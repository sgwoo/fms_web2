<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String arraySize = request.getParameter("arraySize")==null?"":request.getParameter("arraySize");
	String regCodeString = request.getParameter("regCodeArray")==null?"":request.getParameter("regCodeArray");
	String seqString = request.getParameter("seqArray")==null?"":request.getParameter("seqArray");
	
	int size = Integer.parseInt(arraySize);
	
	String[] regCodeArray = regCodeString.split(","); // 보험등록번호
	String[] seqArray = seqString.split(","); // 시퀀스
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	HashMap<String, Object> map = new HashMap<>();
	
	for(int i=0; i<size; i++) {
		map.put("reg_code",regCodeArray[i]);
		map.put("seq",seqArray[i]);
		
		ic_db.comfirmInsur(map);
	}
%>
 
<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body onload="goInsCom()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' 	value='<%=user_id%>'>
    <input type='hidden' name='br_id' 	value='<%=br_id%>'>
    <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
    <input type='hidden' name='andor'	value='<%=andor%>'>
    <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
    <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
    <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
    <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
    <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
    <input type='hidden' name='sort' 	value='<%=sort%>'>
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
</body>
<script language='javascript'>

	function goInsCom() {
		var fm = document.form1;
		fm.action = "ins_com_new_sc_in.jsp";
		fm.submit();
	}
</script>