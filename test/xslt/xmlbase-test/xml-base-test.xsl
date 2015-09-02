<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <xsl:template match="/">
    <xsl:variable name="baseURI" as="xs:anyURI" select="base-uri(.)"/>
    <xsl:variable name="resultBase" as="xs:string" select="string-join(tokenize($baseURI, '/')[position() lt last()], '/')"/>
    <xsl:variable name="resultDoc" as="document-node()">      
      <xsl:document>
        <result>
          <xsl:attribute name="xml:base" select="$resultBase"/>
          <a>Result document</a>
        </result>
      </xsl:document>
    </xsl:variable>
    <xsl:message> + [DEBUG] base-uri($resultDoc/*)="<xsl:value-of select="base-uri($resultDoc/*)"/>"</xsl:message>
    <xsl:sequence select="$resultDoc"/>
    
  </xsl:template>
  
</xsl:stylesheet>