<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Publication Map module
     
     Map that represents a publication.
     
     This module is an example of defining a specific map type
     that uses the publication map domain elements exclusively.
     The publication map domain elements can also be used in 
     other map types as needed; there is no requirement to use
     the pubmap map element just to get publication map 
     components. This allows you to define completely different
     organizations of publication-specific topicref types.
     
     Copyright (c) 2009, 2010 DITA For Publishers

     ============================================================= -->

<!-- =============================================================
     Non-DITA Namespace declarations: 
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->




<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % pubmap      "pubmap"                                      >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % pubmap.content 
 "((%pubtitle;)?, 
   (%pubmeta;)?,
   (%keydefs;)?,
   (%topicref;)*,
   ((%mapref;) |
    ((%publication;) |
     (%publication-mapref;))|
    ((%covers;)?,
     (%colophon;)?, 
     ((%frontmatter;) |
      (%department;) |
      (%page;))*,
     ((%pubbody;) |
      (%part;) |
      (%chapter;) |
      (%sidebar;) |
      (%subsection;))?, 
     ((%appendixes;) |
      (%appendix;) |
      (%backmatter;) |
      (%page;) |
      (%department;) |
      (%colophon;))*)),
   (%data.elements.incl; |
    %reltable;)*)
 "
>
<!ENTITY % pubmap.attributes
 "title 
            CDATA 
                      #IMPLIED
  id 
            ID 
                      #IMPLIED
  %conref-atts;
  anchorref 
            CDATA 
                      #IMPLIED
  outputclass 
            CDATA 
                      #IMPLIED
  %localization-atts;
  %topicref-atts;
  %select-atts;"
>
<!ELEMENT pubmap       
  %pubmap.content;                  
>
<!ATTLIST pubmap
  %pubmap.attributes;
  %arch-atts;
  domains    
    CDATA                
    "(map mapgroup-d) (map pubmap-d) (map pubmeta-d) (map d4p_enumerationMap-d) &included-domains;"    
>



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST pubmap      %global-atts;  class CDATA "- map/map pubmap/pubmap ">

<!-- ================== End Pubmap Declaration Set  ===================== -->