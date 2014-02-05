<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs local df e2s"
      version="2.0">
  
  <!-- Element-to-style mapper
    
    This module provides the base implementation for
    the "style-map" modes, which map elements in context
    to InDesign style names (paragraph, character, frame,
    object, table).
    
    Copyright (c) 2009 Really Strategies, Inc.
    
    NOTE: This material is intended to be donated to the RSI-sponsored
    DITA2InDesign open-source project.
  -->
  <!-- Required modules:
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/icml_generation_util.xsl"/>
  
  -->
  
  <xsl:template match="*[df:class(., 'topic/p')][@outputclass = 'style1']" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Ungrouped Style 1'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/p')][@outputclass = 'style2']" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Style Group 1:Grouped Style 1'"/>
  </xsl:template>
  
  
</xsl:stylesheet>
