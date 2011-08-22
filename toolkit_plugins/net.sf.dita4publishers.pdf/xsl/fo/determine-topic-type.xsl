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
    
      Determine topic type 
      
      The templates in this module map topics
      to topic types.
      
      Implement templates in the mode "mapTopicsToType"
      in order to determine the topic type of 
      specific topics.
      
      Templates in this mode should return the
      string name of the topic type, e.g.
      
      <xsl:sequence select="'topicSomeType'"/>
      
      ================================-->

  
  <xsl:template name="determineTopicType">
    <!-- Determine the topic type of a topic or the 
         parent topic of a non-topic element.
         
         Override this template to completely change
         how topic type determination works.
         
         Otherwise, implement templates in the mode
         determineTopicType to control the mapping
         for specific topics.
      -->
    <xsl:variable name="topicType">
      <xsl:apply-templates mode="determineTopicType" 
        select="ancestor-or-self::*[df:class(., 'topic/topic')][1]"/>
    </xsl:variable>
    <xsl:sequence select="$topicType"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="determineTopicType">
    <!-- This is an override of the same template in
          commons.xsl. By default it uses the topicref type if it's specialized,
          otherwise it uses the topic type if it's specialized, otherwise
          uses the value "simple" to indicate a generic topic type.
    -->
<!--    <xsl:message>+ [DEBUG] determineTopicType: topic=<xsl:sequence select="name(.)"/> id=<xsl:sequence select="string(@id)"/></xsl:message>-->
    <xsl:variable name="topicref" as="element()?"
      select="dita-ot-pdf:getTopicrefForTopic(.)"/>
<!--    <xsl:message>+ [DEBUG] determineTopicType: topicref=<xsl:sequence select="name($topicref)"/></xsl:message>-->
    <xsl:variable name="topicrefType" as="xs:string?" 
      select="if (name($topicref) = ('topicref', 'topichead', 'topicgroup'))
      then 'simple'
      else name($topicref)"/>
<!--    <xsl:message>+ [DEBUG] determineTopicType:   topicrefType=<xsl:sequence select="$topicrefType"/></xsl:message>-->
    <xsl:variable name="topicType" as="xs:string"
      select="if ($topicrefType != 'simple' and $topicrefType != '')
                 then $topicrefType
                 else if (name(.) = 'topic')
                      then 'simple'
                      else name(.)
         "
    />
<!--    <xsl:message>+ [DEBUG] determineTopicType:   topicType=<xsl:sequence select="$topicType"/></xsl:message>-->

    <xsl:variable name="result" as="xs:string"
      select="
       concat(
         'topic', 
         upper-case(substring($topicType, 1,1)), 
         substring($topicType, 2)
       )
      "/>
<!--    <xsl:message>+ [DEBUG] determineTopicType:   result=<xsl:sequence select="$result"/></xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:template>

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
</xsl:stylesheet>
