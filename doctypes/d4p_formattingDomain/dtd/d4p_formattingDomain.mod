<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Formatting Domain
     
     Defines specializations of p and ph for requesting specific
     formatting effects.
     
     Copyright (c) 2009, 2010 DITA For Publishers
     
     ============================================================= -->
     
 <!ENTITY % art           "art" >
 <!ENTITY % art_title     "art_title" >
 <!ENTITY % br            "br" >
 <!ENTITY % eqn_inline    "eqn_inline" >
 <!ENTITY % eqn_block     "eqn_block" >
 <!ENTITY % enumerator    "enumerator" >
 <!ENTITY % frac          "frac" >
 <!ENTITY % inx_snippet   "inx_snippet" >
 <!ENTITY % linethrough   "linethrough" >
 <!ENTITY % tab           "tab" >
     

<!ENTITY % MATHML.prefixed "INCLUDE">

<!ENTITY % mathml2.dtd 
  SYSTEM "../../mathml2/dtd/mathml2.dtd"
>%mathml2.dtd;

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % inx 
  SYSTEM "inx-decls.ent"
>
%inx;

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % br.content "EMPTY" >
<!ENTITY % br.attributes
 "
   %id-atts;
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
<!ELEMENT br %br.content; >
<!ATTLIST br %br.attributes; >



<!ENTITY % tab.content "EMPTY" >
<!ENTITY % tab.attributes
 "
   %id-atts;
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
<!ELEMENT tab %tab.content; >
<!ATTLIST tab %tab.attributes; >


<!ENTITY % frac.content
"
  (#PCDATA | 
   ph|
   i |
   b)*
  " 
>
<!ENTITY % frac.attributes
 "
   %id-atts;
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
<!ELEMENT frac %frac.content; >
<!ATTLIST frac %frac.attributes; >


<!ENTITY % eqn_inline.content 
"
  (%inx_snippet; |
   m:math |
   %art; |
   %data;)*
">
<!ENTITY % eqn_inline.attributes
 "
   %id-atts;
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
<!ELEMENT eqn_inline %eqn_inline.content; >
<!ATTLIST eqn_inline %eqn_inline.attributes; >

<!ENTITY % eqn_block.content
"
  (%inx_snippet; |
   m:math |
   %art; |
   %data;)*
"
>
<!ENTITY % eqn_block.attributes
 "
   %id-atts;
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
<!ELEMENT eqn_block %eqn_block.content; >
<!ATTLIST eqn_block %eqn_block.attributes; >

<!ENTITY % art.content
"
  ((%art_title;)?,
   (%image;)*,
   (%data;)*)
">
<!ENTITY % art.attributes
"
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
">
<!ELEMENT art %art.content; >
<!ATTLIST art %art.attributes; >

<!ENTITY % art_title.content
"
  (%ph.cnt;)*
">
<!ENTITY % art_title.attributes
" 
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
">
<!ELEMENT art_title %art_title.content; >
<!ATTLIST art_title %art_title.attributes; >

<!ENTITY % inx_snippet.content
"
  (%inx-components;)*
">
<!ENTITY % inx_snippet.attributes
"
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    #IMPLIED    
">
<!ELEMENT inx_snippet %inx_snippet.content; >
<!ATTLIST inx_snippet %inx_snippet.attributes; >

<!ENTITY % enumerator.content 
 "(%ph.cnt;)*"
>
<!ENTITY % enumerator.attributes 
 "
  %id-atts;
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
<!ELEMENT enumerator %enumerator.content; >
<!ATTLIST enumerator %enumerator.attributes; >

<!ENTITY % linethrough.content 
 "(%ph.cnt;)*"
>
<!ENTITY % linethrough.attributes 
 "
  %id-atts;
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
<!ELEMENT linethrough %linethrough.content; >
<!ATTLIST linethrough %linethrough.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST art              %global-atts;  class CDATA "+ topic/ph    d4p-formatting-d/art ">
<!ATTLIST art_title        %global-atts;  class CDATA "+ topic/data  d4p-formatting-d/art_title ">

<!ATTLIST br               %global-atts;  class CDATA "+ topic/ph  d4p-formatting-d/br ">
<!ATTLIST enumerator       %global-atts;  class CDATA "+ topic/data  d4p-formatting-d/enumerator ">
<!ATTLIST eqn_inline       %global-atts;  class CDATA "+ topic/ph  d4p-formatting-d/eqn_inline ">
<!ATTLIST eqn_block        %global-atts;  class CDATA "+ topic/p   d4p-formatting-d/eqn_block ">
<!ATTLIST frac             %global-atts;  class CDATA "+ topic/ph  d4p-formatting-d/frac ">
<!ATTLIST inx_snippet      %global-atts;  class CDATA "+ topic/foreign  d4p-formatting-d/inx_snippet ">
<!ATTLIST linethrough      %global-atts;  class CDATA "+ topic/ph  d4p-formatting-d/linethrough ">
<!ATTLIST tab              %global-atts;  class CDATA "+ topic/ph  d4p-formatting-d/tab ">

<!-- ================== End Formatting Domain ==================== -->