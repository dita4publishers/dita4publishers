<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="df xs relpath htmlutil xd dc"
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
  <xsl:output name="indented-xml" method="xml" indent="yes" omit-xml-declaration="yes"/>

  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-pages">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>

    <xsl:apply-templates select="." mode="generate-root-nav-page"/>
  </xsl:template>

  <!-- generate root pages -->
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

  <xsl:variable name="indexUri" select="concat($FILENAME, $RSSEXT)"/>

  <xsl:message> + [INFO] Generating index document <xsl:sequence select="$indexUri"/>...</xsl:message>
  
  <xsl:result-document href="{$indexUri}" format="indented-xml">

      <xsl:apply-templates select="." mode="generate-rss"/>
  
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
  
  <!-- generate RSS version 2.0 -->
  <!-- @see http://www.rssboard.org/rss-specification -->
  <xsl:template match="*" mode="generate-rss">
    <rss version="2.0">
      
      <channel>
      	<!-- required elements -->
      	<xsl:call-template name="generateMapTitle" />
      	
      	<link><xsl:value-of select="$RSSLINK" /></link>
      	
      	<description><xsl:value-of select="/map/topicmeta/shortdesc" /></description>
      	
      	<!-- optional -->
      	<xsl:variable name="lang">
      		<xsl:call-template name="getLowerCaseLang"/>
      	</xsl:variable>
      	
      	<xsl:if test="$lang!=''">
      		<language><xsl:value-of select="$lang" /></language>
      	</xsl:if>
      	
      	<xsl:if test="$PUBDATE!=''">
      		<pubDate><xsl:value-of select="$PUBDATE" /></pubDate>
      		<lastBuildDate><xsl:value-of select="$PUBDATE" /></lastBuildDate>
      	</xsl:if>
      	
      	<xsl:if test="$TTL!=''">
      		<ttl><xsl:value-of select="$TTL" /></ttl>
      	</xsl:if>
      	
      	<generator>dita4publishers</generator>
      	
      	<xsl:if test="$MANAGINGEDITOR!=''">
      		<managingEditor><xsl:value-of select="$TTL" /></managingEditor>
      	</xsl:if>
      	
      	 <xsl:if test="$WEBMASTER!=''">
      		<webMaster><xsl:value-of select="$TTL" /></webMaster>
      	</xsl:if>
      	<xsl:message> ++ name: <xsl:value-of select="name(.)" /></xsl:message>
        <xsl:apply-templates select="." mode="generate-rss-nav-markup"/>
      </channel>
    </rss>
  </xsl:template>  
  

</xsl:stylesheet>