<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*" %>
<%@ page import="acar.cont.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>


<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String o_1 			= request.getParameter("o_1")==null?"":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_a 			= request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String amt 			= request.getParameter("amt")==null?"":request.getParameter("amt");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String mail_yn = request.getParameter("mail_yn")==null?"":request.getParameter("mail_yn");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();

	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();

	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){		//FMS 재리스결정차량에서 기본견적서/조정견적서
		e_bean 	= e_db.getEstimateCase(est_id);
		sh_comp = shDb.getShCompare(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}else{									//홈페이지 재리스차량 견적서
		e_bean 	= e_db.getEstimateShCase(est_id);
		sh_comp = shDb.getShCompareSh(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//차종코드변수
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
		
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String car_y_form		 	= String.valueOf(ht.get("CAR_Y_FORM"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 	= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));	
	String dist_cng			= String.valueOf(ht.get("DIST_CNG"));	
	int dpm 			= AddUtil.parseInt((String)ht.get("DPM"));
	float spe_dc_per		= AddUtil.parseFloat((String)ht.get("SPE_DC_PER"));
	String cha_st_dt 		= String.valueOf(ht.get("CHA_ST_DT"));
	String b_dist 			= String.valueOf(ht.get("B_DIST"));
	String car_use 			= String.valueOf(ht.get("CAR_USE"));
	
	if(e_bean.getB_dist() > 0){
		cha_st_dt 		= e_bean.getCha_st_dt();
		b_dist 			= String.valueOf(e_bean.getB_dist());
	}
	
	int car_use_mon = 0;
	//차량등록 경과기간2(차령만료일2개월전까지)
	if(!String.valueOf(ht.get("CAR_END_DT")).equals("") && AddUtil.checkDate(init_reg_dt)){	
		Hashtable carOld4 	= c_db.getOld(init_reg_dt, AddUtil.getDate(4), ""); //차령
		car_use_mon = (AddUtil.parseInt(String.valueOf(carOld4.get("YEAR")))*12) + AddUtil.parseInt(String.valueOf(carOld4.get("MONTH")));
	}
	
	String min_use_mon		= "6";
	if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){
		min_use_mon		= "12";
		//영업용차량 리스 용도변경시 (경차제외하고 24개월 이상 견적이 되도록)
		if(AddUtil.parseInt(jg_code) > 2000 && AddUtil.parseInt(jg_code) < 9999 && car_use.equals("1")){
			min_use_mon		= "24";
		}
		//영업용차량 리스 용도변경시 (경차제외하고 24개월 이상 견적이 되도록)
		if(AddUtil.parseInt(jg_code) > 2000000 && AddUtil.parseInt(jg_code) < 9999999 && car_use.equals("1")){
			min_use_mon		= "24";
		}		
	}
	
	String max_use_mon		= e_bean.getMax_use_mon();
	if(max_use_mon.equals("")){
		if(car_use_mon>0){
			if(ej_bean.getJg_b().equals("2")){
				if(dpm > 2000){
					max_use_mon = String.valueOf(94-car_use_mon);
				}else{
					max_use_mon = String.valueOf(82-car_use_mon);
				}
			}else{
				if(dpm > 2000){
					max_use_mon = String.valueOf(95-car_use_mon);
				}else{
					max_use_mon = String.valueOf(83-car_use_mon);
				}
			}
			if(AddUtil.parseInt(max_use_mon) > 48){
				max_use_mon = "48";
			}
		}else{
			max_use_mon = "48";
		}
	}
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "신차가격불명";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "중고차가미정";
		
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();
	
	String rent_way = "2";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}	
	if(a_b.equals(""))	a_b	= e_bean.getA_b();
	String a_e 			= s_st;
	float o_13 			= 0;
	
	
	//연락처----------------------------------------------------------------
	
	String name 	= "";
	String tel 		= "";
	String week_st 	= c_db.getWeek_st(AddUtil.getDate());  		//1:일요일 , 7:토요일
	int hol_cnt 	= c_db.getHoliday_st(AddUtil.getDate());  	//휴일
	
	String watch_id = c_db.getWatch_id(AddUtil.getDate() );  // 본사 인터넷 당직
		
	
	//근무시간내:08:30~20:30 회사전화번호 그후 개인전화번호:서울본사인경우. 지점은 지점번호 노출 
	int t_time = Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16));
	//default :서울본사 전화번호
	String check = "C";
	
	if(week_st.equals("1")  || week_st.equals("7") || hol_cnt > 0 ){
		check = "P";
	}else{
		if ( t_time >= 801 && t_time <= 2001 ){
			check = "C";
		}else{
		    check = "P";
		}
	}
	
		if ( check.equals("C")){
		name = "";
		tel =  "02-757-0802";
	} else {
		name = "";
		tel =  "02-392-4242";
		
	}
	
	String br_id = "S1";
	
	if(!acar_id.equals("")){
		UsersBean user_bean 	= umd.getUsersBean(acar_id);
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
		br_id 	= user_bean.getBr_id();
	}
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>견적서</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(복합연비기준)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(복합연비기준)");
	}
})
</script>
<style type="text/css">
<!--
body {
    font-family:'dotum',"나눔고딕",sans-serif;
    color: #000000;
    font-size:11px;
    letter-spacing:-0.05em;
}
.style1 {
	color: #000000;
	font-weight: bold;
	font-size: 19px;
	letter-spacing:-0.05em;
}
.style2 {
	color: #000000;
	font-weight: bold;
}
.style3 {
	color: #000000;
	font-size: 11px;

}
.style4 {color: #000000; font-weight: bold;}
.style5 {color: #000000;}
.style7 {color: #000000; font-weight: bold;}
.style8 {color: #000000; font-weight: bold;}
.style9 {color: #000000; font-weight: bold;}
.style12 {color: #000000; font-weight: bold; }
.style13 {
	color: #000000;
	font-weight: bold;
}
.style14 {color: #000000; font-weight: bold;}
.style15 {
	color: #000000;
	font-weight: bold;
}
.style16 {
	color: #000000;
	font-size: 11px;
}
-->
</style>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
}

</style>
<link href="/acar/main_car_hp/style_est_print.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//-->
		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
</head>
<body topmargin=0 leftmargin=0 <%if(mail_yn.equals("")){%>onLoad="javascript:onprint();"<%}%>>
<%if(mail_yn.equals("")){%>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">

</object>
<%}%>
<form action="" name="form1" method="POST" >
<input type="hidden" name="est_id" value="<%=est_id%>">
<table width=680 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=3 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=478 align=right><img src=/acar/main_car_hp/images/title_2.gif></td>
                    <td width=160 align=right>
                        <table width=160 border=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>작성일</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=3 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=282> <table width=282 border=0 cellspacing=0 cellpadding=0>
                      <tr> 
                        <td height=30 colspan=2>&nbsp;<span class=style1>[<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>]
						              보유차 <%if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){%>재리스<%}else{%>재렌트<%}%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=/acar/main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr> 
                        <td width=24 height=25 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=258><div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										      <span class=style2>님 귀하</span></div></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=/acar/main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr> 
                        <td height=25 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=/acar/main_car_hp/images/est_line.gif></td>
                      </tr>
                      <tr>
                        <td height=25 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=2><img src=/acar/main_car_hp/images/est_line.gif></td>
                      </tr>
                    </table></td>
                  <td width=18>&nbsp;</td>
                  <td width=356> 
                  
                  	<table width=356 border=0 cellpadding=0 cellspacing=0 background=/acar/main_car_hp/images/est_tel_bg.gif>
                      	<tr> 
                        	<td colspan=3 height=14></td>
                      	</tr>
                      	<tr> 
                        	<td width=54 height=18></td>
                        	<td width=155 class=listnum2><span class=style5>여의도영업부 <%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
                      		<td width=147 class=listnum2><span class=style5>광화문지점 <%if(br_id.equals("S5")){%><%= tel %><%= name %><%}else{%>02-2038-8661<%}%></span></td>
                      	</tr> 
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>강 남 지 점 &nbsp;&nbsp;&nbsp;<%if(br_id.equals("S2")){%><%= tel %><%= name %><%}else{%>02-537-5877<%}%></span></td>
                        	<td class=listnum2><span class=style5>송 파 지 점 <%if(br_id.equals("S6")){%><%= tel %><%= name %><%}else{%>02-2038-2492<%}%></span></td>
                      		
                      	</tr> 
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>인 천 지 점 &nbsp;<%if(br_id.equals("I1")){%><%= tel %><%= name %><%}else{%>032-554-8820<%}%></span></td>
                      		<td class=listnum2><span class=style5>수 원 지 점 <%if(br_id.equals("K3")){%><%= tel %><%= name %><%}else{%>031-546-8858<%}%></span></td>
                      	</tr>  
                      	<tr> 
                        	<td height=18></td>
                        	<td class=listnum2><span class=style5>대 전 지 점 &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>042-824-1770<%}%></span></td>
                      		<td class=listnum2><span class=style5>대 구 지 점 <%if(br_id.equals("G1")){%><%= tel %><%= name %><%}else{%>053-582-2998<%}%></span></td>
                      	</tr>
                      	<tr> 
                        	<td height=18></td>
                        	
                        	<td class=listnum2><span class=style5>부 산 지 점 &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
                      		<td class=listnum2><span class=style5>광 주 지 점 <%if(br_id.equals("J1")){%><%= tel %><%= name %><%}else{%>062-385-0133<%}%></span></td>
                      	</tr>                           	
                      	<tr> 
                        	<td colspan=2 height=12></td>
                      	</tr>  
                		</table></td>
                </tr>
                <tr> 
                  <td colspan="3" height="5"></td>
                </tr>
				<%if(stat.equals("신차가격불명")){%>
                <tr> 
                  <td colspan="3" height="12">&nbsp;※ 본 견적은 개략적 추정견적이며, 신차가격이 확인되어야 확정견적이 제시됩니다.</td>
                </tr>
				<%}	else if(stat.equals("중고차가미정")){%>
                <tr> 
                  <td colspan="3" height="12">&nbsp;※ 본 견적은 개략적 추정견적이며, 중고차가격이 결정인되어야 확정견적이 제시됩니다.</td>                
				</tr>
				<%}else{%>
                <tr> 
                  <td colspan="3" height="12">&nbsp;※ 귀사에서 문의하신 장기대여에 대하여 아래와 같이 견적을 제출하오니 
                    검토하시고 좋은 답변 부탁드립니다.</td>
                </tr>
				<%}%>				
              </table></td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"><img src=/acar/main_car_hp/images/bar_01.gif width=638 height=22></td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=132 height=15 align=center bgcolor=f2f2f2><span class=style3>제조사</span></td>
                  <td width=388 bgcolor=#FFFFFF>&nbsp;<span class=style3><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
                  <td width=114 align=center bgcolor=f2f2f2><span class=style3>금 
                    액</span></td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>차종(차량모델명)</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=car_name%></b></span></td>
                  <td align=right bgcolor=#FFFFFF><%if(stat.equals("신차가격불명")){%>미확인<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
                    원<%}%>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>옵 
                    션</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%=opt%></b></span>
                      <%if(car_mng_id.equals("018647")){%>(현재 판매되는 프리미엄 사양과 유사한 모델임)<%}%>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(opt_amt) %>
                    원</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>색 
                    상 </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%if(!e_bean.getIn_col().equals("")){%>외장: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean.getIn_col()%><%}%></b></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(clr_amt) %>
                    원</span>&nbsp;</td>
                </tr>
                <%if(!e_bean.getConti_rat().equals("")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>연 
                    비 </span></td>
                  <td bgcolor=#FFFFFF>
                  	<span id="contiRatDesc">&nbsp;<%=e_bean.getConti_rat()%></span></td>
                  <td bgcolor=#FFFFFF>&nbsp;</td>
                </tr>
                <%}%>
                <!-- 신차 개소세 감면 추가(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>신차 개소세 감면 </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 원</span>&nbsp;</td>
                </tr>
                <%}%>
                
                <tr>
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>감가상각
                   </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b>신차등록일 : <%=AddUtil.ChangeDate2(init_reg_dt)%> (모델연도:<%=car_y_form%>)
                  	<%if(!e_bean.getTot_dt().equals("") && (e_bean.getEst_from().equals("tae_car") || e_bean.getEst_from().equals("secondhand"))){//재리스,출고전대차%>
                  		<br>&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km (확인일자:<%=AddUtil.ChangeDate2(e_bean.getTot_dt())%>)
                  	<%}else{%>
                  		&nbsp;&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
                  	<%}%>
                  	</b></span>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style3>-<%if(stat.equals("신차가격불명") || stat.equals("중고차가미정")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%>
				    원</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>차량가격</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b>차량번호 : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
                     </b></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%if(stat.equals("중고차가미정")){%>미결정<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%>
                    원<%}%></span>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
		 	<td height=10 colspan="2">
		   		<table width=638 border=0 cellpadding=0 cellspacing=1>
		        	<tr>
		          		<td>※ 엔진, 변속기 : 2개월/5,000Km 품질보증<span style="font-size:10px;">(기간 또는 주행거리 중 먼저 도래한 것을 보증기간 만료로 간주)</span></td> 
			            <td height=10 align="right"><span class=style3>
						<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//모닝바이퓨엘,레이%>
									※ LPG/휘발유 겸용차
						<%}else{%>						
						<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		※ 디젤엔진
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	※ LPG전용차
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	※ 가솔린엔진
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	※ 하이브리드
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	※ 플러그인 하이브리드
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	※ 전기차
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	※ 수소차
						<%	}else{%>
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>			※ 디젤엔진
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		※ LPG전용차
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		※ 가솔린엔진
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>		※ 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>		※ 플러그인 하이브리드
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>		※ 전기차
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>		※ 수소차
							<%}%>
						<%	}%>
						<%}%>			
						&nbsp;</td>
			          </tr>
			     </table>
			 </td>
	     </tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=40> &nbsp;<span class=style3> * 위 차량은 계기판 교환 이력(<%=AddUtil.getDate3(cha_st_dt)%>)이 있는 차량으로 계기판 교환전 주행거리는 <%=AddUtil.parseDecimal(b_dist)%>km, 교환후<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;현 계기판의 주행거리는 <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km입니다. 감가상각 계산시에는 주행거리를 <%=AddUtil.parseDecimal(today_dist)%>km로 적용하고, 사고수리에<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;따른 시세하락을 반영하였습니다.</span></td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <%}%>
   
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=208><%if(!e_bean.getIns_per().equals("2")){%><img src=/acar/main_car_hp/images/bar_02.gif width=208 height=22><%}else{%><img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22><%}%></td>
                  <td width=30>&nbsp;</td>
                  <td width=400><img src=/acar/main_car_hp/images/bar_03.gif width=400 height=22></td>
                </tr>
                <tr> 
                  <td height=4 colspan=3></td>
                </tr>
                <tr> 
                  <td> <table width=208 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>대여기간</span></td>
                        <td width=113 align=right bgcolor=#FFFFFF><span class=style3><%=e_bean.getA_b()%>개월</span>&nbsp;</td>
                      </tr>
					  <%	int fee_s_amt = e_bean.getFee_s_amt();
								int fee_v_amt = e_bean.getFee_v_amt();
						  	int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
					  %>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>공 
                          급 가 </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(fee_s_amt)%> 
                          원</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>부 
                          가 세 </span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(fee_v_amt)%> 
                          원</span>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>월대여료</span></td>
                        <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(fee_t_amt)%> 
                          원</b></span>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td>&nbsp;</td>
                  <td> 
				  <%if(!e_bean.getIns_per().equals("2")){%>
				  <table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
                        <td width=106 align=center bgcolor=#FFFFFF><span class=style3>무한(대인 
                          Ⅰ,Ⅱ) </span></td>
                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
                        <td width=105 align=center bgcolor=#FFFFFF><span class=style3>1인당 
                          최고 2억원 </span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else if(e_bean.getIns_dj().equals("4")){%>2억원<%}else if(e_bean.getIns_dj().equals("8")){%>3억원<%}else if(e_bean.getIns_dj().equals("3")){%>5억원<%}else{%>1억원<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean.getIns_age().equals("3")){%>만24세이상<%}else{%>만26세이상<%}%></span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5천만원<%}else{%>1억원<%}%></span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style3>가입</span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>원</span></td>
                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
                      </tr>
                    </table>
					<%}else{%>
				  <table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                      <tr> 
                        <td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>대인배상</span></td>
                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>무보험차상해</span></td>
                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>대물배상</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>운전자연령</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>자기신체사고</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                        <td align=center bgcolor=f2f2f2><span class=style3>긴급출동</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                      </tr>
                      <tr> 
                        <td height=15 align=center bgcolor=f2f2f2><span class=style3>자차면책금</span></td>
                        <td align=center bgcolor=#FFFFFF><span class=style4>보험미반영</span></td>
                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
                      </tr>
                    </table>
					<%}%>			
				  </td>
                </tr>
                
                <%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
	            <tr>
					<td colspan="3" align="right">※ 사고수리시 아마존카 지정 정비공장에서 수리</td>
	            </tr>
	            <%}%>
                
	                <tr> 
				<td height=15 colspan=3 class=listnum2>&nbsp;* 본 차량의 대여기간은 <%=min_use_mon%>개월~<%=max_use_mon%>개월 사이 모든 개월수에서 선택가능합니다.
				</td>
	                </tr>
                
        		<!--용품-->
        		<%if(e_bean.getTint_b_yn().equals("Y") || e_bean.getTint_s_yn().equals("Y")|| e_bean.getTint_n_yn().equals("Y")|| e_bean.getTint_eb_yn().equals("Y")){
        				String tint_all = "";
        				if(e_bean.getTint_b_yn().equals("Y")){	tint_all +="1";	}		//2채널 블랙박스
        				if(e_bean.getTint_s_yn().equals("Y")){	tint_all +="2";	}		//전면 썬팅
        				if(e_bean.getTint_n_yn().equals("Y")){	tint_all +="3";	}		//거치형 내비게이션
        				if(e_bean.getTint_eb_yn().equals("Y")){	tint_all +="4";	}		//이동형 충전기 대여비용
        		%>                        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>*
			    				<%if(tint_all.equals("1")){%>위 대여요금은 2채널 블랙박스가 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("2")){%>위 대여요금은 전면 썬팅이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("3")){%>위 대여요금은 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("4")){%>위 대여요금은 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("12")){%>위 대여요금은 2채널 블랙박스와 전면 썬팅이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("13")){%>위 대여요금은 2채널 블랙박스와 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("14")){%>위 대여요금은 2채널 블랙박스와 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("23")){%>위 대여요금은 전면 썬팅과 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("24")){%>위 대여요금은 전면 썬팅과 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("34")){%>위 대여요금은 거치형 내비게이션과 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("123")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 거치형 내비게이션이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("124")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("134")){%>위 대여요금은 2채널 블랙박스, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("234")){%>위 대여요금은 전면 썬팅, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>
                            	<%if(tint_all.equals("1234")){%>위 대여요금은 2채널 블랙박스, 전면 썬팅, 거치형 내비게이션, 이동형 충전기 대여비용이 포함된 금액입니다.<%}%>    
                                </span>
                            </td>
                        </tr>                        
                        <%}%>                               
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>

                <tr> 
					<td height=20 colspan=3 class=listnum2>&nbsp;<span class=style8>* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>

                <tr> 
					<td height=25 colspan=3 class=listnum2>&nbsp;<span class=style8>* 대여료(월대여료,선납금)가 업무용으로 손비처리 가능할 경우 부가세는 <strong>매입세액공제(환급)받으실 수 있습니다.</strong>
					</span></td>
                </tr>
				<%}%>

              </table></td>
          </tr>
          <tr> 
            <td height=7 colspan="2"></td>
          </tr>
          
          	<tr> 
	            <td colspan="2">
	            	<img src=../main_car_hp/images/bar_2022_04.jpg width=638 height=22>
	            </td>
			</tr>
			<tr> 
	            <td height=4 colspan="2"></td>
			</tr>
			<tr> 
	            <td colspan="2"> 
	            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
	            		<tr>
	            			<td align=center bgcolor=f2f2f2 height=15 rowspan=3 width=75><span class=style3>약정운행거리</span></td>
	            			<td bgcolor=ffffff rowspan=3 align=center width=110><span class=style3><b><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km이하 / 1년</b></span>
	            				<%if(!e_bean.getEst_st().equals("2") && AddUtil.parseInt(e_bean.getA_b()) <12){
	            						String agree_dist_m = AddUtil.parseFloatNotDot2(AddUtil.parseFloat(String.valueOf(e_bean.getAgree_dist()))/(12/AddUtil.parseFloat(e_bean.getA_b())));
	            				%>
	            				<br>※<%=AddUtil.parseDecimal(agree_dist_m)%>km이하 / <%=e_bean.getA_b()%>개월
	            				<%}%>
	            			</td>
	            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75>
		            				<span class=style3>약정운행거리에<br>따른 정산</span>
		            			</td>
		            			<td bgcolor=f2f2f2 height=17> 
		            			  &nbsp;&nbsp; <b>(약정이하운행시) 환급대여료</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            			  <%if(e_bean.getRtn_run_amt_yn().equals("1")){ // 환급대여료 미적용%>
		            			  	미적용
		            			  <%} else{%>
		            			  	<%=e_bean.getRtn_run_amt()%>원/1km	(부가세별도)
		            			  <%} %>
		            			</td>
	            		</tr>
	            		<tr>
		            			<td bgcolor=f2f2f2 height=17>
		            			  &nbsp;&nbsp; <b>(약정초과운행시) 초과운행대여료</b>&nbsp;&nbsp;&nbsp;&nbsp;<%=e_bean.getOver_run_amt()%>원/1km	(부가세별도)
		            			</td>
		            		</tr>
	            		<tr>
	            			<td bgcolor=ffffff height=15> &nbsp;
	            				<%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            			  	<% if(AddUtil.parseInt(e_bean.getA_b()) >= 24){ %>	
		            			  		매입옵션 행사시에는 (약정이하운행시) 환급대여료가 지급되지 않고, (약정초과운행시) 초과운행대여료가 면제됩니다. (기본식)
		            			  	<%}%>
	            			  	<%}%>
            				</td>
	            		</tr>
	            	</table>
	            </td>
			</tr>
			
				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217){%>
                                <tr> 
				    <td colspan=2 height=22>&nbsp;<span class=style3>* 약정운행거리를 줄이면 대여요금이 인하되고, 약정운행거리를 늘리면 대여요금이 인상됩니다.</span></td>
                                </tr>
				<%}%>	
          <tr> 
             <td height=7 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"><img src=/acar/main_car_hp/images/bar_2022_05.jpg width=638 height=22></td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=75 height=15 align=center bgcolor=f2f2f2><span class=style3>보 
                    증 금</span></td>
                  <td width=93 align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
                    원</span>&nbsp;</td>
                  <td width=92 align=center bgcolor=f2f2f2><span class=style3><b>차가의 <%=e_bean.getRg_8()%>%</b></span></td>
                  <td width=373 bgcolor=#FFFFFF>&nbsp;<span class=style3>보증금은 
			  	계약기간 만료 후 환불해 드립니다.[보증금 100만원을 증액하면, 월대여료 5,500원(VAT포함)이 인하됩니다.(년리6.6%효과)]</span></td>
				</tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>선 
                    납 금</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 
				    원</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style3>VAT포함</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- 출고전대차는 문구표시X(2018.03.29) -->
                  	<span class=style3>선납금은 매월 일정 금액씩 공제되어 소멸되는 돈입니다. </span><br>&nbsp;
                  	<span class="style3" style="letter-spacing:-1.5px;">※ 세금계산서는 계약이용기간 동안 매월 균등 발행 또는 납부시 일시 발행 중 선택가능 </span>
                  	<%} %>
                  </td><!-- 2018.01.25 추가 -->
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>개시대여료</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
				    원</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style3>VAT포함</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- 출고전대차는 문구표시X(2018.03.29) -->
                  	<span class=style3>개시대여료는 마지막 (<%=e_bean.getG_10()%>)개월치 대여료를 선납하는 것입니다. </span>
                  	<%} %>
                  </td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>합 
                    계 </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><b><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
                    원</b></span>&nbsp;</td>
                  <td colspan=2 bgcolor=f2f2f2> &nbsp;&nbsp; <span class=style3>위의 대여요금은 좌측 초기납입금 이자효과가 반영된 금액입니다.</span></td>
                </tr>
              </table></td>
          </tr>
		  <%if(e_bean.getIfee_s_amt()>0 && (AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10())>0 ){%>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=206 height=15 align=center bgcolor=f2f2f2><span class=style3>월대여료 
                    잔여납입회수</span></td>
                  <td width=82 align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>회</span></td>
                  <td width=346 bgcolor=#FFFFFF>&nbsp;<span class=style3>개시대여료를 
                    납입한 경우만 적용되는 내용입니다. </span></td>
                </tr>
              </table></td>
          </tr>
		  <%}%>
		  <%if(e_bean.getPp_ment_yn().equals("Y")){%>     
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* 초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.</span></td>
      </tr>
      <%}%>		  		  
<!--적용잔가율-->

<%		if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){//기본식%>
<%			if(e_bean.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){
				e_bean.setRo_13(0);
				e_bean.setRo_13_amt(0);
				}
				if(stat.equals("중고차가미정")){
					e_bean.setRo_13(0);
					e_bean.setRo_13_amt(0);
				}
//				if(cm_bean.getDiesel_yn().equals("2")){//일반승용LPG전용차는 매입옵션 미제공
				if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
					if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
						e_bean.setRo_13(0);
						e_bean.setRo_13_amt(0);
					}
				}
%>
                <tr> 
                    <td height=7 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/main_car_hp/images/bar_2022_06.jpg width=638 height=22></td>
                </tr>
                <tr> 
                    <td height=4 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>적용잔가율</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getRo_13()==0 ){%><%}else{%><%=e_bean.getRo_13()%>%<%}%></span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style3>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;<span class=style3>적용잔가율 = 매입옵션율</span></td>
                            </tr>
                            <tr> 
                                <td height=15 align=center bgcolor=f2f2f2><span class=style3>매입옵션가격</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style3><%if(e_bean.getRo_13()==0 ){%>매입옵션 없음<%}else{%><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원<%}%></span>&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style3><%if(e_bean.getRo_13()>0 ){%>VAT포함<%}%></span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;<span class=style3><%if(e_bean.getRo_13()>0 ){%>본 매입옵션가격에 이용차량을 매입할 수 있는 권리를 드립니다.<%}%></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) < 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>※ 매입옵션은 <strong>기본식 24개월이상 계약</strong>시에만 주어짐.
					</span></td>
                </tr>				
				<%}%>
				<%if(e_bean.getRo_13() == 0 && AddUtil.parseInt(e_bean.getA_b()) >= 24){%>
                <tr> 
                    <td height=10 colspan="2">&nbsp;<span class=style8>※ 매입옵션 없음.
					</span></td>
                </tr>				
				<%}%>
<%		}%>

<!--적용잔가율-->		  
          <tr> 
            <td height=7 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
	            	    <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){ %>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=../main_car_hp/images/bar_07_1_2.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_07_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_07_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_2022_07.jpg width=638 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- 대차서비스는 일반 내연기관차량으로 제공 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%>                        
            </td>
          </tr>
          <tr> 
            <td height=4 colspan="2"></td>
          </tr>
        
          <tr> 
          <td colspan="2" valign=top> 
          		<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                  	<tr> 
                     	<td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>공통서비스</span></td>
                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* 교통사고 발생시 <b>사고처리 업무 대행</b><%}%> &nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;<span class=style3>* <b>사고대차서비스</b>(피해사고시는 보험대차)</span><%}%></td>
                    </tr>
                </table>
          </td>
         </tr>
         <tr></tr>
         <tr>
         	<td colspan="2">
                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                    <tr>
                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=15><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>기본식</b> (정비서비스 미포함 상품)</span></td>
                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>일반식</b> (정비서비스 포함 상품)</span></td>
                  	</tr>
                  	<tr>
                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=80>&nbsp; <span class=style3><b>* 아마존케어 서비스</b><br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;- 차량 정비 관련 유선 상담서비스 상시 제공<br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;- 대여 개시 2개월 이내 무상 정비대차 제공<%if(e_bean.getCar_comp_id().equals("0056")) {%>(테슬라차량 제외)<%}%><br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24시간 이상 정비공장 입고시)<br> 
                  		&nbsp;&nbsp;&nbsp;&nbsp;- 대여 개시 2개월 이후 원가 수준의 유상 정비대차 제공<br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(단기 대여요금의 15~30% 수준, 탁송료 별도)</span></td>
                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* 일체의 정비서비스</b><br>
                   		&nbsp;&nbsp;&nbsp;&nbsp;- 각종 내구성부품/소모품 점검, 교환, 수리<br>
                   		&nbsp;&nbsp;&nbsp;&nbsp;- 제조사 차량 취급설명서 기준<br>
                   		&nbsp; <b>* 정비대차서비스</b><br> 
                   		&nbsp;&nbsp;&nbsp;&nbsp;- 4시간 이상 정비공장 입고시</span></td>
                 	</tr>
         		</table>
         	</td>
        </tr>
          <tr> 
            <td height=7 colspan="2"></td>
          </tr>
          
          	<tr> 
	            <td colspan="2">
	            <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
	            <img src=../main_car_hp/images/bar_2022_08.jpg width=638 height=22>
	            <%}else{%>
	            <img src=../main_car_hp/images/bar_07_yj.gif width=638 height=22>
	            <%	}%>
	            </td>
			</tr>
			<tr> 
	            <td height=4 colspan="2"></td>
			</tr>
			<tr> 
	            <td colspan="2"> 
	            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
	            		<tr>
	            			<td align=center bgcolor=f2f2f2 height=15><span class=style3>중도해지위약금</span></td>
	            			<td colspan=2 bgcolor=ffffff> &nbsp;<span class=style3>중도해지시에는 잔여계약기간 총 대여료의 <b><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%>30<%}%>%</b> 의 위약금이 있음</span></td>
	            		</tr>
	            	</table>
	            </td>
			</tr>
          	<tr> 
		    	<td height=10 colspan="2"></td>
			</tr>
			<tr> 
		     	<td colspan="2">
		     	<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		     	<img src=../main_car_hp/images/bar_2022_09.jpg width=638 height=22>
		     	<%}else{%>
		     	<img src=../main_car_hp/images/bar_08.gif width=638 height=22>
		     	<%	}%>
		     	</td>
			</tr>			
          	<tr> 
            	<td height=4 colspan="2"></td>
         	</tr>
          	<tr> 
            <td colspan="2" align=center> <table width=621 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=20 height=15 align=right><img src=../main_car_hp/images/1.gif width=13 height=13 align=absmiddle></td>
                  <td width=8>&nbsp;</td>
                  <td width=593 colspan=2 align=left class=listnum2><span class=style3>자동차세 납부, 정기검사 
                    등도 아마존카에서 처리(고객 비용 부담 없음) </span></td>
                </tr>
                <tr> 
                  <td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
                </tr>
                <tr> 
                  <td height=15 align=right><img src=../main_car_hp/images/2.gif width=13 height=13 align=absmiddle></td>
                  <td>&nbsp;</td>
                  <td colspan=2 align=left class=listnum2><span class=style3>홈페이지에서 대여차량 유지관리내역 정보제공 [FMS(Fleet Management System)]</span></td>
                </tr>
                <tr> 
                  <td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
                </tr>
                <tr> 
                  <td height=15 align=right><img src=../main_car_hp/images/3.gif width=13 height=13 align=absmiddle></td>
                  <td>&nbsp;</td>
                  <td colspan=2 align=left class=listnum2><span class=style3>대여기간 만료시에는 반납, 연장이용<%if((e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) /* && !cm_bean.getDiesel_yn().equals("2") */ && AddUtil.parseInt(e_bean.getA_b()) >= 24){//기본식 && 비LPG && 24개월이상 %>, 매입옵션 행사<%}%> 중 선택 가능</span></td>
                </tr>
                <tr> 
                  <td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
                </tr>
                <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("21")){%>
                <!-- <tr> 
                  <td height=15 align=right class=listnum2><img src=../main_car_hp/images/4.gif width=13 height=13 align=absmiddle></td>
                  <td>&nbsp;</td>
                  <td colspan=2 align=left><span class=style3>계약기간 동안 
			                    아래금액의 이행(지급)보증보험 가입조건(신용우수업체 면제) </span></td>
                </tr> -->
                <tr> 
                  <td colspan=4><img src=/acar/main_car_hp/images/line_1.gif width=621 height=1></td>
                </tr>
                <tr> 
                  <td colspan=4 height=3></td>
                </tr>
                <%-- <%if (e_bean.getGi_fee() > 0) {%>
			  	<tr>
					<td colspan=4 align=right style="font-weight: bold;">※ 신용등급 <%=e_bean.getGi_grade()%>등급기준</td>
			  	</tr>
			  	<%}%> --%>
                <tr> 
                  <td height=24>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td width=17><img src=/acar/main_car_hp/images/arrow_1.gif width=10 height=6></td>
                  <td width=569 align=left> 
                  <%-- <table width=569 border=0 cellpadding=0 cellspacing=0 background=/acar/main_car_hp/images/img_bg.gif>
                      <tr> 
                        <td colspan=3><img src=/acar/main_car_hp/images/img_up.gif width=569 height=5></td>
                      </tr>                      
                      <tr> 
                        <td width=15 height=15>&nbsp;</td>
                        <td width=270><img src=/acar/main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
                          <span class=style3>보증보험 가입금액</span><span class=style3> 
                          |</span> <span class=style3>
						              <%e_bean.setGi_amt(0);
						  	           	e_bean.setGi_fee(0);%>
						              <%=AddUtil.parseDecimal(e_bean.getGi_amt())%>원
                          </span></td>
                        <td width=284><img src=/acar/main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
                          <span class=style3>보증보험료(<%=e_bean.getA_b()%>개월치)</span><span class=style3> 
                          |</span> <span class=style3><%=AddUtil.parseDecimal(e_bean.getGi_fee())%> 
                          원</span></td>
                         <td width=284>
                        	<img src=/acar/main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
                          	<span class=style3>보증보험료(<%=e_bean.getA_b()%>개월치)</span>
                          	<span class=style3>|</span>
                          	<span class=style3>
                          		<%if (e_bean.getGi_amt() > 0) {%>
		                          	<%if (!e_bean.getGi_grade().equals("")) {%>
		                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;원
		                          	<%} else {%>
	                          			<span style="padding-left: 60px;">원</span>
		                          	<%}%>
	                          	<%} else {%>
	                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;원
	                          	<%}%>
                          	</span>
                        </td>
                      </tr>                      
                      <tr> 
                        <td colspan=3><img src=/acar/main_car_hp/images/img_dw.gif width=569 height=5></td>
                      </tr>
                    </table> --%>
                    </td>
                </tr>
                <%-- <%if (e_bean.getGi_amt() > 0) {%>
			  	<tr>
					<td colspan=4 align=right>※ 신용등급별로 보증보험료가 달라집니다.</td>
			  	</tr>
			  	<%}%> --%>
                <%}%>
              </table></td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <tr> 
            <td align=right><img src=/acar/main_car_hp/images/ceo.gif>&nbsp;</td>
            <td align=right>&nbsp;&nbsp;</td>
          </tr>
          <tr> 
            <td height=3 colspan="2"></td>
          </tr>
        </table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
<tr bgcolor=80972e>
        <td height=3 colspan=3></td>
    </tr>
</table>	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
</body>
<script language="JavaScript" type="text/JavaScript">
function IE_Print(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 14.0; //좌측여백   
factory.printing.rightMargin = 10.0; //우측여백
<%if(mail_yn.equals("")){%>
<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
factory.printing.topMargin = 0.0; //상단여백    
factory.printing.bottomMargin = 0.0; //하단여백
<%	}else{%>
factory.printing.topMargin = 0.0; //상단여백    
factory.printing.bottomMargin = 0.0; //하단여백
<%	}%>
<%}else{%>
factory.printing.topMargin = 0.0; //상단여백    
factory.printing.bottomMargin = 0.0; //하단여백
<%}%>
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}
</script>	
</html>