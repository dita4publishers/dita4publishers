<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:local="urn:local-functions"
  xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
  xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
version="2.0">

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    scope="stylesheet">
    <xd:desc>
      <xd:p>DOCX to DITA generic transformation</xd:p>
      <xd:p>Copyright (c) 2009, 2013 DITA For Publishers, Inc.</xd:p>
      <xd:p>Transforms a DOCX document.xml file into a DITA topic using a style-to-tag mapping. </xd:p>
      <xd:p>This transform is intended to be the base for more specialized transforms that provide
        style-specific overrides. The input to this transform is the document.xml file within a DOCX
        package. </xd:p>
      <xd:p>Originally developed by Really Strategies, Inc.</xd:p>
    </xd:desc>
  </xd:doc>
  <!--==========================================
    DOCX to DITA generic transformation
    
    Copyright (c) 2009, 2012 DITA For Publishers, Inc.

    Transforms a DOCX document.xml file into a DITA topic using
    a style-to-tag mapping.
    
    This transform is intended to be the base for more specialized
    transforms that provide style-specific overrides.
    
    The input to this transform is the document.xml file within a DOCX
    package.
    
    
    Originally developed by Really Strategies, Inc.
    
    =========================================== -->
  
  
  <xsl:param name="styleMapUri" as="xs:string"/>
  <xsl:param name="mediaDirUri" select="relpath:newFile($outputDir, 'topics/media')" as="xs:string"/>  
  <xsl:param name="outputDir" as="xs:string"/>
  <xsl:param name="rootTopicName" as="xs:string?" select="()"/>
  <xsl:param name="rootMapName" as="xs:string" select="$rootTopicName"/>
  <xsl:param name="submapNamePrefix" as="xs:string" select="'map'"/>
  <xsl:param name="filterBr" as="xs:string" select="'false'"/>
  <xsl:param name="filterTabs" as="xs:string" select="'false'"/>
  <xsl:param name="includeWordBackPointers" as="xs:string" select="'true'"/>
  <!-- When true, include <data> elements that reflect Word bookmark start and end markers -->
  <xsl:param name="includeWordBookmarks" as="xs:string" select="'false'"/>
  <xsl:param name="language" as="xs:string" select="'en-US'"/>
  
  <xsl:param name="topicExtension" select="'.dita'" as="xs:string"/><!-- Extension for generated topic files -->
  <xsl:param name="fileNamePrefix" select="''" as="xs:string"/><!-- Prefix for genenerated file names -->
  <xsl:param name="chartsAsTables" select="'false'" as="xs:string"/><!-- When true, capture Word charts as tables with the chart data -->
  <xsl:variable name="chartsAsTablesBoolean" as="xs:boolean" select="$chartsAsTables = 'true'"/>
  
  <xsl:param name="rawPlatformString" select="'unknown'" as="xs:string"/>
  
  <!-- When true, use any external (linked) filename as the name for referenced graphics,
       rather than the internal names. Note that tools that deal with the graphic files
       extracted from the DOCX file will have to know how the internal names map to external
       names (which they can know by examining the word/_rels/document.xml.rels file in the
       package).
    -->
  <xsl:param name="useLinkedGraphicNames" as="xs:string" select="'no'"/>
  <xsl:param name="useLinkedGraphicNamesBoolean" as="xs:boolean" 
    select="matches($useLinkedGraphicNames, 'yes|true|1', 'i')"
  />
  
  <!-- Prefix to add to image filenames when constructing image references
       in the result XML.
    -->
  <xsl:param name="imageFilenamePrefix" as="xs:string?"
    select="$fileNamePrefix"
  />
  
  <!-- If true, issue warnings about unstyled paragraphs. Unstyled paragraphs
       map to <p> by default.
    -->
  <xsl:param name="warnOnUnstyledParas" as="xs:string" select="'false'"/>
  <xsl:variable name="warnOnUnstyledParasBoolean"
     select="matches($warnOnUnstyledParas, 'yes|true|1', 'i')"
  />
  
  <xsl:param name="saveIntermediateDocs" as="xs:string" select="'false'"/>
  <xsl:variable name="doSaveIntermediateDocs" as="xs:boolean" 
    select="$debugBoolean or matches($saveIntermediateDocs, 'true|yes|1|on', 'i')"
  />
  
  <xsl:variable name="rootMapUrl" select="concat($rootMapName, '.ditamap')" as="xs:string"/>
  <xsl:variable name="rootTopicUrl" 
    as="xs:string?" 
    select="if ($rootTopicName) 
    then concat($rootTopicName, $topicExtension)
    else ()"/>
  <xsl:variable name="platform" as="xs:string"
    select="
    if (starts-with($rawPlatformString, 'Win') or 
    starts-with($rawPlatformString, 'Win'))
    then 'windows'
    else 'nx'
    "
  />
  
  <xsl:variable name="filterTabsBoolean" as="xs:boolean" select="matches($filterTabs, 'yes|true|1', 'i')"/>
  <xsl:variable name="filterBrBoolean" as="xs:boolean" select="matches($filterBr, 'yes|true|1', 'i')"/>
  <xsl:variable name="includeWordBackPointersBoolean" as="xs:boolean" 
    select="matches($includeWordBackPointers, 'yes|true|1', 'i')"/>
  
  <xsl:variable name="includeWordBookmarksBoolean" as="xs:boolean" 
    select="matches($includeWordBookmarks, 'yes|true|1', 'i')"/>
  
  <xsl:include
    href="office-open-utils.xsl"/>
  <xsl:include
    href="wordml2simple.xsl"/>
  <xsl:include 
    href="spreadsheetml2simple.xsl"/>
  <xsl:include
    href="wordml2simpleLevelFixup.xsl"/>
  <xsl:include
    href="wordml2simpleMathTypeFixup.xsl"/>
  <xsl:include
    href="simple2dita.xsl"/>
  <xsl:include
    href="resultdocs-xref-fixup.xsl"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:param
    name="debug"
    select="'false'"
    as="xs:string"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:variable
    name="debugBoolean"
    as="xs:boolean"
    select="matches($debug, 'true|yes|1|on', 'i')"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  
  <xsl:template
    match="/"
    priority="10">
    <xsl:apply-templates select="." mode="report-parameters"/>
    <xsl:variable name="doDebug" as="xs:boolean" select="$debugBoolean"/>
    <xsl:variable name="stylesDoc" as="document-node()"
      select="document('styles.xml', .)"
    />      
    
    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:message> + [INFO] Generating initial simple WP doc....</xsl:message>
    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:variable
      name="simpleWpDocBase"
      as="element()">
      <xsl:call-template
        name="processDocumentXml">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="stylesDoc" as="document-node()" tunnel="yes"
          select="$stylesDoc"/>
      </xsl:call-template>
    </xsl:variable>    
    <xsl:variable
      name="tempDoc"
      select="relpath:newFile($outputDir, 'simpleWpDoc.xml')"
      as="xs:string"/>
    <!-- NOTE: do not set this check to true(): it will fail when run within RSuite -->
    <xsl:if
      test="$doSaveIntermediateDocs">
      <xsl:result-document
        href="{$tempDoc}">
        <xsl:message> + [DEBUG] Intermediate simple WP doc saved as <xsl:sequence
            select="$tempDoc"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDocBase"/>
      </xsl:result-document>
    </xsl:if>
    
    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:message> + [INFO] Doing level fixup....</xsl:message>
    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:variable name="simpleWpDocLevelFixupResult" as="element()">
      <xsl:apply-templates select="$simpleWpDocBase" mode="simpleWpDoc-levelFixupRoot">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
<!--      <xsl:sequence select="$simpleWpDocBase"/>-->
    </xsl:variable>
    
    <xsl:if
      test="$doSaveIntermediateDocs">
    <xsl:variable
      name="tempDocLevelFixup"
      select="relpath:newFile($outputDir, 'simpleWpDocLevelFixup.xml')"
      as="xs:string"/>
      <xsl:result-document
        href="{$tempDocLevelFixup}">
        <xsl:message> + [DEBUG] Intermediate simple WP level fixup result doc saved as <xsl:sequence
            select="$tempDocLevelFixup"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDocLevelFixupResult"/>
      </xsl:result-document>
    </xsl:if>

    <xsl:variable name="simpleWpDocMathTypeFixupResult"
      as="document-node()"
    >
      <xsl:choose>      
      <xsl:when test="$simpleWpDocLevelFixupResult//rsiwp:run[@style='MTConvertedEquation']">  
        <xsl:message> + [INFO] ====================================</xsl:message>
        <xsl:message> + [INFO] Doing MathType simpleWpDoc fixup....</xsl:message>
        <xsl:message> + [INFO] ====================================</xsl:message>
        <xsl:document>
          <xsl:apply-templates select="$simpleWpDocLevelFixupResult" mode="simpleWpDoc-MathTypeFixup">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:apply-templates>
        </xsl:document>
      </xsl:when>
        <xsl:otherwise>
          <xsl:document>
            <xsl:sequence select="$simpleWpDocLevelFixupResult"/>
          </xsl:document>
        </xsl:otherwise>
      </xsl:choose>    
    </xsl:variable>

    <xsl:if
      test="$doSaveIntermediateDocs">
    <xsl:variable
      name="tempDocMathTypeFixup"
      select="relpath:newFile($outputDir, 'simpleWpDocMathTypeFixup.xml')"
      as="xs:string"/>
      <xsl:result-document
        href="{$tempDocMathTypeFixup}">
        <xsl:message> + [DEBUG] Intermediate simple WP MathType fixup result doc saved as <xsl:sequence
            select="$tempDocMathTypeFixup"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDocMathTypeFixupResult"/>
      </xsl:result-document>
    </xsl:if>

    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:message> + [INFO] Doing general simpleWpDoc fixup....</xsl:message>
    <xsl:message> + [INFO] ====================================</xsl:message>

    <xsl:variable name="simpleWpDoc"
      as="document-node()"
    >
      <xsl:document>
        <xsl:apply-templates select="$simpleWpDocMathTypeFixupResult" mode="simpleWpDoc-fixup">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        </xsl:apply-templates>
      </xsl:document>
    </xsl:variable>

    <xsl:if
      test="$doSaveIntermediateDocs">
      <xsl:variable
        name="tempDocFixup"
        select="relpath:newFile($outputDir, 'simpleWpDocFixup.xml')"
        as="xs:string"/>
      <xsl:result-document
        href="{$tempDocFixup}">
        <xsl:message> + [DEBUG] Fixed-up simple WP doc saved as <xsl:sequence
            select="$tempDocFixup"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDoc"/>
      </xsl:result-document>
    </xsl:if>

    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:message> + [INFO] Generating DITA result....</xsl:message>
    <xsl:message> + [INFO] ====================================</xsl:message>


    <xsl:apply-templates
      select="$simpleWpDoc/*"
      >
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      <xsl:with-param 
        name="resultUrl" 
        select="relpath:newFile($outputDir, 'temp.output')" 
        tunnel="yes"        
      />
    </xsl:apply-templates>
    <xsl:message> + [INFO] ====================================</xsl:message>
    <xsl:message> + [INFO] Done.</xsl:message>
    <xsl:message> + [INFO] ====================================</xsl:message>
  </xsl:template>
  
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:message> 
      ==========================================
      DOCX 2 DITA
      
      Version: ^version^ - build ^buildnumber^ at ^timestamp^
      
      Parameters:
      
      + styleMapUri     = "<xsl:sequence select="$styleMapUri"/>"
      + mediaDirUri     = "<xsl:sequence select="$mediaDirUri"/>"  
      + rootMapName     = "<xsl:sequence select="$rootMapName"/>"
      + rootTopicName   = "<xsl:sequence select="$rootTopicName"/>"
      + submapNamePrefix= "<xsl:sequence select="$submapNamePrefix"/>"      
      + rootMapUrl      = "<xsl:sequence select="$rootMapUrl"/>"
      + rootTopicUrl    = "<xsl:sequence select="$rootTopicUrl"/>"
      + topicExtension  = "<xsl:sequence select="$topicExtension"/>"
      + fileNamePrefix  = "<xsl:sequence select="$fileNamePrefix"/>"      
      + filterBr        = "<xsl:sequence select="$filterBr"/>"      
      + filterTabs      = "<xsl:sequence select="$filterTabs"/>"      
      + language        = "<xsl:sequence select="$language"/>"      
      + outputDir       = "<xsl:sequence select="$outputDir"/>"  
      + debug           = "<xsl:sequence select="$debug"/>"
      + includeWordBackPointers= "<xsl:sequence select="$includeWordBackPointersBoolean"/>"  
      + chartsAsTables  = "<xsl:sequence select="$chartsAsTablesBoolean"/>"  
      + saveIntermediateDocs  = "<xsl:sequence select="$saveIntermediateDocs"/>"  
      
      Global Variables:
      
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
      + doSaveIntermediateDocs = "<xsl:sequence select="$doSaveIntermediateDocs"/>"
      
      ==========================================
    </xsl:message>
  </xsl:template>
  
  
</xsl:stylesheet>
