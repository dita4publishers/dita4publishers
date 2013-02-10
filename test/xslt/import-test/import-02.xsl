<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">
  
  
  <xsl:template match="foo">
    <xsl:message>import-02: got a foo</xsl:message>
    <foo-result>import-02: <xsl:apply-templates/></foo-result>
  </xsl:template>
  
  <xsl:template match="baz">
    <xsl:message>import-02: got a baz</xsl:message>
    <baz-result>import-02: <xsl:apply-templates/></baz-result>
  </xsl:template>
  
  

</xsl:stylesheet>
