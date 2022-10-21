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
	String insurCodeString = request.getParameter("insurCodeArray")==null?"":request.getParameter("insurCodeArray");
	String value15String = request.getParameter("value15Array")==null?"":request.getParameter("value15Array");
	String value17String = request.getParameter("value17Array")==null?"":request.getParameter("value17Array");
	String value18String = request.getParameter("value18Array")==null?"":request.getParameter("value18Array");
	String value19String = request.getParameter("value19Array")==null?"":request.getParameter("value19Array");
	String value20String = request.getParameter("value20Array")==null?"":request.getParameter("value20Array");
	String value21String = request.getParameter("value21Array")==null?"":request.getParameter("value21Array");
	String value26String = request.getParameter("value26Array")==null?"":request.getParameter("value26Array");
	String arraySize = request.getParameter("arraySize")==null?"":request.getParameter("arraySize");
	String regCodeString = request.getParameter("regCodeArray")==null?"":request.getParameter("regCodeArray");
	String seqString = request.getParameter("seqArray")==null?"":request.getParameter("seqArray");
	
	int size = Integer.parseInt(arraySize);
	
	String[] insurCodeArray = insurCodeString.split(","); // 개발원코드
	String[] value15Array = value15String.split(","); // 증권번호
	String[] value17Array = value17String.split(","); // 대인배상
	String[] value18Array = value18String.split(","); // 대인배상2
	String[] value19Array = value19String.split(","); // 대물배상
	String[] value20Array = value20String.split(","); // 자기신체사고
	String[] value21Array = value21String.split(","); // 무보험차상해
	String[] value26Array = value26String.split(","); // 임직원전용보험
	String[] regCodeArray = regCodeString.split(","); // 보험등록번호
	String[] seqArray = seqString.split(","); // 시퀀스
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	HashMap<String, Object> map = new HashMap<>();
	
	for(int i=0; i<size; i++) {
		map.put("insur_code",insurCodeArray[i]);
		map.put("value15",value15Array[i]);
		map.put("value17",value17Array[i]);
		map.put("value18",value18Array[i]);
		map.put("value19",value19Array[i]);
		map.put("value20",value20Array[i]);
		map.put("value21",value21Array[i]);
		map.put("value26",value26Array[i]);
		map.put("reg_code",regCodeArray[i]);
		map.put("seq",seqArray[i]);
		
		ic_db.updateInsur(map);
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