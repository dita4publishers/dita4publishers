<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="relpath xs"
  
  >
  
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
  
  <xsl:function name="relpath:encodeUri" as="xs:string">
    <xsl:param name="inUriString" as="xs:string"/>
    <xsl:variable name="temp1" as="xs:string"
      select="replace($inUriString, ' ', '%20')"
    />
    <xsl:variable name="temp2" as="xs:string"
      select="replace($temp1, '\[', '%5B')"
    />
    <xsl:variable name="temp3" as="xs:string"
      select="replace($temp2, '\]', '%5D')"
    />
    <xsl:variable name="outUriString" as="xs:string"
      select="$temp3"
    />
    <xsl:sequence select="$outUriString"/>
  </xsl:function>
  
  <xsl:function name="relpath:getName" as="xs:string">
    <!-- As for Java File.getName(): returns the last
         component of the path.
    -->
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:value-of select="tokenize($sourcePath, '/')[last()]"/>
  </xsl:function>
  
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
  
  <xsl:function name="relpath:getParent" as="xs:string">
    <!-- As for Java File.getParent(): returns all but the last
         components of the path.
    -->
    <xsl:param name="sourcePath" as="xs:string"/>
    <xsl:value-of select="string-join(tokenize($sourcePath, '/')[position() &lt; last()], '/')"/>
  </xsl:function>
  
  <xsl:function name="relpath:newFile" as="xs:string">
    <!-- As for Java File(File, path)): Returns a new a absolute path representing
         the new file. File must be a path (because XSLT has no way to distinguish
         a file from a directory).
    -->
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
        <xsl:variable name="childTokens" select="tokenize($childFile, '/')" as="xs:string*"/>
        <xsl:variable name="tempPath" select="string-join(($parentTokens, $childTokens), '/')" as="xs:string"/>
        <xsl:variable name="result"
        select="relpath:getAbsolutePath($tempPath)"/>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="relpath:getAbsolutePath" as="xs:string">
    <!-- Given a path resolves any ".." or "." terms to produce an absolute path -->
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
  
  <xsl:function name="relpath:getRelativePath" as="xs:string">
<!-- Calculate relative path that gets from from source path to target path.
  
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
  
  
-->
  
    <xsl:param name="source" as="xs:string"/><!-- Path to get relative path *from* -->
    <xsl:param name="target" as="xs:string"/><!-- Path to get relataive path *to* -->
    <xsl:if test="false()">
      <xsl:message> + DEBUG: relpath:getRelativePath(): Starting...</xsl:message>
      <xsl:message> + DEBUG:     source="<xsl:value-of select="$source"/>"</xsl:message>
      <xsl:message> + DEBUG:     target="<xsl:value-of select="$target"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="sourceTokens" select="tokenize((if (starts-with($source, '/')) then substring-after($source, '/') else $source), '/')" as="xs:string*"/>
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
</xsl:stylesheet>
