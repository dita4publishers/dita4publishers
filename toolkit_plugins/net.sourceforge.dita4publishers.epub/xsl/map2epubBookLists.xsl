<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms">

  <!-- Manage generation of "book lists" as HTML files included in the EPUB (as
       distinct from EPUB-specific navigation structures such as the .ncx file).
    
       Book lists may include a ToC, list of figures, list of tables, etc.
       
       Different map types (bookmap, pubmap, etc.) may have different conventions
       or business rules for signaling the generation of specific book lists.
       
       Note that these templates only manage the generation of the lists. For each
       list there must also be an entry in the OPF manifest, OPF spine, and, optionally,
       OPF guide.
    
  -->
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-book-lists">
    <xsl:apply-templates mode="#current" 
      select="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]"
    />
  </xsl:template>
  
  <xsl:template mode="generate-book-lists" match="*[df:class(., 'map/topicref')]">
    <xsl:apply-templates mode="#current" 
      select="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]"
    />
  </xsl:template>
  
  <xsl:template mode="generate-book-lists" match="*" priority="-1">
<!--    <xsl:message> + [DEBUG] generate-book-lists: catch-all: <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>-->
  </xsl:template>
  
  <xsl:template mode="generate-book-lists" match="text()"/>
  
</xsl:stylesheet>
