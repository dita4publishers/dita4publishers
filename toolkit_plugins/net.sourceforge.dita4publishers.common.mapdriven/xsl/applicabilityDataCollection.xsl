<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:applicability="http://dita4publishers.org/applicability"
  xmlns="http://dita4publishers.org/applicability"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="xs xd df"
  version="2.0">
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Applicability (filtering and flagging/conditional processing/profiling)
    data collection.
    
    Gathers information about the selection (applicability) attributes used
    in all the maps and topics.
    
    Copyright (c) 2012 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->    
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="collect-applicability-data">
    <xsl:message> + [INFO] map/map Constructing applicability structure...</xsl:message>
    <xsl:variable name="conditions" as="node()*">
      <conditions>
    <!--  WEK: Commenting this out for now as it can add 10x performance cost.
    Need to diagnose and improve.
        <xsl:apply-templates mode="gather-applicability-usage"/>
        -->
      </conditions>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] conditions=
<xsl:sequence select="$conditions"/></xsl:message>
-->    <!-- Now reduce the conditions to unique values -->
    <conditions-and-values>
      <xsl:for-each-group select="$conditions/*"
        group-by="@name"
        >
        <xsl:sort select="current-grouping-key()"/>
        <condition name="{current-grouping-key()}">
          <xsl:for-each-group select="current-group()"
            group-by="@value"
            >
            <xsl:sort select="current-grouping-key()"/>
            <value name="{current-grouping-key()}"/>
          </xsl:for-each-group>
        </condition>
      </xsl:for-each-group>
    </conditions-and-values>
    <xsl:message> + [INFO] Applicability structure constructed.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*" mode="gather-applicability-usage" priority="10">
    <xsl:apply-templates select="@*" mode="#current"/>
    <xsl:next-match/>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="gather-applicability-usage" match="*[df:isTopicRef(.)][not(@format) or @format = 'dita' or @format = 'ditamap']">
    <!--xsl:message> + [DEBUG] gather-applicability-usage: processing topicref... </xsl:message-->
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <!--xsl:message> + [WARNING] gather-applicability-usage: Failed to resolve topic reference to href "<xsl:sequence select="string(@href),string(@keyref)"/>"</xsl:message-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$topic" mode="gather-applicability-usage"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template mode="gather-applicability-usage" name="gather-applicability-usage-for-simple-select-att"
    match="@audience |
    @importance |
    @otherprops |
    @platform |
    @product |
    @rev |
    @status
    "
    >
    <xsl:variable name="conditionName" select="name(.)" as="xs:string"/>
    <xsl:for-each select="tokenize(normalize-space(.), ' ')">
      <condition name="{$conditionName}" value="{.}"/>
    </xsl:for-each>
    
  </xsl:template>
  
  <xsl:template mode="gather-applicability-usage" 
    match="@props"
    >
    <xsl:choose>
      <xsl:when test="not(contains(., '('))">
        <xsl:call-template name="gather-applicability-usage-for-simple-select-att"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:analyze-string select="normalize-space(.)" regex="\((\w+) (\w+)\)\s*">
          <xsl:matching-substring>
            
            <xsl:variable name="propname" select="regex-group(1)" as="xs:string"/>
            <xsl:variable name="propvalue" select="regex-group(2)" as="xs:string"/>
            <condition name="{$propname}" value="{$propvalue}"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <!-- ignore it -->
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template mode="gather-applicability-usage" match="@*" priority="-1"/>
  
  <xsl:template match="text()" mode="gather-applicability-usage collect-applicability-data"/>
  
</xsl:stylesheet>