<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="http://local/functions"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:dita-ot="http://net.sf.dita-ot"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local dita-ot"
  version="2.0">

  <!--================================
    
      Get top-level topics
      
      The templates in this mode determine which topics
      are top-level within the merged map.
      
      The main purpose of this mode is to not include
      topics in the merged map that reflect topic groups
      (e.g., Bookmap <frontmatter> and <backmatter>).
      
      The topics returned by this mode will then contribute
      to the construction of navigation tree page sequences.
      
      ================================-->

  <!-- Bookmap list-generating topicrefs -->
  <xsl:template mode="getTopLevelTopics" 
    match="*[contains(@class, ' bookmap/toc ')] |
           *[contains(@class, ' bookmap/figurelist ')] |
           *[contains(@class, ' bookmap/tablelist ')] |
           *[contains(@class, ' bookmap/glossarylist ')] |
           *[contains(@class, ' bookmap/bibliolist ')] |
           *[contains(@class, ' bookmap/indexlist ')]
    " 
    priority="10">
<!--    <xsl:message>+ [DEBUG] getTopLevelTopics: matched on bookmap thingy <xsl:sequence select="string(@id)"/></xsl:message>-->
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', string(@id))[1]"
    />
    <xsl:sequence select="$topic"/>
  </xsl:template>
  
  <xsl:template mode="getTopLevelTopics" match="*[df:isTopicGroup(.)]" priority="5">
<!--    <xsl:message>+ [DEBUG] getTopLevelTopics: matched on topic group <xsl:sequence select="string(@id)"/></xsl:message>-->
    <xsl:apply-templates mode="#current" select="*[contains(@class, ' map/topicref ')]"/>
  </xsl:template>

  <xsl:template mode="getTopLevelTopics" match="*[df:isTopicRef(.)]">
<!--    <xsl:message>+ [DEBUG] getTopLevelTopics: matched on topic ref <xsl:sequence select="string(@id)"/></xsl:message>-->
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', string(@id))[1]"
    />
    <xsl:sequence select="$topic"/>
  </xsl:template>
  
  <xsl:template mode="getTopLevelTopics" match="*[df:isTopicHead(.)]">
<!--    <xsl:message>+ [DEBUG] getTopLevelTopics: matched on topic head <xsl:sequence select="string(@id)"/></xsl:message>-->
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', string(@id))[1]"
    />
    <xsl:sequence select="$topic"/>
  </xsl:template>
  
</xsl:stylesheet>
