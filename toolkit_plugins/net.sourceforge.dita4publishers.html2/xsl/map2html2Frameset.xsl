<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns="http://www.daisy.org/z3986/2005/ncx/"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms"
  version="2.0">
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="html-generation-utils.xsl"/>
  
  <xsl:output indent="yes" name="frameset" method="html"/>
  

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-frameset">
    <xsl:param name="index-terms" as="element()" tunnel="yes"/>
    <!-- FIXME: Provide appropriate parameters and default behavior to find the first
      topic reference in the doc and generate a reference to it. -->
    <xsl:param name="firstTopicUri" as="xs:string?" tunnel="yes"/>
    
    
    <xsl:variable name="effectiveFirstTopicUri" as="xs:string"
      select="if ($firstTopicUri != '') then $firstTopicUri else 'topics/first-topic.html'"
    />
    <xsl:variable name="framesetUri" select="'frameset.html'"/>
    
    <xsl:message> + [INFO] Generating frameset document <xsl:sequence select="$framesetUri"/>...</xsl:message>
    <xsl:result-document href="{$framesetUri}" format="frameset">
      <html>
        <head>
          <xsl:call-template name="generateMapTitle"/>
          <link rel="stylesheet" type="text/css" href="{relpath:newFile($cssOutputDir,'$csscommonltr.css')}"/>
        </head>
        <frameset cols="30%,*">
          <frame name="tocwin" src="root-nav-page.html"/>
          <!-- Replace the src= with whatever topic you want to come up first -->
          <frame name="contentwin" src="{$effectiveFirstTopicUri}"/>
        </frameset>
      </html>
    </xsl:result-document>
    <xsl:message> + [INFO] Frameset document generated.</xsl:message>
  </xsl:template>
  
  

</xsl:stylesheet>