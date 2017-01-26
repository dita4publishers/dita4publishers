<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:d2r="urn:names:dtd2rng"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:dita="http://dita.oasis-open.org/architecture/2005/"
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
        
        The direct output is a generation log file that lists
        the RNG files generated.
       
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
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug or true()"/>
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
          <xsl:call-template name="makeSpecializationAttributeDeclarations">
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
        <xsl:for-each select="$lines[matches(., '\s*&lt;!ENTITY % ')]">
          <xsl:analyze-string select="." regex="% ([a-zA-Z\-\._]+) ">
            <xsl:matching-substring>
              <ref name="{regex-group(1)}.element" xmlns="http://relaxng.org/ns/structure/1.0"/>
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
      <xsl:for-each select="$lines[matches(., '\s*&lt;!ENTITY % ')]">
        <xsl:analyze-string select="." regex="% ([a-zA-z\-\._]+) ">
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
      select='substring(string-join(for $l in $lines[position() gt 1] return replace($l, "\s+",""), ""), 2)' 
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
          <xsl:variable name="group" select="d2r:processContentGroup($groupString, $doDebug)" as="element()"/>
          <xsl:apply-templates mode="convertGroup" select="$group">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </define>
  </xsl:template>
  
  <xsl:template mode="convertGroup" match="d2r:groupdef">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    
    <!-- Construct the groups as a hierarchy of groups.
         
      -->
    <xsl:variable name="grouped" as="element()*">
      <xsl:call-template name="processGroup">
        <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
        <xsl:with-param name="items" as="element()*" select="*"/>
        <xsl:with-param name="groupLevel" as="xs:integer" select="1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] grouped:
        ============
        <xsl:sequence select="$grouped"/>
        ============            
      </xsl:message>
    </xsl:if>
    <xsl:apply-templates select="$grouped" mode="groupedToRNG">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    </xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template name="processGroup">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>              
    <xsl:param name="items" as="node()*"/>
    <xsl:param name="groupLevel" as="xs:integer"/>
        
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] processGroup: groupLevel="<xsl:value-of select="$groupLevel"/>", items:
===
<xsl:sequence select="$items"/>
===
      </xsl:message>
    </xsl:if>
    
    <xsl:for-each-group select="$items" group-starting-with="d2r:startGroup[@level = $groupLevel]">
      <xsl:if test="$doDebug">
        <xsl:message> + [DEBUG] processGroup: group <xsl:value-of select="position()"/>:
          ===
          <xsl:sequence select="current-group()"/>
          ===
        </xsl:message>
      </xsl:if>
      
      <xsl:choose>
        <xsl:when test="self::d2r:startGroup">
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] processGroup: Group</xsl:message>
          </xsl:if>
          <xsl:variable name="groupItems" as="element()*" 
            select="current-group()[position() gt 1][position() lt last()]"
          />
          <d2r:group>
            <xsl:sequence select="current-group()[last()]/@separator"/>
            <xsl:sequence select="current-group()[last()]/@occurrence"/>
            <xsl:call-template name="processGroup">
              <xsl:with-param name="items" as="node()*" select="$groupItems"/>
              <xsl:with-param name="groupLevel" as="xs:integer" select="$groupLevel + 1"/>
            </xsl:call-template>
          </d2r:group>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] processGroup: Not a group</xsl:message>
          </xsl:if>
          
          <!-- Not a group, just put out the parts. -->
          <xsl:sequence select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>          
    </xsl:for-each-group>
  </xsl:template>
  
    
  <xsl:template mode="groupedToRNG" match="rng:*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* except (@separator, @occurrence), node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="groupedToRNG" match="@* | text()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="groupedToRNG" match="d2r:elementToken">
    <xsl:choose>
      <xsl:when test="@occurrence = '*'">
        <zeroOrMore xmlns="http://relaxng.org/ns/structure/1.0">
          <ref name="{@name}"/>
        </zeroOrMore>
      </xsl:when>
      <xsl:when test="@occurrence = '+'">
        <oneOrMore xmlns="http://relaxng.org/ns/structure/1.0">
          <ref name="{@name}"/>
        </oneOrMore>
      </xsl:when>
      <xsl:when test="@occurrence = '?'">
        <optional xmlns="http://relaxng.org/ns/structure/1.0">
          <ref name="{@name}"/>
        </optional>
      </xsl:when>
      <xsl:otherwise>
        <ref name="{@name}" xmlns="http://relaxng.org/ns/structure/1.0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="groupedToRNG" match="d2r:group">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] groupedToRNG: d2r:group:
        ====
        <xsl:sequence select="."/>
        ====
      </xsl:message>
    </xsl:if>
    <xsl:variable name="separator" as="xs:string?"
      select="*[1]/@separator"
    />
    <xsl:variable name="occurrence" as="xs:string?"
      select="@occurrence"
    />
    <xsl:variable name="group" as="element()*">
      <xsl:choose>
        <xsl:when test="$separator = ('|')">
          <choice>
            <xsl:apply-templates mode="#current"/>
          </choice>
        </xsl:when>
        <xsl:otherwise>
          <!-- No group for sequences -->
          <xsl:apply-templates mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$occurrence = ('?')">
        <optional>
          <xsl:sequence select="$group"/>
        </optional>
      </xsl:when>
      <xsl:when test="$occurrence = ('*')">
        <zeroOrMore>
          <xsl:sequence select="$group"/>
        </zeroOrMore>
      </xsl:when>
      <xsl:when test="$occurrence = ('+')">
        <oneOrMore>
          <xsl:sequence select="$group"/>
        </oneOrMore>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$group"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="groupedToRNG" match="d2r:endGroup">
    <!-- Nothing to do -->
  </xsl:template>
  
  <xsl:template mode="convertGroup" match="d2r:*" priority="-1">
    <xsl:message> + [WARN] convertGroup: Unhandled element <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="groupedToRNG" match="d2r:*" priority="-1">
    <xsl:message> + [WARN] groupedToRNG: Unhandled element <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template name="handleAttlistParmEnt">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
    
    <xsl:variable name="entityName" as="xs:string"
      select="tokenize($lines[1], ' ')[3]"
    />

    <define name="{$entityName}">
      <xsl:choose>
        <xsl:when test="matches($lines[2], '&quot;%[a-zA-Z\.\-_]+;&quot;')">
          <xsl:variable name="entityName" as="xs:string" select="translate($lines[2], '&quot;%;', '')"/>
          <ref name="{$entityName}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each-group select="$lines[position() gt 1]" 
            group-starting-with="*[matches(., '^\s{1,16}&quot;?[a-zA-Z\-\._%;]+')]
            [not(matches(., '(CDATA|NMTOKEN|#IMPLIED|#REQUIRED|&quot;)\s*$'))]">
            
            <xsl:choose>
              <xsl:when test='matches(., """$")'>
                <!-- Ignore -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="attname" as="xs:string" select="normalize-space(replace(., '&quot;', ''))"/>
                <xsl:variable name="default" as="xs:string" select="replace(normalize-space(current-group()[3]), '&quot;', '')"/>
                <xsl:choose>
                  <xsl:when test="starts-with($attname, '%')">
                    <ref name="{substring($attname, 2, string-length($attname) - 2)}"/>
                  </xsl:when>
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
        </xsl:otherwise>
      </xsl:choose>
    </define>
    
  </xsl:template>
  
  <xsl:template name="handleElementDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
    
    <xsl:variable name="tagname" as="xs:string"
      select="tokenize(., ' ')[2]"
    />
    
    <define name="{$tagname}.element">
      <element name="{$tagname}" dita:longName="{$tagname}">
        <a:documentation>docs go here.</a:documentation>
        <ref name="{$tagname}.attlist"/>
        <ref name="{$tagname}.content"/>
      </element>
    </define>
  </xsl:template>
  
  <xsl:template name="handleAttlistDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>

    <xsl:variable name="tagname" as="xs:string"
      select="tokenize(., ' ')[2]"
    />
    
    <define name="{$tagname}.attlist" combine="interleave">
      <ref name="{$tagname}.attributes"/>
    </define>
  </xsl:template>
  
  <xsl:template name="handleCommentDecl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>          
    <xsl:param name="lines" as="element()+"/>
  </xsl:template>

  <xsl:template name="makeSpecializationAttributeDeclarations">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    <xsl:param name="moduleName" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="lines" as="element()*">
      <xsl:for-each select="
        d2r:getLinesUntilMatch(d2r:scanToSection($dtdLines, 'SPECIALIZATION ATTRIBUTE DECLARATIONS'),
        '==========')">
        <line><xsl:value-of select="."/></line>
      </xsl:for-each>
      
    </xsl:variable>
    
    
    
    <div><xsl:text>&#x0a;</xsl:text>
      <a:documentation>Specialization attributes. Global attributes and class defaults</a:documentation><xsl:text>&#x0a;</xsl:text>
      
      <xsl:for-each-group select="$lines" group-starting-with="*[matches(., '&lt;!ATTLIST')]">
        <!-- Ignore leading or trailing blank lines. -->
        <xsl:if test="matches(., '&lt;!ATT')">
          <xsl:variable name="text" as="xs:string"
            select="string-join(for $l in current-group() return string($l), ' ')"
          />
          <xsl:variable name="tagname" as="xs:string"
            select="tokenize(normalize-space(.), ' ')[2]"/>
          <xsl:message> + [DEBUG] tagname="<xsl:value-of select="$tagname"/>"</xsl:message>
          <xsl:variable name="classAttValue" as="xs:string">
            <xsl:analyze-string select="$text" regex='class\s+CDATA\s+"([^"]+)"'>
              <xsl:matching-substring>
                <xsl:sequence select="regex-group(1)"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <define name="{$tagname}.attlist" combine="interleave">
            <ref name="global-atts"/>
            <optional>
              <attribute name="class" a:defaultValue="{$classAttValue}"/>
            </optional>
          </define>
        </xsl:if>
      </xsl:for-each-group>
      
    </div>
    
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
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    
    <d2r:groupdef>
      <xsl:sequence select="d2r:processContentGroup($groupString, 0, (), $doDebug)"/>
    </d2r:groupdef>
  </xsl:function>
  
  <!-- Parse a DTD group into d2r group markup (from which the RNG groups are
       then constructed). This two-phase approach handles the fact that DTD
       occurrence indicators are postfix but RNG groups are prefix (via
       wrappers that indicate occurrence).
       
       For DITA-style RNG there is always an outer group with no occurrence
       indicator (top-level groups are implicitly sequences).
    -->
  <xsl:function name="d2r:processContentGroup" as="node()*">
    <xsl:param name="groupString" as="xs:string"/>
    <xsl:param name="groupLevel" as="xs:integer"/>
    <xsl:param name="resultTokens" as="element()*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:processContentGroup(): groupString=/<xsl:value-of select="$groupString"/>/</xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length($groupString) = 0">
        <xsl:sequence select="$resultTokens"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="nextChar" as="xs:string"
          select="substring($groupString, 1, 1)"
        />
        <xsl:sequence 
          select="
            if ($nextChar = '(')
               then d2r:startGroup($groupString, $groupLevel, $resultTokens, $doDebug)
            else if ($nextChar = ')')
            then d2r:endGroup($groupString, $groupLevel, $resultTokens, $doDebug)
            else if ($nextChar = ',')
            then d2r:processContentGroup(substring($groupString, 2), $groupLevel, $resultTokens, $doDebug)
            else d2r:processContentToken($groupString, $groupLevel, $resultTokens, $doDebug)
          "  
        />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="d2r:startGroup" as="element()*">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:param name="groupLevel" as="xs:integer"/>    
    <xsl:param name="resultTokens" as="element()*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    
    <xsl:variable name="newTokens" as="element()*">
      <d2r:startGroup level="{$groupLevel + 1}"/>
    </xsl:variable>
    
    <xsl:sequence select="d2r:processContentGroup(substring($inString, 2), 
                                                  $groupLevel + 1, 
                                                  ($resultTokens, $newTokens),
                                                  $doDebug)"/>
    
  </xsl:function>
  
  <xsl:function name="d2r:endGroup" as="element()*">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:param name="groupLevel" as="xs:integer"/>
    <xsl:param name="resultTokens" as="element()*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    
    <!-- inString includes the group end indicator (')'), so
         any occurrence indicator will be 2nd character of
         the input, if present.
      -->
    <xsl:variable name="cand" as="xs:string?"
      select="substring($inString, 2, 1)"
    />
    <xsl:variable name="occurrenceIndicator" as="xs:string?"
      select="if ($cand = ('*', '+', '?')) then $cand else ()"
    />
    <xsl:variable name="candSep" as="xs:string?"
      select="if ($cand = (',', '|')) 
                 then $cand 
                 else substring($inString, 3, 1)"
    />
    <xsl:variable name="separator" as="xs:string?"
      select="if ($candSep = (',', '|')) 
                 then $candSep 
                 else ()"
    />
    <xsl:variable name="newTokens" as="element()*">
      <d2r:endGroup level="{$groupLevel}">
        <xsl:if test="$separator">
          <xsl:attribute name="separator" separator="$separator"/>
        </xsl:if>
        <xsl:if test="boolean($occurrenceIndicator)">
          <xsl:attribute name="occurrence" select="$occurrenceIndicator"/>
        </xsl:if>
      </d2r:endGroup>
    </xsl:variable>
    
    <xsl:variable name="rest" as="xs:string?"
      select="if (boolean($occurrenceIndicator)) 
                 then substring($inString, 3) 
                 else substring($inString, 2)"
    />
    <xsl:sequence 
      select="d2r:processContentGroup($rest, 
                                      $groupLevel - 1, 
                                      ($resultTokens, $newTokens), 
                                      $doDebug)"
    />
    
  </xsl:function>
  
  <xsl:function name="d2r:processContentToken" as="element()*">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:param name="groupLevel" as="xs:integer"/>
    <xsl:param name="resultTokens" as="element()*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug"> 
       <xsl:message> + [DEBUG] d2r:processContentToken(): inString=/<xsl:value-of select="$inString"/>/</xsl:message>
    </xsl:if>
    
    <xsl:variable name="token" as="xs:string?"
       select="d2r:parseContentToken($inString)"
    />
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:processContentToken(): token=/<xsl:value-of select="$token"/>/</xsl:message>
    </xsl:if>
    <xsl:variable name="tokenElem" as="element()?">
      <xsl:choose>
        <xsl:when test="not($token)">
          <!-- no token element. Should never happen. -->
        </xsl:when>
        <xsl:when test="$token = ('EMPTY')">
          <empty/>
        </xsl:when>
        <xsl:otherwise>          
          <xsl:variable name="occurrence" as="xs:string?">
            <xsl:analyze-string select="$token" regex="[\?\*\+]">
              <xsl:matching-substring>
                <xsl:sequence select="."/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] d2r:processContentToken(): occurrence="<xsl:value-of select="$occurrence"/>"</xsl:message>
          </xsl:if>
          <xsl:variable name="separator" as="xs:string?">
            <xsl:analyze-string select="$token" regex="[\|,]">
              <xsl:matching-substring>
                <xsl:sequence select="."/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] d2r:processContentToken(): separator="<xsl:value-of select="$separator"/>"</xsl:message>
          </xsl:if>
          
          <xsl:variable name="tagname" as="xs:string?">
            <xsl:analyze-string select="$token" regex="[a-zA-Z\-\._#%;]+">
              <xsl:matching-substring>
                <xsl:sequence select="."/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
<!--          <xsl:message> + [DEBUG] d2r:processContentToken(): tagname="<xsl:value-of select="$tagname"/>"</xsl:message>-->
          <xsl:choose>
            <xsl:when test="starts-with($tagname, '%')">
              <rng:ref name="{translate($tagname, ';%', '')}">
                <xsl:if test="$occurrence">
                  <xsl:attribute name="occurrence" select="$occurrence"/>              
                </xsl:if>
                <xsl:if test="$separator">
                  <xsl:attribute name="separator" select="$separator"/>
                </xsl:if>
              </rng:ref>
            </xsl:when>
            <xsl:when test="$tagname = ('#PCDATA')">
              <rng:text>
                <xsl:if test="$occurrence">
                  <xsl:attribute name="occurrence" select="$occurrence"/>              
                </xsl:if>
                <xsl:if test="$separator">
                  <xsl:attribute name="separator" select="$separator"/>
                </xsl:if>
              </rng:text>
            </xsl:when>
            <xsl:otherwise>
              <d2r:elementToken name="{$tagname}">
                <xsl:if test="$occurrence">
                  <xsl:attribute name="occurrence" select="$occurrence"/>              
                </xsl:if>
                <xsl:if test="$separator">
                  <xsl:attribute name="separator" select="$separator"/>
                </xsl:if>
              </d2r:elementToken>              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="result" as="element()*"
      select="if (not($tokenElem))
                 then $resultTokens
                 else d2r:processContentGroup(substring($inString, string-length($token) + 1), 
                                              $groupLevel, 
                                              ($resultTokens, $tokenElem), 
                                              $doDebug)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="d2r:parseContentToken" as="xs:string?">
    <xsl:param name="inString" as="xs:string"/>
    
<!--    <xsl:message> + [DEBUG] d2r:parseContentToken(): inString=/<xsl:value-of select="$inString"/>/ </xsl:message>-->
    <xsl:variable name="tokenString" as="xs:string?">
      <xsl:choose>
        <xsl:when test="starts-with($inString, ')')">
          <!-- Treat ")" as a token start rather than a non-token character so
             we can get the group-end occurence indicator.
          -->
          <xsl:sequence 
            select="concat(')',
                          if (matches($inString, '.[\*\+\?]'))
                             then substring($inString, 2,1)
                             else '')"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="d2r:getTokenCharacters($inString, ())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] d2r:parseContentToken(): returning=/<xsl:value-of select="$tokenString"/>/ </xsl:message>-->
    
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
      select="if ($c = (',', '|'))
                  then concat($resultString, $c)
                  else if (not(matches($c, '[a-zA-Z\-\._#%;]')))
                       then $resultString  
                  else d2r:getTokenCharacters($rest, concat($resultString, $c))
    "/>
    
    <xsl:sequence select="$result"/>
  </xsl:function>
  
</xsl:stylesheet>