<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Simple Bibliography Domain
     
     Provides a simple bibliography markup that is sufficient
     to identify bibliography entries as distinct from other 
     paragraphs but does not try to model the detailed fields
     within a bibliography entry.
     
     Copyright (c) 2012 DITA For Publishers
     
     ============================================================= -->
     

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

 <!ENTITY % d4p_simpleBiblioentry  "d4p_simpleBiblioentry" >
 <!ENTITY % d4p_simpleBiblioset  "d4p_simpleBiblioset" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- Base type for all bibliographic entries.
     Specializations can be more or less controlled
     as needed, e.g., biblioentry vs. bibliomixed 
     in DocBook.
  -->
<!ENTITY % d4p_simpleBiblioentry.content 
 "(#PCDATA |
   %d4p_simpleBiblioset; | 
   %d4p_bibitem.cnt;)*
">
<!ENTITY % d4p_simpleBiblioentry.attributes
 "
  %univ-atts;
  outputclass 
            CDATA 
                      #IMPLIED
 "
> 
<!ELEMENT d4p_simpleBiblioentry %d4p_simpleBiblioentry.content; >
<!ATTLIST d4p_simpleBiblioentry %d4p_simpleBiblioentry.attributes; >

<!ENTITY % d4p_simpleBiblioset.content 
 "(#PCDATA | 
   %d4p_bibitem.cnt;)*
">
<!ENTITY % d4p_simpleBiblioset.attributes
 "
  %univ-atts;
  outputclass 
            CDATA 
                      #IMPLIED
 "
> 
<!ELEMENT d4p_simpleBiblioset %d4p_simpleBiblioset.content; >
<!ATTLIST d4p_simpleBiblioset %d4p_simpleBiblioset.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4p_simpleBiblioentry %global-atts;  class CDATA "+ topic/p     d4p-bibbase-d/d4p_biblioentryBase d4p-simplebib-d/d4p_simpleBiblioentry ">
<!ATTLIST d4p_simpleBiblioset   %global-atts;  class CDATA "+ topic/ph    d4p-bibbase-d/d4p_bibliosetBase d4p-simplebib-d/d4p_simpleBiblioset ">


<!-- ================== End BibBase Domain ==================== -->