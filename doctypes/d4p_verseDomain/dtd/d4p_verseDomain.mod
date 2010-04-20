<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Verse Domain
     
     Defines specializations for the representation of verse.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % verse "verse" >
<!ENTITY % stanza "stanza" >
<!ENTITY % verse-line "verse-line" >

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % verse.content 
 "((%verse-line; | 
    %stanza; |
    %data; |
    %data-about;)+)
 "
>
<!ENTITY % verse.attributes
" %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
">
<!ELEMENT verse
  %verse.content;
>
<!ATTLIST verse
  %verse.attributes;
>

<!ENTITY % stanza.content 
 "  (%ph.cnt; | 
     %verse-line;)*
 "
>
<!ENTITY % stanza.attributes
"%id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
"
>
<!ELEMENT stanza
  %stanza.content;
>
<!ATTLIST stanza         
  %stanza.attributes;
>

<!ENTITY % verse-line.content 
 "  (%ph.cnt; |
     %verse-line;)*
 "
>
<!ENTITY % verse-line.attributes
"%id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
"
>
<!ELEMENT verse-line
  %stanza.content;
>
<!ATTLIST verse-line         
  %stanza.attributes;
>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST verse              %global-atts;  class CDATA "+ topic/lines    d4p-verse-d/verse ">
<!ATTLIST stanza             %global-atts;  class CDATA "+ topic/ph       d4p-verse-d/stanza ">
<!ATTLIST verse-line         %global-atts;  class CDATA "+ topic/ph       d4p-verse-d/verse-line ">

<!-- ================== End Formatting Domain ==================== -->