<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:glossdata="http://dita4publishers.org/glossdata"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"                
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath glossdata htmlutil"
  >
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Glossary generation. This module collects glossary entry topics and
    groups and sorts them for use in generated glossary lists.
    
    NOTE: This functionality is not completely implemented.
    
    Copyright (c) 2011 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-glossary-list">
    <xsl:param name="collected-data" as="element()"/>

    <xsl:if test="$generateGlossary">
      
      <xsl:message> + [INFO] Generating glossary list...</xsl:message>
      
      <xsl:message> - [WARN] *** Glossary generation not yet implemented ***</xsl:message>
      
      <xsl:message> + [INFO] Glossary list generation done.</xsl:message>
      
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="glossdata:glossary-group">
    <div class="glossary-group">
      <h2><xsl:apply-templates select="glossdata:label" mode="#current"/></h2>
      <xsl:apply-templates select="glossdata:sub-terms" mode="#current"/>
    </div>      
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-index" priority="-1"/>    

  
</xsl:stylesheet>
