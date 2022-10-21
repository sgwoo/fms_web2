<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mgr_st = request.getParameter("mgr_st")==null?"":request.getParameter("mgr_st");	
	String all_upchk = request.getParameter("all_upchk")==null?"N":request.getParameter("all_upchk");
	if(all_upchk.equals("")) all_upchk = "N";
	
	boolean flag = true;

	CarMgrBean mgr_u = a_db.getCarMgr(m_id, l_cd, mgr_st);
	mgr_u.setMgr_nm(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
	mgr_u.setMgr_dept(request.getParameter("mgr_dept")==null?"":request.getParameter("mgr_dept"));
	mgr_u.setMgr_title(request.getParameter("mgr_title")==null?"":request.getParameter("mgr_title"));
	mgr_u.setMgr_tel(request.getParameter("mgr_tel")==null?"":request.getParameter("mgr_tel"));
	mgr_u.setMgr_m_tel(request.getParameter("mgr_m_tel")==null?"":request.getParameter("mgr_m_tel"));
	mgr_u.setMgr_email(request.getParameter("mgr_email")==null?"":request.getParameter("mgr_email").trim());
	mgr_u.setMgr_zip(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	mgr_u.setMgr_addr(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	mgr_u.setLic_no(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	//운전면허번호추가(20180921)
	if(all_upchk.equals("N")){//해당건만 수정
		flag = a_db.updateCarMgr(mgr_u);
	}else{//동일거래처 일괄 수정
		flag = a_db.updateCarMgr(mgr_u, client_id, mgr_st);
	}
%>
<script language='javascript'>
<%	if(flag){%>
		alert('수정되었습니다');
//		parent.opener.location.href = "client_email.jsp?client_id=<%=client_id%>";
		parent.window.close();
		parent.opener.location.reload();		
<%	}else{%>
		alert('수정되지 않았습니다');
<%	}%>
</script>
</body>
</html>
