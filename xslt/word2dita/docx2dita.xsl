<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:local="urn:local-functions"
  xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
  xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
  version="2.0">
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    scope="stylesheet">
    <xd:desc>
      <xd:p>DOCX to DITA generic transformation</xd:p>
      <xd:p>Copyright (c) 2009 DITA For Publishers, Inc.</xd:p>
      <xd:p>Transforms a DOCX document.xml file into a DITA topic using a style-to-tag mapping. </xd:p>
      <xd:p>This transform is intended to be the base for more specialized transforms that provide
        style-specific overrides. The input to this transform is the document.xml file within a DOCX
        package. </xd:p>
      <xd:p>Originally developed by Really Strategies, Inc.</xd:p>
    </xd:desc>
  </xd:doc>
  <!--==========================================
    DOCX to DITA generic transformation
    
    Copyright (c) 2009 DITA For Publishers, Inc.

    Transforms a DOCX document.xml file into a DITA topic using
    a style-to-tag mapping.
    
    This transform is intended to be the base for more specialized
    transforms that provide style-specific overrides.
    
    The input to this transform is the document.xml file within a DOCX
    package.
    
    
    Originally developed by Really Strategies, Inc.
    
    =========================================== -->
  <xsl:include
    href="wordml2simple.xsl"/>
  <xsl:include
    href="simple2dita.xsl"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:param
    name="debug"
    select="'true'"
    as="xs:string"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:variable
    name="debugBoolean"
    as="xs:boolean"
    select="$debug = 'true'"/>
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p/>
    </xd:desc>
  </xd:doc>
  <xsl:template
    match="/"
    priority="10">
    <xsl:variable
      name="simpleWpDoc"
      as="element()">
      <xsl:call-template
        name="processDocumentXml"/>
    </xsl:variable>
    <xsl:variable
      name="tempDoc"
      select="relpath:newFile($outputDir, 'simpleWpDoc.xml')"
      as="xs:string"/>
    <!-- NOTE: do not set this check to true(): it will fail when run within RSuite -->
    <xsl:if
      test="$debugBoolean">
      <xsl:result-document
        href="{$tempDoc}">
        <xsl:message> + [DEBUG] Intermediate simple WP doc saved as <xsl:sequence
            select="$tempDoc"/></xsl:message>
        <xsl:sequence
          select="$simpleWpDoc"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:apply-templates
      select="$simpleWpDoc">
      <xsl:with-param name="resultUrl" select="relpath:newFile($outputDir, 'temp.output')" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:message> + [INFO] Done.</xsl:message>
  </xsl:template>
</xsl:stylesheet>
