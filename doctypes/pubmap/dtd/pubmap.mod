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
     
     Copyright (c) 2009 DITA For Publishers

     ============================================================= -->

<!-- =============================================================
     Non-DITA Namespace declarations: 
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- default namespace prefix for DITAArchVersion attribute can be
     overridden through predefinition in the document type shell   -->
<!ENTITY % DITAArchNSPrefix
  "ditaarch"
>

<!-- must be instanced on each topic type                          -->
<!ENTITY % arch-atts 
  "xmlns:%DITAArchNSPrefix; 
     CDATA
     #FIXED 'http://dita.oasis-open.org/architecture/2005/'
   %DITAArchNSPrefix;:DITAArchVersion
     CDATA
     '1.2'
"
>



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
   ((%mapref;) |
    ((%publication;) |
     (%publication-mapref;))|
    ((%covers;)?,
     (%colophon;)?, 
     ((%frontmatter;) |
      (%department;) |
      (%page;))*,
     ((%pubbody;)), 
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
    "(map pubmap-d) &included-domains;"    
>



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST pubmap      %global-atts;  class CDATA "- map/map pubmap/pubmap ">

<!-- ================== End Pubmap Declaration Set  ===================== -->