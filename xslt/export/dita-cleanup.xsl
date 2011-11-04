<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:RSUITE="http://www.reallysi.com"
      xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
      exclude-result-prefixes="xs RSUITE ditaarch"
      version="2.0">
  
  <!-- DITA cleanup export transform.
    
       - Removes RSUITE Metadata
       - Strips out class, domains, and DITAArchVersion attributes
       
  -->
  
  <xsl:include href="common-identity-transform.xsl"/>
  
  <xsl:template match="RSUITE:*" priority="10"/>

  <xsl:template match="@class | @domains | ditaarch:DITAArchVersion"/>

</xsl:stylesheet>
