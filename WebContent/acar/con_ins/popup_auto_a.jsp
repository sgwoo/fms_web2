<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String size = request.getParameter("size")==null?"0":request.getParameter("size");
	String work_st = request.getParameter("work_st")==null?"1":request.getParameter("work_st");
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	out.println("* 선택건수="+vid_size+"<br><br>");
	
	String value[] = new String[10];
	
	String car_mng_id ="";
	String ins_st	="";
	String ins_tm	="";
	
	int flag = 0;
	int count =0;
	


	for(int i=0; i < vid_size; i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		car_mng_id 	= value[0];
		ins_st		= value[1];
		ins_tm		= value[2];
		
//		out.println(car_mng_id+" ");
//		out.println(ins_st+" ");
//		out.println(ins_tm+" ");
		
		
		InsurScdBean scd = ai_db.getInsScd(car_mng_id, ins_st, ins_tm);
		scd.setPay_yn("1");
		if(!pay_dt.equals("")) 		scd.setPay_dt(pay_dt);
		else						scd.setPay_dt(scd.getR_ins_est_dt());
		if(!ai_db.updateInsScd(scd)) flag += 1;
		out.println("<br>");
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'debt_pay_sc.jsp';
		fm.target = 'c_body';
		//fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
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
  <input type='hidden' name='f_list' value='pay'>
  <input type='hidden' name='size' value='<%=size%>'>  
</form>
<script language='javascript'>
<!--
	alert('확인해보십시오.');
//		go_step();
//-->
</script>
종료
</body>
</html>
