<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:glossdata="http://dita4publishers.org/glossdata"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"                
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath glossdata htmlutil"
  >
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Glossary generation. This transform provides generic grouping and sorting
    of glossary entries.
    
    NOTE: This functionality is not completely implemented.
    
    Copyright (c) 2011 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
  
<!--  <xsl:import href="../../org.dita-community.common.xslt/xsl/dita-support-lib.xsl"/>
  <xsl:import href="../../org.dita-community.common.xslt/xsl/relpath_util.xsl"/>
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/html-generation-utils.xsl"/>
-->
  <xsl:template match="/*[df:class(., 'map/map')]" mode="group-and-sort-glossary">
    
    <xsl:variable name="glossary-entries" as="element()">
      <glossdata:glossary-entries>
        <xsl:if test="$generateGlossaryBoolean">
          <xsl:apply-templates mode="gather-glossary-terms" select="."/>
        </xsl:if>
      </glossdata:glossary-entries>      
    </xsl:variable>
        
    <!-- Group first-level terms by index group -->
    <!-- FIXME: Implement usual index grouping localization and configuration per
         I18N library. 
      -->
    <xsl:for-each-group select="$glossary-entries/glossdata:glossentry"
      group-by="./@grouping-key"
      >
      <xsl:sort select="./@sorting-key"/>
      <!--<xsl:message> + [DEBUG] Glossary group "<xsl:sequence select="local:construct-glossary-group-label(current-group()[1])"
      />", grouping key: "<xsl:sequence select="current-grouping-key()"
      />", sort key: "<xsl:sequence select="local:construct-glossary-group-sort-key(.)"
      />"</xsl:message>-->
      <glossdata:index-group 
        grouping-key="{current-grouping-key()}"
        sorting-key="{@sorting-key}"
        >
        <glossdata:label><xsl:sequence select="local:construct-glossary-group-label(current-group()[1])"/></glossdata:label>
        <!-- At this point, the current group is all entries within the group. 
          
          Now group entries by primary term.
        -->
        <glossdata:sub-terms>
          <xsl:call-template name="process-index-terms">
            <xsl:with-param name="index-terms" as="node()*" select="current-group()"/>
            <xsl:with-param name="term-depth" as="xs:integer" select="1"/>
          </xsl:call-template>
        </glossdata:sub-terms>
      </glossdata:index-group>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="process-index-terms">
    <!-- Given a group of index terms, process each group. -->
    <xsl:param name="index-terms" as="node()*"/>
    <xsl:param name="term-depth" as="xs:integer"/>
    
    <xsl:for-each-group select="$index-terms" 
      group-by="@grouping-key">
      <xsl:sort select="@sorting-key"/>
      <!-- Each group is all the entries for a given term key -->
      <xsl:variable name="firstTerm" select="current-group()[1]" as="element()"/>
      <xsl:if test="$term-depth > 3">
        <xsl:message> - [WARNING] Index entry is more than 3 levels deep: "<xsl:value-of select="glossdata:label"/>"</xsl:message>
      </xsl:if>
      <xsl:if test="false()">
        <xsl:message> + [DEBUG] group-and-sort-index: index term level <xsl:sequence select="$term-depth"/>: "<xsl:value-of select="glossdata:label"/></xsl:message>
      </xsl:if>
      <glossdata:index-term 
        grouping-key="{@grouping-key}"
        sorting-key="{@sorting-key}"
        >
        <glossdata:label><xsl:apply-templates select="$firstTerm/glossdata:label" mode="#current"/></glossdata:label>
        <xsl:sequence select="glossdata:original-markup"/>        
        <xsl:if test="not(current-group()/glossdata:index-term)">
          <!-- Only put out targets for this term if there are no subterms -->
          <glossdata:targets>
            <xsl:sequence select="current-group()/glossdata:target[*[df:class(.,'topic/indexterm')][not(*[df:class(.,'topic/indexterm')])]]"/>
          </glossdata:targets>
        </xsl:if>
        <glossdata:sub-terms>
          <xsl:call-template name="process-index-terms">
            <xsl:with-param name="index-terms" as="node()*" select="current-group()/glossdata:index-term"/>
            <xsl:with-param name="term-depth" select="$term-depth + 1" as="xs:integer"/>
          </xsl:call-template>
        </glossdata:sub-terms>
      </glossdata:index-term>
    </xsl:for-each-group>    
  </xsl:template>
  
  <xsl:template match="glossdata:orginal-markup" mode="group-and-sort-index">
    <!-- Nothing to do. -->
  </xsl:template>
  
  <xsl:template match="glossdata:label" mode="group-and-sort-index">
    <xsl:apply-templates mode="index-term-label"/>
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
        <xsl:variable name="grouping-key" 
          select="if (parent::*[df:class(., 'topic/indexterm')]) 
          then local:construct-glossary-entry-grouping-key($labelContent)
          else local:construct-glossary-group-key($labelContent)" as="xs:string"/>
        <xsl:variable name="sorting-key" select="if (parent::*[df:class(., 'topic/indexterm')])
          then local:construct-glossary-entry-sorting-key($labelContent)
          else local:construct-glossary-group-sort-key($labelContent)" as="xs:string"/>
        
        <xsl:if test="false()">       
          <xsl:message> + [DEBUG] gather-glossdata: grouping-key="<xsl:sequence select="$grouping-key"/>"</xsl:message>        
          <xsl:message> + [DEBUG] gather-glossdata: sorting-key= "<xsl:sequence select="$sorting-key"/>"</xsl:message>        
        </xsl:if>
        <glossdata:index-term
          grouping-key="{$grouping-key}"
          sorting-key="{$sorting-key}"
          item-id="{generate-id()}"
          >
          <glossdata:label><xsl:sequence select="$labelContent"/></glossdata:label>
          <glossdata:original-markup>
            <xsl:sequence select="."/><!-- Make the original index term available in all cases -->
          </glossdata:original-markup>
          <xsl:if test="not(*[df:class(., 'topic/indexterm')])">
            <!-- Only output a target if it is a leaf index term. -->
            <glossdata:target target-uri="{$targetUri}">
              <xsl:sequence select=".[not(*[df:class(., 'topic/indexterm')])]"/>
            </glossdata:target>
          </xsl:if>
          <!--<xsl:message> + [DEBUG] Handling nested index terms...</xsl:message>-->
          <xsl:apply-templates select="*[df:class(., 'topic/indexterm')]" mode="#current"/>
          <!--<xsl:message> + [DEBUG] Nested index terms handled.</xsl:message>-->
        </glossdata:index-term>
      </xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:template>
  
  <xsl:template match="text()" mode="gather-index-terms" priority="-1"/>    

  <xsl:template match="text()" mode="index-term-label"
  >
    <xsl:sequence select="."/>
    <!-- Keep text for labels -->
  </xsl:template>    
  
  <xsl:template mode="index-term-label" 
    match="*[not(df:class(., 'topic/indexterm')) and 
    not(df:class(., 'topic/index-see'))and 
    not(df:class(., 'topic/index-seealso'))
    ]">
    <!-- Delegate to default mode processing for elements within index terms -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="index-term-label" match="*" priority="0">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:function name="local:construct-glossary-group-key" as="xs:string">
    <xsl:param name="label" as="node()*"/>
    <xsl:variable name="labelStr" as="xs:string">
      <xsl:value-of select="$label"/>      
    </xsl:variable>
    <!-- FIXME: This is a very quick-and-dirty grouping key implementation.
      
         A full implementation must be extensible and must be locale-specific.
      -->
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($labelStr, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($labelStr,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$key"/>
  </xsl:function>

  <xsl:function name="local:construct-glossary-group-sort-key" as="xs:string">
    <xsl:param name="label" as="node()*"/>
    <!-- This label-to-label string anticipates more sophisticated label construction -->
    <xsl:variable name="labelStr" as="xs:string">
      <xsl:value-of select="$label"/>      
    </xsl:variable>
    <!-- FIXME: This is a very quick-and-dirty sorting key implementation.
      
      A full implementation must be extensible and must be locale-specific.
      
      Need to control whether non-alpha items come first or last in collation
      order.
    -->
    <xsl:variable name="key" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($labelStr, '^[0-9]')">
          <xsl:sequence select="'#numeric'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="lower-case(substring($labelStr,1,1))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="$key"/>
  </xsl:function>
  
  <xsl:function name="local:construct-glossary-group-label" as="xs:string">
    <xsl:param name="glossentry" as="element()"/>
    <!-- FIXME: This is a very quick-and-dirty label implementation.
      
      A full implementation must be extensible and must be locale-specific.
      
      Need to control whether non-alpha items come first or last in collation
      order.
    -->
    <xsl:variable name="label" select="normalize-space($glossentry/glossdata:label)" as="xs:string"/>
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
  
  <xsl:function name="local:construct-glossary-entry-grouping-key" as="xs:string">
    <xsl:param name="context" as="node()*"/>
    <xsl:variable name="rawContextString" as="xs:string">
      <xsl:value-of select="$context"/>
    </xsl:variable>
    <xsl:variable name="grouping-key" as="xs:string" select="normalize-space($rawContextString)"/>
    <xsl:sequence select="$grouping-key"/>
  </xsl:function>
  
  <xsl:function name="local:construct-glossary-entry-sorting-key" as="xs:string">
    <xsl:param name="context" as="node()*"/>
    <xsl:variable name="rawContextString" as="xs:string">
      <xsl:value-of select="$context"/>
    </xsl:variable>
    <xsl:variable name="grouping-key" as="xs:string" select="lower-case(normalize-space($rawContextString))"/>
    <xsl:sequence select="$grouping-key"/>
  </xsl:function>
  
  
</xsl:stylesheet>
