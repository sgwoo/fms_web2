<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.call.*, acar.util.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<% 
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] ch_call = request.getParameterValues("ch_all");

		
	int result = p_db.updateContCall(ch_call);
	
	// 날짜 기준   
	if(!p_db.updateContCallDt()) flag1+=1;	 	   	
  	
	//5. 검색---------------------------------------------------------------------------------------------------

	String use_yn 	= request.getParameter("use_yn");
	auth_rw 	= request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id");
	String s_bank	= request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst");
%>
<script language='javascript'>
<!--
<%	if(result >= 1 || flag1 == 0 ){%>
	alert("비대상으로 등록되었습니다.\n");
	parent.parent.location.href = "/fms2/survey/rent_cond_frame.jsp?mode=2&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 문의하세요 !");
	parent.c_foot.inner.location.href = "/fms2/survey/rent_cond_frame.jsp?mode=2&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>";
<%}%>
//-->

</script>
</body>
</html>
