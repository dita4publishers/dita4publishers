<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath"
  version="2.0">

  <!-- Override of templates from the base root-processing.xsl -->
  
  <xsl:template
    name="rootTemplate">
    <xsl:call-template
      name="validateTopicRefs"/>
    <xsl:message>[DEBUG] d4p/root-processing.xsl: rootTemplate, context item=<xsl:sequence select="name(.)"/></xsl:message>

    <fo:root
      xsl:use-attribute-sets="__fo__root">

      <xsl:comment>
        <xsl:text>Layout masters = </xsl:text>
        <xsl:value-of
          select="$layout-masters"/>
      </xsl:comment>

      <xsl:call-template
        name="createLayoutMasterSet"/>
      
      <xsl:call-template
        name="createBookmarks"/>

      <xsl:call-template
        name="createCoversAndInitialPages"/>

      <xsl:call-template 
        name="constructNavTreePageSequences"/>

      <xsl:call-template
        name="createIndex"/>
      
      <xsl:call-template name="createLastPages"/>

    </fo:root>
  </xsl:template>
  
  <xsl:template name="constructNavTreePageSequences">
    <!-- Template to manage construction of the page sequences
         that reflect the navigation tree defined in the
         input map.
      -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="createCoversAndInitialPages">
    <!-- Template to manage creation of covers and initial pages 
         up to the frontmatter and book lists (ToC, etc.).
         
         Override this template to do things how you want.
    -->
    <xsl:variable name="frontCoverGraphicUri" as="xs:string">
      <xsl:apply-templates mode="getFrontCoverGraphicUri" select="."/>
    </xsl:variable>
    <xsl:call-template name="createFrontCover">
      <xsl:with-param name="frontCoverGraphicUri" as="xs:string" select="$d4pFrontCoverGraphicUri"/>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="createLastPages">
    <!-- Template to manage creation of trailing pages,
         such as the colophon, back covers, etc.
         
         Override this template to do things how you want.
    -->
    
    <xsl:variable name="backCoverGraphicUri" as="xs:string">
      <xsl:apply-templates mode="getBackCoverGraphicUri" select="."/>
    </xsl:variable>
    <xsl:call-template name="createBackCover">
      <xsl:with-param name="backCoverGraphicUri" as="xs:string" select="$d4pBackCoverGraphicUri"/>
    </xsl:call-template>
    
  </xsl:template>
  

</xsl:stylesheet>
