Release Notes:

Release Notes: Version 0.9.19RC12

Version 0.9.19 (Under development)

Theme for the Release

The 0.9.19 release is primarily about finishing out and generalizing the map-based processing used in the EPUB, Kindle, HTML2, and HTML5 transforms.

The transforms should work with the 1.6, 1.7, and 1.8 versions of the Open Toolkit.

There is the start of vocabulary reference document, developed by Steven Calderwood of Human Kinetics.

Significant improvements to Word-to-DITA transformation framework. The markup for style-to-tag maps has been enhanced to be more complete and hopefully easier to work with. A migration utility is provided in net.sourceforge.dita4publishers.word2dita/utils/style2tagmapMigrator.xsl. It should produce working style-to-tag maps from most existing style-to-tag maps. A few may require manual adjustment, especially if you are trying to generate maps and topics at the same time.

The release also includes additions and refinements to the vocabulary, numerous bug fixes and whatnot.

Word to DITA

New features:

Feature 32: Capture type for break elements and filter out page and column breaks by default (avoids blank paragraphs caused by manual page breaks).
Feature 31: Enable generation of nested inlines by supporting @containerType on inline elements. Lets you generate e.g. <sup><b>A</b></sup>.
Feature 30: Completely reworked how maps are generating, making it possible to generate complex systems of maps and topicrefs. Includes ability to specify @containerType for topicrefs (e.g., "frontmatter" for topicrefs within a book map).
Feature 28: Can now specify map and topic generation details on <output> elements since these are usually the same for all instances of a given topic or map type. Values specified on specific style mappings override the values on <output>.
Feature 27: Added ability to generate @type attribute on <data> elements via new @typeAttValue attribute on style maps.
Feature 18, Feature 24: Added handling of Symbols and Wingdings fonts in Word documents. Result is correct Unicode characters in the generated XML.
Feature 8, Feature 23: Generally improved capturing of Word table details in DITA. DITA result should now reflect the Word table as completely as is possible within the limits of CALS tables.
Feature 17: Capture literal MathML markup in Word documents as MathML in the generated DITA. Literal MathML is created by the Design Science MathType Word plugin from binary MathType equations.
Feature 16: Capture the data behind charts as CALS tables. Note that the chart itself is not captured.
Feature 14: Implemented ability to set @toc attribute on generated topicrefs.
Feature 1: Implement support for footnotes.

Bugs:

Issue 45, Issue 46, Issue 58, Issue 152, Issue 159, Issue 161, Issue 162, Issue 166: Reimplemented map and topic generation to correct errors in map generation. Made the intermediate simpleWP XML reflect the map and topic hierarchy to make DITA generation easier. This change could affect custom preprocessing applied to the simpleWP XML. Also adds a number of new attributes to style mapping definitions as required to fully specify map and topicref generation.
Issue 156: Correctly handle character styles within hyperlinks.
Issue 153: Correctly handle metadata paragraphs after map-generating paragraph.
Issue 83, Issue 110, Issue 152: Broke out map and topic filename generation code into separate XSLT modules to make it easier to override or extend: modeMapUrl.xsl and modeTopicUrl.xsl
Issue 121, Issue 129, Issue 143, Issue 148: Improved table generation to capture all table geometry, including horizontal and vertical alignment within cells.
Issue 139: Fixed issue with hyperlinks not being generated when @xtrc attributes were filtered out.
Handle characters in non-Unicode, Word-specific Symbol and Wingdings fonts. These characters should be translated to the correct Unicode character when there is a Unicode character to use.
Issue 63: Improved generation of hyperlinks.
Issue 33: Implemented generation of footnotes from Word footnotes.
Issue 135: Corrected handling of nbsp references in inline MathML markup.
Issue 120: Enable capturing of MathML from "inline" MathML created by MathType from MathType equations.
Issue 114: Capture width and height of embedded images as sized in the Word doc.
Feature 6, Issue 103: Enable generation of globally unique filenames by providing parameter for filename prefix.
Issue 101: Provide parameter to use filenames of linked graphics when there is a linked graphic.
DITA to InCopy

New features:

Feature 20: Include map resolution library in base DITA-to-InCopy transform.
Fixed bugs:

Issue 133: Corrected generation of ICML table markup, various improvements in generated table geometry.
Issue 119: Corrected handling of table titles with non-numeric numbers.
Issue 72, Issue 113: Correctly escape grouped style names in style catalog.
Issue 94, Issue 107: Handle outputPath correctly in topic2articleIcml.xsl
Issue 85: Corrected order of imports in dita2indesign_template.xsl module.
Transformation Types

New features:

Feature 7: Implemented support for generating HTML5 video and audio markup. Uses new d4p_mediaDomain specialization module.
Fixed bugs:

Added XSLT parameter extension points to all transform types
Issue 165: Correctly include descendants of sections in enumerables.
Issue 164: Correct issue with extra vertical space for <br> in PDF.
Issue 155: Correct generation of EPUB list of tables only process list of tables once.
Issue 151: Corrected name of parameter extension point for EPUB transformation type.
Issue 150: Corrected resolveTopicElementRef() to trap and report case where containing document can't be resolved.
Issue 149: Corrected duplicate capturing of enumerables when @chunk is "to-content".
Issue 147: Corrected xs:int to xs:integer is dita-support-lib.xsl.
Issue 146: Correctly handle toc="no" in HTML2 transform.
Issue 142: Corrected generation of duplicate IDs for enumerables.
Issue 140: Corrected handling of @locktitle for navtitles on topicrefs
Issue 124: Include @type attribute on <link> elements in generated HTML for EPUB and Kindle transforms.
Issue 123: Include references to OT catalog in all XSLT calls from D4P transforms.
Issue 112: Corrected duplication of index entries in collected index data.
Issue 111: Added XSLT parameter extension point to all transforms as for base XHTML transform.
Issue 91: Correctly detect failure to resolve topicref in resolve-map.xsl.
Issue 89: Corrected failures in graphviz transform.
Issue 86: Use base-uri() for resolving relative URI references. Affects DITA support library.
Issue 73: Corrected generation of HTML5 video and audio markup. Copying of referenced media objects not yet implemented.
Issue 48: Resolve keyrefs in df:getEffectiveTopicUri() function (dita-support-lib.xsl)
Issue 43: Generate @type attribute in HTML for EPUB and Kindle.
Issue 42: Corrected setting of generateStaticTocBoolean parameter.
Issue 39: Correctly handle flagging parameters in HTML2. Issue with copying flagging graphics not yet addressed.
Issue 37: Use simple enumeration extensions in EPUB transform.
Vocabulary

New features:

Feature 7: New specialization domain, d4p_mediaDomain, that provides specializations of <object> that mirror the HTML5 <video> and <audio> elements.

Fixed bugs:

Issue 72, Issue 168: Use a D4P-specific URN for the reference to the MathML module. This avoids problems where two different DTDs both include MathML.
Issue 136: Added missing @class attribute for <d4pPageRange>.
Issue 99: Added missing catalog inclusion for xmlDomain.
Issue 98: Corrected case and spelling of system IDs for d4p_commonDomainIntegrations external parameter entities.

Release 0.9.19RC09 6 April 2013
Release 0.9.19_OT17RC09

1. Issues 75, 77: Declared all extension points so strict integration succeeds
2. Issue 76: Corrected case of filenames for d4p_simpleEnumerationDomain.mod,.ent. Fixes failures on Linux

Release 0.9.19RC09 
Release 0.9.19_OT17RC09

1. Issue 71: HTML2 transform generates toc.js with links to the temp dir location of all the files
2. Issue 70: Nested topics not getting topicref tunnel parameter
3. Issue 67: References to user.input.file.list in epub, epub3, html2, and kindle breaks DITA-OT1.7.1 builds 

With this release, now producing two packages, one for OT 1.5.4 and 1.6.x, one for 1.7.x, reflecting changes 
in the HTML XSLT code for doing flagging.

Release 0.9.19RC08 23 Jan 2013

1. Issue 63: Implemented support for translating Word hyperlinks into DITA XRefs.
2. Issue 69: Implemented support for D4P Variables domain in HTML and PDF outputs. 
   Added documentation for the Variables domain to the D4P User Guide
3. Issue 64: Fixed: Conref throws off graphic map construction when conref target is in different relative location to a graphic than referencing topic
4. Incremental updates to the HTML5 transform and documentation.

Release 0.9.19RC07 4 Jan 2013

1. Issue 64: Correct issue with construction of graphic map when conref is used.
 

Release 0.9.19RC06 13 Dec 2012 

1. HTML5 transform close to done. Code reorganized. Docs under way

2. Small bug fixes to map-driven processing

3. New applicability data collection process stubbed in--still working on efficient
implementation.

4. New D4P cover and logo in place: many thanks to Human Kinetics for donating the 
graphic design work for this (http://www.humankinetics.com)

Release 0.9.19RC05 Nov 2012 

1. Many refinements.

2. Correctly handle key ref for EPUB cover graphic

3. Ensure return value from df:getNavigationTitleForTopicref() is a single string

4. Return multiple files from XML-to-InCopy transform

5. HTML5 transform alpha version available.



Release 0.9.19RC03 26 Jan 2012 

1. Added new vocabulary module d4p_mathDomain, which adds more general versions
of the existing formatting-domain elements for MathML and equations. Adds new d4p_display-equation
specialization of <fig>

2. Implemented generation of MathML output with optional use of the MathJax package. New Ant parameters are:

html2.mathjax.use.cdn.link
  When set to true, generates reference to MathJax library as served from the public MathJax site. This
  removes the need for any local MathJax installation.
  
html2.mathjax.use.local.link
  When set to true, generates a reference to a local (to the generated HTML pages) installation of MathJax.
  If html2.mathjax.use.cdn.link is also specified, this parameter is ignored.
  
html2.mathjax.local.javascript.uri
  Specifies the relative URI to use for the MathJax.js file.    
  
  

Release 0.9.19RC02 25 Jan 2012

This release candidate adds the following:

1. Support for generating HTML5 video from the new D4P media domain (d4p_MediaDomain). The markup is:

      <d4p_video id="E5123_026.mp4" width="640" height="360">
        <d4p_video_poster value="../images/E5123_026_poster.png"/>
        <d4p_video_source value="../images/E5123_026.mp4" type="video/mp4"/>
      </d4p_video>

The markup design follows the HTML5 markup design, where the subelements of <d4p_video> correspond to attributes or subelements of the HTML5 video element. You can specify as many <d4p_video_source> elements as you have different encodings of the video. As for HTML5, they should be put in preference order.

The generated HTML will work with iBooks (through the EPUB transform type) and with any Web browser that supports HTML5, including Chrome, Safari, and Firefox and Opera (given appropriate video formats--the mp4 video in my test didn't work with either under OSX). 

The <d4p_video_poster> element points to the picture to use as the preview for the video in the browser.

2. Support for back-of-the-book index generation in HTML2 and EPUB (not yet Kindle). If you specify the Ant parameter html2.generate.index a back-of-the-book index HTML page is generated. For HTML2, if you also request the dynamic ToC (which is on by default), the full index will be included in the dynamic ToC (the HTML2 does not generate a reference to the generated back-of-the-book index page in that case.

3. General support for "data collection" across the map. The data collection does three things out of the box:

- Gathers, groups, and sorts all the index entries (if index generation is turned on)
- Constructs and "enumerables" data structure reflecting those things that are or are likely to be numbered: topic headings, figures, tables, examples, etc.
- Gathers, groups, and sorts glossary entries (if glossary generation is turned on).

Each of these operations may be extended by implementing templates in the corresponding modes. You can also add new data collection processes to the base processes to do whatever you want.

The collected data is an XML structure so it can be processed and accessed using normal XSLT2 processing.

The collected data is then passed as a tunnel parameter to all follow-on processing, which means that all templates have access to it. This allows you to do things like number figures across the publication in HTML if you want.

Note that glossary data collection and generation is not yet fully implemented.

This data collection process is generic and not specific to any output format, so it could be used with any kind of output process, not just HTML-based processes. For example, the index data could be used to generate an XSL-FO index for PDF or an InDesign index for InDesign output.