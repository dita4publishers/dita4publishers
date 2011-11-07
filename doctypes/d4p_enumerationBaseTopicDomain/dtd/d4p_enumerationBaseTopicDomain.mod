<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Enumeration Base Topic Domain
     
     Defines base (abstract) specializations of data for specifying enumerations
     in topic content.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumeratorBase      "d4pEnumeratorBase" >
<!ENTITY % d4pEnumeratorProperty  "d4pEnumeratorProperty" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumeratorBase.content
"
  ((%d4pEnumeratorProperty;)*,
   (%data;)*
  )
">
<!ENTITY % d4pEnumeratorBase.attributes
"
  name
    NMTOKEN
    #IMPLIED
">
<!ELEMENT d4pEnumeratorBase %d4pEnumeratorBase.content; >
<!ATTLIST d4pEnumeratorBase %d4pEnumeratorBase.attributes; >

<!ENTITY % d4pEnumeratorProperty.content
"
  ((%d4pEnumeratorProperty;)*,
   (%data;)*
  )
">
<!ENTITY % d4pEnumeratorProperty.attributes
"
  name
    NMTOKEN
    #IMPLIED
">
<!ELEMENT d4pEnumeratorProperty %d4pEnumeratorProperty.content; >
<!ATTLIST d4pEnumeratorProperty %d4pEnumeratorProperty.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4pEnumeratorBase           %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorBase ">
<!ATTLIST d4pEnumeratorProperty       %global-atts;  class CDATA "+ topic/data  d4p_enumBase-d/d4pEnumeratorProperty ">

<!-- ================== End Enumeration Base Domain ==================== -->