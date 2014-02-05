<?xml version='1.0'?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:fo="http://www.w3.org/1999/XSL/Format" 
xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
exclude-result-prefixes="ot-placeholder"
version="2.0">
  
  <!-- Override of base glossary.xsl -->

    <xsl:template match="ot-placeholder:glossarylist">
    
      <fo:block 
        xsl:use-attribute-sets="
        __glossary__label 
        topic-first-block-glossary
        " 
        id="{$id.glossary}">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Glossary'"/>
          </xsl:call-template>
      </fo:block>

      <xsl:apply-templates/>

    </xsl:template>

</xsl:stylesheet>
