<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  
  exclude-result-prefixes="xs kindleutil df relpath"
  version="2.0">

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="kindle-generation-utils.xsl"/>
  
  <xsl:template match="/" mode="href-fixup">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="image/@href" priority="10">
    <xsl:variable name="origHref" select="." as="xs:string"/>
    <xsl:variable name="newHref" select="concat('../images/', relpath:getName($origHref))" as="xs:string"/>
    <xsl:attribute name="href" select="$newHref"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="xref[not(@scope = 'external')]/@href | 
                      link[not(@scope = 'external')]/@href" priority="10">
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] href-fixup 
        <xsl:sequence select="name(..)"/>/@href att..., value="<xsl:sequence select="string(.)"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="origHref" select="." as="xs:string"/>
    <xsl:variable name="targetTopic" as="document-node()?"
      select="df:getDocumentThatContainsRefTarget(..)"
    />
    <xsl:variable name="newHref" as="xs:string">
      <xsl:choose>
        <xsl:when test="$targetTopic">
          <xsl:sequence select="kindleutil:getXmlResultTopicFileName($targetTopic)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARN] Unable to resolve href '<xsl:sequence select="string(.)"/>' to a topic</xsl:message>
          <xsl:sequence select="concat('unresolvable-reference', $DITAEXT)"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] href-fixup, newHref='<xsl:sequence select="$newHref"/>'</xsl:message>
    </xsl:if>
    <xsl:attribute name="href" select="$newHref"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="*">
    <!--<xsl:message> + [DEBUG] href-fixup, node template, element=<xsl:sequence select="name(.)"/>...</xsl:message>-->
    <xsl:element name="{name(.)}">
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="text() | @* | processing-instruction() | comment()">
    <xsl:sequence select="."/>
  </xsl:template>
</xsl:stylesheet>
