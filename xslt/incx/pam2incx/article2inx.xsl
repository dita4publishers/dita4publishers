<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
  xmlns:local="http://www.reallysi.com/functions/local"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xmp-x="adobe:ns:meta/"
  exclude-result-prefixes="RSUITE xs idsc local ditaarch saxon xmp-x"
  extension-element-prefixes="saxon">

  <!-- 
      Transform to create InCopy articles (.incx) files from BW-articles
      
      Copyright (c) 2008 Really Strategies, Inc. All rights reserved.
  
  -->
  
  <xsl:output indent="no" 
    cdata-section-elements="GrPr" />
  
  <xsl:output name="xmp-out" cdata-section-elements="xmp-x:xmpmeta" method="xml" omit-xml-declaration="yes" indent="yes"/>
  
  <xsl:strip-space elements="*"/>
  
<!--
  <xsl:variable name="styleCatalog" select="document('resources/trl_style_catalog.xml')" as="document-node()"/>
-->
  
  <!-- Inline style catalog so don't have to worry about reading external resource -->
  <xsl:variable name="styleCatalog">
  <idsc:InDesign_Style_Catalog xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog">
   <idsc:ParagraphStyles>
      <idsc:pStyle base="" name="[No paragraph style]" pnam="k_[No paragraph style]" smpt="b_f"
		   flcl="o_ub"
		   ptfs="c_Regular"
		   ptsz="U_12"
		   phzs="D_100"
		   pakm="k_Metrics"
		   ligt="b_t"
		   lnwt="U_1"
		   trak="D_0"
		   ptce="c_HL Composer"
		   dcca="s_0"
		   dcli="s_0"
		   bshf="U_0"
		   capm="e_norm"
		   lncl="o_ue"
		   hypl="s_3"
		   pvts="D_100"
		   inbl="U_0"
		   inbr="U_0"
		   infl="U_0"
		   alea="D_120"
		   szld="e_atil"
		   plng="k_English: USA"
		   hyph="b_t"
		   mibe="s_2"
		   miaf="s_2"
		   hypc="b_t"
		   swor="s_5"
		   nobk="b_f"
		   hyzo="U_36"
		   spbe="U_0"
		   spaf="U_0"
		   alts="x_0"
		   undr="b_f"
		   font="c_Times"
		   Ofst="e_Dflt"
		   wsde="D_100"
		   wsma="D_133"
		   wsmi="D_80"
		   lsde="D_0"
		   lsma="D_0"
		   lsmi="D_0"
		   gsde="D_100"
		   gsma="D_100"
		   gsmi="D_100"
		   pbbp="e_nbrk"
		   kept="b_f"
		   kwnx="s_0"
		   kfnl="s_2"
		   klnl="s_2"
		   posm="e_norm"
		   strk="b_f"
		   jcal="e_Jact"
		   kepl="b_f"
		   lint="D_-1"
		   filt="D_-1"
		   sovp="b_f"
		   ovpr="b_f"
		   pgsa="D_0"
		   pgfa="D_0"
		   pgsl="D_-1"
		   pgfl="D_-1"
		   pgss="x_2_U_0_U_0"
		   pgst="x_2_U_0_U_0"
		   pskw="D_0"
		   rlac="k_Text Color"
		   pras="D_1"
		   prat="D_-1"
		   paof="U_0"
		   pral="U_0"
		   pair="U_0"
		   rawd="e_Klwd"
		   rlbc="k_Text Color"
		   prbs="D_1"
		   prbt="D_-1"
		   pbop="U_0"
		   prbl="U_0"
		   pbir="U_0"
		   rbwd="e_Klwd"
		   prao="b_f"
		   prbo="b_f"
		   prb2="b_f"
		   prar="b_f"
		   prbr="b_f"
		   inlr="U_0"
		   hylw="b_t"
		   pals="e_full"
		   OTor="b_f"
		   OTfr="b_f"
		   OTdl="b_f"
		   OTti="b_f"
		   patp="o_di5a29"
		   pbtp="o_di5a29"
		   bala="e_BlOf"
		   alrs="x_0"
		   ragc="o_ue"
		   ragt="D_-1"
		   rago="b_f"
		   rbgc="o_ue"
		   rbgt="D_-1"
		   rbgo="b_f"
		   rbg2="b_f"
		   paln="e_left"
		   dcdm="l_0"
		   OTPf="e_none"
		   OTmk="b_t"
		   hypw="s_5"
		   OTlc="b_t"
		   hycf="b_t"
		   prak="b_f"
		   igEA="b_f"
		   OTzr="b_f"
		   OTss="l_0"
		   OThi="b_f"
		   OTca="b_t"
		   ulco="k_Text Color"
		   ulgc="o_ue"
		   upgo="b_f"
		   ulgt="D_-1"
		   ulos="U_-9999"
		   ulop="b_f"
		   ultt="D_-1"
		   ulwt="U_-9999"
		   ultp="o_di5a29"
		   stco="k_Text Color"
		   stgc="o_ue"
		   stgo="b_f"
		   stgt="D_-1"
		   stos="U_-9999"
		   Stvp="b_f"
		   sttt="D_-1"
		   sttp="o_di5a29"
		   stwt="U_-9999"
		   OTsw="b_f"
		   tsum="D_0"
		   jmoj="e_nada"
		   jmbs="D_-1"
		   jmas="D_-1"
		   jkin="e_nada"
		   jkit="e_Jkif"
		   jkht="e_none"
		   jbki="b_t"
		   jpro="b_t"
		   jrfs="D_-1"
		   jral="e_Jrjs"
		   jrtp="e_Jrpc"
		   jrfn="k_"
		   jrft="e_nada"
		   jrsp="e_Jr12"
		   jrwd="D_100"
		   jrpt="D_100"
		   jrxo="D_0"
		   jryo="D_0"
		   jrpz="e_Jkar"
		   jraa="b_t"
		   jrva="e_Jro1"
		   jrov="b_f"
		   jras="b_f"
		   jrsc="D_66"
		   jrfl="k_Text Color"
		   jrti="D_-1"
		   jrof="e_atil"
		   jrsk="k_Text Color"
		   jrst="D_-1"
		   jros="e_atil"
		   jrwt="D_-1"
		   jktp="e_none"
		   jkfz="D_-1"
		   jkfn="k_"
		   jkfs="e_nada"
		   jkcm="D_100"
		   jkpt="D_100"
		   jkpl="D_0"
		   jkal="e_Jknc"
		   jkp2="e_Jkar"
		   jkcc="k_"
		   jset="e_Jchi"
		   jkfc="k_Text Color"
		   jktn="D_-1"
		   jkof="e_atil"
		   jksc="k_Text Color"
		   jkst="D_-1"
		   jkos="e_atil"
		   jkwt="D_-1"
		   jtcy="b_f"
		   jtax="D_0"
		   jtay="D_0"
		   jatc="s_0"
		   jatr="b_f"
		   jjid="s_0"
		   jggy="s_0"
		   jga1="b_f"
		   jgal="e_none"
		   crot="D_0"
		   jro1="b_f"
		   jren="b_t"
		   jshp="D_0"
		   jsha="D_4500"
		   jsht="b_t"
		   jshr="b_f"
		   jwar="b_f"
		   jwli="s_2"
		   jwas="D_50"
		   jwls="D_0"
		   jwal="e_atil"
		   jmbb="s_2"
		   jmab="s_2"
		   hkna="b_f"
		   palt="b_f"
		   ital="b_f"
		   Jled="e_Jlab"
		   jslh="b_f"
		   jpgd="b_f"
		   jgrt="b_f"
		   jgfm="e_none"
		   jrtd="s_0"
		   jrtr="b_f"
		   jrts="b_t"
		   bnlt="e_LTno"
		   bncl="c_Text Color"
		   bnbc="x_2_e_BCuo_l_2022"
		   bnst="l_1"
		   bnsa="l_1"
		   DHnm="k_1, 2, 3, 4..."
		   bnns="k_1, 2, 3, 4..."
		   blfn="k_"
		   blft="e_nada"
		   nmfn="k_"
		   bnnl="o_u3d"
		   bnle="l_1"
		   bncp="b_t"
		   bnar="b_t"
		   bnbr="x_3_e_enap_l_0_l_0"
		   bnbs="o_u68"
		   bnnc="o_u68"
		   bnba="e_left"
		   bnna="e_left"
		   bnne="c_^#.^t"
		   bnta="c_^t"/>
      <idsc:pStyle base="[No paragraph style]" name="NormalParagraphStyle"
		   basd="k_[No paragraph style]"
		   pnam="k_NormalParagraphStyle"
		   smpt="b_f"
		   nxpa="o_u6b"
		   kbsc="x_2_s_0_s_0"/>
      <idsc:pStyle base="[No paragraph style]" name="Text-byline~sep~crea"
		   basd="k_[No paragraph style]"
		   pnam="c_Text-byline~sep~crea"
		   smpt="b_f"
		   nxpa="o_uce"
		   kbsc="x_2_s_0_s_0"
		   ptfs="c_Medium"
		   ptsz="U_7.625"
		   pakm="k_Optical"
		   alea="D_100"
		   szld="U_9.5"
		   hyph="b_f"
		   font="c_Adobe Garamond Pro"
		   wsde="D_90"
		   wsma="D_100"
		   jga1="b_t"
		   jgal="e_Jabl"/>
      <idsc:pStyle base="[No paragraph style]" name="Text-ragged-XI~sep~body"
		   basd="k_[No paragraph style]"
		   pnam="c_Text-ragged-XI~sep~body"
		   smpt="b_f"
		   nxpa="o_ud2"
		   kbsc="x_2_s_0_s_0"
		   ptsz="U_9"
		   hypl="s_2"
		   szld="U_11"
		   font="Garamond"
		   wsde="D_90"
		   wsma="D_100"
		   hylw="b_f"
		   jgal="e_Jabl"/>
      <idsc:pStyle base="[No paragraph style]" name="Text-ragged~sep~body"
		   basd="k_[No paragraph style]"
		   pnam="c_Text-ragged~sep~body"
		   smpt="b_f"
		   nxpa="o_ud2"
		   kbsc="x_2_s_0_s_0"
		   ptsz="U_9"
		   hypl="s_2"
		   infl="U_9"
		   szld="U_11"
		   font="Garamond"
		   wsde="D_90"
		   wsma="D_100"
		   hylw="b_f"
		   jgal="e_Jabl"/>
   </idsc:ParagraphStyles>
   <idsc:CharacterStyles>
      <idsc:cStyle base="" name="[No character style]" pnam="k_[No character style]" smpt="b_f"/>
      <idsc:cStyle base="" name="Text-ital~sep~body"
		   basd="k_[No character style]"
		   pnam="c_Text-ital~sep~body"
		   smpt="b_f"
		   kbsc="x_2_s_0_s_0"
		   ptfs="c_Italic"/>
      <idsc:cStyle base="" name="BW~sep~Endslug"
		   basd="k_[No character style]"
		   pnam="c_BW~sep~Endslug"
		   smpt="b_f"
		   kbsc="x_2_s_0_s_0"
		   flcl="o_ucb"
		   ligt="b_f"
		   OTca="b_f"/>
   </idsc:CharacterStyles>
   <idsc:Table_Styles>
      <idsc:tStyle base="" name="[No table style]" pthr="rl_0" ptfr="rl_0"
                   pnam="k_[No table style]"
                   HdSk="b_f"
                   FtSk="b_f"
                   CFfc="l_0"
                   CFsc="l_0"
                   CFof="b_f"
                   CFtf="D_20"
                   CFcf="o_u68"
                   CFcs="o_u6b"
                   CFts="D_100"
                   CFos="b_f"
                   TBsw="U_1"
                   TBss="o_di5a29"
                   TBsc="o_u68"
                   TBst="D_100"
                   TBso="b_f"
                   LBsw="U_1"
                   LBss="o_di5a29"
                   LBsc="o_u68"
                   LBst="D_100"
                   LBso="b_f"
                   BBsw="U_1"
                   BBss="o_di5a29"
                   BBsc="o_u68"
                   BBst="D_100"
                   BBso="b_f"
                   RBsw="U_1"
                   RBss="o_di5a29"
                   RBsc="o_u68"
                   RBst="D_100"
                   RBso="b_f"
                   RFcf="o_u68"
                   RFfc="l_0"
                   RFtf="D_20"
                   RFof="b_f"
                   RFsc="l_0"
                   RFcs="o_u6b"
                   RFts="D_100"
                   RFos="b_f"
                   TBgc="o_u6c"
                   TBgt="D_100"
                   TBgo="b_f"
                   LBgc="o_u6c"
                   LBgt="D_100"
                   LBgo="b_f"
                   BBgc="o_u6c"
                   BBgt="D_100"
                   BBgo="b_f"
                   RBac="o_u6c"
                   RBat="D_100"
                   RBao="b_f"
                   spbe="U_4"
                   spaf="U_-4"
                   CFPr="b_f"
                   tsdo="e_sbej"
                   CSfc="l_0"
                   CScf="o_u68"
                   CSwf="U_1"
                   CSsf="o_di5a29"
                   CStf="D_100"
                   CSof="b_f"
                   CSsc="l_0"
                   CScs="o_u68"
                   CSws="U_0.25"
                   CSss="o_di5a29"
                   CSts="D_100"
                   CSos="b_f"
                   CSgc="o_u6c"
                   CSgt="D_100"
                   CSgo="b_f"
                   CSgs="o_u6c"
                   CSas="D_100"
                   CSps="b_f"
                   RSfc="l_0"
                   RScf="o_u68"
                   RSwf="U_1"
                   RStf="D_100"
                   RSof="b_f"
                   RSsc="l_0"
                   RScs="o_u68"
                   RSws="U_0.25"
                   RSss="o_di5a29"
                   RSts="D_100"
                   RSos="b_f"
                   RSgc="o_u6c"
                   RSgt="D_100"
                   RSgo="b_f"
                   RSgs="o_u6c"
                   RSas="D_100"
                   RSps="b_f"
                   HdBt="e_IaTc"
                   FtBt="e_IaTc"
                   Sfsr="l_0"
                   Slsr="l_0"
                   Sfsc="l_0"
                   Slsc="l_0"
                   Sffr="l_0"
                   Slfr="l_0"
                   Sffc="l_0"
                   Slfc="l_0"
                   RSsf="o_di5a29"
                   Mnht="U_3"
                   Mxht="U_600"
                   Kwnr="b_f"
                   Strw="e_nbrk"
                   AuGw="b_t"
                   MFHo="U_3"
                   klwd="U_1"
                   NstT="U_4"
                   NstL="U_4"
                   NstB="U_4"
                   NstR="U_4"
                   flcl="o_u6b"
                   filt="D_100"
                   ovpr="b_f"
                   DLTl="b_f"
                   DLTr="b_f"
                   DLib="b_f"
                   DLsw="U_1"
                   DLsy="o_di5a29"
                   DLsc="o_u68"
                   DLst="D_100"
                   DLso="b_f"
                   DLgc="o_u6b"
                   DLgt="D_100"
                   DLgo="b_f"
                   ClcC="b_f"
                   Fbof="e_MAso"
                   VJal="e_top"
                   PSsl="U_0"
                   Fboa="U_0"
                   kang="D_0"
                   Rfst="b_t"
                   BrHd="b_t"
                   BrFt="b_t"
                   BrLc="b_t"
                   BrRc="b_t"
                   RsHd="o_n"
                   RsFt="o_n"
                   RsLc="o_n"
                   RsRc="o_n"
                   RsBr="o_ud2"/>
      <idsc:tStyle base="[No table style]" name="[Basic Table]" pthr="rl_0" ptfr="rl_0"
                   pnam="k_[Basic Table]"
                   basd="k_[No table style]"
                   kbsc="x_2_s_0_s_0"/>
   </idsc:Table_Styles>
   <idsc:Object_Styles>
      <idsc:objStyle base="" name="[None]" pnam="k_[None]" prst="o_uc4" dtos="o_ue0" dfos="o_udf"
                     dffg="o_ue1"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     pcOp="e_none"/>
      <idsc:objStyle base="[None]" name="[Normal Graphics Frame]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Graphics Frame]"
                     prst="o_uc4"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_f"
                     obbc="b_f"
                     oboc="b_f"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_1"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u68"
                     lint="D_-1"
                     pcrd="D_12"
                     sovp="b_f"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
      <idsc:objStyle base="[None]" name="[Normal Text Frame]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Text Frame]"
                     prst="o_uc8"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_t"
                     obbc="b_t"
                     oboc="b_f"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
      <idsc:objStyle base="[None]" name="[Normal Grid]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Grid]"
                     prst="o_uc8"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_t"
                     obbc="b_t"
                     oboc="b_t"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
    </idsc:Object_Styles>
  </idsc:InDesign_Style_Catalog>
  </xsl:variable>

  <!-- Output Valid XMP data -->
  <xsl:template match="bw-article" mode="XMP">
  <xsl:processing-instruction name="xpacket">begin="&#xfeff;" id="W5M0MpCehiHzreSzNTczkc9d"</xsl:processing-instruction>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 4.0-c006 1.236519, Wed Jun 14 2006 08:31:24">
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:xap="http://ns.adobe.com/xap/1.0/"
            xmlns:xapGImg="http://ns.adobe.com/xap/1.0/g/img/">
<!--
         <xap:CreateDate>2008-06-06T13:32:37Z</xap:CreateDate>
         <xap:MetadataDate>2008-06-06T13:57:52Z</xap:MetadataDate>
         <xap:ModifyDate>2008-06-06T13:57:52Z</xap:ModifyDate>
-->
         <xap:CreatorTool>Adobe InCopy 5.0</xap:CreatorTool>
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:dc="http://purl.org/dc/elements/1.1/">
         <dc:format>application/x-incopy</dc:format>
<!--
         <dc:title>
            <rdf:Alt>
               <rdf:li xml:lang="x-default">amazon16_Mag</rdf:li>
            </rdf:Alt>
         </dc:title>
-->
      </rdf:Description>
      <rdf:Description rdf:about=""
            xmlns:custom="reallysi/custom/">
	<xsl:if test="pubdate">
         <custom:pubdate><xsl:value-of select="pubdate"/></custom:pubdate>
	</xsl:if>
	<xsl:if test="moid">
         <custom:moid><xsl:value-of select="moid"/></custom:moid>
	</xsl:if>
	<xsl:if test="issue">
	  <custom:issue><xsl:value-of select="issue"/></custom:issue>
	</xsl:if>
	<xsl:if test="department">
	  <custom:department><xsl:value-of select="department"/></custom:department>
	</xsl:if>
	<xsl:if test="editor">
	  <custom:editor><xsl:value-of select="editor"/></custom:editor>
	</xsl:if>
	<xsl:if test="articleID">
         <custom:articleID>
            <rdf:Alt>
               <rdf:li xml:lang="x-default"><xsl:value-of select="articleID"/></rdf:li>
            </rdf:Alt>
         </custom:articleID>
	</xsl:if>
	<xsl:if test="authors/author">
         <custom:authors>
            <rdf:Seq>
	      <xsl:for-each select="authors/author">
		<rdf:li><xsl:value-of select="."/></rdf:li>
	      </xsl:for-each>
            </rdf:Seq>
         </custom:authors>
	</xsl:if>
	<xsl:if test="description">
         <custom:description>
            <rdf:Alt>
               <rdf:li xml:lang="x-default"><xsl:value-of select="description"/></rdf:li>
            </rdf:Alt>
         </custom:description>
	</xsl:if>
	<xsl:if test="keywords/keyword">
         <custom:keywords>
            <rdf:Bag>
	      <xsl:for-each select="keywords/keyword">
		<rdf:li><xsl:value-of select="."/></rdf:li>
	      </xsl:for-each>
            </rdf:Bag>
         </custom:keywords>
	</xsl:if>
	<xsl:if test="layoutID">
         <custom:layoutID>
            <rdf:Alt>
               <rdf:li xml:lang="x-default"><xsl:value-of select="layoutID"/></rdf:li>
            </rdf:Alt>
         </custom:layoutID>
	</xsl:if>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>
  <xsl:processing-instruction name="xpacket">end="r"</xsl:processing-instruction>
<!--
<xsl:value-of select="saxon:serialize($cdata,'xmp-out')"/>
-->
  </xsl:template>

  <xsl:template match="/">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">style="33" type="snippet" DOMVersion="5.0" readerVersion="4.0" featureSet="513" product="5.0(640)"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">SnippetType="InCopyInterchange"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <SnippetRoot><xsl:text>&#x0a;</xsl:text>
      <!-- Paragraph and character style definitions go here -->
      <xsl:apply-templates select="$styleCatalog/*" mode="generateStyles"/>
      <xsl:text>&#x0a;</xsl:text>
      <cflo Self="rc_ub0"><xsl:text>&#x0a;</xsl:text>

      <!-- include XMP -->
      <cMep Self="{ concat('rc_',generate-id()) }">
	<pcnt>
	  <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
	  <xsl:apply-templates mode="XMP"/>
	  <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
	</pcnt>
<!--
	<pcnt><![CDATA[<xsl:apply-templates mode="XMP"/>]]></pcnt>
xsl:value-of select="'&lt;![CDATA['"/><xsl:apply-templates mode="XMP"/><xsl:value-of select="']]'"/></pcnt>
-->
      </cMep>

      <xsl:apply-templates select="*/body"/>

      <xsl:apply-templates select="//ticker" mode="notes"/>

      </cflo><xsl:text>&#x0a;</xsl:text>
    </SnippetRoot>
  </xsl:template>
  
  <xsl:template match="idsc:InDesign_Style_Catalog" mode="generateStyles">
    <xsl:apply-templates select="idsc:CharacterStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ParagraphStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:TableStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ObjectStyles" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="idsc:ParagraphStyles | idsc:CharacterStyles | idsc:TableStyles | idsc:ObjectStyles  " mode="generateStyles">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:cStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'csty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template name="makeStyleElement">
    <xsl:param name="tagName" select="xs:string"/>
    <xsl:element name="{$tagName}">
      <xsl:attribute name="pnam" select="concat('k_', @name)"/>
      <xsl:attribute name="Self" select="concat('rc_', generate-id())"/>
      <xsl:sequence select="@*[not(contains('^base^name^', concat('^', name(.), '^')))]"/>
      <xsl:if test="@base != ''">
        <xsl:attribute name="basd" select="concat('k_', @base)"/>
      </xsl:if>
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:pStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'psty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:tStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'tsty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:objStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'ObSt'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="body/p[1]">
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="'Text-ragged-XI~sep~body'" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="'Text-ragged~sep~body'" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@*" priority="-1">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- FIXME: The point of this template is to suppress whitespace
               in all non-mixed contexts. There may be a more
               efficient way to do this.
    -->
<!--
  <xsl:template match="body/text() | 
    *[contains(@class, ' topic/topic ')]/text() |
    *[contains(@class, ' topic/body ')]/text() |
    *[contains(@class, ' topic/section ')]/text() |
    *[contains(@class, ' topic/ol ')]/text() |
    *[contains(@class, ' topic/ul ')]/text() |
    *[contains(@class, ' topic/table ')]/text() |
    *[contains(@class, ' topic/tgroup ')]/text() |
    *[contains(@class, ' topic/tbody ')]/text() |
    *[contains(@class, ' topic/row ')]/text() |
    *[contains(@class, ' topic/fig ')]/text() |
    *[contains(@class, ' topic/dl ')]/text() |
    *[contains(@class, ' topic/dlentry ')]/text()
    "/>
-->

  <xsl:template name="makeBlock">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:apply-templates>
      <xsl:with-param name="pStyle" select="$pStyle" tunnel="yes" as="xs:string"/>
      <xsl:with-param name="cStyle" select="'[No character style]'" tunnel="yes" as="xs:string"/>
    </xsl:apply-templates>
    <txsr><xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:text>&#x2029;</xsl:text></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeBlock-cont">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:apply-templates select="text()|ticker" mode="cont"/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
    <txsr><xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:text>&#x2029;</xsl:text></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="copyright">
  </xsl:template>
  
  <xsl:template match="copyryear">
  </xsl:template>
  
  <xsl:template match="copyrholder">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="i">
    <!-- FIXME: handle ancestor containing phrase elements -->
    <xsl:apply-templates>
      <xsl:with-param name="cStyle" select="'italic'" tunnel="yes" as="xs:string"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="b">
    <xsl:apply-templates>
      <xsl:with-param name="cStyle" select="'bold'" tunnel="yes" as="xs:string"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="u">
    <xsl:apply-templates>
      <xsl:with-param name="cStyle" select="'underline'" tunnel="yes" as="xs:string"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="ticker" mode="notes">
    <xsl:variable name="quot"><xsl:text>'</xsl:text></xsl:variable>
    <Note UsrN="rsuite" STof="ro_{generate-id(.)}">
      <xsl:call-template name="makeTxsr">
	<xsl:with-param name="content"><xsl:value-of select="concat('c_$TICKER$ (&lt;ticker symbol','=',$quot,@symbol,$quot,'/&gt;)')"/></xsl:with-param>
      </xsl:call-template>
    </Note>
  </xsl:template>
  
  <xsl:template match="text()" mode="cont">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:value-of select="local:normalizeText(.)"/>
  </xsl:template>
  
  <xsl:template match="ticker" mode="cont">
    <xsl:processing-instruction name="aid">Char="feff" Self="rc_<xsl:value-of select="generate-id(.)"/>"</xsl:processing-instruction>
  </xsl:template>
  
  <xsl:template match="*" mode="#all" priority="-1">
    <xsl:message> + WARNING: Unhandled element <xsl:value-of select="name(..)"/>/<xsl:value-of select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="processing-instruction()[name(.) = 'aid']">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <pcnt><xsl:text>e_</xsl:text><xsl:value-of select="."/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:value-of select="local:normalizeText(.)"/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
    <xsl:variable name="nextNode" select="(following-sibling::* | following-sibling::text())[1]" as="node()?"/>
    <xsl:if test="$nextNode instance of element() and contains($nextNode/@class, ' topic/p ')">
      <txsr><xsl:text>&#x0a;</xsl:text>
        <pcnt>c_<xsl:text>&#x0a;</xsl:text></pcnt><xsl:text>&#x0a;</xsl:text>
      </txsr><xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tab" priority="10">
    <xsl:call-template name="makeTxsr">
      <xsl:with-param name="content">c_&#x09;</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="makeTxsr">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt><xsl:sequence select="$content"/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
    <xsl:variable name="nextNode" select="(following-sibling::* | following-sibling::text())[1]" as="node()?"/>
    <xsl:if test="$nextNode instance of element() and contains($nextNode/@class, ' topic/p ')">
      <txsr><xsl:text>&#x0a;</xsl:text>
        <pcnt>c_<xsl:text>&#x0a;</xsl:text></pcnt><xsl:text>&#x0a;</xsl:text>
      </txsr><xsl:text>&#x0a;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:function name="local:getObjectIdForParaStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:ParagraphStyles/idsc:pStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
                 then generate-id($targetStyle)
                 else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:value-of select="$styleId"/>
  </xsl:function>

  <xsl:function name="local:getObjectIdForCharacterStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:CharacterStyles/idsc:cStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="local:normalizeText" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="noBreaks" select="replace($inString, '[&#x2029;&#x0A;]', '')" as="xs:string"/>
    <xsl:variable name="outString" select="replace($noBreaks, '[ ]+', ' ')" as="xs:string"/>
    <xsl:value-of select="$outString"/>
  </xsl:function>
  
</xsl:stylesheet>
