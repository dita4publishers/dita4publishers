<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:local="http://www.example.com/functions/local"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="local xs"
  >
  
  <!--  ====================================================
  
        Calculate the Bounded Object Set (BOS) of unique 
        dependencies referenced by a root map.
        
        Copyright (c) 2009, 2015 DITA For Publishers
        
        ==================================================== -->
  
  
  <xsl:function name="local:calculateBOS"  as="element()*">
    <xsl:param name="rootMap" as="document-node()"/>
    <xsl:message> + INFO: Calculating set of unique documents in map and topic set...</xsl:message>
    <xsl:variable name="baseBosList" as="element()*">
      <bosmember docuri="{document-uri($rootMap)}" refkey="rootMap"/>
      <xsl:apply-templates select="$rootMap/*" mode="bos_construction"/>
    </xsl:variable>
    <xsl:if test="false()">
      <xsl:message> + DEBUG: BOS member count before removing duplicates: <xsl:value-of select="count($baseBosList)"/></xsl:message>  
    </xsl:if>
    <xsl:variable name="bosList" select="local:removeDuplicates($baseBosList)"/>
    <xsl:variable name="temp" select="$bosList"/><!-- Force calculation of value before issuing message -->
    <xsl:message> + INFO: Unique document set calculated. Found <xsl:value-of select="count($baseBosList)"/> references, <xsl:value-of select="count($bosList)"/> unique documents.</xsl:message>
    <xsl:sequence select="$bosList"/>
  </xsl:function>
  
  <xsl:template match="*[contains(@class, ' map/topicref ') and @href]" mode="bos_construction" priority="10">
    <xsl:variable name="targetUrl" select="@href" as="xs:string"/>
    <xsl:variable name="baseUri" select="if (@xtrf) then local:getParent(@xtrf) else local:getParent(document-uri(root(.)))" as="xs:string"/>
    <xsl:variable name="targetDoc" select="document(local:newFile($baseUri, $targetUrl))" as="document-node()?"/>
    <xsl:choose>
      <xsl:when test="not($targetDoc)">
        <xsl:message> - ERROR: Failed to resolve reference to document "<xsl:value-of select="$targetUrl"/>" from base URI "<xsl:value-of select="$baseUri"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <!-- If the reference is in the context of a to-content chunk then we don't want to 
             include it in the BOS list because the file won't be copied anyway.
        -->
        <xsl:if test="not(ancestor-or-self::*[@chunk = 'to-content'])">
          <bosmember docuri="{document-uri($targetDoc)}" refkey="{generate-id(.)}"/>
<!--          <xsl:message> + INFO: Processing referenced document: <xsl:value-of select="document-uri($targetDoc)"/></xsl:message>-->
          <xsl:apply-templates select="$targetDoc/*" mode="#current"/><!-- We don't want document ("/") processing applied to any subordinate docs -->
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*" mode="bos_construction" priority="0">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="bos_construction"/>
  
  <xsl:function name="local:removeDuplicates" as="element()*">
    <xsl:param name="inList" as="element()*"/>
    <xsl:for-each-group select="$inList" group-by="@docuri">
      <xsl:sequence select="current-group()[1]"/>
    </xsl:for-each-group>
  </xsl:function>

</xsl:stylesheet>
