<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:sld="urn:ns:dita4publishers.org:doctypes:simpleslideset"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  exclude-result-prefixes="xs xd df relpath index-terms htmlutil"
  version="2.0">
  
  <!-- =============================
    

    ============================= -->
  
  <xsl:template match="/*[df:class(., 'map/map')]" mode="generate-slides">
    <sld:simpleslideset>
      <sld:prolog>
        <xsl:apply-templates mode="slide-prolog"/>
      </sld:prolog>
      <sld:styles>
        <xsl:apply-templates mode="slide-styles"/>
      </sld:styles>
      <sld:slides>
        <xsl:apply-templates/>
      </sld:slides>
    </sld:simpleslideset>
    
    
  </xsl:template>
  
  <xsl:template mode="slide-prolog" match="*">
    <!-- FIXME: get stuff here -->
  </xsl:template>
  
  <xsl:template mode="slide-styles" match="*">
    <!-- FIXME: get stuff here -->
  </xsl:template>
  
  
  <xsl:template match="*[df:isTopicHead(.)]">
    <xsl:variable name="label" select="df:getNavtitleForTopicref(.)" as="xs:string"/>    
    
    <sld:slide>
      <sld:title>
        <sld:p style="Title"><xsl:sequence select="$label"/></sld:p>
      </sld:title>
    </sld:slide>  
  </xsl:template>
  
    <xsl:template match="*[df:isTopicRef(.)]">
      <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
      <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
      
      <xsl:if test="false() and $debugBoolean">
        <xsl:message> + [DEBUG] Handling topicref to "<xsl:sequence select="string(@href)"/>" in default mode</xsl:message>
      </xsl:if>
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$topic" mode="#current">
            <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
            <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>    
    </xsl:template>
    
  <xsl:template match="*" priority="-1">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  
  <!-- =============================
       Get map title mode
       
       Processes a map to construct
       the appropriate title string.
       
       ============================= -->
  <xsl:template name="generateMapTitle" mode="getMapTitle" match="/*[df:class(., 'map/map')]">
    <xsl:apply-templates select="if (not(*[df:class(., 'map/title')])) then (@title, *) else  (*)" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="@title">
    <xsl:sequence select="string(.)"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/title')]" mode="getMapTitle">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*[df:class(., 'topic/title')]//*" priority="10">
    <!-- By default, just echo the tags out. -->
    <xsl:copy><xsl:apply-templates mode="#current"/></xsl:copy>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*" priority="-1">
    <!-- Suppress elements that are not the map title or a descendant of the map title. -->
  </xsl:template>


  <xsl:function name="df:getMapTitle" as="node()*">
    <xsl:param name="map" as="element()"/>
    <!-- Gets the map title as a sequence of nodes appropriate for the
         use context, e.g. as a node or edge label.
      -->
    <xsl:variable name="result" as="node()*">
      <xsl:apply-templates select="$map" mode="getMapTitle"/>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
</xsl:stylesheet>