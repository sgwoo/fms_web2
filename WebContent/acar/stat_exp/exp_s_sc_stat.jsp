<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.stat_exp.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	StatExpDatabase sed = StatExpDatabase.getInstance();
	String car_mng_id = "";
	String rent_mng_id = "";
	String rent_l_cd = "";
	String gubun = "";
	String gubun_nm = "";
	String st = "0";
	String dt = "1";
	String ref_dt1 = "00000000";
	String ref_dt2 = "99999999";
	String auth_rw = "";

	
	if(request.getParameter("car_mng_id") != null)	car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("rent_mng_id") != null)	rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null)	rent_l_cd= request.getParameter("rent_l_cd");
	if(request.getParameter("gubun") != null)	gubun= request.getParameter("gubun");
	if(request.getParameter("gubun_nm") != null)	gubun_nm= request.getParameter("gubun_nm");
	if(request.getParameter("st") != null)	st = request.getParameter("st");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
		
	//StatExpBean se_r [] = sed.getExpAll(st,dt,ref_dt1,ref_dt2);
	String [] ecst = sed.getExpConSta2(gubun,gubun_nm,st,dt,ref_dt1,ref_dt2);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

function ExpProc(name,gubun,d_gubun,rent_mng_id,rent_l_cd,car_mng_id,client_nm,firm_nm,car_name,car_no,plan_dt,amt,coll_dt)
{
	var theForm = document.ExpProcForm;
	var auth_rw = "";
	/*
	theForm.name.value = name;
	theForm.gubun.value = gubun;
	theForm.d_gubun.value = d_gubun;
	*/
	
	/*
	theForm.client_nm.value = client_nm;
	theForm.firm_nm.value = firm_nm;
	theForm.car_name.value = car_name;
	theForm.car_no.value = car_no;
	theForm.plan_dt.value = plan_dt;
	theForm.amt.value = amt;
	theForm.coll_dt.value = coll_dt;
	*/
	auth_rw = theForm.auth_rw.value; 
	if(name=="과태료/범칙금")
	{
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.car_mng_id.value = car_mng_id;
		theForm.seq_no.value = gubun;
		theForm.target="d_content";
		theForm.submit();
	}else if(name=="보험료"){
	var SUBWIN="./exp_ins_id.jsp?auth_rw=" + auth_rw 
				+ "&rent_mng_id=" + rent_mng_id
				+ "&rent_l_cd=" + rent_l_cd 
				+ "&car_mng_id=" + car_mng_id; 
	window.open(SUBWIN, "ExpIns", "left=100, top=100, width=820, height=430, scrollbars=no");
	}else if(name=="취득세"){
	var SUBWIN="./exp_acq_id.jsp?auth_rw=" + auth_rw 
				+ "&rent_mng_id=" + rent_mng_id
				+ "&rent_l_cd=" + rent_l_cd 
				+ "&car_mng_id=" + car_mng_id; 
	window.open(SUBWIN, "ExpAcq", "left=100, top=100, width=820, height=220, scrollbars=no");
	}else if(name=="할부금"){
	var SUBWIN="./exp_debt_id.jsp?auth_rw=" + auth_rw 
				+ "&rent_mng_id=" + rent_mng_id
				+ "&rent_l_cd=" + rent_l_cd 
				+ "&car_mng_id=" + car_mng_id
				+ "&alt_tm=" + gubun; 
	window.open(SUBWIN, "ExpAcq", "left=100, top=100, width=820, height=220, scrollbars=no");
	}
}
function ExpLoad()
{
	var theForm = document.ExpLoadForm;
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 영업비용관리 > <span class=style1><span class=style5>지출스케줄현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
        <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
	        	<tr>
	    		    <td class=line>			            
			            <table border=0 cellspacing=1 width=100%>
			            	<tr>
			            		<td rowspan=2 width=15% class=title>구분</td>
			            		<td colspan=2 class=title>할부금</td>
			            		<td colspan=2 class=title>보험료</td>
			            		<td colspan=2 class=title>과태료</td>
			            		<td colspan=2 class=title>취득세</td>
			            		<td colspan=2 class=title>합계</td>
	 		
			            	</tr>
			            	<tr>
			            		<td width=7% class=title>건수</td>
			            		<td width=10% class=title>금액</td>
			            		<td width=7% class=title>건수</td>
			            		<td width=10% class=title>금액</td>
			            		<td width=7% class=title>건수</td>
			            		<td width=10% class=title>금액</td>
			            		<td width=7% class=title>건수</td>
			            		<td width=10% class=title>금액</td>
			            		<td width=7% class=title>건수</td>
			            		<td width=10% class=title>금액</td>
	 		
			            	</tr>
			            	<tr>
			            		<td class=title>지출</td>
			            		<td align="right"><%=ecst[18]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[19])%> 원 </td>
			            		<td align="right"><%=ecst[6]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[7])%> 원 </td>
			            		<td align="right"><%=ecst[0]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[1])%> 원 </td>
			            		<td align="right"><%=ecst[12]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[13])%> 원 </td>
			            		<td align="right"><%=ecst[24]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[25])%> 원 </td>
			            	</tr>
			            	<tr>
			            		<td class=title>미지출</td>
			            		<td align="right"><%=ecst[20]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[21])%> 원 </td>
			            		<td align="right"><%=ecst[8]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[9])%> 원 </td>
			            		<td align="right"><%=ecst[2]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[3])%> 원 </td>
			            		<td align="right"><%=ecst[14]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[15])%> 원 </td>
			            		<td align="right"><%=ecst[26]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[27])%> 원 </td>
			            	</tr>
			            	<tr>
			            		<td class=title>합계</td>
			            		<td align="right"><%=ecst[22]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[23])%> 원 </td>
			            		<td align="right"><%=ecst[10]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[11])%> 원 </td>
			            		<td align="right"><%=ecst[4]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[5])%> 원 </td>
			            		<td align="right"><%=ecst[16]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[17])%> 원 </td>
			            		<td align="right"><%=ecst[28]%> 건 </td>
			            		<td align="right"><%=Util.parseDecimal(ecst[29])%> 원 </td>
			            	</tr>
			            </table>
			        </td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
	    <td align="right">
	        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
    </tr>  
</table>
</body>
</html>
