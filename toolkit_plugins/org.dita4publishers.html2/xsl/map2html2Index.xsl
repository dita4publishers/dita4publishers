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
    
    Copyright (c) 2010, 2014 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    

<!--  
  <xsl:import href="../../org.dita-community.common.xslt/xsl/dita-support-lib.xsl"/>
  <xsl:import href="../../org.dita-community.common.xslt/xsl/relpath_util.xsl"/>
  
-->
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
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] generate-index: index-group: <xsl:value-of select="index-terms:label"/> (<xsl:value-of select="@grouping-key"/>)</xsl:message>
    </xsl:if>
    <div class="index-group">
      <h2><xsl:apply-templates select="index-terms:label" mode="#current"/></h2>
      <xsl:apply-templates select="index-terms:sub-terms" mode="#current">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
    </div>      
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-term">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] generate-index: index-term: <xsl:value-of select="index-terms:label"/> (<xsl:value-of select="@grouping-key"/>)</xsl:message>
    </xsl:if>
    <li class="index-term" >
      <span class="label"><xsl:apply-templates select="index-terms:label" mode="#current"/></span>
      <xsl:apply-templates select="index-terms:targets" mode="#current">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
      <xsl:apply-templates 
        select="index-terms:sub-terms | 
                index-terms:see-alsos | 
                index-terms:sees" 
        mode="#current">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
    </li>
  </xsl:template>
  
  <xsl:template match="index-terms:see-alsos" mode="generate-index">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <ul class="see-also">
      <li class="see-also">
        <span class="see-also-label">See also: </span>
        <xsl:apply-templates mode="#current">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        </xsl:apply-templates>
      </li>
    </ul>
  </xsl:template>
  
  <xsl:template match="index-terms:sees" mode="generate-index">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <ul class="see">
      <li class="see">
        <span class="see-label">See: </span>
        <xsl:apply-templates mode="#current">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        </xsl:apply-templates>
      </li>
    </ul>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:see-also">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>    
    <xsl:apply-templates  select="index-terms:label" mode="#current">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:see">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates  select="index-terms:label" mode="#current">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:original-markup">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- nothing to do -->
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:sub-terms">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="./*">
      <ul class="index-terms">
        <xsl:apply-templates mode="#current">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        </xsl:apply-templates>      
      </ul>      
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:targets">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="doDebug" as="xs:boolean" select="string(../@sorting-key) = 'video log'"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] generate-index: Processing targets for entry "video log"...</xsl:message>
    </xsl:if>
    <span class="index-term-targets">
      <!-- If two targets have the same source URI then they're pointing to the same
           topic and we only want one entry in the index in that case.
        -->
      <xsl:for-each-group select="index-terms:target" group-by="@source-uri">
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] generate-index:  for-each-group, grouping key="<xsl:value-of select="current-grouping-key()"/>"</xsl:message>
        </xsl:if>
        
        <xsl:apply-templates mode="#current" select="current-group()[1]">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        </xsl:apply-templates>      
      </xsl:for-each-group>
    </span>      
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:target">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="rootMapDocUrl" tunnel="yes" as="xs:string"/>

    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:variable name="topic" select="document(relpath:getResourcePartOfUri(@source-uri))" as="document-node()"/>
    <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, $topic, $rootMapDocUrl)"
      as="xs:string"/>
    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
    
    <a href="{$relativeUri}">
      <xsl:if test="$contenttarget != ''">
        <xsl:attribute name="target" select="$contenttarget"/>
      </xsl:if>
      <xsl:text> [</xsl:text>
      <xsl:apply-templates select="." mode="generate-index-term-link-text">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
      </xsl:apply-templates>
      <xsl:text>] </xsl:text>
    </a>
  </xsl:template>
  
  
  <xsl:template mode="generate-index-term-link-text" match="index-terms:target">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:number count="index-terms:target" format="1"/>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-terms">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates mode="#current">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>    
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:grouped-and-sorted">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates mode="#current">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>    
  </xsl:template>
  
  <xsl:template match="index-terms:label" mode="generate-index #default">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates>
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-index" priority="-1"/>    

  
</xsl:stylesheet>
