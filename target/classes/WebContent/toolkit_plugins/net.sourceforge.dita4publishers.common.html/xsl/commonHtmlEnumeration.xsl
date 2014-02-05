<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="df xs relpath htmlutil opf dc xd enum"
  version="2.0">
  
  <!-- Enumeration handling for HTML outputs -->
  
  <xsl:template mode="enumeration"  match="*[df:class(., 'topic/fig')][enum:title]">
    <!-- Context item should be enum:* from the collected-data 
        
         NOTE: Within the collected data, all titles are normalized
         to enum:title with no @class attribute.
    -->
    <span class="enumeration fig-enumeration">
      <xsl:text>Figure </xsl:text>      
      <xsl:number count="*[df:class(., 'topic/fig')][enum:title]"
        level="any"
        format="1."
      />
      <xsl:text>&#xa0;</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration"  match="*[df:class(., 'topic/table')][enum:title]">
    <!-- Context item should be enum:* from the collected-data 
        
         NOTE: Within the collected data, all titles are normalized
         to enum:title with no @class attribute.
    -->
    <span class="enumeration fig-enumeration">
      <xsl:text>Table </xsl:text>
      <xsl:number count="*[df:class(., 'topic/table')][enum:title]"
        level="any"
        format="1."
      />
      <xsl:text>&#xa0;</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration" match="*[df:class(., 'pubmap-d/part')]" 
    priority="10">
    <span class='enumeration_part'>
      <xsl:text>Part </xsl:text><!-- FIXME: Enable localization of the string. -->
      <!-- When maps are merged, if there are two root topicrefs, both get the class of the referencing 
           topicref, e.g., <keydefs/><part/> as the children of the target map becomes two mapref topicrefs in the
           merged result. -->
      <xsl:number count="*[df:class(., 'pubmap-d/part')][not(@processing-role = 'resource-only')]" format="I" level="single"/>
      <xsl:text>. </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration" 
    match="*[df:class(., 'pubmap-d/pubbody')]//*[df:class(., 'pubmap-d/chapter')]"
    >
    <span class='enumeration_chapter'>
      <xsl:text>Chapter </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number 
        count="*[df:class(., 'pubmap-d/chapter')][not(@processing-role = 'resource-only')]" 
        format="1." 
        level="any" 
        from="*[df:class(., 'pubmap-d/pubbody')]"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration" 
    match="*[df:class(., 'pubmap-d/frontmatter')]//*[df:class(., 'pubmap-d/chapter')] |
           *[df:class(., 'pubmap-d/backmatter')]//*[df:class(., 'pubmap-d/chapter')]">
    <!-- Frontmatter and backmatter chapters are not enumerated -->
  </xsl:template>
  
  <xsl:template mode="enumeration" 
    match="*[df:class(., 'pubmap-d/appendix')] | 
    *[df:class(., 'pubmap-d/appendixes')]/*[df:isTopicRef(.)]
    ">
    <span class='enumeration_chapter'>
      <xsl:text>Appendix </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number 
        count="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]" 
        format="A." 
        level="single" 
        from="*[df:class(., 'pubmap-d/appendixes')]"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  
  
</xsl:stylesheet>