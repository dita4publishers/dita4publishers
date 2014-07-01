<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs "
  version="2.0">
  
  <xsl:import href="../../net.sourceforge.dita4publishers.word2dita/xsl/docx2dita.xsl"/>

  <!-- Override of a global parameter defined in the base docx2dita.xsl module: -->
  <xsl:param name="filterBr" as="xs:string" select="'true'"/>
  

  <xsl:template match="concept/title" mode="final-fixup">
    <!-- Look for numbers for the form "1-1" at the start of titles and wrap in d4pSimpleEnumeration
         element. The number must be in the first text node, not in a subelement.
    -->
    <xsl:variable name="childNodes" select="./node()" as="node()*"/>
    <xsl:message> + [DEBUG] childNodes=<xsl:sequence select="$childNodes"/></xsl:message>
    <xsl:choose>
      <xsl:when test="$childNodes[1]/self::text() and matches($childNodes[1], '^[0-9]+')">
        <xsl:copy>
          <xsl:apply-templates select="@*" mode="#current"/>
          <xsl:analyze-string select="$childNodes[1]" regex="^(([0-9]+(-[0-9]+)*)[ ]+)(.*)">
            <xsl:matching-substring>
              <d4pSimpleEnumeration><xsl:sequence select="regex-group(1)"/></d4pSimpleEnumeration>
              <xsl:sequence select="regex-group(4)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:sequence select="."/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
          <xsl:apply-templates select="$childNodes[position() > 1]" mode="#current"/>
        </xsl:copy>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
</xsl:stylesheet>