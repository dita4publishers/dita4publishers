<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0">

  <!-- Replacement for base layout master definition code.
    
       Breaks up the layout master set construction into two
       separate phases, one for page masters, one for 
    
    -->

  <xsl:template
    name="createLayoutMasterSet">
    <fo:layout-master-set>
      
      <xsl:call-template
        name="createDefaultLayoutMasters"/>
       <xsl:apply-templates 
         select="/" mode="createLayoutMasters"/>

       <xsl:call-template 
         name="createDefaultPageSequenceMasters"/>
       <xsl:apply-templates 
         select="/" mode="createPageSequenceMasters"/>
    </fo:layout-master-set>
  </xsl:template>
  
  <xsl:template mode="createLayoutMasters" match="*">
    <!-- Implement templates in this mode to generate new layout
         masters. You can either match on "/" or
         match on specific topicref or topic elements if 
      -->
  </xsl:template>

  <xsl:template mode="createPageSequenceMasters" match="*">
    <!-- Implement templates in this mode to generate new page
         sequence masters. You can either match on "/" or
         match on specific topicref or topic elements if 
      -->
  </xsl:template>

  <xsl:template
    name="createCustomLayoutMasters">
    <!-- Override this template to create additional layout masters 
      --> </xsl:template>

  <xsl:template
    name="createDefaultLayoutMasters">

    <fo:simple-page-master
      master-name="front-cover"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.front-cover"/>
    </fo:simple-page-master>
    
    <fo:simple-page-master
      master-name="back-cover"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
    </fo:simple-page-master>
    
    <fo:simple-page-master
      master-name="inside-front-cover"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="copyright-page-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="copyright-page-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="copyright-page-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="front-matter-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="front-matter-last"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="last-frontmatter-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="last-frontmatter-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="front-matter-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="even-frontmatter-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-frontmatter-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="front-matter-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-frontmatter-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-frontmatter-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <!--TOC simple masters-->
    <fo:simple-page-master
      master-name="toc-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="even-toc-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-toc-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="toc-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-toc-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-toc-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="toc-last"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="even-toc-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-toc-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="toc-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-toc-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-toc-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <!--BODY simple masters-->
    <fo:simple-page-master
      master-name="body-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="first-body-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="first-body-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="body-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="even-body-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-body-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="body-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-body-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-body-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="body-last"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="last-body-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="last-body-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <!--INDEX simple masters-->
    <fo:simple-page-master
      master-name="index-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body__index.odd"/>
      <fo:region-before
        region-name="odd-index-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-index-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="index-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body__index.even"/>
      <fo:region-before
        region-name="even-index-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-index-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="index-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body__index.odd"/>
      <fo:region-before
        region-name="odd-index-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-index-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <!--GLOSSARY simple masters-->
    <fo:simple-page-master
      master-name="glossary-first"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-glossary-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-glossary-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="glossary-even"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.even"/>
      <fo:region-before
        region-name="even-glossary-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="even-glossary-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

    <fo:simple-page-master
      master-name="glossary-odd"
      xsl:use-attribute-sets="simple-page-master">
      <fo:region-body
        xsl:use-attribute-sets="region-body.odd"/>
      <fo:region-before
        region-name="odd-glossary-header"
        xsl:use-attribute-sets="region-before"/>
      <fo:region-after
        region-name="odd-glossary-footer"
        xsl:use-attribute-sets="region-after"/>
    </fo:simple-page-master>

  </xsl:template>

  <xsl:template name="createCustomPageSequenceMasters">
  </xsl:template>

  <xsl:template name="createDefaultPageSequenceMasters">
    
    <!-- Creates the default page sequence masters using the
         default page masters.
      -->
      <xsl:call-template
        name="generate-page-sequence-master">
        <xsl:with-param
          name="master-name"
          select="'toc-sequence'"/>
        <xsl:with-param
          name="master-reference"
          select="'toc'"/>
      </xsl:call-template>
      <xsl:call-template
        name="generate-page-sequence-master">
        <xsl:with-param
          name="master-name"
          select="'body-sequence'"/>
        <xsl:with-param
          name="master-reference"
          select="'body'"/>
      </xsl:call-template>
      <xsl:call-template
        name="generate-page-sequence-master">
        <xsl:with-param
          name="master-name"
          select="'ditamap-body-sequence'"/>
        <xsl:with-param
          name="master-reference"
          select="'body'"/>
        <xsl:with-param
          name="first"
          select="false()"/>
        <xsl:with-param
          name="last"
          select="false()"/>
      </xsl:call-template>
      <xsl:call-template
        name="generate-page-sequence-master">
        <xsl:with-param
          name="master-name"
          select="'index-sequence'"/>
        <xsl:with-param
          name="master-reference"
          select="'index'"/>
        <xsl:with-param
          name="last"
          select="false()"/>
      </xsl:call-template>
      <xsl:call-template
        name="generate-page-sequence-master">
        <xsl:with-param
          name="master-name"
          select="'front-matter-sequence'"/>
        <xsl:with-param
          name="master-reference"
          select="'front-matter'"/>
      </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
