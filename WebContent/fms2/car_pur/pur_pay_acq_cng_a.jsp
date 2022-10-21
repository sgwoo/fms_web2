<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	boolean flag1 = true;
	
	
%>


<%
	String vid1[] 	= request.getParameterValues("rent_mng_id");
	String vid2[] 	= request.getParameterValues("rent_l_cd");
	String vid3[] 	= request.getParameterValues("acq_cng_yn");
	String vid4[] 	= request.getParameterValues("cpt_cd");
	String vid_num		= "";
	
	int vid_size = vid1.length;
	
//	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		//car_pur
		ContPurBean pur = a_db.getContPur(vid1[i], vid2[i]);
		pur.setAcq_cng_yn	(vid3[i]);
		pur.setCpt_cd		(vid4[i]);
		
		if(pur.getAcq_cng_yn().equals("N")){
			pur.setCpt_cd	("");
		}
		
		//=====[CAR_PUR] update=====
		flag1 = a_db.updateContPur(pur);
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_pay_frame.jsp';
	fm.target = 'd_content';
	fm.submit();
	
	parent.window.close();
</script>
</body>
</html>