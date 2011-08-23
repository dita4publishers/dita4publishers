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
       Topic to publication region mappings
       
       The templates in this module map topics
       to publication regions. Implement templates
       in the mode "getPublicationRegion" in order
       to change or add how specific top-level topics
       map to publication regions.
    
      ================================-->


  <!-- =========================================================
       Get Publication Region templates
       ========================================================= -->
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/frontmatter')]]" 
    priority="10">
    <xsl:sequence select="'frontmatter'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/backmatter')]]" 
    priority="10">
    <xsl:sequence select="'backmatter'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/appendices')]] |
    *[df:class(., 'bookmap/appendix')]" 
    priority="10">
    <xsl:sequence select="'appendices'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" match="ot-placeholder:*">
    <!-- This will put adjacent generated lists together in the same
         page sequence, which seems appropriate, especially if you
         want the figurelist and table list to not start new pages,
         for example.
      -->
    <xsl:sequence select="'booklists'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" match="*">
    <!-- Make each body topic a unique name starting with "body" so
         each topic becomes a separate page sequence as in the base
         PDF processing, but matches the default body template
         for generating fo:page-sequence.
         
         Context element should be a topicref.
      -->
    <xsl:variable name="pubRegion" 
      select="concat('body', ':', string(count(preceding::*[df:class(., 'map/topicref')])))"
      as="xs:string"
      />
<!--    <xsl:message>+ [DEBUG] mode getPublicationRegion: default template, pubRegion=<xsl:sequence select="$pubRegion"/>"</xsl:message>-->
    <xsl:sequence select="$pubRegion"/>
  </xsl:template>
  
  <!-- =========================================================
       Local functions
       ========================================================= -->
  
  <xsl:function name="local:getPublicationRegion" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="topicref" select="dita-ot-pdf:getTopicrefForTopic($context)" as="element()?"/>

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
