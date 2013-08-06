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

<!ENTITY % d4pExercise "d4pExercise">
<!ENTITY % d4pExerciseBody "d4pExerciseBody">
<!ENTITY % d4pInstructorNotes "d4pInstructorNotes">
<!ENTITY % d4pStudentNotes "d4pStudentNotes">

<!-- declare the structure and content models -->

<!-- declare the class derivations -->

<!ENTITY % learningContent-info-types "no-topic-nesting">
<!ENTITY included-domains    "" >

<!ENTITY % d4pExercise.content
                       "((%title;),
                         (%titlealts;)?,
                         (%shortdesc; | 
                          %abstract;)?,
                         (%prolog;)?,
                         (%d4pExerciseBody;),
                         (%related-links;)?,
                         (%d4pExercise-info-types;)* )"
>
<!ENTITY % d4pExercise.attributes
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
<!ELEMENT d4pExercise    %d4pExercise.content;>
<!ATTLIST d4pExercise
              %d4pExercise.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>


<!ENTITY % d4pExerciseBody.content
                       "(((%lcIntro;) |
                          (%lcDuration;) |
                          (%lcObjectives;))*,
                         (%section;)*,
                         (%d4pStudentNotes;)?,
                         (%d4pInstructorNotes;)?,
                         (%section;)*)  "
>
<!ENTITY % d4pExerciseBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT d4pExerciseBody    %d4pExerciseBody.content;>
<!ATTLIST d4pExerciseBody    %d4pExerciseBody.attributes;>

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

<!ATTLIST d4pExercise        %global-atts; class CDATA "- topic/topic learningBase/learningBase learningContent/learningContent d4pExercise/d4pExercise ">
<!ATTLIST d4pExerciseBody    %global-atts; class CDATA "- topic/body  learningBase/learningBasebody learningContent/learningContentbody d4pExercise/d4pExerciseBody ">
<!ATTLIST d4pStudentNotes    %global-atts; class CDATA "- topic/body  learningBase/section learningContent/section d4pExercise/d4pStudentNotes ">
<!ATTLIST d4pInstructorNotes    %global-atts; class CDATA "- topic/body  learningBase/section learningContent/section d4pExercise/d4pInstructorNotes ">
