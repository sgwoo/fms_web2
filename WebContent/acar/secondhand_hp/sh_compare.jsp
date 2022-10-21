<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.secondhand.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	if(from_page.equals("secondhand")){
		e_bean = e_db.getEstimateCase(est_id);
	}else{
		e_bean = e_db.getEstimateShCase(est_id);
	}
	
	//잔가 차량정보
	Hashtable sh_comp = new Hashtable();
	if(from_page.equals("secondhand")){
		sh_comp = shDb.getShCompare(est_id);
	}else{
		sh_comp = shDb.getShCompareSh(est_id);
	}
	
	
	String car_mng_id 	= e_bean.getMgr_nm();
	
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
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 		= String.valueOf(ht.get("OPT"));
	String colo		 		= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	
	String name = "";
	if(e_bean.getA_a().equals("11")) name = "오토리스 일반식";
	if(e_bean.getA_a().equals("12")) name = "오토리스 기본식";
	if(e_bean.getA_a().equals("21")) name = "장기렌트 일반식";
	if(e_bean.getA_a().equals("22")) name = "장기렌트 기본식";
%>	

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>항목별 비교</title>
<style type="text/css">
<!--
.style1 {color: #507a23}
.style2 {color: #507A23}
.style3 {color: #8a7953}
.style4 {color: #262626}
.style5 {color: #375616}
.style6 {color: #787878;
		font-size:11px;}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
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

function show_compare(arg){
	if(arg=='2'){
		location.href = "./sh_compare.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='3'){
		location.href = "./sh_cash_flow.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='4'){
		location.href = "./sh_cost_all.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}
}

//-->
		
</script>

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td><img src=/acar/main_car_hp/images/bar_compare_1.gif border=0 usemap=#map></td>
	</tr>
	<map name=Map>
    <area shape=rect coords=585,8,677,36 href=javascript:onprint();>
	</map>
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
		<td><img src=/acar/main_car_hp/images/bar_02.gif border=0></td>
	</tr>
	<tr>
		<td>
		    <table width=700 border=0 cellspacing=0 cellpadding=0>
		        <tr>
		            <td width=25>&nbsp;</td>
		            <td width=650>
		                <table width=650 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td align=right height=15 valign=bottom>[단위:원]</td>
		                    </tr>
		                    <tr>
		                        <td height=2 bgcolor=c3b696></td>
		                    </tr>
		                    <tr>
		                        <td>
            		                <table width=650 border=0 cellpadding=0 cellspacing=1 bgcolor=c3b696>
                    <tr bgcolor=#FFFFFF> 
                      <td colspan=4 rowspan=2 align=center bgcolor=f0e6ca><font color=867349><b>구 
                        분</b></font> </td>
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><font color=867349><b><%=e_bean.getA_b()%>개월 
                        할부구입</b></font> </td>
                      <td width=127 rowspan=2 align=center bgcolor=f0e6ca><font color=867349><b>아마존카<br>
					    <%=name%>
                        <br>
                        (<%=e_bean.getA_b()%>개월) </b></font> </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td width=91 height=23 align=center bgcolor=f0e6ca>총비용(<%=e_bean.getA_b()%>개월)</td>
                      <td colspan=2 align=center bgcolor=f0e6ca>산 출 기 준</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td width=22 rowspan=3><span class=style3></span></td>
                      <td height=19 colspan=3 align=center><span class=style3>차량가격</span></td>
                      <td>&nbsp;<%=sh_comp.get("I67")%></td>
                      <td width=91 align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O67")))%>&nbsp;</span></td>
                      <td width=189 rowspan=3 align=center><span class=style1><%=car_name%></span></td>
                      <td rowspan=5>&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>탁 
                        송 료</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O68")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>총차량가격</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O69")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>할 
                        부 원 금</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O70")))%>&nbsp;</span></td>
                      <td align=center><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>원 
                        </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>월 
                        할 부 금</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O71")))%>/월&nbsp;</span></td>
                      <td align=center>이자율 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO70"))*10000)/100f %>%</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=16 align=center bgcolor=f0e6ca><b><span class=style3>구<br>
                        <br>
                        입<br>
                        <br>
                        및<br>
                        <br>
                        유<br>
                        <br>
                        지</span></b></td>
                      <td width=22 rowspan=8 align=center><span class=style3>구<br>
                        <br>
                        입</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>초기 선납금</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>&nbsp;</span></td>
                      <td align=center>총차가의 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O72"))*1000)/10f %>%</td>
                      <td align=center>= 총차량가격 - 할부원금</td>
                      <td rowspan=7 align=right valign=bottom>
                        <%=sh_comp.get("AK78")%>
                        &nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>할부수수료</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I73")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>할부원금 × <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO72"))*1000)/10f %>% 
                      </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>인 
                        지 대</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I74")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>차입인지대</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td width=67 colspan=2 height=19 align=center><span class=style3>통합취득세</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I75")))%>&nbsp;</span></td>
                      <td align=right><%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O75"))*1000)/10f %>%&nbsp;</td>
                      <td align=center></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>공채할인</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I76")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>공채할인매도(할인율 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO77"))*1000)/10f %>%) 
                      </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>부대비용</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I77")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>번호판대 + 증지대 + 등록대행료 등</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>취득세</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I78")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>취득세(<%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O78"))*1000)/10f %>%) <%if(!e_bean.getCar_comp_id().equals("")){%>30일 이내 납부<%}%></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=2 align=center bgcolor=fdf9e9><span class=style3>구입단계 
                        제비용</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I79")))%>&nbsp;</span></td>
                      <td colspan=2 align=center><span class=style2>
                        </span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE79")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=7 align=center><span class=style3>유<br>
                        <br>
                        지</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>보 
                        험 금 </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I80")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O80")))%>/년&nbsp;</span></td>
                      <td align=center>법인업무용 종합보험(삼성화재) </td>
                      <td rowspan=6 align=right>월대여료(VAT포함)&nbsp;<br> <%= AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()) %>/월&nbsp;<br>
                        <br><br><br>
                        ※ 추가비용 없이 좌측&nbsp;<br>
                        의 해당서비스 제공&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>할 
                        부 금 </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I81")))%>&nbsp;</span></td>
                      <td><span class=style4></span></td>
                      <td align=center>= 월할부금 × 할부개월수 </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>자동차세</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I82")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O82")))%>/년&nbsp;</span></td>
                      <td align=center>이용기간 년평균 자동차세</td>
                    </tr>
                    <tr bgcolor=#FFFFFF>
                      <td height=19 colspan=2 align=center><span class=style3>환경개선부담금</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I83")))%></span>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O83")))%>/년</span>&nbsp;</td>
                      <td align=center>경유자동차에 부과 (3,9월 납입)</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=35 colspan=2 align=center><span class=style3>사고처리 
                        및 <br>
                        사고대차</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I84")))%></span>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O84")))%>/년&nbsp;</span></td>
                      <td align=center>아마존카 전상품 기본 제공서비스<br>
                        (자차, 가해사고시에도 무료대차) </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td colspan=2 align=center height=35><span class=style3>정비관리 
                        일체 <br>
                        및 정비대차</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I85")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O85")))%>/월&nbsp;</span></td>
                      <td align=center>아마존카 일반식상품 제공서비스 </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=2 align=center bgcolor=fdf9e9><span class=style3>유지단계 
                        제비용</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I86")))%>&nbsp;</span></td>
                      <td colspan=2>&nbsp;</td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE86")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><b><span class=style3>구입/유지총비용(ⓐ)</span></b></td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I87")))%>&nbsp;</span></td>
                      <td colspan=2 bgcolor=f0e6ca>&nbsp;</td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE87")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=3 bgcolor=f0e6ca><span class=style3></span></td>
                      <td height=19 colspan=3 align=center><span class=style3>중고차 
                        매각 가격</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I88")))%>&nbsp;</span></td>
                      <td colspan=2 align=center>중고차가격의 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO86"))*1000)/10f %>%에 매각</td>
                      <td rowspan=2 align=right>보증금 환불액&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>매각 
                        부가세</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I89")))%>&nbsp;</span></td>
                      <td colspan=2 align=center>매각시 매각가격의 10% 부가세 납입해야 함</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><b><span class=style3>중고차매각수입(ⓑ) 
                        </span></b></td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I90")))%>&nbsp;</span></td>
                      <td colspan=2 align=center bgcolor=f0e6ca>= 중고차 매각 가격 - 
                        매각 부가세</td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE90")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=39 colspan=4 align=center><b><span class=style3><%=e_bean.getA_b()%>개월 
                        차량 이용에 <br>
                        따른 순비용</span></b></td>
                      <td align=right><b><font color=1555be><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I91")))%>&nbsp;</font></b></td>
                      <td colspan=2 align=center>= ⓐ - ⓑ </td>
                      <td align=right><b><font color=1555be><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%>&nbsp;</font></b></td>
                    </tr>
                  </table>
                                </td>
                            </tr>
                            <tr>
		                        <td height=2 bgcolor=c3b696></td>
		                    </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=650 border=0 cellspacing=0 cellpadding=0>
            		                    <tr>
            		                        <td width=415>&nbsp;</td>
            		                        <td width=235 background=/acar/main_car_hp/images/c_compare_bg.gif align=right height=30><b><font color=FFFFFF>할부구입 대비 :</font>
            		                        <font color=e9fe01><%if(AddUtil.parseInt((String)sh_comp.get("AE93"))>0){%>+<%}%><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE93")))%></font></b>&nbsp;&nbsp;&nbsp;</td>
            		                    </tr>
            		                </table>
                                </td>
                            </tr>
                            <tr>
                                <td align=right><img src=/acar/main_car_hp/images/c_compare_01.gif></td>
                            </tr>
                            <tr>
                                <td align=right>
                                    <table width=636 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=307 valign=top>
                                                <table width=307 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_1.gif></td>
                                                    </tr>
                                                    <tr>
                                                        <td align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom><img src=/acar/main_car_hp/images/c_compare_03.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=76 align=center height=21 class=listnum3><font color=262626>2억이하</font></td>
                                                                                <td width=62 align=center class=listnum3><font color=262626>11.0%</font></td>
                                                                                <td width=74 align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td width=89 align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.11)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>200억 이하</font></td>
                                                                                <td align=center class=listnum3><font color=262626>22.0%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.22)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>200억 초과</font></td>
                                                                                <td align=center class=listnum3><font color=262626>24.2%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.242)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>      
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align=left height=45><span class=style6>&nbsp;* 차량구입 이용시에도 대부분 비용처리가 가능하나, <br>&nbsp;&nbsp;&nbsp;회계처리가 매우 복잡합니다.</span></td>
                                                    </tr>
                                                </table>
                                            <td width=23>&nbsp;</td>
                                            <td width=309 align=left>
                                                <table width=309 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_2.gif></td>
                                                    </tr>
                                                    <tr>
                                                        <td align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom align=center><img src=/acar/main_car_hp/images/c_compare_03_1.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=87 align=center height=21 class=listnum3><font color=262626>4600만원 이하</font></td>
                                                                                <td width=62 align=center class=listnum3><font color=262626>16.5%</font></td>
                                                                                <td width=72 align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;&nbsp;</td>
                                                                                <td width=80 align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.165)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>8800만원 이하</font></td>
                                                                                <td align=center class=listnum3><font color=262626>26.4%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.264)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1억5천만원 이하</font></td>
                                                                                <td align=center class=listnum3><font color=262626>38.5%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.385)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1억5천만원 초과</font></td>
                                                                                <td align=center class=listnum3><font color=262626>41.8%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.418)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>      
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=45><span class=style6>&nbsp;* 차량구입 이용시 손비처리가 안 될 경우도 있으나, <br>&nbsp;&nbsp;&nbsp;장기렌트/오토리스 이용시에는 쉽게 손비처리 가능<br>&nbsp;&nbsp;&nbsp;합니다.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td><img src=/acar/main_car_hp/images/c_compare_02.gif></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td><img src=/acar/main_car_hp/images/c_compare_02_1.gif></td>
                            </tr>
                        </table>
		            </td>
		            <td width=25>&nbsp;</td>
		        </tr>
		    </table>
		</td>
	</tr>
	<tr>	
		<td align=center height=70>
		<a href="javascript:show_compare('2');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image2','','/acar/main_car_hp/images/button_02_01.gif',2)><img src=/acar/main_car_hp/images/button_02.gif name=Image2 border=0></a>&nbsp;
		<a href="javascript:show_compare('3');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image3','','/acar/main_car_hp/images/button_03_01.gif',2)><img src=/acar/main_car_hp/images/button_03.gif name=Image3 border=0></a>&nbsp;
		<a href="javascript:show_compare('4');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/main_car_hp/images/button_04_01.gif',2)><img src=/acar/main_car_hp/images/button_04.gif name=Image4 border=0></a>&nbsp;
		</td>
	</tr>
</table>
</body>
</html>