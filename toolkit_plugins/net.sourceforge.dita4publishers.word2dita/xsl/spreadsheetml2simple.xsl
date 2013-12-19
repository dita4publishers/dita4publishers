<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:ws="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mv="urn:schemas-microsoft-com:mac:vml"
      xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
      xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
      xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
      xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:w10="urn:schemas-microsoft-com:office:word"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
      xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
      xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
      xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
      xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
      xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart"
      
      xmlns:local="urn:local-functions"
      xmlns:ooutil="http://dita4publishers.org/ns/office-open-utilities"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a c pic xs mv mo ve o r m v w10 w wne wp ws local relpath saxon"
      version="2.0">
  
  <!-- ==================================
       Spreadsheet markup language to Simple Word Processing ML
       
       Generates generic table markup from spreadsheets.
       
       ================================== -->
  
  <xsl:template match="/" mode="spreadsheet-to-cals-table">
<!--    <xsl:message> + [DEBUG] spreadsheet-to-cals-table, "/": Handling document: <xsl:sequence select="."/></xsl:message>-->
    <!-- Root should be a worksheet element -->
    <xsl:apply-templates mode="#current"/>
<!--    <xsl:message> + [DEBUG] spreadsheet-to-cals-table: Done with "/" template</xsl:message>-->
  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" match="ws:worksheet">
<!--    <xsl:message>+ [DEBUG] spreadsheet-to-cals-table: ws:worksheet</xsl:message>-->
    <table styleId="table" structureType="block" tagName="table" topicZone="body">
      <xsl:apply-templates mode="#current"/>
    </table>

  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" 
    match="ws:cols">
    <!--<xsl:message>+ [DEBUG] spreadsheet-to-cals-table: ws:cols</xsl:message>-->
    <cols>
      <xsl:apply-templates mode="#current"/>
    </cols>

  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" match="ws:col">
<!--    <xsl:message>+ [DEBUG] spreadsheet-to-cals-table: ws:col</xsl:message>-->
    <!-- The width is a unitless number so it should work as a proportional width -->
    <!-- The col element can apply to multiple columns, so we need to 
         repeat it for the number of times it repeats.
         
      -->
    <xsl:variable name="context" select="." as="node()"/>
    <xsl:variable name="min" select="@min" as="xs:integer"/>
    <xsl:variable name="max" select="@max" as="xs:integer"/>
    <xsl:for-each select="$min to $max">
      <col width="{$context/@width}"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" match="ws:sheetData">
<!--    <xsl:message>+ [DEBUG] spreadsheet-to-cals-table: ws:sheetData</xsl:message>-->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="spreadsheet-to-cals-table" match="ws:row">
    <tr>
      <xsl:apply-templates mode="#current"/>
    </tr>
  </xsl:template>

  <xsl:template mode="spreadsheet-to-cals-table" match="ws:c">
    <td>
      <p style="entry" styleName="entry" tagName="p" outputclass="entry" topicZone="body" level="1"><xsl:apply-templates mode="#current"/></p>
    </td>
  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" match="ws:v">
    <!-- NOTE: The type is not always specified. -->
    <xsl:variable name="type" as="xs:string?" select="../@t"/>
    <!-- From Office Open XML Part 1 - 18.18.11 ST_CellType (Cell Type):
      
b (Boolean) Cell containing a boolean.
d (Date) Cell contains a date in the ISO 8601 format.
e (Error) Cell containing an error.
inlineStr (Inline String) Cell containing an (inline) rich string, i.e., one not in
the shared string table. If this cell type is used, then
the cell value is in the is element rather than the v
element in the cell (c element).
n (Number) Cell containing a number.
s (Shared String) Cell containing a shared string.
str (String) Cell containing a formula string.      
      -->
<!--    <xsl:message> + [DEBUG] spreadsheet-to-cals-table: ws:v: type="<xsl:sequence select="$type"/>"</xsl:message>-->
    <xsl:choose>
      <xsl:when test="$type = 's'">
        <xsl:sequence select="ooutil:resolveSharedString(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="spreadsheet-to-cals-table" 
    match="
     ws:dimension | 
     ws:sheetViews |
     ws:sheetFormatPr |
     ws:pageMargins |
     ws:pageSetup |
     ws:legacyDrawing |
     ws:tableParts |
     ws:extLst
    "/><!-- Ignore -->
  
  <xsl:template mode="spreadsheet-to-cals-table" match="text()" priority="-1">
    <!-- Suppress text by default -->
  </xsl:template>
  
  <xsl:template mode="spreadsheet-to-cals-table" match="*" priority="-1">
<!--    <xsl:message> + [DEBUG] spreadsheet-to-cals-table: Unhandled element <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>-->
  </xsl:template>
  
</xsl:stylesheet>