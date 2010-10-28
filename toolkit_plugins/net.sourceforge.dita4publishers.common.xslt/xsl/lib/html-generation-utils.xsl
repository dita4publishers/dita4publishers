<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs htmlutil relpath df"  
  version="2.0">
 
  <xsl:import href="dita-support-lib.xsl"/>
  <xsl:import href="relpath_util.xsl"/>
  
  <!-- The strategy to use when constructing output files. Default is "as-authored", meaning
    reflect the directory structure of the topics as authored relative to the root map,
    possibly as reworked by earlier Toolkit steps.
  -->       
 
  <xsl:param name="fileOrganizationStrategy" as="xs:string" select="'as-authored'"/>
  
  <xsl:function name="htmlutil:getTopicResultUrl" as="xs:string">
    <xsl:param name="outdir" as="xs:string"/><!-- Output directory -->
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:sequence select="htmlutil:getTopicResultUrl($outdir, $topicDoc, '')"/>
  </xsl:function>

  <xsl:function name="htmlutil:getTopicResultUrl" as="xs:string">
    <xsl:param name="outdir" as="xs:string"/><!-- Output directory -->
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:param name="rootMapDocUrl" as="xs:string"/>
    
    <xsl:variable name="resultUrl" as="xs:string">
      <xsl:choose>
        <xsl:when test="$fileOrganizationStrategy = 'single-dir' or $rootMapDocUrl = ''">
          <xsl:for-each select="$topicDoc">
            <xsl:call-template name="get-topic-result-url-single-dir">
              <xsl:with-param name="outdir" select="$outdir" as="xs:string"/>    
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$topicDoc">
            <xsl:apply-templates select="." mode="get-topic-result-url">
              <xsl:with-param name="outdir" tunnel="yes" select="$outdir" as="xs:string"/>            
              <xsl:with-param name="rootMapDocUrl" tunnel="yes" select="$rootMapDocUrl" as="xs:string"/>            
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$resultUrl"/>
  </xsl:function>
  
  <xsl:template name="get-topic-result-url-single-dir" match="/">
    <!-- Handle the single-dir file organization strategy.

         Named template allows override of this strategy.
    -->
    <xsl:param name="outdir" as="xs:string"/>
    
    <xsl:variable name="topicHtmlFilename" 
      select="htmlutil:constructHtmlResultTopicFilename(.)" 
      as="xs:string"/>  
    
    <xsl:variable name="resultUrl" select="relpath:newFile($outdir, $topicHtmlFilename)" as="xs:string"/>
    <xsl:sequence select="$resultUrl"/>
  </xsl:template>
  
  <xsl:template mode="get-topic-result-url" match="/">
    <!-- Default file organization strategy: as-authored -->
    <xsl:param name="outdir" as="xs:string" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:variable name="topicDocUri" select="string(document-uri(.))" as="xs:string"/>
    <xsl:variable name="relSourcePath" select="relpath:getRelativePath($rootMapDocUrl, $topicDocUri)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($relSourcePath)" as="xs:string"/>
    <xsl:variable name="baseName" select="relpath:getNamePart(relpath:getName($relSourcePath))" as="xs:string"/>
    <xsl:variable name="resultUrl" 
      select="relpath:newFile(relpath:newFile($outdir, $parentPath), 
                              concat($baseName,$outext))" 
                              as="xs:string"/>
    
    <xsl:sequence select="$resultUrl"/>
    
  </xsl:template>
  
  <xsl:function name="htmlutil:constructHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topic" as="document-node()"/>
    <xsl:variable name="topicFilename" 
      select="concat(htmlutil:getResultTopicBaseName($topic), '.html')" 
      as="xs:string"/>
    <xsl:sequence select="$topicFilename"/>    
  </xsl:function>
  
  <!--
    Construct a reliably-unique base name for result topics that can then be used to
    construct full filenames of different types.
    -->
  <xsl:function name="htmlutil:getResultTopicBaseName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="concat(relpath:getNamePart($topicUri), '_', generate-id($topicDoc))" as="xs:string"/>
    <xsl:sequence select="$baseName"/>
  </xsl:function>

  <xsl:function name="htmlutil:getXmlResultTopicFileName" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:variable name="topicUri" select="string(document-uri(root($topicDoc)))" as="xs:string"/>
    <xsl:variable name="baseName" select="htmlutil:getResultTopicBaseName($topicDoc)" as="xs:string"/>
    <xsl:variable name="ext" select="relpath:getExtension($topicUri)"/>
    <xsl:variable name="fileName" select="concat($baseName, '.', $ext)" as="xs:string"/>
    <xsl:sequence select="$fileName"/>
  </xsl:function>
  
  <xsl:function name="htmlutil:getTopicheadHtmlResultTopicFilename" as="xs:string">
    <xsl:param name="topichead" as="element()"/>
    
    <xsl:variable name="result" select="concat('topichead_', generate-id($topichead), '.html')" as="xs:string"/>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="htmlutil:getInitialTopicrefUri" as="xs:string">
    <!-- Gets the first topic referenced by the first topicref in the list of topicrefs provided. -->
    <xsl:param name="topicRefs" as="element()*"/>
    <xsl:param name="topicsOutputPath" as="xs:string"/>
    <xsl:param name="outdir" as="xs:string"/>
    <xsl:param name="rootMapDocUrl" as="xs:string"/>
    
    
    <xsl:variable name="initialTopicRef" select="$topicRefs[1]" as="element()?"/>
    <xsl:choose>
      <xsl:when test="$initialTopicRef">
        <xsl:variable name="initialTopic" select="df:resolveTopicRef($initialTopicRef)" as="element()?"/>
        <xsl:choose>
          <xsl:when test="$initialTopic">
            <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($topicsOutputPath, root($initialTopic), $rootMapDocUrl)"/>
            <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
            <xsl:sequence select="$relativeUri"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="'failed-to-resolve-initial-topicref'"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'no-initial-topicref'"/>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:function>
  
</xsl:stylesheet>
