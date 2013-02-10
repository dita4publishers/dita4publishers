Release Notes:

Release 0.9.19RC09 
Release 0.9.19RC09_OT17

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