<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Publication Component Map module
     
     Map that represents a component of a publication.
          
     Copyright (c) 2010 DITA For Publishers

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
 

<!ENTITY % pub-component-map      "pub-component-map"                                      >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % pub-component-map.content 
 "((%title;)?,
   (%topicmeta;)?,
   (%keydefs;)?,
   (
    (%abbrevlist;) |
    (%amendments;) |
    (%appendix;) |
    (%appendixes;) |
    (%article;) |
    (%backmatter;) |
    (%book-jacket;) |
    (%bibliolist;) |
    (%chapter;) |
    (%colophon;) | 
    (%copyright-page;) | 
    (%covers;) |
    (%dedication;) |
    (%department;) |
    (%draftintro;) |
    (%figurelist;) |
    (%forward;) |
    (%frontmatter;) |
    (%glossary;) |
    (%glossarylist;) |
    (%indexlist;) |
    (%notices;) |
    (%page;) |
    (%part;) |
    (%partsection;) |
    (%preface;) |
    (%pubabstract;) |
    (%publist;) |
    (%publists;) |
    (%pubbody;) |
    (%sidebar;) |
    (%subsection;) |
    (%tablelist;) |
    (%toc;) |
    (%topicref;) |
    (%trademarklist;)
   )?,
   (%data.elements.incl; |
    %reltable;)*)
 "
>
<!ENTITY % pub-component-map.attributes
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
<!ELEMENT pub-component-map       
  %pub-component-map.content;                  
>
<!ATTLIST pub-component-map
  %pub-component-map.attributes;
  %arch-atts;
  domains    
    CDATA                
    "(map pubmap-d) &included-domains;"    
>



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST pub-component-map      %global-atts;  class CDATA "- map/map pub-component-map/pub-component-map ">

<!-- ================== End Pub Component Map Declaration Set  ===================== -->