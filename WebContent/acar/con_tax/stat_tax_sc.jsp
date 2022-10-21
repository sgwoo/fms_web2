<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//스케줄관리 이동 - 납부일 기분
	function tax_pay(pay_dt){
		var fm = document.form1;
		//구버전
		/*
		fm.gubun1.value = "13";
		fm.gubun2.value = "4";
		fm.gubun3.value = "2";
		fm.gubun4.value = "";				
		fm.st_dt.value = est_dt;
		fm.end_dt.value = "";
		fm.s_kd.value = "";
		fm.t_wd.value = "";
		fm.action = "tax_frame_s.jsp";
		*/
		//신버전
		fm.gubun1.value = "2";
		fm.gubun2.value = "3";
		fm.gubun3.value = "";
		fm.gubun4.value = "";				
		fm.gubun5.value = pay_dt.substr(0,4);				
		fm.gubun6.value = "";				
		fm.gubun7.value = pay_dt.substr(4,2);
		fm.st_dt.value = "";
		fm.end_dt.value = "";
		fm.s_kd.value = "";
		fm.t_wd.value = "";
		fm.action = "/fms2/con_tax/tax_m_frame.jsp";		
		
		fm.target = "d_content";
		fm.submit();
	}	
	
	//스케줄관리 이동 - 사유발생일 기준
	function tax_pay2(est_dt, pay_dt){
		var fm = document.form1;
		//구버전
		/*
		fm.gubun1.value = "13";
		fm.gubun2.value = "4";
		fm.gubun3.value = "2";
		fm.gubun4.value = "";				
		fm.st_dt.value = est_dt;
		fm.end_dt.value = "";
		fm.s_kd.value = "";
		fm.t_wd.value = "";
		fm.action = "tax_frame_s.jsp";
		*/
		//신버전
		fm.gubun1.value = "1";
		fm.gubun2.value = "3";
		fm.gubun3.value = "";
		fm.gubun4.value = "";				
		fm.gubun5.value = pay_dt.substr(0,4);				
		fm.gubun6.value = "";				
		fm.gubun7.value = pay_dt.substr(4,2);
		fm.st_dt.value = "";
		fm.end_dt.value = "";
		fm.s_kd.value = "";
		fm.t_wd.value = "";
		fm.action = "/fms2/con_tax/tax_m_frame.jsp";		
		
		fm.target = "d_content";
		fm.submit();
	}	
		
	//일괄납부처리
	function tax_all_pay(com_ym, est_dt){
		var fm = document.form1;
		fm.est_dt.value = est_dt;
		fm.com_ym.value = com_ym;				
		fm.target = "d_content";
		fm.action = "tax_all_pay.jsp";
		fm.submit();
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_est_y = request.getParameter("s_est_y")==null?"":request.getParameter("s_est_y");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");

	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
%>
<form name='form1' action='/acar/con_tax/stat_tax_sc.jsp' target='' method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
<input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
<input type='hidden' name='gubun7' 	value='<%=gubun7%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='est_mon' value='<%=est_mon%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='est_dt' value=''>
<input type='hidden' name='com_ym' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  <tr>
	<td>
	  <iframe src="/acar/con_tax/stat_tax_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&s_brch=<%=s_brch%>&s_est_y=<%=s_est_y%>" name="i_no" width="100%" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>
	</td>
  </tr>
  <!--
  <tr>
	<td>&nbsp;</td>
  </tr>  
  <tr>
	<td>
	  <iframe src="/acar/con_tax/stat_tax_sc_in2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&s_brch=<%=s_brch%>&s_est_y=<%=s_est_y%>" name="i_no" width="800" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>
	</td>
  </tr>-->
</table>
</form>
</body>
</html>