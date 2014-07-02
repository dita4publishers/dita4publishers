<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:enum="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms enum"
  version="2.0">
  
  <xsl:template match="/" mode="generate-list-of-tables-html-toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'map/map')]" 
    mode="generate-list-of-tables-html-toc">
    <xsl:param name="collected-data" as="element()*" tunnel="yes"/>
    <xsl:apply-templates mode="#current"
        select="$collected-data/enum:enumerables//*[df:class(., 'topic/table')][enum:title]"/>
  </xsl:template>
  
  <xsl:template name="generate-table-list-html-doc">
    <xsl:param name="collected-data" as="element()*"/>

    <xsl:variable name="targetUri"
      select="relpath:newFile($outdir, concat('list-of-tables_', generate-id(.), '.html'))" 
      as="xs:string"
    />
    <xsl:variable name="lot-title" as="node()*">
      <xsl:text>List of Tables</xsl:text><!-- FIXME: Get this string from string config -->
    </xsl:variable>
    <xsl:message> + [INFO] Generating list of tables as "<xsl:sequence select="$targetUri"/>"</xsl:message>
    <xsl:result-document href="{$targetUri}"
      format="html"
      doctype-public="-//W3C//DTD XHTML 1.1//EN"
      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />         
          <title><xsl:sequence select="$lot-title"/></title>
          <xsl:call-template name="constructToCStyle"/>
        </head>
        <body class="toc-list-of-tables html-toc">
          <h2 class="toc-title"><xsl:sequence select="$lot-title"/></h2>
          <ul  class="html-toc html-toc_1 list-of-tables">
            <xsl:apply-templates select="root(.)" mode="generate-list-of-tables-html-toc">
              <xsl:with-param 
                name="collected-data" 
                select="$collected-data" 
                tunnel="yes" 
                as="element()"
              />
            </xsl:apply-templates>
          </ul>
        </body>
      </html>
    </xsl:result-document>
    
  </xsl:template>
  
  
  
  <xsl:template mode="generate-list-of-tables-html-toc" 
                match="*[df:class(., 'topic/table')]">
    <xsl:variable name="sourceUri" as="xs:string" select="@docUri"/>
    <xsl:variable name="rootTopic" select="document($sourceUri)" as="document-node()?"/>
    <xsl:variable name="targetUri"
      select="htmlutil:getTopicResultUrl($outdir, $rootTopic)" as="xs:string"/>
    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
      as="xs:string"/>
    <xsl:variable name="enumeratedElement" 
      select="key('elementsByXtrc', string(@xtrc), root($rootTopic))" 
      as="element()?"/>
    <xsl:variable name="containingTopic" as="element()"
      select="df:getContainingTopic($enumeratedElement)"
    />
    <li class="html-toc-entry html-toc-entry_1">
      <!-- FIXME: Here we're replicating ID construction logic implemented elsewhere in the Toolkit.
           This is of course fragile. -->
      <span class="html-toc-entry-text html-toc-entry-text_1"
        ><a href="{$relativeUri}{if (@origId) 
          then concat('#', $containingTopic/@id, '__', @origId) 
          else concat('#', df:generate-dita-id($enumeratedElement))}"
          >
          <xsl:if test="$contenttarget">
            <xsl:attribute name="target" select="$contenttarget"/>
          </xsl:if>
          <!-- Generate a number, if any -->
          <xsl:apply-templates select="." mode="enumeration"/> 
          <xsl:apply-templates 
            select="$enumeratedElement/*[df:class(., 'topic/title')]" 
            mode="#current"/></a></span>
    </li>    
  </xsl:template>
  
  
  <xsl:template match="*" mode="generate-list-of-tables-html-toc" priority="-1">
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] Fallback in mode generate-list-of-tables-html-toc: <xsl:sequence select="concat(name(..), '/', @class)"/> in mode generate-list-of-tables-html-toc</xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-list-of-tables-html-toc" match="text()"/>
  
  <xsl:template mode="generate-list-of-tables-html-toc" match="*[df:class(., 'topic/title')]">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>