<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns:glossdata="http://dita4publishers.org/glossdata"
                xmlns:mapdriven="http://dita4publishers.org/mapdriven"
                xmlns:enum="http://dita4publishers.org/enumerables"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum"
  >
  <!-- =============================================================

    DITA Map to rss Transformation

    rss navigation structure generation.

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

  <xsl:template mode="generate-rss-nav-markup" match="*[df:class(., 'map/map')]">

    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    	<xsl:message> + [INFO] Generating rss navigation structure...</xsl:message>

    <xsl:variable name="listItems" as="node()*">
          <xsl:apply-templates mode="generate-rss-nav"
            select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/reltable')]
            )"
          />
        </xsl:variable>
        
        <xsl:if test="$listItems">
            <xsl:sequence select="$listItems"/>
        </xsl:if>
        <xsl:message> + [INFO] rss navigation generation done.</xsl:message>
  </xsl:template>


  <xsl:template mode="generate-rss-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
  </xsl:template>


  <!-- Convert each topicref to a ToC entry. -->
  <xsl:template match="*[df:isTopicRef(.)][not(@toc = 'no')]" mode="generate-rss-nav">
      <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
   	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
   	<xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] generate-rss-nav: Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri" 
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" 
            as="xs:string"/>
          <xsl:variable name="relativeUri" 
            select="relpath:getRelativePath($outdir, $targetUri)" 
            as="xs:string"/>
          <xsl:variable name="self" select="generate-id(.)" as="xs:string"/>

   	<item>
   		<title><xsl:apply-templates select="." mode="nav-point-title"/></title>
        <link><xsl:value-of select="concat($RSSLINK, $RSSDIR, $relativeUri)" /></link>
        <description><xsl:value-of select="$topic/shortdesc" /></description>
        <!--pubDate>Tue, 03 Jun 2003 09:39:21 GMT</pubDate-->
        <guid><xsl:value-of select="concat($RSSLINK, $RSSDIR, $relativeUri)" /></guid>
   	</item>
   	
   	</xsl:otherwise>
   	</xsl:choose>
  </xsl:template>

  <xsl:template match="mapdriven:collected-data" mode="generate-rss-nav">
    <!--xsl:apply-templates mode="#current"/-->
  </xsl:template>

  <xsl:template match="enum:enumerables" mode="generate-rss-nav">
    <!-- Nothing to do with enumerables in this context -->
  </xsl:template>

  <xsl:template match="glossdata:glossary-entries" mode="generate-rss-nav">
    <xsl:message> + [INFO] RSS generation: glossary entry processing not included.</xsl:message>
  </xsl:template>

  <xsl:template match="index-terms:index-terms" mode="generate-rss-nav">
        <xsl:message> + [INFO] RSS generation: glossary entry processing not included.</xsl:message>
  </xsl:template>

  <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" priority="20" mode="generate-rss-nav">
  	 <xsl:apply-templates select="*" mode="#current" />
  </xsl:template>



<xsl:template match="*[df:class(., 'map/linktext')]" mode="generate-rss-nav">

  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-rss-nav">
    <!-- Non-root topics generate ToC entries if they are within the ToC depth -->
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <!-- FIXME: Handle nested topics here. -->
    </xsl:if>
  </xsl:template>

  <xsl:template mode="#all" match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="30"/>
  


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)][not(@toc = 'no')]" mode="generate-rss-nav" priority="20">
		<xsl:apply-templates select="*" mode="#current" />
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>

<!--  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/title')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
-->

  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-rss-nav nav-point-title">

  </xsl:template>

  <xsl:template match="
    *[df:class(., 'topic/topicmeta')] |
    *[df:class(., 'map/navtitle')] |
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/cite')] |
    *[df:class(., 'topic/image')] |
    *[df:class(., 'topic/keyword')] |
    *[df:class(., 'topic/term')]
    " mode="generate-rss-nav">
   
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()" mode="generate-rss-nav">
    
  </xsl:template>

  <xsl:template match="text()" mode="generate-rss-nav"/>

  <xsl:function name="local:isNavPoint" as="xs:boolean">
    <!-- FIXME: Factor this out to a common function library. It's also
         in HTML2 and EPUB code.
      -->
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="$context/@processing-role = 'resource-only'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="df:isTopicRef($context) or df:isTopicHead($context)">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:when test="df:isTopicGroup($context)">
        <xsl:variable name="navPointTitle" as="xs:string*">
          <xsl:apply-templates select="$context" mode="nav-point-title"/>
        </xsl:variable>
        <!-- If topic head has a title (e.g., a generated title), then it
             acts as a navigation point.
          -->
        <xsl:sequence
           select="normalize-space(string-join($navPointTitle, ' ')) != ''"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


</xsl:stylesheet>