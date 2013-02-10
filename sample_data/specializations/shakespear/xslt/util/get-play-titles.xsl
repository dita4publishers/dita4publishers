<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">

  <xsl:import href="../../../../../xslt/util/common-identity-transform.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>
  
  <xsl:template match="tbody/row/entry[1]">
    <xsl:variable name="epubFilename" select="normalize-space(.)" as="xs:string"/>
    <xsl:message> + [DEBUG] epubFilename="<xsl:sequence select="$epubFilename"/>"</xsl:message>
    <xsl:variable name="playName" select="substring-before($epubFilename, '.')" as="xs:string"/>
    <xsl:variable name="mapFilename" 
      select="concat('/Users/ekimber/workspace/dita4publishers/sample_data/specializations/shakespear/plays/',
                     $playName, '/', $playName, '.ditamap')"
    />
    <entry>
      <xsl:sequence 
        select="normalize-space(document($mapFilename)/*/*[contains(@class, ' topic/title ')])"
      />
    </entry>
  </xsl:template>

</xsl:stylesheet>
