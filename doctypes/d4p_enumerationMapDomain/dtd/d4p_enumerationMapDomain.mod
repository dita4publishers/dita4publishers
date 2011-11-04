<?xml version="1.0" encoding="UTF-8"?>
<!-- =============================================================
     DITA For Publishers Enumeration Map Domain
     
     Defines specializations of topicref and data for specifying enumerations
     in maps.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumeratorStreamDefinition "d4pEnumeratorStreamDefinition" >
<!ENTITY % d4pEnumeratorStreamProperties "d4pEnumeratorStreamProperties" >
<!ENTITY % d4pEnumeratorFormat           "d4pEnumeratorFormat" >
<!ENTITY % d4pEnumeratorOutputClass      "d4pEnumeratorOutputClass" >
<!ENTITY % d4pEnumeratorIncrement        "d4pEnumeratorIncrement" >
<!ENTITY % d4pEnumeratorInitialValue     "d4pEnumeratorInitialValue" >
<!ENTITY % d4pEnumeratorIncrementBy      "d4pEnumeratorIncrementBy" >
<!ENTITY % d4pEnumeratorLevel            "d4pEnumeratorLevel" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4pEnumeratorStreamDefinition.content
"
  ((%d4pEnumeratorStreamProperties;),
   (%data;)*
  )
">
<!ENTITY % d4pEnumeratorStreamDefinition.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorStreamDefinition'
  processing-role
    (resource-only)
    'resource-only'
  keys
    NMTOKENS
    #IMPLIED
">
<!ELEMENT d4pEnumeratorStreamDefinition %d4pEnumeratorStreamDefinition.content; >
<!ATTLIST d4pEnumeratorStreamDefinition %d4pEnumeratorStreamDefinition.attributes; >

<!ENTITY % d4pEnumeratorStreamProperties.content
"
  ((%d4pEnumeratorFormat;)?,
   (%d4pEnumeratorOutputClass;)?,
   (%d4pEnumeratorIncrement;)?)
">
<!ENTITY % d4pEnumeratorStreamProperties.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorStreamProperties'
">
<!ELEMENT d4pEnumeratorStreamProperties %d4pEnumeratorStreamProperties.content; >
<!ATTLIST d4pEnumeratorStreamProperties %d4pEnumeratorStreamProperties.attributes; >

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

<!ENTITY % d4pEnumeratorOutputClass.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorOutputClass.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorOutputClass'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorOutputClass %d4pEnumeratorOutputClass.content; >
<!ATTLIST d4pEnumeratorOutputClass %d4pEnumeratorOutputClass.attributes; >

<!ENTITY % d4pEnumeratorIncrement.content
"
  ((%d4pEnumeratorInitialValue;)?,
   (%d4pEnumeratorIncrementBy;)?,
   (%d4pEnumeratorLevel;)?)
">
<!ENTITY % d4pEnumeratorIncrement.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorIncrement'
  
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorIncrement %d4pEnumeratorIncrement.content; >
<!ATTLIST d4pEnumeratorIncrement %d4pEnumeratorIncrement.attributes; >

<!ENTITY % d4pEnumeratorInitialValue.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorInitialValue.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorInitialValue'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorInitialValue %d4pEnumeratorInitialValue.content; >
<!ATTLIST d4pEnumeratorInitialValue %d4pEnumeratorInitialValue.attributes; >

<!ENTITY % d4pEnumeratorIncrementBy.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorIncrementBy.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorIncrementBy'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorIncrementBy %d4pEnumeratorIncrementBy.content; >
<!ATTLIST d4pEnumeratorIncrementBy %d4pEnumeratorIncrementBy.attributes; >

<!ENTITY % d4pEnumeratorLevel.content
"
  EMPTY
">
<!ENTITY % d4pEnumeratorLevel.attributes
"
  name
    NMTOKEN
    'd4pEnumeratorLevel'
  value
    CDATA
    #REQUIRED
">
<!ELEMENT d4pEnumeratorLevel %d4pEnumeratorLevel.content; >
<!ATTLIST d4pEnumeratorLevel %d4pEnumeratorLevel.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4pEnumeratorStreamDefinition  %global-atts;  class CDATA "+ map/topicref d4p_enum-d/d4pEnumeratorStreamDefinition ">
<!ATTLIST d4pEnumeratorStreamProperties  %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorStreamProperties ">
<!ATTLIST d4pEnumeratorFormat            %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorFormat ">
<!ATTLIST d4pEnumeratorOutputClass       %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorOutputClass ">
<!ATTLIST d4pEnumeratorIncrement         %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorIncrement ">
<!ATTLIST d4pEnumeratorInitialValue      %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorInitialValue ">
<!ATTLIST d4pEnumeratorIncrementBy       %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorIncrementBy ">
<!ATTLIST d4pEnumeratorLevel             %global-atts;  class CDATA "+ topic/data d4p_enum-d/d4pEnumeratorLevel ">


<!-- ================== End D4P Enumeration Map Domain ==================== -->