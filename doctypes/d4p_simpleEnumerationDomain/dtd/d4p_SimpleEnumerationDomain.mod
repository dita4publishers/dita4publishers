<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Simple Enumeration Domain
     
     Defines specialization of data for specifying simple (literal) enumerations
     in mapr or topic content.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % d4pSimpleEnumerator       "d4pSimpleEnumerator" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- Simple Enumerator: Simply holds a literal enumerator value. -->
<!ENTITY % d4pSimpleEnumerator.content
"
  (#PCDATA | %text;)*
">
<!ENTITY % d4pSimpleEnumerator.attributes
"
  name
    NMTOKEN
    'd4pSimpleEnumerator'
">
<!ELEMENT d4pSimpleEnumerator %d4pSimpleEnumerator.content; >
<!ATTLIST d4pSimpleEnumerator %d4pSimpleEnumerator.attributes; >

<!-- Simple Enumerator: Holds a page number value. Primarily intended for
     capturing page numbers during legacy conversion or for identifying
     literal page number references in legacy content. -->
<!ENTITY % d4pPageNumber.content
"
  (#PCDATA | %text;)*
">
<!ENTITY % d4pPageNumber.attributes
"
  name
    NMTOKEN
    'd4pSimpleEnumerator'
">
<!ELEMENT d4pPageNumber %d4pPageNumber.content; >
<!ATTLIST d4pPageNumber %d4pPageNumber.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4pSimpleEnumerator   %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorBase     d4p_simplenum-d/d4pSimpleEnumerator ">
<!ATTLIST d4pPageNumber         %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorBase     d4p_simplenum-d/d4pPageNumber ">


<!-- ================== End D4P Simple Enumeration Topic Domain ==================== -->