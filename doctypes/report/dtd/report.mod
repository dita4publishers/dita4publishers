<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Report Map module
     
     Map that represents a report.
          
     Copyright (c) 2012 DITA For Publishers

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
 

<!ENTITY % report      "report"                                      >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % report.content 
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
<!ENTITY % report.attributes
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
<!ELEMENT report       
  %report.content;                  
>
<!ATTLIST report
  %report.attributes;
  %arch-atts;
  domains    
    CDATA                
    "(map mapgroup-d) (map pubmap-d) (map pubmeta-d) (map d4p_enumerationMap-d) &included-domains;"    
>



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST report      %global-atts;  class CDATA "- map/map report/report ">

<!-- ================== End report Declaration Set  ===================== -->