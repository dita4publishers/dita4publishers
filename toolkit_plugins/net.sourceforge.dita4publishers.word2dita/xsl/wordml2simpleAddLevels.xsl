<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mv="urn:schemas-microsoft-com:mac:vml"
      xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
      xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
      xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
      xmlns:v="urn:schemas-microsoft-csimpleWp-addLevelsom:vml"
      xmlns:w10="urn:schemas-microsoft-com:office:word"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
      xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
      xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
      xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
      xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
      xmlns:mathml="http://www.w3.org/1998/Math/MathML"
      
      xmlns:local="urn:local-functions"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a pic xs mv mo ve o r m v w10 w wne wp local relpath saxon"
  version="2.0">
  <!-- This processes the flat paragraph structure into levels that reflect
       the map and topic structure.
       
       One challenge is that there are two independent level hierarchies: the levels
       of map and topic elements (the navigation hierarchy of topics) and the 
       levels within topic bodies so it's not as simple as just grouping by level
       value. Also, not all paragraphs have an explicit level.
       
       The result of this processing is a a document with the map and topic 
       hierarchy reflected but grouping by container type not reflected. The next
       processing step is to group things by container type where appropriate
       (e.g., within the map structure and within topic body contents).
    -->
  
  <xsl:template mode="simpleWp-addLevels" match="/">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates select="*" mode="#current"/>    
  </xsl:template>
  
  <xsl:template mode="simpleWp-addLevels" match="/*">
    <xsl:copy>
      <xsl:apply-templates select="@*,*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWp-addLevels" match="rsiwp:body">
    <!-- Within the <body> element there must be at least one
         paragraph that is either the level 0 topic or map
      -->
    
    <xsl:variable name="doDebug" as="xs:boolean" select="true()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] simpleWp-addLevels: rsiwp:body</xsl:message>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:call-template name="groupMapsAndTopicsByLevel">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="content" select="*" as="element()*"/>
        <xsl:with-param name="level" as="xs:integer" select="0"/>
      </xsl:call-template>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template name="groupMapsAndTopicsByLevel">
    <!-- For a given level, groups all the map-structure-creating
         paragraphs together. It then applies templates to each
         group such that the initial paragraph generates the appropriate
         structures (map, topicref, topic) and the remaining paragraphs
         of the group are then recursively processed.
         
         The end result is a document with the map and topic structure
         explicit but the original paragraphs otherwise unmodified.
         
      -->
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="content" as="element()*"/>
    <xsl:param name="level" as="xs:integer" select="0"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] groupMapsAndTopicsByLevel: level=<xsl:value-of select="$level"/>, content[1]=<xsl:value-of select="local:reportPara($content[1])"/></xsl:message>
    </xsl:if>
    <xsl:for-each-group select="$content" 
      group-starting-with="
         *[(string(@structureType) = 
            ('topicTitle', 
             'map', 
             'mapTitle',
             'topicHead',
             'topicGroup'))  and
            string(@level) = string($level)]">
      <!-- This system of match templates handles the first paragraph of the group
           to see if it generates a map, a map title (if it generates a map), a 
           topicref, and finally a topic.
           
           This will result in the pargraphs grouped to reflect the map and
           topic hierarchy. This is set of grouped paragraphs is then the input
           to the final simple-to-DITA transform.
        -->
      <xsl:choose>
        <xsl:when test=".[not(string(@structureType) = 
            ('topicTitle', 
             'map', 
             'mapTitle',
             'topicHead',
             'topicGroup'))]">
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] groupMapsAndTopicsByLevel: Group is not a map structure, emitting it.</xsl:message>
          </xsl:if>
          <!-- First group may be non-leveled, non-map-creating paragraphs, such as metadata -->
          <xsl:sequence select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] groupMapsAndTopicsByLevel: Group is a map structure, applying addLevels-map...</xsl:message>
          </xsl:if>
          <xsl:apply-templates select="current-group()[1]" mode="addLevels-map">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="rest" as="element()*" tunnel="yes" select="current-group()[position() > 1]"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template mode="addLevels-map addLevels-mapTitle addLevels-topicref" match="text()"/>
  
  <xsl:template mode="addLevels-map" match="*" priority="-1">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>

    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-map: catch-all: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>

    <xsl:apply-templates mode="addLevels-topicref" select=".">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="addLevels-map" 
    match="*[@structureType = ('map', 'mapTitle') or @secondStructureType = ('map', 'mapTitle')]"    
    >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="rest" as="element()*" tunnel="yes"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-map: map or mapTitle: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>

    <rsiwp:map>
      <xsl:sequence select="@mapType, @mapFormat, @prologType"/>
      <xsl:apply-templates mode="addLevels-mapTitle" select=".">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="addLevels-topicref" select=".">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="level" as="xs:integer" select="@level"/>
      </xsl:apply-templates>
    </rsiwp:map>
  </xsl:template>
  
  <xsl:template mode="addLevels-mapTitle" 
    match="*[@structureType = ('mapTitle') or @secondStructureType = ('mapTitle')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <rsiwp:maptitle>
      <xsl:sequence select="local:getContainerTypeSiblings(.)"/>
    </rsiwp:maptitle>
  </xsl:template>
  
  <xsl:template mode="addLevels-mapTitle" match="*" priority="-1"/>
  
  <xsl:template mode="addLevels-topicref" 
    match="*[@structureType = 'topicGroup' or @structureType = 'topicHead']">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:element name="rsiwp:{@structureType}">
      <xsl:sequence select="@*"/>
      <xsl:apply-templates select="." mode="addLevels-navtitle"/>
      <!-- FIXME: Do something with the rest of the group. -->
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="addLevels-topicref" match="*" priority="-1">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: catch-all: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="addLevels-topic" select=".">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="addLevels-navtitle" match="*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <rsiwp:navtitle>
      <xsl:sequence select="local:getContainerTypeSiblings(.)"/>
    </rsiwp:navtitle>
  </xsl:template>
  
  <xsl:template mode="addLevels-topicref" 
         match="*[@structureType = 'topicTitle' or @secondStructureType = 'topicTitle']">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:element name="rsiwp:topicref">
      <xsl:sequence select="@topicrefType"/>
      <xsl:apply-templates select="." mode="addLevels-navtitle"/>
      <xsl:apply-templates mode="addLevels-topic" select=".">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="level" as="xs:integer" tunnel="yes" select="@level"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="addLevels-topic" priority="10"
    match="*[@structureType = 'topicTitle' or @structureType = 'topicTitle']">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>

    <rsiwp:topic>
      <xsl:sequence select="@topicType, @format, @bodyType, @prologType"/>
      <xsl:apply-templates mode="addLevels-handleChildren" select=".">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="level" as="xs:integer" tunnel="yes" select="@level"/>
      </xsl:apply-templates>
    </rsiwp:topic>
  </xsl:template>
  
  <xsl:template mode="addLevels-topic" match="*" priority="-1">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topic: Catch-all: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="addLevels-handleChildren" select=".">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      <xsl:with-param name="level" as="xs:integer" tunnel="yes" select="@level"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="addLevels-handleChildren" match="*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="rest" as="element()*" tunnel="yes"/>
    <xsl:param name="level" as="xs:integer" tunnel="yes"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-handleChildren: <xsl:value-of select="local:reportPara(.)"/>, level="<xsl:value-of select="$level"/>"</xsl:message>
    </xsl:if>

    <!-- Emit the current paragraph then apply the grouping process to the rest. -->
    <xsl:sequence select="."/>
    
    <xsl:call-template name="groupMapsAndTopicsByLevel">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      <xsl:with-param name="content" select="$rest" as="element()*"/>
      <xsl:with-param name="level" as="xs:integer" select="$level + 1"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="simpleWp-addLevels" match="@*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:sequence select="."/>
  </xsl:template>
  
</xsl:stylesheet>