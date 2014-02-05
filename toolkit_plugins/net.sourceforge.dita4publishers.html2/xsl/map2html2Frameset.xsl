<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms"
  version="2.0">
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Frameset generation. This transform generates a frameset that 
    includes the root navigation page and an initial topic.
    
    NOTE: The use of framesets is generally depricated as HTML practice.
    This transform is primarily a convenience for the generation of 
    older DITA-based HTML that used TOCJS and hand-built framesets.
    
    Copyright (c) 2010 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
<!--  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
-->  
  <xsl:output indent="yes" name="frameset" method="html"/>
  

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-frameset">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="firstTopicUri" as="xs:string?" tunnel="yes"/>
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="initialTopicUri"
      as="xs:string"
      select="
      if ($firstTopicUri != '') 
      then $firstTopicUri
      else htmlutil:getInitialTopicrefUri($uniqueTopicRefs, $topicsOutputPath, $outdir, $rootMapDocUrl)
      "
    />
    
    <xsl:variable name="framesetUri" select="concat('frameset', $OUTEXT)"/>
    <xsl:variable name="framesetNavPageUri" select="concat('frameset-nav', $OUTEXT)"/>
    <xsl:variable name="rootPage" select="concat(relpath:getNamePart($inputFileNameParam), $OUTEXT)" as="xs:string"/>
    
    <xsl:message> + [INFO] Generating frameset document <xsl:sequence select="$framesetUri"/>...</xsl:message>
    <xsl:result-document href="{$framesetUri}" format="frameset">
      <html>
        <head>
          <xsl:call-template name="generateMapTitle"/>
          <link rel="stylesheet" type="text/css" href="{relpath:newFile($cssOutputDir,'$csscommonltr.css')}"/>
        </head>
        <frameset cols="30%,*">
          <frame name="tocwin" src="{$framesetNavPageUri}"/>
          <!-- Replace the src= with whatever topic you want to come up first -->
          <frame name="contentwin" src="{$initialTopicUri}"/>
        </frameset>
      </html>
    </xsl:result-document>
    <xsl:message> + [INFO] Frameset document generated.</xsl:message>
    <xsl:message> + [INFO] Generating frameset navigation document <xsl:sequence select="$framesetNavPageUri"/>...</xsl:message>
    <xsl:result-document href="{$framesetNavPageUri}">
      <xsl:apply-templates mode="generate-frameset-nav-page" select="."/>
    </xsl:result-document>
    <xsl:message> + [INFO] Frameset navigation document generated.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-frameset-nav-page">
    
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
        <xsl:apply-templates select="." mode="generate-dynamic-toc-page-markup"/>
        <xsl:apply-templates select="." mode="generate-static-toc"/>
        <xsl:apply-templates select="." mode="generate-dynamic-toc-script-includes"/>      
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>