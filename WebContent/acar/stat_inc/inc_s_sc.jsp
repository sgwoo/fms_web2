<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.stat_inc.*"%>

<%@ include file="/acar/cookies.jsp" %>

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
	}
	
}
function ExpLoad()
{
	var theForm = document.ExpLoadForm;
	theForm.submit();
}
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=900px, height=250px");
		document.form1.action="inc_s_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td><iframe src="./inc_s_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>" name="ExpList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > </iframe></td>
		</tr>							
	  </table>
	</td>
  </tr>
</table>
</body>
</html>
