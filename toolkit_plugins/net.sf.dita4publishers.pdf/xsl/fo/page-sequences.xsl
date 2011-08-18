<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df"
  version="2.0">

  <!--================================
    
      Page sequence construction
      
      These templates manage the construction
      of the result FO page sequences from
      the merged map and topics.
      ================================-->

  <xsl:template name="constructNavTreePageSequences">
    <!-- Template to manage construction of the page sequences
         that reflect the navigation tree defined in the
         input map.
    -->
    <xsl:param name="frontCoverTopics"  as="element()*" select="()"/>
    <xsl:param name="backCoverTopics"  as="element()*" select="()"/>

    <xsl:apply-templates mode="constructNavTreePageSequences" select="/">
        <xsl:with-param name="frontCoverTopics" as="element()*" 
          select="$frontCoverTopics"
          tunnel="yes"
        />
        <xsl:with-param name="backCoverTopics" as="element()*" 
          select="$backCoverTopics"
          tunnel="yes"
        />
    </xsl:apply-templates>
  </xsl:template>
  

   <xsl:template mode="constructNavTreePageSequences" match="/">
    <xsl:param name="frontCoverTopics"  as="element()*" tunnel="yes"/>
    <xsl:param name="backCoverTopics"  as="element()*"  tunnel="yes"/>
    
    <xsl:variable name="topLevelTopicsOrRefs" as="element()*">
      <xsl:apply-templates mode="getTopLevelTopicsOrRefs" select="/*/opentopic:map/*[contains(@class, ' map/topicref ')]"/>
    </xsl:variable>
    
    <xsl:if test="false()">
      <xsl:message>[DEBUG] constructNavTreePageSequences: topLevelTopicsOrRefs=<xsl:sequence 
        select="for $e in $topLevelTopicsOrRefs return concat(name($e), ' [id=', $e/@id, ']')"/></xsl:message>
    </xsl:if>
     
    <xsl:apply-templates select="$topLevelTopicsOrRefs except $frontCoverTopics | $backCoverTopics" 
      mode="constructNavTreePageSequences"/> 
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates select="."/><!-- Apply normal mode processing -->
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:isTopicRef(.)]">
    <!-- Do list generation here -->
  </xsl:template>
  
  <!-- Bookmap list-generating topicrefs -->
  <xsl:template mode="getTopLevelTopicsOrRefs" 
    match="*[contains(@class, ' bookmap/toc ')] |
           *[contains(@class, ' bookmap/figurelist ')] |
           *[contains(@class, ' bookmap/tablelist ')] |
           *[contains(@class, ' bookmap/glossarylist ')] |
           *[contains(@class, ' bookmap/bibliolist ')] |
           *[contains(@class, ' bookmap/indexlist ')]
    " 
    priority="10">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="getTopLevelTopicsOrRefs" match="*[df:isTopicGroup(.)]" priority="5">
    <xsl:apply-templates mode="#current" select="*[contains(@class, ' map/topicref ')]"/>
  </xsl:template>

  <xsl:template mode="getTopLevelTopicsOrRefs" match="*[df:isTopicRef(.)]">
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', string(@id))[1]"
    />
    <xsl:sequence select="$topic"/>
  </xsl:template>
  
</xsl:stylesheet>
