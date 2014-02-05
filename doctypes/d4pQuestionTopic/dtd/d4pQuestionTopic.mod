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

<!ENTITY % d4pQuestionTopic "d4pQuestionTopic">
<!ENTITY % d4pQuestionTopicBody "d4pQuestionTopicBody">
<!ENTITY % d4pQuestionTopicTitle "d4pQuestionTopicTitle">


<!ENTITY % learningContent-info-types "no-topic-nesting">
<!ENTITY included-domains    "" >

<!ENTITY % d4pQuestionTopic.content
                       "((%d4pQuestionTopicTitle;),
                         (%titlealts;)?,
                         (%prolog;)?,
                         (%d4pQuestionTopicBody;),
                         (%related-links;)?,
                         (%d4pQuestionTopic-info-types;)* )"
>
<!ENTITY % d4pQuestionTopic.attributes
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
<!ELEMENT d4pQuestionTopic    %d4pQuestionTopic.content;>
<!ATTLIST d4pQuestionTopic
              %d4pQuestionTopic.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>


<!ENTITY % d4pQuestionTopicBody.content
                       "(%lcInteractionBase; | 
                         %lcInteractionBase2;)+
                       "
>
<!ENTITY % d4pQuestionTopicBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT d4pQuestionTopicBody    %d4pQuestionTopicBody.content;>
<!ATTLIST d4pQuestionTopicBody    %d4pQuestionTopicBody.attributes;>

<!--                    LONG NAME: Question Topic Title                         -->
<!ENTITY % d4pQuestionTopicTitle.content
                       "(%title.cnt;)*"
>
<!ENTITY % d4pQuestionTopicTitle.attributes
             "%univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4pQuestionTopicTitle    %d4pQuestionTopicTitle.content;>
<!ATTLIST d4pQuestionTopicTitle    %d4pQuestionTopicTitle.attributes;>

<!--specialization attributes-->

<!ATTLIST d4pQuestionTopic              %global-atts; class CDATA "- topic/topic d4pQuestionTopic/d4pQuestionTopic ">
<!ATTLIST d4pQuestionTopicTitle         %global-atts; class CDATA "- topic/title d4pQuestionTopic/d4pQuestionTopicTitle ">
<!ATTLIST d4pQuestionTopicBody          %global-atts; class CDATA "- topic/body  d4pQuestionTopic/d4pQuestionTopicBody ">

<!-- End of d4pQuestionTopic module -->