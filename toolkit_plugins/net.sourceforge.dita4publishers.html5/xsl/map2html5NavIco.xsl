<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath" xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven" xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum">
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    HTML5 navigation structure generation.

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= -->


  <xsl:template mode="generate-html5-nav-ico-markup" match="*[df:class(., 'map/map')]">

    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:variable name="listItems" as="node()*">
      <xsl:apply-templates mode="generate-html5-ico-nav"
        select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/relicole')]    
            )"
      />
    </xsl:variable>

    <xsl:variable name="listItemsContent" as="node()*">
      <xsl:apply-templates mode="generate-html5-tabbed-nav-content"
        select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/relicole')]
            )"
      />
    </xsl:variable>


    <div id="doc-content" class="span-23 prepend-1 last">
     	<div id="local-navigation">
     		<h1><xsl:call-template name="map-title" /></h1>
        	<xsl:sequence select="'&#x0a;'"/>
        	<xsl:sequence select="$listItems"/>
        	<div class="clear"/>
		</div>
      <div id="content-container">
        <xsl:sequence select="$listItemsContent"/>
      </div>
    </div>
    <div class="clear"/>
  </xsl:template>

  <!-- icos header -->
  <xsl:template match="*" mode="ico-toc">
     	<xsl:variable name="id">
  			<xsl:choose>
  				<xsl:when test="@id!=''">
  					<xsl:value-of select="@id"/>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:value-of select="generate-id(.)"/>
  				</xsl:otherwise>
  			</xsl:choose>
  		</xsl:variable>
  		
  		<xsl:variable name="count" as="xs:integer"><xsl:number count="topichead"/></xsl:variable>
  		
  		<xsl:variable name="isLast">
  			<xsl:choose>
  				<xsl:when test="$count mod 6 = 0">
  					<xsl:value-of select="' last'"/>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:value-of select="' append-1'"/>
  				</xsl:otherwise>
  			</xsl:choose>
  		</xsl:variable>
  		
      	<div id="{$id}" class="{concat('box box-ico square span-3', $isLast)}">
      	
      	<!-- {count(preceding-sibling::*) + 1} -->
      		<a href="{concat('#tab-', $count)}">
        		<xsl:apply-templates select="." mode="nav-point-title"/>
        	</a>
        </div>
     
  </xsl:template>
  
  
  <!-- icos content -->
  <xsl:template match="*" mode="ico-ico-content">
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    
    <xsl:variable name="items" as="node()*">
      <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
        -->
      <xsl:apply-templates mode="html5-blocks"
        select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
        
        <xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1"/>
      </xsl:apply-templates>
    </xsl:variable>
       
    <div id="ico-{count(preceding-sibling::*) + 1}">
      <xsl:if test="$items">
        <xsl:sequence select="$items"/>
      </xsl:if>
    </div>
    
  </xsl:template>
  
 

  <xsl:template name="html5-ico-content-block">
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="id" as="xs:string" tunnel="yes" select="''"/>
    <xsl:param name="relativeUri" as="xs:string" tunnel="yes" select="''"/>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

    <h2>
      <xsl:apply-templates select="." mode="nav-point-title"/>
    </h2>

  </xsl:template>


  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/body')]" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>



  <!-- 
  		Templates for ico headers -->
  <xsl:template mode="generate-html5-ico-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]"> </xsl:template>
  
    <xsl:template mode="generate-html5-ico-nav" match="*[df:class(., 'topic/meta')]" />


  <xsl:template mode="generate-html5-ico-nav" match="*[df:isTopicRef(.)][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="ico-toc"/>
  </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="mapdriven:collected-data"> </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="enum:enumerables"> </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="glossdata:glossary-entries"> </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="index-terms:index-terms"> </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="*[df:isTopicGroup(.)]" priority="20">
    <xsl:apply-templates select="." mode="ico-toc"/>
  </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="*[df:class(., 'topic/topic')][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="ico-toc"/>
  </xsl:template>

  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template mode="generate-html5-ico-nav" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="ico-toc"/>
  </xsl:template>

  <xsl:template mode="generate-html5-ico-nav" match="*[df:isTopicHead(.)][@toc = 'no']"> </xsl:template>

  

</xsl:stylesheet>
