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
 
  <!-- xmlns="http://www.w3.org/1999/xhtml" --> 
  <!-- Generates HTML ePub content from a DITA map.
    
  -->
  
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
    <xsl:apply-templates mode="#current"/>
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
        <xsl:apply-templates select="$topic" mode="#current">
          <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-content">
    <!-- This template generates the output file for a referenced topic.
      -->
    <!-- The topicref that referenced the topic -->
    <xsl:param name="topicref" as="element()" tunnel="yes"/>
    
    <xsl:variable name="resultUri" select="epubutil:getTopicResultUrl($topicsOutputPath, .)" as="xs:string"/>
    <xsl:message> + [INFO] Writing result HTML file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
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
