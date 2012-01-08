<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      
      exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
      version="2.0">

  <!--==========================================
    Simple Word Processing Markup to DITA generic transformation
    
    Copyright (c) 2009, 2011 DITA For Publishers, Inc.

    Transforms a simple word processing document into a DITA topic using
    a style-to-tag mapping.
    
    This transform is intended to be the base for more specialized
    transforms that provide style-specific overrides.
    
    The input to this transform is a simple ML document created
    by transforming some proprietary word processing or DTP
    format, such as DOCX or IDML.
    
    This transform is intended to be used from a format-specific shell
    that generates the simple ML instance and then applies
    this transform. The shell should supply the root template.
       
    Originally developed by Really Strategies, Inc.
    
    =========================================== -->

<!-- 
  The root importer of this module must also import the following module:
  
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
 -->  
  
  
  <xsl:template match="rsiwp:document">
    <xsl:message> + [INFO] simple2dita: Processing intermediate simpleML XML to generate DITA XML...</xsl:message>
    <!-- First <p> in doc should be title for the root topic. If it's not, bail -->  
    <xsl:variable name="firstP" select="rsiwp:body/(rsiwp:p|rsiwp:table)[1]" as="element()?"/>
    <xsl:if test="$debugBoolean">        
      <xsl:message> + [DEBUG] rsiwp:document: firstP=<xsl:sequence select="$firstP"/></xsl:message>
    </xsl:if>
    <xsl:if test="$firstP and not(local:isRootTopicTitle($firstP)) and not(local:isMap($firstP))">
      <xsl:message terminate="yes"> - [ERROR] The first block in the Word document must be mapped to the root map or topic title.
        First para is style <xsl:sequence select="string($firstP/@style)"/>, mapped as <xsl:sequence 
          select="
          (key('styleMapsByName', lower-case(string($firstP/@style)), $styleMapDoc)[1],
          key('styleMapsById', string($firstP/@style), $styleMapDoc)[1])[1]"/> 
      </xsl:message>
    </xsl:if>
    <xsl:message> + [INFO] Determining result documents...</xsl:message>
    <xsl:variable name="resultDocs" as="element()*">
      <xsl:choose>
        <xsl:when test="local:isRootTopicTitle($firstP)">
          <xsl:if test="$debugBoolean or true()">        
            <xsl:message> + [DEBUG] rsiwp:document: firstP is root topic title, calling makeTopic...</xsl:message>
          </xsl:if>
          <xsl:call-template name="makeTopic">
            <xsl:with-param name="content" select="rsiwp:body/(rsiwp:p|rsiwp:table)" as="node()*"/>
            <xsl:with-param name="level" select="0" as="xs:integer"/>
            <xsl:with-param name="treePos" select="(0)" as="xs:integer+" tunnel="yes"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="local:isMap($firstP)">
          <xsl:if test="$debugBoolean">        
            <xsl:message> + [DEBUG] rsiwp:document: firstP is root map, calling makeMap...</xsl:message>
          </xsl:if>
          <xsl:call-template name="makeMap">
            <xsl:with-param name="content" select="rsiwp:body/(rsiwp:p | rsiwp:table)" as="node()*"/>
            <xsl:with-param name="level" select="0" as="xs:integer"/>
            <xsl:with-param name="newMapUrl" select="$rootMapUrl" as="xs:string"/>
            <xsl:with-param name="topicrefType" select="'mapref'"/><!-- shouldn't be necessary, but it is -->
            <xsl:with-param name="mapUrl" select="relpath:newFile($outputDir, 'garbage.ditamap')" tunnel="yes" as="xs:string"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$debugBoolean or true()">        
            <xsl:message> + [DEBUG] rsiwp:document: firstP is neither root topic nor root map</xsl:message>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="false() or $debugBoolean">
      <xsl:variable
        name="tempDoc"
        select="relpath:newFile($outputDir, 'resultDocs.xml')"
        as="xs:string"/>
      <xsl:message> + [DEBUG] saveing $resultDocs to 
<xsl:sequence select="$tempDoc"/>        
      </xsl:message>
      <xsl:result-document href="{$tempDoc}">
        <xsl:sequence select="$resultDocs"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:message> + [INFO] Writing result documents...</xsl:message>
    <xsl:apply-templates select="$resultDocs" mode="generate-result-docs"/>
    <xsl:message> + [INFO] simple2dita: Done processing simpleML document.</xsl:message>
    
  </xsl:template>
  
  <xsl:template mode="generate-result-docs" match="rsiwp:result-document" priority="10">
    <xsl:message> + [INFO] Generating result document "<xsl:sequence select="string(@href)"/>..."</xsl:message>
    <xsl:result-document href="{@href}" 
      doctype-public="{@doctype-public}"
      doctype-system="{@doctype-system}">
      <xsl:apply-templates select="./*" mode="generate-result-docs"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template mode="generate-result-docs" match="*" priority="5">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="generate-result-docs" match="@*|node()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="rsiwp:p[string(@structureType) = 'skip']" priority="10"/>
  
  <xsl:template match="rsiwp:p" name="transformPara">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] rsiwp:p (transformPara): text=<xsl:sequence select="substring(., 1, 40)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="tagName" as="xs:string"
      select="
      if (@tagName) 
      then string(@tagName)
      else 'p'
      "
    />
    <xsl:if test="not(./@tagName)">
      <xsl:message> + [WARNING] No style to tag mapping for paragraph style "<xsl:sequence select="string(@style)"/>"</xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(./*) = 0 and normalize-space(.) = ''">
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] Skipping apparently-empty paragraph: <xsl:sequence select="local:reportPara(.)"/></xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="idGenerator" as="xs:string">
          <xsl:choose>
            <xsl:when test="string(@idGenerator) = ''">
              <xsl:sequence select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="string(@idGenerator)"/>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:variable>
        <xsl:element name="{$tagName}">  
          <xsl:if test="$includeWordBackPointersBoolean">
            <xsl:attribute name="xtrc" select="@wordLocation"/>
            <xsl:attribute name="xtrf" select="ancestor::rsiwp:document[1]/@sourceDoc"/>
          </xsl:if>
          <xsl:sequence select="./@outputclass"/>
          <xsl:if test="./@dataName">
            <xsl:attribute name="name" select="./@dataName"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="generate-id">
            <xsl:with-param name="idGenerator" select="$idGenerator" as="xs:string"/>
            <xsl:with-param name="tagName" select="$tagName" as="xs:string"/>
          </xsl:apply-templates>
          <xsl:call-template name="transformParaContent"/>    
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template mode="generate-id" match="*">
    <xsl:param name="idGenerator" select="''"/>
    <xsl:choose>
      <xsl:when test="$idGenerator = ''">
        <!-- Don't generate an ID -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id" select="generate-id(.)"/>
        <!-- This will be removed during ID fixup pass -->
        <xsl:attribute name="idGenerator" select="$idGenerator"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="transformParaContent">
    <xsl:variable name="isTitlePara" as="xs:boolean"
      select="local:isTopicTitle(.)"
    />
    <!-- Transforms the content of a paragraph, where the containing
         element is generated by the caller. -->
    <xsl:choose>
      <xsl:when test="string(@useContent) = 'elementsOnly'">
        <xsl:apply-templates mode="p-content" select="*">
          <xsl:with-param name="inTitleContext" as="xs:boolean" tunnel="yes"
            select="$isTitlePara"
          />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="string(@putValueIn) = 'valueAtt'">
        <xsl:attribute name="value" select="string(.)"/>
        <xsl:if test="@dataName">
          <xsl:attribute name="name" select="string(@dataName)"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="p-content">
          <xsl:with-param name="inTitleContext" as="xs:boolean" tunnel="yes"
            select="$isTitlePara"
          />          
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="rsiwp:table">
<!--    <xsl:message> + [DEBUG] rsiwp:table: Starting...</xsl:message>-->
    <xsl:variable name="tagName" as="xs:string"
      select="
      if (@tagName) 
      then string(@tagName)
      else 'table'
      "
    />
    <xsl:element name="{$tagName}">  
      <xsl:attribute name="xtrc" select="@wordLocation"/>
      <tgroup cols="{count(rsiwp:cols/rsiwp:col)}">
        <xsl:apply-templates select="rsiwp:cols"/>
        <xsl:if test="rsiwp:th">
          <thead>
            <xsl:apply-templates select="rsiwp:th"/>          
          </thead>
        </xsl:if>
        <tbody>
          <xsl:choose>
            <xsl:when test="rsiwp:tr">
              <xsl:apply-templates select="rsiwp:tr"/>
            </xsl:when>
            <xsl:otherwise>
              <row>
                <entry>Generated row for table with only header rows. DITA requires a body which requires a row.</entry>
              </row>
            </xsl:otherwise>
          </xsl:choose>
          
        </tbody>    
      </tgroup>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="rsiwp:cols">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="rsiwp:col">
    <colspec colname="{position()}" 
      colwidth="{concat(@width, '*')}"/>
  </xsl:template>
  
  <xsl:template match="rsiwp:tr | rsiwp:th">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  
  <xsl:template match="rsiwp:td">
    <entry>
      <xsl:call-template name="handleBodyParas">
        <xsl:with-param name="bodyParas" select="*"/>
      </xsl:call-template>
    </entry>
  </xsl:template>
  
  
  <xsl:template match="rsiwp:run" mode="p-content">
    <xsl:variable name="tagName" as="xs:string"
      select="
      if (@tagName) 
      then string(@tagName)
      else 'ph'
      "
    />
    <xsl:if test="not(./@tagName)">
      <xsl:message> + [WARNING] No style to tag mapping for character style "<xsl:sequence select="string(@style)"/>"</xsl:message>
    </xsl:if>
    <xsl:element name="{$tagName}">
      <xsl:attribute name="xtrc" select="@wordLocation"/>
      <xsl:if test="@outputclass">
        <xsl:attribute name="outputclass" select="string(@outputclass)"/>
      </xsl:if>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="text()" mode="p-content">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template name="makeMap">
    <xsl:param name="content" as="element()+"/>
    <xsl:param name="level"  as="xs:integer"/><!-- Level of this topic -->
    <xsl:param name="treePos" as="xs:integer*" tunnel="yes"/><!-- Sequence of integers representing tree position of parent. --> 
    <xsl:param name="topicrefType" select="$content[1]/@topicrefType" as="xs:string"/>
    <xsl:param name="mapUrl" as="xs:string" tunnel="yes"/>
    
    <xsl:param name="newMapUrl" as="xs:string" 
      select="local:getResultUrlForMap($content[1], $topicrefType, $treePos, $mapUrl)"/>

    <xsl:variable name="firstP" select="$content[1]"/>
    
    <xsl:if test="false() or $debugBoolean">
      <xsl:message> + [DEBUG] makeMap: firstP=<xsl:value-of select="$firstP"/></xsl:message>
      <xsl:message> + [DEBUG] makeMap: treePos=<xsl:value-of select="$treePos"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeMap: newMapUrl=<xsl:sequence select="$newMapUrl"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="nextLevel" select="$level + 1" as="xs:integer"/>
    
    <xsl:variable name="formatName" select="$firstP/@format" as="xs:string?"/>
    <xsl:if test="not($formatName)">
      <xsl:message terminate="yes"> + [ERROR] makeMap: No format= attribute for paragraph style <xsl:sequence select="string($firstP/@styleId)"/>, which is mapped to structure type "map".</xsl:message>
    </xsl:if>
    
    <xsl:variable name="format" select="key('formats', $formatName, $styleMapDoc)[1]" as="element()?"/>
    <xsl:if test="not($format)">
      <xsl:message terminate="yes"> + [ERROR] makeMap: Failed to find &lt;output&gt; element for @format value "<xsl:sequence select="$formatName"/>" specified for style "<xsl:sequence select="string($firstP/@styleName)"/>" <xsl:sequence select="concat(' [', string($firstP/@styleId), ']')"/>. Check your style-to-tag mapping.</xsl:message>
    </xsl:if>
    
    <xsl:variable name="schemaAtts" as="attribute()*">
      <xsl:if test="$format/@noNamespaceSchemaLocation">
        <xsl:attribute name="xsi:noNamespaceSchemaLocation"
          select="string($format/@noNamespaceSchemaLocation)"
        />
      </xsl:if>
      <xsl:if test="$format/@schemaLocation != ''">
        <xsl:attribute name="xsi:schemaLocation"
          select="string($format/@schemaLocation)"
        />
      </xsl:if>      
    </xsl:variable>
    
    <xsl:variable name="prologType" as="xs:string"
      select="
      if ($firstP/@prologType and $firstP/@prologType != '')
      then $firstP/@prologType
      else 'topicmeta'
      "
    />
    
    <xsl:variable name="resultUrl" as="xs:string"
      select="relpath:newFile(relpath:getParent($mapUrl), $newMapUrl)"
    />
    
    <xsl:message> + [INFO] makeMap: Creating new map document "<xsl:sequence select="$resultUrl"/>"...</xsl:message>
    
    
    <rsiwp:result-document href="{$resultUrl}"
      doctype-public="{$format/@doctype-public}"
      doctype-system="{$format/@doctype-system}"
      indent="yes"
      >
      <xsl:element name="{$firstP/@mapType}">
        <xsl:sequence select="$schemaAtts"/>
        <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
        <xsl:attribute name="xml:lang" select="$language"/>
        
        <!-- The first paragraph can simply trigger a (possibly) untitled map, or
          it can also be the map title. If it's the map title, generate it.
          First paragraph can also generate a root topicref and/or a topicref
          to a topic in addition to the map.
        -->
        <xsl:if test="local:isMapTitle($firstP)">
          <xsl:apply-templates select="$firstP"/>
        </xsl:if>
        <xsl:if test="$content[string(@topicZone) = 'topicmeta' and string(@containingTopic) = 'root']">
          <xsl:variable name="prologParas" select="$content[string(@topicZone) = 'topicmeta' and string(@containingTopic) = 'root']" as="node()*"/>
          <!-- Now process any map-level topic metadata paragraphs. -->
          <xsl:element name="{$prologType}">
            <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
            <xsl:call-template name="handleTopicProlog">
              <xsl:with-param name="content" select="$prologParas"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:if>
        
        <xsl:if test="false() or $debugBoolean">        
          <xsl:message> + [DEBUG] </xsl:message>
          <xsl:message> + [DEBUG] +++++++++++++</xsl:message>
          <xsl:message> + [DEBUG] </xsl:message>
          <xsl:message> + [DEBUG] makeMap: calling generateTopicrefs...</xsl:message>
        </xsl:if>
        <xsl:call-template name="generateTopicrefs">
          <xsl:with-param name="content" select="$content[position() > 1][(string(@structureType) = 'topicTitle' or 
            string(@structureType) = 'map' or 
            string(@structureType) = 'mapTitle' or
            string(@structureType) = 'topicHead' or
            string(@structureType) = 'topicGroup')]" as="node()*"/>
          <xsl:with-param name="level" select="$nextLevel" as="xs:integer"/>
        </xsl:call-template>
        <xsl:if test="false() or $debugBoolean">        
          <xsl:message> + [DEBUG] </xsl:message>
          <xsl:message> + [DEBUG] +++++++++++++</xsl:message>
          <xsl:message> + [DEBUG] </xsl:message>
          <xsl:message> + [DEBUG] makeMap: Calling generateTopics...
            </xsl:message>
        </xsl:if>
        <xsl:call-template name="generateTopics">
          <xsl:with-param name="content" select="$content[position() > 1]" as="node()*"/>
          <xsl:with-param name="level" select="$nextLevel" as="xs:integer"/>
        </xsl:call-template>        

      </xsl:element>
    </rsiwp:result-document>
    <xsl:if test="false() or $debugBoolean">        
      <xsl:message> + [DEBUG] makeMap: Done.</xsl:message>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="handleTopicProlog">
    <xsl:param name="content" as="node()*"/>
    
    <xsl:call-template name="handleBodyParas">
      <xsl:with-param name="bodyParas" select="$content"/>
    </xsl:call-template>
    
  </xsl:template>
  
  <!-- Generate topicsrefs and topicheads.
  -->
  <xsl:template name="generateTopicrefs">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="treePos" as="xs:integer*" tunnel="yes"/>
    <xsl:param name="mapUrl" as="xs:string" tunnel="yes"/>
    
   <xsl:if test="$debugBoolean">
     <xsl:message> + [DEBUG] generateTopicrefs: Starting, content:
<xsl:sequence select="local:reportParas($content)"/>
     </xsl:message>
   </xsl:if>   
    <xsl:variable name="firstP" select="$content[1]" as="element()"/>
    
    <xsl:variable name="generatedTopicrefs" as="node()*">
      <xsl:for-each-group select="$content"
        group-starting-with="*[(string(@structureType) = 'topicTitle' or 
        string(@structureType) = 'map' or 
        string(@structureType) = 'mapTitle' or
        string(@structureType) = 'topicHead' or
        string(@structureType) = 'topicGroup')  and
        string(@level) = string($level)]"
        >
        <xsl:variable name="groupFirstP" select="current-group()[1]" as="element()"/>

        <xsl:choose>
          <xsl:when test="$groupFirstP/@topicrefType != ''">
            <xsl:variable name="topicName" as="xs:string">
              <xsl:apply-templates mode="topic-name" select="($groupFirstP)">
                <xsl:with-param name="treePos" select="($treePos, position())" as="xs:integer*"/>
              </xsl:apply-templates>
            </xsl:variable>
            
            <xsl:variable name="topicrefType" 
              select="if (string($groupFirstP/@topicrefType) != '')
              then string($groupFirstP/@topicrefType)
              else 'topicref'
              "
              as="xs:string"
            />
            
            <xsl:variable name="topicUrl"
              as="xs:string"
              select="local:getResultUrlForTopic($groupFirstP, 
              $topicrefType, 
              ($treePos, position()), 
              $mapUrl, 
              $topicName)"
            />
            <xsl:element name="{$groupFirstP/@topicrefType}">
              <xsl:attribute name="xtrc" select="$groupFirstP/@wordLocation"/>
              <xsl:call-template name="generateTopicrefAtts">
                <xsl:with-param name="topicUrl" select="$topicUrl"/>
              </xsl:call-template>            
              <xsl:if test="count(current-group()) > 1">
                <xsl:call-template name="generateTopicrefs">
                  <xsl:with-param name="content" select="current-group()[position() > 1]"/>
                  <xsl:with-param name="level" select="$level + 1"/>
                  <xsl:with-param name="treePos" select="($treePos, position())"  tunnel="yes"/>
                </xsl:call-template>    
              </xsl:if>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="count(current-group()) > 1">
              <xsl:call-template name="generateTopicrefs">
                <xsl:with-param name="content" select="current-group()[position() > 1]"/>
                <xsl:with-param name="level" select="$level + 1"/>
                <xsl:with-param name="treePos" select="($treePos, position())" tunnel="yes"/>
              </xsl:call-template>    
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>          
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$firstP[@rootTopicrefType != '']">
        <xsl:element name="{$firstP/@rootTopicrefType}">
          <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
          <xsl:if test="string($firstP/@rootTopicrefType) = 'learningObject'">
            <!-- FIXME: This is a workaround until we implement the ability
              to specify collection-type for the root topicref type.
            -->
            <xsl:attribute name="collection-type" select="'sequence'"/>
          </xsl:if>
          <xsl:sequence select="$generatedTopicrefs"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$generatedTopicrefs"/>
      </xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:template>
  
  <!-- Generate topicsrefs and topicheads.
  -->
  <xsl:template name="generateTopicrefs-orig">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="treePos" as="xs:integer*" tunnel="yes"/>
    <xsl:param name="mapUrl" as="xs:string" tunnel="yes"/>
    <xsl:variable name="firstP" select="$content[1]" as="element()"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] *** generateTopicrefs: treePos=<xsl:sequence select="$treePos"/></xsl:message>
    </xsl:if>

    <xsl:variable name="topicName" as="xs:string">
      <xsl:apply-templates mode="topic-name" select="($firstP)">
        <xsl:with-param name="treePos" select="($treePos, 1)" as="xs:integer*" />
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:variable name="topicrefType" 
      select="if (string(@topicrefType) != '')
      then string(@topicrefType)
      else 'topicref'
      "
      as="xs:string"
    />    
    
    <xsl:variable name="topicUrl"
      as="xs:string"
      select="local:getResultUrlForTopic($firstP, $topicrefType, ($treePos, 1), $mapUrl, $topicName)"
    />
    
    <xsl:choose>
      <xsl:when test="$firstP/@rootTopicrefType != ''">
        <xsl:if test="$debugBoolean">                  
          <xsl:message> + [DEBUG] generateTopicrefs(): First para specifies rootTopicrefType</xsl:message>
        </xsl:if>
        <xsl:element name="{$firstP/@rootTopicrefType}">
          <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
            <xsl:if test="string($firstP/@rootTopicrefType) = 'learningObject'">
            <!-- FIXME: This is a workaround until we implement the ability
              to specify collection-type for the root topicref type.
            -->
            <xsl:attribute name="collection-type" select="'sequence'"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="@topicrefType != ''">
              <xsl:element name="{@topicrefType}">
                <xsl:attribute name="xtrc" select="@wordLocation"/>
                <xsl:call-template name="generateTopicrefAtts">
                  <xsl:with-param name="topicUrl" select="$topicUrl"/>
                </xsl:call-template>            
                <xsl:call-template name="generateSubordinateTopicrefs">
                  <xsl:with-param name="content" select="$content"/>
                  <xsl:with-param name="level" select="$level"/>
                </xsl:call-template>    
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="generateSubordinateTopicrefs">
                <xsl:with-param name="content" select="$content"/>
                <xsl:with-param name="level" select="$level"/>
              </xsl:call-template>    
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:element>
      </xsl:when>
      <xsl:when test="$firstP/@topicrefType">
        <xsl:if test="$debugBoolean">                  
          <xsl:message> + [DEBUG] generateTopicrefs(): First para specifies topicrefType but not rootTopicrefType</xsl:message>
        </xsl:if>
        <xsl:element name="{$firstP/@topicrefType}">
          <xsl:call-template name="generateTopicrefAtts">
            <xsl:with-param name="topicUrl" select="$topicUrl"/>
          </xsl:call-template>            
          <xsl:call-template name="generateSubordinateTopicrefs">
            <xsl:with-param name="content" select="$content" as="node()*"/>
            <xsl:with-param name="level" select="$level + 1"/>
          </xsl:call-template>    
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="generateSubordinateTopicrefs">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="level" select="$level"/>
        </xsl:call-template>    
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] generateTopicrefs: Done.</xsl:message>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="generateSubordinateTopicrefs">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="treePos" as="xs:integer*" tunnel="yes" select="()"/>
    <xsl:param name="mapUrl" as="xs:string" tunnel="yes"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] generateSubordinateTopicrefs: level=<xsl:sequence select="$level"/>.</xsl:message>
    </xsl:if>
    <xsl:for-each-group select="$content[position() > 1]" 
      group-starting-with="*[(string(@structureType) = 'topicTitle' or 
      string(@structureType) = 'map' or 
      string(@structureType) = 'mapTitle' or
      string(@structureType) = 'topicHead' or
      string(@structureType) = 'topicGroup')  and
      string(@level) = string($level)]">
      <xsl:variable name="topicrefType" as="xs:string"
        select="if (@topicrefType) then @topicrefType else 'topicref'"
      />
      <xsl:choose>
        <xsl:when test="string(@structureType) = 'topicTitle' and string(@topicDoc) = 'yes'">
          <xsl:if test="$debugBoolean">        
            <xsl:message> + [DEBUG] generateTopicrefs: Got a doc-creating topic title. Level=<xsl:sequence select="string(@level)"/></xsl:message>
          </xsl:if>
          <xsl:variable name="topicName" as="xs:string">
            <xsl:apply-templates mode="topic-name" select="current-group()[1]">
              <xsl:with-param name="treePos" select="($treePos, position())" as="xs:integer+"/>
            </xsl:apply-templates>
          </xsl:variable>
          
          
          <xsl:variable name="topicUrl"
            as="xs:string"
            select="local:getResultUrlForTopic(current-group()[1], $topicrefType, ($treePos, position()), $mapUrl, $topicName)"
          />
          <xsl:element name="{$topicrefType}">            
            <xsl:call-template name="generateTopicrefAtts">
              <xsl:with-param name="topicUrl" select="$topicUrl"/>
            </xsl:call-template>            
            <xsl:if test="current-group()[position() > 1]">
              <xsl:call-template name="generateTopicrefs">
                <xsl:with-param name="content" select="current-group()[position() > 1]" as="node()*"/>
                <xsl:with-param name="level" select="$level + 1"  as="xs:integer"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:element>          
        </xsl:when>
        <xsl:when test="string(@structureType) = 'topichead'">
          
          <xsl:if test="$debugBoolean">        
            <xsl:message> + [DEBUG] generateTopicrefs: Got a topic head. Level=<xsl:sequence select="string(@level)"/></xsl:message>
          </xsl:if>
          <xsl:variable name="topicheadType" select="if (@topicheadType) then string(@topicheadType) else 'topichead'"/>
          <xsl:variable name="topicmetaType" select="if (@topicmetaType) then string(@topicmetaType) else 'topicmeta'"/>
          <xsl:variable name="navtitleType" select="if (@navtitleType) then string(@navtitleType) else 'navtitle'"/>
          <xsl:element name="{$topicheadType}">
            <xsl:attribute name="xtrc" select="@wordLocation"/>
            <xsl:element name="{$topicmetaType}">
              <xsl:attribute name="xtrc" select="@wordLocation"/>
              <xsl:apply-templates select="current-group()[1]"/>
            </xsl:element>
            <xsl:call-template name="generateTopicrefs">
              <xsl:with-param name="content" select="current-group()[position() > 1]" as="node()*"/>
              <xsl:with-param name="level" select="$level + 1" as="xs:integer"/>
              <xsl:with-param name="treePos" select="($treePos, position() - 2)" tunnel="yes"/>
            </xsl:call-template>
          </xsl:element>          
        </xsl:when>
        <xsl:when test="string(@structureType) = 'map' or string(@structureType) = 'mapTitle'">
          <xsl:if test="$debugBoolean">        
            <xsl:message> + [DEBUG] generateTopicrefs: Got a map-reference-generating map or map title. Level=<xsl:sequence select="string(@level)"/></xsl:message>
          </xsl:if>
          <xsl:variable name="mapRefType" as="xs:string"
          >
            <xsl:choose>
              <xsl:when test="@mapRefType != ''">
                <xsl:sequence select="string(@mapRefType)"/>
              </xsl:when>
              <xsl:when test="@rootTopicrefType != ''">
                <xsl:sequence select="string(@rootTopicrefType)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="$topicrefType"/>
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:variable>
          <xsl:variable name="newMapUrl" as="xs:string" 
            select="local:getResultUrlForMap(., $mapRefType, ($treePos, position() - 2), $mapUrl)">
          </xsl:variable>
          <xsl:element name="{$mapRefType}">
            <xsl:attribute name="format" select="'ditamap'"/>
            <xsl:attribute name="navtitle" select="."/>
            <xsl:attribute name="href" select="relpath:getRelativePath(relpath:getParent($mapUrl), $newMapUrl)"/>
            <xsl:attribute name="xtrc" select="@wordLocation"/>
            
            <xsl:for-each select="./*[string(@structureType) = 'topicTitle' and @level = $level]">
              <xsl:call-template name="generateTopicrefs">
                <xsl:with-param name="content" select="current-group()[position() > 1]" as="node()*"/>
                <xsl:with-param name="treePos" select="($treePos, $level, position())" as="xs:integer+" tunnel="yes"/>
                <xsl:with-param name="mapUrl" select="$newMapUrl" tunnel="yes"/>
              </xsl:call-template>
            </xsl:for-each>
            
            
          </xsl:element>          
        </xsl:when>
        <xsl:when test="current-group()[position() = 1]">
          <!-- Ignore this stuff since it should be map metadata or ignorable stuff -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARNING] generateTopicrefs: Shouldn't be here, first para=<xsl:sequence select="current-group()[1]"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>          
    </xsl:for-each-group>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] generateSubordinateTopicrefs: Done.</xsl:message>
    </xsl:if>
    
  </xsl:template>
  <xsl:template name="generateTopicrefAtts">
    <xsl:param name="topicUrl"/>
    <xsl:param name="mapUrl" tunnel="yes" as="xs:string"/>
    
    <xsl:variable name="topicRelUrl"
      select="relpath:getRelativePath(relpath:getParent($mapUrl), $topicUrl)"
    />
    
    <xsl:attribute name="href" select="$topicRelUrl"/>
    <xsl:if test="@chunk">
      <xsl:copy-of select="@chunk"/>
    </xsl:if>
    <xsl:if test="@collection-type">
      <xsl:copy-of select="@collection-type"/>
    </xsl:if>
    <xsl:if test="@processing-role">
      <xsl:copy-of select="@processing-role"/>
    </xsl:if>
    <xsl:attribute name="xtrc" select="@wordLocation"/>
      
  </xsl:template>
  
  
 
  <!-- Generates topics and submaps. Generation of topicrefs in maps is handled by separate
       mode and processing pass.
    -->
  <xsl:template name="generateTopics">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="treePos" as="xs:integer*" tunnel="yes" select="()"/>
    <xsl:if test="false() or $debugBoolean">        
      <xsl:message> + [DEBUG] *** generateTopics: Starting, level=<xsl:sequence select="$level"/>, treePos=<xsl:sequence select="$treePos"/></xsl:message>
    </xsl:if>
    
    <!-- First paragraph is a special case because a first para
         may generate both a map and a topicref.
      -->
    <xsl:variable name="firstP" select="$content[1]" as="element()*"/>
    <xsl:variable name="firstStructureType" as="xs:string*" select="$firstP/@structureType"/>
    <xsl:if test="not($firstStructureType = ('topicTitle', 'map', 'mapTitle'))">
      <xsl:message terminate="yes"> + [ERROR] First paragraph following the root-map-generating paragraph
 + [ERROR] is not a topic title, map, or map title paragraph. You cannot have content paragraphs
 + [ERROR] between the publication title and the first topic-generating paragraph.
 + [ERROR] Paragraph has structureType of "<xsl:sequence select="string($firstP/@structureType)"/>"
 + [ERROR] and a style of "<xsl:sequence select="string($firstP/@style)"/>".
      </xsl:message>
    </xsl:if>
    
    <xsl:for-each-group select="$content" 
      group-starting-with="*[(string(@structureType) = 'topicTitle' or string(@structureType) = 'map' or string(@structureType) = 'mapTitle') and
      string(@level) = string($level)]">
      <xsl:if test="false() or $debugBoolean">
        <xsl:message> + [DEBUG] generateTopics: In for-each-group:</xsl:message>
        <xsl:message> + [DEBUG]        group=<xsl:sequence select="current-group()"/></xsl:message>
        <xsl:message> + [DEBUG]        position()=<xsl:sequence select="position()"/></xsl:message>
        <xsl:message> + [DEBUG]    @structureType=<xsl:sequence select="string(@structureType)"/></xsl:message>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="string(@structureType) = 'topicTitle' and string(@secondStructureType) = 'mapTitle'">
          <xsl:call-template name="makeMap">
            <xsl:with-param name="content" select="current-group()" as="node()*"/>
            <xsl:with-param name="level" select="$level" as="xs:integer"/>
            <xsl:with-param name="treePos" select="($treePos, ( position() -2))" tunnel="yes"/>
          </xsl:call-template>
          <xsl:call-template name="makeTopic">
            <xsl:with-param name="content" select="current-group()" as="node()*"/>
            <xsl:with-param name="level" select="$level" as="xs:integer"/>
            <xsl:with-param name="treePos" select="($treePos, position())" tunnel="yes"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string(@structureType) = 'topicTitle'">
          <xsl:call-template name="makeTopic">
            <xsl:with-param name="content" select="current-group()" as="node()*"/>
            <xsl:with-param name="level" select="$level" as="xs:integer"/>
            <xsl:with-param name="treePos" select="($treePos, position())" tunnel="yes"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string(@structureType) = 'map' or string(@structureType) = 'mapTitle'">
          <xsl:choose>
            <xsl:when test="count(. | $firstP) = 1">
              <xsl:choose>
                <xsl:when test="@topicrefType != ''">
                  <xsl:call-template name="makeTopic">
                    <xsl:with-param name="content" select="current-group()" as="node()*"/>
                    <xsl:with-param name="level" select="$level" as="xs:integer"/>
                    <xsl:with-param name="treePos" select="($treePos, position())" tunnel="yes"/>
                    <xsl:with-param name="topicrefType" select="string(@topicrefType)" as="xs:string"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/><!-- Just a map generator, ignore the paragraph -->
              </xsl:choose>              
            </xsl:when>
            <xsl:otherwise><!-- Not the first para, handle normally -->
              <xsl:call-template name="makeMap">
                <xsl:with-param name="content" select="current-group()" as="node()*"/>
                <xsl:with-param name="level" select="$level" as="xs:integer"/>
                <xsl:with-param name="treePos" select="($treePos, position() -2)" tunnel="yes"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:when>
        <xsl:when test="current-group()[position() = 1]">
          <!-- Ignore this stuff since it should be map metadata or ignorable stuff -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARNING] generateTopics: Shouldn't be here, first para=<xsl:sequence select="current-group()[1]"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>          
    </xsl:for-each-group>
    
  </xsl:template>
  
  <xsl:template name="makeTopic">
    <xsl:param name="content" as="node()+"/>
    <xsl:param name="level" as="xs:integer"/><!-- Level of this topic -->
    <xsl:param name="treePos" as="xs:integer+" tunnel="yes"/><!-- Tree position of topic in map tree -->
    <xsl:param name="topicrefType" select="$content[1]/@topicrefType" as="xs:string?"/>
    <xsl:param name="mapUrl" as="xs:string?" tunnel="yes"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeTopic: treePos=<xsl:sequence select="$treePos"/></xsl:message>
      <xsl:message> + [DEBUG] makeTopic: level=<xsl:sequence select="$level"/></xsl:message>
      <xsl:message> + [DEBUG] makeTopic: rootTopicUrl=<xsl:sequence select="$rootTopicUrl"/></xsl:message>
    </xsl:if>

    <xsl:variable name="firstP" select="$content[1]"/>

    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeTopic: firstP=<xsl:sequence select="$firstP"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="topicFileName" select="substring-before($firstP,' ')"/>
    <xsl:variable name="makeDoc" 
      select="string($firstP/@topicDoc) = 'yes' or 
      (($level = 0) and $rootTopicUrl)" as="xs:boolean"/>

    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeTopic: makeDoc=<xsl:value-of select="$makeDoc"/></xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$makeDoc">
        <xsl:variable name="topicName" as="xs:string">
          <xsl:apply-templates mode="topic-name" select="$firstP">
            <xsl:with-param name="treePos" select="$treePos" as="xs:integer+"/>
          </xsl:apply-templates>
        </xsl:variable>
        
        <xsl:variable name="topicUrl"
           as="xs:string"
           select="
           if (($level = 0) and $rootTopicUrl)
              then $rootTopicUrl
              else local:getResultUrlForTopic($firstP, $topicrefType, $treePos, $mapUrl, $topicName)"
        />
        
        <xsl:variable name="resultUrl" as="xs:string"
            select="relpath:newFile($outputDir,$topicUrl)"
        />
        
        <xsl:message> + [INFO] Creating new topic document "<xsl:sequence select="$resultUrl"/>"...</xsl:message>
        
        <xsl:variable name="formatName" select="$firstP/@topicType" as="xs:string?"/>
        <xsl:if test="not($formatName)">
          <xsl:message terminate="yes"> + [ERROR] No topicType= attribute for paragraph style <xsl:sequence select="string($firstP/@styleId)"/>, when topicDoc="yes".</xsl:message>
        </xsl:if>
        
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] makeTopic: formatName="<xsl:sequence select="$formatName"/>"</xsl:message>
        </xsl:if>
        
        <xsl:variable name="format" select="key('formats', $formatName, $styleMapDoc)[1]" as="element()?"/>
        <xsl:if test="not($format)">
          <xsl:message terminate="yes"> + [ERROR] makeMap: Failed to find &lt;output&gt; element for @format value "<xsl:sequence select="$formatName"/>" specified for style "<xsl:sequence select="string($firstP/@styleName)"/>" <xsl:sequence select="concat(' [', string($firstP/@styleId), ']')"/>. Check your style-to-tag mapping.</xsl:message>
        </xsl:if>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] makeTopic: format="<xsl:sequence select="$format"/>"</xsl:message>
        </xsl:if>
                
        <xsl:variable name="schemaAtts" as="attribute()*">
          <xsl:if test="$format/@noNamespaceSchemalocation">
            <xsl:attribute name="xsi:noNamespaceSchemaLocation"
              select="string($format/@noNamespaceSchemaLocation)"
            />
          </xsl:if>
          <xsl:if test="$format/@schemaLocation != ''">
            <xsl:attribute name="xsi:schemaLocation"
              select="string($format/@schemaLocation)"
            />
          </xsl:if>
        </xsl:variable>
        <xsl:if test="false() or $debugBoolean">
          <xsl:message> + [DEBUG] makeTopic: schemaAtts=<xsl:sequence select="$schemaAtts"/></xsl:message>
        </xsl:if>
        
        
        <xsl:variable name="resultDoc" as="node()*"> 
          <xsl:call-template name="constructTopic">
            <xsl:with-param name="content" select="$content"  as="node()*"/>
            <xsl:with-param name="level" select="$level" as="xs:integer"/>
            <xsl:with-param name="resultUrl" as="xs:string" tunnel="yes" select="$resultUrl"/>
            <xsl:with-param name="topicName" as="xs:string" tunnel="yes" select="$topicName"/>
            <xsl:with-param name="schemaAtts" as="attribute()*" select="$schemaAtts"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$debugBoolean">
          <xsl:message> + DEBUG: $format=<xsl:sequence select="$format"/></xsl:message>
        </xsl:if>
        <!-- Now do ID fixup on the result document: -->
        <rsiwp:result-document href="{$resultUrl}"
            doctype-public="{$format/@doctype-public}"
            doctype-system="{$format/@doctype-system}"
            >
          <xsl:apply-templates select="$resultDoc" mode="final-fixup"/>
        </rsiwp:result-document>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="topicName" as="xs:string">
          <xsl:apply-templates mode="topic-name" select="$firstP">
            <xsl:with-param name="treePos" select="$treePos" as="xs:integer+"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:call-template name="constructTopic">
          <xsl:with-param name="content" select="$content" as="node()*"/>
          <xsl:with-param name="level" select="$level" as="xs:integer"/>
          <xsl:with-param name="topicName" as="xs:string" tunnel="yes" select="$topicName"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="final-fixup" match="*">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] final-fixup: handling <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="@id" priority="2">
    <!-- Override this template to implement specific ID generators -->
    <xsl:variable name="idGenerator" select="string(../@idGenerator)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$idGenerator = '' or $idGenerator = 'default'">
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] final-fixup/@ID: Using default ID generator, returning "<xsl:sequence select="string(.)"/>"</xsl:message>
        </xsl:if>
        <xsl:copy/><!-- Use the base generated ID value. -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARNING] Unrecognized ID generator name "<xsl:sequence select="$idGenerator"/>"</xsl:message>
        <xsl:copy/><!-- Use the base generated ID value. -->
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="@idGenerator | @class">
    <!-- Suppress -->
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="@*">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="text() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>
  
  <!-- Constructs the topic itself -->
  <xsl:template name="constructTopic">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="topicName" as="xs:string" tunnel="yes" select="generate-id(.)"/>
    <xsl:param name="treePos" as="xs:integer+" tunnel="yes"/><!-- Tree position of topic in map tree -->
    <xsl:param name="schemaAtts" as="attribute()*" select="()"/>
    
    <xsl:variable name="initialSectionType" as="xs:string" select="string(@initialSectionType)"/>
    <xsl:variable name="firstP" select="$content[1]"/>
    <xsl:variable name="nextLevel" select="$level + 1" as="xs:integer"/>
 
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] constructTopic: firstP=<xsl:sequence select="local:reportPara($firstP)"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="topicType" as="xs:string"
      select="local:getTopicType($firstP)"
    />
    
    <xsl:variable name="bodyType" as="xs:string"
      select="
      if ($firstP/@bodyType)
      then $firstP/@bodyType
      else 'body'
      "
    />
    
    <xsl:variable name="prologType" as="xs:string"
      select="
      if ($firstP/@prologType and $firstP/@prologType != '')
      then $firstP/@prologType
      else 'prolog'
      "
    />
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] constructTopic: topicType="<xsl:value-of select="$topicType"/>"</xsl:message>
      <xsl:message> + [DEBUG] constructTopic: bodyType="<xsl:value-of select="$bodyType"/>"</xsl:message>
      <xsl:message> + [DEBUG] constructTopic: prologType="<xsl:value-of select="$prologType"/>"</xsl:message>
      <xsl:message> + [DEBUG] constructTopic: initialSectionType="<xsl:value-of select="$initialSectionType"/>"</xsl:message>
    </xsl:if>
    
    <xsl:variable name="titleIndexEntries" as="element()*">
      <xsl:if test="local:isTopicTitle($firstP)">
        <xsl:sequence select="$firstP//rsiwp:indexterm"/>
      </xsl:if>
    </xsl:variable>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] constructTopic: Creating topic element <xsl:value-of select="$topicType"/></xsl:message>
      <xsl:message> + [DEBUG] constructTopic: topicName="<xsl:sequence select="$topicName"/>"</xsl:message>
    </xsl:if>
    
    <xsl:if test="false() or $debugBoolean">
      <xsl:message> + [DEBUG] constructTopic: schemaAtts=<xsl:sequence select="$schemaAtts"/></xsl:message>
    </xsl:if>
    <xsl:element name="{$topicType}">
      <xsl:attribute name="id" select="$topicName"/>
      <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
      <xsl:attribute name="xml:lang" select="$language"/>
      <xsl:sequence select="$schemaAtts"/>
      <xsl:if test="$firstP/@topicOutputclass">
        <xsl:attribute name="outputclass" select="$firstP/@topicOutputclass"/>
      </xsl:if>
      <xsl:variable name="titleTagName" as="xs:string"
        select="if ($firstP/@tagName)
        then $firstP/@tagName
        else 'title'
        "
      />
      <xsl:if test="$debugBoolean">
        <xsl:message> + [DEBUG] constructTopic: Applying templates to firstP...</xsl:message>
      </xsl:if>      
      <xsl:apply-templates select="$firstP"/>
      <xsl:if test="$debugBoolean">
        <xsl:message> + [DEBUG] constructTopic: For-each-group on content...</xsl:message>
      </xsl:if>      
      <xsl:for-each-group select="$content[position() > 1]" 
        group-starting-with="*[string(@structureType) = 'topicTitle' and string(@level) = string($nextLevel)]">
        <xsl:if test="false() and $debugBoolean">
          <xsl:message> + [DEBUG] constructTopic: currentGroup[<xsl:sequence select="position()"/>]: <xsl:sequence select="current-group()"/></xsl:message>
        </xsl:if>      
        <xsl:choose>
            <xsl:when test="current-group()[position() = 1] and current-group()[1][string(@structureType) != 'topicTitle']">
              <!-- Prolog and body elements for the topic -->
            <!-- NOTE: can't process title itself here because we're using title elements to define
              topic boundaries.
            -->
            <xsl:apply-templates select="current-group()[string(@topicZone) = 'titleAlts']"/>        
            <xsl:apply-templates select="current-group()[string(@topicZone) = 'shortdesc']"/>             
            <xsl:if test=".[string(@topicZone) = 'prolog' or $level = 0] or count($titleIndexEntries) > 0">
              <xsl:choose>
                <xsl:when test="$level = 0">
                  <xsl:element name="{$prologType}">
                    <xsl:attribute name="xtrc" select="$firstP/@wordLocation"/>
                    <!-- For root topic, can pull metadata from anywhere in the incoming document. -->
                    <xsl:apply-templates select="root($firstP)//*[string(@containingTopic) = 'root' and 
                      string(@topicZone) = 'prolog' and 
                      contains(@baseClass, ' topic/author ')]"/>     
                    <!-- FIXME: This is a hack to handle index entries in keywords. Need to refine this
                                so it handles keywords explicitly mapped to the prolog.
                      -->
                    <xsl:if test="count($titleIndexEntries) > 0">
                      <metadata>
                        <keywords>
                           <xsl:apply-templates select="$titleIndexEntries" mode="p-content"/>                          
                        </keywords>
                      </metadata>
                    </xsl:if>
                    <xsl:apply-templates select="root($firstP)//*[string(@containingTopic) = 'root' and 
                      string(@topicZone) = 'prolog' and 
                      contains(@baseClass, ' topic/data ')
                      ]"/>                        
                  </xsl:element>                  
                </xsl:when>
                <xsl:when test="current-group()[string(@topicZone) = 'prolog' and not(@containingTopic)]">
                  <xsl:element name="{$prologType}">
                    <xsl:attribute name="xtrc" select="@wordLocation"/>
                    <xsl:apply-templates select="current-group()[not(@containingTopic) and string(@topicZone) = 'prolog']"/>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="count($titleIndexEntries) > 0">
                  <xsl:element name="{$prologType}">
                    <xsl:attribute name="xtrc" select="@wordLocation"/>
                    <metadata>
                      <keywords>
                        <xsl:apply-templates select="$titleIndexEntries" mode="p-content"/>                          
                      </keywords>
                    </metadata>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise/><!-- Must be only root-level prolog elements in this non-root topic context -->
              </xsl:choose>
            </xsl:if>
            <xsl:if test="current-group()[string(@topicZone) = 'body']">
              <xsl:if test="$debugBoolean">        
                <xsl:message> + [DEBUG] current group is topicZone body</xsl:message>
              </xsl:if>
              <xsl:element name="{$bodyType}">
                <xsl:attribute name="xtrc" select="@wordLocation"/>
                <xsl:call-template name="handleSectionParas">
                  <xsl:with-param name="sectionParas" select="current-group()[string(@topicZone) = 'body']" as="element()*"/>
                  <xsl:with-param name="initialSectionType" select="$initialSectionType" as="xs:string"/>
                </xsl:call-template>
              </xsl:element>                  
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$debugBoolean">        
              <xsl:message> + [DEBUG] makeTopic(): Not topicZone prolog or body, calling makeTopic...</xsl:message>
            </xsl:if>
            <xsl:call-template name="makeTopic">
              <xsl:with-param name="content" select="current-group()" as="node()*"/>
              <xsl:with-param name="level" select="$level + 1" as="xs:integer"/>
              <xsl:with-param name="treePos" select="($treePos, position() - 1)" as="xs:integer+" tunnel="yes"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:for-each-group>
    </xsl:element>      
  </xsl:template>
  
  <xsl:template name="handleSectionParas">
    <xsl:param name="sectionParas" as="element()*"/>
    <xsl:param name="initialSectionType" as="xs:string"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] handleSectionParas: initialSectionType="<xsl:sequence select="$initialSectionType"/>"</xsl:message>
    </xsl:if>
    <xsl:for-each-group select="$sectionParas" group-starting-with="*[string(@structureType) = 'section']">
      <xsl:choose>
        <xsl:when test="current-group()[position() = 1] and string(@structureType) != 'section'">
          <xsl:choose>
            <xsl:when test="$initialSectionType != ''">
              <xsl:element name="{$initialSectionType}">
                <xsl:attribute name="xtrc" select="@wordLocation"/>
                <xsl:call-template name="handleBodyParas">
                  <xsl:with-param name="bodyParas" select="current-group()"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="handleBodyParas">
                <xsl:with-param name="bodyParas" select="current-group()"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="sectionType" as="xs:string"
              select="if (@sectionType) then string(@sectionType) else 'section'"
          />
          <xsl:element name="{$sectionType}">
            <xsl:attribute name="xtrc" select="@wordLocation"/>
            <xsl:if test="@spectitle != ''">
              <xsl:variable name="spectitle" select="local:constructSpectitle(.)" as="xs:string"/>
              <xsl:attribute name="spectitle" select="$spectitle"/>
            </xsl:if>
            <xsl:variable name="firstSectionPara" as="element()">
              <xsl:choose>
                <xsl:when test="starts-with(@spectitle, '#')">
                  <xsl:sequence select="local:removeSpectitleContent(.)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="current-group()[1]"/>
                </xsl:otherwise>
              </xsl:choose>
              
            </xsl:variable>
            <xsl:variable name="bodyParas"
              select="if (string(@useAsTitle) = 'no' or 
                          ((@spectitle != '') and 
                           (not(starts-with(@spectitle, '#')))))
                         then current-group()[position() > 1]
                         else ($firstSectionPara, current-group()[position() > 1])                         
              "
            />
            <xsl:call-template name="handleBodyParas">
              <xsl:with-param name="bodyParas" select="$bodyParas"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="handleBodyParas">
    <xsl:param name="bodyParas" as="element()*"/>
    
    <xsl:for-each-group select="$bodyParas" group-adjacent="boolean(@containerType)">
      <xsl:choose>
        <xsl:when test="@containerType">
          <xsl:variable name="containerGroup" as="element()">
            <containerGroup containerType="{@containerType}">
              <xsl:sequence select="current-group()"/>
            </containerGroup>
          </xsl:variable>
          <xsl:apply-templates select="$containerGroup"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="containerGroup">
<!--    <xsl:message> + [DEBUG] Handling groupContainer...</xsl:message>-->
    <xsl:call-template name="processLevelNContainers">
      <xsl:with-param name="context" select="*" as="element()*"/>
      <xsl:with-param name="level" select="1" as="xs:integer"/>
      <xsl:with-param name="currentContainer" select="'body'" as="xs:string"/>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="processLevelNContainers">
    <xsl:param name="context" as="element()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="currentContainer" as="xs:string"/>
<!--    <xsl:message> + [DEBUG] processLevelNContainers, level="<xsl:sequence select="$level"/>"</xsl:message>
    <xsl:message> + [DEBUG]   currentContainer="<xsl:sequence select="$currentContainer"/>"</xsl:message>
-->    
    <xsl:for-each-group select="$context[@level = $level]" group-adjacent="@containerType">
<!--      <xsl:message> + [DEBUG]   @containerType="<xsl:sequence select="string(@containerType)"/>"</xsl:message>
      <xsl:message> + [DEBUG]   $currentContainer != @containerType="<xsl:sequence select="$currentContainer != string(@containerType)"/>"</xsl:message>
-->
      <xsl:choose>
        <xsl:when test="$currentContainer != string(@containerType)">
<!--          <xsl:message> + [DEBUG ]  currentContainer != @containerType, currentPara=<xsl:sequence select="local:reportPara(.)"/></xsl:message>-->
          <xsl:element name="{@containerType}">
            <xsl:attribute name="xtrc" select="@wordLocation"/>
            <xsl:if test="@containerOutputclass">
              <xsl:attribute name="outputclass" select="string(@containerOutputclass)"/>
            </xsl:if>
            <xsl:for-each select="current-group()">
              <xsl:call-template name="handleGroupSequence">
                <xsl:with-param name="level" select="$level" as="xs:integer"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="current-group()">
            <xsl:call-template name="handleGroupSequence">
              <xsl:with-param name="level" select="$level" as="xs:integer"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>    
  </xsl:template>
  <xsl:template name="handleGroupSequence">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="string(@structureType) = 'dt' and @level = $level">
        <xsl:variable name="dlEntryType" as="xs:string"
          select="if (@dlEntryType) then string(@dlEntryType) else 'dlentry'"
        />
        <xsl:element name="{$dlEntryType}"> 
          <xsl:attribute name="xtrc" select="@wordLocation"/>
          <xsl:call-template name="transformPara"/>
          <xsl:variable name="followingSibling" as="element()?" select="following-sibling::*[1]"/>
          <xsl:variable name="precedingSibling" as="element()?" select="preceding-sibling::*[1]"/>
          <!-- find position of next <dt> element type -->
          <xsl:variable name="followingSiblingDtPositions" as="item()*">
            <xsl:for-each select="following-sibling::*">
              <xsl:if test="@structureType='dt'">
                <xsl:sequence select="position()"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="firstFollowingSiblingDtPosition" as="xs:integer">
            <xsl:choose>
              <xsl:when test="following-sibling::*[@structureType='dt']">
                <xsl:value-of select="$followingSiblingDtPositions[position()=1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$followingSibling/@level &gt; @level">
              <xsl:for-each-group select="following-sibling::*" group-adjacent="@level">
                <xsl:if test="@level &gt; $level">
                  <xsl:element name="{@containerType}">
                    <xsl:attribute name="xtrc" select="@wordLocation"/>
                    
                  <xsl:for-each select="current-group()">
                    <xsl:choose>
                      <xsl:when test="string(@structureType) = 'dt'">
                        <xsl:variable name="nestedFollowingSibling" as="element()?" select="following-sibling::*[1]"/>
                        <xsl:variable name="dlEntryType" as="xs:string"
                          select="if (@dlEntryType) then string(@dlEntryType) else 'dlentry'"
                        />
                        <xsl:element name="{$dlEntryType}">  
                          <xsl:attribute name="xtrc" select="@wordLocation"/>
                          <xsl:call-template name="transformPara"/>
                          <!-- find position of next <dt> element type -->
                          <xsl:variable name="followingNestedSiblingDtPositions" as="item()*">
                            <xsl:for-each select="following-sibling::*">
                              <xsl:if test="@structureType='dt'">
                                <xsl:sequence select="position()"/>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:variable>
                          <xsl:variable name="firstFollowingNestedSiblingDtPosition" as="xs:integer">
                            <xsl:choose>
                              <xsl:when test="following-sibling::*[@structureType='dt']">
                                <xsl:value-of select="$followingNestedSiblingDtPositions[position()=1]"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="0"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <xsl:choose>
                            <xsl:when test="following-sibling::*[@structureType='dt']">
                              <xsl:for-each select="following-sibling::*[@structureType='dd'][position() &lt; $firstFollowingNestedSiblingDtPosition]">
                                <xsl:call-template name="transformPara"/>
                              </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:for-each select="$nestedFollowingSibling">
                                <xsl:call-template name="transformPara"/>
                              </xsl:for-each>
                            </xsl:otherwise>
                          </xsl:choose>
                          <!-- 
                          <xsl:for-each select="$nestedFollowingSibling">
                            <xsl:call-template name="transformPara"/>
                          </xsl:for-each>
                          -->
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:element>
                </xsl:if>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:when test="$precedingSibling/@level &lt; @level"/>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="following-sibling::*[@structureType='dt']">
                    <xsl:for-each select="following-sibling::*[@structureType='dd'][position() &lt; $firstFollowingSiblingDtPosition]">
                      <xsl:call-template name="transformPara"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="following-sibling::*[@structureType='dd']">
                      <xsl:call-template name="transformPara"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="string(@structureType) = 'dd'"/><!-- Handled by dt processing -->
     <xsl:when test="following-sibling::*[1][@level &gt; $level]">
        <xsl:variable name="me" select="." as="element()"/>
       <xsl:element name="{@tagName}">  
         <xsl:attribute name="xtrc" select="@wordLocation"/>
         <xsl:call-template name="transformParaContent"/>
          <xsl:call-template name="processLevelNContainers">
            <xsl:with-param name="context" 
              select="following-sibling::*[(@level = $level + 1) and 
              preceding-sibling::*[@level = $level][1][. is $me]]" as="element()*"/>
            <xsl:with-param name="level" select="$level + 1" as="xs:integer"/>
            <xsl:with-param name="currentContainer" select="@tagName" as="xs:string"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="transformPara"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="rsiwp:break" mode="p-content">
    <br/>
  </xsl:template>
  
  <xsl:template match="rsiwp:tab" mode="p-content">
    <tab/>
  </xsl:template>
  
  <xsl:template match="rsiwp:b | 
    rsiwp:i | 
    rsiwp:u | 
    rsiwp:sup | 
    rsiwp:sub | 
    rsiwp:ph 
    "
    mode="p-content">
    <xsl:element name="{local-name()}">
      <xsl:sequence select="./@*"/>
      <xsl:apply-templates mode="p-content"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="rsiwp:indexterm" mode="p-content">
    <xsl:param name="inTitleContext" as="xs:boolean" tunnel="yes"
       select="false()"/>
    <xsl:if test="not($inTitleContext)">
      <xsl:element name="{local-name()}">
        <xsl:sequence select="./@*"/>
        <xsl:apply-templates mode="p-content"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rsiwp:fn" mode="p-content">
    <xsl:element name="{local-name()}">
      <xsl:sequence select="./@*"/>
      <xsl:call-template name="handleSectionParas">
        <xsl:with-param name="sectionParas" select="*" as="element()*"/>
        <xsl:with-param name="initialSectionType" as="xs:string" select="''"/>        
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="rsiwp:hyperlink" mode="p-content">
    <xsl:element name="{@tagName}">
      <!-- Not all Word hyperlinks become DITA hyperlinks: -->
      <xsl:if test="string(@structureType) = 'xref'">
        <xsl:attribute name="href" select="@href"/>
        <xsl:attribute name="scope" select="@scope"/>
      </xsl:if>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Generates a DITA image element. The URL of the image is determined
      by creating a relative path constructed from the value of the @src
      attribute in the simple WP, which should point to the absolute
      location of the image as it will be accessed by the generated XML,
      and the directory containing the result file for the
      topic being generated, so the resulting value is a relative
      path from the containing topic document to the image.</xd:p>
    </xd:desc>
    <xd:param name="resultUrl"></xd:param>
  </xd:doc>
  <xsl:template match="rsiwp:image" mode="p-content">
    <xsl:param name="resultUrl" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="resultDir" select="relpath:getParent($resultUrl)"/>
    <xsl:variable name="srcAtt" select="@src" as="xs:string"/>
    <xsl:variable name="imageUrl" as="xs:string"
      select="relpath:getRelativePath($resultDir, $srcAtt)"
    />
    <image href="{$imageUrl}">
      <alt><xsl:sequence select="$imageUrl"/></alt>
    </image>
  </xsl:template>
  
  <xsl:function name="local:isMap" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleName" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="$styleName = '' or $styleName = '[None]'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="(key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1],
          key('styleMapsById', $styleName, $styleMapDoc))[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap)
          then ($styleMap/string(@structureType) = 'map' or
                $styleMap/string(@structureType) = 'mapTitle')
          else false()
          "
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="local:isMapRoot" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleName" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="$styleName = '' or $styleName = '[None]'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="(key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1],
          key('styleMapsById', $styleName, $styleMapDoc))[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap)
          then string($styleMap/@structureType) = 'map'
          else false()
          "
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="local:isMapTitle" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleName" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="$styleName = '' or $styleName = '[None]'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="(key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1],
          key('styleMapsById', $styleName, $styleMapDoc))[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap)
          then string($styleMap/@structureType) = 'mapTitle'
          else false()
          "
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="local:isRootTopicTitle" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleName" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="$styleName = '' or $styleName = '[None]'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="
          (key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1],
          key('styleMapsById', $styleName, $styleMapDoc))[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap)
          then (($styleMap/@level = '0') and ($styleMap/@structureType = 'topicTitle'))
          else false()
          "
        />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="local:isTopicTitle" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleId" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="not($styleId) or $styleId = '' or $styleId = '[None]'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="
          (key('styleMapsByName', lower-case($styleId), $styleMapDoc)[1],
          key('styleMapsById', $styleId, $styleMapDoc)[1])[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap)
          then $styleMap/@structureType = 'topicTitle'
          else false()
          "
        />
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  <xsl:function name="local:getTopicType" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleId" as="xs:string"
      select="$context/@style"
    />
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] local:getTopicType(): styleId="<xsl:value-of select="$styleId"/>"</xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$styleId = '' or $styleId = '[None]'">
        <xsl:sequence select="'unknown-topic-type'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="(key('styleMapsByName', lower-case($styleId), $styleMapDoc)[1],
          key('styleMapsById', $styleId, $styleMapDoc)[1])[1]"
        />
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] local:getTopicType(): styleMap="<xsl:sequence select="$styleMap"/>"</xsl:message>
        </xsl:if>
        <xsl:variable name="topicType"
          select="
          if ($styleMap and $styleMap/@topicType)
          then string($styleMap/@topicType)
          else 'unknown-topic-type'
          "
          as="xs:string"
        />
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] local:getTopicType(): returning "<xsl:value-of select="$topicType"/>"</xsl:message>
        </xsl:if>
        <xsl:sequence select="$topicType"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>

  <xsl:function name="local:getMapType" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="styleId" as="xs:string"
      select="$context/@style"
    />
    <xsl:choose>
      <xsl:when test="$styleId = '' or $styleId = '[None]'">
        <xsl:sequence select="'unknown-map-type'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="styleMap" as="element()?"
          select="(key('styleMapsByName', lower-case($styleId), $styleMapDoc)[1],
          key('styleMapsById', $styleId, $styleMapDoc)[1])[1]"
        />
        <xsl:sequence
          select="
          if ($styleMap and $styleMap/@mapType)
          then string($styleMap/@mapType)
          else 'unknown-map-type'
          "
        />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="local:getResultUrlForTopic" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="topicrefType" as="xs:string?"/>
    <xsl:param name="treePos" as="xs:integer+"/>
    <xsl:param name="mapUrl" as="xs:string"/>
    <xsl:param name="topicName" as="xs:string"/>
    
    <xsl:if test="false() or $debugBoolean">
      <xsl:message> + [DEBUG] getResultUrlForTopic(): topicrefType=<xsl:value-of select="$topicrefType"/>, treePos=<xsl:value-of select="$treePos"/></xsl:message>
    </xsl:if>
    <xsl:variable name="topicRelativeUri" as="xs:string+">
      <xsl:apply-templates mode="topic-url" select="$context">
        <xsl:with-param name="topicrefType" as="xs:string?" select="$topicrefType"/>
        <xsl:with-param name="treePos" as="xs:integer+" select="$treePos"/>   
        <xsl:with-param name="topicName" as="xs:string" select="$topicName"/>   
      </xsl:apply-templates>
    </xsl:variable>
    <!-- mapUrl is the URL of the map document -->
    <xsl:variable name="parentDir" select="relpath:getParent($mapUrl)" as="xs:string"/>
    <xsl:variable name="result" as="xs:string"
      select="relpath:newFile($parentDir, $topicRelativeUri)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:function name="local:getResultUrlForMap" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="topicrefType" as="xs:string"/>
    <xsl:param name="treePos" as="xs:integer+"/>
    <xsl:param name="parentMapUrl" as="xs:string"/>
    
    <xsl:variable name="mapRelativeUri" as="xs:string+">
      <xsl:apply-templates mode="map-url" select="$context">
        <xsl:with-param name="topicrefType" as="xs:string" select="$topicrefType"/>
        <xsl:with-param name="treePos" as="xs:integer+" select="$treePos"/>        
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="result" as="xs:string"
      select="relpath:newFile(relpath:getParent($parentMapUrl), string-join($mapRelativeUri, ''))"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:template match="rsiwp:p" mode="topic-name">
    <!-- Generates the name for a topic, which can then be
         used in IDs and filenames.
      -->
    <xsl:param name="treePos" as="xs:integer+"/>
    <xsl:variable name="treePosString" as="xs:string+">
      <xsl:for-each select="$treePos">
        <xsl:value-of select="concat('_', .)"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="result" select="concat($fileNamePrefix, 'topic', string-join($treePosString, ''))"/>
    <xsl:sequence select="$result"/>
    
  </xsl:template>  
 
  <xsl:template match="rsiwp:p" mode="topic-url">   
    <xsl:param name="treePos" as="xs:integer+"/>
    <xsl:param name="topicName" as="xs:string"/>
    
    <xsl:if test="false() or $debugBoolean">
      <xsl:message> + [DEBUG] rsiwp:p, mode=topic-url: treePos=<xsl:sequence select="$treePos"/></xsl:message>
    </xsl:if>

    <xsl:variable name="result" select="concat('topics/', $topicName, $topicExtension)"/>
    <xsl:if test="false() or $debugBoolean">
      <xsl:message> + [DEBUG] rsiwp:p, mode=topic-url: result="<xsl:sequence select="$result"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="map-url topic-url"/>   
  
 
  <xsl:template match="rsiwp:p" mode="map-url">   
    <xsl:param name="treePos" as="xs:integer+"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] rsiwp:p, mode=map-url: treePos=<xsl:sequence select="$treePos"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="treePosString" as="xs:string+">
      <xsl:for-each select="$treePos">
        <xsl:value-of select="concat('_', .)"/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="submapName" as="xs:string" select="concat($fileNamePrefix, $submapNamePrefix, string-join($treePosString, ''))"/>
    
    <xsl:variable name="result" select="concat($submapName, '/', $submapName, '.ditamap')"/>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] rsiwp:p, mode="map-url": result=<xsl:sequence select="$result"/></xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:template>
  
  
  <xsl:template match="rsiwp:*" mode="topic-url">
    <xsl:message> - [WARNING] Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/> in mode 'topic-url'</xsl:message>
    <xsl:variable name="topicTitleFragment">
      <xsl:choose>
        <xsl:when test="contains(.,' ')">
          <xsl:value-of select="replace(substring-before(.,' '),'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(.,'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="concat('topics/topic_', $topicTitleFragment, '_', generate-id(.),format-time(current-time(),'[h][m][s]'), '.dita')"/>
  </xsl:template>
  
  <xsl:template match="rsiwp:*" mode="map-url">
    <xsl:message> - [WARNING] Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/> in mode 'map-url'</xsl:message>
    <xsl:variable name="mapTitleFragment">
      <xsl:choose>
        <xsl:when test="contains(.,' ')">
          <xsl:value-of select="replace(substring-before(.,' '),'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(.,'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="concat('topics/topic_', $mapTitleFragment, '_', generate-id(.), $topicExtension)"/>
  </xsl:template>
  
  <xsl:function name="local:debugMessage">
    <xsl:param name="msg" as="xs:string"/>
    <xsl:message> + [DEBUG] <xsl:sequence select="$msg"/></xsl:message>
  </xsl:function>
  
  <xsl:function name="local:reportParas">
    <xsl:param name="paras" as="element()*"/>
    <xsl:for-each select="$paras">
      <xsl:sequence select="local:reportPara(.)"/>
      <xsl:text>&#x0a;</xsl:text>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="local:reportPara">
    <xsl:param name="para" as="element()?"/>
    <xsl:if test="$para">
      <xsl:sequence 
        select="concat('[', 
                       name($para),
                       ' ',
                       ' tagName=',
                       $para/@tagName,
                       if ($para/@level)
                          then concat(' level=', $para/@level)
                          else '',
                       if ($para/@containerType)
                          then concat(' containerType=', $para/@containerType)
                          else '',
                       if ($para/@containerOutputclass)
                          then concat(' containerOutputclass=', $para/@containerOutputclass)
                          else '',
                          ']',
                       substring(normalize-space($para), 1,20)
                       )"
      />
    </xsl:if>
  </xsl:function>
 
  <xsl:function name="local:constructSpectitle">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="specTitleSpec" select="string($context/@spectitle)"/>    
    <xsl:variable name="spectitle" as="xs:string">
      <xsl:choose>
        <xsl:when test="$specTitleSpec = '#toColon'">
          <xsl:sequence select="substring-before(string($context), ':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="string($context/@spectitle)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$spectitle"/>
  </xsl:function>
  
  <xsl:function name="local:removeSpectitleContent" as="element()">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="initialText" as="xs:string" select="$context/text()[count(preceding-sibling::*) = 0]"/>
    <xsl:element name="{name($context)}"
      namespace="{namespace-uri($context)}"
      >
      <xsl:sequence select="$context/@*"/>
      <xsl:choose>
        <xsl:when test="string($context/@spectitle) = '#toColon'">
          <xsl:sequence select="substring-after($initialText, ': ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="string($initialText)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:sequence select="$context/* | $context/text()[count(preceding-sibling::*) gt 0]"/>
    </xsl:element>
  </xsl:function>
  
  <xsl:template match="rsiwp:*" priority="-0.5" mode="p-content">
    <xsl:message> + [WARNING] simple2dita[p-content]: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="rsiwp:*" priority="-0.5">
    <xsl:message> + [WARNING] simple2dita: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
