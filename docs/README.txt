Release 0.9.19RC02 25 Jan 2012 Release Notes

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