<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:ooutil="http://dita4publishers.org/ns/office-open-utilities"
  xmlns:sheet="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
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

  exclude-result-prefixes="xs xd ooutil mv mo ve o r m v w10 w wne wp pic a rels c local"
  version="2.0">
  <!-- ============================================================ 
    Utilities for operating on Microsoft Office Office Open files.
    
    =============================================================== -->
    
   <xsl:key name="relsById" match="rels:Relationship" use="@Id"/>

    <xsl:function name="ooutil:resolveSharedString" as="xs:string">
      <xsl:param name="vElement" as="element(sheet:v)"/>
      <xsl:variable name="sharedStringsDoc" as="document-node()?"
        select="ooutil:getSharedStringsDoc($vElement)"
      />
      <!-- NOTE: value is zero-based index into the shared string table. -->
      <xsl:variable name="index" as="xs:integer" select="$vElement"/>
      
      <xsl:variable name="result" as="xs:string" select="string(($sharedStringsDoc/*/sheet:si)[index + 1])"/>
      <xsl:sequence select="$result"/>
    </xsl:function>
    
  <xsl:function name="local:getRunStyleId" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="
      if ($context/w:rPr/w:rStyle) 
          then string($context/w:rPr/w:rStyle/@w:val)
          else ''
    "/>
  </xsl:function>
  
  <xsl:function name="ooutil:getSharedStringsDoc" as="document-node()?">
    <xsl:param name="context" as="element()"/>
    <!-- Context should be an element within a sheet -->
    <xsl:variable name="resultDoc" as="document-node()"
      select="document('../sharedStrings.xml', root($context))"
    />    
    <xsl:sequence select="$resultDoc"/>
  </xsl:function>
  
  <xsl:function name="local:getHyperlinkStyle" as="xs:string">
    <!-- Hyperlinks don't have a directly-associated style but 
         should contain at least one text run. So we use
         the first text run as the hyperlink style to determine
         the hyperlink style.
      -->
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="
      if ($context/w:r[1]/w:rPr/w:rStyle) 
      then string($context/w:r[1]/w:rPr/w:rStyle/@w:val)
      else ''
      "/>
  </xsl:function>
  
  <xsl:function name="local:getParaStyleId" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="mapUnstyledParasTo" as="xs:string"/>
    <xsl:sequence select="
      if ($context/w:pPr/w:pStyle) 
         then string($context/w:pPr/w:pStyle/@w:val)
         else $mapUnstyledParasTo
      "/>
  </xsl:function>
  
  <xsl:function name="local:lookupStyleName" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="stylesDoc" as="document-node()"/>
    <xsl:param name="styleId" as="xs:string"/>
    <xsl:variable name="styleElem" as="element()?"
      select="key('stylesById', $styleId, $stylesDoc)[1]"
    />
    <xsl:choose>
      <xsl:when test="$styleElem">
         <xsl:variable name="styleName" as="xs:string"
           select="$styleElem/w:name/@w:val"/>
         <xsl:sequence select="$styleName"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARN] lookupStyleName(): No style definition found for style ID "<xsl:sequence select="$styleId"/>", returning style ID "<xsl:sequence select="$styleId"/>"</xsl:message>
        <xsl:sequence select="$styleId"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  
</xsl:stylesheet>