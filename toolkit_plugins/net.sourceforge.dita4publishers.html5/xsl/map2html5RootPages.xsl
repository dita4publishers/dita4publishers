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

    DITA Map to HTML5 Transformation

    Root output page (navigation/index) generation. This transform
    manages generation of the root page for the generated HTML.
    It calls the processing to generate navigation structures used
    in the root page (e.g., dynamic and static ToCs).

    Copyright (c) 2012 DITA For Publishers

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
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-pages">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>

    <xsl:apply-templates select="." mode="generate-root-nav-page"/>
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

  <xsl:variable name="indexUri" select="concat('index', $OUTEXT)"/>

  <xsl:message> + [INFO] Generating index document <xsl:sequence select="$indexUri"/>...</xsl:message>
  <xsl:result-document href="{$indexUri}" format="indented-xml">
  	<!-- I added the right doctype here -->
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
  <html>
  <xsl:attribute name = "lang"><xsl:call-template name="getLowerCaseLang"/></xsl:attribute>
  <xsl:sequence select="'&#x0a;'"/>
    <head>

      <xsl:call-template name="generateMapTitle"/><xsl:sequence select="'&#x0a;'"/>

      <meta charset="utf-8" /><xsl:sequence select="'&#x0a;'"/>

      <meta name="viewport" content="width=device-width, initial-scale=1.0"/><xsl:sequence select="'&#x0a;'"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/><xsl:sequence select="'&#x0a;'"/>

      <!-- initial meta information -->

      <!-- Generate stuff for dynamic TOC. Need to parameterize/extensify this -->

      	<!--
      		Add a single style css and use  @import to load
      	     others CSS. It becomes easier to compress all css afterward with a css compressor such as http://developer.yahoo.com/yui/compressor/
      	     which works well with ant
      	-->
				<xsl:apply-templates select="." mode="generate-css-includes"/>

        <xsl:apply-templates select="." mode="generate-javascript-includes"/>

    </head><xsl:sequence select="'&#x0a;'"/>

    <body>

    	<xsl:attribute name = "class">
    		<xsl:call-template name="getLowerCaseLang"/>
				<xsl:sequence select="'&#160;'"/>
    		<xsl:value-of select="$siteTheme" />
    	</xsl:attribute>

			<div class="container_24">
    		<xsl:sequence select="'&#x0a;'"/>

      	<header role = "banner" aria-labelledby="publication-title">
       	 <xsl:apply-templates select="." mode="generate-root-page-header"/>
     		</header>



      	<!-- This mode generates the navigation structure (ToC) on the
           index.html page, that is, the main navigation structure.
        -->
     	 <xsl:apply-templates select="." mode="generate-html5-nav-page-markup"/>

      	<div id="main-content" role="main">
        	<xsl:attribute name="class">
        		grid_18
        		<xsl:sequence select="'&#160;'"/>
        		push_1
        	</xsl:attribute>


        </div>

				<div class="clear" /><xsl:sequence select="'&#x0a;'"/>

				<footer role="contentinfo">

					<!-- Examples of information included in this region of the page are copyrights and links to privacy statements.-->


				</footer><xsl:sequence select="'&#x0a;'"/>

			</div>
    </body><xsl:sequence select="'&#x0a;'"/>
  </html>
  </xsl:result-document>
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
    <h1 id="publication-title">
      <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
      <xsl:choose>
        <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
          <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
        </xsl:when>
        <xsl:when test="/*[contains(@class,' map/map ')]/@title">
          <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
        </xsl:when>
      </xsl:choose>
    </h1>
  </xsl:template>

  <xsl:template match="*" mode="generate-javascript-includes">
    <!-- FIXME: Parameterize the location of the JavaScript -->
    <script src="assets/script.js" type="text/javascript">&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
  </xsl:template>

  <xsl:template match="*" mode="generate-css-includes">
    <!-- FIXME: Parameterize the location of the css -->
		<link rel="stylesheet" type="text/css" href="assets/style.css"/><xsl:sequence select="'&#x0a;'"/>
    <link rel="stylesheet" type="text/css" >
    	<xsl:attribute name = "href">
    	 	<xsl:apply-templates select="." mode="get-css-theme-path"/>
    	</xsl:attribute>
    </link>
    <xsl:sequence select="'&#x0a;'"/>
  </xsl:template>

  <xsl:template match="*" mode="get-css-theme-path">assets/<xsl:value-of select="$siteTheme" />/style.css</xsl:template>

</xsl:stylesheet>