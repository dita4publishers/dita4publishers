<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
  exclude-result-prefixes="xs related-links"
  version="2.0">
  
  <!-- Overrides of built-in HTML generation templates -->
  
  <xsl:template match="*[contains(@class, ' topic/related-link ')]" mode="#all" name="related-links:group-result.">
    <xsl:message> + [DEBUG] Suppress related links.</xsl:message>
    <!-- Suppress related links -->
  </xsl:template>  
</xsl:stylesheet>
