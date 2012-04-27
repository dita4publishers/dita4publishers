<xsl:stylesheet version="2.0"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"  
  xmlns="http://www.idpf.org/2007/opf"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="df xs relpath htmlutil gmap local"
  >

  <!-- Convert a DITA map to an EPUB content.opf file. 
    
    Notes:
    
    If map/topicmeta element has author, publisher, and copyright elements,
    they will be added to the epub file as Dublin Core metadata.
    
  -->
  
  <!-- Output format for the content.opf file -->
  <xsl:output name="opf"
    indent="yes"
    method="xml"
  />

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-opf">
    <xsl:param name="graphicMap" as="element()" tunnel="yes"/>
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating OPF manifest file...</xsl:message>
    
    <xsl:if test="not(@xml:lang)">
      <xsl:message> - [WARNING] dc:language required in epub file; please add xml:lang attribute to map element. Using en-US.
      </xsl:message>
    </xsl:if>

    <xsl:variable name="lang" select="if (@xml:lang) then string(@xml:lang) else 'en-US'" as="xs:string"/>
    
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'content.opf')" 
      as="xs:string"/>
    
    <xsl:message> + [INFO] Generating OPF file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
    
    <xsl:variable name="uniqueTopicRefs" as="element()*" select="df:getUniqueTopicrefs(.)"/>
        
    <xsl:result-document format="opf" href="{$resultUri}">
      <package xmlns="http://www.idpf.org/2007/opf"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        version="2.0"
        unique-identifier="bookid">
        <metadata xmlns:opf="http://www.idpf.org/2007/opf">
          
          <!-- dc:title, dc:language, and dc:identifier are required, so
            if the ditamap doesn't have values, they go in as empty
            elements. -->
          
          <dc:title>
            <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
          </dc:title>
          
          <dc:language id="language"><xsl:sequence select="$lang"/></dc:language>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]" mode="bookid"/>
          
          <!-- Remaining metadata fields optional, so 
            their tags only get output if values exist. -->
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
              mode="generate-opf"/>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/publisher')]" 
            mode="generate-opf"/>
          
          <xsl:apply-templates 
            select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/copyright')] |
            *[df:class(., 'map/topicmeta')]/*[df:class(., 'pubmeta-d/pubrights')]
            " 
            mode="generate-opf"/>
          
          <!-- NOTE: keywords can be directly in topicmeta or in metadata under topicmeta -->
          <xsl:apply-templates mode="generate-opf"
            select="*[df:class(., 'map/topicmeta')]//*[df:class(., 'topic/keywords')]"
          />
          
          <xsl:if test="$effectiveCoverGraphicUri != ''">
            <meta name="cover" content="{$coverImageId}"/>
          </xsl:if>
          <xsl:apply-templates mode="generate-opf"
            select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/data') and @name = 'opf-metadata']"/>
          
        </metadata>
        
        <manifest xmlns:opf="http://www.idpf.org/2007/opf">
          <opf:item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
          <!-- List the XHTML files -->
          <xsl:apply-templates mode="manifest" select="$uniqueTopicRefs"/>
          <xsl:apply-templates select=".//*[df:isTopicHead(.)]" mode="manifest"/>
          <xsl:apply-templates select=".//*[local:includeTopicrefInManifest(.)]" mode="manifest"/>
          <!-- Hook for extension points: -->
          <xsl:apply-templates select="." mode="generate-opf-manifest-extensions"/>
          <!-- List the images -->
          <xsl:apply-templates mode="manifest" select="$graphicMap"/>
          <opf:item id="commonltr.css" href="{$cssOutputDir}/commonltr.css" media-type="text/css"/>
          <opf:item id="commonrtl.css" href="{$cssOutputDir}/commonrtl.css" media-type="text/css"/>
          <xsl:if test="$CSS != ''">
            <opf:item id="{$CSS}" href="{$cssOutputDir}/{$CSS}" media-type="text/css"/>
          </xsl:if>
          <xsl:if test="$generateIndexBoolean">
            <opf:item id="generated-index" href="generated-index.html" media-type="application/xhtml+xml"/>
          </xsl:if>
        </manifest>
        
        <spine toc="ncx">
          
          <xsl:apply-templates mode="spine" 
            select="($uniqueTopicRefs | 
            .//*[df:isTopicHead(.)]) | 
            .//*[local:includeTopicrefInSpine(.)]"
          />
          <xsl:if test="$generateIndexBoolean">
            <opf:itemref idref="generated-index"/>
          </xsl:if>
          
        </spine>
        
          <guide>
            <xsl:apply-templates mode="guide"  select=".">
              <xsl:with-param name="uniqueTopicRefs" as="element()*" 
                select="$uniqueTopicRefs" tunnel="yes"/>
            </xsl:apply-templates>            
          </guide>
        
      </package>
    </xsl:result-document>  
    <xsl:message> + [INFO] OPF file generation done.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="guide" match="*[df:class(., 'map/map')]">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <!-- FIXME: Generate a guide entry for the cover page -->            
    <!--<reference type="cover" title="Cover Page" href="${frontCoverUri}"/>-->
    <xsl:apply-templates mode="#current" 
      select="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]"
    />
    
  </xsl:template>
  
  <xsl:template mode="guide" match="text()"/>
  
  <xsl:template mode="guide" match="*[df:class(., 'map/topicref')]">
    <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicref')][not(@processing-role = 'resource-only')]"/>
  </xsl:template>
  
  <xsl:template mode="generate-opf-manifest-extensions" match="*[df:class(., 'map/map')]">
    <!-- Default implementation. Override to add files to the OPF manifest. -->
  </xsl:template>

  <xsl:template mode="spine-extensions" match="*[df:class(., 'map/map')]">
    <!-- Default implementation. Override to add files to the OPF spine. -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
    mode="generate-opf">  
    <xsl:variable name="role" as="xs:string"
      select="if (@type) then string(@type) else 'aut'"
    />
    <dc:creator opf:role="{$role}"
      ><xsl:apply-templates select=".//*[df:class(., 'topic/data')]" mode="data-to-atts"
      /><xsl:apply-templates
    /></dc:creator>
  </xsl:template>
  
  <xsl:template mode="data-to-atts" match="text()"/><!-- Suppress all text by default -->
  
  <xsl:template match="*[df:class(., 'topic/data')]" mode="data-to-atts" priority="-1">
    <xsl:message> + [INFO] mode data-to-atss: Unhandled data element <xsl:sequence select="name(.)"/>, @name="<xsl:sequence select="string(@name)"/>"</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/author')]//*[df:class(., 'topic/data') and @name = 'file-as']" mode="data-to-atts">
    <xsl:attribute name="opf:file-as" select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template 
    match="
    *[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/publisher')]
    " 
    mode="generate-opf"> 
    <dc:publisher><xsl:apply-templates/></dc:publisher>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/publisher')]/*">
    <!-- Make sure that markup within publisher is handled (e.g., for bookmap). -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/copyright')]" 
    mode="generate-opf"> 
    <!-- copyryear and copyrholder are required children of copyright element -->
    <dc:rights>Copyright <xsl:value-of select="*[df:class(., 'topic/copyryear')]/@year"/><xsl:text> </xsl:text><xsl:value-of select="*[df:class(., 'topic/copyrholder')]"/></dc:rights>
  </xsl:template>

  <xsl:template match="*[df:class(., 'pubmeta-d/pubrights')]" 
    mode="generate-opf"> 
    <dc:rights>
      <xsl:apply-templates mode="#current" select="*[df:class(., 'pubmeta-d/copyrfirst')]"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates mode="generate-opf" select="* except *[df:class(., 'pubmeta-d/copyrfirst')]"/>
    </dc:rights>
  </xsl:template>
  
  <xsl:template mode="generate-opf" match="*[df:class(., 'pubmeta-d/copyrfirst')]">
    Copyright <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="../*[df:class(., 'pubmeta-d/copyrlast')]">
      <xsl:text>, </xsl:text>
      <xsl:sequence select="normalize-space(../*[df:class(., 'pubmeta-d/copyrlast')])"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="generate-opf" match="*[df:class(., 'pubmeta-d/copyrlast')]">
    <!-- Handled in processing of copyrfirst -->
  </xsl:template>
  
  <xsl:template mode="generate-opf" match="*[df:class(., 'pubmeta-d/pubowner')]">
    <xsl:variable name="pubOwners" as="element()*">
      <xsl:sequence select="*"/>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="count($pubOwners) le 1">
        <xsl:apply-templates select="$pubOwners" mode="pubOwner"/>
      </xsl:when>
      <xsl:when test="count($pubOwners) = 2">
        <xsl:apply-templates select="$pubOwners[1]" mode="pubOwner"/>
        <xsl:text> and </xsl:text>
        <xsl:apply-templates select="$pubOwners[2]" mode="pubOwner"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$pubOwners[1]" mode="pubOwner"/>
        <xsl:for-each select="$pubOwners[2, last() - 1]">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="." mode="pubOwner"/>
        </xsl:for-each>
        <xsl:text> and </xsl:text>
        <xsl:apply-templates select="$pubOwners[last()]" mode="pubOwner"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="pubOwner" match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[df:isTopicRef(.)]" mode="manifest">
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, root($topic))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
        <xsl:if test="false()">          
          <xsl:message> + [DEBUG] map2epubOpfImpl: outdir="<xsl:sequence select="$outdir"/>"</xsl:message>
          <xsl:message> + [DEBUG] map2epubOpfImpl: targetUri="<xsl:sequence select="$targetUri"/>"</xsl:message>
          <xsl:message> + [DEBUG] map2epubOpfImpl: relativeUri="<xsl:sequence select="$relativeUri"/>"</xsl:message>
        </xsl:if>        
        <opf:item id="{generate-id()}" href="{$relativeUri}"
              media-type="application/xhtml+xml"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="*[df:isTopicHead(.)]" mode="manifest">
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] in mode manifest, handling topichead <xsl:sequence select="df:getNavtitleForTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="titleOnlyTopicFilename" as="xs:string"
      select="htmlutil:getTopicheadHtmlResultTopicFilename(.)" />
    <xsl:variable name="targetUri" as="xs:string"
          select="        
       if ($topicsOutputDir != '') 
          then concat($topicsOutputDir, '/', $titleOnlyTopicFilename) 
          else $titleOnlyTopicFilename
          " />
    <opf:item id="{generate-id()}" href="{$targetUri}"
      media-type="application/xhtml+xml"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref')]" mode="spine">
    <opf:itemref idref="{generate-id()}"/>
  </xsl:template>
  
  <xsl:template mode="bookid" match="*[df:class(., 'map/topicmeta')]">
    <!-- OPF requires one dc:identifier, which must have an ID. There may
         be other book identifiers.
         
         DITA provides a number of ways, none mandatory, to specify book
         identifiers. So there's a bit of a challenge here.
         
         Bookmap and pubmap-d both provide elements for ISBNs, book numbers,
         etc.
         
         The approach here is to get a sequence of book-identifying elements
         and then process them, using the first one in the sequence as
         the "bookid" as referenced from the OPF manifest.
         
    -->
    
    <xsl:variable name="bookids" as="element()*">
      <xsl:apply-templates mode="list-bookids"/>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="count($bookids) = 0">
        <dc:identifier id="bookid">no-bookid-value</dc:identifier>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="constructDcIdentifiers">
          <xsl:with-param name="bookids" select="$bookids" as="element()+"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    
    </xsl:template>
    <xsl:template name="constructDcIdentifiers">
      <xsl:param name="bookids" as="element()+"/>
      
      <!-- $bookids is a list of elements that are specializations of 
           <data> and that represent some form of book ID.
      -->
      
      <xsl:apply-templates select="$bookids[1]" mode="bookid">
        <xsl:with-param name="id" select="'bookid'"/>
      </xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'bookmap/bookid')] | *[df:class(., 'pubmeta-d/pubid ')]" 
    mode="list-bookids">
    <!-- Assume that all topic/data children of bookid or pubid are identifiers. -->
    <xsl:sequence select="*[df:class(., 'topic/data')]"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="list-bookids"/> 
  
  <xsl:template match="*[df:class(., 'bookmap/bookid')] | *[df:class(., 'pubmeta-d/pubid ')]" 
    mode="bookid">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/data')]" 
    mode="bookid">
    <xsl:param name="id" as="xs:string?" required="no"/>
    
    <xsl:variable name="schemeBase" as="xs:string"
      select="if (@name) then string(@name) else name(.)"
    />
    
    <xsl:variable name="scheme" as="xs:string"
      select="if (starts-with(lower-case($schemeBase), 'isbn')) then 'isbn' else $schemeBase"
    />
    <dc:identifier opf:scheme="{$scheme}">
      <xsl:if test="$id">
        <xsl:attribute name="id" select="$id"/>
      </xsl:if>
      <xsl:sequence select="string(@value)"/>
      <xsl:apply-templates/>
    </dc:identifier>
  </xsl:template>
  
  <xsl:template match="*" mode="bookid" priority="-1">
    <!-- Do nothing by default -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmap/pubid')]" mode="bookid">
    <xsl:choose>
      <xsl:when test=".//*[df:class(., 'topic/data') and @name = 'epub-bookid']">
        <xsl:sequence select="normalize-space(.//*[df:class(., 'topic/data') and @name = 'epub-bookid'][1])"></xsl:sequence>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/isbn-13')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/isbn-13')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/isbn-10')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/isbn-10')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/isbn')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/isbn')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/issn-13')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/issn-13')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/issn-10')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/issn-10')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/issn')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/issn')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/pubpartno')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/pubpartno')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[df:class(., 'pubmap/pubnumber')]) = '')">
        <xsl:sequence select="normalize-space(*[df:class(., 'pubmap/pubnumber')])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>{No publication ID}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/keywords')]" mode="generate-opf">
    <xsl:message> + [DEBUG] generate-opf: handling topic/keywords</xsl:message>
    <xsl:apply-templates select="*[df:class(., 'topic/keyword')]" mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/keyword')]" mode="generate-opf">
    <xsl:message> + [DEBUG] generate-opf: handling topic/keyword</xsl:message>
    <dc:subject><xsl:apply-templates/></dc:subject>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/data') and @name = 'opf-metadata']" mode="generate-opf">
    <xsl:apply-templates select="*[df:class(., 'topic/data')]" mode="generate-opf-metadata"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/data')]" mode="generate-opf-metadata">
    <xsl:variable name="value" as="xs:string"
      select="if (@value)
        then string(@value)
        else string(.)"
    />
    <meta name="{@name}" content="{$value}"/>
  </xsl:template>

  <xsl:template match="gmap:graphic-map" mode="manifest">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="gmap:graphic-map-item" mode="manifest">
    <xsl:variable name="imageFilename" select="relpath:getName(@output-url)" as="xs:string"/>
    <xsl:variable name="imageExtension" select="lower-case(relpath:getExtension($imageFilename))" as="xs:string"/>
    <xsl:variable name="hrefPath" as="xs:string" 
      select="relpath:getParent(@output-url)"/>
    <xsl:variable name="imageHref" 
      select="relpath:newFile(relpath:getRelativePath($outdir, $hrefPath), $imageFilename)" as="xs:string"/>
    <xsl:if test="false()">
      <xsl:message> + [DEBUG]
        outdir      =<xsl:sequence select="$outdir"/>
        output-url  =<xsl:sequence select="string(@output-url)"/>
        hrefPath    =<xsl:sequence select="$hrefPath"/>
        imageHref   =<xsl:sequence select="$imageHref"/>
      </xsl:message>
    </xsl:if>
    <opf:item id="{@id}" href="{$imageHref}">
      <xsl:attribute name="media-type">
        <xsl:choose>
          <xsl:when test="$imageExtension = 'jpg'"><xsl:sequence select="'image/jpeg'"/></xsl:when>
          <xsl:when test="$imageExtension = 'jpeg'"><xsl:sequence select="'image/jpeg'"/></xsl:when>
          <xsl:when test="$imageExtension = 'gif'"><xsl:sequence select="'image/gif'"/></xsl:when>
          <xsl:when test="$imageExtension = 'png'"><xsl:sequence select="'image/png'"/></xsl:when>
          <xsl:otherwise>
            <xsl:message> - [WARN] Image extension "<xsl:sequence select="$imageExtension"/>" not recognized, may not work with ePub viewers.</xsl:message>
            <xsl:sequence select="concat('application/', lower-case($imageExtension))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </opf:item>
  </xsl:template>
  
  <xsl:function name="local:includeTopicrefInSpine" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="test">
      <xsl:apply-templates select="$context" mode="include-topicref-in-spine"/>
    </xsl:variable>
    <xsl:variable name="result" as="xs:boolean" select="$test = 'true'"/>
    <xsl:if test="$result">
      <xsl:message> + [DEBUG] local:includeTopicrefInSpine: Including element "<xsl:sequence select="name($context)"/>" in spine.</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function>  
  
  <xsl:function name="local:includeTopicrefInManifest" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="test">
      <xsl:apply-templates select="$context" mode="include-topicref-in-manifest"/>
    </xsl:variable>
    <xsl:variable name="result" as="xs:boolean" select="$test = 'true'"/>
    <xsl:if test="$result">
      <xsl:message> + [DEBUG] local:includeTopicrefInSpine: Including element "<xsl:sequence select="name($context)"/>" in manifest.</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function>  
  
  <xsl:template mode="include-topicref-in-spine" match="*">
    <!-- Do nothing, don't explicitly include by default. -->
  </xsl:template>
  
  <xsl:template mode="include-topicref-in-manifest" match="*">
    <!-- Do nothing, don't explicitly include by default. -->
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-opf manifest guide include-topicref-in-manifest include-topicref-in-spine"/>
</xsl:stylesheet>
