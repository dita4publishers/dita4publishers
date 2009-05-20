<!-- Convert a DITA map to an EPUB content.opf file. 

Notes:

If map/topicmeta element has author, publisher, and copyright elements,
they will be added to the epub file as Dublin Core metadata.

-->
<xsl:stylesheet version="1.0"
                xmlns:opf="http://www.idpf.org/2007/opf"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- See note about my-URI-stub in build_dita2epub.xml. Hopefully a
       better URI will be passed to override this. -->
  <xsl:param name="IdURIStub">http://my-URI-stub/</xsl:param>

  <xsl:param name="tempFilesDir">tempFilesDir value not passed</xsl:param>

<!-- XSLT document function needs full URI for parameter, so this is
     used for that. -->
  <xsl:variable name="inputURLstub">
    <xsl:text>file:///</xsl:text>
    <xsl:value-of select="translate($tempFilesDir,':\','|/')">
    </xsl:value-of>
    <xsl:text>/</xsl:text>
  </xsl:variable>

  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes"/>


  <xsl:template name="pathname">
    <!-- output text up to last slash -->
    <xsl:param name="string">dummy string</xsl:param>
    <xsl:param name="nextCharToCheck" select="string-length($string)"/>

    <xsl:choose>
      <xsl:when test="not(contains($string,'/'))"/>
      <xsl:when test="substring($string,$nextCharToCheck,1) = '/'">
        <xsl:value-of select="substring($string,1,$nextCharToCheck)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="pathname">
          <xsl:with-param name="string" select="$string"/>
          <xsl:with-param name="nextCharToCheck" select="$nextCharToCheck - 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="*[contains(@class,' map/map ')]">

        <xsl:if test="not(@xml:lang)">
          <xsl:message> ===== Warning: dc:language required in epub file; please add xml:lang attribute to map element.
          </xsl:message>
        </xsl:if>

        <xsl:if test="$IdURIStub = 'http://my-URI-stub/'">
          <xsl:message> ===== Warning: epub ID must be URL; if you don't want it built on "http://my-URI-stub/" reset IdURIStub param in build_dita2epub.xml.
          </xsl:message>
        </xsl:if>

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
          <!-- title is an attribute of map, but bookmap puts title in
               bookmap/booktitle/mainbooktitle -->
          <xsl:choose>
            <xsl:when test="*[contains(@class,' bookmap/booktitle ')]/
                            *[contains(@class,' bookmap/mainbooktitle ')]">
              <xsl:value-of select="*[contains(@class,' bookmap/booktitle ')]/
                                    *[contains(@class,' bookmap/mainbooktitle ')]"/>
            </xsl:when>
            <xsl:when test="*[contains(@class,' pubmap/pubtitle ')]/
              *[contains(@class,' pubmap/mainpubtitle ')]">
              <xsl:value-of select="*[contains(@class,' pubmap/pubtitle ')]/
                *[contains(@class,' pubmap/mainpubtitle ')]"/>
            </xsl:when>
            <xsl:when test="*[contains(@class,' topic/title ')]">
              <xsl:value-of select="*[contains(@class,' topic/title ')]"/>
            </xsl:when>
            <xsl:when test="@title">
              <xsl:value-of select="@title"/>              
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>{No map title}</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </dc:title>

        <dc:language xsi:type="dcterms:RFC3066">
          <xsl:value-of select="@xml:lang"/>
        </dc:language>

        <dc:identifier id="bookid">
          <xsl:value-of select="$IdURIStub"/>
          <xsl:choose>
            <xsl:when test="*[contains(@class,' pubmap/pubmeta ')]/*[contains(@class,' pubmap/pubid ')]">
              <xsl:apply-templates select="*[contains(@class,' pubmap/pubmeta ')]/*[contains(@class,' pubmap/pubid ')]"
                mode="bookid"
              />
            </xsl:when>
            <xsl:when test="@id">
              <xsl:value-of select="@id"/>
            </xsl:when>
          </xsl:choose>
          
        </dc:identifier>

        <!-- Remaining metadata fields optional, so 
             their tags only get output if values exist. -->

        <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/author ')]"/>

        <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/publisher ')]"/>

        <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/copyright ')]"/>

      </metadata>

      <manifest xmlns:opf="http://www.idpf.org/2007/opf">
        <opf:item id="ncx" href="toc.ncx" media-type="text/xml"/>
        <!-- List the XHTML files -->
        <xsl:apply-templates mode="manifest" select=".//*[contains(@class,' map/topicref ') and @href]"/>
        <!-- List the images -->
        <xsl:apply-templates mode="getpics" select=".//*[contains(@class,' map/topicref ') and @href]"/>
      </manifest>

      <spine toc="ncx">
        <xsl:apply-templates mode="spine" select=".//*[contains(@class,' map/topicref ') and @href]"/>
      </spine>

    </package>
  </xsl:template>

  <xsl:template match="*[contains(@class,' map/topicref ') and @href and @scope != 'external']" mode="getpics">
    <!-- This assumes that the @href value is not already a URL, and
         that it points to a locally stored file. To do: don't assume
         this. -->
    <xsl:variable name="topicrefURL">
      <xsl:value-of select="$inputURLstub"/>
      <xsl:choose>
        <xsl:when test="contains(@href,'#')">
          <xsl:value-of select="substring-before(@href,'#')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hrefDir">
      <xsl:call-template name="pathname">
        <xsl:with-param name="string" select="@href"/>
      </xsl:call-template>
    </xsl:variable>

<!--    <xsl:apply-templates select="document($topicrefURL)" mode="getpics">
      <xsl:with-param name="dir" select="$hrefDir"/>
    </xsl:apply-templates> -->

  </xsl:template>


  <xsl:template match="text()" mode="getpics"/>


  <xsl:template match="*[contains(@class,' topic/image ')]" mode="getpics">

    <xsl:param name="dir"/>

    <opf:item id="{generate-id()}" href="{$dir}{@href}">
      <xsl:attribute name="media-type">
        <xsl:choose>
          <xsl:when test="contains(@href,'.jpg')">image/jpeg</xsl:when>
          <xsl:when test="contains(@href,'.JPG')">image/jpeg</xsl:when>
          <xsl:when test="contains(@href,'.gif')">image/gif</xsl:when>
          <xsl:when test="contains(@href,'.GIF')">image/gif</xsl:when>
          <xsl:when test="contains(@href,'.png')">image/png</xsl:when>
          <xsl:when test="contains(@href,'.PNG')">image/png</xsl:when>
          <xsl:otherwise>
            <xsl:message>Warning: <xsl:value-of select="@href"/> image format not supported by DITA Open Toolkit.
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


  <xsl:template match="*[contains(@class,' map/map ')]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/author ')]"> 
    <dc:creator opf:role="aut" opf:file-as="Feedbooks"><xsl:apply-templates/></dc:creator>
  </xsl:template>

  <xsl:template match="*[contains(@class,' map/map ')]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/publisher ')]"> 
    <dc:publisher><xsl:apply-templates/></dc:publisher>
  </xsl:template>

  <xsl:template match="*[contains(@class,' map/map ')]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/copyright ')]"> 
    <!-- copyryear and copyrholder are required children of copyright element -->
    <dc:rights>Copyright <xsl:value-of select="*[contains(@class,' topic/copyryear ')]/@year"/><xsl:text> </xsl:text><xsl:value-of select="*[contains(@class,' topic/copyrholder ')]"/></dc:rights>
  </xsl:template>

  <xsl:template match="*[contains(@class,' map/topicref ')]" mode="manifest">
    <opf:item id="{generate-id()}" href="{substring-before(@href,'.xml')}.html"
              media-type="application/xhtml+xml"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' map/topicref ')]" mode="spine">
    <opf:itemref idref="{generate-id()}"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap/pubid ')]" mode="bookid">
    <xsl:choose>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/isbn-13 ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/isbn-13 ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/isbn-10 ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/isbn-10 ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/isbn ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/isbn ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/issn-13 ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/issn-13 ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/issn-10 ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/issn-10 ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/issn ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/issn ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/pubpartno ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/pubpartno ')])"/>
      </xsl:when>
      <xsl:when test="not(normalize-space(*[contains(@class, ' pubmap/pubnumber ')]) = '')">
        <xsl:value-of select="normalize-space(*[contains(@class, ' pubmap/pubnumber ')])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>{No publication ID}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

</xsl:stylesheet>
