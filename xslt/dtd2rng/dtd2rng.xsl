<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:d2r="urn:names:dtd2rng"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns="http://relaxng.org/ns/structure/1.0"
  exclude-result-prefixes="xs relpath d2r"
  version="2.0">
  <!-- =====================================================
       Utility transform to generate DITA RNG moduels from
       DTD modules.
       
       Uses analyze-string to do regular expression parsing of
       DTD files. Depends on the use of DITA code formatting
       conventions
       
       The input to the transform is an XML file that references
       each DTD module file to be processed:
       
       <modules>
         <include href="someModule.mod"/>
        </modules>
        
        The root element type does not matter.
       
       ======================================================= -->
  
  <xsl:import href="relpath_util.xsl"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:variable name="doDebug" as="xs:boolean" select="false()"/>
    
    <generation-log xmlns="urn:names:dtd2rng">
     <time><xsl:sequence select="current-dateTime()"/></time>
     <input><xsl:sequence select="document-uri(.)"/></input>      
    
    <xsl:apply-templates select="/*/include">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
    </generation-log>
  </xsl:template>
  
  <xsl:template match="include[@href]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="href" as="xs:string" select="@href"/>
    <xsl:variable name="baseName" select="relpath:getNamePart($href)"/>
    
    <xsl:variable name="moduleName" as="xs:string"
      select="if (ends-with($baseName, 'Domain'))
                 then substring-before($baseName, 'Domain')
              else $baseName"
    />
    
    <xsl:variable name="dtdModuleURI" as="xs:string"
      select="string(resolve-uri($href, base-uri(.)))"
    />
    
    <xsl:variable name="resultURI" as="xs:string"
      select="relpath:newFile(relpath:newFile(relpath:getParent(relpath:getParent($dtdModuleURI)), 'rng'), 
                              concat($baseName, '.rng'))"
    />
    
    <xsl:variable name="dtdText" select="unparsed-text($dtdModuleURI)" as="xs:string?"/>
    <!-- Skip any XML declaration since we never want it -->
    <xsl:variable name="startPos" as="xs:integer"
      select="if (starts-with($dtdText, '&lt;?xml'))
                 then 2
                 else 1"
    />
    <xsl:variable name="dtdLines" as="xs:string*" 
      select="for $l in tokenize($dtdText, '\n')[position() ge $startPos] return replace($l, '&#x0d;', '')"/>
    
    <d2r:include>
      <d2r:source><xsl:sequence select="$dtdModuleURI"/></d2r:source>
      <d2r:generatedFile><xsl:sequence select="$resultURI"/></d2r:generatedFile>
      <xsl:result-document href="{$resultURI}">
        <grammar 
          xmlns="http://relaxng.org/ns/structure/1.0"
          xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
          datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
          <xsl:call-template name="makeModuleDesc">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="dtdText" as="xs:string" select="$dtdText"/>
            <xsl:with-param name="dtdLines" as="xs:string*" select="$dtdLines"/>
            <xsl:with-param name="moduleName" as="xs:string" tunnel="yes" select="$moduleName"/>
          </xsl:call-template>
          <xsl:call-template name="makeDomainExtensionPatterns">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="dtdText" as="xs:string" select="$dtdText"/>
            <xsl:with-param name="dtdLines" as="xs:string*" select="$dtdLines"/>
            <xsl:with-param name="moduleName" as="xs:string" tunnel="yes" select="$moduleName"/>
          </xsl:call-template>
          <xsl:call-template name="makeElementNamePatterns">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="dtdText" as="xs:string" select="$dtdText"/>
            <xsl:with-param name="dtdLines" as="xs:string*" select="$dtdLines"/>
            <xsl:with-param name="moduleName" as="xs:string" tunnel="yes" select="$moduleName"/>
          </xsl:call-template>
          <xsl:call-template name="makeElementTypeDeclarations">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="dtdText" as="xs:string" select="$dtdText"/>
            <xsl:with-param name="dtdLines" as="xs:string*" select="$dtdLines"/>
            <xsl:with-param name="moduleName" as="xs:string" tunnel="yes" select="$moduleName"/>
          </xsl:call-template>
        </grammar>
      </xsl:result-document>
    </d2r:include>
    
    
  </xsl:template>
  
  <xsl:template name="makeModuleDesc">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    <xsl:param name="moduleName" as="xs:string" tunnel="yes"/>
    
    
    <xsl:variable name="moduleTitle" as="xs:string"
      select="normalize-space($dtdLines[2])"
    />
    
    <moduleDesc xmlns="http://dita.oasis-open.org/architecture/2005/">
      <moduleTitle><xsl:value-of select="$moduleTitle"/></moduleTitle>
      <headerComment xml:space="preserve">
<xsl:sequence select="d2r:getBlockComment($dtdLines)"/>
</headerComment>
      <moduleMetadata>
        <moduleType>elementdomain</moduleType>
        <moduleShortName><xsl:value-of select="concat($moduleName, '-d')"/></moduleShortName>
        <modulePublicIds>
          <dtdMod><xsl:value-of select="concat('urn:xxx:dtd:', $moduleName, '.mod')"/></dtdMod>
          <dtdEnt><xsl:value-of select="concat('urn:xxx:dtd:', $moduleName, '.ent')"/></dtdEnt>
          <xsdMod><xsl:value-of select="concat('urn:xxx:xsd:', $moduleName, '.xsd')"/></xsdMod>
          <rncMod><xsl:value-of select="concat('urn:xxx:rnc:', $moduleName, '.rnc')"/></rncMod>
          <rngMod><xsl:value-of select="concat('urn:xxx:rng:', $moduleName, '.rng')"/></rngMod>
        </modulePublicIds>
        <domainsContribution><xsl:value-of select="concat('(topic ', $moduleName, '-d)')"/></domainsContribution>
      </moduleMetadata>
    </moduleDesc>
    
    
  </xsl:template>
  
  <xsl:template name="makeDomainExtensionPatterns">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    <xsl:param name="moduleName" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="lines" as="xs:string*"
      select="d2r:getLinesUntilMatch(d2r:scanToSection($dtdLines, 'ELEMENT NAME ENTITIES'),
      '==========')"
    />
    
    
    <div><xsl:text>&#x0a;</xsl:text>
      <a:documentation>DOMAIN EXTENSION PATTERNS</a:documentation><xsl:text>&#x0a;</xsl:text>
      
      <define name="{$moduleName}-d-xxx">
        <xsl:for-each select="$lines[starts-with(., '&lt;!ENTITY % ')]">
          <xsl:analyze-string select="." regex="% (\c+) ">
            <xsl:matching-substring>
              <ref name="{regex-group(1)}.element"/>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:for-each>
        
        <xsl:text>&#x0a;      </xsl:text></define>
      
    <xsl:text>&#x0a;   </xsl:text></div>
    
  </xsl:template>
  
  <xsl:template name="makeElementNamePatterns">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    <xsl:param name="moduleName" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="lines" as="xs:string*"
      select="d2r:getLinesUntilMatch(d2r:scanToSection($dtdLines, 'ELEMENT NAME ENTITIES'),
                                     '==========')"
    />
    
    
    <div><xsl:text>&#x0a;</xsl:text>
      <a:documentation>ELEMENT TYPE NAME PATTERNS</a:documentation><xsl:text>&#x0a;</xsl:text>
      <xsl:for-each select="$lines[starts-with(., '&lt;!ENTITY % ')]">
        <xsl:analyze-string select="." regex="% (\c+) ">
          <xsl:matching-substring>
            <define name="{regex-group(1)}">
              <ref name="{regex-group(1)}.element"/>
            </define>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:for-each>
      
    </div>
    
  </xsl:template>
  
  <xsl:template name="makeElementTypeDeclarations">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    <xsl:param name="moduleName" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="lines" as="element()*">
      <xsl:for-each select="
        d2r:getLinesUntilMatch(d2r:scanToSection($dtdLines, 'ELEMENT DECLARATIONS'),
                '==========')">
        <line><xsl:value-of select="."/></line>
      </xsl:for-each>
      
    </xsl:variable>
    
        
    
    <div><xsl:text>&#x0a;</xsl:text>
      <a:documentation>ELEMENT TYPE DECLARATIONS</a:documentation><xsl:text>&#x0a;</xsl:text>

      <xsl:for-each-group select="$lines" group-starting-with="*[matches(., '&lt;!ENTITY.+\.content')]">
        <!-- Ignore leading or trailing blank lines. -->
        <xsl:if test="matches(., '&lt;!')">
          <xsl:variable name="tagname" as="xs:string"
            select="substring-before(substring-after(., '&lt;!ENTITY % '), '.content')"/>
          <div>
            <a:documentation>Long Name: <xsl:value-of select="$tagname"/></a:documentation>
            <xsl:for-each-group select="current-group()" group-starting-with="*[matches(., '&lt;!')]">
              <xsl:call-template name="handleDeclaration">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
                <xsl:with-param name="lines" as="element()+" select="current-group()"/>
              </xsl:call-template>
            </xsl:for-each-group>
          </div>
        </xsl:if>
      </xsl:for-each-group>
      
    </div>
    
  </xsl:template>
  
  <xsl:template name="handleDeclaration">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
    
    <xsl:choose>
      <xsl:when test="contains($lines[1], '&lt;!ELEMENT')">
        <xsl:call-template name="handleElementDecl">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
          <xsl:with-param name="lines" as="element()+" select="$lines"/>          
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($lines[1], '&lt;!ATTLIST')">
        <xsl:call-template name="handleAttlistDecl">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
          <xsl:with-param name="lines" as="element()+" select="$lines"/>          
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($lines[1], '&lt;!--')">
        <xsl:call-template name="handleCommentDecl">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
          <xsl:with-param name="lines" as="element()+" select="$lines"/>          
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($lines[1], '.content')">
        <xsl:call-template name="handleContentParmEnt">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
          <xsl:with-param name="lines" as="element()+" select="$lines"/>          
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($lines[1], '.attributes')">
        <xsl:call-template name="handleAttlistParmEnt">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>          
          <xsl:with-param name="lines" as="element()+" select="$lines"/>          
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARN] handleDeclaration: Unrecognized declaration:
<xsl:for-each select="$lines">
  <xsl:value-of select="."/><xsl:text>&#x0a;</xsl:text>
</xsl:for-each>          
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="handleContentParmEnt">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
    
    <xsl:variable name="entityName" as="xs:string"
      select="tokenize($lines[1], ' ')[3]"
    />
    <!-- First character will always be a '"' and we want to start with the group open. -->
    <xsl:variable name="groupString" as="xs:string*"
      select='substring(string-join(for $l in $lines[position() gt 1] return normalize-space($l), ""), 2)' 
      />
    
    <define name="{$entityName}">
      <xsl:choose>
        <xsl:when test="matches($groupString, 'EMPTY')">
          <empty/>
        </xsl:when>
        <xsl:when test="matches($groupString, 'ANY')">
          <any/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="d2r:processContentGroup($groupString, ())"/>    
        </xsl:otherwise>
      </xsl:choose>
    </define>
  </xsl:template>
  
  <xsl:template name="handleAttlistParmEnt">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
    
    <xsl:variable name="entityName" as="xs:string"
      select="tokenize($lines[1], ' ')[3]"
    />
    <define name="{$entityName}">
      <xsl:for-each-group select="$lines[position() gt 1]" group-starting-with="*[matches(., '^  \c+')]">
        <xsl:choose>
          <xsl:when test='contains(., """")'>
            <!-- Ignore -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="attname" as="xs:string" select="normalize-space(.)"/>
            <xsl:variable name="default" as="xs:string" select="normalize-space(current-group()[3])"/>
              <xsl:choose>
                <xsl:when test="$default = ('#IMPLIED')">
                  <optional>
                    <attribute name="{$attname}"/>
                  </optional>                  
                </xsl:when>
                <xsl:otherwise>
                  <attribute name="{$attname}">
                    <xsl:if test="not($default = ('#REQUIRED'))">
                      <xsl:attribute name="a:defaultValue" select="$default"/>
                    </xsl:if>
                  </attribute>
                </xsl:otherwise>
              </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:for-each-group>
    </define>
    
  </xsl:template>
  
  <xsl:template name="handleElementDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
  </xsl:template>
  
  <xsl:template name="handleAttlistDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
  </xsl:template>
  
  <xsl:template name="handleCommentDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="text()"/>

  <!-- Get the block comment that starts in the first line of the
       input string.
       
    -->
  <xsl:function name="d2r:getBlockComment" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:sequence select="d2r:getBlockComment($lines, false())"/>
  </xsl:function>
  
  <!-- Get the block comment that starts in the first line of the
       input string.
       
    -->
  <xsl:function name="d2r:getBlockComment" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getBlockComment(): Starting, lines[1]:
<xsl:sequence select="$lines[1]"/></xsl:message>
    </xsl:if>
    
    <!-- Account for the original comment open delimiter so horizontal indent is preserved in result -->
    <xsl:variable name="firstLine" select="concat('    ', substring-after($lines[1], '&lt;!--'))"/>
    <xsl:variable name="result" as="xs:string*"
      select="($firstLine, d2r:getLinesUntilMatch($lines[position() gt 1], '\s?--&gt;$', $doDebug))"
    />
    <xsl:sequence select="string-join($result, '&#x0a;')"/>
  </xsl:function>
  
  <xsl:function name="d2r:getLinesUntilMatch" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:sequence select="d2r:getLinesUntilMatch($lines, $regex, false())"/>
  </xsl:function>
  
  <xsl:function name="d2r:getLinesUntilMatch" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
        
    <xsl:variable name="result" as="xs:string*"
      select="d2r:getLinesUntilMatch((), $lines, $regex, $doDebug)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <!-- Gets lines until a line matches the regular expression or
       the lines are exhausted.
       
       Last line is the text before the match.
       
    -->
  <xsl:function name="d2r:getLinesUntilMatch" as="xs:string*">
    <xsl:param name="resultLines" as="xs:string*"/>
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getLinesUntilMatch(): Starting, regex="<xsl:value-of select="$regex"/>", 
        lines[1]:
/<xsl:sequence select="$lines[1]"/>/</xsl:message>
    </xsl:if>
        
    <xsl:variable name="beforeMatch" as="xs:string?"
      select="if (matches($lines[1], $regex))
                 then tokenize($lines[1], $regex)[1]
                 else ()
      "
    />
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getLinesUntilMatch(): beforeMatch="<xsl:value-of select="$beforeMatch"/>"</xsl:message>
    </xsl:if>
    

    <xsl:variable name="result" as="xs:string*"
      select="if (empty($lines) or matches($lines[1], $regex))
                 then ($resultLines, $beforeMatch)
                 else d2r:getLinesUntilMatch(($resultLines, $lines[1]),
                                             $lines[position() gt 1], 
                                             $regex, 
                                             $doDebug)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <!-- Scans the input lines until it finds the labeled section and returns the lines following 
       the second heading block comment.
    -->
  <xsl:function name="d2r:scanToSection" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="sectionText" as="xs:string"/>
    
    <!-- Skip the closing comment line -->
    <xsl:variable name="result" as="xs:string*"
      select="d2r:scanToMatchingLine($lines, $sectionText)[position() gt 1]"
    />
    
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <!-- Scans the input lines until it finds the labeled section and returns the lines following 
       the second heading block comment.
    -->
  <xsl:function name="d2r:scanToMatchingLine" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    
    <xsl:variable name="matched" as="xs:boolean"
      select="matches($lines[1], $regex)"
    />
    
    <xsl:variable name="result" as="xs:string*"
      select="if ($matched or empty($lines))
      then $lines[position() gt 1]
      else d2r:scanToMatchingLine($lines[position() gt 1], $regex)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="d2r:processContentGroup" as="node()*">
    <xsl:param name="groupString" as="xs:string"/>
    <xsl:param name="resultTokens" as="element()*"></xsl:param>
    
    <xsl:message> + [DEBUG] d2r:processContentGroup(): groupString=/<xsl:value-of select="$groupString"/>/</xsl:message>

    <xsl:variable name="groupToken" as="element()">
      <d2r:group>
        <xsl:sequence select="d2r:processGroupTokens(substring($groupString, 2), ())"/>
      </d2r:group>
    </xsl:variable>
    
    <xsl:message> + [DEBUG] d2r:processContentGroup(): groupToken:
=====
<xsl:sequence select="$groupToken"/>
=====
    </xsl:message>
    
    <xsl:sequence select="($resultTokens, $groupToken)"/>
    
  </xsl:function>
  
  <xsl:function name="d2r:processGroupTokens" as="element()*">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:param name="resultTokens" as="element()*"/>

    <xsl:message> + [DEBUG] d2r:processGroupTokens(): inString=/<xsl:value-of select="$inString"/>/</xsl:message>
    
    <xsl:variable name="result" as="element()*"
      select="if (not($inString)) 
                 then $resultTokens
              else if (substring($inString, 1, 1) = ('('))
                    then d2r:processContentGroup($inString, $resultTokens)
                    else d2r:processContentToken($inString, $resultTokens)
      "
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="d2r:processContentToken" as="element()*">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:param name="resultTokens" as="element()*"/>
    
    <xsl:message> + [DEBUG] d2r:processContentToken(): inString=/<xsl:value-of select="$inString"/>/</xsl:message>
    <xsl:message> + [DEBUG] d2r:processContentToken(): resultTokens=
====
<xsl:sequence select="$resultTokens"/>
====</xsl:message>
    
    <xsl:variable name="token" as="xs:string?"
       select="d2r:parseContentToken($inString)"
    />
    <xsl:variable name="tokenElem" as="element()?">
      <xsl:choose>
        <xsl:when test="not($token)">
          <!-- no token element -->
        </xsl:when>
        <xsl:when test="starts-with($token, ')')">
          <d2r:groupend>
            <xsl:if test="string-length($token) gt 1">
              <xsl:attribute name="repeat" select="substring($token, 2)"/>
            </xsl:if>
          </d2r:groupend>
        </xsl:when>
        <xsl:when test="$token = ('EMPTY')">
          <empty/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="occurrence" as="xs:string?"
            select="if (matches($token, '[\?\*\+]$'))
                       then substring($token, string-length($token))
                       else ()"
           />
          <d2r:elementToken name="{tokenize($token, '[\?\*\+]')[1]}">
            <xsl:if test="$occurrence">
              <xsl:attribute name="occurrence" select="$occurrence"/>
            </xsl:if>
          </d2r:elementToken>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="result" as="element()*"
      select="d2r:processGroupTokens(substring($inString, string-length($token) + 2), ($resultTokens, $tokenElem))"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="d2r:parseContentToken" as="xs:string?">
    <xsl:param name="inString" as="xs:string"/>
    
    <xsl:message> + [DEBUG] d2r:parseContentToken(): inString=/<xsl:value-of select="$inString"/>/ </xsl:message>
    
    <xsl:variable name="tokenString" as="xs:string?"
      select="d2r:getTokenCharacters($inString, ())"
    />
    <xsl:message> + [DEBUG] d2r:parseContentToken(): returning=/<xsl:value-of select="$tokenString"/>/ </xsl:message>
    
    <xsl:sequence select="$tokenString"/>
  </xsl:function>
  
  <xsl:function name="d2r:getTokenCharacters" as="xs:string?">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:param name="resultString" as="xs:string?"/>

<!--    
    <xsl:message> + [DEBUG] d2r:getTokenCharacters(): inString=/<xsl:value-of select="$inString"/>/ </xsl:message>
    <xsl:message> + [DEBUG] d2r:getTokenCharacters(): resultString=/<xsl:value-of select="$resultString"/>/ </xsl:message>
-->    
    <xsl:if test="$inString = ('')">
      <xsl:sequence select="$resultString"/>      
    </xsl:if>
    
    <xsl:variable name="c" as="xs:string" select="substring($inString, 1, 1)"/>
    <xsl:variable name="rest" as="xs:string?" select="substring($inString, 2)"/>
    
    <xsl:variable name="result" as="xs:string?"
      select='if (not(matches($c, "[\c\?\*\+]"))) 
                 then $resultString
                 else d2r:getTokenCharacters($rest, concat($resultString, $c))
                 '
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
</xsl:stylesheet>