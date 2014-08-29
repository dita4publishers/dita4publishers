<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  >
  <!-- Formatting domain elements to XSL-FO -->
  
  <!-- Default width to use for tabs -->
  <xsl:param name="tabWidth" select="'1pc'" as="xs:string"/>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <!--<xsl:message> + [DEBUG] handling d4p-formatting-d/br </xsl:message>-->
    <!-- WEK: Previously had non-breaking space. This causes extra vertical space 
         in AXF and FOP.
      -->
    <fo:block>&#x0020;</fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/tab ')]" priority="10"
    mode="#default getTitle">
    <fo:leader leader-length="{tabWidth}" leader-pattern="space"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' d4p-formatting-d/b-i ')]">
    <fo:inline font-weight="bold" font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <!-- FIXME: Implement some sort of support for the other formatting-d elements. -->
  <!--
    The following implements the d4pSidebarAnchor. With the use of keys, it suppresses the location of the anchoredObject (e.g., a sidebar) and instead copies it to the result tree in the location of the d4pSidebarAnchor. Currently commented out pending recommended changes to the d4pSidebarAnchor element. Code does work and is in use at Human Kinetics -->
  <!--
  <xsl:key name="kObjectAnchor" match="*[df:class(.,'topic/xref d4p-formatting-d/d4pSidebarAnchor')]" use="@otherprops"/>
  
  <xsl:key name="kAnchoredObject" match="*" use="@id"/>
  
  <xsl:template match="*[df:class(.,'topic/xref d4p-formatting-d/d4pSidebarAnchor')]" priority="20">
    <xsl:apply-templates select=
      "key('kAnchoredObject', @otherprops)">
      <xsl:with-param name="useNextMatch" select="'true'" as="xs:string" />
    </xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="*[key('kObjectAnchor', @id)]" priority="20">
    <xsl:param name="useNextMatch" select="'false'" as="xs:string" />
    <xsl:choose>
      <xsl:when test="$useNextMatch='true'">
        <xsl:next-match/>
      </xsl:when> 
    </xsl:choose>
  </xsl:template>
  -->
</xsl:stylesheet>
