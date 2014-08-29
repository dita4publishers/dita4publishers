<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  
  exclude-result-prefixes="df xs relpath htmlutil xd"
  version="2.0">
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Root output page (navigation/index) generation. This transform
    manages generation of the root page for the generated HTML.
    It calls the processing to generate navigation structures used
    in the root page (e.g., dynamic and static ToCs).
    
    Copyright (c) 2010 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->  
<!-- 
  <xsl:import href="../../org.dita-community.common.xslt/xsl/dita-support-lib.xsl"/>
  <xsl:import href="../../org.dita-community.common.xslt/xsl/relpath_util.xsl"/>
-->  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-pages">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>

    <xsl:apply-templates select="." mode="generate-root-nav-page"/>
    <xsl:if test="$generateFramesetBoolean">
      <xsl:apply-templates select="." mode="generate-frameset"/>
    </xsl:if>
  </xsl:template>
  
<xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-nav-page">
  <!-- Generate the root output page. By default this page contains the root
       navigation elements. The direct output of this template goes to the
       default output target of the XSLT transform.
    -->
  <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
  <xsl:param name="collected-data" as="element()" tunnel="yes"/>
  <xsl:param name="firstTopicUri" as="xs:string?" tunnel="yes"/>
  <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
  
  <xsl:variable name="initialTopicUri"
    as="xs:string"
    select="
    if ($firstTopicUri != '') 
       then $firstTopicUri
       else htmlutil:getInitialTopicrefUri($uniqueTopicRefs, $topicsOutputPath, $outdir, $rootMapDocUrl)
       "
  />
  
  <html><xsl:sequence select="'&#x0a;'"/>
    <head>
      <xsl:call-template name="generateMapTitle"/><xsl:sequence select="'&#x0a;'"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/><xsl:sequence select="'&#x0a;'"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/><xsl:sequence select="'&#x0a;'"/>
          
      <xsl:if test="string-length($contenttarget)>0 and
        $contenttarget!='NONE'">
        <base target="{$contenttarget}"/><xsl:sequence select="'&#x0a;'"/>
      </xsl:if>
      <!-- initial meta information -->
      
      <!-- Generate stuff for dynamic TOC. Need to parameterize/extensify this -->
      
        <link rel="stylesheet" type="text/css" href="css/reset-html5.css"/><xsl:sequence select="'&#x0a;'"/>
        <link rel="stylesheet" type="text/css" href="css/root-page.css"/><xsl:sequence select="'&#x0a;'"/>
        <link rel="stylesheet" type="text/css" href="css/local/tree.css"/><xsl:sequence select="'&#x0a;'"/>
      
    </head><xsl:sequence select="'&#x0a;'"/>
    
    <body>
      <header>
        <xsl:apply-templates select="." mode="generate-root-page-header"/>
      </header>
      <nav>
        <xsl:apply-templates select="." mode="generate-dynamic-toc"/>
        <xsl:apply-templates select="." mode="generate-static-toc"/>
      </nav>
      <iframe class="contentwin" id="contentwin" name="contentwin" src="{$initialTopicUri}"><xsl:text>&#xa0;</xsl:text></iframe>
    
      <!-- Script includes comes at the end of the body for browser load efficiency:
        -->
      <xsl:apply-templates select="." mode="generate-dynamic-toc-script-includes"/>      
    </body><xsl:sequence select="'&#x0a;'"/>
  </html>  
</xsl:template>
  
  <xsl:template mode="toc-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="titleValue" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$titleValue"/>    
  </xsl:template>
  
  
  <xsl:template name="generateMapTitle">
    <!-- FIXME: Replace this with a separate mode that will handle markup within titles -->
    <!-- Title processing - special handling for short descriptions -->
    <xsl:if test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')] or /*[contains(@class,' map/map ')]/@title">
      <title>
        <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
        <xsl:choose>
          <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
            <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
          </xsl:when>
          <xsl:when test="/*[contains(@class,' map/map ')]/@title">
            <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
          </xsl:when>
        </xsl:choose>
      </title><xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-root-page-header" match="*[df:class(., 'map/map')]">
    <div class="publication-title">
      <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
      <xsl:choose>
        <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
          <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
        </xsl:when>
        <xsl:when test="/*[contains(@class,' map/map ')]/@title">
          <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
        </xsl:when>
      </xsl:choose>      
    </div>
  </xsl:template>
  
</xsl:stylesheet>