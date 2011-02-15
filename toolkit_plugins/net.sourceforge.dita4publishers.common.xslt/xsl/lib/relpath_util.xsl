<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="relpath xs"
  
  >
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Returns the base URI of the specified context node. Fixes "file:///" to "file:/" 
      for compatibility with processors that choke on "file:///".</xd:p>
    </xd:desc>
    <xd:param name="context"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:base-uri" as="xs:string">
    <xsl:param name="context" as="node()"/>
    <xsl:variable name="baseUri" select="string(base-uri($context))" as="xs:string"/>
    <xsl:variable name="resultBaseUri" 
      select="if (starts-with($baseUri, 'file:///'))
                 then (concat('file:/', substring-after($baseUri, 'file:///')))
                 else $baseUri
      " 
      as="xs:string"/>
    <xsl:sequence select="$resultBaseUri"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Encodes a URI string.</xd:p>
    </xd:desc>
    <xd:param name="inUriString"></xd:param>
    <xd:return>Encoded URI</xd:return>
  </xd:doc>
  <xsl:function name="relpath:encodeUri" as="xs:string">
    <xsl:param name="inUriString" as="xs:string"/>
    <xsl:variable name="parts" select="tokenize($inUriString, '#')"/>
    <xsl:variable name="pathTokens" as="xs:string*">
      <xsl:for-each select="tokenize($parts[1], '/')">
        <xsl:sequence select="encode-for-uri(.)"/>  
      </xsl:for-each>      
    </xsl:variable>
    <xsl:variable name="escapedFragId" as="xs:string"
      select="if ($parts[2]) then concat('#', encode-for-uri($parts[2])) else ''"
    />
    <xsl:variable name="result" as="xs:string"
      select="concat(string-join($pathTokens, '/'), $escapedFragId)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Unecodes an encoded URI string encoded in UTF-8 encoding.</xd:p>
    </xd:desc>
    <xd:param name="inUriString"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:unencodeUri" as="xs:string">
    <xsl:param name="inUriString" as="xs:string"/>
    <xsl:variable name="firstChar" select="substring($inUriString, 1, 1)" as="xs:string"/>
    <xsl:variable name="outUriString" as="xs:string*">
      <xsl:for-each select="tokenize($inUriString, '/')">
        <xsl:variable name="pathComponent" select="." as="xs:string"/>
        <xsl:variable name="unencodedComponent" select="relpath:unencodeString(.)" as="xs:string"/>
        <xsl:sequence select="$unencodedComponent"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="pathComponentsJoined" select="string-join($outUriString, '/')"/>
    <xsl:sequence
      select="$pathComponentsJoined"
    />
  </xsl:function>
  
  <xsl:function name="relpath:unencodeString" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="tokens" as="xs:string*">
      <xsl:analyze-string select="$inString" regex="%[0-9A-Fa-f][0-9A-Fa-f]">
        <xsl:matching-substring>
          <xsl:sequence select="."/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:sequence select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] unencodeString(): tokens=<xsl:sequence select="string-join($tokens, '|')"/></xsl:message>-->
    <xsl:variable name="resultTokens" as="xs:string*"
      select="relpath:unencodeStringTokens($tokens, ())"
    />
    <xsl:sequence select="string-join($resultTokens, '')"/>
  </xsl:function>
  
  <xsl:function name="relpath:unencodeStringTokens" as="xs:string*">
    <xsl:param name="tokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/> 
    <xsl:choose>
      <xsl:when test="count($tokens) = 0">
        <xsl:sequence select="$resultTokens"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="token" select="$tokens[1]" as="xs:string"/>
        <xsl:choose>
          <xsl:when test="starts-with($token, '%')">
            <xsl:sequence select="relpath:processEncodedChars($token, $tokens[position() > 1], $resultTokens)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Reset character code and copy token to result token list: -->
            <xsl:sequence select="relpath:unencodeStringTokens($tokens[position() > 1], ($resultTokens, $tokens[1]))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:function>
  
  <xsl:function name="relpath:processEncodedChars" as="xs:string*">
    <xsl:param name="byte1Str" as="xs:string"/>
    <xsl:param name="tokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/>
     
    <xsl:variable name="byte1" as="xs:integer"
      select="relpath:hex-to-char($byte1Str)"
    /> 
    <!--<xsl:message> + [DEBUG] processEncodedChars(): byte1 is "<xsl:sequence select="$byte1"/>" (<xsl:sequence select="$byte1Str"/>)</xsl:message>-->
    <xsl:choose>
      <xsl:when test="$byte1 lt 128">
        <!-- ASCII character -->
        <xsl:variable name="char" 
          select="codepoints-to-string($byte1)" as="xs:string"/>
        <!--<xsl:message> + [DEBUG] processEncodedChars(): byte1 is ASCII character "<xsl:sequence select="$char"/>"</xsl:message>-->
        <xsl:sequence select="relpath:unencodeStringTokens($tokens, ($resultTokens, $char))"/>
      </xsl:when>
      <xsl:when test="$byte1 gt 127 and $byte1 lt 192">
        <xsl:message> + [ERROR] Invalid byte <xsl:sequence select="$byte1Str"/> in UTF-8 byte sequence.</xsl:message>
        <xsl:sequence select="relpath:unencodeStringTokens($tokens, ($resultTokens, '&#xFFFD;'))"/>
      </xsl:when>
      <xsl:when test="count($tokens) = 0">
        <xsl:message> + [ERROR] Expected more encoded bytes for initial byte <xsl:sequence select="$byte1Str"/></xsl:message>
        <xsl:sequence select="relpath:unencodeStringTokens($tokens, ($resultTokens, '&#xFFFD;'))"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Must be start of multi-byte sequence -->
        <!--<xsl:message> + [DEBUG] processEncodedChars(): Multi-byte sequence, processing second byte...</xsl:message>-->
        <xsl:sequence
          select="relpath:processSecondUtfByte($byte1, $tokens[1], $tokens[position() > 1], $resultTokens)"
        />
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  <xsl:function name="relpath:processSecondUtfByte" as="xs:string*">
    <xsl:param name="byte1" as="xs:integer"/>
    <xsl:param name="byte2Str" as="xs:string"/>
    <xsl:param name="tokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/>
    
    <xsl:variable name="byte2" as="xs:integer"
      select="relpath:hex-to-char($byte2Str)"
    /> 
<!-- 
  if (byte2 > 127 && byte2 < 192) {
  decoded = decoded + String.fromCharCode(((byte1 & 0x1F) << 6) | (byte2 & 0x3F));
  } else {
  decoded = decoded + encoded.substr(i,6);
  illegalencoding = illegalencoding + encoded.substr(i,6) + " ";
  }
-->
    <!--<xsl:message> + [DEBUG] processSecondUtfByte(): processing byte2 <xsl:sequence select="$byte2"/> (<xsl:sequence select="$byte2Str"/>)</xsl:message>-->
    <xsl:choose>
      <xsl:when test="$byte2 gt 127 and $byte2 lt 192">
        <!--<xsl:message> + [DEBUG] processSecondUtfByte(): byte is between 127 and 192 </xsl:message>-->
        <xsl:variable name="shiftedByte1" as="xs:integer"
          select="relpath:shiftLeft(relpath:bitwiseAnd($byte1, 31), 6)"
        />
        <!--<xsl:message> + [DEBUG] processSecondUtfByte(): shifted and anded byte1 = <xsl:sequence select="$shiftedByte1"/> </xsl:message>-->
        <xsl:variable name="andedByte2" as="xs:integer"
          select="(relpath:bitwiseAnd($byte2, 63))"
        />
        <!--<xsl:message> + [DEBUG] processSecondUtfByte(): anded byte2 = <xsl:sequence select="$andedByte2"/> </xsl:message>-->
        
        <xsl:variable name="codePoint" 
          select="relpath:shiftLeft(relpath:bitwiseAnd($byte1, 31), 6) + (relpath:bitwiseAnd($byte2, 63)) "/>
        <!--<xsl:message> + [DEBUG] processSecondUtfByte(): code Point = <xsl:sequence select="$codePoint"/> ("<xsl:sequence select="codepoints-to-string($codePoint)"/>")</xsl:message>-->
        <xsl:variable name="char" select="codepoints-to-string($codePoint)" as="xs:string"/>
        <!--<xsl:message> + [DEBUG] processSecondUtfByte(): char = "<xsl:sequence select="$char"/>"</xsl:message>-->
        <xsl:sequence select="relpath:unencodeStringTokens($tokens, ($resultTokens, $char))"/>
      </xsl:when>
      <xsl:when test="count($tokens) = 0">
        <xsl:message> + [ERROR] Expected more encoded bytes for initial byte <xsl:sequence select="$byte2Str"/></xsl:message>
        <xsl:sequence select="relpath:unencodeStringTokens($tokens, ($resultTokens, '&#xFFFD;'))"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Must be 3+ byte sequence -->
        <xsl:message> + [DEBUG] processSecondUtfByte(): 3+ byte sequence, processing third byte...</xsl:message>
        <xsl:sequence
          select="relpath:processThirdUtfByte($byte1, $byte2, $tokens[1], $tokens[position() > 1], $resultTokens)"
        />
      </xsl:otherwise>
    </xsl:choose>        
  </xsl:function>
  
  <xsl:function name="relpath:processThirdUtfByte" as="xs:string*">
    <xsl:param name="byte1" as="xs:integer"/>
    <xsl:param name="byte2" as="xs:integer"/>
    <xsl:param name="byte3Str" as="xs:string"/>
    <xsl:param name="tokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/>
    
    <xsl:variable name="byte3" as="xs:integer"
      select="relpath:hex-to-char($byte3Str)"
    /> 
    <xsl:sequence select="$resultTokens"/>
  </xsl:function>
  
  <xsl:function name="relpath:shiftLeft" as="xs:integer">
    <xsl:param name="operand" as="xs:integer"/>
    <xsl:param name="shiftSize" as="xs:integer"/>
    <!--<xsl:message> + [DEBUG] shiftLeft(): operand=<xsl:sequence select="$operand"/></xsl:message>-->
    <xsl:variable name="multiplier" select="(2,4,8,16,32,64,128,256)[$shiftSize]" as="xs:integer"/>
    <!--<xsl:message> + [DEBUG] shiftLeft(): multipler=<xsl:sequence select="$multiplier"/></xsl:message>-->
    <xsl:variable name="result" as="xs:integer"
      select="$operand * $multiplier"
    />
    <!--<xsl:message> + [DEBUG] shiftLeft(): $result=<xsl:sequence select="$result"/></xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="relpath:bitwiseAnd" as="xs:integer">
    <xsl:param name="byte1" as="xs:integer"/>
    <xsl:param name="byte2" as="xs:integer"/>
    <!--<xsl:message> + [DEBUG] bitwiseAnd(): byte1 = <xsl:sequence select="$byte1"/></xsl:message>
    <xsl:message> + [DEBUG] bitwiseAnd(): byte2 = <xsl:sequence select="$byte2"/></xsl:message>-->
    <xsl:variable name="byte1Bit7" select="if (($byte1 mod 256) - ($byte1 mod 128) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit6" select="if (($byte1 mod 128) - ($byte1 mod 64) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit5" select="if (($byte1 mod 64)  - ($byte1 mod 32) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit4" select="if (($byte1 mod 32)  - ($byte1 mod 16) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit3" select="if (($byte1 mod 16)  - ($byte1 mod 8) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit2" select="if (($byte1 mod 8)   - ($byte1 mod 4) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit1" select="if (($byte1 mod 4)   - ($byte1 mod 2) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte1Bit0" select="if (($byte1 mod 2)  > 0) then 1 else 0" as="xs:integer"/>
    
    <xsl:variable name="byte2Bit7" select="if (($byte2 mod 256) - ($byte2 mod 128) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit6" select="if (($byte2 mod 128) - ($byte2 mod 64) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit5" select="if (($byte2 mod 64)  - ($byte2 mod 32) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit4" select="if (($byte2 mod 32)  - ($byte2 mod 16) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit3" select="if (($byte2 mod 16)  - ($byte2 mod 8) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit2" select="if (($byte2 mod 8)   - ($byte2 mod 4) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit1" select="if (($byte2 mod 4)   - ($byte2 mod 2) > 0) then 1 else 0" as="xs:integer"/>
    <xsl:variable name="byte2Bit0" select="if (($byte2 mod 2)  > 0) then 1 else 0" as="xs:integer"/>
    
    <!--<xsl:message> + [DEBUG]: Byte1 <xsl:sequence select="if ($byte1Bit7) then 1 else 0"
    />,<xsl:sequence select="$byte1Bit7"
    />,<xsl:sequence select="$byte1Bit6"
    />,<xsl:sequence select="$byte1Bit5"
    />,<xsl:sequence select="$byte1Bit4"
    />,<xsl:sequence select="$byte1Bit3"
    />,<xsl:sequence select="$byte1Bit2"
    />,<xsl:sequence select="$byte1Bit1"
    />,<xsl:sequence select="$byte1Bit0"
    /></xsl:message>
    <xsl:message> + [DEBUG]: Byte2 <xsl:sequence select="$byte2Bit7"
    />,<xsl:sequence select="$byte2Bit7"
    />,<xsl:sequence select="$byte2Bit6"
    />,<xsl:sequence select="$byte2Bit5"
    />,<xsl:sequence select="$byte2Bit4"
    />,<xsl:sequence select="$byte2Bit3"
    />,<xsl:sequence select="$byte2Bit2"
    />,<xsl:sequence select="$byte2Bit1"
    />,<xsl:sequence select="$byte2Bit0"
    /></xsl:message>-->
    <xsl:variable name="result" as="xs:integer"
      select="
      (128 * $byte2Bit7 * $byte1Bit7) +
      (64 * $byte2Bit6 * $byte1Bit6) +
      (32 * $byte2Bit5 * $byte1Bit5) +
      (16 * $byte2Bit4 * $byte1Bit4) +
      (8* $byte2Bit3 * $byte1Bit3) +
      (4 * $byte2Bit2 * $byte1Bit2) +
      (2 * $byte2Bit1 * $byte1Bit1) +
      (1 * $byte2Bit0 * $byte1Bit0)
      "
    />
    <!--<xsl:message> + [DEBUG] bitwiseAnd(): result=<xsl:sequence select="$result"/></xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="relpath:unescapeUriCharacter" as="xs:string">
    <xsl:param name="escapedCharStr" as="xs:string"/>
    <xsl:variable name="cadr" select="substring($escapedCharStr, 2)"/>
    <xsl:variable name="resultChar" as="xs:string">
      <!-- cadr must be pair of hex digits -->
      <xsl:variable name="codepoint" select="relpath:hex-to-char($cadr)" as="xs:integer"/>
      <xsl:sequence select="codepoints-to-string($codepoint)"/>
    </xsl:variable>
    <xsl:sequence select="$resultChar"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Gets the filename of the resource (last path component) as for Java File.getName().</xd:p>
    </xd:desc>
    <xd:param name="sourcePath"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getName" as="xs:string">
    <!-- As for Java File.getName(): returns the last
         component of the path.
    -->
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:value-of select="tokenize($sourcePath, '/')[last()]"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Gets the name part of the resource filename, that is, the filename with any extension removed.</xd:p>
    </xd:desc>
    <xd:param name="sourcePath"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getNamePart" as="xs:string">
    <!-- Returns the name part of a filename, excluding
         any trailing extension.
    -->
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:variable name="fullName" select="relpath:getName($sourcePath)" as="xs:string"/>
    <xsl:variable name="result" as="xs:string"
      select="if (contains($fullName, '.'))
                 then string-join(tokenize($fullName, '\.')[position() &lt; last()], '.')
                 else $fullName
             "
    />
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Gets the extension, if any, of the resource's filename.</xd:p>
    </xd:desc>
    <xd:param name="sourcePath"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getExtension" as="xs:string">
    <!-- Returns the extension part of a filename, excluding the
         leading "."
    -->
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:variable name="fullName" select="relpath:getName($sourcePath)" as="xs:string"/>
    <xsl:variable name="result" as="xs:string"
      select="if (contains($fullName, '.'))
      then tokenize($fullName, '\.')[last()]
      else ''
      "
    />
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>As for Java File.getParent(): returns all but the last
        components of the path.</xd:p>
    </xd:desc>
    <xd:param name="sourcePath"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getParent" as="xs:string">
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:value-of select="string-join(tokenize($sourcePath, '/')[position() &lt; last()], '/')"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>As for Java File(File, path)): Returns a new a absolute path representing
        the new file. File must be a path (because XSLT has no way to distinguish
        a file from a directory).</xd:p>
    </xd:desc>
    <xd:param name="parentPath">Parent directory for the new file.</xd:param>
    <xd:param name="childFile">Path and name of child file. May be an absolute or relative
    path.</xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:newFile" as="xs:string">
    <xsl:param name="parentPath" as="xs:string"/>
    <xsl:param name="childFile" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="matches($childFile, '^(/|[a-z]+:)')">
        <xsl:value-of select="$childFile"/>
      </xsl:when>
      <xsl:when test="$parentPath = '/'">
        <xsl:variable name="tempPath" select="concat($parentPath, $childFile)" as="xs:string"/>
        <xsl:variable name="result"
          select="relpath:getAbsolutePath($tempPath)"/>
        <xsl:value-of select="$result"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="tempParentPath" as="xs:string" 
          select="if (ends-with($parentPath, '/') and $parentPath != '/') 
          then substring($parentPath, 1, string-length($parentPath) - 1) 
          else $parentPath" />
        <xsl:variable name="parentTokens" select="tokenize($tempParentPath, '/')" as="xs:string*"/>
        <xsl:variable name="firstToken" select="$parentTokens[1]" as="xs:string?"/>
        <xsl:variable name="childTokens" select="tokenize($childFile, '/')" as="xs:string*"/>
        <xsl:variable name="tempPath" select="string-join(($parentTokens, $childTokens), '/')" as="xs:string"/>
        <xsl:variable name="result"
          select="if ($firstToken = '..') 
              then $tempPath 
              else relpath:getAbsolutePath($tempPath)"/>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Given a path resolves any ".." or "." terms to produce an absolute path</xd:p>
    </xd:desc>
    <xd:param name="sourcePath"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getAbsolutePath" as="xs:string">
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:variable name="pathTokens" select="tokenize($sourcePath, '/')" as="xs:string*"/>
    <xsl:if test="false()">
      <xsl:message> + DEBUG relpath:getAbsolutePath(): Starting</xsl:message>
      <xsl:message> +       sourcePath="<xsl:value-of select="$sourcePath"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="baseResult" 
    select="string-join(relpath:makePathAbsolute($pathTokens, ()), '/')" as="xs:string"/>
    <xsl:variable name="baseResult2" 
      select="if (ends-with($baseResult, '/')) 
                 then substring($baseResult, 1, string-length($baseResult) -1) 
                 else $baseResult" as="xs:string"/>
    <xsl:variable name="result" as="xs:string"
       select="if (starts-with($sourcePath, '/') and not(starts-with($baseResult2, '/')))
                  then concat('/', $baseResult2)
                  else $baseResult2
               "
    />
    <xsl:if test="false()">
      <xsl:message> + DEBUG: result="<xsl:value-of select="$result"/>"</xsl:message>
    </xsl:if>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Removes any relative components from the path.</xd:p>
    </xd:desc>
    <xd:param name="pathTokens"></xd:param>
    <xd:param name="resultTokens"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:makePathAbsolute" as="xs:string*">
    <xsl:param name="pathTokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/>
    <xsl:if test="false()">
      <xsl:message> + DEBUG: relpath:makePathAbsolute(): Starting...</xsl:message>
      <xsl:message> + DEBUG:    pathTokens="<xsl:value-of select="string-join($pathTokens, ',')"/>"</xsl:message>
      <xsl:message> + DEBUG:    resultTokens="<xsl:value-of select="string-join($resultTokens, ',')"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="if (count($pathTokens) = 0)
                             then $resultTokens
                             else if ($pathTokens[1] = '.')
                                  then relpath:makePathAbsolute($pathTokens[position() > 1], $resultTokens)
                                  else if ($pathTokens[1] = '..')
                                       then relpath:makePathAbsolute($pathTokens[position() > 1], $resultTokens[position() &lt; last()])
                                       else relpath:makePathAbsolute($pathTokens[position() > 1], ($resultTokens, $pathTokens[1]))
                         "/>
  </xsl:function>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Calculate relative path that gets from from source path to target path.</xd:p>
      <xd:pre>
        Given:
        
        [1]  Target: /A/B/C
        Source: /A/B/C/X
        
        Return: "X"
        
        [2]  Target: /A/B/C
        Source: /E/F/G/X
        
        Return: "/E/F/G/X"
        
        [3]  Target: /A/B/C
        Source: /A/D/E/X
        
        Return: "../../D/E/X"
        
        [4]  Target: /A/B/C
        Source: /A/X
        
        Return: "../../X"
      </xd:pre>
    </xd:desc>
    <xd:param name="source"></xd:param>
    <xd:param name="target"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="relpath:getRelativePath" as="xs:string">
    <xsl:param name="source" as="xs:string"/><!-- Path to get relative path *from* -->
    <xsl:param name="target" as="xs:string"/><!-- Path to get relataive path *to* -->
    <xsl:variable name="effectiveSource" as="xs:string"
      select="if (ends-with($source, '/') and string-length($source) > 1) then substring($source, 1, string-length($source) - 1) else $source"
    />
    <xsl:if test="false()">
      <xsl:message> + [DEBUG]: relpath:getRelativePath(): Starting...</xsl:message>
      <xsl:message> + [DEBUG]:     source="<xsl:value-of select="$effectiveSource"/>"</xsl:message>
      <xsl:message> + [DEBUG]:     target="<xsl:value-of select="$target"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="sourceTokens" select="tokenize((if (starts-with($effectiveSource, '/')) then substring-after($effectiveSource, '/') else $effectiveSource), '/')" as="xs:string*"/>
    <xsl:variable name="targetTokens" select="tokenize((if (starts-with($target, '/')) then substring-after($target, '/') else $target), '/')" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="(count($sourceTokens) > 0 and count($targetTokens) > 0) and 
                      (($sourceTokens[1] != $targetTokens[1]) and 
                       (contains($sourceTokens[1], ':') or contains($targetTokens[1], ':')))">
        <!-- Must be absolute URLs with different schemes, cannot be relative, return
        target as is. -->
        <xsl:value-of select="$target"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="resultTokens" 
          select="relpath:analyzePathTokens($sourceTokens, $targetTokens, ())" as="xs:string*"/>              
        <xsl:variable name="result" select="string-join($resultTokens, '/')" as="xs:string"/>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="relpath:toUrl" as="xs:string">
    <xsl:param name="filepath" as="xs:string"/>
    <xsl:variable name="url" as="xs:string"
      select="if (contains($filepath, '\'))
       then translate($filepath, '\', '/')
       else $filepath
      "
    />
    <xsl:variable name="fileUrl" as="xs:string"
      select="
      if (matches($url, '^[a-zA-Z]:'))
        then concat('file:/', $url)
        else $url
        "
    />
    <xsl:sequence select="$fileUrl"/>
  </xsl:function>
  
  <xsl:function name="relpath:toFile" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:param name="platform" as="xs:string"/><!-- One of "windows", "nx" -->
    <xsl:variable name="unescapedUrl" select="relpath:unencodeUri($url)" as="xs:string"/>
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] -------------</xsl:message>
      <xsl:message> + [DEBUG] toFile(): url         ='<xsl:sequence select="$url"/>', platform='<xsl:sequence select="$platform"/>'</xsl:message>
      <xsl:message> + [DEBUG] toFile(): unescapedUrl='<xsl:sequence select="$unescapedUrl"/>', platform='<xsl:sequence select="$platform"/>'</xsl:message>
    </xsl:if>
    <xsl:variable name="result" as="xs:string"
       select="
       if ($platform = 'windows')
          then relpath:urlToWindowsFile($unescapedUrl)
          else relpath:urlToNxFile($unescapedUrl)
       "
    />
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] toFile(): result='<xsl:sequence select="$result"/>'</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="relpath:urlToNxFile" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="matches($url, '^file:.+')">
        <xsl:variable name="filepath" select="substring-after($url, 'file:')" as="xs:string"/>
        <xsl:variable name="result" as="xs:string"
          select="
          if (starts-with($filepath, '///'))
          then substring($filepath, 3)
          else $filepath
          "
        />
        <xsl:sequence select="$result"/>
      </xsl:when>
      <xsl:when test="matches($url, '^[a-zA-Z]+:.+')">
        <xsl:sequence select="'{cannot convert absolute URL to file path}'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="relpath:urlToWindowsFile" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] urlToWindowsFile(): url='<xsl:sequence select="$url"/>'</xsl:message>
    </xsl:if>
    <xsl:variable name="basePath" as="xs:string"
       select="relpath:urlToNxFile($url)"
    />
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] urlToWindowsFile(): basePath='<xsl:sequence select="$basePath"/>'</xsl:message>
    </xsl:if>
    <xsl:variable name="windowsPath" as="xs:string" 
      select="
     replace(
      replace($basePath, '/', '\\'), 
      '%20', 
      ' ')" 
      />
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] urlToWindowsFile(): windowsPath='<xsl:sequence select="$windowsPath"/>'</xsl:message>
    </xsl:if>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($windowsPath, '^\\[a-zA-Z]+:')">
          <xsl:sequence select="substring($windowsPath, 2)"/>
        </xsl:when>
        <xsl:when test="matches($windowsPath, '^\\\\\\[a-zA-Z]+:')">
          <xsl:sequence select="substring($windowsPath, 4)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$windowsPath"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="false()">      
      <xsl:message> + [DEBUG] urlToWindowsFile(): Returning '<xsl:sequence select="$result"/>'</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function> 
  
  
  
  <xsl:function name="relpath:analyzePathTokens" as="xs:string*">
    <xsl:param name="sourceTokens" as="xs:string*"/>
    <xsl:param name="targetTokens" as="xs:string*"/>
    <xsl:param name="resultTokens" as="xs:string*"/>
    <xsl:if test="false()">
    <xsl:message> + DEBUG: relpath:analyzePathTokens(): Starting...</xsl:message>
    <xsl:message> + DEBUG:     sourceTokens=<xsl:value-of select="string-join($sourceTokens, ',')"/></xsl:message>
    <xsl:message> + DEBUG:     targetTokens=<xsl:value-of select="string-join($targetTokens, ',')"/></xsl:message>
    <xsl:message> + DEBUG:     resultTokens=<xsl:value-of select="string-join($resultTokens, ',')"/></xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count($sourceTokens) = 0">
        <!-- Append remaining target tokens (if any) to the result -->
        <xsl:sequence select="$resultTokens, $targetTokens"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Still source tokens, so see if source[1] = target[1] -->
        <xsl:choose>
          <!-- If they are equal, go to the next level in the paths: -->
          <xsl:when test="(count($targetTokens) > 0) and ($sourceTokens[1] = $targetTokens[1])">
            <xsl:sequence select="relpath:analyzePathTokens($sourceTokens[position() > 1], $targetTokens[position() > 1], $resultTokens)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Paths must diverge at this point. Append one ".." for each token
            left in the source: -->
            <xsl:variable name="goUps" as="xs:string*">
              <xsl:for-each select="$sourceTokens">
                <xsl:sequence select="'..'"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="string-join(($resultTokens, $goUps, $targetTokens), '/')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  <xsl:function name="relpath:hex-to-char" as="xs:integer">
    <xsl:param name="in" as="xs:string"/> <!-- e.g. 030C -->
    <xsl:sequence select="
      if (string-length($in) eq 1)
      then relpath:hex-digit-to-integer($in)
      else 16 * relpath:hex-to-char(substring($in, 1, string-length($in)-1)) +
      relpath:hex-digit-to-integer(substring($in, string-length($in)))"/>
  </xsl:function>
  
  <xsl:function name="relpath:hex-digit-to-integer" as="xs:integer">
    <xsl:param name="char" as="xs:string"/>
    <xsl:sequence 
      select="string-length(substring-before('0123456789ABCDEF',
      $char))"/>
  </xsl:function>
</xsl:stylesheet>
