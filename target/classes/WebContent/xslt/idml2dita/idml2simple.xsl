<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      
      xmlns:local="urn:local-functions"
      
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:/dita4publishers.org/namespaces/word2dita/style2tagmap"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
      
      exclude-result-prefixes="idPkg stylemap local"
      version="2.0">
  
  <!--==========================================
      InDesign CS4 IDML XML to generic Word Processing
      XML transform.
      
      Copyright (c) 2009 DITA2InDesign Project.
      
      This transform is a generic transform that produces a simplified
      form of generic XML from InDesign CS4 IDML XML.
      
      The input to this transform is a Story file within an IDML
      package.
      
      =========================================== -->
  
  <xsl:param name="styleMapUri" as="xs:string"/>
  <xsl:param name="debug" select="'true'" as="xs:string"/>
  
  <xsl:variable name="debugBoolean" as="xs:boolean" select="$debug = 'true'"/>  
  
  <xsl:key name="styleMaps" match="stylemap:style" use="@styleId"/>
  
  <xsl:variable name="styleMapDoc" as="document-node()"
    select="document($styleMapUri)"
  />
  
  <xsl:template match="/" name="processStoryXml">
    <xsl:if test="not(/idPkg:Story)">
      <xsl:message terminate="yes"> + [ERROR] Input document must be a idPkg:Story document.</xsl:message>
    </xsl:if>
    
    <document
      sourceDoc="{document-uri(.)}"
      >
      <xsl:apply-templates>
        <!-- Add params here as necessary to provide supporting documents -->
      </xsl:apply-templates>
    </document>
  </xsl:template>
  
  <xsl:template match="idPkg:Story">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="Story">
    <body>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  
  <xsl:template match="ParagraphStyleRange">
    <xsl:param name="mapUnstyledParasTo" select="'p'" tunnel="yes"/>
    <xsl:variable name="styleId"
      as="xs:string"
      select="
      local:getParaStyle(., $mapUnstyledParasTo)
      "
    />
    
    <xsl:variable name="styleMap" as="element()?"
      select="key('styleMaps', $styleId, $styleMapDoc)[1]"
    />
    <xsl:variable name="styleData" as="element()">
      <xsl:choose>
        <xsl:when test="$styleMap">          
          <xsl:sequence select="$styleMap"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARNING: No style mapping for paragraph with style ID "<xsl:sequence select="$styleId"/>"</xsl:message>
          <stylemap:style styleId="copy"
            structureType="block"
            tagName="p"
            topicZone="body"
          />          
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:variable name="textRuns" as="element()*">
      <!-- Push the paragraph and character styles down onto the Content
           elements so we can then group text runs into paragraphs
      -->
      <xsl:apply-templates select="CharacterStyleRange" mode="makeTextRuns">
        <xsl:with-param name="paraStyleId" as="xs:string" select="$styleId" tunnel="yes"/>        
      </xsl:apply-templates>
    </xsl:variable>
<!--    <xsl:message>$textRuns=<xsl:sequence select="$textRuns"/></xsl:message>-->
    <xsl:for-each-group select="$textRuns" group-ending-with="Br">
      <xsl:call-template name="handlePara">
        <xsl:with-param name="styleId" select="$styleId"/>
        <xsl:with-param name="styleData" select="$styleData"/>
        <xsl:with-param name="context" select="current-group()"/>
      </xsl:call-template>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="Footnote">
    <fn><xsl:apply-templates /></fn>
  </xsl:template>
  
  <xsl:template match="text()" mode="makeTextRuns"/>
  
  <xsl:template match="Content/text()" mode="makeTextRuns" priority="10">
    <xsl:sequence select="."/>
  </xsl:template>
  
  
  
  <xsl:template match="CharacterStyleRange" mode="makeTextRuns">
    <xsl:apply-templates mode="makeTextRuns">
      <xsl:with-param name="charStyleId" select="@AppliedCharacterStyle" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="CrossReferenceSource" mode="makeTextRuns">
      <xsl:apply-templates mode="makeTextRuns">
        <xsl:with-param name="charStyleId" select="@AppliedCharacterStyle" as="xs:string" tunnel="yes"/>
      </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="Br" mode="makeTextRuns">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="Footnote" mode="makeTextRuns">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="PageReference" mode="makeTextRuns">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="Content" mode="makeTextRuns">
    <xsl:param name="paraStyleId" as="xs:string" tunnel="yes"/>
    <xsl:param name="charStyleId" as="xs:string" tunnel="yes"/>
    <xsl:copy>
      <xsl:attribute name="pStyle" select="$paraStyleId"/>
      <xsl:attribute name="cStyle" select="$charStyleId"/>
      <xsl:apply-templates mode="makeTextRuns"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="PageReference">
    
    <!-- IDML page references are index markers -->
    <!-- 
      <PageReference Self="u4b5b" PageReferenceType="CurrentPage" 
      ReferencedTopic="u173TopicnWeb 2.0Topicnfit with Agile development"/>
      
    -->
    <xsl:variable name="indexTokens" select="tokenize(@ReferencedTopic, 'Topicn')[position() > 1]" as="xs:string*"/>
<!--    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] PageReference: indexTokens="<xsl:sequence select="$indexTokens"/></xsl:message>
    </xsl:if>
-->    <xsl:if test="count($indexTokens) > 0">
      <indexterm><xsl:sequence select="$indexTokens[1]"/>
        <xsl:if test="count($indexTokens) > 1">
          <indexterm><xsl:sequence select="$indexTokens[2]"/>
            <xsl:if test="count($indexTokens) > 2">
              <indexterm><xsl:sequence select="$indexTokens[2]"/></indexterm>
            </xsl:if>
          </indexterm>
        </xsl:if>
      </indexterm>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="handlePara">
    <xsl:param name="styleId"/>
    <xsl:param name="styleData"/>
    <xsl:param name="context" as="element()*"/>
    
    <p style="{$styleId}">
      <xsl:sequence select="$styleData/@*"/>
      <xsl:for-each-group select="$context" group-adjacent="concat('x', @cStyle)">
        <xsl:choose>
          <xsl:when test="current-group()[1][self::Content or self::Footnote or self::PageReference]">
            <xsl:call-template name="handleRunSequence">
              <xsl:with-param name="runSequence" select="current-group()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="current-group()[1][self::Br]"/><!-- silently ignore -->
          <xsl:when test="current-group()[1][self::indexterm]">
            <xsl:sequence select="current-group()"/>
          </xsl:when>
          <xsl:when test="current-group()[1][self::CrossReferenceSource]">
            <xsl:call-template name="handleRunSequence">
              <xsl:with-param name="runSequence" select="current-group()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="current-group()[1][self::rsiwp:table]">
            <xsl:sequence select="current-group()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes"> + [ERROR] idml2simple: handlePara(): Unhandled element type <xsl:sequence select="name(.)"/></xsl:message>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:for-each-group>
    </p>    
  </xsl:template>
  
  <xsl:template mode="makeTextRuns" match="Table">
    <xsl:variable name="columnCount" as="xs:integer" select="count(./Column)"/>
    <table>
      <cols>
        <xsl:apply-templates select="Column"/>
      </cols>
      <xsl:for-each-group select="Cell" group-by="substring-after(@Name, ':')">
        <tr>
          <xsl:apply-templates select="current-group()"/>
        </tr>
      </xsl:for-each-group>
    </table>
  </xsl:template>  
  
  <xsl:template match="Cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="Column">
    <col/><!-- FIXME: Set more useful properties -->
  </xsl:template>
  
  <xsl:template match="Row">
    <!-- Ignore for now -->
  </xsl:template>
  
  
  <xsl:template match="*" mode="table" priority="0">
    <xsl:message> + [WARNING] mode table: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template name="handleRunSequence">
    <xsl:param name="runSequence" as="element()*"/>
    
    <xsl:variable name="runStyle" select="local:getRunStyle($runSequence[1])" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$runStyle = '' or ends-with($runStyle, '[No character style]')">
        <xsl:apply-templates select="$runSequence"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="runStyleMap" as="element()?"
          select="key('styleMaps', $runStyle, $styleMapDoc)[1]"
        />
        <xsl:if test="not($runStyleMap)">
          <xsl:message> + [WARNING: No style mapping for character run with style ID "<xsl:sequence select="$runStyle"/>"</xsl:message>              
        </xsl:if>
        <xsl:variable name="runTagName"
          as="xs:string"
          select="
          'run'
          "
        />
        <xsl:element name="{$runTagName}">
          <xsl:attribute name="style" select="$runStyle"/>
          <xsl:if test="$runStyleMap">
            <xsl:for-each select="$runStyleMap/@*">
              <xsl:copy/>
            </xsl:for-each>
          </xsl:if>
          <xsl:apply-templates select="$runSequence"/></xsl:element>
      </xsl:otherwise>
    </xsl:choose>        
    
  </xsl:template>
  
  <xsl:template match="CharacterStyleRange">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="text()"/>

  <xsl:template match="Content/text()" mode="#default" priority="10">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="Content">
    <!-- NOTE: this has to be value-of. If you use select, you get spaces
      between the Content text values.
      -->
    <xsl:value-of select="string(.)"/>
  </xsl:template>

  <xsl:template 
    match="
    Br |
    Story/StoryPreference |
    Story/InCopyExportOption
    "/>  
  
  <xsl:function name="local:getRunStyle" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="string($context/@cStyle)"/>
  </xsl:function>
  
  <xsl:function name="local:getParaStyle" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="mapUnstyledParasTo" as="xs:string"/>
    <xsl:sequence select="string($context/@AppliedParagraphStyle)"/>
  </xsl:function>
  
  <xsl:template match="*" priority="-1" mode="makeTextRuns">
    <xsl:message> + [WARNING] idml2simple: (Mode makeTextRuns) Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> + [WARNING] idml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
