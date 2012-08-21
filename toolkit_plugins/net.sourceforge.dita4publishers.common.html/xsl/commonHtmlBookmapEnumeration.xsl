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
  
  <!-- 
    DITA Map to HTML-based outputs
    
    Bookmap enumeration support.
    
    Copyright (c) 2012 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.

  -->
  
  <xsl:template mode="enumeration" match="*[df:class(., 'bookmap/part')]" 
    priority="10">
    <!-- NOTE: The not(df:isResourceOnly()) predicate is a workaround for a bug in the
               OT whereby it applies the wrong @class value to topicrefs pulled from
               submaps, for example, turning keyrefs into "map/topicref bookmap/chapter"
               
               Once that bug is fixed the check should be unnecessary.
      -->
    <span class='enumeration_part'>      
      <xsl:text>Part </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number count="*[df:class(., 'bookmap/part')][not(df:isResourceOnly(.))]" format="I" level="single"/>
      <xsl:text>. </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="enumeration" match="*[df:class(., 'bookmap/chapter')]">
    <!-- NOTE: The not(df:isResourceOnly()) predicate is a workaround for a bug in the
               OT whereby it applies the wrong @class value to topicrefs pulled from
               submaps, for example, turning keyrefs into "map/topicref bookmap/chapter"
               
               Once that bug is fixed the check should be unnecessary.
      -->
    <span class='enumeration_chapter'>
      <xsl:text>Chapter </xsl:text><!-- FIXME: Enable localization of the string. -->
      <xsl:number 
        count="*[df:class(., 'bookmap/chapter')][not(df:isResourceOnly(.))]" 
        format="1." 
        level="any"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  
  
</xsl:stylesheet>