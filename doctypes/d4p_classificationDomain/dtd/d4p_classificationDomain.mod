<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Classification Domain
     
     Defines specializations of data for classifying components
     of publications (topics, figures, tables, etc.).
     
     Copyright (c) 2009, 2010 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % classification      "classification" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % classification.content
"
  ((%data;)*,
   (%keyword;)*
  )
">
<!ENTITY % classification.attributes
"
  name
    NMTOKEN
    'classification'
">
<!ELEMENT classification %classification.content; >
<!ATTLIST classification %classification.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST classification   %global-atts;  class CDATA "+ topic/data  d4p-classification-d/classification ">


<!-- ================== End Classification Domain ==================== -->