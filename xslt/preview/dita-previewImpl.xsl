<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Default DITA HTML preview style sheet for use with RSuite CMS.
       
       Provides good-enough HTML preview of DITA maps and topics. Handles
       topicref resolution, does not currently handle conref resolution.
       
       This style sheet is normally packaged as an RSuite plugin from 
       which it is used by shell transforms that override or extend
       this one in the style of the DITA Open Toolkit.
    
       =============================================================== -->
  
  <xsl:import href="../lib/dita-support-lib.xsl"/>
  <xsl:import href="../lib/resolve-map.xsl"/>
  <xsl:import href="dita-topicPreview.xsl"/>
  <xsl:import href="dita-tocModePreview.xsl"/>
  <xsl:import href="dita-hi-dPreview.xsl"/>
  <xsl:import href="dita-xml-dPreview.xsl"/>
  <xsl:import href="dita-pubmap-dPreview.xsl"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  

</xsl:stylesheet>
