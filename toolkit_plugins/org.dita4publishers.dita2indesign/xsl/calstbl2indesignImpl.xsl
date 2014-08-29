<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:ctbl="http//dita2indesign.org/functions/cals-table-to-inx-mapping"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df ctbl incxgen e2s"
      version="2.0">
  
  <!-- CALS table to InDesign table 
    
    Generates InDesign tables from DITA CALS tables.
    Implements the "tables" mode.
    
    Copyright (c) 2010 DITA2InDesign.org
    
  -->
  
  <xsl:import href="lib/incx_generation_util.xsl"/>
  <xsl:import href="elem2styleMapper.xsl"/>
  
  <xsl:template match="*[df:class(.,'topic/table')]" mode="tables">
    <xsl:variable name="STof" select="concat('ro_',generate-id(), 'Anchor')"/>
    <xsl:variable name="colCounts" select="ctbl:calcRowCounts(.)" as="xs:integer*"/>
    <xsl:variable name="numRows" select="count(.//*[df:class(., 'topic/row')])" as="xs:integer"/>
    <xsl:variable name="numCols" select="max($colCounts)" as="xs:integer"/>
    <xsl:variable name="tableID" select="generate-id(.)"/>
    <xsl:variable name="tStyle" select="e2s:getTStyleForElement(.)" as="xs:string"/>
    <xsl:variable name="tStyleObjId" select="incxgen:getObjectIdForTableStyle($tStyle)" as="xs:string"/>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:if test="*[df:class(., 'topic/title')]">
      <xsl:call-template name="makeTableCaption">
        <xsl:with-param name="caption" select="*[df:class(., 'topic/title')]" as="node()*"/>
      </xsl:call-template>
    </xsl:if>
    <ctbl ptzz="o_{$tStyleObjId}" STof="{$STof}" HRCt="l_0" FRCt="l_0" RwCt="l_{$numRows}" colc="l_{$numCols}" 
      Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="*[df:class(., 'topic/tgroup')]" mode="crow"/>
      <!-- replace this apply templates with function to generate ccol elements.
        This apply-templates generates a ccol for every cell; just need one ccol for each column
        <xsl:apply-templates select="row" mode="ccol"/> -->
      <xsl:copy-of select="incxgen:makeCcolElems($numCols,$tableID)"/>
      <xsl:apply-templates select="*[df:class(., 'topic/tgroup')]">
        <xsl:with-param name="colCount" select="$numCols" as="xs:integer" tunnel="yes"/>
        <xsl:with-param name="rowCount" select="$numRows" as="xs:integer" tunnel="yes"/>
      </xsl:apply-templates>
    </ctbl><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tgroup')]" mode="crow">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/colspec')]" mode="crow #default">
    <!-- Ignored in this mode -->
  </xsl:template>
  
  <xsl:template match="tgroup | *[df:class(., 'topic/tgroup')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/tbody')] |
    *[df:class(., 'topic/thead')]
    " 
    mode="crow #default">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/row')]" mode="crow">
    <xsl:variable name="rowIndex" select="count(preceding-sibling::row)" as="xs:integer"/>
    <!-- changed MFHO from "17" to "1" -->
    <crow pnam="rk_{$rowIndex}" MFHo="U_1" Self="rc_{generate-id(..)}crow{$rowIndex}"/><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/row')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/entry')]">
    <xsl:param name="colCount" as="xs:integer" tunnel="yes"/>
    <xsl:param name="rowCount" as="xs:integer" tunnel="yes"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="rowNumber" select="count(../preceding-sibling::*[df:class(., 'topic/row')])" as="xs:integer"/>
    <xsl:variable name="colNumber" select="count(preceding-sibling::*[df:class(., 'topic/entry')])" as="xs:integer"/>
    <xsl:variable name="colspan">
      <!-- FIXME: This needs to be reworked for CALS tables -->
      <xsl:choose>
        <xsl:when test="@colspan">
          <xsl:value-of select="@colspan"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rowspan">
      <xsl:choose>
        <xsl:when test="@rowspan">
          <xsl:value-of select="@rowspan"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colSpan" select="incxgen:makeCSpnAttr($colspan,$colCount)"/>
    <xsl:variable name="rowSpan" select="incxgen:makeRSpnAttr($rowspan,$rowCount)"/>
    <!-- <xsl:message select="concat('[DEBUG: r: ',$colSpan,' c: ',$rowSpan)"/> -->
    <xsl:text> </xsl:text><ccel pnam="rk_{$colNumber}:{$rowNumber}" RSpn="l_{$rowSpan}" CSpn="l_{$colSpan}" pcst="o_u75" ppcs="l_0" Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <!-- must wrap cell contents in txsr and pcnt -->
      <xsl:variable name="pStyle" as="xs:string">
        <xsl:choose>
          <xsl:when test="ancestor::*[df:class(., 'topic/thead')]">
            <xsl:value-of select="'Columnhead'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'Body Table Cell'"></xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="cStyle" select="'$ID/[No character style]'" as="xs:string"/>
      <xsl:variable name="pStyleObjId" select="incxgen:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
      <xsl:variable name="cStyleObjId" select="incxgen:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
      <xsl:choose>
        <xsl:when test="df:hasBlockChildren(.)">
          <!-- FIXME: handle non-empty text before first block element -->
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="makeBlock-cont">
            <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text></ccel><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeTableCaption">
    <xsl:param name="caption" as="node()*"/>
    <xsl:variable name="pStyle" select="'tableCaption'" as="xs:string"/>
    <xsl:variable name="cStyle" select="'$ID/[No character style]'" as="xs:string"/>
    <xsl:variable name="pStyleObjId" select="incxgen:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="incxgen:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <pcnt><xsl:text>c_</xsl:text><xsl:value-of select="$caption"/></pcnt>
    </txsr>
  </xsl:template>
  
  <xsl:function name="ctbl:calcRowCounts" as="xs:integer*">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="for $row in $context//row return count($row/entry)"/>
  </xsl:function>
  
  <xsl:template mode="crow" match="*" priority="-1">
    <xsl:message> + [WARNING] (crow mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence 
      select="concat(name(.), ' [', normalize-space(@class), ']')"/></xsl:message>
  </xsl:template>
  
  
  
</xsl:stylesheet>
