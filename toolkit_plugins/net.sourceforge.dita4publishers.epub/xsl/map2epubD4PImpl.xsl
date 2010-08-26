<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
  exclude-result-prefixes="xs df relpath epubutil"
  version="2.0">
    
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  <xsl:import href="epub-generation-utils.xsl"/>
  
  <!-- Extensions for DITA for Publishers vocabulary modules in
  different contexts -->
  
  
  <!-- Default context (HTML generation) -->
  
  <xsl:template mode="topicref-driven-content" 
    match="*[df:class(., 'pubmap-d/covers')]/*[df:class(., 'map/topicref')]" priority="10">
    <xsl:param name="topic" as="element()?"/>
    
    <!-- This template doesn't really do anything, although it could.
      
         This is just a test of the general mechanism of this mode.
      -->
    <xsl:apply-templates select="$topic"/>    
  </xsl:template>

  <xsl:template mode="enumeration" match="*[df:class(., 'pubmap-d/part')]" 
    priority="10">
    <span class='enumeration_part'>
      <xsl:text>Part </xsl:text><!-- FIXME: Enable localization of the string. -->
      <!-- When maps are merged, if there are two root topicrefs, both get the class of the referencing 
           topicref, e.g., <keydefs/><part/> as the children of the target map becomes two mapref topicrefs in the
           merged result. -->
      <xsl:number count="*[df:class(., 'pubmap-d/part')][not(@processing-role = 'resource-only')]" format="I" level="single"/>
      <xsl:text>. </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration" match="*[df:class(., 'pubmap-d/chapter')]">
    <span class='enumeration_chapter'>
      <xsl:text>Chapter </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number 
        count="*[df:class(., 'pubmap-d/chapter')][not(@processing-role = 'resource-only')]" 
        format="1." 
        level="any" 
        from="*[df:class(., 'pubmap-d/pubbody')] | *[df:class(., 'map/map')]"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/data')]" mode="#all">
    <!-- Suppress <data> by default. -->
  </xsl:template>

  <xsl:template mode="enumeration" match="*[df:class(., 'pubmap-d/appendix')]">
    <span class='enumeration_chapter'>
      <xsl:text>Appendix </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number 
        count="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]" 
        format="A." 
        level="single" 
        from="*[df:class(., 'pubmap-d/appendixes')]"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  <!-- FIXME: Add rules for other topicrefs -->
  
  <!-- TOC (.ncx) generation context -->
  
  <!-- OPF (.opf) generation context -->
  
</xsl:stylesheet>
