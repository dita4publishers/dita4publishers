<!-- =============================================================

     XML construct domain
     
     Provides phrase-level elements for identifying mentions of
     XML constructs: element types, attributes, etc.
     
     Copyright (c) 2009, 2010 DITA For Publishers
     
     This domain module may be used by anyone without restriction.
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % xmlelem           
  "xmlelem"                                           
>
<!ENTITY % xmlatt      
  "xmlatt"
>
<!ENTITY % textent           
  "textent"                                           
>     
<!ENTITY % parment          
  "parment"                                          
>
<!ENTITY % numcharref
  "numcharref"
>   

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: XML Element                            -->
<!ENTITY % xmlelem.content
"
  (#PCDATA |
   %keyword; |
   %text;)*
">
<!ENTITY % xmlelem.attributes
"
  %univ-atts;                                  
  keyref
    CDATA
    #IMPLIED                                 
  outputclass 
    CDATA
    #IMPLIED    
">
<!ELEMENT xmlelem %xmlelem.content; >
<!ATTLIST xmlelem %xmlelem.attributes; >

<!--                    LONG NAME: XML Attribute                            -->
<!ENTITY % xmlatt.content
"
  (#PCDATA |
   %keyword; |
   %text;)*
">
<!ENTITY % xmlatt.attributes
"
  %univ-atts;                                  
  keyref
    CDATA
    #IMPLIED                                 
  outputclass 
    CDATA
    #IMPLIED    
">
<!ELEMENT xmlatt %xmlatt.content; >
<!ATTLIST xmlatt %xmlatt.attributes; >

<!--                    LONG NAME: Text entity -->
<!ENTITY % textent.content
"
  (#PCDATA |
   %keyword; |
   %text;)*
">
<!ENTITY % textent.attributes
"
  %univ-atts;                                  
  keyref
    CDATA
    #IMPLIED                                 
  outputclass 
    CDATA
    #IMPLIED    
">
<!ELEMENT textent %textent.content; >
<!ATTLIST textent %textent.attributes; >

<!--                    LONG NAME: Parameter entity -->
<!ENTITY % parment.content
"
  (#PCDATA |
   %keyword; |
   %text;)*
">
<!ENTITY % parment.attributes
"
  %univ-atts;                                  
  keyref
    CDATA
    #IMPLIED                                 
  outputclass 
    CDATA
    #IMPLIED    
">
<!ELEMENT parment %parment.content; >
<!ATTLIST parment %parment.attributes; >

<!--                    LONG NAME: Numeric character reference -->
<!ENTITY % numcharref.content
"
  (#PCDATA |
   %keyword; |
   %text;)*
">
<!ENTITY % numcharref.attributes
"
  %univ-atts;                                  
  keyref
    CDATA
    #IMPLIED                                 
  outputclass 
    CDATA
    #IMPLIED    
">
<!ELEMENT numcharref %numcharref.content; >
<!ATTLIST numcharref %numcharref.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


  <!ATTLIST xmlelem     %global-atts;  class CDATA "+ topic/keyword xml-d/xmlelem "  >
  <!ATTLIST xmlatt      %global-atts;  class CDATA "+ topic/keyword xml-d/xmlatt "  >
  <!ATTLIST textent     %global-atts;  class CDATA "+ topic/keyword xml-d/textent "  >
  <!ATTLIST parment     %global-atts;  class CDATA "+ topic/keyword xml-d/parment "  >
  <!ATTLIST numcharref  %global-atts;  class CDATA "+ topic/keyword xml-d/numcharref "  >


<!-- ================== DITA Highlight Domain ==================== -->