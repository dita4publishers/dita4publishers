<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs xd df relpath"
  version="2.0">
  
  <!-- =============================================================
    
       DITA Map to ePub Transformation
       
       Copyright (c) 2010 DITA For Publishers
       
       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.
       
       This transform requires XSLT 2.
       
       This transform is the root transform and manages the generation
       of the following distinct artifacts that make up a complete
       ePub publication:
       
       1. content.opf file, which defines the contents and publication metadata for the ePub
       2. toc.ncx, which defines the navigation table of contents for the ePub.
       3. The HTML content, generated from the map and topics referenced by the input map.
       4. An input-file-to-output-file map document that is used to copy referenced non-XML
          objects to the appropriate output location.
       
       This process flattens the resulting HTML such that file system organization of the 
       input map does not matter as far as the ePub organization is concerned.
       
       The input to this transform is a fully-resolved map. All processing of maps
       and topics is driven by references from the map.
       
       All files produced by this transform use xsl:result document. The primary
       output should be named deleteme.txt. It should be empty but extensions 
       may inadvertently output data outside the scope of a containing xsl:result-document
       instruction.
       ============================================================== -->

  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  
  <!-- Import the base HTML output generation transform. -->
  <xsl:import href="../../../xsl/dita2xhtml.xsl"/>
  
  
  <xsl:include href="map2epubCommon.xsl"/>
  <xsl:include href="map2epubopfImpl.xsl"/>
  <xsl:include href="map2graphicMapImpl.xsl"/>
  <xsl:include href="map2epubContentImpl.xsl"/>
  <xsl:include href="map2epubTocImpl.xsl"/>
  <xsl:include href="html2xhtmlImpl.xsl"/>
  
  <!-- Directory into which the generated output is put.

       This should be the directory that will be zipped up to
       produce the final ePub package.
       -->
  <xsl:param name="outdir" select="./epub"/>
  
  <!-- The path of the directory, relative the $outdir parameter,
    to hold the graphics in the EPub package. Should not have
    a leading "/". 
  -->  
  <xsl:param name="imagesOutputDir" select="'images'" as="xs:string"/>
  <!-- The path of the directory, relative the $outdir parameter,
    to hold the topics in the EPub package. Should not have
    a leading "/". 
  -->  
  <xsl:param name="topicsOutputDir" select="'topics'" as="xs:string"/>
  
  <xsl:param name="debug" select="'false'" as="xs:string"/>
  
  <xsl:variable name="debugBinary" select="$debug = 'true'" as="xs:boolean"/>
  
  <xsl:variable name="topicsOutputPath">
    <xsl:choose>
      <xsl:when test="$topicsOutputDir != ''">
        <xsl:sequence select="concat($outdir, '/', $topicsOutputDir)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$outdir"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:variable>

  <xsl:variable name="imagesOutputPath">
    <xsl:choose>
      <xsl:when test="$imagesOutputDir != ''">
        <xsl:sequence select="concat($outdir, '/', $imagesOutputDir)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$outdir"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:variable>
  
  <xsl:template match="/*[df:class(., 'map/map')]">
    
    <xsl:message> + [INFO] outdir="<xsl:sequence select="$outdir"/>"</xsl:message>
    
    <xsl:variable name="graphicMap" as="element()">
      <graphic-map>
        <xsl:apply-templates select="." mode="generate-graphic-map"/>
      </graphic-map>     
    </xsl:variable>
    <xsl:result-document href="{relpath:newFile($outdir, 'graphicMap.xml')}" format="graphic-map">
      <xsl:sequence select="$graphicMap"/>
    </xsl:result-document>    
    <xsl:call-template name="make-meta-inf"/>
    <xsl:apply-templates select="." mode="generate-content"/>
    <xsl:apply-templates select="." mode="generate-toc"/>
    <xsl:apply-templates select="." mode="generate-opf"/>
  </xsl:template>
  
  <xsl:template name="make-meta-inf">
    <xsl:result-document href="{relpath:newFile(relpath:newFile($outdir, 'META-INF'), 'container.xml')}">
      <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
        <rootfiles>
          <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
        </rootfiles>
      </container>
    </xsl:result-document>
  </xsl:template>
  
</xsl:stylesheet>
