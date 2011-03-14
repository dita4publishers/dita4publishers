Release Notes: Version 0.9.15

Common XSLT library

- Implemented decoding of escaped UTF-8 characters in URIs.

Word to DITA

- Fixed issue 3186860, Tables with no header row emit empty thead. Tables with no header rows and tables with only header rows should now produce valid DITA topics.

Vocabulary

- Corrected design problem with MathML integration. In order for the eqn-block and eqn-inline elements to be normal DITA elements, there must be another level of markup between those elements and the MathML math elements. I added a new container, specialized from foreign, named d4pMathML, that then contains the math element. This is the in d4pFormatting domain.

- Added object and foreign to content of art. This allows art to used to bind metadata to any kind of media object or display.