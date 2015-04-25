<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Table of Contents generation mode
    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->  
  <xsl:template match="*[df:class(., 'map/map')]" mode="toc">
    <xsl:message> + [INFO] Generating ToC...</xsl:message>
    <div class="table-of-contents">
      <h2>Table of Contents</h2>
      <ul class="toc">
        <xsl:apply-templates mode="#current"/>
      </ul>
    </div>
    <xsl:message> + [INFO] ToC Done.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @processing-role = 'resource-only']" mode="toc"
    priority="10"
    >    
    <!-- Ignore resource-only topicrefs in ToC mode -->
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="toc">
    <li><xsl:sequence select="df:getNavtitleForTopicref(.)"/>
      <xsl:if test="*[df:class(., 'map/topicref')]">
        <ul class="toc">
          <xsl:apply-templates mode="#current"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="toc">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] toc: handling topicref, root(.)/*=<xsl:sequence select="for $e in root(.)/* return (name($e), ' ')"></xsl:sequence></xsl:message>
    </xsl:if>
    <xsl:variable name="targetTopic" select="df:resolveTopicRef(.)" as="element()?"/>
    <xsl:variable name="topicid" as="xs:string"
      select="generate-id($targetTopic)"
    />
    <li><a href="#{$topicid}"><xsl:sequence select="df:getNavtitleForTopicref(.)"/></a>
      <xsl:if test="*[df:class(., 'map/topicref')] | $targetTopic/*[df:class(., 'topic/topic')]">
        <ul class="toc">
          <xsl:choose>
            <xsl:when test="*[df:class(., 'map/topicref')]">
              <xsl:apply-templates mode="#current"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$targetTopic/*[df:class(., 'topic/topic')]" mode="toc"/>
            </xsl:otherwise>
          </xsl:choose>
          
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicGroup(.)]" mode="toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'topic/title')]" mode="toc">
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicmeta')]" mode="toc"/>

  <xsl:template match="*[df:class(., 'topic/topic')]" mode="toc">
    <xsl:variable name="topicid" as="xs:string"
      select="generate-id(.)"
    />
    <li><a href="#{$topicid}"><xsl:sequence select="df:getNavtitleForTopic(.)"/></a>
      <xsl:if test="*[df:class(., 'topic/topic')]">
        <ul>
          <xsl:apply-templates select="*[df:class(., 'topic/topic')]" mode="#current"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="RSUITE:*" mode="toc" priority="2"/>    
  
  
  <xsl:template match="*" mode="toc" priority="-1">    
    <xsl:message> + [DEBUG] dita-tocModePreview: Catch-all in toc mode: <xsl:sequence select="name(.)"/>[class=<xsl:sequence select="string(@class)"/>]</xsl:message>
    <div style="margin-left: 1em;">
      <span style="color: green;">[<xsl:value-of select="if (@class) then @class else concat('No Class Value: ', name(.))"/>{</span><xsl:apply-templates/><span style="color: green;">}]</span>
    </div>
  </xsl:template>
  

  
</xsl:stylesheet>
