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
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-index">
    <xsl:param name="index-terms" as="element()"/>

    <xsl:if test="$generateIndexBoolean">
      
      <xsl:variable name="pubTitle" as="xs:string*">
        <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
      </xsl:variable>           
      <xsl:variable name="resultUri" 
        select="relpath:newFile($outdir, 'generated-index.html')" 
        as="xs:string"/>

      <xsl:message> + [INFO] Generating index file "<xsl:sequence select="$resultUri"/>"...</xsl:message>

      <xsl:result-document href="{$resultUri}" format="topic-html"
        exclude-result-prefixes="index-terms"
        >
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <title>Index</title>
          </head>
          <body>
            <h1>Index</h1>
            <div class="index-list">
              <xsl:for-each-group select="$index-terms/index-terms:index-term"
                group-by="local:construct-index-group-key(.)"
                >
                <xsl:sort select="local:construct-index-group-sort-key(.)"/>
                <xsl:message> + [DEBUG] Index group "<xsl:sequence select="local:construct-index-group-label(current-group()[1])"/>", grouping key: "<xsl:sequence select="current-grouping-key()"/>", sort key: "<xsl:sequence select="local:construct-index-group-sort-key(.)"/>"</xsl:message>
                <div class="index-group">
                  <h2><xsl:sequence select="local:construct-index-group-label(current-group()[1])"/></h2>
                  <!-- At this point, the current group is all entries within the group. 
                    
                       Now need to group entries by primary term.
                    -->
                  <ul class="index-terms">
                    <xsl:for-each-group select="current-group()" 
                      group-by="local:construct-index-term-grouping-key(./index-terms:label)">
                      <xsl:sort select="local:construct-index-term-sorting-key(./index-terms:label)"/>
                      <xsl:variable name="firstPrimaryTerm" select="current-group()[1]" as="element()"/>
                      <li class="index-term"  xmlns="http://www.w3.org/1999/xhtml">
                        <span class="label"><xsl:apply-templates select="$firstPrimaryTerm/index-terms:label"/></span>
                        <ul class="index-terms">
                          <xsl:for-each-group select="current-group()/index-terms:index-term"
                            group-by="local:construct-index-term-grouping-key(./index-terms:label)">
                            <xsl:sort select="local:construct-index-term-sorting-key(./index-terms:label)"/>               
                            <xsl:variable name="firstSecondaryTerm" select="current-group()[1]" as="element()"/>
                            <li class="index-term"  xmlns="http://www.w3.org/1999/xhtml">
                              <span class="label"><xsl:apply-templates
                                  select="$firstSecondaryTerm/index-terms:label"/></span>
                              <ul class="index-terms">
                                <xsl:for-each-group select="current-group()/index-terms:index-term"
                                  group-by="local:construct-index-term-grouping-key(./index-terms:label)">
                                  <xsl:sort select="local:construct-index-term-sorting-key(./index-terms:label)"/>               
                                  <xsl:variable name="firstTertiaryTerm" select="current-group()[1]" as="element()"/>
                                  <li class="index-term"  xmlns="http://www.w3.org/1999/xhtml">
                                    <span class="label"><xsl:apply-templates
                                      select="$firstTertiaryTerm/index-terms:label"/></span>
                                  </li>
                                </xsl:for-each-group>
                              </ul>                              
                            </li>
                          </xsl:for-each-group>
                        </ul>
                      </li>
                    </xsl:for-each-group>
                  </ul>
                </div>
              </xsl:for-each-group>
            </div>
          </body>
        </html>
      </xsl:result-document>  
      <xsl:message> + [INFO] Index generation done.</xsl:message>
      
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-index" match="index-terms:index-term">
    <li class="index-term"  xmlns="http://www.w3.org/1999/xhtml">
      <span class="label"><xsl:apply-templates select="index-terms:label"/></span>
      <!-- Generate links here. -->
      <xsl:if test="index-terms:index-term">
        <ul class="index-terms"  xmlns="http://www.w3.org/1999/xhtml">
          <xsl:for-each-group select="index-terms:index-term" 
            group-by="normalize-space(./index-terms:label)">
            <xsl:sort select="normalize-space(./index-terms:label)"/>
            <xsl:apply-templates select="current-group()" mode="generate-index"/>
          </xsl:for-each-group>
        </ul>
      </xsl:if>
    </li>    
  </xsl:template>
  
  <xsl:template match="index-terms:label">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template mode="gather-index-terms" 
    match="*[df:class(.,'map/topicmeta')] | *[df:class(., 'topic/topic')]">
    <xsl:apply-templates 
      select=".//*[df:class(.,'topic/indexterm')]" mode="generate-index"/>
  </xsl:template>
  
  <xsl:template mode="gather-index-terms" 
    match="*[df:class(.,'topic/indexterm')]"> 
    <xsl:param name="targetUri" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="labelContent" as="node()*">
      <xsl:apply-templates select="*[not(df:class(., 'topic/indexterm')) and 
        not(df:class(., 'topic/index-see')) and 
        not(df:class(., 'topic/index-seealso'))] | 
        text()" mode="index-term-label"/>
    </xsl:variable>
    
    <xsl:if test="normalize-space(string-join($labelContent, '')) = '' and ./*">
    </xsl:if>
    
    <xsl:choose>
      <xsl:when test="normalize-space(string-join($labelContent, '')) = '' and not(./*)">
        <xsl:message> + [INFO] Skipping empty <xsl:sequence select="name(.)"/> element in <xsl:sequence select="string(@xtrf)"/>...</xsl:message>
      </xsl:when>
      <xsl:when test="normalize-space(string-join($labelContent, '')) = '' and ./*">
        <xsl:message> - [WARN] Empty index entry label for index entry with child elements in <xsl:sequence select="string(@xtrf)"/></xsl:message>
        <xsl:message> - [WARN]   Entry: <xsl:apply-templates mode="report-element" select="."/></xsl:message>
        <xsl:apply-templates mode="#current"/>
      </xsl:when>
      <xsl:otherwise>        
        <!--<xsl:message> - [DEBUG] Entry: <xsl:apply-templates mode="report-element" select="."/></xsl:message>-->
        <index-term xmlns="http://dita4publishers.org/index-terms">
          <label><xsl:sequence select="$labelContent"/></label>
          <target><xsl:sequence select="$targetUri"/></target>
          <item-id><xsl:sequence select="generate-id()"/></item-id>
          <!--<xsl:message> + [DEBUG] Handling nested index terms...</xsl:message>-->
          <xsl:apply-templates select="*[df:class(., 'topic/indexterm')]" mode="#current"/>
          <!--<xsl:message> + [DEBUG] Nested index terms handled.</xsl:message>-->
        </index-term>
      </xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:template>
  
  <xsl:template match="text()" mode="gather-index-terms generate-index" priority="-1"/>    

  <xsl:template match="text()" mode="index-term-label"
  >
    <xsl:sequence select="."></xsl:sequence>
    <!-- Keep text for labels -->
  </xsl:template>    
  
  <xsl:template mode="index-term-label" 
    match="*[not(df:class(., 'topic/indexterm')) and 
    not(df:class(., 'topic/index-see'))and 
    not(df:class(., 'topic/index-seealso'))
    ]">
    <!-- Delegate to default mode processing for elements within index terms -->
    <xsl:apply-templates select="." mode="#default"/>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="gather-index-terms">
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="not($topic)">
          <!-- Do nothing. Unresolveable topics will already have been reported. -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($topicsOutputPath, root($topic))" as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
            <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
            <!--<xsl:message> + [DEBUG] gather-index-terms: applying templates to indexterms in referenced topic:
              <xsl:apply-templates select="$topic//*[df:class(., 'topic/indexterm')][not(parent::*[df:class(., 'topic/indexterm')])]" mode="report-element"></xsl:apply-templates>
            </xsl:message>-->
            <xsl:apply-templates mode="#current" 
              select="$topic//*[df:class(., 'topic/indexterm')][not(parent::*[df:class(., 'topic/indexterm')])], *[df:class(., 'map/topicref')]">
              <xsl:with-param name="targetUri" as="xs:string" tunnel="yes"
                select="$targetUri"
              />
            </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>    
        
  </xsl:template>
  
  <xsl:function name="local:construct-index-group-key" as="xs:string">
    <xsl:param name="index-term" as="element()"/>
    <!-- FIXME: This is a very quick-and-dirty grouping key implementation.
      
         A full implementation must be extensible and must be locale-specific.
      -->
    <xsl:variable name="label" select="normalize-space($index-term/index-terms:label)" as="xs:string"/>
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($label, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($label,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$key"/>
  </xsl:function>

  <xsl:function name="local:construct-index-group-sort-key" as="xs:string">
    <xsl:param name="index-term" as="element()"/>
    <!-- FIXME: This is a very quick-and-dirty sorting key implementation.
      
      A full implementation must be extensible and must be locale-specific.
      
      Need to control whether non-alpha items come first or last in collation
      order.
    -->
    <xsl:variable name="label" select="normalize-space($index-term/index-terms:label)" as="xs:string"/>
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($label, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($label,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$key"/>
  </xsl:function>
  
  <xsl:function name="local:construct-index-group-label" as="xs:string">
    <xsl:param name="index-term" as="element()"/>
    <!-- FIXME: This is a very quick-and-dirty label implementation.
      
      A full implementation must be extensible and must be locale-specific.
      
      Need to control whether non-alpha items come first or last in collation
      order.
    -->
    <xsl:variable name="label" select="normalize-space($index-term/index-terms:label)" as="xs:string"/>
    <xsl:variable name="groupLabel" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($label, '^[0-9]')">
          <xsl:sequence select="'Numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="upper-case(substring($label,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$groupLabel"/>
  </xsl:function>
  
  <xsl:function name="local:construct-index-term-grouping-key" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="grouping-key" as="xs:string" select="normalize-space($context)"/>
    <xsl:sequence select="$grouping-key"/>
  </xsl:function>
  
  <xsl:function name="local:construct-index-term-sorting-key" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="grouping-key" as="xs:string" select="lower-case(normalize-space($context))"/>
    <xsl:sequence select="$grouping-key"/>
  </xsl:function>
  
  
</xsl:stylesheet>
