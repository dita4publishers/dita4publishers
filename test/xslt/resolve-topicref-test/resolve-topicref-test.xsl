<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="xs xd mapdriven df"
  version="2.0">
  
  <!-- Test of df:resolveTopicRef() function
       
       The input to this transform should be a resolved map.
       
       The output is a report of the URLs of the topics
       referenced by each topicref.
       
    -->
  <xsl:import href="../../../toolkit_plugins/org.dita-community.common.xslt/xsl/dita-support-lib.xsl"/>
  <xsl:import href="../../../toolkit_plugins/org.dita-community.common.xslt/xsl/relpath_util.xsl"/>
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:variable name="rootMapUrl" select="string(document-uri(.))" as="xs:string"/>
    <test-result>
      <mapuri><xsl:value-of select="$rootMapUrl"/></mapuri>
      <topicref-results>
        <xsl:apply-templates select="//*[df:class(., 'map/topicref')]"/>
      </topicref-results>
    </test-result>
  </xsl:template>
  
  <xsl:template match="*[@href]">
    <topicref href="{@href}">
      <inChunk><xsl:value-of select="df:inChunk(.)"/></inChunk>
      <resultURL><xsl:value-of select="document-uri(df:resolveTopicRef(.))"/></resultURL>
    </topicref>
  </xsl:template>
  
  <xsl:template match="text()"/>

</xsl:stylesheet>