<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %> 
<%
	String st 		= request.getParameter("st")			== null ? "" : request.getParameter("st");
	String m_st 	= request.getParameter("m_st")		== null ? "" : request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")		== null ? "" : request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")		== null ? "" : request.getParameter("m_cd");
	
	MaMymenuDatabase mm_db = MaMymenuDatabase.getInstance();
	
	int count = 0;
	
	if(!m_st.equals("")){
		if(st.equals("Y")){
			count = mm_db.insertXmlMyMenu(ck_acar_id, m_st, m_st2, m_cd);
		}else if(st.equals("N")){
			count = mm_db.deleteXmlMyMenu(ck_acar_id, m_st, m_st2, m_cd);
		}
	}

%>
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script>
	<%if(!m_st.equals("")){%> 
		<%if(count > 0){%>
		alert('정상적으로 처리되었습니다.');
		parent.location = '/fms2/menu/emp_submenu.jsp';
		parent.parent.top_menu.showMenuDepth('<%=m_st%>');
  	<%}else{%>
  	alert('에러발생');	
  	<%}%>
  <%}%>	
</script>
<body>
	나의 메뉴 등록 페이지입니다.
</body>
</html>