<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  
  exclude-result-prefixes="df xs relpath epubutil opf dc xd"
  version="2.0">
  <!-- =============================================================
    
    DITA Map to ePub Transformation: Content Generation Module
    
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
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  <xsl:import href="epub-generation-utils.xsl"/>
    
  <xsl:output name="topic-html"
    method="xhtml"
    encoding="UTF-8"
    indent="yes"
  />
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-content">
    <xsl:message> + [INFO] Generating content...</xsl:message>
    <xsl:for-each-group select=".//*[df:isTopicRef(.)]"
       group-by="generate-id(df:resolveTopicRef(.))"
      >     
      <xsl:apply-templates select="current-group()[1]" mode="generate-content"/>
    </xsl:for-each-group>
    <xsl:message> + [INFO] Content generated.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-content">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] Handling topicref to "<xsl:sequence select="string(@href)"/>" in mode generate-content</xsl:message>
    </xsl:if>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="tempTopic" as="document-node()">
          <xsl:message> + [DEBUG] Applying href fixup processing...</xsl:message>
          <xsl:document>
            <xsl:apply-templates select="$topic" mode="href-fixup"/>
          </xsl:document>
          <xsl:message> + [DEBUG] Href fixup processing done.</xsl:message>
        </xsl:variable>
        <xsl:apply-templates select="$tempTopic" mode="#current">
          <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
          <xsl:with-param name="resultUri" select="epubutil:getTopicResultUrl($topicsOutputPath, $topic)"
           tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-content">
    <!-- This template generates the output file for a referenced topic.
      -->
    <!-- The topicref that referenced the topic -->
    <xsl:param name="topicref" as="element()" tunnel="yes"/>    
    <!-- Result URI to which the document should be written. -->
    <xsl:param name="resultUri" as="xs:string" tunnel="yes"/>
    
    <xsl:message> + [INFO] Writing topic <xsl:sequence select="document-uri(root(.))"/> to HTML file "<xsl:sequence select="relpath:newFile($topicsOutputDir, relpath:getName($resultUri))"/>"...</xsl:message>
    <xsl:variable name="htmlNoNamespace" as="node()*">
      <xsl:apply-templates select="."/>      
    </xsl:variable>
    <xsl:result-document format="topic-html" href="{$resultUri}" exclude-result-prefixes="opf">
      <xsl:apply-templates select="$htmlNoNamespace" mode="html2xhtml"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-content"/>
  
  <xsl:template match="*[df:class(., 'map/topicmeta')]" priority="10"/>
  
</xsl:stylesheet>
