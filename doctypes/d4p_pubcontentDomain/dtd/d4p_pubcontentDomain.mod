<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Content Domain
     
     Specializations of topic content elements that provide common
     publication components that are semantic and not strictly
     formatting.
     
     Copyright (c) 2009 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % epigram "epigram" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- Epigram: Quote used to introduce a chapter or section. -->
<!ENTITY % epigram.content
 "(%para.cnt;)*"
>
<!ENTITY % epigram.attributes
 '
 '
>
<!ELEMENT epigram %epigram.content; >
<!ATTLIST epigram %epigram.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST epigram              %global-atts;  class CDATA "+ topic/p    d4p-pubcontent-d/epigram ">

<!-- ================== End Formatting Domain ==================== -->