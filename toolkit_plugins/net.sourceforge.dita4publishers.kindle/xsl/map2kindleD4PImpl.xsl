<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  exclude-result-prefixes="xs df relpath kindleutil"
  version="2.0">
    
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

  <!-- FIXME: Add rules for other topicrefs -->
  
  <!-- TOC (.ncx) generation context -->
  
  <!-- OPF (.opf) generation context -->
  
</xsl:stylesheet>
