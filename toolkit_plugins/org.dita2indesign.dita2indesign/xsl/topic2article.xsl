<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:local="urn:local-functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df local relpath e2s"
      version="2.0">
  
  <!-- Transform to generate an InCopy article (.incx) from a DITA topic
       
       The mapping of elements to InDesign styles is managed through a separate
       mapping file, which overrides default style names used in a "standard"
       DITA-specific InDesign template. 
       
       Copyright (c) 2009, 2010 DITA2InDesign.org
              
  -->
  
  <xsl:include href="topic2indesignImpl.xsl"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>

  <xsl:template match="/">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] topic2article.xsl: Processing doc root...</xsl:message>
    </xsl:if>
    <xsl:if test="not(/*[1][df:class(., 'topic/topic')])">
      <xsl:message terminate="yes"> + [ERROR] Input document does not appear to be a DITA topic. Got <xsl:sequence
      select="name(/*[1])"/> with @class value "<xsl:sequence
        select="string(/*[1]/@class)"
      /></xsl:message>
    </xsl:if>
    <!-- Using a mode for map processing so topic processing
         can be the default mode for convenience.
    -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'topic/topic')]" priority="10">
    <!-- The topicref that points to this topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] topic2article.xsl: Processing root topic...</xsl:message>
    </xsl:if>
    <xsl:if test="true() and $debugBoolean">
            <xsl:message> + [DEBUG] topic2article.xsl: Style catalog = <xsl:sequence select="$styleCatalog"/></xsl:message>
    </xsl:if>
    <!-- Create a new output InCopy article. 
      
      NOTE: This code assumes that all chunking has been performed
      so that each document-root topic maps to one result
      InCopy article and all nested topics are output as
      part of the same story. This behavior can be
      overridden by providing templates that match on
      specific topic types or output classes.
    -->
   <xsl:call-template name="makeInCopyArticle">
     <xsl:with-param name="styleCatalog" select="$styleCatalog"/>    
     <xsl:with-param name="articleType" select="name(.)" tunnel="yes"/>     
   </xsl:call-template> 
  </xsl:template>
  
  
</xsl:stylesheet>
