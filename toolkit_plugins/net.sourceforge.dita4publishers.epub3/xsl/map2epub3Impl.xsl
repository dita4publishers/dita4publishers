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
    
       DITA Map to EPUB3 Transformation
       
       Copyright (c) 2012 DITA For Publishers
       
       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.
       
       This transform requires XSLT 2.
       
       This transform is the root transform and manages the generation
       of the following distinct artifacts that make up a complete
       EPUB3 publication:
       
       1. content.opf file, which defines the contents and publication metadata for the EPUB
       2. toc.ncx, which defines the navigation table of contents for the EPUB.
       3. The HTML content, generated from the map and topics referenced by the input map.
       4. An input-file-to-output-file map document that is used to copy referenced non-XML
          objects to the appropriate output location.
       
       This process flattens the resulting HTML such that file system organization of the 
       input map does not matter as far as the EPUB organization is concerned.
       
       The input to this transform is a fully-resolved map. All processing of maps
       and topics is driven by references from the map.
       
       All files produced by this transform use xsl:result document. The primary
       output should be named deleteme.txt. It should be empty but extensions 
       may inadvertently output data outside the scope of a containing xsl:result-document
       instruction.
       
       NOTE: This transform leverages the base EPUB2 transformation type (transtype epub).
       Most of the parameters and global variables are defined there.
       
       It also uses templates from the HTML5 transformation type.
       
       EPUB3 Differences from EPUB2:
       
       - NCX replaced with HTML5 navigation structures (NCX may be included for
         backward compatibility with EPUB2-only readers)
       - Changes to publication metadata
       - No guide structure
       - No tours element
       - Video and audio may be remote (not included in the EPUB Zip package)
       - New link element for package documents for binding metadata
       - Can use SMIL for media overlays (synchronization of text and audio)
       - Can embed OpenType and WOFF fonts
       - Fonts may be obfuscated to prevent general use of embedded fonts
       - Can use subset of CSS3
       - Alternate style tags for selection of different style sets
       - New trigger element for activating video and audio playback without scripting
       - Can use JavaScript with EPUB-specific constraints
       - New EPUB-specific fragment identifier syntax.
       - Simplified content switching (<switch>)
       - Native MathML support
       - SVG allowed as top-level content objects
       - HTML5 for content
       - Pronunciation lexicons for text-to-speach
       - Inline SMLL phonemes
       - CSS3 speach features from
       - @epub:type attribute, corresponds to HTML @role (namespace http://www.idpf.org/2007/ops)
       - Multiple root documents (e.g., fixed-layout and dynamic layout
         versions of the same content)
       - Use .xhtml for XHTML content files.
       
       ============================================================== -->

  <xsl:import href="../../net.sourceforge.dita4publishers.epub/xsl/map2epubImpl.xsl"/>
  
  <xsl:import href="../../net.sourceforge.dita4publishers.html5/xsl/map2html5Nav.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.html5/xsl/map2html5Content.xsl"/>
  
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message> 
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^
      
      Parameters:
      
      + coverGraphicUri = "<xsl:sequence select="$coverGraphicUri"/>"
      + cssOutputDir    = "<xsl:sequence select="$cssOutputDir"/>"
      + generateGlossary= "<xsl:sequence select="$generateGlossary"/>"
      + generateHtmlToc = "<xsl:sequence select="$generateHtmlToc"/>"
      + maxTocDepth     = "<xsl:sequence select="$maxTocDepth"/>"
      + maxNavDepth     = "<xsl:sequence select="$maxNavDepth"/>"
      + generateIndex   = "<xsl:sequence select="$generateIndex"/>"
      + imagesOutputDir = "<xsl:sequence select="$imagesOutputDir"/>"
      + mathJaxInclude  = "<xsl:sequence select="$mathJaxInclude"/>"
      + mathJaxConfigParam = "<xsl:sequence select="$mathJaxConfigParam"/>"
      + mathJaxLocalJavascriptUri= "<xsl:sequence select="$mathJaxLocalJavascriptUri"/>"
      + outdir          = "<xsl:sequence select="$outdir"/>"
      + tempdir         = "<xsl:sequence select="$tempdir"/>"
      + titleOnlyTopicClassSpec = "<xsl:sequence select="$titleOnlyTopicClassSpec"/>"
      + titleOnlyTopicTitleClassSpec = "<xsl:sequence select="$titleOnlyTopicTitleClassSpec"/>"
      + topicsOutputDir = "<xsl:sequence select="$topicsOutputDir"/>"

      + DITAEXT         = "<xsl:sequence select="$DITAEXT"/>"
      + WORKDIR         = "<xsl:sequence select="$WORKDIR"/>"
      + PATH2PROJ       = "<xsl:sequence select="$PATH2PROJ"/>"
      + KEYREF-FILE     = "<xsl:sequence select="$KEYREF-FILE"/>"
      + CSS             = "<xsl:sequence select="$CSS"/>"
      + CSSPATH         = "<xsl:sequence select="$CSSPATH"/>"
      + debug           = "<xsl:sequence select="$debug"/>"
      
      Global Variables:
      
      + cssOutputPath    = "<xsl:sequence select="$cssOutputPath"/>"
      + effectiveCoverGraphicUri = "<xsl:sequence select="$effectiveCoverGraphicUri"/>"
      + topicsOutputPath = "<xsl:sequence select="$topicsOutputPath"/>"
      + imagesOutputPath = "<xsl:sequence select="$imagesOutputPath"/>"
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
      
      ==========================================
    </xsl:message>
  </xsl:template>
  
  
  <xsl:template match="/*[df:class(., 'map/map')]">
    
    <xsl:variable name="effectiveCoverGraphicUri" as="xs:string">
      <xsl:apply-templates select="." mode="get-cover-graphic-uri"/>
    </xsl:variable>
    
    <!-- FIXME: Add mode to get effective front cover topic URI so we
         can generate <guide> entry for the cover page. Also provides
         extension point for synthesizing the cover if it's not 
         explicit in the map.
    -->

    <xsl:apply-templates select="." mode="report-parameters">
      <xsl:with-param name="effectiveCoverGraphicUri" select="$effectiveCoverGraphicUri" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
    
    <xsl:variable name="graphicMap" as="element()">
      <xsl:apply-templates select="." mode="generate-graphic-map">
        <xsl:with-param name="effectiveCoverGraphicUri" select="$effectiveCoverGraphicUri" as="xs:string" tunnel="yes"/>        
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:message> + [INFO] Collecting data for index generation, enumeration, etc....</xsl:message>
    
    <xsl:variable name="collected-data" as="element()">
      <xsl:call-template name="mapdriven:collect-data"/>      
    </xsl:variable>
    
    <xsl:if test="true() or $debugBoolean">
      <xsl:message> + [DEBUG] Writing file <xsl:sequence select="relpath:newFile($outdir, 'collected-data.xml')"/>...</xsl:message>
      <xsl:result-document href="{relpath:newFile($outdir, 'collected-data.xml')}"
        format="indented-xml"
        >
        <xsl:sequence select="$collected-data"/>
      </xsl:result-document>
    </xsl:if>
        
    <xsl:result-document href="{relpath:newFile($outdir, 'graphicMap.xml')}" format="graphic-map">
      <xsl:sequence select="$graphicMap"/>
    </xsl:result-document>    
    <xsl:call-template name="make-meta-inf"/>
    <xsl:call-template name="make-mimetype"/>
    
    <xsl:message> + [INFO] Gathering index terms...</xsl:message>
    
    <xsl:apply-templates select="." mode="generate-content">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>     
    </xsl:apply-templates>
    <!-- NOTE: The generate-toc mode is for the EPUB toc, not the HTML toc -->
    <xsl:apply-templates select="." mode="generate-toc">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:message> + [DEBUG] after generate-toc</xsl:message>
    <xsl:apply-templates select="." mode="generate-index">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:message> + [DEBUG] after generate-index</xsl:message>
    <xsl:apply-templates select="." mode="generate-book-lists">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:message> + [DEBUG] after generate-book-lists</xsl:message>
    <xsl:apply-templates select="." mode="generate-opf">
      <xsl:with-param name="graphicMap" as="element()" tunnel="yes" select="$graphicMap"/>
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="effectiveCoverGraphicUri" select="$effectiveCoverGraphicUri" as="xs:string" tunnel="yes"/>        
    </xsl:apply-templates>
    <xsl:message> + [DEBUG] after generate-opf</xsl:message>
    <xsl:apply-templates select="." mode="generate-graphic-copy-ant-script">
      <xsl:with-param name="graphicMap" as="element()" tunnel="yes" select="$graphicMap"/>
    </xsl:apply-templates>
    <xsl:message> + [DEBUG] after generate-graphic-copy-ant-script</xsl:message>
  </xsl:template>
  
</xsl:stylesheet>
