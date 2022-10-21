<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetMaBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	// 상각재계산  - 자산 수정/추가 이후 해당 기수 상각금액 수정 
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String asset_code 			= request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	String asset_name 			= request.getParameter("asset_name")==null?"":request.getParameter("asset_name");
	
	String gisu 	= request.getParameter("gisu")==null?"":request.getParameter("gisu");
	String s_flag = "";
	
	//당기 기수
	int count=0;
	AssetDatabase as_db = AssetDatabase.getInstance();
	System.out.println(" 상각 재계산 asset_code=" + asset_code + " | gisu = " + gisu );
	s_flag =  as_db.call_sp_insert_assetmove3(gisu, asset_code, user_id );
	System.out.println("자산상각 재계산 =" + s_flag);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){	
	<%	if( s_flag.equals("0")){%>
 	  			alert("정상적으로 수정되었습니다.");
	 	  		var theForm = document.form1;
	 	  		theForm.target='d_content';
  				theForm.submit();
	<%	}else {%>
 	  			alert("수정 오류!");
	<% } %>
   
   }
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./asset_s_frame.jsp" name="form1" method="post">
<input type="hidden" name="cmd" valaue="nd">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="asset_code" value="<%=asset_code%>">
</form>
</body>
</html>
