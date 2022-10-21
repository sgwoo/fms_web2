<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getClient(client_id);
	
	client.setCom_nm		(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
	client.setDept			(request.getParameter("dept")==null?"":request.getParameter("dept"));
	client.setTitle			(request.getParameter("title")==null?"":request.getParameter("title"));
	client.setH_tel			(request.getParameter("h_tel")==null?"":request.getParameter("h_tel"));
	client.setO_tel			(request.getParameter("o_tel")==null?"":request.getParameter("o_tel"));
	client.setM_tel			(request.getParameter("m_tel")==null?"":request.getParameter("m_tel"));
	client.setFax			(request.getParameter("fax")==null?"":request.getParameter("fax"));
	client.setHomepage		(request.getParameter("homepage")==null?"":request.getParameter("homepage"));
	client.setCon_agnt_nm	(request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm"));
	client.setCon_agnt_o_tel(request.getParameter("con_agnt_o_tel")==null?"":request.getParameter("con_agnt_o_tel"));
	client.setCon_agnt_m_tel(request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel"));
	client.setCon_agnt_fax	(request.getParameter("con_agnt_fax")==null?"":request.getParameter("con_agnt_fax"));
	client.setCon_agnt_email(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
	client.setCon_agnt_dept	(request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept"));
	client.setCon_agnt_title(request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title"));
	client.setEtax_not_cau	(request.getParameter("etax_not_cau")==null?"":request.getParameter("etax_not_cau"));
	client.setPrint_st		(request.getParameter("print_st")==null?"1":request.getParameter("print_st"));
	client.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	client.setCar_use		(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
	client.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
	client.setFirm_price	(request.getParameter("t_firm_price").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price")));
	client.setFirm_price_y	(request.getParameter("t_firm_price_y").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_y")));
	client.setFirm_day		(request.getParameter("t_firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day")));
	client.setFirm_day_y	(request.getParameter("t_firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_y")));
	client.setUpdate_id		(user_id);
%>
<script language='javascript'>
<%	if(al_db.updateClient2(client)){%>
		alert('수정되었습니다');
		parent.location='/acar/mng_client2/client_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>';
<%	}else{%>
		alert('수정되지 않았습니다');
<%	}%>
</script>
</body>
</html>
