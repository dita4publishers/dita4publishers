<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  xmlns:s2m="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  exclude-result-prefixes="xs xd s2m"
  version="2.0">
  <!-- ==============================================================
       DITA for Publishers
       
       Style-to-Tag Map Migration Utility
       
       This transform takes a pre-0.9.19RC12Feature30 style-to-tag
       map (that uses only the <style> element) and migrates it to
       the new style-to-tag map markup that uses distinct element
       types for paragraph and character styles and that uses
       subelements for defining map, topicref, and topic generation
       details.
       
       Copyright (c) 2014 DITA For Publishers
       ============================================================== -->
  
  <xsl:output method="xml" 
    indent="yes"
  />
  
<xsl:template match="/">
  
  <xsl:apply-templates/>
  
</xsl:template>
  
  <xsl:template match="s2m:output">
    <xsl:variable name="format" select="@name" as="xs:string"/>
    <xsl:copy>
      <xsl:apply-templates 
        select="(/*/s2m:styles/s2m:style[@format = $format])[1]"
        mode="get-maptype"
      />
      <xsl:apply-templates 
        select="(/*/s2m:styles/s2m:style[@format = $format])[1]"
        mode="get-topictypeAtts"
      />
      <xsl:sequence select="@*"/><!-- Preserve any attributes on output -->
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="get-maptype" match="s2m:style">
    <xsl:sequence select="@mapType"/>
  </xsl:template>
  
  <xsl:template mode="get-topictypeAtts" match="s2m:style">
    <xsl:sequence 
      select="
        @topicType | 
        @bodyType |
        @abstractType |
        @shortdescType |
        @prologType |
        @initialSectionType
        "
    />
  </xsl:template>
  
  <xsl:template match="s2m:style[@topicZone = 'inline']" priority="10">
    <characterStyle>
      <xsl:apply-templates select="@* except (@topicZone), node()"/>
    </characterStyle>
  </xsl:template>
  
  <xsl:template match="s2m:style">
    <paragraphStyle>
      <xsl:apply-templates select="@*, node()"/>
      <xsl:apply-templates select="." mode="make-map-properties"/>
      <xsl:apply-templates select="." mode="make-topicref-properties"/>
      <xsl:apply-templates select="." mode="make-topic-properties"/>
    </paragraphStyle>
  </xsl:template>
  
  <!-- ===========================
       Mode make-map-properties
       =========================== -->
  
  <xsl:template mode="make-map-properties"
    match="s2m:style[@mapType or 
                     @structureType = ('map', 'mapTitle') or
                     @mapFormat or
                     @maprefFormat or
                     @maprefType
                     ][not(s2m:mapProperties)]">
    <mapProperties>
      <xsl:apply-templates select="@*" mode="#current"/>
    </mapProperties>
  </xsl:template>
  
  <xsl:template mode="make-map-properties" match="@mapType">
    <!-- @mapType now goes on the output element that defines 
         the map output details. 
      -->
  </xsl:template>
  
  <xsl:template mode="make-map-properties" match="@mapFormat | @format">
    <xsl:attribute name="format" select="."/>
  </xsl:template>

  <xsl:template mode="make-map-properties" 
    match="@prologType[../@structureType = ('map', 'mapTitle')] |
           @tagName[../@structureType = ('map', 'mapTitle')] |
           @maprefType |
           @rootTopicrefType
           ">
    <xsl:sequence select="."/>
  </xsl:template>
  
    <!-- ===========================
         Mode make-topicref-properties
         =========================== -->
  
  <xsl:template mode="make-topicref-properties" 
     match="s2m:style[@topicrefType or @topicDoc = 'yes'][not(s2m:topicrefProperties)]">
    <topicrefProperties>
      <xsl:apply-templates select="@*" mode="#current"/>
    </topicrefProperties>
  </xsl:template>
  
  <xsl:template mode="make-topicref-properties" 
    match="@topicrefType | 
           @navtitleType |
           @chunk
           ">
    <xsl:sequence select="."/>
  </xsl:template>

    <!-- ===========================
         Mode make-topic-properties
         =========================== -->
  
  <xsl:template mode="make-topic-properties"
    match="s2m:style[@structureType = 'topicTitle' or
                     @topicDoc = 'yes' or
                     @topicType
                     ][not(s2m:topicProperties)]"      
    >
    <topicProperties>
      <xsl:apply-templates select="@*" mode="make-topic-properties"/>
    </topicProperties>
  </xsl:template>

  <xsl:template mode="make-topic-properties" 
    match="@topicDoc | 
           @topicType |
           @bodyType |
           @prologType[not(../@structureType = ('map', 'mapTitle'))] |
           @abstractType |
           @shortdescType |
           @initialSectionType |
           @format[not(../@structureType = ('map', 'mapTitle'))]
           ">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template mode="make-map-properties make-topicref-properties make-topic-properties"
    match="* | @*" priority="-1"
    >
    
  </xsl:template>
  
  <xsl:template match="s2m:mapProperties | s2m:topicrefProperties | s2m:topicProperties">
    <xsl:copy>
      <xsl:sequence select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="
    @chunk |
    @mapType |
    @prologType |
    @format |
    @topicDoc |
    @topicType |
    @bodyType |
    @abstractType |
    @shortdescType |
    @topicrefType |
    @navtitleType |
    @rootTopicrefType |
    @initialSectionType |
    @maprefFormat |
    @mapFormat |
    @maprefType |
    @prologType[../@structureType = ('map', 'mapTitle')]
    ">
    <!-- These attributes are handled by the property subelement-creating templates. -->    
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text() | processing-instruction() | comment()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="@*" priority="-1">
    <xsl:sequence select="."/>
  </xsl:template>

</xsl:stylesheet>