<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mv="urn:schemas-microsoft-com:mac:vml"
      xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
      xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
      xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
      xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:w10="urn:schemas-microsoft-com:office:word"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
      xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
      xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
      xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
      xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
      
      xmlns:local="urn:local-functions"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a pic xs mv mo ve o r m v w10 w wne wp local relpath saxon"
      version="2.0">
  <!-- Level fixup mode. -->
  
    <!--==================================
      simpleWpDocLevel-fixup
      
      Implements application of the relative
      levels.
      
      Uses recursion to calculate relative
      levels, meaning that each paragraph
      determines its level and then applies
      templatest to its following sibling, 
      passing in the current level and level
      group.
      
      ================================== -->
  
  <xsl:template mode="simpleWpDoc-levelFixupRoot" match="rsiwp:document">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] simpleWpDoc-levelFixupRoot: handling rsiwp:document...</xsl:message>
    </xsl:if>
    <!-- Apply template to the first child of the <body> element: -->
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:element name="{name(*[1])}">
        <xsl:apply-templates mode="simpleWpDoc-levelFixup"
          select="(rsiwp:*[1]/*)[1]"
        >
          <xsl:with-param name="currentLevel" as="xs:integer" select="0"/>
          <xsl:with-param name="currentLevelGroup" as="xs:string" select="generate-id(.)"/>
          <xsl:with-param name="currentTopicLevel" as="xs:integer" select="0"/>
          <xsl:with-param name="currentTopicLevelGroup" as="xs:string" select="generate-id(.)"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-levelFixup" match="*" >
    <xsl:param name="currentLevel" as="xs:integer"/>
    <xsl:param name="currentTopicLevel" as="xs:integer"/>
    <xsl:param name="currentLevelGroup" as="xs:string"/>
    <xsl:param name="currentTopicLevelGroup" as="xs:string"/>
    
    <xsl:if test="$debugBoolean">    
      <xsl:message> + [DEBUG] simpleWpDoc-levelFixup:  <xsl:value-of select="@style"/></xsl:message>
      <xsl:message> + [DEBUG]    currentLevel:      <xsl:sequence select="$currentLevel"/></xsl:message>
      <xsl:message> + [DEBUG]    currentTopicLevel: <xsl:sequence select="$currentTopicLevel"/></xsl:message>
      <xsl:message> + [DEBUG]    currentLevelGroup: <xsl:sequence select="$currentLevelGroup"/></xsl:message>
      <xsl:message> + [DEBUG]    currentTopicLevelGroup: <xsl:sequence
        select="$currentTopicLevelGroup"/></xsl:message>
    </xsl:if>    
    <!-- Topics leveled relative to other topics, while
         non-topic elements are leveled relative to each
         other.
      -->
    <xsl:variable name="isTopic" as="xs:boolean"
          select="@structureType = 'topicTitle'"
        />

    <xsl:variable name="myLevelValue" as="xs:string"
      select="string(@level)"
    />
    <xsl:if test="$debugBoolean">    
      <xsl:message> + [DEBUG]    myLevelValue: <xsl:sequence select="$myLevelValue"/></xsl:message>
    </xsl:if>
    <!-- The use of generate-id(.) here ensures that unspecified
         @levelGroup results in a non-match with any following
         element's level group.
      -->
    <xsl:variable name="myLevelGroup" as="xs:string"
      select="if (@levelGroup) 
        then string(@levelGroup) 
        else generate-id(.)"
    />
    <!-- If we are a topic and we don't specify a @levelGroup
         attribute then generate a unique level group value -->
    <xsl:variable name="myTopicLevelGroup" as="xs:string"
      select="
      if ($isTopic)
         then if (@levelGroup) 
                 then @levelGroup 
                 else generate-id(.)
         else $currentTopicLevelGroup
       "
    />
    <xsl:if test="$debugBoolean">    
      <xsl:message> + [DEBUG]    myTopicLevelGroup: <xsl:sequence select="$myTopicLevelGroup"/></xsl:message>
    </xsl:if>
    
    
    <xsl:choose>
      <xsl:when test="$myLevelValue = ''">
        <!-- If level is unspecified, nothing to do, let it default -->
        <xsl:sequence select="."/>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
          <xsl:with-param name="currentLevel" as="xs:integer" 
            select="$currentLevel"
          />
          <xsl:with-param name="currentTopicLevel" as="xs:integer" select="$currentTopicLevel"/>
          <xsl:with-param name="currentLevelGroup" as="xs:string" select="$myLevelGroup"/>
          <xsl:with-param name="currentTopicLevelGroup" as="xs:string" 
            select="$myTopicLevelGroup"
          />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="string(number($myLevelValue)) != 'NaN'">
        <!-- Level is an explicit number, no change to the paragraph -->
        <xsl:if test="$debugBoolean">    
          <xsl:message> + [DEBUG]    myLevelValue is a number, leaving as-is</xsl:message>
        </xsl:if>
        <xsl:variable name="myLevel" as="xs:integer"
          select="xs:integer($myLevelValue)"
        />
        <xsl:variable name="myTopicLevel" as="xs:integer"
          select="
          if ($isTopic) 
             then $myLevel
             else $currentTopicLevel
             "
        />
        <xsl:if test="$debugBoolean">    
          <xsl:message> + [DEBUG]    Is a topic</xsl:message>
        </xsl:if>
        <!-- Level is explicit, no change to this element -->
        <xsl:sequence select="."/>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
          <xsl:with-param name="currentLevel" as="xs:integer" select="$myLevel"/>
          <xsl:with-param name="currentTopicLevel" as="xs:integer" select="$myTopicLevel"/>
          <xsl:with-param name="currentLevelGroup" as="xs:string" select="$myLevelGroup"/>
          <xsl:with-param name="currentTopicLevelGroup" as="xs:string" 
            select="$myTopicLevelGroup"
          />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG]    myLevelValue is not a number, setting relative</xsl:message>
        </xsl:if>
        <!-- Relative level, figure out the effective level -->
        <xsl:variable name="baseLevel" as="xs:integer"
          select="
          if ($isTopic) 
             then $currentTopicLevel 
             else $currentLevel"
        />
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG]    $baseLevel:  <xsl:sequence select="$baseLevel"/></xsl:message>
        </xsl:if>
        <xsl:variable name="myLevel" as="xs:integer"
        >
          <xsl:choose>
            <xsl:when test="
              ($isTopic and $myLevelGroup = $currentTopicLevelGroup) or 
              (not($isTopic) and $myLevelGroup = $currentLevelGroup)">
              <xsl:message></xsl:message>
              <!-- No change, first item in level group will set the level value and we just follow. -->
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG]    myLevelGroup = current topic or body level group, using $baseLevel value</xsl:message>
        </xsl:if>
              <xsl:sequence select="$baseLevel"/>
            </xsl:when>
            <xsl:when test="$myLevelValue = 'currentLevel'">
              <xsl:sequence select="$baseLevel"/>
            </xsl:when>
            <xsl:when test="$myLevelValue = 'plusOne'">
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG]    myLevelGroup != current topic or body level group, using $baseLevel + 1</xsl:message>
        </xsl:if>
              <xsl:sequence select="$baseLevel + 1"/>
            </xsl:when>
            <xsl:when test="$myLevelValue = 'minusOne'">
              <xsl:sequence 
                select="
                if ($baseLevel > 0) 
                   then $baseLevel - 1 
                   else 0"
              />
            </xsl:when>
            <xsl:otherwise>
              <xsl:message> - [ERROR] Style "<xsl:sequence select="string((@style, @styleId)[1])"/>": Unexpected value "<xsl:sequence select="$myLevelValue"/>" for @level attribute. Using current level</xsl:message>
              <xsl:sequence select="$baseLevel"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG]    myLevel: <xsl:sequence select="$myLevel"/></xsl:message>
        </xsl:if>
        <!-- Now output the original element with the @level attribute reset -->
        <xsl:copy>
          <xsl:sequence select="@* except (@level)"/>
          <xsl:attribute name="level" select="$myLevel"/>
          <xsl:sequence select="node()"/>
        </xsl:copy>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
          <xsl:with-param name="currentLevel" as="xs:integer" select="$myLevel"/>
          <xsl:with-param name="currentTopicLevel" as="xs:integer" 
            select="
            if ($isTopic) 
               then $myLevel
               else $currentTopicLevel"
          />
          <xsl:with-param name="currentLevelGroup" as="xs:string" select="$myLevelGroup"/>
          <xsl:with-param name="currentTopicLevelGroup" as="xs:string" 
            select="$myTopicLevelGroup"
          />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>