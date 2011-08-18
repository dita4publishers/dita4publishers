<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  version="2.0">
  <!-- NOTE: This is the base shell transform type. Not sure how to handle
             the case where you want an FO-engine-specific transform.
             
  -->
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../../demo/fo/xsl/fo/topic2fo_shell_1.0.xsl"/>
  
  <xsl:import href="../cfg/fo/attrs/covers-attr.xsl"/>
  <xsl:import href="../cfg/fo/attrs/layout-masters-attr.xsl"/>
  
  <xsl:import href="fo/root-processing.xsl"/>
  <xsl:import href="fo/covers.xsl"/>
  <xsl:import href="fo/layout-masters.xsl"/>
  
</xsl:stylesheet>
