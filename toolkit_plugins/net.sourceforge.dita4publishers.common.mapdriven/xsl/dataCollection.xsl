<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath" xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:applicability="http://dita4publishers.org/applicability" 
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  xmlns:local="urn:functions:local" xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables" exclude-result-prefixes="local xs df xsl relpath glossdata">
  <!-- =============================================================
    
    DITA Map-Driven Processing Framework
    
    Data Collection. This module provides the base implementation of the data collection
    phase of map-driven processing. It can be extended through plugins to collect
    additional data or modify or extend the built-in data collection.
    
    Copyright (c) 2011, 2014 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->

  <!--  
  
  Users of this module must provide the following imports:
  
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
-->
  <xsl:import href="mapdrivenEnumeration.xsl"/>
  <xsl:import href="glossaryProcessing.xsl"/>
  <xsl:import href="indexProcessing.xsl"/>
  <xsl:import href="applicabilityDataCollection.xsl"/>
  <xsl:import href="mapdrivenEnumerationD4P.xsl"/>

  <xsl:template name="mapdriven:collect-data">
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <!-- Manages the construction of the <mapdriven:collected-data> element
         that is the value of the $collected-data variable.
         
         The context element should be the root map element.
      -->
    <mapdriven:collected-data>
      <!-- Index Terms: -->
      <xsl:if test="$generateIndexBoolean">
        <xsl:message> + [INFO] Grouping and sorting index terms...</xsl:message>
        <xsl:apply-templates mode="group-and-sort-index" select="."/>
      </xsl:if>
      <!-- Enumerated (countable) elements: -->
      <enum:enumerables>
        <xsl:apply-templates mode="construct-enumerable-structure" select="."/>
      </enum:enumerables>
      <!-- Glossary entries -->
      <glossdata:glossary-entries>
        <xsl:if test="$generateGlossaryBoolean">
          <xsl:apply-templates mode="group-and-sort-glossary" select="."/>
        </xsl:if>
      </glossdata:glossary-entries>
      <!--applicability:conditions>
        <xsl:apply-templates mode="collect-applicability-data" select="."/>
      </applicability:conditions-->
      <xsl:apply-templates mode="data-collection-extensions" select="."/>
    </mapdriven:collected-data>
  </xsl:template>

  <xsl:template mode="data-collection-extensions" match="*" priority="-1">
    <!-- Do nothing by default. Implement templates in this
      mode to construct whatever collected data structures
      your extension code needs beyond the enumerables, index entries,
      and glossary entries.
    -->
  </xsl:template>



</xsl:stylesheet>
