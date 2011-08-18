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
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df"
  version="2.0">

  <!-- Override of templates from the base root-processing.xsl -->

  <!-- NOTE: As of 1.5.4M2 there is no way to set arbitrary XSLT 
             properties for a transform type that extends
             the PDF2 transform type.
    -->
  <!-- URI of the graphic to use for the front cover. -->
  <xsl:param name="d4pFrontCoverGraphicUri" as="xs:string" select="''"/>

  <!-- URI of the graphic to use for the back cover. -->
  <xsl:param name="d4pBackCoverGraphicUri" as="xs:string" select="''"/>
  
  <xsl:key name="topicsById" match="*[df:class(., 'topic/topic')]" use="@id"/>
  <xsl:key name="topicRefsById" match="*[df:class(., 'map/topicref')]" use="@id"/>

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
      
      <xsl:variable name="frontCoverTopics" as="element()*">
        <xsl:apply-templates select="/*/opentopic:map" mode="getFrontCoverTopics"/>
      </xsl:variable>
      <xsl:variable name="backCoverTopics" as="element()*">
        <xsl:apply-templates select="/*/opentopic:map" mode="getBackCoverTopics"/>
      </xsl:variable>

      <xsl:call-template
        name="createCoversAndInitialPages">
        <xsl:with-param name="frontCoverTopics" as="element()*" 
          select="$frontCoverTopics"/>
      </xsl:call-template>

      <xsl:call-template 
        name="constructNavTreePageSequences">
        <xsl:with-param name="frontCoverTopics" as="element()*" 
          select="$frontCoverTopics"/>
        <xsl:with-param name="backCoverTopics" as="element()*" 
          select="$backCoverTopics"/>
      </xsl:call-template>

      <xsl:call-template
        name="createIndex"/>
      
      <xsl:call-template name="createLastPages">
        <xsl:with-param name="backCoverTopics" as="element()*" 
          select="$backCoverTopics"/>
      </xsl:call-template>

    </fo:root>
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="text()"/>
  
  <xsl:template name="createCoversAndInitialPages">
    <!-- Template to manage creation of covers and initial pages 
         up to the frontmatter and book lists (ToC, etc.).
         
         Override this template to do things how you want.
    -->
    <xsl:param name="frontCoverTopics"  as="element()*" select="()"/>
    <xsl:param name="backCoverTopics"  as="element()*" select="()"/>

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
    <xsl:param name="backCoverTopics"  as="element()*" select="()"/>
    
    <xsl:variable name="backCoverGraphicUri" as="xs:string">
      <xsl:apply-templates mode="getBackCoverGraphicUri" select="."/>
    </xsl:variable>
    <xsl:call-template name="createBackCover">
      <xsl:with-param name="backCoverGraphicUri" as="xs:string" select="$d4pBackCoverGraphicUri"/>
    </xsl:call-template>
    
  </xsl:template>
  

</xsl:stylesheet>
