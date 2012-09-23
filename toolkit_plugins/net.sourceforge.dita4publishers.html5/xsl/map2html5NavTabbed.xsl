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
  	</xsl:template>
  	
 	
	<xsl:template match="*" mode="jquery-tab-head">
		<li><a href="#tab-{count(preceding-sibling::*) + 1}"><xsl:apply-templates select="." mode="nav-point-title"/></a></li>
  	</xsl:template>
  	
  	<xsl:template match="*" mode="html5-block">
  		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
  	 	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
		<div>
			<xsl:attribute name="class" select="@outputclass" />
			<xsl:element name="{concat('h', $tocDepth+1 )}">
				<xsl:apply-templates select="." mode="nav-point-title"/>
			</xsl:element>
			<!-- output children -->
			<xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            	<xsl:variable name="listItems" as="node()*">
              		<!-- Any subordinate topics in the currently-referenced topic are
              		 	reflected in the ToC before any subordinate topicrefs.
            		-->
              		<xsl:apply-templates mode="html5-list-items"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                  select="$tocDepth + 1"
                />
              </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$listItems">
              <ul>
                <xsl:sequence select="$listItems"/>
              </ul>
            </xsl:if>
          </xsl:if>		
			
		</div>
  	</xsl:template>
  	
  	  	<xsl:template match="*" mode="html5-list-item">
  	 		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    		<xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

   			<xsl:if test="$tocDepth le $maxTocDepthInt">
      			<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      			
      			<xsl:choose>
        			
        			<xsl:when test="not($topic)">
        			  <xsl:message> + [WARNING] html5-list-item: Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        			</xsl:when>
        		
        			<xsl:otherwise>
          				
          				<xsl:variable name="targetUri" 
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" 
            as="xs:string"/>
          				<xsl:variable name="relativeUri" 
            select="relpath:getRelativePath($outdir, $targetUri)" 
            as="xs:string"/>
          				
          				<xsl:variable name="enumeration" as="xs:string?">
            				<xsl:apply-templates select="." mode="enumeration"/>
          				</xsl:variable>
          				
          				<xsl:variable name="self" select="generate-id(.)" as="xs:string"/>

          				<!-- Use UL for navigation structure -->

          				<li><a
            href="{$relativeUri}">
           <!-- target="{$contenttarget}" -->
            <xsl:if test="$enumeration and $enumeration != ''">
              <span class="enumeration enumeration{$tocDepth}"><xsl:sequence select="$enumeration"/></span>
            </xsl:if>
            
            <xsl:apply-templates select="." mode="nav-point-title"/></a>
            
          <!--xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            <xsl:variable name="listItems" as="node()*">
              <xsl:apply-templates mode="html5-list-item"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                  select="$tocDepth + 1"
                />
              </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$listItems">
              <ul>
                <xsl:sequence select="$listItems"/>
              </ul>
            </xsl:if>
          </xsl:if-->
          </li>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  	</xsl:template>
  	
  
  	

   
   	<xsl:template match="*" mode="jquery-tab-content">
   		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
		<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
		<xsl:variable name="listItems" as="node()*">
        <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
        -->              
        	<xsl:apply-templates 
        		mode="html5-blocks"
            	select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                
            	<xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1" />
        	</xsl:apply-templates>
        </xsl:variable>
        
        
		<div id="tab-{count(preceding-sibling::*) + 1}">
			<xsl:if test="$listItems">
            	<xsl:sequence select="$listItems"/>
        	</xsl:if>
		</div>
		
  	</xsl:template>
  	
    	
  	<xsl:template name="html5-tab-content-block">
  		<xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
  		<xsl:param name="id" as="xs:string" tunnel="yes" select="''"/>
  		<xsl:param name="relativeUri" as="xs:string" tunnel="yes" select="''"/>
  			<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
  		
 		<h2><xsl:apply-templates select="." mode="nav-point-title"/></h2>
 		
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


  	 	
  	<!-- 
  		Templates for tab headers -->
    <xsl:template mode="generate-html5-tabbed-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
		<!--xsl:apply-templates select="." mode="jquery-tab-head"/-->    
    </xsl:template>
    
	<xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicRef(.)][not(@toc = 'no')]" >
		<xsl:apply-templates select="." mode="jquery-tab-head"/>
	</xsl:template>
	  	  
  	<xsl:template mode="generate-html5-tabbed-nav" match="mapdriven:collected-data">
  		
  	</xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav" match="enum:enumerables">

    </xsl:template>
  
	<xsl:template mode="generate-html5-tabbed-nav" match="glossdata:glossary-entries" >    						
		
    </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav" match="index-terms:index-terms" >    			
    	
    </xsl:template>
      
    <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicGroup(.)]" priority="20" >    			
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
  
  <xsl:template mode="generate-html5-tabbed-nav" match="*[df:isTopicHead(.)][@toc = 'no']">
  	
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

    </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav-content" match="index-terms:index-terms" >    			

    </xsl:template>

      
    <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicGroup(.)]" priority="20" >    			
    	<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:class(., 'topic/topic')]">  
  		<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    </xsl:template>
  
  <!-- topichead elements get a navPoint, but don't actually point to anything.-->
  <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicHead(.)][not(@toc = 'no')]" >
  		<xsl:apply-templates select="." mode="jquery-tab-content"/>
  </xsl:template>
  
    <xsl:template mode="generate-html5-tabbed-nav-content" match="*[df:isTopicHead(.)][@toc = 'no']" >
  		
  </xsl:template>
  
  
  <!-- templates for tab block -->
    <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
		<!--xsl:apply-templates select="." mode="html5-block"/-->    
    </xsl:template>
    
	<xsl:template mode="html5-blocks" match="*[df:isTopicRef(.)][not(@toc = 'no')]" >
		<xsl:apply-templates select="." mode="html5-block"/>
	</xsl:template>
	  	  
  	<xsl:template mode="html5-blocks" match="mapdriven:collected-data">
  		<xsl:apply-templates select="." mode="html5-block"/>
  	</xsl:template>
  
    <xsl:template mode="html5-blocks" match="enum:enumerables">
  		<xsl:apply-templates select="." mode="html5-block"/>
    </xsl:template>
  
	<xsl:template mode="html5-blocks" match="glossdata:glossary-entries" >    						

    </xsl:template>
  
    <xsl:template mode="html5-blocks" match="index-terms:index-terms" >    			
   
    </xsl:template>
      
    <xsl:template mode="html5-blocks" match="*[df:isTopicGroup(.)]" priority="20" >    			
    	<xsl:apply-templates select="." mode="html5-block"/>
    </xsl:template>
  
  <xsl:template mode="html5-blocks" match="*[df:class(., 'topic/topic')]">  
  		<xsl:apply-templates select="." mode="html5-block"/>
    </xsl:template>
   
  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template mode="html5-blocks" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
  		<xsl:apply-templates select="." mode="html5-block"/>
  </xsl:template>
  
    <xsl:template mode="html5-blocks" match="*[df:isTopicHead(.)][@toc = 'no']">

  </xsl:template>

    <xsl:template mode="html5-blocks" match="*[df:class(., 'map/topicref')][contains(@chunk, 'to-toc')]" priority="20" >    			
    	<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    	<xsl:message> + [INFO] MERGING TOPIC INTO CONTENT</xsl:message>
    	
    	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    	
    	<xsl:apply-templates mode="#default" select="$topic"/>
    	
    	
  </xsl:template>
  
  <xsl:template match="
    *[df:class(., 'topic/body')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/shortdesc')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/abstract')]//*[df:class(., 'topic/indexterm')]
     "
     priority="10"
    >
      
   		<!--xsl:sequence select="$content" /-->
    	 
    </xsl:template>


  <!-- templates for html5 list item -->
    <xsl:template mode="html5-list-items" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
		<!--xsl:apply-templates select="." mode="html5-block"/-->    
    </xsl:template>
    
	<xsl:template mode="html5-list-items" match="*[df:isTopicRef(.)][not(@toc = 'no')]" >
		<xsl:apply-templates select="." mode="html5-list-item"/>
	</xsl:template>
	  	  
  	<xsl:template mode="html5-list-items" match="mapdriven:collected-data">
  		<xsl:apply-templates select="." mode="html5-list-item"/>
  	</xsl:template>
  
    <xsl:template mode="html5-list-items" match="enum:enumerables">
  		<xsl:apply-templates select="." mode="html5-list-item"/>
    </xsl:template>
  
	<xsl:template mode="html5-list-items" match="glossdata:glossary-entries" >    						
		
    </xsl:template>
  
    <xsl:template mode="html5-list-items" match="index-terms:index-terms" >    			
    	
    </xsl:template>
      
    <xsl:template mode="html5-list-items" match="*[df:isTopicGroup(.)]" priority="20" >    			
    	<xsl:apply-templates select="." mode="html5-list-item"/>
    </xsl:template>
  
  <xsl:template mode="html5-list-items" match="*[df:class(., 'topic/topic')]">  
  		<xsl:apply-templates select="." mode="html5-list-item"/>
    </xsl:template>
   
  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template mode="html5-list-items" match="*[df:isTopicHead(.)][not(@toc = 'no')]">
  		<xsl:apply-templates select="." mode="html5-block"/>
  </xsl:template>
  
    <xsl:template mode="html5-list-items" match="*[df:isTopicHead(.)][@toc = 'no']">
  </xsl:template>
  
      <xsl:template mode="html5-list-items" match="*[df:class(., 'map/topicref')][contains(@chunk, 'to-toc')]" priority="20" >    			
    	<!--xsl:apply-templates select="." mode="jquery-tab-content"/-->
    	<xsl:message> + [INFO] MERGING TOPIC INTO CONTENT</xsl:message>
   	
    	<xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    	
    	<xsl:apply-templates mode="#default" select="$topic"/>

    	
    	
  </xsl:template>
  
  
</xsl:stylesheet>