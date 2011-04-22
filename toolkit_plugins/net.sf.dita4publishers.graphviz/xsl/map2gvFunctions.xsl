<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:gv="http://dita4publishers.sf.net/functions/graphviz"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 22, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:function name="gv:makeProperty" as="xs:string">
    <xsl:param name="propName" as="xs:string"/>
    <xsl:param name="value"/>
    <xsl:sequence select="concat('label=', gv:quoteString(string-join($value, '')), ',')"/>
    
  </xsl:function>

  <xsl:function name="gv:quoteString" as="xs:string">
    <xsl:param name="inSTring" as="xs:string"/>
    <xsl:sequence select='concat("""", replace($inSTring, """", "\\"""), """")'/>
  </xsl:function>
  
</xsl:stylesheet>