<xsl:stylesheet version="2.0"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
  xmlns="http://www.idpf.org/2007/opf"
  exclude-result-prefixes="df xs relpath epubutil"
  >

  <!-- Convert a DITA map to an EPUB content.opf file. 
    
    Notes:
    
    If map/topicmeta element has author, publisher, and copyright elements,
    they will be added to the epub file as Dublin Core metadata.
    
  -->
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  
  <!-- See note about my-URI-stub in build_dita2epub.xml. Hopefully a
       better URI will be passed to override this. -->
  <xsl:param name="idURIStub" select="'http://my-URI-stub/'" as="xs:string"/>

  <xsl:param name="tempFilesDir" select="'tempFilesDir value not passed'" as="xs:string"/>

<!-- XSLT document function needs full URI for parameter, so this is
     used for that. -->
  <xsl:variable name="inputURLstub" as="xs:string" 
    select="concat('file:///', translate($tempFilesDir,':\','|/'), '/')"/>

  <xsl:strip-space elements="*"/>
  <!-- Output format for the content.opf file -->
  <xsl:output name="opf"
    indent="yes"
    method="xml"
  />

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-opf">

    <xsl:if test="not(@xml:lang)">
      <xsl:message> - [WARNING] dc:language required in epub file; please add xml:lang attribute to map element. Using en-US.
      </xsl:message>
    </xsl:if>

    <xsl:if test="$idURIStub = 'http://my-URI-stub/'">
      <xsl:message> - [WARNING] epub ID must be a URL; if you don't want it built on "http://my-URI-stub/" set the Ant property idURIStub to the appropriate URL.
      </xsl:message>
    </xsl:if>
    
    <xsl:variable name="lang" select="if (@xml:lang) then string(@xml:lang) else 'en-US'" as="xs:string"/>
    
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'content.opf')" 
      as="xs:string"/>
    
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
          
          <dc:language xsi:type="dcterms:RFC3066"><xsl:sequence select="$lang"/></dc:language>
          
          <dc:identifier id="bookid">
            <xsl:sequence select="$idURIStub"/>
            <xsl:choose>
              <xsl:when test="*[df:class(., 'pubmap/pubmeta')]/*[df:class(., 'pubmap/pubid')]">
                <xsl:apply-templates select="*[df:class(., 'pubmap/pubmeta')]/*[df:class(., 'pubmap/pubid')]"
                  mode="bookid"
                />
              </xsl:when>
              <xsl:when test="@id">
                <xsl:sequence select="string(@id)"/>
              </xsl:when>
            </xsl:choose>
            
          </dc:identifier>
          
          <!-- Remaining metadata fields optional, so 
            their tags only get output if values exist. -->
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
              mode="generate-opf"/>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/publisher')]" 
            mode="generate-opf"/>
          
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/copyright')]" 
            mode="generate-opf"/>
          
        </metadata>
        
        <manifest xmlns:opf="http://www.idpf.org/2007/opf">
          <opf:item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
          <!-- List the XHTML files -->
          <xsl:apply-templates mode="manifest" select=".//*[df:class(., 'map/topicref') and @href]"/>
          <!-- List the images -->
          <xsl:apply-templates mode="getpics" select=".//*[df:class(., 'map/topicref') and @href]"/>
          <opf:item id="commonltr.css" href="topics/commonltr.css" media-type="text/css"/>
          <opf:item id="commonrtl.css" href="topics/commonrtl.css" media-type="text/css"/>
          <!-- FIXME: Need ability to add references to user-supplied CSS files as defined using
               normal Toolkit methods -->
        </manifest>
        
        <spine toc="ncx">
          <xsl:apply-templates mode="spine" select=".//*[df:class(., 'map/topicref') and @href]"/>
        </spine>
        
      </package>
    </xsl:result-document>  
    <xsl:message> + [INFO] OPF file generation done.</xsl:message>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/topicref') and @href and @scope != 'external']" mode="getpics">
    <!-- This assumes that the @href value is not already a URL, and
         that it points to a locally stored file. To do: don't assume
         this. -->
    <!-- FIXME: Need to construct the output URI for the graphic using a common function -->
    
    <xsl:variable name="topicrefURL" as="xs:string">
      <xsl:sequence select="$inputURLstub"/>
      <xsl:sequence select="if (contains(@href,'#')) then substring-before(@href,'#') else string(@href)"/>
    </xsl:variable>

    <xsl:variable name="hrefDir" select="relpath:getParent(string(@href))" as="xs:string"/>
    
    <xsl:message> + [DEBUG] hrefDir="<xsl:sequence select="$hrefDir"/>"</xsl:message>

  </xsl:template>


  <xsl:template match="text()" mode="getpics"/>


  <xsl:template match="*[df:class(., 'topic/image')]" mode="getpics">

    <xsl:param name="dir"/>

    <opf:item id="{generate-id()}" href="{concat($dir, @href)}">
      <xsl:attribute name="media-type">
        <xsl:choose>
          <xsl:when test="contains(@href,'.jpg')">image/jpeg</xsl:when>
          <xsl:when test="contains(@href,'.JPG')">image/jpeg</xsl:when>
          <xsl:when test="contains(@href,'.gif')">image/gif</xsl:when>
          <xsl:when test="contains(@href,'.GIF')">image/gif</xsl:when>
          <xsl:when test="contains(@href,'.png')">image/png</xsl:when>
          <xsl:when test="contains(@href,'.PNG')">image/png</xsl:when>
          <xsl:otherwise>
            <xsl:message>Warning: <xsl:sequence select="@href"/> image format not supported by DITA Open Toolkit.
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </opf:item>
  </xsl:template>


  <!-- When searching for image elements, if we find anything besides a
       topicref or an image, just keep looking. -->
  <xsl:template match="*" mode="getpics">
    <xsl:param name="dir"/>
    <xsl:apply-templates mode="getpics">
      <xsl:with-param name="dir" select="$dir"/>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/author')]" 
    mode="generate-opf">  
    <dc:creator opf:role="aut" opf:file-as="Feedbooks"><xsl:apply-templates/></dc:creator>
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
        <xsl:variable name="targetUri" select="epubutil:getTopicResultUrl($topicsOutputPath, $topic)" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
        <opf:item id="{generate-id()}" href="{$relativeUri}"
              media-type="application/xhtml+xml"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/topicref')]" mode="spine">
    <opf:itemref idref="{generate-id()}"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmap/pubid')]" mode="bookid">
    <xsl:choose>
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

  <xsl:template match="text()" mode="generate-opf"/>
</xsl:stylesheet>
