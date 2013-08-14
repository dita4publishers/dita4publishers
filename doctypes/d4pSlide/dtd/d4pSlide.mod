<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA For Publishers Slide                         -->
<!--  VERSION:   0.9.19                                            -->
<!--  DATE:      June 2013                                         -->
<!--                                                               -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!-- ============ Specialization of declared elements ============ -->

<!ENTITY % d4pSlide "d4pSlide">
<!ENTITY % d4pSlideBody "d4pSlideBody">
<!ENTITY % d4pInstructorNotes "d4pInstructorNotes">
<!ENTITY % d4pStudentNotes "d4pStudentNotes">

<!-- declare the structure and content models -->

<!-- declare the class derivations -->

<!ENTITY % learningContent-info-types "no-topic-nesting">
<!ENTITY included-domains    "" >

<!ENTITY % d4pSlide.content
                       "((%title;),
                         (%titlealts;)?,
                         (%shortdesc; | 
                          %abstract;)?,
                         (%prolog;)?,
                         (%d4pSlideBody;)?,
                         (%related-links;)?,
                         (%d4pSlide-info-types;)* )"
>
<!ENTITY % d4pSlide.attributes
             "id
                        ID 
                                  #REQUIRED
              %conref-atts;
              %select-atts;
              %localization-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT d4pSlide    %d4pSlide.content;>
<!ATTLIST d4pSlide
              %d4pSlide.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>


<!ENTITY % d4pSlideBody.content
                       "(((%lcIntro;) |
                          (%lcDuration;) |
                          (%lcObjectives;))*,
                         (%lcChallenge;)?,
                         (%lcInstruction;)?,
                         (%d4pStudentNotes;)?,
                         (%d4pInstructorNotes;)?,
                         (%section;)*)  "
>
<!ENTITY % d4pSlideBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT d4pSlideBody    %d4pSlideBody.content;>
<!ATTLIST d4pSlideBody    %d4pSlideBody.attributes;>

<!--                    LONG NAME: student notes                         -->
<!ENTITY % d4pStudentNotes.content
                       "(%section.cnt;)*"
>
<!ENTITY % d4pStudentNotes.attributes
             "spectitle 
                        CDATA 
                                  'Student Notes'
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4pStudentNotes    %d4pStudentNotes.content;>
<!ATTLIST d4pStudentNotes    %d4pStudentNotes.attributes;>

<!--                    LONG NAME: instructor notes                         -->
<!ENTITY % d4pInstructorNotes.content
                       "(%section.cnt;)*"
>
<!ENTITY % d4pInstructorNotes.attributes
             "spectitle 
                        CDATA 
                                  'Instructor Notes'
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4pInstructorNotes    %d4pInstructorNotes.content;>
<!ATTLIST d4pInstructorNotes    %d4pInstructorNotes.attributes;>


<!--specialization attributes-->

<!ATTLIST d4pSlide        %global-atts; class CDATA "- topic/topic learningBase/learningBase learningContent/learningContent d4pSlide/d4pSlide ">
<!ATTLIST d4pSlideBody    %global-atts; class CDATA "- topic/body  learningBase/learningBasebody learningContent/learningContentbody d4pSlide/d4pSlideBody ">
<!ATTLIST d4pStudentNotes    %global-atts; class CDATA "- topic/body  learningBase/section learningContent/section d4pSlide/d4pStudentNotes ">
<!ATTLIST d4pInstructorNotes    %global-atts; class CDATA "- topic/body  learningBase/section learningContent/section d4pSlide/d4pInstructorNotes ">
