<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");

	String value01 = request.getParameter("value01")==null?"":request.getParameter("value01");
	String value02 = request.getParameter("value02")==null?"":request.getParameter("value02");
	String value03 = request.getParameter("value03")==null?"":request.getParameter("value03");
	String value04 = request.getParameter("value04")==null?"":request.getParameter("value04");
	String value05 = request.getParameter("value05")==null?"":request.getParameter("value05");
	String value06 = request.getParameter("value06")==null?"":request.getParameter("value06");
	String value07 = request.getParameter("value07")==null?"":request.getParameter("value07");
	String value08 = request.getParameter("value08")==null?"":request.getParameter("value08");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String modify_dt = request.getParameter("modify_dt")==null?"":request.getParameter("modify_dt");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	Hashtable ht = ic_db.getInsRatioSelect(save_dt);	
	int flag = 0;
	if(ht.get("SAVE_DT") != null){
		if(!ic_db.updateInsRatio("1", value01, value02, AddUtil.parseLong(value03), AddUtil.parseLong(value04), AddUtil.parseFloat(value05), AddUtil.parseFloat(value06), AddUtil.parseLong(value07), AddUtil.parseLong(value08),save_dt, modify_dt)){
			flag += 1;
		}
	}else{
		if(!ic_db.insertInsRatio("1", value01, value02, AddUtil.parseLong(value03), AddUtil.parseLong(value04), AddUtil.parseFloat(value05), AddUtil.parseFloat(value06), AddUtil.parseLong(value07), AddUtil.parseLong(value08))){
			flag += 1;
		}
	}
	
	
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>