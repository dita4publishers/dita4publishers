<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="df xs relpath htmlutil xd dc"
  version="2.0">
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    Root output page (navigation/index) generation. This transform
    manages generation of the root page for the generated HTML.
    It calls the processing to generate navigation structures used
    in the root page (e.g., dynamic and static ToCs).

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= --> 

  
  <xsl:template match="*" mode="generate-javascript-includes">  
		<xsl:apply-templates select="." mode="generate-d4p-javascript" />
  </xsl:template>
  
  
  <!-- this template is used to add compressed or none-compressed javascripts links -->
  <xsl:template match="*" mode="generate-d4p-javascript">
  	<xsl:choose>
  		<xsl:when test="$DBG='yes'">
  			<xsl:apply-templates select="." mode="generate-d4p-uncompressed-javascript" />
  		</xsl:when>  		
  		<xsl:otherwise>
  			<xsl:apply-templates select="." mode="generate-d4p-compressed-javascript" />		
  		</xsl:otherwise> 	
  	</xsl:choose>		
  </xsl:template>
  
  <!-- This template render ons script element per script element declared in the theme config.xml -->  
  <xsl:template match="*" mode="generate-d4p-uncompressed-javascript">
    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
  	<xsl:message> + [INFO] Debug mode on, render individual script link </xsl:message>
    <xsl:for-each select="$HTML5THEMECONFIGDOCUMENT/html5/script">
    	<xsl:message><xsl:sequence select="." /></xsl:message>
    	<script type="text/javascript" charset="utf-8" src="{relpath:fixRelativePath($relativePath, concat($HTML5THEMEDIR, '/', @path))}"></script><xsl:sequence select="'&#x0a;'"/>
    </xsl:for-each>
    <xsl:apply-templates select="." mode="generate-d4p-javascript-initializer" />	
  </xsl:template>
  
   
  <!-- 
    used to generate the js links 
    FIXME: find a way to translate javascript variables.
    ex: d4h5.locale: {
      'property': 'value',
      'property2': 'value2',
      ...    
    }
  --> 
  <xsl:template match="*" mode="generate-d4p-compressed-javascript">
  	<xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
  	
    <script type="text/javascript" src="{relpath:fixRelativePath($relativePath, $JS)}">
  		<xsl:sequence select="'&#x0a;'"/>
  	</script>
    <xsl:sequence select="'&#x0a;'"/>
    
    <xsl:apply-templates select="." mode="generate-d4p-javascript-initializer" />	

  </xsl:template>
  
 <xsl:template match="*" mode="generate-d4p-javascript-initializer">
   <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
   <xsl:variable name="json" as="xs:string" select="unparsed-text($JSONVARFILE, 'UTF-8')"/>

    <script type="text/javascript">
   		<xsl:sequence select="'&#x0a;'"/>
		<xsl:value-of select="$json" /><xsl:text>;</xsl:text>
		<xsl:sequence select="'&#x0a;'"/>		
   		<xsl:text>$(function(){d4p.init({</xsl:text>
   		<xsl:text>relativePath:'</xsl:text><xsl:value-of select="$relativePath"/><xsl:text>'</xsl:text>
   		<xsl:if test="$jsoptions != ''">
   			<xsl:text>, </xsl:text>
			<xsl:value-of select="$jsoptions" />
		</xsl:if>
		<xsl:text>});});</xsl:text>
	</script><xsl:sequence select="'&#x0a;'"/>
 
 </xsl:template>
 
</xsl:stylesheet>
