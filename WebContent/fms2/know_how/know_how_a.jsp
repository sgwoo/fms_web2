<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.know_how.*" %>
<jsp:useBean id="k_bean" class="acar.know_how.Know_howBean" scope="page" />
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="kr_bean" class="acar.know_how.Know_how_ReplyBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	Know_how_Database kh_db = Know_how_Database.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int know_how_id = request.getParameter("know_how_id")==null?0:Util.parseInt(request.getParameter("know_how_id"));
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	String know_how_st  = request.getParameter("know_how_st")==null?"":request.getParameter("know_how_st");
	String p_view 	= request.getParameter("p_view")==null?"":request.getParameter("p_view");
	String reply_content  = request.getParameter("reply_content")==null?"":request.getParameter("reply_content");

	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");

	String user_nm = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";

	int count = 0;
	

	UserMngDatabase umd = UserMngDatabase.getInstance();
	u_bean = umd.getUsersBean(user_id);
	
if(cmd.equals("i")){
	
		k_bean.setUser_id(user_id);
		k_bean.setTitle(title);
		k_bean.setContent(content);
		k_bean.setKnow_how_st(know_how_st);
		k_bean.setP_view(p_view);
		
	count = kh_db.insertKnow_how(k_bean);
	
}else if(cmd.equals("c")){
	
		kr_bean.setUser_id(acar_id);
		kr_bean.setReply_content(reply_content);
		kr_bean.setKnow_how_id(know_how_id);

	count = kh_db.insertKnow_howRp(kr_bean);

}else if(cmd.equals("u")){

		k_bean.setUser_id(user_id);
		k_bean.setTitle(title);
		k_bean.setContent(content);
		k_bean.setKnow_how_st(know_how_st);
		k_bean.setKnow_how_id(know_how_id);
		k_bean.setP_view(p_view);
		
	count = kh_db.UpdateKnow_how(k_bean);

}else if(cmd.equals("d")){
	
	k_bean.setKnow_how_id(know_how_id);
	k_bean.setUser_id(user_id);
	
	count = kh_db.DeleteKnow_how(k_bean);
}

%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST" enctype="">


</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("i")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='know_how_frame.jsp';
		fm.target='d_content';
		fm.submit();			
		parent.window.close();		
				
<%}
}else if(cmd.equals("c")){
	if(count==1){
%>
		alert("리플이 등록 되었습니다.");
		fm.action='know_how_frame.jsp';
		fm.target='d_content';
		fm.submit();	
		parent.window.close();
	
<%}
}else if(cmd.equals("u")){
	if(count==1){
%>
		alert("수정 되었습니다.");
		fm.action='know_how_frame.jsp';
		fm.target='d_content';
		fm.submit();					
		parent.window.close();
<%}
}else if(cmd.equals("d")){
	if(count==1){
%>
		alert("삭제 되었습니다.");
		fm.action='know_how_frame.jsp';
		fm.target='d_content';
		fm.submit();					
		parent.window.close();
<%}
}
%>
//-->
</script>
</body>
</html>
