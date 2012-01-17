<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"
  exclude-result-prefixes="xs df relpath"
  version="2.0">
  
<!--  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
-->  
  <xsl:output name="graphic-map" method="xml" indent="yes" />
  <xsl:output name="ant" method="xml" indent="yes" />
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-graphic-map">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating graphic input-to-output map...</xsl:message>
    <xsl:variable name="graphicRefs" as="element()*">
      <xsl:apply-templates mode="get-graphic-refs" select=".//*[df:isTopicRef(.)]"/>
      <xsl:apply-templates mode="additional-graphic-refs" select="."/>
    </xsl:variable>
    
    <xsl:message> + [INFO]   Found <xsl:sequence select="count($graphicRefs)"/> graphic references.</xsl:message>
    <xsl:variable name="uniqueRefs" as="element()">
      <root>
        <xsl:for-each-group select="$graphicRefs" group-by="string(@href)">
          <xsl:sequence select="current-group()[1]"/>
        </xsl:for-each-group>        
      </root>
    </xsl:variable>
    <xsl:message> + [INFO]   Found <xsl:sequence select="count($uniqueRefs/*)"/> unique graphic references.</xsl:message>
    
    <gmap:graphic-map>
      <xsl:for-each select="$uniqueRefs/*">
        <xsl:variable name="absoluteUrl" as="xs:string" select="@href"/>
        <xsl:variable name="filename" as="xs:string" select="@filename"/>
        <xsl:variable name="namePart" as="xs:string" select="relpath:getNamePart($filename)"/>
        <xsl:variable name="extension" as="xs:string" select="relpath:getExtension($filename)" />
        <xsl:variable name="key" 
          select="
          if (count(preceding-sibling::*[@filename = $filename]) > 0)
          then concat($namePart, '-', count(preceding-sibling::*[@filename = $filename]) + 1, '.', $extension)
          else $filename
          "
        />
        <gmap:graphic-map-item
          input-url="{$absoluteUrl}"
          output-url="{relpath:newFile($imagesOutputPath, $key)}"
        >
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:sequence select="@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="id" select="generate-id(.)"/>
            </xsl:otherwise>
          </xsl:choose>          
        </gmap:graphic-map-item>        
      </xsl:for-each>
    </gmap:graphic-map>
    <xsl:message> + [INFO] Graphic input-to-output map generated.</xsl:message>
  </xsl:template>  
  
  <xsl:template mode="additional-graphic-refs" match="*[df:class(., 'map/map')]">
    <!-- Nothing to do by default. Override this template to do something special,
         such as setting a default cover graphic or including branding components
         or whatever.
    -->
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-graphic-map get-graphic-refs">
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates 
          select="$topic//*[df:class(.,'topic/image')] | 
                  $topic//*[df:class(.,'topic/object')]" 
          mode="#current"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/image')]" mode="get-graphic-refs">
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="graphicPath" select="@href" as="xs:string?"/>
    <xsl:variable name="rawUrl" select="concat($parentPath, '/', $graphicPath)" as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    <xsl:if test="$debugBoolean">    
      <xsl:message> + [DEBUG] get-graphic-refs for image:
          
          docUri="<xsl:sequence select="$docUri"/>"
          parentPath="<xsl:sequence select="$parentPath"/>"
          graphicPath="<xsl:sequence select="$graphicPath"/>"
          rawUrl="<xsl:sequence select="$rawUrl"/>"
          absoluteUrl="<xsl:sequence select="$absoluteUrl"/>"      
        </xsl:message>
    </xsl:if>   
    <xsl:choose>
      <xsl:when test="not($graphicPath)">
        <xsl:variable name="topic" as="element()?"
          select="(ancestor-or-self::*[df:class(., 'topic/topic')])[1]"
        />
        <xsl:variable name="contextString" as="xs:string"
          select="if ($topic) 
          then concat('Topic ', df:getNavtitleForTopic($topic))
          else name(..)"
        />
        <xsl:message> + [WARN] Image element with no @href or @keyref attribute in <xsl:sequence select="$contextString"/></xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <gmap:graphic-ref href="{$absoluteUrl}" filename="{relpath:getName($absoluteUrl)}"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/image')]" mode="generate-graphic-map">
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="graphicPath" select="@href" as="xs:string"/>
    <xsl:variable name="rawUrl" select="concat($parentPath, '/', $graphicPath)" as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    
    <xsl:if test="$graphicPath">
      <gmap:graphic-map-item
        input-url="{$absoluteUrl}"
        output-url="{relpath:newFile($imagesOutputPath, relpath:getName($absoluteUrl))}"
      />        
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:class(.,'topic/object')]" mode="get-graphic-refs">
    <!-- NOTE: For object elements, the @data attribute points at the main
               object data object, but its location may be relative to @codebase.
               It's a bit ambiguous in practice whether the @data object will
               be managed with the source, and therefore needs to be copied,
               or will be managed separately, when @codebase is specified.
               This code assumes that if @codebase is specified, @data should
               be ignored. Override this template to change this behavior to
               match what you actually do, if necessary.
      -->
               
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="dataPath" select="@data" as="xs:string?"/>
    <xsl:variable name="codeBase" select="@codebase" as="xs:string?"/>    
    <xsl:if test="true() or $debugBoolean">    
      <xsl:message> + [DEBUG] get-graphic-refs for object:
        
        docUri="<xsl:sequence select="$docUri"/>"
        parentPath="<xsl:sequence select="$parentPath"/>"
        dataPath="<xsl:sequence select="$dataPath"/>"
        codeBase="<xsl:sequence select="$codeBase"/>"
      </xsl:message>
    </xsl:if>   
    <xsl:if test="$dataPath != ''">
      <xsl:variable name="rawUrl" 
        select="if (@codeBase != '') 
        then relpath:newFile($codeBase, $dataPath)
        else relpath:newFile($parentPath, $dataPath)" 
        as="xs:string"/>
      <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
      <xsl:if test="$debugBoolean">    
        <xsl:message>
          rawUrl="<xsl:sequence select="$rawUrl"/>"
          absoluteUrl="<xsl:sequence select="$absoluteUrl"/>"      
        </xsl:message>
      </xsl:if>   
      <xsl:if test="$dataPath and not($codeBase = '')">
        <gmap:graphic-ref href="{$absoluteUrl}" filename="{relpath:getName($absoluteUrl)}"/>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates mode="#current"/>    
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/object')]" mode="generate-graphic-map">
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="dataPath" select="@data" as="xs:string?"/>
    <xsl:variable name="codeBase" select="@codebase" as="xs:string?"/>    
    <xsl:variable name="rawUrl" 
      select="if (@codeBase != '') 
      then relpath:newFile($codeBase, $dataPath)
      else relpath:newFile($parentPath, $dataPath)" 
      as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    
    <xsl:if test="$dataPath and not($codeBase = '')">
      <gmap:graphic-map-item
        input-url="{$absoluteUrl}"
        output-url="{relpath:newFile($imagesOutputPath, relpath:getName($absoluteUrl))}"
      />
    </xsl:if>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/param')][@valuetype = 'ref']" mode="get-graphic-refs">
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="valuePath" select="@value" as="xs:string?"/>
    <xsl:variable name="rawUrl" select="concat($parentPath, '/', $valuePath)" as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    <xsl:if test="true() or $debugBoolean">    
      <xsl:message> + [DEBUG] get-graphic-refs for param:
        
        docUri="<xsl:sequence select="$docUri"/>"
        parentPath="<xsl:sequence select="$parentPath"/>"
        valuePath="<xsl:sequence select="$valuePath"/>"
      </xsl:message>
    </xsl:if>   
    <xsl:choose>
      <xsl:when test="not($valuePath)">
        <xsl:variable name="topic" as="element()?"
          select="(ancestor-or-self::*[df:class(., 'topic/topic')])[1]"
        />
        <xsl:variable name="contextString" as="xs:string"
          select="if ($topic) 
          then concat('Topic ', df:getNavtitleForTopic($topic))
          else name(..)"
        />
        <xsl:message> + [WARN] param element with @valuetype of 'ref' but no @value attribute in <xsl:sequence select="$contextString"/></xsl:message>        
      </xsl:when>
      <xsl:otherwise>
        <gmap:graphic-ref href="{$absoluteUrl}" filename="{relpath:getName($absoluteUrl)}"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(.,'topic/param')][@valuetype = 'ref']" mode="generate-graphic-map">
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentPath" select="relpath:getParent($docUri)" as="xs:string"/>
    <xsl:variable name="valuePath" select="@value" as="xs:string?"/>
    <xsl:variable name="rawUrl" select="concat($parentPath, '/', $valuePath)" as="xs:string"/>
    <xsl:variable name="absoluteUrl" select="relpath:getAbsolutePath($rawUrl)"/>
    
    <xsl:if test="$valuePath">
      <gmap:graphic-map-item
        input-url="{$absoluteUrl}"
        output-url="{relpath:newFile($imagesOutputPath, relpath:getName($absoluteUrl))}"
      />
    </xsl:if>
  </xsl:template>
  

  
  <xsl:template match="text()" mode="generate-graphic-map get-graphic-refs"/>
  
</xsl:stylesheet>
