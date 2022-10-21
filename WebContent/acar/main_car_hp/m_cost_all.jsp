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
	if(e_bean.getA_a().equals("11")) name = "오토리스 일반식";
	if(e_bean.getA_a().equals("12")) name = "오토리스 기본식";
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

<%	//캐시플로우 계산
	
	long amt1=0, amt2=0, amt3=0, amt4=0, mon_tot_amt=0, sum_amt=0, ama_sum_amt=0, last_amt=0, tot_amt1=0, tot_amt2=0, tot_amt3=0, tot_amt4=0, tot_amt5=0, tot_last_amt=0;
	
				double d_amt4 =0;
				double d_mon_tot_amt =0;
				double d_sum_amt =0;
				double d_last_amt =0;
				double d_tot_amt4 =0;
				double d_tot_amt5 =0;
				double d_tot_last_amt =0;
					
	for(int i=0; i<AddUtil.parseInt(e_bean.getA_b())+1; i++){
		
		//초기비용/할부금
		if(i==0)					amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("I79")));	//구입단계 제비용
		else							amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("O71")));	//월할부금
		tot_amt1 += amt1;
		
		//보험료/중고차매각
		if(i==0||i==12||i==24||i==36||i==48){
			amt2 = AddUtil.parseLong(String.valueOf(sh_comp.get("O80")));
		}else{
			amt2 = 0;
		}
		if(i==AddUtil.parseInt(e_bean.getA_b()))	amt2 = -AddUtil.parseLong(String.valueOf(sh_comp.get("I90")));
			
		tot_amt2 += amt2;
		
		//자동차세/환경개선부담금
		if(i>0 && i%6==0)																	amt3 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O82")))/2.0);
		else if(i==3||i==9||i==15||i==21||i==27||i==33) 	amt3 = AddUtil.parseLong(String.valueOf(sh_comp.get("I83")));
		else																							amt3 = 0;
		tot_amt3 += amt3;
		
		//사고처리/사고대차
		if(i>0)							amt4   = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O84")))/12.0)+AddUtil.parseLong(String.valueOf(sh_comp.get("O85")));
		if(i>0)							d_amt4 = AddUtil.parseDouble(String.valueOf(sh_comp.get("O84")))/12+AddUtil.parseDouble(String.valueOf(sh_comp.get("O85")));
		
		tot_amt4 += amt4;
		d_tot_amt4 += d_amt4;
		
		//월별비용합계(초기비용/할부금+보험료/중고차매각+자동차세/환경개선부담금+사고처리/사고대차)
		mon_tot_amt = amt1+amt2+amt3+amt4;
		d_mon_tot_amt = amt1+amt2+amt3+d_amt4;
		
		tot_amt5 += mon_tot_amt; 
		d_tot_amt5 += d_mon_tot_amt; 
		
		//월별비용누계
		sum_amt += mon_tot_amt;
		d_sum_amt += d_mon_tot_amt;
		
		//아마존카 비용누계
		if(i==0)																			ama_sum_amt += AddUtil.parseLong(String.valueOf(sh_comp.get("AE79")));
		else if(i==AddUtil.parseInt(e_bean.getA_b()))	ama_sum_amt += (e_bean.getFee_s_amt()+e_bean.getFee_v_amt() - e_bean.getGtr_amt()); 
		else																					ama_sum_amt += e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
		
		//할부구입대비
		last_amt = ama_sum_amt - sum_amt;
		d_last_amt = ama_sum_amt - d_sum_amt;
		
		tot_last_amt += last_amt;
		d_tot_last_amt += d_last_amt;
	}
	
	long l214 = AddUtil.parseLong((String)sh_comp.get("AE93"));
	double d_l216 = d_tot_last_amt/(AddUtil.parseFloat(e_bean.getA_b())+1)*AddUtil.parseFloat((String)sh_comp.get("AO70"))*AddUtil.parseFloat(e_bean.getA_b())/12;
	long l216 = (long)Math.round(d_l216);
	long l218 = l214+l216;
%>
				 
<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>비용절감 효과 합계</title>
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
	    <td height=30></td>
	</tr>
	<tr>
		<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:'나눔고딕'; font-size:17px; font-weight:bold; color:#2d5403;">▶ 비용절감 효과 합계</span></td>
	</tr>
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
        <td align=right height=20 class=listnum2><font color=828282>[<%=car_name%> 기준 (단위:원)]</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td align=center>
            <table width=655 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>            
	<tr>
	    <td align=center>
	        <table width=655 border=0 cellspacing=1 cellpadding=0 bgcolor=c3b696>
        <tr> 
          <td bgcolor=f0e6ca height=45 width=150></td>
          <td width=165 align="center" bgcolor=f0e6ca><font color=534524><b>할부구입대비</b></font></td>
          <td width=281 align="center" bgcolor=f0e6ca><font color=534524><b>비 고</b></font></td>
        </tr>
        <tr> 
          <td height=55 align="center" bgcolor=fdf9e9><font color=6c5d3b>지출된 총 비용</font></td>
          <td bgcolor=FFFFFF><div align="right"><font color=515151><%if(AddUtil.parseInt((String)sh_comp.get("AE93"))>0){%>+<%}%><%=AddUtil.parseDecimal(l214)%>&nbsp;&nbsp;&nbsp;</font></div></td>
          <td align="center" bgcolor=FFFFFF><font color=4a7d0d>" 항목별 비용비교 " 결과</font></td>
        </tr>
        <tr> 
          <td height=45 align="center" bgcolor=fdf9e9><font color=6c5d3b>Cash Flow 차이에 따른 <br>
          이자 절감</font></td>
          <td bgcolor=FFFFFF><div align="right"><font color=515151><%=AddUtil.parseDecimal(l216)%>&nbsp;&nbsp;&nbsp;</font></div></td>
          <td align="center" bgcolor=FFFFFF><font color=4a7d0d>" Cash Flow 비교 " 결과</font></td>
        </tr>
        <tr> 
          <td height=60 align="center" bgcolor=fdf9e9><font color=6c5d3b><b>비용절감 합계</b></font></td>
          <td bgcolor=FFFFFF><div align="right"><font color=fc0bcc><b><%=AddUtil.parseDecimal(l218)%>&nbsp;&nbsp;&nbsp;</b></font></div></td>
          <td align="center" bgcolor=FFFFFF><font color=6c5d3b>아마존카 <%=name%> (<%=e_bean.getA_b()%>개월)</font></td>
        </tr>
      </table>
	    </td>
	</tr>
	<tr>
        <td align=center>
            <table width=655 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>            
	<tr>
	    <td height=15></td>
	</tr>
	<tr>	
		<td align=center height=70>
		<a href="javascript:show_compare('2');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image2','','/acar/main_car_hp/images/button_02_01.gif',2)><img src=/acar/main_car_hp/images/button_02.gif name=Image2 border=0></a>&nbsp;
		<a href="javascript:show_compare('3');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image3','','/acar/main_car_hp/images/button_03_01.gif',2)><img src=/acar/main_car_hp/images/button_03.gif name=Image3 border=0></a>&nbsp;
		<a href="javascript:show_compare('4');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/main_car_hp/images/button_04_01.gif',2)><img src=/acar/main_car_hp/images/button_04.gif name=Image4 border=0></a>&nbsp;
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
