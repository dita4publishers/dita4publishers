<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers BibBase Domain
     
     Defines base types for bibliographic entries. These types
     are modeled as closely as possible on the DocBook biblioentry
     and bibliomixed models.
     
     This base domain is intended primarily to provide a base
     for further specialization.
     
     Specializations can specialize from <ph> to define more 
     detailed bibliographic markup.
     
     Copyright (c) 2012 DITA For Publishers
     
     ============================================================= -->
     

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

 <!ENTITY % d4p_biblioentryBase  "d4p_biblioentryBase" >
 <!ENTITY % d4p_bibliosetBase    "d4p_bibliosetBase" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4p_bibitem.cnt 
"  %cite; |
   %data; |
   %data-about; |
   %foreign; |
   %fn; |
   %image; |
   %indexterm; |
   %keyword; |
   %ph; |
   %text; |
   %tm; |
   %xref;
   "
>

<!-- Base type for all bibliographic entries.
     Specializations can be more or less controlled
     as needed, e.g., biblioentry vs. bibliomixed 
     in DocBook.
  -->
<!ENTITY % d4p_biblioentryBase.content 
 "(#PCDATA |
   %d4p_bibliosetBase; | 
   %d4p_bibitem.cnt;)*
">
<!ENTITY % d4p_biblioentryBase.attributes
 "
  %univ-atts;
  outputclass 
            CDATA 
                      #IMPLIED
 "
> 
<!ELEMENT d4p_biblioentryBase %d4p_biblioentryBase.content; >
<!ATTLIST d4p_biblioentryBase %d4p_biblioentryBase.attributes; >

<!ENTITY % d4p_bibliosetBase.content 
 "(#PCDATA | 
   %d4p_bibitem.cnt;)*
">
<!ENTITY % d4p_bibliosetBase.attributes
 "
  %univ-atts;
  outputclass 
            CDATA 
                      #IMPLIED
 "
> 
<!ELEMENT d4p_bibliosetBase %d4p_bibliosetBase.content; >
<!ATTLIST d4p_bibliosetBase %d4p_bibliosetBase.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4p_biblioentryBase %global-atts;  class CDATA "+ topic/p     d4p-bibbase-d/d4p_biblioentryBase ">
<!ATTLIST d4p_bibliosetBase   %global-atts;  class CDATA "+ topic/ph    d4p-bibbase-d/d4p_bibliosetBase ">


<!-- ================== End BibBase Domain ==================== -->