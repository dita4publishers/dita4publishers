<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:java="org.dita.dost.util.ImgUtils"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"  
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:enum="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="xs xd relpath java dita2html df enum htmlutil"
  xmlns="http://www.w3.org/1999/xhtml"  
  version="2.0">
  <!-- ==================
       Flagging overrides
       
       These templates rework the base flagging processing in order to 
       generate working URLs for flagging graphics, which would otherwise
       be incorrect. These templates override the templates in flag.xsl.
       
       
       ================== -->
  
  <xsl:template match="prop" mode="start-flagit">  
    <xsl:choose> <!-- Ensure there's an image to get, otherwise don't insert anything -->
      <xsl:when test="startflag/@imageref">
        <xsl:variable name="imgsrc" select="startflag/@imageref"/>
        <!-- The flagging graphics will be in the images output directory. -->
        <xsl:variable name="topicResultUri" select="htmlutil:getTopicResultUrl($outdir, root(.))"/>
        <xsl:variable name="effectiveImageUri"
          as="xs:string"
          select="relpath:newFile(relpath:newFile($outdir, $imagesOutputDir), relpath:getName($imgsrc))"
        />
        <xsl:variable name="topicParent" select="relpath:getParent($topicResultUri)" as="xs:string"/>
        <xsl:variable name="imageParent" select="relpath:getParent($effectiveImageUri)" as="xs:string"/>
        <xsl:variable name="relParent" 
          select="relpath:getRelativePath($topicParent, $imageParent)" 
          as="xs:string"/>
        <xsl:variable name="newHref" select="relpath:newFile($relParent, relpath:getName($imgsrc))"/>
        <img src="{$newHref}">
          <xsl:if test="startflag/alt-text">
            <xsl:attribute name="alt" select="startflag/alt-text"/>
          </xsl:if>     
        </img>
      </xsl:when>
      <xsl:when test="startflag/alt-text">
        <xsl:value-of select="startflag/alt-text"/>
      </xsl:when>
      <xsl:otherwise/> <!-- that flag not active -->
    </xsl:choose>
    <xsl:apply-templates select="following-sibling::prop[1]" mode="start-flagit"/>
  </xsl:template>
  
  <xsl:template match="prop" mode="end-flagit">  
    <xsl:choose> <!-- Ensure there's an image to get, otherwise don't insert anything -->
      <xsl:when test="endflag/@imageref">
        <xsl:variable name="imgsrc" select="endflag/@imageref"/>
          <xsl:variable name="imgsrc" select="startflag/@imageref"/>
          <!-- The flagging graphics will be in the images output directory. -->
          <xsl:variable name="topicResultUri" select="htmlutil:getTopicResultUrl($outdir, root(.))"/>
          <xsl:variable name="effectiveImageUri"
            as="xs:string"
            select="relpath:newFile(relpath:newFile($outdir, $imagesOutputDir), relpath:getName($imgsrc))"
          />
          <xsl:variable name="topicParent" select="relpath:getParent($topicResultUri)" as="xs:string"/>
          <xsl:variable name="imageParent" select="relpath:getParent($effectiveImageUri)" as="xs:string"/>
          <xsl:variable name="relParent" 
            select="relpath:getRelativePath($topicParent, $imageParent)" 
            as="xs:string"/>
          <xsl:variable name="newHref" select="relpath:newFile($relParent, relpath:getName($imgsrc))"/>
        <img src="{$newHref}">
          <xsl:if test="endflag/alt-text">
            <xsl:attribute name="alt">
              <xsl:value-of select="endflag/alt-text"/>
            </xsl:attribute>
          </xsl:if>     
        </img>
      </xsl:when>
      <xsl:when test="endflag/alt-text">
        <xsl:value-of select="endflag/alt-text"/>
      </xsl:when>
      <!-- not necessary to add logic for @img. original ditaval does not support end flag. -->
      <xsl:otherwise/> <!-- that flag not active -->
    </xsl:choose>
    <xsl:apply-templates select="preceding-sibling::prop[1]" mode="end-flagit"/>
  </xsl:template>
</xsl:stylesheet>