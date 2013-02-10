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
    
    Static ToC generation. This transform generates the HTML markup
    for a static table of contents.
    
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
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-static-toc">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:if test="$generateStaticTocBoolean">
      <xsl:message> + [INFO] Generating static table of contents...</xsl:message>
      <div class="static-toc" style="display: none;"><xsl:sequence select="'&#x0a;'"/>
        <xsl:sequence select="'&#x0a;'"/>
        <ul><xsl:sequence select="'&#x0a;'"/>        
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="generate-static-toc"/>
        </ul><xsl:sequence select="'&#x0a;'"/>
      </div><xsl:sequence select="'&#x0a;'"/>    
      <xsl:message> + [INFO] Static table of contents generated.</xsl:message>
    </xsl:if>
  </xsl:template>  
  
  <xsl:template match="*[df:isTopicGroup(.)]" mode="generate-static-toc" priority="10">
    <xsl:apply-templates mode="#current" 
      select="*[df:class(., 'map/topicref')]"/>        
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)][not(@toc = 'no')]" mode="generate-static-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:if test="$tocDepth le $maxTocDepthInt">
      
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      
      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] generate-static-toc: Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="fragId" as="xs:string" 
            select="relpath:getFragmentId(string(@href))"
          />
          <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" as="xs:string"/>
          <xsl:variable name="relativeUri" 
            select="concat(
            relpath:getRelativePath($outdir, $targetUri), 
            if ($fragId != '') 
               then concat('#', $fragId) 
               else '')" as="xs:string"/>
          <li id="{generate-id()}"
            ><a href="{$relativeUri}" target="{$contenttarget}"><xsl:apply-templates select="." mode="enumeration"/>
              <xsl:apply-templates select="." mode="toc-title"/></a>              
            <xsl:if test="($topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')][not(@toc = 'no')]) and
              ($tocDepth lt $maxTocDepthInt)">
              <ul><xsl:sequence select="'&#x0a;'"/>
                <!-- Any subordinate topics in the currently-referenced topic are
                  reflected in the ToC before any subordinate topicrefs.
                -->
                <xsl:apply-templates mode="#current" 
                  select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                  <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                    select="$tocDepth + 1"
                  />
                </xsl:apply-templates>                
              </ul><xsl:sequence select="'&#x0a;'"/>              
            </xsl:if>
          </li><xsl:sequence select="'&#x0a;'"/>
        </xsl:otherwise>
      </xsl:choose>    
    </xsl:if>    
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-static-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <li id="{generate-id()}"><xsl:apply-templates mode="toc-title" select="."/>
        <xsl:if test="(*[df:class(., 'map/topicref')][not(@toc = 'no')]) and
          ($tocDepth lt $maxTocDepthInt)">
          <ul><xsl:sequence select="'&#x0a;'"/>
            <xsl:apply-templates mode="#current" 
              select="*[df:class(., 'map/topicref')]">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                select="$tocDepth + 1"
              />
            </xsl:apply-templates>
          </ul><xsl:sequence select="'&#x0a;'"/>
        </xsl:if>
      </li><xsl:sequence select="'&#x0a;'"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-static-toc">
    <xsl:variable name="navTitle" select="df:getNavtitleForTopic(.)" as="xs:string"/>
    <li><a href="{df:getEffectiveTopicUri(.)}"><xsl:sequence select="$navTitle"/></a>
      <!-- NOTE: This enforces non-inclusion of section elements within TOC. -->
      <xsl:apply-templates select="*[df:class(., 'topic/topic')]" mode="#current"/>
    </li>
  </xsl:template>
  
</xsl:stylesheet>