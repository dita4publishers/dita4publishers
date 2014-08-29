<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd df relpath"
  version="2.0">
  
  <!-- =============================================================
    
       DITA Map to EPUB Custom Transformation
       
       Copyright (c) 2013, 2014 DITA For Publishers
       
       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.
       
       This transform requires XSLT 2.
       
       You should place your customizations in this file or import other files that you create.
       
       Most of the formatting templates that the epub plugin uses comes from the base XHTML plugin that comes with the DITA-OT. Of course you may decide to override templates from the epub plugin or from some of the common D4P libraries (such as if you want to override or extend the graphic-map generation processing, which can be quite useful for resizing images if you have ImageMagick installed).
       
       ============================================================== -->

  <xsl:import href="../../org.dita4publishers.epub/xsl/map2epubImpl.xsl"/> <!-- import the D4P epub transform -->

  <xsl:param name="paramNameinXSLT" as="xs:string" select="'not-set'"/>

  <!-- Example custom template; all this does is applies the next matching template to any element that is or is specialized from the base paragraph element in DITA 1.2 --> 
  <xsl:template match="*[df:class(.,'topic/p')]">
    <xsl:next-match/>
  </xsl:template>
  
  
  <xsl:template match="*" mode="extension-report-parameters">
    <xsl:message>
      
      EPUB Customization Parameters:
      
      paramNameinXSLT  = "<xsl:value-of select="$paramNameinXSLT"/>"
    </xsl:message>
  </xsl:template>
  

  
</xsl:stylesheet>
