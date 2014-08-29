<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  xmlns:local="http://local/functions"
  exclude-result-prefixes="xs xd w r local"
  version="2.0">
  <!-- Generates a styles-to-tag map document for all the styles
       in an DOCX styles.xml file.
       
       TODO: Use numbering.xml to infer list type for paragraph styles.
  -->
  
  <xsl:output method="xml" indent="yes"
  />
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="w:styles" priority="10">
    <style2tagmap xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap style2tagmap.xsd"      
      >
      <title>Default Word Styles to BookMap Style-to-Tag Map</title>
      <documentation xmlns:html="http://www.w3.org/1999/xhtml">
        <html:div xmlns="http://www.w3.org/1999/xhtml">
          <p>Documentation goes here.</p>    
        </html:div>
      </documentation>
      <styles>
        <output
          name="bookmap"
          doctype-system="bookmap.dtd"
          doctype-public="-//OASIS//DTD DITA BookMap//EN"
        />
        
        <output
          name="concept"
          doctype-system="concept.dtd"
          doctype-public="-//OASIS//DTD DITA Concept//EN"
        />
        
        <output
          name="task"
          doctype-system="task.dtd"
          doctype-public="-//OASIS//DTD DITA Task//EN"
        />
        
        <output
          name="reference"
          doctype-system="reference.dtd"
          doctype-public="-//OASIS//DTD DITA Reference//EN"
        />
        
      <xsl:apply-templates/>
        </styles>
     </style2tagmap>
  </xsl:template>
  
  <!-- Paragraphs that should be skipped: -->
  
  <xsl:template 
    match="
    w:style[starts-with(@w:styleId, 'TOC')] |
    w:style[@w:styleId = 'Contents']
    " 
    priority="10">
    <style styleId="{@w:styleId}" structureType="skip"/>
  </xsl:template>
  
  <xsl:template match="w:style[starts-with(@w:styleId, 'Bullet')]" 
    priority="10">
    <xsl:variable name="listLevel"
      select="if (matches(@w:styleId, 'Bullet[0-9]+'))
      then substring(@w:styleId, 7)
      else '1'
      "
    />
    <style styleId="{@w:styleId}" 
      containerType="ul" 
      tagName="li"
      level="{$listLevel}"
      structureType="block" 
      topicZone="body"
    />
  </xsl:template>
  
  <xsl:template match="w:style[starts-with(@w:styleId, 'ListBullet')]" 
    priority="10">
    <xsl:variable name="listLevel"
    >
      <xsl:analyze-string select="@w:styleId" regex=".*([0-9]+)">
        <xsl:matching-substring>
          <xsl:sequence select="regex-group(1)"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:sequence select="'1'"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <style styleId="{@w:styleId}" 
      containerType="ul" 
      tagName="li"
      level="{$listLevel}"
      structureType="block" 
      topicZone="body"
    />
  </xsl:template>
  
  <xsl:template match="w:style[starts-with(@w:styleId, 'ListNumber')]" priority="10">
    
    <xsl:variable name="listLevel"
      >
      <xsl:analyze-string select="@w:styleId" regex=".*([0-9]+)">
        <xsl:matching-substring>
          <xsl:sequence select="regex-group(1)"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:sequence select="'1'"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <style styleId="{@w:styleId}" 
      containerType="ol" 
      tagName="li"
      level="{$listLevel}"
      structureType="block" 
      topicZone="body"
    />
  </xsl:template>
  
  <xsl:template match="w:style[@w:type = 'paragraph']" priority="5">
    <!--
      <w:style
      w:type="paragraph"
      w:default="1"
      w:styleId="Normal">
      
      
    -->
    <style styleId="{@w:styleId}"
      tagName="p"
      topicZone="body"
      level="1"
    />    
  </xsl:template>
  
  <xsl:template match="w:style[@w:type = 'character']" priority="5">
    <!--
      <w:style
      w:type="character"
      w:customStyle="1"
      w:styleId="List1Char">
      
    -->
    <style styleId="{@w:styleId}"
      tagName="ph"
      topicZone="body"
      level="1"
    />    
  </xsl:template>
  
  <xsl:template match="w:style[@w:type = 'table'] | w:style[@w:type = 'numbering']" priority="5">
    <!-- We don't currently do anything with these styles in the output so nothing to map them to. -->
  </xsl:template>
  
  <xsl:template match="w:style" priority="1">
    <xsl:message> + [INFO] Unhandled style type <xsl:sequence select="string(@w:type)"/></xsl:message>
  </xsl:template>
  
  
  <!-- Ignored elements. -->
  <xsl:template match="w:docDefaults | w:latentStyles" priority="5"/>
  
  <xsl:template match="w:*" priority="0">
    <xsl:message> + [WARN] Unhandled w: element: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="r:*">
    <xsl:message> + [WARN] Unhandled r: element: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="text()"/><!-- Suppress all text -->
  
</xsl:stylesheet>