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
<title>Cash flow 비교</title>
<style type="text/css">
<!--
.style6 {color: #9b8c69}
.style7 {color: #515151}
.style9 {color: #343434}
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
	    <td height=15></td>
	</tr>
	<tr>
		<td><img src=/acar/main_car_hp/images/bar_03.gif border=0></td>
	</tr>
	<tr>
        <td align=right height=18 class=listnum2 valign=bottom><font color=828282>[<%=car_name%> 기준 (단위:원)]</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td align=center>
            <table width=665 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>                    
	<tr>
	    <td align=center>
	        <table width=665 border=0 cellpadding=0 cellspacing=1 bgcolor=c3b696>
                <tr align=center bgcolor=#FFFFFF>
                    <td width=46 rowspan=2 bgcolor=f0e6ca><font color=6c5d3b>경과<br>개월수</font></td>
                    <td height=35 colspan=6 bgcolor=f0e6ca><font color=6c5d3b><%=e_bean.getA_b()%>개월 할부구입</font></td>
                    <td colspan=2 bgcolor=f0e6ca><font color=6c5d3b>아마존카 <br>
		              <%=name%>
					  (<%=e_bean.getA_b()%>개월)</font></td>
                </tr>
                <tr bgcolor=#FFFFFF>
                    <td width=74 height=40 align=center bgcolor=ffffff><font color=6c5d3b>초기비용/<br>할부금</font></td>
                    <td width=79 align=center bgcolor=ffffff><font color=6c5d3b>보험료/<br>중고차 매각</font></td>
                    
          <td width=68 align=center bgcolor=ffffff><font color=6c5d3b>자동차세/<br>
            환경개선<br>
            부담금 </font></td>
                    <td width=68 align=center bgcolor=ffffff><font color=6c5d3b>사고처리<br>사고대차</font></td>
                    <td width=72 align=center bgcolor=ffffff><font color=6c5d3b>월별비용</font></td>
                    <td width=81 align=center bgcolor=fdf9e9><font color=6c5d3b>월별비용 누계</font></td>
                    <td width=83 align=center bgcolor=fdf9e9><font color=6c5d3b>월별비용 누계</font></td>
                    <td width=84 align=center bgcolor=fdf9e9><font color=6c5d3b>할부구입 대비</font></td>
                </tr>
				<%
				long amt1=0, amt2=0, amt3=0, amt4=0, mon_tot_amt=0, sum_amt=0, ama_sum_amt=0, last_amt=0, tot_amt1=0, tot_amt2=0, tot_amt3=0, tot_amt4=0, tot_amt5=0, tot_last_amt=0;
				for(int i=0; i<AddUtil.parseInt(e_bean.getA_b())+1; i++){
					
					//초기비용/할부금
					if(i==0)						amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("I79")));	//구입단계 제비용
					else							amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("O71")));	//월할부금
					
					tot_amt1 += amt1;
					
					//보험료/중고차매각
					if(i==0||i==12||i==24)			amt2 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O80")))*0.75f);
					else if(i==5||i==17||i==29)		amt2 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O80")))*0.25f);
					else if(i==36)					amt2 = -AddUtil.parseLong(String.valueOf(sh_comp.get("I90")));
					else							amt2 = 0;
					
					tot_amt2 += amt2;
					
					//자동차세/환경개선부담금
					if(i>0 && i%6==0)									amt3 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O82")))/2.0);
					else if(i==3||i==9||i==15||i==21||i==27||i==33) 	amt3 = AddUtil.parseLong(String.valueOf(sh_comp.get("I83")));
					else												amt3 = 0;
					
					tot_amt3 += amt3;
					
					//사고처리/사고대차
					if(i>0)							amt4 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O84")))/12.0)+AddUtil.parseLong(String.valueOf(sh_comp.get("O85")));
					
					tot_amt4 += amt4;
					
					//월별비용합계
					mon_tot_amt =	amt1+amt2+amt3+amt4;
					
					tot_amt5 += mon_tot_amt; 
					
					//월별비용누계
					sum_amt += mon_tot_amt;
					
					//아마존카 비용누계
					if(i==0)						ama_sum_amt += AddUtil.parseLong(String.valueOf(sh_comp.get("AE79")));
					else if(i==36)					ama_sum_amt += (e_bean.getFee_s_amt() - e_bean.getGtr_amt()); 
					else							ama_sum_amt += e_bean.getFee_s_amt();
					
					//할부구입대비
					last_amt = ama_sum_amt - sum_amt;
					tot_last_amt += last_amt;
					
				 %>
                <tr bgcolor=#FFFFFF>
                    <td height=18 align=center class=listnum2 bgcolor=fdf9e9><span class=style6><b><%= i %></b></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt1) %>&nbsp;</span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt2) %>&nbsp;</span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt3) %>&nbsp;</span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt4) %>&nbsp;</span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(mon_tot_amt) %>&nbsp;</span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimalLong(sum_amt) %>&nbsp;</span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimal(ama_sum_amt) %>&nbsp;</span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimal(last_amt) %>&nbsp;</span></td>
                </tr>
				<% } %>				
                <tr bgcolor=#FFFFFF>
                    <td height=30 align=center bgcolor=f0e6ca><font color=6c5d3b>합 계</font></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt1) %></b>&nbsp;</span></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt2) %></b>&nbsp;</span></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt3) %></b>&nbsp;</span></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimalLong(tot_amt4) %></b>&nbsp;</span></td>
                    <td align=right bgcolor=fdf9e9><span class=style7><b><%= AddUtil.parseDecimal(tot_amt5) %></b>&nbsp;</span></td>
                    
          <td align=right bgcolor=fdf9e9><span class=style9>&nbsp;</span></td>
                    
          <td align=right bgcolor=fdf9e9><span class=style9>&nbsp;</span></td>
                    <td align=right>&nbsp;</td>
                </tr>
                <tr bgcolor=#FFFFFF>
                    <td height=30 align=center bgcolor=f0e6ca><font color=6c5d3b>3년평균</font></td>
                    <td align=right>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td align=right>&nbsp;</td>
                    <td><span class=style9></span></td>
                    <td><span class=style9></span></td>
                    <td align=right><font color=e60011><b><%= AddUtil.parseDecimal(tot_last_amt/AddUtil.parseInt(e_bean.getA_b())) %></b>&nbsp;</font></td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
        <td align=center>
            <table width=665 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>            
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
	    <td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/cashflow_1.gif></td>
	</tr>
	<tr>
	    <td align=center>
	        <table width=635 border=0 cellspacing=0 cellpadding=0>
	            <tr>
	                <td><img src=/acar/main_car_hp/images/cashflow_up.gif></td>
	            </tr>
	            <tr>
	                <td bgcolor=f0f0f0>
	                    <table width=635 border=0 cellspacing=0 cellpadding=0 background=/acar/main_car_hp/images/cashflow_bg.gif>
	                        <tr>
	                            <td width=26 height=30></td>
	                            <td width=180><font color=585858><b><%= AddUtil.parseDecimal(tot_last_amt/AddUtil.parseInt(e_bean.getA_b())*-1) %> × 9% × 3(년) =</b></font></td>
	                            <td width=429 align=left>
	                                <table width=100 cellpadding=0 cellspacing=1 bgcolor=f13cbc>
	                                    <tr>
	                                        <td bgcolor=FFFFFF height=23 align=right><b><font color=585858><font color=f13cbc><%= AddUtil.parseDecimal(Math.round(tot_last_amt/AddUtil.parseInt(e_bean.getA_b())*-1*0.09f*3)) %> </font>원</font></b>&nbsp;</td>
	                                    </tr>
	                                </table>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
	                <td><img src=/acar/main_car_hp/images/cashflow_dw.gif></td>
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