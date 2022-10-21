<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	e_bean = e_db.getEstimateHpCase(est_id);
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
	}
	
	String a_a = "";
	String rent_way = "";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	String a_b 		= e_bean.getA_b();
	float o_13 		= 0;
	
	String name = "";
	if(e_bean.getA_a().equals("11")) name = "리스 일반식";
	if(e_bean.getA_a().equals("12")) name = "리스 기본식";
	if(e_bean.getA_a().equals("21")) name = "장기렌트 일반식";
	if(e_bean.getA_a().equals("22")) name = "장기렌트 기본식";
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean.getS_st();
	
	String car_name = cm_bean.getCar_nm()+" "+cm_bean.getCar_name();
	
	
	//잔가 차량정보
	Hashtable sh_comp = shDb.getShCompareHp(est_id);
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		sh_comp = shDb.getShCompare(est_id);
	}
	
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
.compare-content-box { background-color: #eeeeee; padding: 15px 25px; border-radius: 15px;	}
.compare-content-box .box-div { margin-top: -5px;	}
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
		location.href = "./m_compare.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='3'){
		location.href = "./m_cash_flow.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='4'){
		location.href = "./m_cost_all.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}
}

//-->
		
</script>
<!--구글 분석기 시작-->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-30468978-3', 'auto');
  ga('send', 'pageview');
</script>
<!--구글 분석기 종료-->
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td><img src=/acar/main_car_hp/images/bar_compare_2.gif border=0 usemap=#map></td>
	</tr>
	<map name=Map>
    <area shape=rect coords=585,8,677,36 href=javascript:onprint();>
	</map>
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
		<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:'나눔고딕'; font-size:17px; font-weight:bold; color:#2d5403;">▶ 항목별 비교</span></td>
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
                      <td rowspan=<%if(e_bean.getEcar_pur_sub_amt()>0){%>7<%}else{%>5<%}%>>&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>탁 
                        송 료</span></td>
                      <td align=center>서울기준</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O68")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>총차량가격</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O69")))%>&nbsp;</span></td>
                    </tr>
                    <%if(e_bean.getEcar_pur_sub_amt()>0){%>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3><%if(e_bean.getEcar_pur_sub_amt()>0){%>친환경차 구매보조금<%}%></span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>&nbsp;</span></td>
                      <td align=center></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3><%if(e_bean.getEcar_pur_sub_amt()>0){%>총차량가격-구매보조금<%}%></span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O69"))-e_bean.getEcar_pur_sub_amt())%>&nbsp;</span></td>
                      <td align=center></td>
                    </tr>                    
                    <%}%>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>할 
                        부 원 금</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O70")))%>&nbsp;</span></td>
                      <td align=center>메이커 선수금  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>원 
                        기준 </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>월 
                        할 부 금</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O71")))%>/월&nbsp;</span></td>
                      <td align=center>이자율 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO70"))*10000)/100f %>%</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=12 align=center bgcolor=f0e6ca><b><span class=style3>구<br>
                        <br>
                        입<br>
                        <br>
                        및<br>
                        <br>
                        유<br>
                        <br>
                        지</span></b></td>
                      <td width=22 rowspan=5 align=center><span class=style3>구<br>
                        <br>
                        입</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>메이커 
                        선수금</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>&nbsp;</span></td>
                      <td align=center>총차가의 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O72"))*1000)/10f %>%</td>
                      <td align=center></td>
                      <td rowspan=4 align=right valign=bottom>
                        <%=sh_comp.get("AK78")%>
                        &nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF>                       
                      <td width=67 colspan=2 height=19 align=center><span class=style3>통합취득세</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I75")))%>&nbsp;</span></td>
                      <td align=right>&nbsp;<%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O75"))*1000)/10f %>%&nbsp;</td>
                      <td></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>공채할인</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I76")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>공채할인매도(서울기준,할인율 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO77"))*1000)/10f %>%) 
                      </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>부대비용</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I77")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>번호판대 + 증지대 + 등록대행료 등</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=2 align=center bgcolor=fdf9e9><span class=style3>구입단계 
                        제비용</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I79")))%>&nbsp;</span></td>
                      <td colspan=2 align=center><span class=style2>&nbsp;</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE79")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=6 align=center><span class=style3>유<br>
                        <br>
                        지</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>보 
                        험 료 </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I80")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O80")))%>/년&nbsp;</span></td>
                      <td align=center>법인업무용 종합보험(DB손해보험) </td>
                      <td rowspan=5 align=right>월대여료(VAT포함)&nbsp;<br> <%= AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()) %>/월&nbsp;<br>
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
                      <td height=35 colspan=2 align=center><span class=style3>사고처리 
                        및 <br>
                        사고대차,<br>
                        자동차검사비
                        </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I84")))%></span>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O84")))%>/년&nbsp;</span></td>
                      <td align=center>아마존카 전상품 기본 제공서비스<br>
                        (자차, 가해사고시에도 무료대차),<br>
                        자동차 정기/종합 검사비용 포함 </td>
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
                      <td colspan=2 align=center>신차가격의 <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO86"))*1000)/10f %>%에 매각</td>
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
                                                        <td colspan='2' height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_1.gif></td>
                                                        <td align=right>(주민세 포함)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom><img src=/acar/main_car_hp/images/c_compare_03.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=76 align=center height=21 class=listnum3><font color=262626>2억 이하</font></td>
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
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* 차량구입 이용시에도 비용처리가 가능하나, <br>&nbsp;&nbsp;&nbsp;회계처리가 매우 복잡합니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* 승용차(경차,9인승 제외)의 경우 차량구입과 장기렌트/리스<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  모두 임직원 전용 자동차 보험을 가입하고, 법인세법상<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  손비처리 기준에 따라 손비처리 가능(당사 홈페이지<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  '업무용승용차 손비처리 기준' 참고)
                                                        	</span></td>
                                                    </tr>
                                                </table>
                                            <td width=23>&nbsp;</td>
                                            <td width=309 align=left>
                                                <table width=309 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan='2' height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_2.gif></td>
                                                        <td align=right>(주민세 포함)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom align=center><img src=/acar/main_car_hp/images/c_compare_03_1.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=88 align=center height=21 class=listnum3><font color=262626>4600만원 이하</font></td>
                                                                                <td width=58 align=center class=listnum3><font color=262626>16.5%</font></td>
                                                                                <td width=70 align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td width=85 align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.165)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>8800만원 이하</font></td>
                                                                                <td align=center class=listnum3><font color=262626>26.4%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.264)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1억5천만원 이하</font></td>
                                                                                <td align=center class=listnum3><font color=262626>38.5%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.385)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1억5천만원 초과</font></td>
                                                                                <td align=center class=listnum3><font color=262626>41.8%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.418)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>      
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' height=45><span class=style6>&nbsp;* 차량구입 이용시 손비처리가 안 될 경우도 있으나, <br>&nbsp;&nbsp;&nbsp;장기렌트/리스 이용시에는 쉽게 손비처리 가능 합니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* 승용차(경차,9인승 제외)의 경우 2016년 소득세법부터 적용<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  되고 있는 업무용승용차 손비처리 기준에 따라 손비처리 가능<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  (당사 홈페이지 '업무용승용차 손비처리 기준' 참고)
                                                        	</span></td>
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
                            <!-- <tr>
                                <td><img src=/acar/main_car_hp/images/c_compare_02_1.gif></td>
                            </tr> -->
                            <tr>    
                                <td>
                                	<div class="compare-content-box">
                                		<table width="100%">
                                			<tr>
                                				<td width="3%"><div class="box-div">1)</div></td>
                                				<td width="*">대여료 손비처리시 회계처리가 매우 간편합니다.(매월 발부되는 세금계산서 1장으로 비용처리 완료)</td>
                                			</tr>
                                			<tr>
                                				<td><div class="box-div">2)<br>&nbsp;</div></td>
                                				<td>차량구입 이용시 손비처리가 불가능하거나, 어려운 경우에도 쉽게 손비처리 할 수 있습니다.(개인사업자, 변호사 등)</td>
                                			</tr>
                                			<tr>
                                				<td><div class="box-div">3)<br>&nbsp;</div></td>
                                				<td>할부구입이나 일반 캐피탈사 리스 이용시 금융권 전산에 대출이 있는 것으로 처리 되지만, 아마존카 장기렌트/리스 이용시 대출로 잡히지 않습니다.</td>
                                			</tr>
                                		</table>
                                	</div>
                                </td>
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
		<a href="javascript:show_compare('4');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/main_car_hp/images/button_04_01.gif',2)><img src=/acar/main_car_hp/images/button_04.gif name=Image4 border=0></a>
		</td>
	</tr>
</table>

<!--Adgather Log Analysis v2.0 start-->
<script LANGUAGE="JavaScript" type="text/javascript">
<!--
     var domainKey = "1378270167211"
     var _localp = ""
     var _refererp = ""
     var _aday = new Date(); 
     var _fname = ""; 
     var _version = String(_aday.getYear())+String(_aday.getMonth()+1)+String(_aday.getDate())+String(_aday.getHours()); 
     document.write ("<"+"script language='JavaScript' type='text/javascript' src='"+document.location.protocol+"//logsys.adgather.net/adtracking.js?ver="+_version+"'>");
     document.write ("</"+"script>");
 //-->
 </script>
<!--Adgather Log Analysis v2.0 end-->


<!-- AceCounter Log Gathering Script V.71.2013012101 -->
<script language='javascript'>
if(typeof EL_GUL == 'undefined'){
var EL_GUL = 'dgc2.acecounter.com';var EL_GPT='8080'; var _AIMG = new Image(); var _bn=navigator.appName; var _PR = location.protocol=="https:"?"https://"+EL_GUL:"http://"+EL_GUL+":"+EL_GPT;if( _bn.indexOf("Netscape") > -1 || _bn=="Mozilla"){ setTimeout("_AIMG.src = _PR+'/?cookie';",1); } else{ _AIMG.src = _PR+'/?cookie'; };
document.writeln("<scr"+"ipt language='javascript' src='/acecounter/acecounter_V70.js'></scr"+"ipt>");
}
</script>
<noscript><img src='http://dgc2.acecounter.com:8080/?uid=AR5F38251710881&je=n&' border=0 width=0 height=0></noscript>
<!-- AceCounter Log Gathering Script End -->


</body>
</html>

<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>