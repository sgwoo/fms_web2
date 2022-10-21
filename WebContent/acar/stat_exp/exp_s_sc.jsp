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
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
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
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="exp_s_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='st' value='<%=st%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./exp_s_sc_in.jsp?auth_rw=<%=auth_rw%>&st=<%=st%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="ExpList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							

			</table>
		</td>
	</tr>
</table>
</body>
</html>
