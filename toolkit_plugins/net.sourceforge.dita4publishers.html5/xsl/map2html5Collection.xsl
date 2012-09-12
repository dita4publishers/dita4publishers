<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--xsl:template mode="data-collection-extensions" match="*" priority="-1">
   <xsl:message> + [INFO] Creating Audience collection</xsl:message>
   <xsl:apply-templates select="//*[df:class(., 'topic/audience')]"/>
   <xsl:message> + [INFO] Audience collection Created</xsl:message>
  </xsl:template-->


  <xsl:template match="//*[df:class(., 'topic/audience')]">
    <xsl:message> + [INFO] Audience : <xsl:value-of select="@name"/> type: <xsl:value-of select="@type"/></xsl:message>
  </xsl:template>
  
  
</xsl:stylesheet>