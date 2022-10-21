<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_cmplt.Offls_cmpltBean"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_auctionBean"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");


	detail = olcD.getCmplt_detail(car_mng_id);
	String imgfile[] = new String[5];
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                		
	String content_code = "";
	String content_seq  = "";
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
		
	for(int i=0;i<5;i++){
                	               			
		content_code = "APPRSL";
		content_seq  = car_mng_id+""+String.valueOf(i+1);

		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
		attach_vt_size = attach_vt.size();	

		if(attach_vt_size > 0){
			for (int j = 0 ; j < attach_vt_size ; j++){
 				Hashtable ht = (Hashtable)attach_vt.elementAt(j);	
 				imgfile[i] = "https://fms3.amazoncar.co.kr"+String.valueOf(ht.get("SAVE_FOLDER"))+""+String.valueOf(ht.get("SAVE_FILE"));
 			}
 		}else{
 			imgfile[i] = "";
 		}
 	}	

	apprsl = olpD.getPre_apprsl(car_mng_id);
	auction = olaD.getAuction(car_mng_id, olaD.getAuction_maxSeq(car_mng_id));
	
	//경매장정보
	Vector actns = olpD.getActns();
	
	//사원전체리스트
	
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
	//상품가격 수정 등록 구분하기 위해
	String auction_car_mng_id = olaD.getAuction_Car_mng_id(car_mng_id);
	
	//차량출고매핑 수정 등록 구분하기 위해
	String auction_pur_car_mng_id = olaD.getAuction_Pur_Car_mng_id(car_mng_id);
	
	
	//희망가,시작가 퍼센트
	int carpr = detail.getCar_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cs_amt()+detail.getOpt_cv_amt()+detail.getClr_cs_amt()+detail.getClr_cv_amt();
	double hppr_per=0.0D, stpr_per=0.0D;
	double hppr = auction.getHp_pr();
	double stpr = auction.getSt_pr();
	if(carpr==0){
		hppr_per = 0;
		stpr_per = 0;
	}else{
		hppr_per = (hppr*100)/carpr;
		stpr_per = (stpr*100)/carpr;
	}
	
	//반출시
	if(!olpD.getCar_mng_id_ban(car_mng_id).equals("")){
		detail.setDeterm_id("");
		detail.setHppr(0);
		detail.setStpr(0);
	}
	
	//차량정보
	Hashtable sh_ht = shDb.getShBase(car_mng_id);	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
var imgnum =0;
carImage = new Array();
for(i=0; i<5; i++){
	carImage[i] = new Image();
}
carImage[0].src = "<%=imgfile[0]%>";
carImage[1].src = "<%=imgfile[1]%>";
carImage[2].src = "<%=imgfile[2]%>";
carImage[3].src = "<%=imgfile[3]%>";
carImage[4].src = "<%=imgfile[4]%>";

function show(n){
	document.images["carImg"].src = carImage[n].src;
	document.form1.carImg.value = carImage[n].src;
	imgnum = n;
}
function apprslUpd(ioru)
{
	var fm = document.form1;	
	var apprsl_dt = ChangeDate2(fm.apprsl_dt.value);
	if(apprsl_dt != ""){
		if(ioru=="i"){
			if(!confirm('평가내용을 등록하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('평가내용을 수정하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_pre/off_ls_pre_apprsl_upd.jsp";
		fm.target = "i_no";	
		fm.submit();
	}else{
		alert("평가일자를 입력하세요!");
		return;
	}
}
function auctionUpd(ioru){
	var fm = document.form1;
	if(fm.determ_id.value==""){ alert('가격결장자를 선택해 주세요!'); return; }
	else if(fm.stpr.value==0){ alert('시작가를 입력해 주세요!'); return; }
	else if(fm.hppr.value==0){ alert('희망가를 입력해 주세요!'); return; }
	if(ioru=="i"){
		if(!confirm('등록하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_auction_upd.jsp";
	fm.target = "i_no";	
	fm.submit();
}


function carPurUpd(ioru){
	var fm = document.form1;	
	if(ioru=="i"){
		if(!confirm('등록하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_car_pur_upd.jsp";
	fm.target = "i_no";	
	fm.submit();
}


function imgAppend(){
	<%
	int num = 0;
	for(int i=0; i<imgfile.length; i++){
		if(!imgfile[i].equals("")){
			num++;
		}
	}
	if(num==5){%>
		alert("5개까지만 추가됩니다.!");
		return;
	<%}else{%>
		window.open("/acar/res_search/car_img_add_all.jsp?c_id=<%=car_mng_id%>&car_no=<%=detail.getCar_no()%>", "imgAppend", "left=300, top=200, width=820, height=600, resizable=no, scorllbars=no");
	<%}%>
}
function imgDelete(){
	var imgName = "";
	if(imgnum==0){ imgName = "앞측"; }
	else if(imgnum==1){ imgName = "실내"; }
	else if(imgnum==2){ imgName = "뒤"; }
	else if(imgnum==3){ imgName = "뒷측"; }
	else if(imgnum==4){ imgName = "앞";}

	if(!confirm(imgName+' 이미지를 삭제하시겠습니까?')){ return; }
	var fm = document.form1;
	fm.action = "/acar/off_lease/off_lease_imgDelete.jsp";
	fm.target = "i_no";
	fm.imgnum.value = imgnum;
	fm.submit();
}
function imgBig(){
	var imgName = document.form1.carImg.value;
	window.open("/acar/secondhand_hp/bigimg.jsp?c_id=<%=car_mng_id%>","imgBig", "left=200, top=100, width=800, height=600, resizable=yes, scorllbars=no");
}
function list(){
	var fm = document.form1;
	fm.action = "off_ls_pre_frame.jsp";
	fm.submit();	
}
function add_actn(){
	var url = "?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	var SUBWIN = "off_ls_pre_actn_i.jsp"+url;
	window.open(SUBWIN, "View_ADD_ACTN", "left=100, top=100, width=820, height=400, resizable=no, scrollbars=no");
}
function getHpprPer(){
	var fm = document.form1;
	var hppr = toInt(parseDigit(fm.hppr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (hppr*100)/carpr;
	fm.hppr.value = parseDecimal2(hppr);
	fm.hppr_per.value = parseFloatCipher3(per,2);
}
function getStprPer(){
	var fm = document.form1;
	var stpr = toInt(parseDigit(fm.stpr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (stpr*100)/carpr;
	fm.stpr.value = parseDecimal2(stpr);
	fm.stpr_per.value = parseFloatCipher3(per,2);	
}
-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="imgnum" value="">
<input type="hidden" name="gubun" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본정보</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width=100% >
                <tr> 
                    <td class='title' width=16%>차량연번</td>
                    <td class='title' width=21%>차량번호</td>
                    <td class='title' width=21%>최초등록일</td>
                    <td class='title' width=21%>출고일</td>
                    <td class='title' width=21%>차대번호</td>
                </tr>
                <tr> 
                    <td align="center"><%=detail.getCar_l_cd()%>(<%=String.valueOf(sh_ht.get("JG_CODE"))%>)</td>
                    <td align="center"><%=detail.getCar_no()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getDlv_dt())%></td>
                    <td align="center"><%=detail.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'>용도</td>
                    <td class='title'>연료</td>
                    <td class='title'>배기량</td>
                    <td class='title'>연식</td>
                    <td class='title'>형식</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <%if(detail.getCar_use().equals("1")){%>
                      영업용 
                      <%}else{%>
                      자가용 
                      <%}%>
                    </td>
                    <td align="center"><%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%></td>
                    <td align="center"><%=detail.getDpm()%> cc</td>
                    <td align="center"><%=detail.getCar_y_form()%></td>
                    <td align="center"><%=detail.getCar_form()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%" >
                <tr> 
                    <td rowspan="6"  width=16% align="center">
			        <img src="<%if(!imgfile[0].equals("")){%>	
							<%=imgfile[0]%>
						<%}else if(!detail.getImgfile2().equals("")){%>
							<%=imgfile[1]%>
						<%}else if(!detail.getImgfile3().equals("")){%>
					                <%=imgfile[2]%>
						<%}else if(!detail.getImgfile4().equals("")){%>
							<%=imgfile[3]%>
						<%}else if(!detail.getImgfile5().equals("")){%>
							<%=imgfile[4]%>
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
						name="carImg" 
						value = "<%if(!imgfile[0].equals("")){%>	
							<%=imgfile[0]%>
						<%}else if(!detail.getImgfile2().equals("")){%>
							<%=imgfile[1]%>
						<%}else if(!detail.getImgfile3().equals("")){%>
					                <%=imgfile[2]%>
						<%}else if(!detail.getImgfile4().equals("")){%>
							<%=imgfile[3]%>
						<%}else if(!detail.getImgfile5().equals("")){%>
							<%=imgfile[4]%>
						<%}else{%>
							https://fms3.amazoncar.co.kr/images/no_photo.gif
						<%}%>" 
						border="0" width="150" height="120" onclick="javascript:imgBig()"></td>
                    <td rowspan="2"  class='title' width=7%>구분</td>
                    <td class='title' rowspan="2" width=14%>명칭</td>
                    <td class="title" colspan="3">소비자가</td>
                    <td class="title" colspan="3">구입가</td>
                </tr>
                <tr> 
                    <td  class='title' width=10%>공급가</td>
                    <td  class='title' width=11%>부가세</td>
                    <td  class='title' width=11%>합계</td>
                    <td  class='title' width=10%>공급가</td>
                    <td  class='title' width=10%>부가세</td>
                    <td  class='title' width=11%>합계</td>
                </tr>
                <tr> 
                    <td align="center" >차명</td>
                    <td align="center"><span title='<%=detail.getCar_jnm()+" "+detail.getCar_nm()%>'><%=AddUtil.subData(detail.getCar_jnm()+" "+detail.getCar_nm(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getCar_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getCar_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >옵션</td>
                    <td align="center"><span title='<%=detail.getOpt()%>'><%=AddUtil.subData(detail.getOpt(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_cs_amt()+detail.getOpt_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getOpt_fs_amt()+detail.getOpt_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >색상</td>
                    <td align="center"><span title='<%=detail.getColo()%>'><%=AddUtil.subData(detail.getColo(),8)%></span></td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_cs_amt()+detail.getClr_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getClr_fs_amt()+detail.getClr_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2" align="center" class=title>매출DC</td>
                    <td align="right">0
                    <%//=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right">0
                    <%//=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right">0
                    <%//=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getDc_cs_amt()+detail.getDc_cv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" rowspan='2'> 
                      <%
        			int j=1;
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%>
                      <a href="#" onClick="show(<%=i%>)">
                      <%if(j==1){%><img src=../images/center/button_front_s.gif align=absmiddle border=0>
                      <%}else if(j==2){%><img src=../images/center/button_in.gif align=absmiddle border=0> 
                      <%}else if(j==3){%><img src=../images/center/button_back.gif align=absmiddle border=0>
                      <%}else if(j==4){%><img src=../images/center/button_back_s.gif align=absmiddle border=0>
                      <%}else if(j==5){%><img src=../images/center/button_front.gif align=absmiddle border=0>
                      <%}%>
                      </a> 
                      <%}
        				j++;
        			}
        			for(int i=0; i<imgfile.length; i++){
        				if(!imgfile[i].equals("")){%>
                      <script language="javascript">
        						imgnum = <%=i%>;
        						//alert(imgnum);
        					</script> 
                      <%break;
        				}
        			}
        			if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
                      <a href='javascript:imgAppend();'><img src=../images/center/button_in_plus.gif align=absmiddle border=0></a>   
                      <%}%>
        
                    </td>
                    <td colspan="2" align="center" class=title>탁송료</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_cs_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fv_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getSd_fs_amt()+detail.getSd_fv_amt())%>&nbsp;</td>
                </tr>
                <tr> 
                    <!--<td align="center"> 
                      <%if(auth_rw.equals("4")||auth_rw.equals("6")){
        			  		if(imgfile[0].equals("") && imgfile[1].equals("") && imgfile[2].equals("") && imgfile[3].equals("") && imgfile[4].equals("")){%>
                      <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      <%}else{%>
                      <a href='javascript:imgAppend();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_plus.gif align=absmiddle border=0></a> 
                      &nbsp;<a href='javascript:imgDelete();' onMouseOver="window.status=''; return true"> 
                      <img src=../images/center/button_in_delete.gif align=absmiddle border=0></a> 
                      <%}
        			  }%>
                    </td>-->
                    <td colspan="2" align="center" class=title>합 계</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_cs_amt()+detail.getOpt_cs_amt()+detail.getClr_cs_amt()+detail.getSd_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cv_amt()+detail.getClr_cv_amt()+detail.getSd_cv_amt())%></b>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt())%>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%>&nbsp;</td>
                    <td align="right"><b><%=AddUtil.parseDecimal(detail.getCar_fs_amt()+detail.getOpt_fs_amt()+detail.getClr_fs_amt()+detail.getSd_fs_amt()-detail.getDc_cs_amt()+detail.getCar_fv_amt()+detail.getOpt_fv_amt()+detail.getClr_fv_amt()+detail.getSd_fv_amt()-detail.getDc_cv_amt())%></b>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타정보</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%> 할부금융사</td>
                    <td align='center' width=21%> 
                      <%if(detail.getBank_nm().equals("")){%>
                      - 
                      <%}else{%>
                      <%=detail.getBank_nm()%> 
                      <%}%>
                    </td>
                    <td class='title' width=14%> 대출금액</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_prn())%>&nbsp;원</td>
                    <td class='title' width=13%>상환원금잔액</td>
                    <td align='center' width=18%><%=AddUtil.parseDecimal(detail.getLend_rem())%>&nbsp;원</td>
                </tr>
                <tr> 
                    <td class='title'> 보험사</td>
                    <td align='center'><%= detail.getIns_com_nm() %></td>
                    <td class='title'> 보험유효기간</td>
                    <td align='center'><%= AddUtil.ChangeDate2(detail.getIns_exp_dt()) %></td>
                    <td class='title'>상환만료일</td>
                    <td align="center"><%=AddUtil.ChangeDate2(detail.getAlt_end_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>정기검사유효기간</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getMaint_st_dt())%> 
                      ~ <%=AddUtil.ChangeDate2(detail.getMaint_end_dt())%></td>
                    <td class='title'> 누적주행거리</td>
                    <td align="center"><%=AddUtil.parseDecimal(detail.getToday_dist())%> 
                      km</td>
                    <td class="title" align="center">평균주행거리</td>
                    <td align="center" ><%=AddUtil.parseDecimal(detail.getAverage_dist())%> 
                      km</td>
                </tr>
                <tr> 
                    <td class='title'>점검유효기간</td>
                    <td align='center'><%=AddUtil.ChangeDate2(detail.getTest_st_dt())%> 
                      ~ <%=AddUtil.ChangeDate2(detail.getTest_end_dt())%></td>
					<td class="title" align="center">차령만료일</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sh_ht.get("CAR_END_DT")))%></td>
                    <td class='title'>구조변경</td>
                    <td align="center"> 
                      <%if(detail.getCar_cha_yn().equals("1")){%>
                      &nbsp;있음 
                      <%}else{%>
                      &nbsp;없음 
                      <%}%>
                    </td>
                    
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left'><a name="apprsl"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품평가</span></a></td>
        <td align="right">
<%if(auth_rw.equals("4")||auth_rw.equals("6")){%>	  
	 <%if(apprsl_car_mng_id.equals("")){%>
	 	<a href='javascript:apprslUpd("i");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_reg.gif align=absmiddle border=0></a>
	<%}else{%>
		<a href='javascript:apprslUpd("u");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_modify.gif align=absmiddle border=0></a>
	<%}%>	
<%}%> 
        </td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <tr> 
                    <td class='title' width=16%> 자체평가</td>
                    <td width=21%>&nbsp; 
                      <select name='lev'>
                        <option value='0'>선택</option>
                        <option value='1' <%if(apprsl.getLev().equals("1")){%>selected<%}%>>상</option>
                        <option value='2' <%if(apprsl.getLev().equals("2")){%>selected<%}%>>중</option>
                        <option value='3' <%if(apprsl.getLev().equals("3")){%>selected<%}%>>하</option>
                      </select>
                    </td>
                    <td class='title' width=14%>평가일자</td>
                    <td width=49%>&nbsp; 
                      <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(apprsl.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>평가요인</td>
                    <td colspan="3">&nbsp; 
                      <textarea  class="textarea" name="reason" cols="145" rows="2"><%=apprsl.getReason()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>차량상태</td>
                    <td colspan="3">&nbsp; 
                      <input  class="text" type="text" name="car_st" size="147" value="<%=apprsl.getCar_st()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>사고유무</td>
                    <td> &nbsp; 
                      <select name='sago_yn'>
                        <option value=''>선택</option>
                        <option value='Y' <%if(apprsl.getSago_yn().equals("Y")){%>selected<%}%>>유</option>
                        <option value='N' <%if(apprsl.getSago_yn().equals("N")){%>selected<%}%>>무</option>
                      </select>
                    </td>
                    <td class="title">LPG유무</td>
                    <td> &nbsp; 
                      <select name='lpg_yn'>
                        <option value=''>선택</option>
                        <option value='1' <%if(apprsl.getLpg_yn().equals("1")){%>selected<%}%>>유</option>
                        <option value='0' <%if(apprsl.getLpg_yn().equals("0")){%>selected<%}%>>무</option>
        				<option value='2' <%if(apprsl.getLpg_yn().equals("2")){%>selected<%}%>>탈거</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>차량실제주행거리</td>
                    <td> &nbsp; 
                      <input  class="num" type="text" name="km" size="20" value="<%=AddUtil.parseDecimal(apprsl.getKm())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      KM </td>
                    <td class='title'>출품경매장</td>
                    <td> 
                      <select name='client_id'>
                        <option value=''>선택</option>
                        <%for(int i=0; i<actns.size(); i++){
        					Hashtable ht = (Hashtable)actns.elementAt(i);%>
                        <option value='<%=ht.get("CLIENT_ID")%>' <%if(ht.get("CLIENT_ID").equals(apprsl.getActn_id())){%>selected<%}%>><%=ht.get("FIRM_NM")%></option>
                        <%}%>
                      </select>
                      &nbsp;<input  class="text" type="text" name="actn_wh" size="10" value="<%=apprsl.getActn_wh()%>" > 
                      <%//<a href='javascript:add_actn();' onMouseOver="window.status=''; return true"> 
                      //<img src="/images/add.gif" width="50" height="18" align="absmiddle" border="0" alt="추가"></a> 
                    %>
                     
                    </td>
                </tr>
                <tr> 
                    <td class='title'>담당자평가</td>
                    <td colspan="3"> &nbsp; 
                      <textarea  class="textarea" name="damdang" cols="145" rows="2"><%=apprsl.getDamdang()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>변경전차량번호</td>
                    <td> &nbsp;&nbsp; 
                      <%if(detail.getCar_pre_no().equals("")){%>
                      없음 
                      <%}else{%>
                      <%=detail.getCar_pre_no()%> &nbsp; 
                      <%}%>
                    </td>
                    <td class="title">차량번호변경일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(detail.getCha_dt())%> </td>
                </tr>
                <tr> 
                    <td class='title'>담당자</td>
                    <td>&nbsp; 
                      <select name="damdang_id">
                        <option value='' <%if(apprsl.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(apprsl.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select>
                    </td>
                    <td class="title">최종수정자</td>
                    <td>&nbsp; 
                      <%if(login.getAcarName(apprsl.getModify_id()).equals("error")){%>
                      &nbsp;
                      <%}else{%>
                      <%=login.getAcarName(apprsl.getModify_id())%> 
                      <%}%>
                      &nbsp; </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품가격결정</span></td>
        <td align='right'>
 <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>	  
	 <%if(auction.getDamdang_id().equals("") && auction.getSt_pr()==0 && auction.getHp_pr()==0){%>
	 	<a href='javascript:auctionUpd("i");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_reg.gif align=absmiddle border=0></a>
	<%}else{%>
		<a href='javascript:auctionUpd("u");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_modify.gif align=absmiddle border=0></a>
	<%}%>	
<%}%> 
        </td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%>최종결정자</td>
                    <td class='title' width=28%>신차가</td>
                    <td class='title' width=28%>시작가(신차대비)</td>
                    <td class='title' width=28%>희망가(신차대비)</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <select name="determ_id">
                        <option value='' <%if(auction.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(auction.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input  class="num" type="text" name="carpr" size="12" value="<%=AddUtil.parseDecimal(carpr)%>">
                      원 </td>
                    <td  align="center"> 
                      <input  class="num" type="text" name="stpr" size="12" value="<%=AddUtil.parseDecimal(auction.getSt_pr())%>" onChange="javascript:getStprPer()">
                      (<input  class="white" type="text" name="stpr_per" size="5" value="<%=AddUtil.parseDecimal(stpr_per)%>" >%)</td>
                    <td  align="center"> 
                      <input  class="num" type="text" name="hppr" size="12" value="<%=AddUtil.parseDecimal(auction.getHp_pr())%>" onChange="javascript:getHpprPer()">
                      (<input  class="white" type="text" name="hppr_per" size="5" value="<%=AddUtil.parseDecimal(hppr_per)%>">%)</td>
                </tr>
            </table>
        </td>
    </tr>
    
      <tr> 
        <td colspan="2"></td>
    </tr>
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량출고매핑</span></td>
        <td align='right'>
<!--        
 <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>	  
	 <%if(auction_pur_car_mng_id.equals("")){%>
	 	<a href='javascript:carPurUpd("i");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_reg.gif align=absmiddle border=0></a>
	<%}else{%>
		<a href='javascript:carPurUpd("u");' onMouseOver="window.status=''; return true">
		<img src=../images/center/button_modify.gif align=absmiddle border=0></a>
	<%}%>	
<%}%> 
-->
        </td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                 	<td class='title' width=30%>출고점</td>
                    <td class='title' width=16%>관리자</td>
                    <td class='title' width=16%>계약번호</td>
                    <td class='title' width=24%>계출번호</td>                  
                    <td class='title' width=14%>출고일</td>                              
                </tr>
                <tr>                  
                    <td align="center"> 
                      <input  class="text" type="text" name="car_off_nm" size="40"  class="text"  value="<%=detail.getP_car_off_nm()%>"></td>
                    <td align="center"> 
                      <input  class="text" type="text" name="emp_nm" size="20" value="<%=detail.getP_emp_nm()%>" ></td>
                    <td align="center"> 
                      <input  class="text" type="hidden" name="rent_mng_id" value="<%=detail.getP_rent_mng_id()%>" >
                      <input  class="text" type="text" name="rent_l_cd" size="15" value="<%=detail.getP_rent_l_cd()%>" ></td>
                    <td align="center"> 
                       <input  class="text" type="hidden" name="p_car_no" value="<%=detail.getP_car_no()%>" >
                      <input  class="text" type="text" name="rpt_no" size="30" value="<%=detail.getP_rpt_no()%>" ></td>
                    <td align="center"> 
                      <input  class="text" type="text" name="dlv_dt" size="14" value="<%=detail.getP_dlv_dt()%>" ></td>
                   
                </tr>
            </table>
        </td>
    </tr>
    
    
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>