<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  
  exclude-result-prefixes="xs htmlutil df relpath"
  version="2.0">

<!--
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  <xsl:import href="lib/html-generation-utils.xsl"/>
  
-->
  <xsl:template match="/" mode="href-fixup">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="image/@href" priority="10">
    <xsl:param name="topicResultUri" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="origHref" select="." as="xs:string"/>
    <xsl:variable name="effectiveImageUri" 
      select="relpath:newFile(relpath:newFile($outdir, $imagesOutputDir), relpath:getName($origHref))" 
      as="xs:string"/>
    <!--<xsl:message> + [DEBUG] href-fixup: href="<xsl:sequence select="$origHref"/>"</xsl:message>-->
    <xsl:variable name="topicParent" select="relpath:getParent($topicResultUri)" as="xs:string"/>
   <!-- <xsl:message> + [DEBUG] href-fixup: topicParent="<xsl:sequence select="$topicParent"/>"</xsl:message> -->
    <xsl:variable name="imageParent" select="relpath:getParent($effectiveImageUri)" as="xs:string"/>
  <!-- <xsl:message> + [DEBUG] href-fixup: imageParent="<xsl:sequence select="$imageParent"/>"</xsl:message>-->
    <xsl:variable name="relParent" 
      select="relpath:getRelativePath($topicParent, $imageParent)" 
      as="xs:string"/>
  <!-- <xsl:message> + [DEBUG] href-fixup: relParent="<xsl:sequence select="$relParent"/>"</xsl:message> -->
    <xsl:variable name="newHref" select="relpath:newFile($relParent, relpath:getName($origHref))"/>
 <!--  <xsl:message> + [DEBUG] href-fixup: newHref="<xsl:sequence select="$newHref"/>"</xsl:message> -->
    <xsl:attribute name="href" select="$newHref"/>
    <xsl:attribute name="origHref" select="$origHref"/>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="xref[@scope = 'external']/@href | 
    link[@scope = 'external']/@href" priority="10">
    <!-- Add missing http:// for URLs with no scheme -->
    <xsl:choose>
     <!-- try to fix a bug when url are http:/www -->
       <xsl:when test="matches(., '^http:/[A-Za-z_0-9].*')">
        <xsl:attribute name="{name(.)}" select="concat('http://', substring(.,7))"/>    
      </xsl:when>
      <xsl:when test="matches(., '^[a-zA-Z]+:')">
        <xsl:sequence select="."/><!-- Must have a scheme, don't change it -->
      </xsl:when>
       
      <xsl:otherwise>
        <!-- Add http:// to make it a valid absolute URL -->
        <xsl:attribute name="{name(.)}" select="concat('http://', .)"/>
      </xsl:otherwise>
              
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="href-fixup" match="xref[not(@scope = 'external')]/@href | 
                      link[not(@scope = 'external')]/@href" priority="10">
    <xsl:if test="false() or $debugBoolean">
<!--      <xsl:message> + [DEBUG] href-fixup 
        <xsl:sequence select="name(..)"/>/@href att..., value="<xsl:sequence select="string(.)"/>"</xsl:message> -->
    </xsl:if>
    <xsl:variable name="parentElem" select=".." as="element()"/>
    <xsl:variable name="targetTopic" as="document-node()?"
      select="if (not($parentElem/@format) or $parentElem/@format = 'dita' or $parentElem/@format = '') 
      then df:getDocumentThatContainsRefTarget(..)
      else ()"    
    />
    
    <xsl:variable name="origHref" as="xs:string" 
      select="."/>
    
    <xsl:variable name="fragmentId" as="xs:string"
      select="if (contains($origHref, '#')) 
      then concat('#', substring-after($origHref, '#'))
      else ''
      "
    />
    
    <xsl:variable name="query" as="xs:string"
      select="if (contains($origHref, '?'))
        then concat('?', substring-after($origHref, '?'))
        else ''
      "
    />

    <xsl:variable name="newHref" as="xs:string">
      <xsl:choose>
        <xsl:when test="$targetTopic">
          <xsl:variable name="thisXmlTopicBaseUrl" as="xs:string">
            <xsl:apply-templates select="root(.)" mode="get-topic-result-base-url">
              <xsl:with-param name="outdir" select="$outdir" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:variable name="targetXmlTopicBaseUrl" as="xs:string">
            <xsl:apply-templates select="$targetTopic" mode="get-topic-result-base-url">
              <xsl:with-param name="outdir" select="$outdir" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>      
          </xsl:variable>
          <xsl:variable name="baseTargetFilename" select="relpath:getName($targetXmlTopicBaseUrl)" as="xs:string"/>
          <xsl:variable name="relPathToTarget" as="xs:string" 
            select="relpath:getRelativePath(relpath:getParent($thisXmlTopicBaseUrl), 
                                            relpath:getParent($targetXmlTopicBaseUrl))"/>
          <xsl:sequence select="concat(relpath:newFile($relPathToTarget, $baseTargetFilename), $DITAEXT)"/>
        </xsl:when>
        <xsl:when test="$parentElem/@format and 
                        $parentElem/@format != '' and 
                        $parentElem/@format != 'dita'">
          <!--<xsl:message> + [DEBUG] non-topic href, url="<xsl:sequence select="string(@href)"/>" format="<xsl:sequence select="string($parentElem/@format)"/>"</xsl:message>-->
          <xsl:sequence select="''"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARN] Unable to resolve href '<xsl:sequence select="string(.)"/>' to a topic</xsl:message>
          <xsl:sequence select="concat('unresolvable-reference', $DITAEXT)"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] href-fixup, newHref='<xsl:sequence select="$newHref"/>'</xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$newHref != ''">
        <xsl:attribute name="href" select="concat($newHref, $fragmentId, $query)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="."/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:attribute name="origHref" select="$origHref"/>
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
