<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd mapdriven"
  version="2.0">
  
  <!-- Test harness for running the the D4P data collection process in
       isolation.
       
       The input to this transform should be a resolved map.
       
       The output is the collected-data.xml file.
       
    -->
  <xsl:import href="../../../toolkit_plugins/net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../../toolkit_plugins/net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../../toolkit_plugins/net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>

  <xsl:import href="../../../toolkit_plugins/net.sourceforge.dita4publishers.common.mapdriven/xsl/dataCollection.xsl"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:variable name="msgprefix" as="xs:string" select="'DATACOLTEST'"/>
  
  <xsl:param name="CSSPATH" select="''"/>
  <xsl:param name="OUTEXT" select="''"/>
  <xsl:param name="topicsOutputDir" select="''"/>
  <xsl:param name="tempdir" select="''"/>
  
  <xsl:param name="outdir" select="./html2"/>

  <xsl:param name="generateIndex" as="xs:string" select="'no'"/>
  <xsl:variable name="generateIndexBoolean" 
    select="matches($generateIndex, 'yes|true|on|1', 'i')"
  />

  <xsl:param name="generateGlossary" as="xs:string" select="'no'"/>
  <xsl:variable name="generateGlossaryBoolean" 
    select="matches($generateGlossary, 'yes|true|on|1', 'i')"
  />
  
  
  <xsl:template match="/">
    <xsl:variable name="rootMapUrl" select="string(document-uri(.))" as="xs:string"/>
    <xsl:call-template name="mapdriven:collect-data">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
      <xsl:with-param name="rootMapDocUrl" select="$rootMapUrl" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>