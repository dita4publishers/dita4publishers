<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"                
                xmlns:local="urn:functions:local"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="local xs df xsl relpath index-terms htmlutil"
  >
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Back-of-the-book index generation. This transform generates the HTML markup
    for a back-of-the-book index reflecting the index entries in the map and
    topic set.
    
    NOTE: This functionality is not completely implemented.
    
    Copyright (c) 2010, 2011 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
  
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sf.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-index">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:if test="$generateIndexBoolean">
      
      <xsl:variable name="pubTitle" as="xs:string*">
        <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
      </xsl:variable>           
      <xsl:variable name="resultUri" 
        select="relpath:newFile($outdir, concat('generated-index', $OUTEXT))" 
        as="xs:string"/>

      <xsl:message> + [INFO] Generating index file "<xsl:sequence select="$resultUri"/>"...</xsl:message>

      <xsl:result-document href="{$resultUri}" format="topic-html"
        exclude-result-prefixes="index-terms"
        >
        <html>
          <head>
            <title>Index</title>
          </head>
          <body>
            <h1>Index</h1>
            <div class="index-list">
              <xsl:apply-templates select="$collected-data/index-terms:index-terms/index-terms:grouped-and-sorted" mode="#current"/>
            </div>
          </body>
        </html>
      </xsl:result-document>  
      <xsl:message> + [INFO] Index generation done.</xsl:message>
      
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-group">
    <div class="index-group">
      <h2><xsl:apply-templates select="index-terms:label" mode="#current"/></h2>
      <xsl:apply-templates select="index-terms:sub-terms" mode="#current"/>
    </div>      
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-term">
    <li class="index-term" >
      <span class="label"><xsl:apply-templates select="index-terms:label" mode="#current"/></span>
      <xsl:apply-templates select="index-terms:targets" mode="#current"/>
      <xsl:apply-templates 
        select="index-terms:sub-terms | 
                index-terms:see-alsos | 
                index-terms:sees" 
        mode="#current"/>
    </li>
  </xsl:template>
  
  <xsl:template match="index-terms:see-alsos" mode="generate-index">
    <ul class="see-also">
      <li class="see-also">
        <span class="see-also-label">See also: </span>
        <xsl:apply-templates mode="#current"/>
      </li>
    </ul>
  </xsl:template>
  
  <xsl:template match="index-terms:sees" mode="generate-index">
    <ul class="see">
      <li class="see">
        <span class="see-label">See: </span>
        <xsl:apply-templates mode="#current"/>
      </li>
    </ul>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:see-also">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>    
    <xsl:apply-templates  select="index-terms:label" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:see">
    <xsl:apply-templates  select="index-terms:label" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:original-markup">
    <!-- nothing to do -->
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:sub-terms">
    <ul class="index-terms">
      <xsl:apply-templates mode="#current"/>      
    </ul>      
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:targets">
    <span class="index-term-targets">
      <xsl:apply-templates mode="#current"/>      
    </span>      
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:target">
    <xsl:param name="rootMapDocUrl" tunnel="yes" as="xs:string"/>

    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:variable name="topic" select="document(relpath:getResourcePartOfUri(@source-uri))" as="document-node()"/>
    <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, $topic, $rootMapDocUrl)"
      as="xs:string"/>
    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
    
    <a href="{$relativeUri}" target="{$contenttarget}"> 
      <xsl:text> [</xsl:text>
      <xsl:apply-templates select="." mode="generate-index-term-link-text"/>
      <xsl:text>] </xsl:text>
    </a>
  </xsl:template>
  
  
  <xsl:template mode="generate-index-term-link-text" match="index-terms:target">
    <xsl:number count="index-terms:target" format="1"/>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-terms">
    <xsl:apply-templates mode="#current"/>    
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:grouped-and-sorted">
    <xsl:apply-templates mode="#current"/>    
  </xsl:template>
  
  <xsl:template match="index-terms:label" mode="generate-index #default">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-index" priority="-1"/>    

  
</xsl:stylesheet>
