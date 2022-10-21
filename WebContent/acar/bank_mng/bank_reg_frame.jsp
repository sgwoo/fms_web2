<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	
	if(lend_id.equals("")){
%>
<frameset rows="75, *" border=1>
  <frame src="bank_lend_hi.jsp?bank_id=<%=bank_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=lend_id%>&sh_height=<%=sh_height%>" name="r_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
  <frame src="bank_lend_i.jsp?bank_id=<%=bank_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=lend_id%>&sh_height=<%=sh_height%>" name="r_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
<%	}else{%>
<frameset rows="75, *" border=0>
  <frame src="bank_lend_hi.jsp?bank_id=<%=bank_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=lend_id%>&sh_height=<%=sh_height%>" name="r_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
  <frame src="bank_lend_u.jsp?bank_id=<%=bank_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=lend_id%>&sh_height=<%=sh_height%>" name="r_body" marginwidth=0 marginheight=0 scrolling="auto">
</frameset>
<%	}%>
</HTML>
