<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns:glossdata="http://dita4publishers.org/glossdata"
                xmlns:mapdriven="http://dita4publishers.org/mapdriven"
                xmlns:enum="http://dita4publishers.org/enumerables"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum"
  >
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    HTML5 navigation structure generation.

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= -->
<!--
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
-->

<!--

<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Nunc tincidunt</a></li>
		<li><a href="#tabs-2">Proin dolor</a></li>
	</ul>
	<div id="tabs-1">
		<p> content of tab 1</p>
	</div>
	<div id="tabs-2">
		<p> content of tab 2</p>
	</div>

</div>

-->
	<xsl:variable name="maxTocDepth"  as="xs:integer" select="3" />

	<xsl:template mode="generate-html5-nav-tabbed-markup" match="*[df:class(., 'map/map')]">
  
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    
    <xsl:variable name="listItems" as="node()*">
        <xsl:apply-templates mode="generate-html5-tabbed-nav"
            select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/reltable')]
            )"
        />
    </xsl:variable>
    
    <xsl:variable name="listItemsContent" as="node()*">
        <xsl:apply-templates mode="generate-html5-tabbed-nav-content"
            select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/reltable')]
            )"
    />
    </xsl:variable>

        
    <div id="tabs-navigation">
    	<ul>
           <xsl:sequence select="$listItems"/>
         </ul>
         <div id="tab-container">
         	<xsl:sequence select="$listItemsContent"/>
         </div>
    </div>
    
    <script>
    	<xsl:text>
		$(function() {
			$( "#tabs-navigation" ).tabs();
		});
		</xsl:text>
	</script>
	
  	</xsl:template>
  	
 	
	<xsl:template match="*" mode="jquery-tab-head">
		<li><a href="#tab-{count(preceding-sibling::*) + 1}"><xsl:apply-templates select="." mode="nav-point-title"/></a></li>
  	</xsl:template>
   
   	<xsl:template match="*" mode="jquery-tab-content">
		<div id="tab-{count(preceding-sibling::*) + 1}">
			<xsl:apply-templates select="." mode="jquery-tab-content-item"/>
		</div>
  	</xsl:template>
  	
  	<xsl:template match="*" mode="jquery-tab-content-item">
		<ul>
			<xsl:apply-templates select="." mode="jquery-tab-content-navigation"/>
		</ul>
	</xsl:template>
  	
  	<xsl:template match="*" mode="jquery-tab-content-navigation">
  	
  		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
   		<xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>		
        <xsl:variable name="self" select="generate-id(.)" as="xs:string"/>
		<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
		<xsl:variable name="targetUri" as="xs:string">
			<xsl:choose>
				<xsl:when test="root($topic)!=''">		
					<xsl:value-of 
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" 
             />
        		
        		</xsl:when>
        	
        	<xsl:otherwise>
        	
     			<xsl:value-of 
            select="''" 
             />
        	</xsl:otherwise>        	
        	
        </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="relativeUri" as="xs:string">
			<xsl:choose>
				<xsl:when test="root($topic)!=''">		
					<xsl:value-of 
            select="relpath:getRelativePath($outdir, $targetUri)" 
             />
        		
        		</xsl:when>
        	
        	<xsl:otherwise>
        	
     			<xsl:value-of 
            select="''" 
             />
        	</xsl:otherwise>        	
        	
        </xsl:choose>
		</xsl:variable>
		
			<xsl:if test="$tocDepth le $maxTocDepthInt">
				<li 
					id="{$self}"
					class="{@outputclass}"
				>

				<xsl:choose>
					<!-- is there a link availaible -->
					<xsl:when test="$relativeUri!=''">           
						<a href="{$relativeUri}">
							<xsl:call-template name="nav-enumeration">
					 			<xsl:with-param name="tocDepth" select="$tocDepth" tunnel="yes" />
							</xsl:call-template>
							<xsl:apply-templates select="." mode="nav-point-title"/>
						</a>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="nav-point-title"/>
					</xsl:otherwise>	
												
				</xsl:choose>
          	
            	<xsl:call-template name="navigation-children">
            		<xsl:with-param name="tocDepth"  select="$tocDepth" tunnel="yes" />
            		<xsl:with-param name="topic"  select="$topic" />
				</xsl:call-template>
          </li>
        </xsl:if>

  	</xsl:template>
  	
  	<xsl:template name="navigation-children">
  		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
  		<xsl:param name="topic" />
  		
  	   	<xsl:variable name="isTopicRef" select="not(df:class(., 'map/topicref'))" />
 		<xsl:variable name="listItems" as="node()*">
        <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
        -->
              
        	<xsl:apply-templates 
        		mode="generate-html5-tabbed-nav-content"
            	select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                
            	<xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1" />
        	</xsl:apply-templates>
        </xsl:variable>
            	
        <xsl:if test="$listItems">
            <ul>
                <xsl:sequence select="$listItems"/>
              </ul>
        </xsl:if>
  	</xsl:template>
  	
  	<xsl:template name="nav-enumeration">
  		<xsl:param name="tocDepth" as="xs:integer"  select="1" />
		<xsl:variable name="enumeration" as="xs:string?">
			<xsl:apply-templates select="." mode="enumeration"/>
        </xsl:variable>
        
        <xsl:if test="$enumeration and $enumeration != ''">
        	<span class="enumeration enumeration{$tocDepth}"><xsl:sequence select="$enumeration"/></span>
        </xsl:if>
  	</xsl:template>
  
  	
  	  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/body')]" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>


  	 	
  	<!-- templates for tab headers -->
    <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
		<!--xsl:apply-templates select="." mode="jquery-tab-head"/-->    
    </xsl:template>
    
	<xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicRef(.)][not(@toc = 'no')]" >
		<xsl:apply-templates select="." mode="jquery-tab-head"/>
	</xsl:template>
	  	  
  	<xsl:template mode="generate-html5-tabbed-nav" match="mapdriven:collected-data">
  		<xsl:apply-templates select="." mode="jquery-tab-head"/>
  	</xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav" match="enum:enumerables">
  		<xsl:apply-templates select="." mode="jquery-tab-head"/>
    </xsl:template>
  
	<xsl:template mode="generate-html5-tabbed-nav" match="glossdata:glossary-entries" >    						
		<xsl:apply-templates select="." mode="jquery-tab-head"/>
    </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav" match="index-terms:index-terms" >    			
    	<xsl:apply-templates select="." mode="jquery-tab-head"/>
    </xsl:template>
      
    <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicGroup(.)]" priority="20" >    			
    	<xsl:apply-templates select="." mode="jquery-tab-head"/>
    </xsl:template>
  
  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/topic')]">  
  		<xsl:apply-templates select="." mode="jquery-tab-head"/>
    </xsl:template>
   
  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
  		<xsl:apply-templates select="." mode="jquery-tab-head"/>
  </xsl:template>
  
  <!-- 
       templates for tab content 
  -->
    <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->    
    </xsl:template>
    
	<xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicRef(.)][not(@toc = 'no')]" >
		<xsl:apply-templates select="." mode="jquery-tab-content"/>
	</xsl:template>
	  	  
  	<xsl:template mode="generate-html5-tabbed-nav-content" match="mapdriven:collected-data">
  		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  	</xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav-content" match="enum:enumerables">
  		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
	<xsl:template mode="generate-html5-tabbed-nav-content" match="glossdata:glossary-entries" >    						
		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav-content" match="index-terms:index-terms" >    			
    	<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
      
    <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicGroup(.)]" priority="20" >    			
    	<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:class(., 'topic/topic')]">  
  		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
  <!-- topichead elements get a navPoint, but don't actually point to
       anything.-->
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicHead(.)][not(@toc = 'no')]" >
  		<xsl:apply-templates select="." mode="jquery-tab-content"/>
  </xsl:template>

</xsl:stylesheet>