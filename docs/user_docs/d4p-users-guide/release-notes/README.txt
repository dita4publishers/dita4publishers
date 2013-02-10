Release Notes:

Version 0.9.18 released 8 Jan 2012

All transformation types (HTML2, EPUB, etc.)

- Removed duplicate XSLT imports
- Created common.html plugin to provide single import point for all extensions to the HTML transformation type
- Fixed handling of @scale attribute for images.

Word to DITA

Fixed the following logged bugs:

- 3435135: Misnumbered topics
  Added check for non-topic paragraphs between root-map-generating paragraph and first map- or topic-generating paragraph.   This avoids the problem where content paragraphs immediately after map root cause misnumbering of generated topic filenames.

- 3435133: Use DOCX filename for name of result file
  Updated the plugin Ant script to use the DOCX filename as the base name for the root topic or map by default.

- 3434693: An empty sequence is not allowed as the value of variable $styleMap
  Fixed the code so the variable allows an empty sequence.

- 3435135: Simple word doc generates incorrect topic filename
  Improved error reporting for non-topic-creating paragraphs before first topic-creating paragraph in Word doc.


- 3434694: Key styleMaps has not been defined
  Fixed the XSLT.

- 3434693: An empty sequence is not allowed as the value of variable $s
  Fixed the XSLT.

- 3436363: containerOutputclass causes transform to fail
  Fixed in the XSLT.

Implemented the following feature requests:

- 3309933: Add runtime parameter to set result language
  Added new Ant parameter w2d.language that sets the value to use for the @xml:lang attribute. If not specified, value "en-US" is used.

Other fixes:

- Use configured topic extension for root topic output.

- Use style name "Normal" for unmapped paragraphs. This lets you explicitly map unstyled paragraphs rather than depending on the built-in default mapping to <p>.

- Updated built-in default style-to-tag map to include Heading 2, Heading 3, and Normal.

- Refined the Ant script to make properties appropriately conditional and to avoid setting any unnecessary global properties.

- Added start of an automated regression test suite in the project's test/ area in the source tree. These tests also serve as examples of how to use Ant to call the Toolkit transform.

EPUB and Kindle

Fixed the following logged bugs:

- 3434065: Empty sequence not allowed for $graphicPath
  Fixed the bug so <image> with no @href or @keyref is ignored when building the graphic map but is reported as a warning.

- 3433937: Include keywords as dc:subject in EPUB/Kindle books
  Keywords within metadata/keywords become <dc:subject> elements in the EPUB and Kindle metadata.

- 3433935: Include authors in EPUB/Kindle metadata
  All authors in the publication metadata are included with appropriate roles.

- 3433934: Include ISBN and other bookid in EPUB/Kindle
  ISBN numbers and other bookid content is be included in the EPUB and Kindle metadata appropriately.

- 3411763: Warnings received when an image has the @scale attribute set
  Check for values with a leading "-" and suppress them and report them. If the value is positive, then use it. If it is a bare number, append "px" to the value.

- 3331319: @toc = no not respected for EPUB ToC
  Topics with toc="no" should not be reflected in the EPUB ToC.

- 3317385: Chunked topics produce bad EPUB toc
  Topics chucked to content should produce correct results in the ToC.

- 3312288: Problem with default parameter values
  All D4P plugin Ant build files have been reworked to avoid setting any global parameters inappropriately.
  
- 3471010: Handle .jpeg files for EPUB/Kindle
  EPUB and Kindle processing now correctly handles .jpeg extension in addition to .jpg.

Other fixes/enhancements:

- Factored out some common code between EPUB and Kindle transforms.

DITA to InDesign

- Enhancements and bug fixes to the Java INX support library. Can now generate multi-spread page sequences as configured in a separate configuration file. Corrects bugs with correlation of frames to pages.

- Added support for parsing and accessing conversion configurations defined using the new conversion_config topic type.

- Added XSLT support for generating CS 4/5 ICML InCopy articles from DITA content.

Vocabulary Modules

Fixed the following logged bugs:

- 3371240: Inconsistencies in SYSTEM name in topic.dtd
  Corrected "dp4" to "d4p" throughout. Corrected "d4pcommon" to "d4p_common".

- Corrected some configuration errors in doctype shells.

- Upgraded topic types to use DITA 1.2 coding conventions.

- Added new <art-ph> element. Specialize <art> from topic/p so it can go in <fig> directly.

- Added new topic type "conversion_configuration", used to configure Word2DITA and DITA2InDesign transforms, especially the 

Documentation

- Added missing documentation for word2dita Ant parameters.

- Added vocabulary topics from the website content into the User Guide