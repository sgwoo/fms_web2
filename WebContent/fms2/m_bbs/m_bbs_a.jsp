<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.m_bbs.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="mr_bean" class="acar.m_bbs.M_bbs_ReplyBean" scope="page"/>
<jsp:useBean id="m_bean" class="acar.m_bbs.M_bbsBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	M_bbs_Database m_db = M_bbs_Database.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	String email = request.getParameter("email")==null?"":request.getParameter("email");
	String reply_content  = request.getParameter("reply_content")==null?"":request.getParameter("reply_content");
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");

	String user_nm = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";

	int count = 0;
	int h_bbs_id = 0;
	

	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	u_bean = umd.getUsersBean(user_id);
	
 if(cmd.equals("i")){
	
		m_bean.setTarget(user_id);
		m_bean.setReg_id(client_id);
		m_bean.setEmail(email);
		m_bean.setTitle(title);
		m_bean.setContent(content);
		m_bean.setHit(0);
		
		count = m_db.insertM_bbs(m_bean);
//System.out.println("count : "+count);	
}else if(cmd.equals("c")){
	
		mr_bean.setReg_id(user_id);
		mr_bean.setReply_content(reply_content);
		mr_bean.setBbs_id(bbs_id);

	count = m_db.insertM_bbs_Rp(mr_bean);

}else if(cmd.equals("d")){
	
	mr_bean.setBbs_id(bbs_id);
	mr_bean.setReg_id(user_id);
	
	count = m_db.DeleteM_bbs_Rp(mr_bean);
}


%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script language="JavaScript">
<!--
	function go_parent_list(){
		var fm = document.form1;
		fm.action = "https://fms.amazoncar.co.kr/service/center/member_bbs.jsp";
		fm.target='d_content';
		fm.submit();
	}

//-->
</script>
<body>

<form name='form1' action='' method="POST" >

<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="bbs_id" value="<%=bbs_id%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(cmd.equals("i")){
		if(count != 0){%>			
		alert("등록 되었습니다.");

		go_parent_list();
<%		}else{%>
			alert("등록 오류!!");
<%		}
	}else if(cmd.equals("c")){
	if(count != 0){
%>
		alert("리플이 등록 되었습니다.");
		fm.action='m_bbs_frame.jsp';
		fm.target='d_content';
		fm.submit();	
	
<%}
}else if(cmd.equals("d")){
	if(count != 0 ){
%>
		alert("삭제 되었습니다.");
		fm.action='m_bbs_frame.jsp';
		fm.target='d_content';
		fm.submit();					
<%}
}
%>
//-->
</script>
</body>
</html>
