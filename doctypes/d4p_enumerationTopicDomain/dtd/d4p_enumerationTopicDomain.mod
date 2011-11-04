<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Enumeration Topic Domain
     
     Defines specializations of data for specifying enumerations
     in topic content.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumerator             "d4pEnumerator" >
<!ENTITY % dp4EnumeratorStream       "dp4EnumeratorStream" >
<!ENTITY % d4pEnumeratorOrdinalValue "d4pEnumeratorOrdinalValue" >
<!ENTITY % d4pEnumeratorDisplayValue "d4pEnumeratorDisplayValue" >
<!ENTITY % d4pEnumeratorFormat       "d4pEnumeratorFormat" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumerator.content
"
  (dp4EnumeratorStream,
   d4pEnumeratorOrdinalValue?,
   d4pEnumeratorDisplayValue?,
   d4pEnumeratorFormat?
  )
">
<!ENTITY % d4pEnumerator.attributes
"
  name
    NMTOKEN
    'd4pEnumerator'
">
<!ELEMENT d4pEnumerator %d4pEnumerator.content; >
<!ATTLIST d4pEnumerator %d4pEnumerator.attributes; >

<!ENTITY % dp4EnumeratorStream.content
"
  EMPTY
">
<!ENTITY % dp4EnumeratorStream.attributes
"
  name
    NMTOKEN
    'dp4EnumeratorStream'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT dp4EnumeratorStream %dp4EnumeratorStream.content; >
<!ATTLIST dp4EnumeratorStream %dp4EnumeratorStream.attributes; >

<!ENTITY % d4pEnumeratorOrdinalValue.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorOrdinalValue.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorOrdinalValue'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorOrdinalValue %d4pEnumeratorOrdinalValue.content; >
<!ATTLIST d4pEnumeratorOrdinalValue %d4pEnumeratorOrdinalValue.attributes; >

<!ENTITY % d4pEnumeratorDisplayValue.content
"
  (#PCDATA | %text;)*
">
<!ENTITY % d4pEnumeratorDisplayValue.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorDisplayValue'
  value
    CDATA
    #IMPLIED
">
<!ELEMENT d4pEnumeratorDisplayValue %d4pEnumeratorDisplayValue.content; >
<!ATTLIST d4pEnumeratorDisplayValue %d4pEnumeratorDisplayValue.attributes; >

<!ENTITY % d4pEnumeratorFormat.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorFormat.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorFormat'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorFormat %d4pEnumeratorFormat.content; >
<!ATTLIST d4pEnumeratorFormat %d4pEnumeratorFormat.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4pEnumerator               %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorBase     d4p_enum-d/d4pEnumerator ">
<!ATTLIST dp4EnumeratorStream         %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/dp4EnumeratorProperty d4p_enum-d/dp4EnumeratorStream ">
<!ATTLIST d4pEnumeratorOrdinalValue   %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/dp4EnumeratorProperty d4p_enum-d/d4pEnumeratorOrdinalValue ">
<!ATTLIST d4pEnumeratorDisplayValue   %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/dp4EnumeratorProperty d4p_enum-d/d4pEnumeratorDisplayValue ">
<!ATTLIST d4pEnumeratorFormat         %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/dp4EnumeratorProperty d4p_enum-d/d4pEnumeratorFormat ">


<!-- ================== End D4P Enumeration Topic Domain ==================== -->