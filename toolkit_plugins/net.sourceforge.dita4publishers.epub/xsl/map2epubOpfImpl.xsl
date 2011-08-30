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
  exclude-result-prefixes="df xs relpath htmlutil gmap"
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
          
          <dc:identifier id="bookid">
            <xsl:variable name="basePubId" as="xs:string*">
              <xsl:choose>
                <xsl:when test="*[df:class(., 'pubmeta-d/pubmeta')]/*[df:class(., 'pubmeta-d/pubid')]">
                  <xsl:apply-templates select="*[df:class(., 'pubmeta-d/pubmeta')]/*[df:class(., 'pubmeta-d/pubid')]"
                    mode="bookid"
                  />
                </xsl:when>
                <xsl:when test="@id">
                  <xsl:sequence select="string(@id)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="'no-pubid-value'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="pubid" as="xs:string" select="normalize-space(string-join($basePubId,''))"/>
            <xsl:variable name="bookid" select="string(resolve-uri($idURIStub, $pubid))" as="xs:string"/>
            <!-- FIXME: Need to refine how EPUB ID is constructed. Not sure what shape this should take
                        given that you can have any number of pubid elements.
            -->
            
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] basePubId="<xsl:sequence select="$basePubId"/>"</xsl:message>
              <xsl:message> + [DEBUG] pubid="<xsl:sequence select="$pubid"/>"</xsl:message>
              <xsl:message> + [DEBUG] bookid="<xsl:sequence select="$bookid"/>"</xsl:message>
            </xsl:if>            
            <xsl:sequence select="$bookid"/>
          </dc:identifier>
          
          <!-- Remaining metadata fields optional, so 
            their tags only get output if values exist. -->
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
              mode="generate-opf"/>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/publisher')]" 
            mode="generate-opf"/>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/copyright')]" 
            mode="generate-opf"/>
          
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
          <!-- Hook for extension points: -->
          <xsl:apply-templates select="." mode="generate-opf-manifest-extensions"/>
          <!-- List the images -->
          <xsl:apply-templates mode="manifest" select="$graphicMap"/>
          <opf:item id="commonltr.css" href="{$cssOutputDir}/commonltr.css" media-type="text/css"/>
          <opf:item id="commonrtl.css" href="{$cssOutputDir}/commonrtl.css" media-type="text/css"/>
          <xsl:if test="$CSS != ''">
            <opf:item id="{$CSS}" href="{$cssOutputDir}/{$CSS}" media-type="text/css"/>
          </xsl:if>
          <xsl:if test="$generateHtmlTocBoolean">
            <xsl:variable name="tocId" select="concat('html-toc_', generate-id(.))" as="xs:string"/>
            <xsl:variable name="htmlTocUrl" as="xs:string" 
        select="relpath:newFile($topicsOutputPath, concat($tocId, $OUTEXT))"/>
            <opf:item id="{$tocId}" href="{$htmlTocUrl}" media-type="text/html"/>
          </xsl:if>
        </manifest>
        
        <spine toc="ncx">
          <xsl:if test="$generateHtmlTocBoolean">
            <xsl:variable name="tocId" select="concat('html-toc_', generate-id(.))" as="xs:string"/>
            <xsl:variable name="htmlTocUrl" as="xs:string" 
        select="relpath:newFile($topicsOutputPath, concat($tocId, $OUTEXT))"/>
            <opf:itemref idref="{$tocId}"/>
          </xsl:if>
          
          <xsl:apply-templates mode="spine" select="($uniqueTopicRefs | .//*[df:isTopicHead(.)])"/>
          
          <!-- Hook for extension points: -->
          <xsl:apply-templates select="." mode="spine-extensions"/>
        </spine>
        
      </package>
    </xsl:result-document>  
    <xsl:message> + [INFO] OPF file generation done.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="generate-opf-manifest-extensions" match="*[df:class(., 'map/map')]">
    <!-- Default implementation. Override to add files to the OPF manifest. -->
  </xsl:template>

  <xsl:template mode="spine-extensions" match="*[df:class(., 'map/map')]">
    <!-- Default implementation. Override to add files to the OPF spine. -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
    mode="generate-opf">  
    <dc:creator opf:role="aut"
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

  <xsl:template match="*[df:isTopicRef(.)]" mode="manifest">
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, root($topic))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
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
  
  <xsl:template match="text()" mode="generate-opf manifest"/>
</xsl:stylesheet>
