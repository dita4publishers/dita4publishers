<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:docxrel="http://schemas.openxmlformats.org/package/2006/relationships"
                exclude-result-prefixes="xs"
                version="2.0">
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    scope="stylesheet">
    <xd:desc>
      <xd:p>Rename graphic filenames in DOCX relationships file.</xd:p>
      <xd:p>Copyright (c) 2009 DITA For Publishers, Inc.</xd:p>
      <xd:p>Originally developed by Really Strategies, Inc.</xd:p>
    </xd:desc>
  </xd:doc>
  <!--==========================================
    Copyright (c) 2009 DITA For Publishers, Inc.

    Originally developed by Really Strategies, Inc.
    =========================================== -->

  <!-- Should be set by caller -->
  <xsl:param name="graphicFileNamePrefix" select="''"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="docxrel:Relationship[@Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/image']">
    <xsl:variable name="target"
                  select="@Target"/>
    <xsl:variable name="dir"
                  select="substring-before($target, '/')"/>
    <xsl:variable name="graphic"
                  select="substring-after($target, '/')"/>
    <xsl:variable name="newGraphic"
                  select="concat($graphicFileNamePrefix, $graphic)"/>
    <xsl:variable name="newPathname"
                  select="concat($dir,'/',$newGraphic)"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="Target">
        <xsl:value-of select="$newPathname"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
