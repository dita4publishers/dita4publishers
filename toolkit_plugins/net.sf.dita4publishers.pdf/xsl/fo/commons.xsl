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
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local dita-ot-pdf"
  version="2.0">

  <!--================================
    
      commons.xsl overrides
      
      Note: Topic processing moved
      to process-toplevel-topics.xsl.
      
      ================================-->
  
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

</xsl:stylesheet>
