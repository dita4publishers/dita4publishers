<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="http://reallysi.com/namespaces/style-to-tag-map"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      
      exclude-result-prefixes="xs rsiwp stylemap"
      version="2.0">

  <!--==========================================
    
    
    Copyright (c) 2009 DITA 4 Publishers Project

    Transforms an InDesign IDML story file into a DITA chapter topic.
    
    The input to this transform is an IDML Story document within an IDML
    package.
    
    =========================================== -->
  
  <xsl:import href="idml2simple.xsl"/>
  <xsl:import href="../word2dita/simple2dita.xsl"/>
  
  <xsl:output 
    doctype-public="urn:pubid:dita4publishers.sourceforge.net:doctypes:dita:chapter"
    doctype-system="chapter.dtd"
  />
  
  
  <xsl:param name="debug" select="'true'" as="xs:string"/>
  
  <xsl:variable name="debugBoolean" as="xs:boolean" select="$debug = 'true'"/>  
  
  <xsl:template match="/" priority="10">
    <xsl:message> + [INFO] Idml2chapter: Starting...</xsl:message>
    
    <xsl:message> + [INFO] Idml2chapter: Generating intermediate "simple" word processing document...</xsl:message>
    <xsl:variable name="simpleWpDoc" as="element()">
      <xsl:call-template name="processStoryXml"/>
    </xsl:variable>
    <xsl:variable name="tempDoc" select="relpath:newFile($outputDir, 'simpleWpDoc.xml')" as="xs:string"/>
    
    <xsl:message> + [INFO] Idml2chapter: Converting simple WP doc into DITA output...</xsl:message>
    <!-- NOTE: do not set this check to true(): it will fail when run within RSuite -->
    <xsl:if test="$debugBoolean">        
      <xsl:result-document href="{$tempDoc}">
        <xsl:message> + [DEBUG] Intermediate simple WP doc saved as <xsl:sequence select="$tempDoc"/></xsl:message>
        <xsl:sequence select="$simpleWpDoc"/>
      </xsl:result-document>
    </xsl:if>    
    <xsl:apply-templates select="$simpleWpDoc"/>
    <xsl:message> + [INFO] Done.</xsl:message>
  </xsl:template>
  
  
</xsl:stylesheet>
