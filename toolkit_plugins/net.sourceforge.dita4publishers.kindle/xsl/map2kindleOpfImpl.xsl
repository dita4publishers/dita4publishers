<xsl:stylesheet version="2.0"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"  
  xmlns="http://www.idpf.org/2007/opf"
  exclude-result-prefixes="df xs relpath htmlutil kindleutil gmap"
  >
  
  <!-- removing all opf prefixes from elements, as kindlegen does not like them -->

  <!-- Convert a DITA map to an EPUB content.opf file. 
    
    Notes:
    
    If map/topicmeta element has author, publisher, and copyright elements,
    they will be added to the epub file as Dublin Core metadata.
    
  -->
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  <xsl:import href="kindle-generation-utils.xsl"/>
  
  <!-- See note about my-URI-stub in build_dita2epub.xml. Hopefully a
       better URI will be passed to override this. -->
  <xsl:param name="idURIStub" select="'http://my-URI-stub/'" as="xs:string"/>

  <xsl:param name="tempFilesDir" select="'tempFilesDir value not passed'" as="xs:string"/>

<!-- XSLT document function needs full URI for parameter, so this is
     used for that. -->
  <xsl:variable name="inputURLstub" as="xs:string" 
    select="concat('file:///', translate($tempFilesDir,':\','|/'), '/')"/>

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

    <xsl:if test="$idURIStub = 'http://my-URI-stub/'">
      <xsl:message> - [WARNING] epub ID must be a URL; if you don't want it built on "http://my-URI-stub/" set the Ant property epub.pubid.uri.stub to the appropriate URL.
      </xsl:message>
    </xsl:if>
    
    <xsl:variable name="lang" select="if (@xml:lang) then string(@xml:lang) else 'en-US'" as="xs:string"/>
    
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'content.opf')" 
      as="xs:string"/>
    
    <xsl:variable name="coverImageFilename" as="xs:string"
      select="kindleutil:getKindleCoverGraphicFilename(.)">
    </xsl:variable>
    
    <xsl:variable name="uniqueTopicRefs" as="element()*" select="df:getUniqueTopicrefs(.)"/>
    
    <xsl:message> + [INFO] Generating OPF file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
    
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
          <!-- kindlegen does not like the id attribute
                also prefers string en-US to en_US as defined elsewhere
                hardcoding that for now          -->
          <xsl:variable name="langValue" as="xs:string"
            select="translate($lang, '_', '-')"
          />
          <dc:language><xsl:sequence select="$langValue"/></dc:language>
          
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
            <xsl:message> + [DEBUG] basePubId="<xsl:sequence select="$basePubId"/>"</xsl:message>
            <xsl:message> + [DEBUG] pubid="<xsl:sequence select="$pubid"/>"</xsl:message>
            <xsl:message> + [DEBUG] bookid="<xsl:sequence select="$bookid"/>"</xsl:message>
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
          <!-- Kindle requires a cover image. This is a reference to the manifest
               entry generated below.
            -->
          <meta name="cover" content="coverimage"/>
          <xsl:apply-templates mode="generate-opf"
            select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/data') and @name = 'opf-metadata']"/>
        </metadata>
        
        <manifest xmlns:opf="http://www.idpf.org/2007/opf">
          <!-- all these opf prefixes must go to please kindlegen -->
          <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>

          <item id="html-toc" media-type="application/xhtml+xml" href="toc.html"/>
          <!-- List the XHTML files -->
          <xsl:apply-templates mode="manifest" select="$uniqueTopicRefs"/>
          <xsl:apply-templates select=".//*[df:isTopicHead(.)]" mode="manifest"/>
          <!-- List the images -->
          <xsl:apply-templates mode="manifest" select="$graphicMap"/>
          <!-- FIXME: Will need to provide parameters for constructing references
               to user-specified CSS files.
            -->
          <item id="commonltr.css" href="{$cssOutputDir}/commonltr.css" media-type="text/css"/>
          <item id="commonrtl.css" href="{$cssOutputDir}/commonrtl.css" media-type="text/css"/>
          
          <xsl:if test="$CSS != ''">
            <item id="{$CSS}" href="{$cssOutputDir}/{$CSS}" media-type="text/css"/>
          </xsl:if>
          <!-- kindle requires a cover image -->
          <item id="coverimage" media-type="image/jpg" href="./images/{$coverImageFilename}"/>
        </manifest>
        
        <spine toc="ncx">
          <itemref idref="html-toc"/>
          <xsl:apply-templates mode="spine" select="($uniqueTopicRefs | .//*[df:isTopicHead(.)])"/>
        </spine>
        
        <guide>
          <reference type="toc" title="Table of Contents" href="toc.html"/>
        </guide>

        
      </package>
    </xsl:result-document>  
    <xsl:message> + [INFO] OPF file generation done.</xsl:message>
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

  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/publisher')]" 
    mode="generate-opf"> 
    <dc:publisher><xsl:apply-templates/></dc:publisher>
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
        <!-- losing the opf prefix to please kindlegen -->
        <!--<opf:item id="{generate-id()}" href="{$relativeUri}"
        media-type="application/xhtml+xml"/>-->
        <item id="{generate-id()}" href="{$relativeUri}"
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
    <item id="{generate-id()}" href="{$targetUri}"
      media-type="application/xhtml+xml"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref')]" mode="spine">
    <itemref idref="{generate-id()}"/>
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
    <item id="{@id}" href="{$imageHref}">
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
    </item>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-opf manifest"/>
</xsl:stylesheet>
