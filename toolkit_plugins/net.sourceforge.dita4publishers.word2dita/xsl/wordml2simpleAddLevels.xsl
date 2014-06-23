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
       
       The result of this processing is a document with the map and topic 
       hierarchy reflected but grouping by container type not reflected. The next
       processing step is to group things by container type where appropriate
       (e.g., within the map structure and within topic body contents).
    -->
  
  <xsl:template mode="simpleWp-addLevels" match="/">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- Construct the map, topicref, and topic hierarchy, but without container types. -->
    <xsl:variable name="structureNoContainerTypes" as="node()*">
      <xsl:apply-templates select="*" mode="#current">
         <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$debugBoolean"/>
      </xsl:apply-templates>    
    </xsl:variable>
    <xsl:if
      test="$doSaveIntermediateDocs">
      <xsl:variable
        name="tempDocFixup"
        select="relpath:newFile($outputDir, 'simpleWpWithLevelsNoContainerTypes.xml')"
        as="xs:string"/>
      <xsl:result-document format="indented"
        href="{$tempDocFixup}">
        <xsl:message> + [DEBUG] Simple WP doc with levels added saved as <xsl:sequence
            select="$tempDocFixup"/></xsl:message>
        <xsl:sequence
          select="$structureNoContainerTypes"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:sequence select="$structureNoContainerTypes"/>
<!--    <xsl:apply-templates select="$structureNoContainerTypes" mode="handleContainerTypes">-->
       <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="true()"/>
    <!--</xsl:apply-templates>-->
  
  </xsl:template>
  
  <xsl:template mode="simpleWp-addLevels" match="/*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*,*" mode="#current">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWp-addLevels" match="rsiwp:body">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- Within the <body> element there must be at least one
         paragraph that is either the level 0 topic or map
      -->
<!--    <xsl:variable name="doDebug" as="xs:boolean" select="true()"/>-->
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] simpleWp-addLevels: rsiwp:body</xsl:message>
    </xsl:if>
    
    <!-- First <p> in doc should be title for the root topic. If it's not, bail -->  
    <xsl:variable name="firstP" select="rsiwp:body/(rsiwp:p|rsiwp:table)[1]" as="element()?"/>
    <xsl:if test="$doDebug">        
      <xsl:message> + [DEBUG] rsiwp:document: firstP=<xsl:sequence select="$firstP"/></xsl:message>
    </xsl:if>
    <xsl:if test="$firstP and 
                  not(local:isRootTopicTitle($firstP)) and 
                  not(local:isMap($firstP) or local:isMapTitle($firstP))">
      <xsl:message terminate="yes"> - [ERROR] The first paragraph in the Word document must be mapped to the root map or topic title.
        First para is style <xsl:sequence select="string($firstP/@style)"/>, mapped as <xsl:sequence 
          select="
          (key('styleMapsByName', lower-case(string($firstP/@style)), $styleMapDoc)[1],
          key('styleMapsById', string($firstP/@style), $styleMapDoc)[1])[1]"/> 
      </xsl:message>
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
    
    <xsl:variable name="doDebug" as="xs:boolean" select="true()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] groupMapsAndTopicsByLevel: level=<xsl:value-of select="$level"/>, content[1]=<xsl:value-of select="local:reportPara($content[1])"/></xsl:message>
    </xsl:if>
    <xsl:for-each-group select="$content" 
      group-starting-with="
         *[local:isMapOrTopicStructure(.)  and
            string(@level) = string($level)]">
      <!-- This system of match templates handles the first paragraph of the group
           to see if it generates a map, a map title (if it generates a map), a 
           topicref, and finally a topic.
           
           This will result in the pargraphs grouped to reflect the map and
           topic hierarchy. This set of grouped paragraphs is then the input
           to the final simple-to-DITA transform.
        -->
      <xsl:choose>
        <xsl:when test=".[not(local:isMapOrTopicStructure(.))]">
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
            <xsl:with-param name="level" as="xs:integer" tunnel="yes" select="$level"/>
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
    match="*[@generatesMap = 'true']"    
    >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="rest" as="element()*" tunnel="yes"/>
    <xsl:param name="level" as="xs:integer" tunnel="yes" select="0"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-map: map or mapTitle: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>

    <xsl:variable name="outputElem" as="element()?"
      select="key('formats', string(stylemap:mapProperties/@format)[1], $styleMapDoc)"
    />
    
    <xsl:if test="not($outputElem)">
      <xsl:message> - [ERROR] No &lt;output&gt; element for format "<xsl:value-of select="stylemap:mapProperties/@format"/>"</xsl:message>
    </xsl:if>

    <xsl:variable name="map" as="element()">
      <rsiwp:map>
        <xsl:for-each select="$outputElem">
          <xsl:sequence select="@mapType, @prologType"/>  
        </xsl:for-each>        
        <xsl:sequence select="stylemap:mapProperties/@*"/>
        
        <xsl:apply-templates mode="addLevels-mapTitle" select=".">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          <xsl:with-param name="tagName" as="xs:string?" select="stylemap:mapProperties/@tagName"/>
        </xsl:apply-templates>
        <xsl:apply-templates mode="addLevels-topicref" select=". except(stylemap:mapProperties)">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          <xsl:with-param name="level" as="xs:integer" select="@level"/>
        </xsl:apply-templates>
      </rsiwp:map>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$level > 0">
        <rsiwp:mapref>
          <xsl:sequence select="@styleName, @styleId"/>
          <xsl:for-each select="stylemap:MapProperties">
            <xsl:sequence select="@maprefType"/>
          </xsl:for-each>          
          <xsl:sequence select="$map"/>
        </rsiwp:mapref>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$map"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="addLevels-mapTitle" 
    match="*[@structureType = ('mapTitle') or @secondStructureType = ('mapTitle')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="tagName" as="xs:string?" />
    <rsiwp:maptitle>
      <xsl:attribute name="tagName" select="if ($tagName) then $tagName else 'title'"/>
      <xsl:sequence select="@containerType"/>
      <xsl:sequence select="local:getContainerTypeSiblings(.)"/>
    </rsiwp:maptitle>
  </xsl:template>
  
  <xsl:template mode="addLevels-mapTitle" match="*" priority="-1"/>
  
  <xsl:template mode="addLevels-topicref" 
    match="*[@structureType = ('topicHead', 'topicGroup') ]" priority="10">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="rest" as="element()*" tunnel="yes"/>
      
    <xsl:variable name="level" as="xs:integer" select="@level"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: topicHead/Group: level="<xsl:value-of select="$level"/>"</xsl:message>
    </xsl:if>
    
    <xsl:variable name="content" as="element()*"
      select="$rest"
    />
    <xsl:if test="false() and $doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: topicHead/Group: content="<xsl:value-of select="local:reportParas($content)"/><xsl:value-of select="$level"/>"</xsl:message>
    </xsl:if>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:element name="rsiwp:{@structureType}">
      <xsl:sequence select="@*, stylemap:topicrefProperties/@*"/>
      <xsl:apply-templates select="." mode="addLevels-navtitle">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="tagName" as="xs:string?" select="stylemap:topicrefProperties/@tagName"/>
      </xsl:apply-templates>
      <xsl:call-template name="groupMapsAndTopicsByLevel">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="content" as="element()*" select="$content"/>
        <xsl:with-param name="level" select="$level + 1" as="xs:integer"/>
      </xsl:call-template>
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
    <xsl:param name="tagName" as="xs:string?"/>
    <rsiwp:navtitle>
      <xsl:attribute name="tagName" select="if ($tagName) then $tagName else 'navtitle'"/>
      <xsl:sequence select="local:getContainerTypeSiblings(.)"/>
    </rsiwp:navtitle>
  </xsl:template>
  
  <xsl:template mode="addLevels-topicref" 
         match="*[@generatesTopicref = 'true']">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="level" as="xs:integer" tunnel="yes"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: Will make topic doc, generating topicref.</xsl:message>
    </xsl:if>
    <xsl:element name="rsiwp:topicref">
      <xsl:sequence select="@styleId, 
        stylemap:topicrefProperties/@*
        "
      />
      <xsl:apply-templates select="." mode="addLevels-navtitle"/>
      <xsl:apply-templates mode="addLevels-topic" select=". except (stylemap:topicrefProperties)">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="level" as="xs:integer" tunnel="yes" select="@level"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="addLevels-topic" priority="10"
    match="*[@generatesTopic = 'true']">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] addLevels-topicref: <xsl:value-of select="local:reportPara(.)"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="topicOutputElem" as="element()?"
      select="key('formats', string(stylemap:topicProperties/@format)[1], $styleMapDoc)"
    />

    <rsiwp:topic>
      <!-- Attributes on the topicProperties element take
           precedence over attributes on referenced 
           output element, if any.
        -->
      <!-- Properties from the paragraph element: -->
      <xsl:sequence select="
          @styleName, 
          @styleId"
      />
      <xsl:for-each select="$topicOutputElem">
        <xsl:sequence 
          select="
          @topicType, 
          @topicrefType, 
          @bodyType, 
          @prologType
          "
        />
      </xsl:for-each>
      <xsl:sequence 
        select="stylemap:topicProperties/@*"
      />
      <xsl:apply-templates mode="addLevels-handleChildren" select=". except (stylemap:topicProperties)">
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
  
  <!-- ========================================
       Mode handleContainerTypes
       ======================================== -->
  
  <xsl:template mode="handleContainerTypes" 
    match="rsiwp:map | 
           rsiwp:topicref | 
           rsiwp:topicHead | 
           rsiwp:topicGroup
           ">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] handleContainerTypes: <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>
    </xsl:if>
    
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:for-each-group select="*" group-adjacent="concat('x', @containerType)">
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] handleContainerTypes:   Group <xsl:value-of select="position()"/></xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="current-grouping-key() != 'x'">
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] handleContainerTypes:   containerType="<xsl:value-of select="@containerType"/>"</xsl:message>
            </xsl:if>
            <rsiwp:topicref topicrefType="{@containerType}"
              >
              <xsl:if test="@containerTypeOutputclass">
                <xsl:attribute name="outputclass" select="@containerTypeOutputclass"/>
              </xsl:if>
              <xsl:apply-templates mode="#current" select="current-group()">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
              </xsl:apply-templates>
            </rsiwp:topicref>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] handleContainerTypes:   No container type in group</xsl:message>
            </xsl:if>
            <xsl:apply-templates mode="#current" select="current-group()">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="handleContainerTypes" match="*" priority="-0.5">
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="handleContainerTypes" match="text() | processing-instruction() | comment()" priority="0">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:function name="local:isMapOrTopicStructure">
    <xsl:param name="p"/>
    <xsl:variable name="result" 
      select="(string($p/@structureType) = 
            ('topicTitle', 
             'map', 
             'mapTitle',
             'topicHead',
             'topicGroup') or
            $p/@generatesMap = 'true' or
            $p/@generatesTopicref = 'true' or
            $p/@generatesTopic = 'true'
            )"/>
    <xsl:sequence select="$result"/>
  </xsl:function>
    
</xsl:stylesheet>