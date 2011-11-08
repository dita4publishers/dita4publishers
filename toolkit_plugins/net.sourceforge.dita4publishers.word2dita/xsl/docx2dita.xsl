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
      <xd:p>Copyright (c) 2009, 2011 DITA For Publishers, Inc.</xd:p>
      <xd:p>Transforms a DOCX document.xml file into a DITA topic using a style-to-tag mapping. </xd:p>
      <xd:p>This transform is intended to be the base for more specialized transforms that provide
        style-specific overrides. The input to this transform is the document.xml file within a DOCX
        package. </xd:p>
      <xd:p>Originally developed by Really Strategies, Inc.</xd:p>
    </xd:desc>
  </xd:doc>
  <!--==========================================
    DOCX to DITA generic transformation
    
    Copyright (c) 2009, 2011 DITA For Publishers, Inc.

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
  <xsl:param name="rootMapName" as="xs:string" select="'rootmap'"/>
  <xsl:param name="rootTopicName" as="xs:string?" select="()"/>
  <xsl:param name="submapNamePrefix" as="xs:string" select="'map'"/>
  <xsl:param name="filterBr" as="xs:string" select="'false'"/>
  <xsl:param name="filterTabs" as="xs:string" select="'false'"/>
  <xsl:param name="includeWordBackPointers" as="xs:string" select="'true'"/>
  
  <xsl:param name="topicExtension" select="'.dita'" as="xs:string"/><!-- Extension for generated topic files -->
  <xsl:param name="fileNamePrefix" select="''" as="xs:string"/><!-- Prefix for genenerated file names -->
  
  <xsl:param name="rawPlatformString" select="'unknown'" as="xs:string"/>
  
  <xsl:variable name="rootMapUrl" select="concat($rootMapName, '.ditamap')" as="xs:string"/>
  <xsl:variable name="rootTopicUrl" 
    as="xs:string?" 
    select="if ($rootTopicName) 
    then concat($rootTopicName, '.xml')
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
  <xsl:variable name="includeWordBackPointersBoolean" as="xs:boolean" select="matches($includeWordBackPointers, 'yes|true|1', 'i')"/>
  
  <xsl:include
    href="wordml2simple.xsl"/>
  <xsl:include
    href="simple2dita.xsl"/>
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
    select="$debug = 'true'"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:template
    match="/"
    priority="10">
    <xsl:call-template name="report-parameters"/>
    <xsl:variable name="stylesDoc" as="document-node()"
      select="document('styles.xml', .)"
    />      
    <xsl:variable
      name="simpleWpDocBase"
      as="element()">
      <xsl:call-template
        name="processDocumentXml">
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
      test="false() or $debugBoolean">
      <xsl:result-document
        href="{$tempDoc}">
        <xsl:message> + [DEBUG] Intermediate simple WP doc saved as <xsl:sequence
            select="$tempDoc"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDocBase"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:variable name="simpleWpDoc"
      as="element()"
    >
      <xsl:apply-templates select="$simpleWpDocBase" mode="simpleWpDoc-fixup"/>
    </xsl:variable>
    <xsl:apply-templates
      select="$simpleWpDoc">
      <xsl:with-param name="resultUrl" select="relpath:newFile($outputDir, 'temp.output')" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:message> + [INFO] Done.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-fixup" match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-fixup" match="@* | text() | processing-instruction()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template name="report-parameters">
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
      + outputDir       = "<xsl:sequence select="$outputDir"/>"  
      + debug           = "<xsl:sequence select="$debug"/>"
      + includeWordBackPointers= "<xsl:sequence select="$includeWordBackPointersBoolean"/>"  
      
      Global Variables:
      
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
      
      ==========================================
    </xsl:message>
  </xsl:template>
  
  
</xsl:stylesheet>
