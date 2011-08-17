<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  version="2.0">
  <!-- NOTE: This is the base shell transform type. Not sure how to handle
             the case where you want an FO-engine-specific transform.
             
    -->
<xsl:import href="../../../demo/fo/xsl/fo/topic2fo_shell.xsl"/>

<xsl:import href="fo/root-processing.xsl"/>
  
</xsl:stylesheet>
