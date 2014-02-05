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
  xmlns:html2="http://dita4publishers.org/html2"
  xmlns:gv="http://dita4publishers.sourceforge.net/functions/graphviz"

  exclude-result-prefixes="xs xd df relpath html2 gv enum index-terms"
  version="2.0">
  
  <!-- =============================================================
    
       DITA Map to GraphViz Transformation
       
       Copyright (c) 2011 DITA For Publishers
       
       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.
       
       Processing of GraphViz output requires
       either the graphviz tool (graphviz.org) or a compatible tool that
       understands the graphviz DOT format.
       
       
       ============================================================== -->

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.mapdriven/xsl/indexProcessing.xsl"/>
  
  <xsl:import href="../../../xsl/dita2xhtml.xsl"/>
  
  <xsl:param name="outdir" select="./gv"/>
  <!-- NOTE: Case of OUTEXT parameter matches case used in base HTML
    transformation type.
  -->
  <xsl:param name="OUTEXT" select="'.gv'"/>
  <xsl:param name="tempdir" select="./temp"/>
  <xsl:param name="CSSPATH" select="''"/>
  <xsl:param name="DITAEXT" select="'.dita'"/>
  <xsl:param name="topicsOutputDir" select="'topics'" as="xs:string"/>
  
  <xsl:param name="graphType" as="xs:string" select="'navigation-tree'"/>
  
  <xsl:param name="generateIndex" as="xs:string" select="'no'"/>
  <xsl:variable name="generateIndexBoolean" 
    select="true()"/>
  
  <!-- Generate the glossary dynamically using all glossary entry
    topics included in the map.
  -->
  <xsl:param name="generateGlossary" as="xs:string" select="'no'"/>
  <xsl:variable name="generateGlossaryBoolean" 
    select="
    lower-case($generateGlossary) = 'yes' or 
    lower-case($generateGlossary) = 'true' or
    lower-case($generateGlossary) = 'on'
    "/>
  
  
  <!-- We're generating graphviz DOT files, which are plain text files -->
  <xsl:output method="text"/>
  <xsl:output method="xml" name="indented-xml"
    indent="yes"
  />
  
  
  
  <xsl:include href="map2navigationTreeGraph.xsl"/>
  <xsl:include href="map2indexTreeGraph.xsl"/>
  <xsl:include href="map2graphCommon.xsl"/>
  <xsl:include href="map2gvFunctions.xsl"/>
  
  <xsl:template match="/">
    
    <xsl:apply-templates select="." mode="report-parameters"/>
    
    <xsl:apply-templates>
      <xsl:with-param name="rootMapDocUrl" select="document-uri(.)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
 </xsl:template>   
    
 <xsl:template match="/*[df:class(., 'map/map')]">   
    <xsl:variable name="collected-data" as="element()">
      <html2:collected-data>
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
        <xsl:apply-templates mode="data-collection-extensions"/>
      </html2:collected-data>
    </xsl:variable>
   
   <xsl:if test="true() or $debugBoolean">
     <xsl:message> + [DEBUG] Writing file <xsl:sequence select="relpath:newFile($outdir, 'collected-data.xml')"/>...</xsl:message>
     <xsl:result-document href="{relpath:newFile($outdir, 'collected-data.xml')}"
       format="indented-xml"
       >
       <xsl:sequence select="$collected-data"/>
     </xsl:result-document>
   </xsl:if>
   
    
    <xsl:choose>
      <xsl:when test="$graphType = 'navigation-tree'">
        <xsl:apply-templates select="." mode="generate-navigation-tree-graph">
          <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$graphType = 'index-tree'">
        <xsl:apply-templates select="." mode="generate-index-tree-graph">
          <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARN] Unrecognized graphType value "<xsl:sequence select="$graphType"/>" Using "navigation-tree".</xsl:message>
        <xsl:apply-templates select="." mode="generate-navigation-tree-graph">
          <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
   
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:message> 
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^
      
      Parameters:
      
      + generateIndex      = "<xsl:sequence select="$generateIndex"/>
      + debug           = "<xsl:sequence select="$debug"/>"
      
      Global Variables:
      
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
      
      ==========================================
    </xsl:message>
  </xsl:template>
  
  
</xsl:stylesheet>
