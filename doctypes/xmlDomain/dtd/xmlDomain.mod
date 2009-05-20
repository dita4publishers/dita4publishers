<!-- =============================================================

     XML construct domain
     
     Provides phrase-level elements for identifying mentions of
     XML constructs: element types, attributes, etc.
     
     Copyright (c) 2009 DITA For Publishers
     
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
<!ELEMENT xmlelem  
  (#PCDATA)*
>
<!ATTLIST xmlelem               
  %univ-atts;                                  
  outputclass 
    CDATA
    #IMPLIED    
>

<!--                    LONG NAME: XML Attribute                            -->
<!ELEMENT xmlatt  
  (#PCDATA)*
>
<!ATTLIST xmlatt
  %univ-atts;                                  
  outputclass 
    CDATA
    #IMPLIED    
>

<!--                    LONG NAME: Text entity -->
<!ELEMENT textent  
  (#PCDATA)*
>
<!ATTLIST textent
  %univ-atts;                                  
  outputclass 
    CDATA
    #IMPLIED    
>

<!--                    LONG NAME: Parameter entity -->
<!ELEMENT parment  
  (#PCDATA)*
>
<!ATTLIST parment
  %univ-atts;                                  
  outputclass 
    CDATA
    #IMPLIED    
>

<!--                    LONG NAME: Numeric character reference -->
<!ELEMENT numcharref  
  (#PCDATA)*
>
<!ATTLIST numcharref
  %univ-atts;                                  
  outputclass 
    CDATA
    #IMPLIED    
>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


  <!ATTLIST xmlelem     %global-atts;  class CDATA "+ topic/keyword xml-d/xmlelem "  >
  <!ATTLIST xmlatt      %global-atts;  class CDATA "+ topic/keyword xml-d/xmlatt "  >
  <!ATTLIST textent     %global-atts;  class CDATA "+ topic/keyword xml-d/textent "  >
  <!ATTLIST parment     %global-atts;  class CDATA "+ topic/keyword xml-d/parment "  >
  <!ATTLIST numcharref  %global-atts;  class CDATA "+ topic/keyword xml-d/numcharref "  >


<!-- ================== DITA Highlight Domain ==================== -->