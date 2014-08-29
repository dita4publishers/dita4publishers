<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath index-terms"
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
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/html-generation-utils.xsl"/>
-->
  <xsl:template match="/*[df:class(., 'map/map')]" mode="group-and-sort-index">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <!-- Gather all the index entries from the map and topic. 
    -->
    <xsl:variable name="index-terms-ungrouped" as="element()">
      <index-terms:ungrouped>
        <xsl:if test="$generateIndexBoolean">
          <xsl:apply-templates mode="gather-index-terms" select="."/>
        </xsl:if>
      </index-terms:ungrouped>
    </xsl:variable>
    
    <index-terms:index-terms>
      <xsl:sequence select="$index-terms-ungrouped"/>      
      <index-terms:grouped-and-sorted>
        <xsl:apply-templates select="$index-terms-ungrouped" mode="group-and-sort-index"/>    
      </index-terms:grouped-and-sorted>
    </index-terms:index-terms>      
  </xsl:template>
  
  <xsl:template mode="group-and-sort-index" match="index-terms:ungrouped">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- Group first-level terms by index group -->
    <!-- FIXME: Implement usual index grouping localization and configuration per
      I18N library. 
    -->
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] group-and-sort-index: index-terms:ungrouped - All ungrouped terms:
        <xsl:for-each select="*">
          <xsl:sequence select="local:reportIndexTerm(.)"/>      
        </xsl:for-each>
      </xsl:message>
    </xsl:if>
    <xsl:for-each-group select="index-terms:index-term"
      group-by="./@grouping-key"
      >
      <xsl:sort select="./@grouping-key" case-order="lower-first"/>
      <xsl:if test="$doDebug">
        <xsl:message> + [DEBUG] Index group "<xsl:sequence select="local:construct-index-group-label(current-group()[1])"
        />", grouping key: "<xsl:sequence select="current-grouping-key()"
        />", sort key: "<xsl:sequence select="local:construct-index-group-sort-key(current-group()[1])"
        />"</xsl:message>
      </xsl:if>
      <index-terms:index-group 
        grouping-key="{current-grouping-key()}"
        sorting-key="{local:construct-index-group-sort-key(current-group()[1])}"
        >
        <index-terms:label><xsl:sequence select="local:construct-index-group-label(current-group()[1])"/></index-terms:label>
        <!-- At this point, the current group is all entries within the group. 
          
          Now group entries by primary term.
        -->
        <index-terms:sub-terms>
          <xsl:call-template name="process-index-terms">
            <xsl:with-param name="index-terms" as="node()*" select="current-group()"/>
            <xsl:with-param name="term-depth" as="xs:integer" select="1"/>
          </xsl:call-template>
        </index-terms:sub-terms>
      </index-terms:index-group>
    </xsl:for-each-group>
    
  </xsl:template>
  
  <xsl:template name="process-index-terms">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>

    <!-- Given a group of index terms, process each group. -->
    <xsl:param name="index-terms" as="node()*"/>
    <xsl:param name="term-depth" as="xs:integer"/>
    
    
    <xsl:for-each-group select="$index-terms" 
      group-by="@sorting-key">
      <xsl:sort select="@sorting-key" case-order="lower-first" />
      <!-- Each group is all the entries for a given term key -->
      <xsl:variable name="firstTerm" select="current-group()[1]" as="element()"/>
      <xsl:if test="$term-depth > 3">
        <xsl:message> - [WARNING] Index entry is more than 3 levels deep: "<xsl:value-of select="index-terms:label"/>"</xsl:message>
      </xsl:if>
      <xsl:if test="$doDebug">
        <xsl:message> + [DEBUG] group-and-sort-index: index term level <xsl:sequence select="$term-depth"/>: "<xsl:value-of select="index-terms:label"/></xsl:message>
      </xsl:if>
      <index-terms:index-term 
        grouping-key="{@grouping-key}"
        sorting-key="{@sorting-key}"
        >
        <index-terms:label><xsl:apply-templates select="$firstTerm/index-terms:label" mode="#current"/></index-terms:label>
        <xsl:sequence select="index-terms:original-markup"/>        
        <xsl:if test="not(current-group()/index-terms:index-term)">
          <!-- Only put out targets for this term if there are no subterms -->

          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] index grouping and sorting: leaf index term: <xsl:sequence select="local:reportIndexTerm(.)"/></xsl:message>
          </xsl:if>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG]   Processing <xsl:value-of select="count(current-group()/index-terms:target[*[df:class(.,'topic/indexterm')]
                                                          [not(*[df:class(.,'topic/indexterm')])]])"/> targets for the term...</xsl:message>
            </xsl:if>
          <index-terms:targets>
            <xsl:for-each-group
              select="current-group()/index-terms:target[*[df:class(.,'topic/indexterm')]
                                                          [not(*[df:class(.,'topic/indexterm')])]]"
              group-by="./*[df:class(., 'topic/indexterm')]/@xtrc"                       
              >
              <!-- If two entries have the same @xtrc value then they are in fact the same entry -->
              <!-- Note that in the collected index data we want all *unique* entries even if they
                   point to the same topic since in some outputs (e.g., print) there may still be
                   a need to output different entries in the generated index.
                -->
              <xsl:sequence select="current-group()[1]"/>
            </xsl:for-each-group>
          </index-terms:targets>
          <xsl:if test="current-group()/index-terms:see">
            <index-terms:sees>
              <xsl:for-each-group select="current-group()/index-terms:see" group-by="index-terms:label">
                <xsl:sequence select="."/>
              </xsl:for-each-group>
            </index-terms:sees>
          </xsl:if>
           <xsl:if test="current-group()/index-terms:see-also">
            <index-terms:see-alsos>
              <xsl:for-each-group select="current-group()/index-terms:see-also" group-by="@target-label">
                <xsl:sort select="@target-label"/>
                <xsl:sequence select="."/>
              </xsl:for-each-group>
            </index-terms:see-alsos>
          </xsl:if>
        </xsl:if>
        <index-terms:sub-terms>
          <xsl:call-template name="process-index-terms">
            <xsl:with-param name="index-terms" as="node()*" select="current-group()/index-terms:index-term"/>
            <xsl:with-param name="term-depth" select="$term-depth + 1" as="xs:integer"/>
          </xsl:call-template>
        </index-terms:sub-terms>
      </index-terms:index-term>
    </xsl:for-each-group>    
  </xsl:template>
  
  <xsl:template match="index-terms:orginal-markup" mode="group-and-sort-index">
    <!-- Nothing to do. -->
  </xsl:template>
  
  <xsl:template match="index-terms:label" mode="group-and-sort-index">
    <xsl:apply-templates mode="index-term-label"/>
  </xsl:template>
  
  <xsl:template mode="gather-index-terms" 
    match="*[df:class(.,'map/topicmeta')] | *[df:class(., 'topic/topic')]">
    <xsl:apply-templates 
      select=".//*[df:class(.,'topic/indexterm')]" mode="generate-index"/>
  </xsl:template>
  
  <xsl:template mode="gather-index-terms" priority="10"
    match="*[df:class(., 'map/reltable')]">
    <!-- Suppress handling of things within relatables -->
  </xsl:template>
  
  <xsl:template mode="gather-index-terms" 
    match="*[df:class(.,'topic/indexterm')]"> 
    
    <xsl:variable name="labelContent" as="node()*">
      <xsl:apply-templates select="*[not(df:class(., 'topic/indexterm')) and 
        not(df:class(., 'indexing-d/index-see')) and 
        not(df:class(., 'indexing-d/index-see-also'))] | 
        text()" mode="index-term-label"/>
    </xsl:variable>
    
    <xsl:variable name="labelString" as="xs:string" 
      select="local:getLabelStringForIndexTerm(.)"/>
    <xsl:variable name="sortAsString" as="xs:string"
      select="local:getSortAsStringForIndexTerm(.)"
    />
    
    <xsl:variable name="sortOnString" as="xs:string"
      select="if ($sortAsString != '') then $sortAsString else $labelString"
    />
    
    <xsl:choose>
      <xsl:when test="$labelString = '' and not(./*)">
        <xsl:message> + [INFO] Skipping empty <xsl:sequence select="name(.)"/> element in <xsl:sequence select="string(@xtrf)"/>...</xsl:message>
      </xsl:when>
      <xsl:when test="$labelString = '' and ./*">
        <xsl:message> - [WARN] Empty index entry label for index entry with child elements in <xsl:sequence select="string(@xtrf)"/></xsl:message>
        <xsl:message> - [WARN]   Entry: <xsl:apply-templates mode="report-element" select="."/></xsl:message>
        <xsl:apply-templates mode="#current"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="parentLabel" as="xs:string"
          select="if (parent::*[df:class(., 'topic/indexterm')])
          then local:getLabelStringForIndexTerm(parent::*)
          else ''"
        />
        <xsl:variable name="grouping-key" 
          select="if ($parentLabel = '') 
          then local:construct-index-group-key($sortOnString)
          else local:construct-index-term-grouping-key($sortOnString)" as="xs:string"/>
        
        <xsl:if test="false()">       
          <xsl:message> + [DEBUG] gather-index-terms: grouping-key="<xsl:sequence select="$grouping-key"/>"</xsl:message>        
          <xsl:message> + [DEBUG] gather-index-terms: sorting-key= "<xsl:sequence select="$sortOnString"/>"</xsl:message>        
        </xsl:if>
        <index-terms:index-term
          grouping-key="{$grouping-key}"
          sorting-key="{$sortOnString}"
          item-id="{generate-id()}"
          >
          <xsl:variable name="containingTopic" as="element()?"
            select="df:getContainingTopic(.)"
          />
          <xsl:variable name="sourceUri" as="xs:string"
            select="if ($containingTopic) 
            then concat(document-uri(root($containingTopic)), '#', $containingTopic/@id)
            else ''
            "
          />
          <index-terms:label><xsl:sequence select="$labelContent"/></index-terms:label>
          <index-terms:original-markup>
            <xsl:sequence select="."/><!-- Make the original index term available in all cases -->
          </index-terms:original-markup>
          <!-- Check rules for indexterm content: -->
          <xsl:if test="*[df:class(., 'topic/indexterm')] and 
            (*[df:class(., 'indexing-d/index-see')] or 
            *[df:class(., 'indexing-d/index-see-also')])">
            <xsl:message> - [WARN] Index term "<xsl:sequence select="$labelString"/>" contains both index-see or index-see-also and subordinate index terms. 
the index-see and index-see-also elements will be ignored.</xsl:message>              
          </xsl:if>
          <xsl:if test="
            *[df:class(., 'indexing-d/index-see')] and 
            *[df:class(., 'indexing-d/index-see-also')]">
            <xsl:message> - [ERROR] Index term "<xsl:sequence select="$labelString"/>" contains both index-see or index-see-also.</xsl:message>              
          </xsl:if>
          <!-- Generate target element: -->
          <xsl:apply-templates mode="make-index-targets" select=".">
            <xsl:with-param name="sourceUri" select="$sourceUri" as="xs:string"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="*[df:class(., 'topic/indexterm')]" mode="#current"/>
          <!--<xsl:message> + [DEBUG] Nested index terms handled.</xsl:message>-->
        </index-terms:index-term>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="make-index-targets" match="*[local:isPointReferenceIndexTerm(.)]">
    <xsl:param name="sourceUri" as="xs:string"/>
    <index-terms:target 
      source-uri="{$sourceUri}"
      >
      <xsl:copy>
      <xsl:sequence select="@*, node() 
        except (*[df:class(., 'indexing-d/index-see')] | 
                *[df:class(., 'indexing-d/index-see-also')])"/>
      </xsl:copy>
    </index-terms:target>
    <xsl:apply-templates select="*[df:class(., 'indexing-d/index-see-also')]" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="make-index-targets" match="*[df:class(., 'indexing-d/index-see-also')]" priority="10">
    <xsl:variable name="labelString" select="local:getLabelStringForIndexTerm(.)" as="xs:string"/>
    <xsl:variable name="labelContent" as="node()*">
      <xsl:apply-templates select="*[not(df:class(., 'topic/indexterm')) and 
        not(df:class(., 'indexing-d/index-see')) and 
        not(df:class(., 'indexing-d/index-see-also'))] | 
        text()" mode="index-term-label"/>
    </xsl:variable>
    
    <index-terms:see-also target-label="{$labelString}">
      <index-terms:label><xsl:sequence select="$labelContent"/></index-terms:label>
      <xsl:sequence select="."/>
    </index-terms:see-also>
  </xsl:template>
  
  <xsl:template mode="make-index-targets" match="*[df:class(., 'indexing-d/index-see')]" priority="10">
    <xsl:variable name="labelString" select="local:getLabelStringForIndexTerm(.)" as="xs:string"/>
    <xsl:variable name="labelContent" as="node()*">
      <xsl:apply-templates select="*[not(df:class(., 'topic/indexterm')) and 
        not(df:class(., 'indexing-d/index-see')) and 
        not(df:class(., 'indexing-d/index-see-also'))] | 
        text()" mode="index-term-label"/>
    </xsl:variable>
    
    <index-terms:see target-label="{$labelString}">
      <index-terms:label><xsl:sequence select="$labelContent"/></index-terms:label>
      <xsl:sequence select="."/>
    </index-terms:see>
  </xsl:template>
  
  <xsl:template match="text()" mode="gather-index-terms" priority="-1"/>    

  <xsl:template match="text()" mode="index-term-label index-term-sort-as"
  >
    <xsl:sequence select="."/>
    <!-- Keep text for labels -->
  </xsl:template>    
  
  <xsl:template mode="index-term-label" 
    match="*">
    <!-- Delegate to default mode processing for elements within index terms -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template mode="index-term-label" priority="10"
    match="*[df:class(., 'topic/indexterm')] | 
    *[df:class(., 'indexing-d/index-see')] |
    *[df:class(., 'indexing-d/index-see-also')] | 
    *[df:class(., 'indexing-d/index-sort-as')]
    ">
    <!-- Does not contribute to label -->
  </xsl:template>
  
  <xsl:template mode="index-term-sort-as"
    match="*"
    >
    <!-- Delegate to default mode processing for elements within index terms -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="index-term-label" match="*" priority="0">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="gather-index-terms">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    
    <xsl:choose>
        <xsl:when test="not($topic)">
          <!-- Do nothing. Unresolveable topics will already have been reported. -->
        </xsl:when>
        <xsl:otherwise>
          <!-- Any subordinate topics in the currently-referenced topic are
            reflected in the ToC before any subordinate topicrefs.
          -->
          <!--<xsl:message> + [DEBUG] gather-index-terms: applying templates to indexterms in referenced topic:
            <xsl:apply-templates select="$topic//*[df:class(., 'topic/indexterm')][not(parent::*[df:class(., 'topic/indexterm')])]" mode="report-element"></xsl:apply-templates>
          </xsl:message>-->
          <xsl:apply-templates mode="#current" 
            select="$topic//*[df:class(., 'topic/indexterm')][not(parent::*[df:class(., 'topic/indexterm')])]"> 
          </xsl:apply-templates>
          <xsl:if test="not(contains(@chunk, 'to-content'))">
            <!-- If this topicref chunks to content then we don't want to process
                 any subordinate topicrefs because all the index entries will be in the
                 chunk referenced by this topicref.
              -->
            <xsl:apply-templates mode="#current" 
              select="*[df:class(., 'map/topicref')]"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>    
        
  </xsl:template>
  
  <xsl:function name="local:isPointReferenceIndexTerm" as="xs:boolean">
    <xsl:param name="index-term" as="element()"/>
    <!-- A "point reference" is a leaf term that should result in a reference
         to a specific point. That is, it has no child index terms and no
         index-see children and does not specify @start or @end.
      -->
    <xsl:variable name="result"
      select="
      not($index-term/*[df:class(., 'topic/indexterm')]) and 
      not($index-term/*[df:class(., 'indexing-d/index-see')]) and
      not($index-term/@start) and
      not($index-term/@end)
              "
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:reportIndexTerm" as="xs:string">
    <xsl:param name="index-term" as="element()"/>
    <xsl:variable name="result">
Label: "<xsl:sequence select="string($index-term/index-terms:label)"/>"
  Sort-as:      "<xsl:sequence select="string($index-term/@sorting-key)"/>"
  Grouping key: "<xsl:sequence select="string($index-term/@grouping-key)"/>"
  Has child terms: <xsl:sequence select="count($index-term/index-terms:sub-terms/*) > 0"/>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:construct-index-group-key" as="xs:string">
    <xsl:param name="groupOnString" as="xs:string"/>
    <!-- FIXME: This is a very quick-and-dirty grouping key implementation.
      
         A full implementation must be extensible and must be locale-specific.
      -->
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($groupOnString, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($groupOnString,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$key"/>
  </xsl:function>

  <xsl:function name="local:construct-index-group-sort-key" as="xs:string">
    <xsl:param name="sortOnString" as="xs:string"/>
    <!-- FIXME: This is a very quick-and-dirty sorting key implementation.
      
      A full implementation must be extensible and must be locale-specific.
      
      Need to control whether non-alpha items come first or last in collation
      order.
    -->
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($sortOnString, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($sortOnString,1,1))"/>
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
    <xsl:param name="groupOnString" as="xs:string"/>
    <xsl:variable name="grouping-key" as="xs:string" select="normalize-space($groupOnString)"/>
    <xsl:sequence select="$grouping-key"/>
  </xsl:function>
  
  <xsl:function name="local:construct-index-term-sorting-key" as="xs:string">
    <xsl:param name="sortOnString" as="xs:string"/>
    <xsl:variable name="sorting-key" as="xs:string" select="lower-case(normalize-space($sortOnString))"/>
    <xsl:sequence select="$sorting-key"/>
  </xsl:function>
  
  <xsl:function name="local:getLabelStringForIndexTerm" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="labelNodes" as="node()*">
      <xsl:apply-templates select="$context/*[not(df:class(., 'topic/indexterm')) and 
        not(df:class(., 'indexing-d/index-see')) and 
        not(df:class(., 'indexing-d/index-see-also'))] | 
        $context/text()" mode="index-term-label"/>
    </xsl:variable>
    <xsl:variable name="nodeValue" as="xs:string">
      <xsl:value-of select="$labelNodes"/>
    </xsl:variable>
    <xsl:variable name="result" as="xs:string" select="normalize-space($nodeValue)"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getSortAsStringForIndexTerm" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <!-- Gets the formatted string value of any index-sort-as children of
         the context node.
      -->
    <xsl:variable name="sortAsNodes" as="node()*">
      <xsl:apply-templates select="$context/*[df:class(., 'topic/index-sort-as')]" 
        mode="index-term-sort-as"/>
    </xsl:variable>
    <xsl:variable name="nodeValue" as="xs:string">
      <xsl:value-of select="$sortAsNodes"/>
    </xsl:variable>
    <xsl:variable name="result" as="xs:string" select="normalize-space($nodeValue)"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
</xsl:stylesheet>
