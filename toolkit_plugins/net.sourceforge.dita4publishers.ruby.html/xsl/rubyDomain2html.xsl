<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the rubyDomain DITA domain.
     
     Copyright (c) 2010 W. DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="
    *[contains(@class, ' d4p-ruby-d/ruby ')] |
    *[contains(@class, ' d4p-ruby-d/rb ')]  |
    *[contains(@class, ' d4p-ruby-d/rp ')]  |
    *[contains(@class, ' d4p-ruby-d/rt ')] 
    " priority="10">
     <xsl:copy copy-namespaces="no"><xsl:apply-templates/></xsl:copy>
  </xsl:template>

  
</xsl:stylesheet>
