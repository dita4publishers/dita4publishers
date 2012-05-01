<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:enum="http://dita4publishers.org/enumerables"
  
  exclude-result-prefixes="df xs relpath htmlutil opf dc xd enum"
  version="2.0">
  
  <!-- Enumeration handling for HTML outputs -->
  
  <xsl:template mode="enumeration"  match="*[df:class(., 'topic/fig')][enum:title]">
    <!-- Context item should be enum:* from the collected-data 
        
         NOTE: Within the collected data, all titles are normalized
         to enum:title with no @class attribute.
    -->
    <span class="enumeration fig-enumeration">
      <xsl:text>Figure </xsl:text>      
      <xsl:number count="*[df:class(., 'topic/fig')][enum:title]"
        level="any"
        format="1."
      />
      <xsl:text>&#xa0;</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration"  match="*[df:class(., 'topic/table')][enum:title]">
    <!-- Context item should be enum:* from the collected-data 
        
         NOTE: Within the collected data, all titles are normalized
         to enum:title with no @class attribute.
    -->
    <span class="enumeration fig-enumeration">
      <xsl:text>Table </xsl:text>
      <xsl:number count="*[df:class(., 'topic/table')][enum:title]"
        level="any"
        format="1."
      />
      <xsl:text>&#xa0;</xsl:text>
    </span>
  </xsl:template>
  
</xsl:stylesheet>