<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath" xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven" xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum">
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    HTML5 navigation structure generation.

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= -->


  <xsl:variable name="maxdepth" as="xs:integer" select="3"/>

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
  </xsl:template>

  <!-- Tabs header -->
  <xsl:template match="*" mode="jquery-tab-head">
    <xsl:variable name="rawCount" as="xs:string">
      <xsl:number count="topichead"/>
    </xsl:variable>
    <xsl:if test="$rawCount != ''">
      <xsl:variable name="count" select="$rawCount"/>
      <li>
        <a href="{concat('#tab-', $count)}">
          <xsl:apply-templates select="." mode="nav-point-title"/>
        </a>
      </li>
    </xsl:if>
  </xsl:template>
  
  
  <!-- tabs content -->
  <xsl:template match="*" mode="jquery-tab-content">
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    
    <xsl:variable name="items" as="node()*">
      <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
        -->
      <xsl:apply-templates mode="html5-blocks"
        select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
        
        <xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1"/>
      </xsl:apply-templates>
    </xsl:variable>
          <xsl:variable name="count" as="xs:integer"><xsl:number count="topichead"/></xsl:variable>
        <xsl:variable name="countItems" select="count($items)"/>

    <div id="{concat('tab-', $count)}" class="content-chunk">
      <xsl:if test="$items">
      	<h2><xsl:apply-templates select="." mode="nav-point-title"/></h2>
      	<div class="{concat('section-content', ' ', 'items-', $countItems)}">
        <xsl:sequence select="$items"/>
        </div>
        <div class="clear"/>      
      </xsl:if>
    </div>
    
  </xsl:template>
  

  <xsl:template name="html5-tab-content-block">
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="id" as="xs:string" tunnel="yes" select="''"/>
    <xsl:param name="relativeUri" as="xs:string" tunnel="yes" select="''"/>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

    <h3>
      <xsl:apply-templates select="." mode="nav-point-title"/>
    </h3>

  </xsl:template>


  <xsl:template name="nav-enumeration">
    <xsl:param name="depth" as="xs:integer" select="1"/>
    <xsl:variable name="enumeration" as="xs:string?">
      <xsl:apply-templates select="." mode="enumeration"/>
    </xsl:variable>

    <xsl:if test="$enumeration and $enumeration != ''">
      <span class="enumeration enumeration{$depth}">
        <xsl:sequence select="$enumeration"/>
      </span>
    </xsl:if>
  </xsl:template>



  <!-- 
  		Templates for tab headers -->
  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]"> </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/meta')]" />


  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicRef(.)][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="jquery-tab-head"/>
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="mapdriven:collected-data"> </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="enum:enumerables"> </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="glossdata:glossary-entries"> </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="index-terms:index-terms"> </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicGroup(.)]" priority="20">
    <xsl:apply-templates select="." mode="jquery-tab-head"/>
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/topic')][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="jquery-tab-head"/>
  </xsl:template>

  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="jquery-tab-head"/>
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicHead(.)][@toc = 'no']"> </xsl:template>

  <!-- 
       templates for tab content 
  -->
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
    <!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicRef(.)][not(@toc = 'no')][not(ancestor::*[df:class(., 'map/topicref')][@copy-to])]">
    <xsl:apply-templates select="." mode="jquery-tab-content"/>
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="mapdriven:collected-data">
    <!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="enum:enumerables">
    <!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="glossdata:glossary-entries"> </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="index-terms:index-terms"> </xsl:template>
  
  


  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicGroup(.)]" priority="20">
    <!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:class(., 'topic/topic')]">
    <!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
  </xsl:template>

  <!-- topichead elements get a navPoint, but don't actually point to anything.-->
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
    <xsl:apply-templates select="." mode="jquery-tab-content"/>
  </xsl:template>

  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicHead(.)][@toc = 'no']"> </xsl:template>


  <!-- 
    templates for blocks
   -->
  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/title')][not(@toc = 'no')]"></xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:isTopicRef(.)][@toc = 'no']"></xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/meta')]"></xsl:template>

  <xsl:template mode="html5-blocks" match="mapdriven:collected-data"></xsl:template>

  <xsl:template mode="html5-blocks" match="enum:enumerables"></xsl:template>

  <xsl:template mode="html5-blocks" match="glossdata:glossary-entries"></xsl:template>

  <xsl:template mode="html5-blocks" match="index-terms:index-terms"></xsl:template>

  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/topic')]"></xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/navtitle')]"></xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/title')]"></xsl:template>
  
    <xsl:template mode="html5-blocks" match="*[df:isTopicRef(.)][not(@toc = 'no')]">
   		<xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes" />
    	<xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
    	<xsl:param name="topicElement" as="xs:string" tunnel="yes" select="'p'" />
      
     <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:if test="$depth le $maxTocDepthInt">
     <xsl:element name="{$topicElement}">
     	<xsl:apply-templates select="." mode="print-title-link">
     		<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1" />
     	    <xsl:with-param name="topic" as="element()*" select="$topic" />    
        </xsl:apply-templates>
     
     <xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            <xsl:variable name="items" as="node()*">

              <xsl:apply-templates mode="#current"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">  
                	<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1" />
                  <xsl:with-param name="topicElement" as="xs:string" tunnel="yes" select="$topicElement" />    
              </xsl:apply-templates>
              
            </xsl:variable>
            <xsl:if test="$items">
                <ul>
               	 	<xsl:sequence select="$items"/>
               	</ul>
            </xsl:if>
          </xsl:if>
  	</xsl:element>
     </xsl:if>
  </xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:isTopicRef(.)][contains(@chunk, 'to-toc')]" priority="20">
   <xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
  <xsl:message> + [INFO] TOPICREF TO MERGE DETECTED</xsl:message>
  	<xsl:apply-templates mode="merge-content" select=".">  
        		<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth" />
        	</xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:isTopicGroup(.)][contains(@chunk, 'to-toc')]" priority="20">
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

    <xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
    	<xsl:message> + [INFO] TOPICGROUP TO MERGE DETECTED</xsl:message>
    	<!--xsl:message><xsl:sequence select="."/></xsl:message-->
    	<xsl:variable name="items" as="node()*">

        	<xsl:apply-templates mode="merge-content" select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">  
        		<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth" />
        	</xsl:apply-templates>
              
        </xsl:variable>
        
        <xsl:if test="$items">
           	<section class="{@outputclass}">
   	 			<xsl:sequence select="$items"/>
   			</section> 
        </xsl:if>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template mode="merge-content" match="*">
     	 <xsl:message> + [INFO] MERGING TOPIC <xsl:value-of select="@href" /> INTO CONTENT</xsl:message>
  	  	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
  	  	
    		<xsl:apply-templates mode="child.topic" select="$topic">
    			<xsl:with-param name="nestlevel" select="3" />
    			<xsl:with-param name="headinglevel" select="3" />
    		</xsl:apply-templates>
    
  </xsl:template>
  
   <xsl:template mode="merge-content" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
    	<xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
    	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
  	  	<xsl:if test="$depth le $maxTocDepthInt">
			<xsl:element name="{concat('h', $depth + 1)}">
				<xsl:apply-templates select="." mode="nav-point-title"/>
			</xsl:element>
      
      		<xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            	<xsl:variable name="items" as="node()*">

              		<xsl:apply-templates mode="html5-blocks"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">  
                	<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1" />
                  	    
              	</xsl:apply-templates>
              
            	</xsl:variable>
            	
            	<xsl:if test="$items">
                	<xsl:sequence select="$items"/>
            	</xsl:if>
      		</xsl:if>
      	</xsl:if>
  </xsl:template>

  <xsl:template mode="html5-blocks" match="*[df:isTopicGroup(.)]">
    <xsl:param name="topicElement">
    <xsl:choose>
    		<xsl:when test="contains(@outputclass, 'ul-list')">li</xsl:when>
    	    <xsl:when test="contains(@outputclass, 'ol-list')">li</xsl:when>
    		<xsl:otherwise>div</xsl:otherwise>
    	</xsl:choose> 
    </xsl:param>
    
    <!-- topic depth -->
    <xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
    
  	<!-- topic -->
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

	<!-- name of the element -->    
    <xsl:variable name="name">
    	<xsl:choose>
    		<xsl:when test="contains(@outputclass, 'ul-list')">ul</xsl:when>
    	    <xsl:when test="contains(@outputclass, 'ol-list')">ol</xsl:when>
    		<xsl:otherwise>div</xsl:otherwise>
    	</xsl:choose>  
    </xsl:variable>

    <xsl:if test="$depth le $maxTocDepthInt">
    
    
    <!-- output starts here -->
  	<xsl:element name="{$name}">
  		<xsl:attribute name="class" select="@outputclass" />
  		<xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            <xsl:variable name="items" as="node()*">

              <xsl:apply-templates mode="#current"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                  <xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1" />
                  <xsl:with-param name="topicElement" as="xs:string" tunnel="yes" select="$topicElement" />
              </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$items">
                <xsl:sequence select="$items"/>
            </xsl:if>
          </xsl:if>
  	</xsl:element>
  		</xsl:if>
  </xsl:template>

	<!-- topichead elements are headers -->
	<xsl:template mode="html5-blocks" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
		<xsl:param name="depth" as="xs:integer" tunnel="yes" select="1" />
		<xsl:param name="topicElement" as="xs:string" tunnel="yes" select="'p'" />
      
		<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      
		<xsl:if test="$depth le $maxTocDepthInt">
			<xsl:element name="{concat('h', $depth + 1)}">
				<xsl:apply-templates select="." mode="nav-point-title"/>
			</xsl:element>
      
      		<xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            	<xsl:variable name="items" as="node()*">

              		<xsl:apply-templates mode="#current"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">  
                	<xsl:with-param name="depth" as="xs:integer" tunnel="yes" select="$depth + 1" />
                  	<xsl:with-param name="topicElement" as="xs:string" tunnel="yes" select="$topicElement" />    
              	</xsl:apply-templates>
              
            	</xsl:variable>
            	
            	<xsl:if test="$items">
                	<xsl:sequence select="$items"/>
            	</xsl:if>
      		</xsl:if>
      	</xsl:if>
  </xsl:template>

  <xsl:template mode="html5-blocks" match="*[df:isTopicHead(.)][@toc = 'no']">   </xsl:template>

  

	<xsl:template mode="print-title-link" match="*">
	    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes" />
		<xsl:param name="topic" as="element()*"/>
		<xsl:param name="depth" as="xs:integer"  select="2" />
		
		<xsl:choose>
		<xsl:when test="@href!='' and $topic">
	 		<xsl:variable name="targetUri" 
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" 
            as="xs:string"/>
            
        	<xsl:variable name="relativeUri" 
            select="relpath:getRelativePath($outdir, $targetUri)" 
            as="xs:string"/>

        	<xsl:variable name="self" select="generate-id(.)" as="xs:string"/>
        
        	<a href="{$relativeUri}">
           <!-- target="{$contenttarget}" -->

            
            <xsl:apply-templates select="." mode="nav-point-title"/></a>
        </xsl:when>
        <xsl:when test="@href='' and $topic">
         	<xsl:apply-templates select="." mode="nav-point-title"/>
        </xsl:when>
        </xsl:choose>
	</xsl:template>

</xsl:stylesheet>
