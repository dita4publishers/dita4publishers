<?xml version="1.0" encoding="UTF-8"?>
<!-- =====================================================
     DITA for Publishers Training Map Domain
     
     Provides topicref types specialized from the DITA Learning
     and Training learning map domain types. These types codify
     the training organization taxonomy of course or workshop, session,
     module, and lesson.
     
     Copyright (c) 2013 DITA for Publishers
     
     ====================================================== -->
<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!-- Topicref types: -->
<!--
course |
workshop |
session |
module |
lesson"

-->

<!ENTITY % course "course" >
<!ENTITY % course-mapref "course-mapref" >
<!ENTITY % workshop "workshop" >
<!ENTITY % workshop-mapref "workshop-mapref" >
<!ENTITY % session "session" >
<!ENTITY % session-mapref "session-mapref" >
<!ENTITY % module "module" >
<!ENTITY % module-mapref "module-mapref" >
<!ENTITY % lesson "lesson" >
<!ENTITY % lesson-mapref "lesson-mapref" >
<!ENTITY % exercise "exercise" >
<!ENTITY % exercise-mapref "exercise-mapref" >
<!ENTITY % learningObjectMapref "learningObjectMapref" >




<!-- ============================================================= -->
<!--                    COMMON ATTLIST SETS                        -->
<!-- ============================================================= -->

<!-- Currently: same as topicref, sets collection-type to 'sequence' -->

<!ENTITY % training-topicref-atts 
             "collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                 'sequence'
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
               "
>



<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->




<!--                    LONG NAME: Course: Represents a complete course of study -->
<!ENTITY % course.content
 "((%topicmeta;)?,
   (%learningPlanRef;)?,
   ((%learningOverviewRef;) | 
    (%learningPreAssessmentRef;))*,
   (%session; | 
    %session-mapref;)*,
   ((%learningPostAssessmentRef;) | 
    (%learningSummaryRef;))* )"
>
<!ENTITY % course.attributes
             "%training-topicref-atts;
              %univ-atts;"
>
<!ELEMENT course    %course.content;>
<!ATTLIST course    %course.attributes;>

<!--                    LONG NAME: workshop: A multi-session training activity given over one or more days. -->
<!ENTITY % workshop.content
 "((%topicmeta;)?,
   (%learningPlanRef;)?,
   ((%learningOverviewRef;) | 
    (%learningPreAssessmentRef;))*,
   (%session; | 
    %session-mapref;)*,
   ((%learningPostAssessmentRef;) | 
    (%learningSummaryRef;))* )"
>
<!ENTITY % workshop.attributes
             "%training-topicref-atts;
              %univ-atts;"
>
<!ELEMENT workshop    %workshop.content;>
<!ATTLIST workshop    %workshop.attributes;>

<!--                    LONG NAME: session: One or more modules within a course or workshop,
                                   usually spanning one or more hours of instruction.
           -->
<!ENTITY % session.content
 "((%topicmeta;)?,
   (%learningPlanRef;)?,
   ((%learningOverviewRef;) | 
    (%learningPreAssessmentRef;))*,
   (%module; | 
    %module-mapref; |
    %exercise; |
    %exercise-mapref;)*,
   ((%learningPostAssessmentRef;) | 
    (%learningSummaryRef;))* )"
>
<!ENTITY % session.attributes
             "%training-topicref-atts;
              %univ-atts;"
>
<!ELEMENT session    %session.content;>
<!ATTLIST session    %session.attributes;>

<!--                    LONG NAME: module: One or more lessons on the same general subject. 
                                   A module typically represents about an hour of instruction.
                                   
           -->
<!ENTITY % module.content
 "((%topicmeta;)?,
   (%learningPlanRef;)?,
   ((%learningOverviewRef;) | 
    (%learningPreAssessmentRef;))*,
   (%lesson; | 
    %lesson-mapref; |
    %exercise; |
    %exercise-mapref;)*,
   ((%learningPostAssessmentRef;) | 
    (%learningSummaryRef;))* )"
>
<!ENTITY % module.attributes
             "%training-topicref-atts;
              %univ-atts;"
>
<!ELEMENT module    %module.content;>
<!ATTLIST module    %module.attributes;>

<!--                    LONG NAME: lesson: One or more learning objects focusing on a
                                   a single subject or topic. Typically represents about
                                   10 minutes of instruction.
                                   
           -->
<!ENTITY % lesson.content
 "((%topicmeta;)?,
   (%learningPlanRef;)?,
   ((%learningOverviewRef;) | 
    (%learningPreAssessmentRef;))*,
   (%learningObject; |
    %learningObjectMapref; |
    %exercise; |
    %exercise-mapref;)*,
   ((%learningPostAssessmentRef;) | 
    (%learningSummaryRef;))* )"
>
<!ENTITY % lesson.attributes
             "%training-topicref-atts;
              %univ-atts;"
>
<!ELEMENT lesson    %lesson.content;>
<!ATTLIST lesson    %lesson.attributes;>

<!ENTITY % exercise.content
                       "((%topicmeta;)?,
                         (%learningContentRef;)*
                         )"
>
<!ENTITY % exercise.attributes
             "%learningDomain-topicref-atts;
              collection-type
                        (choice|
                         unordered|
                         sequence|
                         family | 
                         -dita-use-conref-target)
                                   #IMPLIED
              type
                        CDATA
                                  #IMPLIED
              format
                        CDATA
                                  #IMPLIED
">
<!ELEMENT exercise    %exercise.content;>
<!ATTLIST exercise    %exercise.attributes;>


<!-- ============================================
     Map reference specializations
     ============================================-->

<!ENTITY % mapref-atts
 'navtitle 
             CDATA 
                       #IMPLIED
  href 
             CDATA 
                       #IMPLIED
  keyref 
             CDATA 
                       #IMPLIED
              
  keys 
             CDATA 
                       #IMPLIED
  format
             CDATA
                       "ditamap"
  %univ-atts; 
'
 >
 
 <!ENTITY % mapref.cnt
  "((%topicmeta;)?, 
   (%data.elements.incl;)* )
  "
>

<!--  Course map reference -->
<!ENTITY % course-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % course-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT course-mapref    %course-mapref.content;>
<!ATTLIST course-mapref    %course-mapref.attributes;>

<!--  Workshop map reference -->
<!ENTITY % workshop-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % workshop-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT workshop-mapref    %workshop-mapref.content;>
<!ATTLIST workshop-mapref    %workshop-mapref.attributes;>

<!--  Session map reference -->
<!ENTITY % session-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % session-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT session-mapref    %session-mapref.content;>
<!ATTLIST session-mapref    %session-mapref.attributes;>

<!--  Module map reference -->
<!ENTITY % module-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % module-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT module-mapref    %module-mapref.content;>
<!ATTLIST module-mapref    %module-mapref.attributes;>

<!--  Lession map reference -->
<!ENTITY % lesson-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % lesson-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT lesson-mapref    %lesson-mapref.content;>
<!ATTLIST lesson-mapref    %lesson-mapref.attributes;>

<!ENTITY % exercise-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % exercise-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT exercise-mapref    %exercise-mapref.content;>
<!ATTLIST exercise-mapref    %exercise-mapref.attributes;>

<!--  Learning object map reference 

      NOTE: In DITA 1.3, the L&T learning map domain
      provides this element type

-->
<!ENTITY % learningObjectMapref.content
 "%mapref.cnt;"
>
<!ENTITY % learningObjectMapref.attributes
 "%mapref-atts;"
>
<!ELEMENT learningObjectMapref    %learningObjectMapref.content;>
<!ATTLIST learningObjectMapref    %learningObjectMapref.attributes;>



 
<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
<!-- Topicref types: -->
<!ATTLIST course                 %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/course ">
<!ATTLIST course-mapref          %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/course-mapref ">
<!ATTLIST workshop               %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/workshop ">
<!ATTLIST workshop-mapref        %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/workshop-mapref ">
<!ATTLIST session                %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/session ">
<!ATTLIST session-mapref         %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/session-mapref ">
<!ATTLIST module                 %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/module ">
<!ATTLIST module-mapref          %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/module-mapref ">
<!ATTLIST lesson-mapref          %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/lesson-mapref ">
<!ATTLIST lesson                 %global-atts; class CDATA "+ map/topicref learningmap-d/learningGroup trainingmap-d/lesson ">
<!ATTLIST exercise-mapref        %global-atts; class CDATA "+ map/topicref learningmap-d/learningObject trainingmap-d/exercise-mapref ">
<!ATTLIST exercise               %global-atts; class CDATA "+ map/topicref learningmap-d/learningObject trainingmap-d/exercise ">
<!ATTLIST learningObjectMapref   %global-atts; class CDATA "+ map/topicref learningmap-d/learningObject trainingmap-d/learningObjectMapref ">


<!-- ================== End training map domain ============================= -->