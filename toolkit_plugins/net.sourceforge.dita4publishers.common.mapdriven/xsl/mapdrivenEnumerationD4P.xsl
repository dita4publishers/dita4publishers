<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:enum="http://dita4publishers.org/enumerables"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"                
                xmlns:local="urn:functions:local"
                xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns="http://dita4publishers.org/enumerables"                
                exclude-result-prefixes="local xs df xsl relpath enum htmlutil ditaarch index-terms"
  >
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Enumeration support for DITA for Publishers
    
    Copyright (c) 2012 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
  
<!--  
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
-->
  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicHead(.)]">
    <xsl:call-template name="construct-enumerated-element"/>
  </xsl:template>
 
  <xsl:template mode="construct-enumerable-structure" priority="10"
    match="*[df:class(., 'pubmap-d/frontmatter')] |
    *[df:class(., 'pubmap-d/body')] |
    *[df:class(., 'pubmap-d/backmatter')]
    ">
    <xsl:call-template name="construct-enumerated-element"/>
    
  </xsl:template> 
  
</xsl:stylesheet>
