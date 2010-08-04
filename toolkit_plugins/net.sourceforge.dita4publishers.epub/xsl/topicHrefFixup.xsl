<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="xs epubutil df"
  version="2.0">

  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="epub-generation-utils.xsl"/>
  
  <xsl:template match="/" mode="href-fixup">
    <xsl:message> + [DEBUG] href-fixup, root template...</xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="xref[not(@scope = 'external')]/@href" priority="10">
    <xsl:message> + [DEBUG] href-fixup, @href att..., value="<xsl:sequence select="string(.)"/>"</xsl:message>
    <xsl:variable name="origHref" select="." as="xs:string"/>
    <xsl:variable name="targetTopic" as="element()?"
       select="df:resolveTopicElementRef(.., $origHref)"
    />
    <xsl:message> + [DEBUG] href-fixup, targetTopic=<xsl:sequence select="name($targetTopic[1])"/>.</xsl:message>
    <xsl:variable name="newHref" as="xs:string">
      <xsl:choose>
        <xsl:when test="$targetTopic">
          <xsl:sequence select="epubutil:getXmlResultTopicFileName($targetTopic)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARN] Unable to resolve href '<xsl:sequence select="string(.)"/>' to a topic</xsl:message>
          <xsl:sequence select="'unresolvable-reference'"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:message> + [DEBUG] href-fixup, newHref='<xsl:sequence select="$newHref"/>'</xsl:message>
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
