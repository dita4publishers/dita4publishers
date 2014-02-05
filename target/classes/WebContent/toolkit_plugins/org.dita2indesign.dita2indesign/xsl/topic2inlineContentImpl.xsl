<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df e2s relpath incxgen"
      version="2.0">
  
  <!-- "cont" (content) mode templates. This mode generates output that
       goes within InDesign paragraphs (text runs).
       
       Copyright (c) 2010 DITA2InDesign.org
  -->
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="lib/incx_generation_util.xsl"/>
  <xsl:import href="elem2styleMapper.xsl"/>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/entry')] |
    *[df:class(., 'topic/cite')]
    " 
    mode="block-children">
    
    <!-- The block-children mode handles text and elements that are (effectively) direct
      children of block elements, meaning that they have no ancestor inline elements
      from which then need to inherit style info.
      
      If an element processed here generates a text run, it, uses mode "cont"
      and passes down the style name it applies. If an element processed here
      does not generate a text run, it uses mode block-children on its 
      content.
      
    -->
    <xsl:variable name="cStyle" select="e2s:getCStyleForElement(.)"/>
    <xsl:if test="$debugBoolean">
       <xsl:message> + [DEBUG] (mode block-children): <xsl:sequence select="string(@class)"/>: cStyle="<xsl:sequence select="$cStyle"/>"</xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="cont">
      <xsl:with-param name="cStyle" select="$cStyle" tunnel="yes" as="xs:string"/>
    </xsl:apply-templates>   
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/div')] |
    *[df:class(., 'topic/bodydiv')] |
    *[df:class(., 'topic/sectiondiv')] |
    *[df:class(., 'topic/p')] 
    " 
    mode="block-children">
    <xsl:apply-templates mode="block-children"/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/xref')]
    " 
    mode="block-children">
    <!-- FIXME: There is no way to represent working hyperlinks in an InCopy
                article—the link has to be defined in an InDesign
                document. Not sure what, if anything, to do here.
      -->
    <xsl:apply-templates mode="block-children"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/image')]" mode="block-children cont">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] (block-children/cont mode): handling topic/image</xsl:message>      
    </xsl:if>
    <xsl:processing-instruction name="aid">Char="fffc" Self="rc_<xsl:value-of select="generate-id(.)"/>Anchor"</xsl:processing-instruction>  
  </xsl:template>
  
  <xsl:template match="processing-instruction(aid)" mode="cont">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="text()" mode="block-children cont" name="makeTxsr">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:param name="text" as="xs:string" select="''"/>
    
    <xsl:variable name="textValue" as="xs:string"
      select="
      if ($text = '')
         then string(.)
         else $text
      "
    />
    
<!--    <xsl:message> + [DEBUG] block-children/cont: text(): pStyle="<xsl:sequence select="$pStyle"/>", cStyle="<xsl:sequence select="$cStyle"/>"</xsl:message>-->
    
    <xsl:variable name="pStyleObjId" select="incxgen:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="incxgen:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:value-of select="incxgen:normalizeText($textValue)"/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeFrameBreak">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    
    <xsl:variable name="pStyleObjId" select="incxgen:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="incxgen:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt>e_SFrB</pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template mode="cont" match="*[df:class(., 'topic/ph')]">
    <!-- If we get here with a ph element, it must be a passthrough -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="cont" match="*" priority="-1">
    <xsl:message> + [WARNING] topic2inlineContentImpl: (cont mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="block-children" match="*" priority="-1">
    <xsl:message> + [WARNING] topic2inlineContentImpl: (block-children mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
</xsl:stylesheet>
