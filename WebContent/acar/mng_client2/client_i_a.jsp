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
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 		= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	ClientBean client = new ClientBean();
	
	String zip[] 	= request.getParameterValues("t_zip");
	String addr[] = request.getParameterValues("t_addr");
	
	client.setClient_st		(request.getParameter("client_st")==null?"":request.getParameter("client_st"));
	client.setFirm_nm		(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	client.setClient_nm		(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
	client.setSsn1			(request.getParameter("ssn1")==null?"":request.getParameter("ssn1"));
	client.setSsn2			(request.getParameter("ssn2")==null?"":request.getParameter("ssn2"));
	//개인사업자는 생년월일만
	if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
		client.setSsn2	("");
	}
	client.setEnp_no1		(request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1"));
	client.setEnp_no2		(request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2"));
	client.setEnp_no3		(request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3"));
	client.setH_tel			(request.getParameter("h_tel")==null?"":request.getParameter("h_tel"));
	client.setO_tel			(request.getParameter("o_tel")==null?"":request.getParameter("o_tel"));
	client.setM_tel			(request.getParameter("m_tel")==null?"":request.getParameter("m_tel"));
	client.setHomepage		(request.getParameter("homepage")==null?"":request.getParameter("homepage"));
	client.setFax			(request.getParameter("fax")==null?"":request.getParameter("fax"));
	client.setBus_cdt		(request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"));
	client.setBus_itm		(request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"));
	client.setCom_nm		(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
	client.setDept			(request.getParameter("dept")==null?"":request.getParameter("dept"));
	client.setTitle			(request.getParameter("title")==null?"":request.getParameter("title"));
	client.setCar_use		(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
	client.setCon_agnt_nm	(request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm"));
	client.setCon_agnt_o_tel(request.getParameter("con_agnt_o_tel")==null?"":request.getParameter("con_agnt_o_tel"));
	client.setCon_agnt_m_tel(request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel"));
	client.setCon_agnt_fax	(request.getParameter("con_agnt_fax")==null?"":request.getParameter("con_agnt_fax"));
	client.setCon_agnt_email(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
	client.setCon_agnt_dept	(request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept"));
	client.setCon_agnt_title(request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title"));
	client.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
	client.setOpen_year		(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
	client.setFirm_price	(request.getParameter("t_firm_price").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price")));
	client.setFirm_price_y	(request.getParameter("t_firm_price_y").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_y")));
	client.setFirm_day		(request.getParameter("t_firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day")));
	client.setFirm_day_y	(request.getParameter("t_firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_y")));
	client.setHo_addr		(addr[0]);
	client.setHo_zip		(zip[0]);
	client.setO_addr		(addr[1]);
	client.setO_zip			(zip[1]);
	client.setReg_id		(user_id);
	client.setPrint_st		(request.getParameter("print_st")==null?"1":request.getParameter("print_st"));
	//미사용분----------------------------------------------------------------------
//	client.setFirm_price_b	(request.getParameter("t_firm_price_b").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_b")));
//	client.setFirm_day_b	(request.getParameter("t_firm_day_b").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_b")));
	
	//주민(법인)등록번호와 사업자등록번호로 중복체크
	int	count = al_db.checkSSN(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
	
	if(count == 0){
		client = al_db.insertClient(client);
	}
%>
<script language='javascript'>
<%	if(count == 0){
		if(client != null){%>
			alert('등록되었습니다');
			parent.location='/acar/mng_client2/client_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>';
<%		}else{%>
			alert('등록되지 않았습니다');
<%		}
	}else{%>
			alert('이미 등록된 주민(법인)등록번호입니다.\n\n확인하십시오.');
<%	}%>				
</script>
</body>
</html>
