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
  xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  exclude-result-prefixes="
      opentopic-index opentopic opentopic-i18n 
      opentopic-func xs xd relpath df local dita-ot-pdf ot-placeholder"
  version="2.0">

  <!--================================
    
      Function library
      

      Defines functions specific to the 
      PDF transformation type.
      ================================-->
  
  <xsl:function name="dita-ot-pdf:determineTopicType" as="xs:string">
    <!-- Convenience function that delegates to the determineTopicType named template. -->
    <xsl:param name="context" as="element()"/>
    
    <xsl:variable name="topicType">
      <xsl:for-each select="$context">
        <xsl:call-template name="determineTopicType"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$topicType"/>
  </xsl:function>  

  <!--=================================================
    Generic functions specific to the PDF processing
    ================================================= -->
  
  <xsl:function name="dita-ot-pdf:getTopicrefForTopic" as="element()?">
    <xsl:param name="topicElem" as="element()"/>
    
    <xsl:variable name="topicrefId" as="xs:string"
      select="string($topicElem/@id)" 
    />
    <!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicrefId="<xsl:sequence select="$topicrefId"/></xsl:message>-->
    
    <xsl:variable name="topicref" as="element()?"
      select="key('topicRefsById', $topicrefId, root($mergedDoc))"
    />
    <!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicref="<xsl:sequence select="name($topicref)"/></xsl:message>-->
    <xsl:sequence select="$topicref"/>
  </xsl:function>
  
  <xsl:function name="dita-ot-pdf:getNearestTopicrefForTopic" as="element()?">
    <!-- Get the topicref that points to the topic or its nearest ancestor
         for which there is a topicref.
      -->
    <xsl:param name="topicElem" as="element()"/>
    <xsl:variable name="directTopicref" as="element()?"
      select="dita-ot-pdf:getTopicrefForTopic($topicElem)"
    />
    <xsl:variable name="topicref" as="element()?"
    >
      <xsl:choose>
        <xsl:when test="$directTopicref">
          <xsl:sequence select="$directTopicref"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="topicrefs" as="element()*"
            select="for $e in $topicElem/ancestor-or-self::*[df:class(., 'topic/topic')]
                        return dita-ot-pdf:getTopicrefForTopic($e)
            "
          />
          <xsl:sequence select="$topicrefs[last()]"></xsl:sequence>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$topicref"/>
  </xsl:function>
  
  <xsl:function name="dita-ot-pdf:getTopicForId" as="element()?">
    <xsl:param name="topicId" as="xs:string"/>
    
    <!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicrefId="<xsl:sequence select="$topicrefId"/></xsl:message>-->
    
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', $topicId, root($mergedDoc))"
    />
    <!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicref="<xsl:sequence select="name($topicref)"/></xsl:message>-->
    <xsl:sequence select="$topic"/>
  </xsl:function>
  
  <xsl:function name="dita-ot-pdf:getPublicationRegion" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="topicref" select="dita-ot-pdf:getNearestTopicrefForTopic($context)" as="element()?"/>
    
    <xsl:variable name="pubRegion" as="xs:string?">
      <xsl:apply-templates select="($topicref, $context)[1]" mode="getPublicationRegion"/>
    </xsl:variable>
    <xsl:variable name="result" as="xs:string"
      select="if ($pubRegion) 
      then $pubRegion 
      else name($topicref)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
</xsl:stylesheet>
