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
    
    DITA Map to HTML Transformation: Content Generation Module
    
    Copyright (c) 2010 DITA For Publishers
    
    This module generates output HTML files for each topic referenced
    from the incoming map.
    
    Because all the HTML files are output to a single directory, this
    process generates unique (and opaque) filenames for the result
    HTML files. [It would be possible, given more effort, to generate
    distinct names that reflected the original filenames but it doesn't
    appear to be worth the effort.]
    
    The output generation template logs messages that show the
    source-to-result mapping to make it easier to debug issues
    with the generated topics.
    
    =============================================================  -->
<!--  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  -->
  <xsl:output name="topic-html"
    method="xhtml"
    encoding="UTF-8"
    indent="no"
  />
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-content">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating content...</xsl:message>
    
    <xsl:if test="false() and $debugBoolean">    
      <xsl:message> + [DEBUG] ------------------------------- 
        + [DEBUG] Unique topics:      
        <xsl:for-each select="$uniqueTopicRefs">
          + [DEBUG] <xsl:sequence select="name(.)"/>: generated id="<xsl:sequence select="generate-id(.)"/>", URI=<xsl:sequence select="document-uri(root(.))"/>                
        </xsl:for-each>
        + [DEBUG] -------------------------------    
      </xsl:message>
    </xsl:if>    
    <xsl:apply-templates select="$uniqueTopicRefs" mode="generate-content"/>
    <xsl:message> + [INFO] Generating title-only topics for topicheads...</xsl:message>
    <xsl:apply-templates select=".//*[df:isTopicHead(.)]" mode="generate-content"/>
    <xsl:message> + [INFO] Content generated.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-content">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Handling topichead "<xsl:sequence select="df:getNavtitleForTopicref(.)"/>" in mode generate-content</xsl:message>
    </xsl:if>
    <xsl:variable name="topicheadFilename" as="xs:string"
      select="normalize-space(htmlutil:getTopicheadHtmlResultTopicFilename(.))" />
    <xsl:variable name="generatedTopic" as="document-node()">
      <xsl:document>
        <topic id="{relpath:getNamePart($topicheadFilename)}"
          xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
          ditaarch:DITAArchVersion="1.2"
          domains="(topic topic)"
          >
          <xsl:attribute name="class"
            select="$titleOnlyTopicClassSpec"
          />
          <title>
            <xsl:attribute name="class"
              select="$titleOnlyTopicTitleClassSpec"
            />
            <xsl:sequence select="df:getNavtitleForTopicref(.)"/></title>
        </topic>
      </xsl:document>
    </xsl:variable>
    <xsl:apply-templates select="$generatedTopic" mode="generate-content">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="yes"/>
      <xsl:with-param name="resultUri" select="relpath:newFile($topicsOutputPath, $topicheadFilename)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-content">
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Handling topicref to "<xsl:sequence select="string(@href)"/>" in mode generate-content</xsl:message>
    </xsl:if>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] generate-content: Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="topicResultUri" 
          select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)"
          as="xs:string"
        />
        <xsl:variable name="tempTopic" as="document-node()">
          <xsl:document>
            <xsl:apply-templates select="$topic" mode="href-fixup">
              <xsl:with-param name="topicResultUri" select="$topicResultUri"
                tunnel="yes"/>              
            </xsl:apply-templates>
          </xsl:document>
        </xsl:variable>
        <xsl:apply-templates select="$tempTopic" mode="#current">
          <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
          <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
          <xsl:with-param name="resultUri" select="$topicResultUri"
            tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*" mode="generate-content" priority="-1">
    <xsl:message> + [DEBUG] In catchall for generate-content, got 
      <xsl:sequence select="."/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-content">
    <!-- This template generates the output file for a referenced topic.
    -->
    <!-- The topicref that referenced the topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>    
    <!-- Enumerables structure: -->
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <!-- Result URI to which the document should be written. -->
    <xsl:param name="resultUri" as="xs:string" tunnel="yes"/>
    
    <xsl:message> + [INFO] Writing topic <xsl:sequence select="base-uri(root(.))"/> to HTML file "<xsl:sequence 
      select="$resultUri"/>"...</xsl:message>
    <xsl:variable name="htmlNoNamespace" as="node()*">
      <xsl:apply-templates select="." mode="map-driven-content-processing" >
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
      </xsl:apply-templates>      
    </xsl:variable>
    <xsl:result-document format="topic-html" href="{$resultUri}" >
      <xsl:apply-templates select="$htmlNoNamespace" mode="no-namespace-html-post-process">
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
        <xsl:with-param name="resultUri" select="$resultUri" as="xs:string" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template mode="no-namespace-html-post-process" match="html">
    <!-- Default post-processing for HTML: just copy input back to the output -->
    <xsl:apply-templates select="." mode="html-identity-transform"/>
  </xsl:template>
  
  
  <xsl:template match="*[df:class(., 'topic/topic')]" priority="100" mode="map-driven-content-processing">
    <!-- This template is a general dispatch template that applies
      templates to the topic in a distinct mode so processors
      can do topic output processing based on the topicref context
      if they want to. -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <xsl:choose>
      <xsl:when test="$topicref">
        <xsl:apply-templates select="$topicref" mode="topicref-driven-content">
          <xsl:with-param name="topic" select="." as="element()?"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- Do default processing -->
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="topicref-driven-content" match="*[df:class(., 'map/topicref')]">
    <!-- Default topicref-driven content template. Simply applies normal processing
      in the default context to the topic parameter. -->
    <xsl:param name="topic" as="element()?"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] topicref-driven-content: topicref="<xsl:sequence select="name(.)"/>, class="<xsl:sequence select="string(@class)"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="topicref" select="." as="element()"/>
    <xsl:for-each select="$topic">
      <!-- Process the topic in the default mode, meaning the base Toolkit-provided
        HTML output processing.
        
        By providing the topicref and collected data as a tunneled parameters
        it makes them available to custom extensions to the base Toolkit processing.
      -->
      <xsl:apply-templates select="." >
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="
    *[df:class(., 'topic/body')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/shortdesc')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/abstract')]//*[df:class(., 'topic/indexterm')]
    "
    priority="10"
    >
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Found an index item in topic content: [<xsl:sequence select="string(.)"/>]</xsl:message>
    </xsl:if>
    <a id="{generate-id()}" class="indexterm-anchor"/>
  </xsl:template>
  
  <!-- NOTE: the body of this template is taken from the base dita2xhtmlImpl.xsl 
   
       This should only be applied to root topics so that chunk to-content does
       not result in the same topicref being used for non-child topics and thus
       resulting in incorrect enumeration logic.
  -->
  <xsl:template match="*[df:class(., 'topic/topic')][parent::dita or count(parent::*) = 0]/*[df:class(., 'topic/title')]">
    <xsl:param name="topicref" select="()" as="element()?" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <xsl:param name="headinglevel">
      <xsl:choose>
        <xsl:when test="count(ancestor::*[contains(@class,' topic/topic ')]) > 6">6</xsl:when>
        <xsl:otherwise><xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:variable name="htmlClass"  select="concat('topictitle', $headinglevel)" as="xs:string"/>
    <xsl:element name="h{$headinglevel}">
      <xsl:attribute name="class" select="$htmlClass"/>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$htmlClass" as="xs:string"/>      
      </xsl:call-template>
      <xsl:apply-templates select="$topicref" mode="enumeration"/>
      <xsl:apply-templates/>
    </xsl:element>    
  </xsl:template>  
  
  <!-- Enumeration mode manages generating numbers from topicrefs -->
  <xsl:template match="* | text()" mode="enumeration">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] enumeration: catch-all template. Element="<xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-content"/>
  
  <xsl:template match="*[df:class(., 'map/topicmeta')]" priority="10"/>
  
</xsl:stylesheet>
