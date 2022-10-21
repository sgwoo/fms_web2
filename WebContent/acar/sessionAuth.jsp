<%@ page import="java.util.*, acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="LoginBean" scope="request" class="acar.util.LoginBean"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	if(session.getAttribute("USER_ID") == null){
		String login_id 	= request.getParameter("login_id")==null?"":request.getParameter("login_id");
		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(login_id);
		
		LoginBean.getLogin(user_bean.getId(), user_bean.getUser_psd(),response,request);
		
	}
%>

