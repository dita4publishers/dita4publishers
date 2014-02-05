<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Textbook Domain
     
     Defines specializations often needed in textbooks.
     
     Copyright (c) 2012 DITA For Publishers
     
     ============================================================= -->
     

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

 <!ENTITY % d4p_display-map  "d4p_display-map" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- Specialization of figure for containing maps. Allows separate
     numbering and labeling of maps.
  -->
<!ENTITY % d4p_display-map.content 
 "((%title;)?, 
   (%desc;)?, 
   (%figgroup; | 
    %fig.cnt;)* )
">
<!ENTITY % d4p_display-map.attributes
 "
 %display-atts;
  spectitle 
            CDATA 
                      #IMPLIED
  %univ-atts;
  outputclass 
            CDATA 
                      #IMPLIED
 "
> 
<!ELEMENT d4p_display-map %d4p_display-map.content; >
<!ATTLIST d4p_display-map %d4p_display-map.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4p_display-map %global-atts;  class CDATA "+ topic/fig     d4p-math-d/d4p_display-map ">


<!-- ================== End Textbook Domain ==================== -->