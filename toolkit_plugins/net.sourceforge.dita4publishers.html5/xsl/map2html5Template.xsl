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

  <xsl:output name="indented-xml" method="html" indent="yes" omit-xml-declaration="yes"/>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-pages">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>

    <xsl:apply-templates select="." mode="generate-root-nav-page"/>
  </xsl:template>

  <!-- generate root pages -->
<xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-nav-page">
  <!-- Generate the root output page. By default this page contains the root
       navigation elements. The direct output of this template goes to the
       default output target of the XSLT transform.
    -->
  <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
  <xsl:param name="collected-data" as="element()" tunnel="yes"/>
  <xsl:param name="firstTopicUri" as="xs:string?" tunnel="yes"/>
  <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

  <xsl:variable name="initialTopicUri"
    as="xs:string"
    select="
    if ($firstTopicUri != '')
       then $firstTopicUri
       else htmlutil:getInitialTopicrefUri($uniqueTopicRefs, $topicsOutputPath, $outdir, $rootMapDocUrl)
       "
  />

  <xsl:variable name="indexUri" select="concat('index', $OUTEXT)"/>

  <xsl:message> + [INFO] Generating index document <xsl:sequence select="$indexUri"/>...</xsl:message>
  <xsl:result-document href="{$indexUri}" format="indented-xml">

    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
  
      <xsl:apply-templates select="." mode="generate-html5-page"/>
  
  </xsl:result-document>
</xsl:template>


  <xsl:template mode="toc-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="titleValue" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$titleValue"/>
  </xsl:template>

  <!-- FIXME: Replace this with a separate mode that will handle markup within titles -->
  <xsl:template mode="gen-head-title" match="*">
  	<xsl:param name="documentation-title" as="xs:string" select="''" tunnel="yes" />
  	<xsl:param name="topic-title" as="xs:string" select="''" tunnel="yes" />
  	
  	<xsl:variable name="title">
  		<xsl:choose>
  			<xsl:when test="$topic-title != ''">
  				<xsl:value-of select="concat($documentation-title, ' - ', $topic-title)" />
  			</xsl:when> 
  			<xsl:otherwise>
  				<xsl:value-of select="$documentation-title" />
  			</xsl:otherwise>  
  		</xsl:choose>
  	</xsl:variable>
  	
    <title><xsl:value-of select="normalize-space($title)" /></title>
  </xsl:template>

  
  <xsl:template match="*" mode="generate-html5-page">
    <html>
    
      <xsl:attribute name = "lang"><xsl:call-template name="getLowerCaseLang"/></xsl:attribute>
      
      <xsl:sequence select="'&#x0a;'"/>
  
      <xsl:apply-templates select="." mode="generate-head"/>
     
      <xsl:apply-templates select="." mode="generate-body"/>

    </html>
  </xsl:template>  
  
  <!-- 
    used to generate the js links 
    FIXME: find a way to translate javascript variables.
    ex: d4h5.locale: {
      'property': 'value',
      'property2': 'value2',    
    }
  -->
  <xsl:template match="*" mode="generate-javascript-includes">
  	<xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
  	
    <script type="text/javascript" src="{relpath:fixRelativePath($relativePath, $JS)}">
  		<xsl:sequence select="'&#x0a;'"/>
  	</script>
    <xsl:sequence select="'&#x0a;'"/>
    
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

  <!-- used to generate the css links -->
  <xsl:template match="*" mode="generate-css-includes">
  <!-- prevent aboslute path to be rewritten -->
  	<xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
    	
  	<xsl:if test="$CSS!=''">
     	<link rel="stylesheet" type="text/css" href="{relpath:fixRelativePath($relativePath, $CSS)}" />
    </xsl:if>
    
    <xsl:sequence select="'&#x0a;'"/>
    
    <link rel="stylesheet" type="text/css" href="{relpath:fixRelativePath($relativePath, $CSSTHEME)}" />
    	<xsl:sequence select="'&#x0a;'"/>
    
  </xsl:template>
  

  <!-- page links are intented to be used for screen reader -->
  <xsl:template name="gen-page-links">
     <ul id="page-links">
		<li><a id="skip-to-content" href="#{$IDMAINCONTENT}"><xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'SkipToContent'"/>
                </xsl:call-template></a></li>
		<li><a id="skip-to-localnav" href="#local-navigation"><xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'SkipToLocalNav'"/>
                </xsl:call-template></a></li>
     </ul>
  </xsl:template>

  <!-- define class attribute -->
  <xsl:template match="*" mode="set-body-class-attr">
    <xsl:attribute name = "class">
      <xsl:call-template name="getLowerCaseLang"/>
        <xsl:sequence select="' '"/>
        <xsl:value-of select="$siteTheme" />
        <xsl:sequence select="' '"/>
        <xsl:value-of select="$BODYCLASS" />
        <xsl:apply-templates select="." mode="gen-user-body-class"/>
    </xsl:attribute>
  </xsl:template>

  <!-- used to defined initial content if javascript is off -->
  <xsl:template match="*" mode="set-initial-content">
		<noscript>
			<p><xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'turnJavascriptOn'"/>
                </xsl:call-template>
			</p>
		</noscript>
  </xsl:template>
  
  <!-- used to output the html5 header -->
  <xsl:template match="*" mode="generate-header">
  	<xsl:param name="documentation-title" as="xs:string" select="''" tunnel="yes" />
    <header role="banner" aria-labelledby="publication-title">
     	<h1 id="publication-title">
    		<xsl:value-of select="$documentation-title"/>
    	</h1>
    </header>
  </xsl:template>
  
  <!-- used to output the head -->  
    <xsl:template match="*" mode="generate-head">
      <head>

      <xsl:apply-templates select="." mode="gen-head-title" />
       
      <xsl:sequence select="'&#x0a;'"/>

	  <xsl:apply-templates select="." mode="gen-user-top-head" />
	  
      <meta charset="utf-8" />
      <xsl:sequence select="'&#x0a;'"/>

      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <xsl:sequence select="'&#x0a;'"/>
      
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
      <xsl:sequence select="'&#x0a;'"/>

      <!-- initial meta information -->
      <xsl:call-template name="getMeta"/>
      
      <xsl:call-template name="copyright"/>   

		<xsl:apply-templates select="." mode="generate-css-includes"/>
						 
        <xsl:apply-templates select="." mode="generate-javascript-includes"/>
        
	    <xsl:apply-templates select="." mode="gen-user-bottom-head" />
	    
    </head>
    <xsl:sequence select="'&#x0a;'"/>
  </xsl:template>
  
  <!-- generate body -->
  <xsl:template match="*" mode="generate-body">
    
    <body>

      <xsl:apply-templates select="." mode="set-body-class-attr" />
    
      <xsl:apply-templates select="." mode="gen-user-body-top" />
             
      <xsl:apply-templates select="." mode="generate-main-container"/>
	
	  <xsl:apply-templates select="." mode="gen-user-body-bottom" />
	  
    </body>
    
    <xsl:sequence select="'&#x0a;'"/>
    
  </xsl:template>
    
  <!-- generate main container -->
  <xsl:template match="*" mode="generate-main-container">

    <div id="{$IDMAINCONTAINER}" class="{$CLASSMAINCONTAINER}" role="application">
    
      <xsl:sequence select="'&#x0a;'"/>
      
      <xsl:call-template name="gen-page-links" />
    		
      <xsl:apply-templates select="." mode="generate-header"/>
      
      <xsl:apply-templates select="." mode="generate-section-container"/>
      
      <xsl:apply-templates select="." mode="generate-footer"/>
      
    </div>
  </xsl:template>
  
  <!-- generate section container -->
   <xsl:template match="*" mode="generate-section-container">
   		<xsl:param name="navigation" as="element()*"  tunnel="yes" />
   		<xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
   
   
     <div id="{$IDSECTIONCONTAINER}" class="{$CLASSSECTIONCONTAINER}">

        <xsl:choose>
        	<xsl:when test="$is-root">
        		<xsl:sequence select="$navigation"/>
        	</xsl:when>
        	<xsl:otherwise>
        		<xsl:variable name="navigation-fixed">
         			<xsl:apply-templates select="$navigation" mode="fix-navigation-href"/>
         		</xsl:variable>
         
         		<xsl:sequence select="$navigation-fixed"/>
        	</xsl:otherwise>
        
        </xsl:choose>
        

        <xsl:apply-templates select="." mode="generate-main-content"/>
        
      </div>
   </xsl:template>
   
   
  
  
   <!-- generate main content -->
  <xsl:template match="*" mode="generate-main-content"> 
   	<xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
   	<xsl:param name="content" tunnel="yes" as="node()*" />
   	
    <div id="{$IDMAINCONTENT}" class="{$CLASSMAINCONTENT}">    
         
      <xsl:choose>
      
        	<xsl:when test="$is-root">
        		<xsl:apply-templates select="." mode="set-initial-content"/>
        	</xsl:when>
        	<xsl:otherwise>
        		<!-- !important
        		     if you remove section, you will need to change
        		     the d4p.property externalContentElement
        		-->
        		<section>
        			<xsl:sequence select="$content"/>
        		</section>
        	</xsl:otherwise>
        
        </xsl:choose>      

      <div class="clear" /><xsl:sequence select="'&#x0a;'"/>
      
    </div>
  </xsl:template>
  
  <!-- choose navigation markup type 
        will be used later to offer alternate markup for navigation
   -->

   <xsl:template match="*" mode="choose-html5-nav-markup">
    <xsl:message> + [INFO] Generating HTML5 <xsl:value-of select="$NAVIGATIONMARKUP" />navigation ...</xsl:message>
   <xsl:choose>
        <!-- 
        	Experimental
        -->
          <xsl:when test="$NAVIGATIONMARKUP='navigation-tabbed'">
          	<xsl:message> + [WARNING] This code is experimental !</xsl:message>
            <xsl:apply-templates select="." mode="generate-html5-nav-tabbed-markup"/>
          </xsl:when>
          
          <xsl:when test="$NAVIGATIONMARKUP='navigation-ico'">
          	<xsl:message> + [WARNING] This code is experimental !</xsl:message>
            <xsl:apply-templates select="." mode="generate-html5-nav-ico-markup"/>
          </xsl:when>
          
           <xsl:when test="$NAVIGATIONMARKUP='navigation-whole-page'">
          	<xsl:message> + [WARNING] This code is experimental !</xsl:message>
            <xsl:apply-templates select="." mode="generate-html5-nav-whole-page"/>
          </xsl:when>
          
          <xsl:otherwise>
            <!-- This mode generates the navigation structure (ToC) on the
                index.html page, that is, the main navigation structure.
             -->
            <xsl:apply-templates select="." mode="generate-html5-nav-page-markup"/>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:template>
  
  <!-- generate html5 footer -->
  <xsl:template match="*" mode="generate-footer">  	
    <div id="footer-container" class="container_24">
		<xsl:call-template name="gen-user-footer"/>
		<xsl:call-template name="processFTR"/>
		<xsl:sequence select="'&#x0a;'"/>
	</div>
  </xsl:template>
  
  <!--
  
  -->
   
 	<xsl:template match="@*|node()" mode="fix-navigation-href">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="fix-navigation-href"/>
		</xsl:copy>
    </xsl:template>
    
    <xsl:template match="@href" mode="fix-navigation-href">

    	<xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes" />
    	<xsl:variable name="prefix">
  	    	<xsl:choose>
  	    		<xsl:when test="substring(., 1, 1) = '#'">
  	    			<xsl:value-of select="''" />
  	    		</xsl:when>
  	    		<xsl:when test="substring(., 1, 1) = '/'">
  	    			<xsl:value-of select="''" />
  	    		</xsl:when>
  	    		<xsl:otherwise>
  	    			<xsl:value-of select="$relativePath" />
  	    		</xsl:otherwise>
  	    	    	
  	    	</xsl:choose>
  	    	</xsl:variable>
    		
    		
		<xsl:attribute name="href" select="concat($prefix, .)"/>
    </xsl:template>
    

  		
  <!-- 
      template declared for extention point purpose 
   -->
  <xsl:template match="*" mode="gen-user-top-head">
    <!-- to allow insertion into the head -->
  </xsl:template>
  
  <xsl:template match="*" mode="gen-user-bottom-head">
    <!-- to allow insertion into the head -->
  </xsl:template>
  
  <xsl:template match="*" mode="gen-user-body-class">
    <!-- to to append class class to the body element 
         to override class use xsl:template match="*" mode="set-body-class-attr"
    -->
  </xsl:template>
  
  <xsl:template match="*" mode="gen-user-body-top">
    <!-- to to append class class to the body element 
         to override class use xsl:template match="*" mode="set-body-class-attr"
    -->
  </xsl:template>
  
  <xsl:template match="*" mode="gen-user-body-bottom">
    <!-- to to append class class to the body element 
         to override class use xsl:template match="*" mode="set-body-class-attr"
    -->
  </xsl:template>


</xsl:stylesheet>
