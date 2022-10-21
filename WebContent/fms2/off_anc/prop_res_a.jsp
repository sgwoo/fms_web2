<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String s_ym 	= request.getParameter("s_ym")==null?"":request.getParameter("s_ym");
	String sh_height= request.getParameter("sh_height")==null?"":request.getParameter("sh_height");
	
	String prop_ym 	= request.getParameter("prop_ym")==null?"":request.getParameter("prop_ym");
	String prop_dt 	= request.getParameter("prop_dt")==null?"":request.getParameter("prop_dt");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	

	
	int count = 0;
	int count2 = 0;
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	
	if(cmd.equals("i")){		
		count = p_db.insertPropResId(prop_ym, user_id);
	}else if(cmd.equals("d")){
		count = p_db.deletePropResId(prop_ym, user_id);
	}else if(cmd.equals("u")){
		count = p_db.updatePropDt(prop_ym, prop_dt);
	}
		
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_ym'  	value='<%=s_ym%>'>
  <input type='hidden' name="s_width" 	value="<%=s_width%>">   
  <input type='hidden' name="s_height" 	value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
  
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 처리되었습니다.");
	fm.action='./prop_res_c.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();	
	<%	if(cmd.equals("i")||cmd.equals("u")){%>		
	parent.window.close();	
	<%	}%>	
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
