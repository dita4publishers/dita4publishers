<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs df relpath"
  version="2.0">
  <!-- NOTE: This is the base shell transform type. Not sure how to handle
             the case where you want an FO-engine-specific transform.
             
  -->
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>

  <xsl:import href="../../../demo/fo/xsl/fo/topic2fo_shell_1.0.xsl"/>
  
  <xsl:import href="../cfg/fo/attrs/covers-attr.xsl"/>
  <xsl:import href="../cfg/fo/attrs/enumeration-attr.xsl"/>
  <xsl:import href="../cfg/fo/attrs/layout-masters-attr.xsl"/>
  <xsl:import href="../cfg/fo/attrs/page-break-control-attr.xsl"/>
  
  <xsl:import href="fo/root-processing.xsl"/>
  <xsl:import href="fo/bookmarks_1.0.xsl"/>
  <xsl:import href="fo/bookmarks.xsl"/>
  <xsl:import href="fo/commons.xsl"/>
  <xsl:import href="fo/determine-topic-type.xsl"/>
  <xsl:import href="fo/enumeration.xsl"/>
  <xsl:import href="fo/front-matter.xsl"/>
  <xsl:import href="fo/function-library.xsl"/>
  <xsl:import href="fo/get-toplevel-topics.xsl"/>
  <xsl:import href="fo/glossary.xsl"/>
  <xsl:import href="fo/index.xsl"/>
  <xsl:import href="fo/lot-lof.xsl"/>
  <xsl:import href="fo/preface.xsl"/>
  <xsl:import href="fo/toc.xsl"/>
  <xsl:import href="fo/page-sequences.xsl"/>
  <xsl:import href="fo/process-titles.xsl"/>
  <xsl:import href="fo/process-topics.xsl"/>
  <xsl:import href="fo/topic-to-pub-region-mappings.xsl"/>
  <xsl:import href="fo/covers.xsl"/>
  <xsl:import href="fo/layout-masters.xsl"/>
  
</xsl:stylesheet>
