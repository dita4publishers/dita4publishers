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
  
  <xsl:import href="../lib/dita-support-lib.xsl"/>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="toc">
    <div class="table-of-contents">
      <h2>Table of Contents</h2>
      <ul class="toc">
        <xsl:apply-templates mode="#current"/>
      </ul>
    </div>
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
    <xsl:variable name="targetTopic" select="df:resolveTopicRef(.)" as="element()?"/>
    <xsl:variable name="topicid" as="xs:string"
      select="generate-id($targetTopic)"
    />
    <li><a href="#{$topicid}"><xsl:sequence select="df:getNavtitleForTopicref(.)"/></a>
      <xsl:if test="*[df:class(., 'map/topicref')]">
        <ul class="toc">
          <xsl:apply-templates mode="#current"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicGroup(.)]" mode="toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/title')]" mode="toc">
  </xsl:template>


  <xsl:template match="*" mode="toc">    
    <xsl:message> + [DEBUG] dita-tocModePreview: Catch-all in toc mode: <xsl:sequence select="name(.)"/>[class=<xsl:sequence select="string(@class)"/>]</xsl:message>
    <div style="margin-left: 1em;">
      <span style="color: green;">[<xsl:value-of select="if (@class) then @class else concat('No Class Value: ', name(.))"/>{</span><xsl:apply-templates/><span style="color: green;">}]</span>
    </div>
  </xsl:template>
  

  
</xsl:stylesheet>
