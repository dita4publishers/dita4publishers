<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Media Domain
     
     Defines specializations for the inclusion of interactive media
     (media other than graphics) into publications.
     
     Copyright (c) 2012, 2013 DITA For Publishers
     
     ============================================================= -->
     
<!ENTITY % d4p_video "d4p_video" >    
<!ENTITY % d4p_video_poster "d4p_video_poster" >
<!-- NOTE: Maintaining the video_source and video_tracks elements for
           backward compatibility.
  -->
<!ENTITY % d4p_video_source "d4p_video_source" >
<!ENTITY % d4p_video_tracks "d4p_video_tracks" >

<!ENTITY % d4p_media_source "d4p_media_source" >
<!ENTITY % d4p_media_tracks "d4p_media_tracks" >

<!ENTITY % d4p_audio "d4p_audio" >    


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4p_video.content
                       "((%desc;)?,
                         (%longdescref;)?,
                         (%d4p_video_poster;)?,
                         (%param; |
                          %d4p_video_source; |
                          %d4p_media_source;)*,
                         (%d4p_video_tracks; |
                          %d4p_media_tracks;)?,
                         (%foreign.unknown.incl;)*)"
>
<!ENTITY % d4p_video.attributes
             "height 
                        NMTOKEN 
                                  #IMPLIED
              width 
                        NMTOKEN 
                                  #IMPLIED
              name 
                        CDATA 
                                  #IMPLIED
              longdescref
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED 
              longdescre CDATA    #IMPLIED"
>
<!ELEMENT d4p_video    %d4p_video.content;>
<!ATTLIST d4p_video    %d4p_video.attributes;>

<!ENTITY % d4p_audio.content
                       "((%desc;)?,
                         (%longdescref;)?,
                         (%d4p_video_poster;)?,
                         (%param; |
                          %d4p_media_source;)*,
                         (%d4p_media_tracks;)?,
                         (%foreign.unknown.incl;)*)"
>
<!ENTITY % d4p_audio.attributes
             "height 
                        NMTOKEN 
                                  #IMPLIED
              width 
                        NMTOKEN 
                                  #IMPLIED
              name 
                        CDATA 
                                  #IMPLIED
              longdescref
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED 
              longdescre CDATA    #IMPLIED"
>
<!ELEMENT d4p_audio    %d4p_audio.content;>
<!ATTLIST d4p_audio    %d4p_audio.attributes;>

<!ENTITY % d4p_video_source.content
                       "EMPTY"
>
<!ENTITY % d4p_video_source.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  'source'
              value 
                        CDATA 
                                  #IMPLIED
              valuetype
                        (ref) 
                                  'ref'
              type 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4p_video_source    %d4p_video_source.content;>
<!ATTLIST d4p_video_source    %d4p_video_source.attributes;>


<!ENTITY % d4p_media_source.content
                       "EMPTY"
>
<!ENTITY % d4p_media_source.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  'source'
              value 
                        CDATA 
                                  #IMPLIED
              valuetype
                        (ref) 
                                  'ref'
              type 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4p_media_source    %d4p_media_source.content;>
<!ATTLIST d4p_media_source    %d4p_media_source.attributes;>

<!ENTITY % d4p_video_poster.content
                       "EMPTY"
>
<!ENTITY % d4p_video_poster.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  'poster'
              value 
                        CDATA 
                                  #IMPLIED
              valuetype
                        (ref) 
                                  'ref'
              type 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4p_video_poster    %d4p_video_poster.content;>
<!ATTLIST d4p_video_poster    %d4p_video_poster.attributes;>

<!ENTITY % d4p_video_tracks.content
                       "(track)*"
>
<!ENTITY % d4p_video_tracks.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  'poster'
              value 
                        CDATA 
                                  #IMPLIED
              valuetype
                        (ref | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4p_video_tracks    %d4p_video_tracks.content;>
<!ATTLIST d4p_video_tracks    %d4p_video_tracks.attributes;>

<!ENTITY % d4p_media_tracks.content
                       "(track)*"
>
<!ENTITY % d4p_media_tracks.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  'poster'
              value 
                        CDATA 
                                  #IMPLIED
              valuetype
                        (ref | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT d4p_media_tracks    %d4p_media_tracks.content;>
<!ATTLIST d4p_media_tracks    %d4p_media_tracks.attributes;>

<!-- NOTE: this is the track element from HTML without modification. -->
<!ELEMENT track        
  EMPTY
>
<!ATTLIST track
  src 
     CDATA        
        #REQUIRED
  kind    
     (subtitles | 
      captions | 
      descriptions | 
      chapters | 
      metadata)    
        #REQUIRED
  srclang    
      CDATA             
        #IMPLIED
  label    
      CDATA        
        #REQUIRED
  default    
      (default)    
        #IMPLIED
>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4p_video         %global-atts;  class CDATA "+ topic/object   d4p-media-d/d4p_video ">
<!ATTLIST d4p_audio         %global-atts;  class CDATA "+ topic/object   d4p-media-d/d4p_audio ">
<!ATTLIST d4p_video_poster  %global-atts;  class CDATA "+ topic/param    d4p-media-d/d4p_video_poster ">
<!ATTLIST d4p_video_source  %global-atts;  class CDATA "+ topic/param    d4p-media-d/d4p_video_source ">
<!ATTLIST d4p_video_tracks  %global-atts;  class CDATA "+ topic/foreign  d4p-media-d/d4p_video_tracks ">
<!ATTLIST d4p_media_source  %global-atts;  class CDATA "+ topic/param    d4p-media-d/d4p_media_source ">
<!ATTLIST d4p_media_tracks  %global-atts;  class CDATA "+ topic/foreign  d4p-media-d/d4p_media_tracks ">


<!-- ================== End Media Domain ==================== -->