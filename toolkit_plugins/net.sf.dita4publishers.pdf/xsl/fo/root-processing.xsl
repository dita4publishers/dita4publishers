<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd"
  version="2.0">
  
  <!-- Override of templates from the base root-processing.xsl -->
  
      <xsl:template name="rootTemplate">
        <xsl:call-template name="validateTopicRefs"/>
        <xsl:message>*** d4p/root-processing.xsl: rootTemplate</xsl:message>

        <fo:root xsl:use-attribute-sets="__fo__root">

            <xsl:comment>
                <xsl:text>Layout masters = </xsl:text>
                <xsl:value-of select="$layout-masters"/>
            </xsl:comment>

            <xsl:call-template name="createLayoutMasters"/>

            <xsl:call-template name="createBookmarks"/>

            <xsl:call-template name="createFrontMatter"/>

            <xsl:call-template name="createToc"/>

<!--            <xsl:call-template name="createPreface"/>-->

            <xsl:apply-templates/>

            <xsl:call-template name="createIndex"/>

        </fo:root>
    </xsl:template>

  
</xsl:stylesheet>