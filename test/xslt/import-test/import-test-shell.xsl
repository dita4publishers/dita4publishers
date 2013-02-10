<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">
  <xsl:import href="import-02.xsl"/>
  <xsl:import href="import-01.xsl"/>
  
  <xsl:template match="/">
    <result>
      <xsl:message> + import-test-shell: root template</xsl:message>
      <xsl:apply-templates/>
    </result>
  </xsl:template>
  
</xsl:stylesheet>
