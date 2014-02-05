<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      xmlns:RSUITE="http://www.reallysi.com"
      exclude-result-prefixes="xs local df relpath incxgen e2s RSUITE"
      version="2.0">
  
  <!-- Topic to INX Transformation.
    
       Into one or more InCopy (INCX) articles.
       
       This module handles the base (topic.mod) types. 
       Specialization modules should add their own
       XSL modules as necessary.
       
       Copyright (c) 2009, 2012 DITA2InDesign Project
       
  -->
<!--  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
-->  
  <xsl:import href="lib/incx_generation_util.xsl"/>
  
  <xsl:import href="elem2styleMapper.xsl"/>
  <xsl:include href="topic2inlineContentImpl.xsl"/>
  <xsl:include href="calstbl2indesignImpl.xsl"/>
  
  <!-- Directory, relative to result InDesign document, that
    contains linked articles:
  -->
  <!-- Doesn't need to be specified when the topic is being
       generated in isolation, only for generation from
       map-based processing.
    -->
  <xsl:param name="outputPath" as="xs:string" select="''"/>
  <xsl:param name="linksPath" as="xs:string" select="'links'"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output name="incx" 
    indent="no" 
    cdata-section-elements="GrPr" />
  
  <xsl:template match="dita">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'topic/topic')] | /dita/*[df:class(., 'topic/topic')]" priority="5">
    <!-- The topicref that points to this topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:message> + [DEBUG] topic2IndesignImpl.xsl: Processing root topic</xsl:message>
    <!-- Create a new output InCopy article. 
      
      NOTE: This code assumes that all chunking has been performed
      so that each document-root topic maps to one result
      InCopy article and all nested topics are output as
      part of the same story. This behavior can be
      overridden by providing templates that match on
      specific topic types or output classes.
    -->
    
    <xsl:variable name="articleUrl" as="xs:string"
      select="local:getArticleUrlForTopic(.)"
    />
    <xsl:variable name="articlePath" as="xs:string"
      select="relpath:newFile($outputPath, $articleUrl)"
    />
    <xsl:variable name="effectiveArticleType" as="xs:string"
      select="if ($articleType) then $articleType else name(.)"
    />
    <xsl:message> + [DEBUG] effectiveArticleType="<xsl:sequence select="$effectiveArticleType"/>"</xsl:message>
    <xsl:message> + [INFO] Generating InCopy article "<xsl:sequence select="$articlePath"/>"</xsl:message>
    
    <xsl:result-document href="{$articlePath}" format="incx">
      <xsl:call-template name="makeInCopyArticle">
        <xsl:with-param name="styleCatalog" select="$styleCatalog"/>
        <xsl:with-param name="articleType" select="$effectiveArticleType" as="xs:string" tunnel="yes"/>
      </xsl:call-template>
    </xsl:result-document>    
  </xsl:template>
  
  <xsl:template name="makeInCopyArticle">
    <xsl:param name="styleCatalog"/>
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="leadingParagraphs" as="node()*"/>
    <xsl:param name="trailingParagraphs" as="node()*"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeInCopyArticle: Article type is "<xsl:sequence select="$articleType"/>"</xsl:message>
    </xsl:if>
    
    <xsl:variable name="effectiveContents" as="node()*"
      select="
      if (count($content) gt 0)
        then $content
        else ./node()
      "
    />
    
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">style="33" type="snippet" DOMVersion="5.0" readerVersion="4.0" featureSet="513" product="5.0(640)"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">SnippetType="InCopyInterchange"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <SnippetRoot><xsl:text>&#x0a;</xsl:text>
      <!-- Insert style catalog -->
      <xsl:apply-templates select="$styleCatalog/*" mode="generateStyles"/>
      <!-- Create the "story" for the topic contents: -->
      <cflo Self="rc_{generate-id(.)}"><xsl:text>&#x0a;</xsl:text>
        <!-- include XMP:
          
          The XML metadata should include at least the topic
          title, if not the author and any copyright information
          in the topic.
        -->
        <cMep Self="{ concat('rc_',generate-id(), 'xmp') }">
          <pcnt>
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates mode="XMP" select="/*"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
          </pcnt>
        </cMep>
        <!-- Core content elements go here -->
        <xsl:sequence select="$leadingParagraphs"/>
        <xsl:apply-templates select="$effectiveContents"/>
        <xsl:sequence select="$trailingParagraphs"/>
        <!-- Tables: -->
        <xsl:apply-templates 
          select="
          $effectiveContents//*[df:class(., 'topic/table')] |
          $effectiveContents//*[df:class(., 'topic/simpletable')]
          " 
          mode="tables"/>
        <!-- Images: -->
        <xsl:apply-templates select="$effectiveContents//*[df:class(., 'topic/image')]" mode="images"/>
        <!-- Change tracking notes: -->
        <!-- <xsl:apply-templates select="//foo" mode="makeChngNotes"/> -->
        <!-- Notes: -->
        <xsl:apply-templates select="$effectiveContents//*[df:class(., 'topic/draftcomment')]" mode="makeNotes"/>
      </cflo><xsl:text>&#x0a;</xsl:text>
      
    </SnippetRoot>    
    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/related-links')]">
    <!-- Suppress by default -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/table') or df:class(., 'topic/simpletable')]">
    <!-- Char="16" Self="rc_u643cinsfbb" -->
    <xsl:processing-instruction name="aid">Char="16" Self="rc_<xsl:value-of select="generate-id(.)"/>Anchor"</xsl:processing-instruction>  
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/image')]">
    <xsl:message> + [DEBUG] (default mode): handling topic/image</xsl:message>
    <xsl:processing-instruction name="aid">Char="fffc" Self="rc_<xsl:value-of select="generate-id(.)"/>Anchor"</xsl:processing-instruction>  
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/image')]" mode="images">
    <xsl:message> + [DEBUG] (mode images): handling topic/image</xsl:message>
    <xsl:variable name="linkUri"
      select="
      if (starts-with(@href, 'file:') or starts-with(@href, 'http:'))
         then string(@href)
         else relpath:newFile(relpath:getParent(relpath:base-uri(.)),string(@href))
      "
      as="xs:string"
    />
    <xsl:message> + [DEBUG] (mode images): linkUri="<xsl:sequence select="$linkUri"/>"</xsl:message>
    <!-- NOTE: This geometry is totally bogus: it's just copied from a sample
      that worked. Probably not worth trying to generate usable
      geometry at this point.
    -->
    <crec sTtl="k_" 
      IGeo="x_19_l_1_l_4_l_2_D_-71.52_D_-108_l_2_D_-71.52_D_108_l_2_D_71.52_D_108_l_2_D_71.52_D_-108_b_f_D_-71.52_D_-108_D_71.52_D_108_D_1_D_0_D_0_D_1_D_71.52_D_-108" 
      cntt="e_grpt" 
      STof="ro_{concat(generate-id(), 'Anchor')}" 
      Self="rc_{generate-id()}">
      <imag IGeo="x_f_l_0_D_0_D_0_D_143.04_D_216_D_1_D_0_D_0_D_1_D_-71.52_D_-108_D_0_D_0_D_143.04_D_216" 
        Self="rc_{concat(generate-id(),'Image')}">
        <!-- NOTE: The LnkI= attribute is required in order to create a working link but generating
                   that value is pretty much beyond the ability of XSLT. Need to look at the 
                   link generation code in the RSI INX Utils library to see how best to do this.
                   It may require integrating that library with XSLT.
          -->
        <clnk 
          lURI="rc_{replace($linkUri, '_','~sep~')}" 
          Self="rc_{concat(generate-id(),'Link')}"/>
      </imag>
    </crec>
  </xsl:template>
  
  <xsl:template match="text() | *" mode="XMP"/><!-- Suppress everything by default in XMP mode -->

  <xsl:template match="*[df:class(., 'topic/lq')]">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="df:hasBlockChildren(.)">
        <!-- FIXME: Handle any non-empty text before the first paragraph -->
         <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makeBlock-cont">
          <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/fig')]">
    <!-- Override this template to put the title before or after the 
         figure content.
      -->
    <xsl:apply-templates select="*[df:class(., 'topic/title')]"/>
    <xsl:apply-templates select="*[not(df:class(., 'topic/title'))]"/>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/section')]">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:if test="@spectitle">
      <xsl:call-template name="makeBlock-cont">
        <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        <xsl:with-param name="content" as="text()">
          <xsl:value-of select="@spectitle"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/dt')] |
    *[df:class(., 'topic/title')]
    ">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <!-- Elements that are not inherently block elements but are rendered as 
         blocks by default.
      -->
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/li')] |
    *[df:class(., 'topic/dd')]
    ">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <!-- FIXME: For LI, LQ, DD, etc., need general logic for handling
                as single block, sequence of blocks, or blocks preceded
                by mixed content.
      -->
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="*[df:isBlock(.)]" priority="-0.5">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(.,$articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/prolog')]
    ">
    <!-- Ignored in default mode -->
  </xsl:template>
    
  <xsl:template 
    match="
    *[df:class(., 'topic/div')] |
    *[df:class(., 'topic/bodydiv')] |
    *[df:class(., 'topic/sectiondiv')] 
    ">    
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:choose>
      <xsl:when test="text()">
        <xsl:call-template name="makeBlock-cont">
          <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        </xsl:call-template>        
      </xsl:when>
      <xsl:otherwise><!-- No direct text, just apply templates -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/body')] |
    *[df:class(., 'topic/ul')] |
    *[df:class(., 'topic/ol')] |
    *[df:class(., 'topic/dl')] |
    *[df:class(., 'topic/dlentry')]
    ">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="constructManifestFileEntry">
    <xsl:param name="incopyFileUri" as="xs:string"/>
    <file uri="{$incopyFileUri}"/>&#x0020;
  </xsl:template>
  
  <xsl:template match="RSUITE:*" mode="#all" priority="10"/><!-- Ignore in all modes -->
    
  <xsl:template match="*" mode="result-docs">
    <!--
    <xsl:message> + [DEBUG] topic2article.xsl: in result-docs catch-all: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/>.</xsl:message>
    -->
    <xsl:apply-templates mode="#current" select="*"/>
  </xsl:template>
  
  <xsl:template mode="#default" match="*" priority="-1">
    <xsl:message> + [WARNING] topic2indesignImpl (default mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence 
      select="concat(name(.), ' [', normalize-space(@class), ']')"/></xsl:message>
  </xsl:template>
  
  
  <xsl:function name="local:getArticleUrlForTopic" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="topicFilename" select="relpath:getNamePart(document-uri(root($context)))" as="xs:string"/>
<!--    <xsl:variable name="articleUrl" select="concat($linksPath, '/', $topicFilename, '.incx')" as="xs:string"/>
-->  
    <xsl:variable name="articleUrl" select="concat($topicFilename, '.incx')" as="xs:string"/>
    <xsl:sequence select="$articleUrl"/>
  </xsl:function>
  
</xsl:stylesheet>
