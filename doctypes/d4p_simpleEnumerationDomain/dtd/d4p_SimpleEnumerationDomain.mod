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

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4pSimpleEnumerator         %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorBase     d4p_enum-d/d4pSimpleEnumerator ">


<!-- ================== End D4P Enumeration Topic Domain ==================== -->