<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	
	// client 만 등록 - 자산 및 재무제표 관련은 별도처리 2007-07-12
	ClientBean client = al_db.getNewClient(client_id);
	
	String zip[] 	= request.getParameterValues("t_zip");
	String addr[] = request.getParameterValues("t_addr");
	String m_tel[] = request.getParameterValues("m_tel");
	String h_tel[] = request.getParameterValues("h_tel");
	String o_tel[] = request.getParameterValues("o_tel");
	String fax[] = request.getParameterValues("fax");
	String homepage[] = request.getParameterValues("homepage");
	
	String repre_nm[] = request.getParameterValues("repre_nm");
	String repre_ssn1[] = request.getParameterValues("repre_ssn1");
	String repre_ssn2[] = request.getParameterValues("repre_ssn2");
	String repre_email[] = request.getParameterValues("repre_email");
	
	String client_st  = request.getParameter("client_st");
	
	client.setCom_nm			(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
	client.setDept				(request.getParameter("dept")==null?"":request.getParameter("dept"));
	client.setTitle				(request.getParameter("title")==null?"":request.getParameter("title"));
	client.setCon_agnt_nm	(request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm"));
	client.setCon_agnt_o_tel	(request.getParameter("con_agnt_o_tel")==null?"":request.getParameter("con_agnt_o_tel"));
	client.setCon_agnt_m_tel	(request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel"));
	client.setCon_agnt_fax		(request.getParameter("con_agnt_fax")==null?"":request.getParameter("con_agnt_fax"));
	client.setCon_agnt_email	(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
	client.setCon_agnt_dept		(request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept"));
	client.setCon_agnt_title	(request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title"));
	client.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	client.setCar_use			(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
	client.setEtc					(request.getParameter("etc")==null?"":request.getParameter("etc"));
	client.setUpdate_id		(user_id);
  // newFMS - 20070718
	client.setFirm_st			(request.getParameter("firm_st")==null?"":request.getParameter("firm_st"));
	client.setEnp_yn			(request.getParameter("enp_yn")==null?"":request.getParameter("enp_yn"));
	client.setEnp_nm			(request.getParameter("enp_nm")==null?"":request.getParameter("enp_nm"));
	client.setFirm_type		(request.getParameter("firm_type")==null?"":request.getParameter("firm_type"));
	client.setFound_year	(request.getParameter("found_year")==null?"":AddUtil.ChangeString(request.getParameter("found_year")));
	client.setRepre_st		(request.getParameter("repre_st")==null?"":request.getParameter("repre_st"));
// 	client.setRepre_ssn1	(request.getParameter("repre_ssn1")==null?"":request.getParameter("repre_ssn1"));
	client.setRepre_ssn2	("");
// 	client.setRepre_email	(request.getParameter("repre_email")==null?"":request.getParameter("repre_email"));
	client.setJob					(request.getParameter("job")==null?"":request.getParameter("job"));
	client.setPay_st			(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
	client.setPay_type		(request.getParameter("pay_type")==null?"":request.getParameter("pay_type"));
	client.setWk_year			(request.getParameter("wk_year")==null?"":request.getParameter("wk_year"));
	client.setDly_sms			(request.getParameter("dly_sms")==null?"":request.getParameter("dly_sms"));
	client.setEtc_cms			(request.getParameter("etc_cms")==null?"":request.getParameter("etc_cms"));
	client.setFine_yn			(request.getParameter("fine_yn")==null?"":request.getParameter("fine_yn"));
	client.setNationality	(request.getParameter("nationality")==null?"":request.getParameter("nationality"));	
	client.setDly_yn 			(request.getParameter("dly_yn")==null?"":request.getParameter("dly_yn"));	
// 	client.setRepre_nm		(request.getParameter("repre_nm")==null?"":request.getParameter("repre_nm"));
		
	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id)){
		client.setEtax_not_cau(request.getParameter("etax_not_cau")==null?"":request.getParameter("etax_not_cau"));
		client.setPrint_st		(request.getParameter("print_st")==null?"1":request.getParameter("print_st"));
		client.setBigo_yn			(request.getParameter("bigo_yn")==null?"":request.getParameter("bigo_yn"));
		client.setItem_mail_yn(request.getParameter("item_mail_yn")==null?"":request.getParameter("item_mail_yn"));
		client.setTax_mail_yn	(request.getParameter("tax_mail_yn")==null?"":request.getParameter("tax_mail_yn"));
		client.setIm_print_st	(request.getParameter("im_print_st")==null?"":request.getParameter("im_print_st"));
		client.setTm_print_yn	(request.getParameter("tm_print_yn")==null?"":request.getParameter("tm_print_yn"));
		client.setBigo_value1	(request.getParameter("bigo_value1")==null?"":request.getParameter("bigo_value1"));
		client.setBigo_value2	(request.getParameter("bigo_value2")==null?"":request.getParameter("bigo_value2"));
		client.setPubform			(request.getParameter("pubform")==null?"":request.getParameter("pubform"));
		client.setPrint_car_st(request.getParameter("print_car_st")==null?"":request.getParameter("print_car_st"));
		client.setEtax_item_st(request.getParameter("etax_item_st")==null?"":request.getParameter("etax_item_st"));
	}
		
	if(client_st.equals("1")){
		client.setM_tel			(m_tel[0]);
		client.setH_tel			(h_tel[0]);
		client.setO_tel			(o_tel[0]);
		client.setFax			(fax[0]);
		client.setHomepage		(homepage[0]);
		client.setRepre_addr		(addr[0]);
		client.setRepre_zip		(zip[0]);
		client.setRepre_nm(repre_nm[0]);
		client.setRepre_ssn1(repre_ssn1[0]);
		client.setRepre_email(repre_email[0]);
	}else if(client_st.equals("2")){
		client.setM_tel			(m_tel[2]);
		client.setH_tel			(h_tel[2]);
		client.setO_tel			(o_tel[2]);
		client.setFax			(fax[2]);
		client.setHomepage		(homepage[2]);
		client.setComm_addr		(addr[2]);
		client.setComm_zip		(zip[2]);
		client.setRepre_nm(repre_nm[2]);
		client.setRepre_ssn1(repre_ssn1[2]);
		client.setRepre_email(repre_email[2]);
		client.setRepre_addr		(addr[3]);
		client.setRepre_zip		(zip[3]);
	}else{
		client.setM_tel			(m_tel[1]);
		client.setH_tel			(h_tel[1]);
		client.setO_tel			(o_tel[1]);
		client.setFax			(fax[1]);
		client.setHomepage		(homepage[1]);
		client.setRepre_addr		(addr[1]);
		client.setRepre_zip		(zip[1]);
		client.setRepre_nm2(request.getParameter("repre_nm2")==null?"":request.getParameter("repre_nm2"));
		client.setRepre_ssn2_1(request.getParameter("repre_ssn2_1")==null?"":request.getParameter("repre_ssn2_1"));
		client.setRepre_ssn2_2("");
		client.setRepre_zip2(request.getParameter("repre_zip2")==null?"":request.getParameter("repre_zip2"));
		client.setRepre_addr2(request.getParameter("repre_addr2")==null?"":request.getParameter("repre_addr2"));
		client.setRepre_email2(request.getParameter("repre_email2")==null?"":request.getParameter("repre_email2"));
		client.setRepre_nm(repre_nm[1]);
		client.setRepre_ssn1(repre_ssn1[1]);
		client.setRepre_email(repre_email[1]);
	}
	
	client.setCon_agnt_nm2		(request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2"));
	client.setCon_agnt_o_tel2	(request.getParameter("con_agnt_o_tel2")==null?"":request.getParameter("con_agnt_o_tel2"));
	client.setCon_agnt_m_tel2	(request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2"));
	client.setCon_agnt_fax2		(request.getParameter("con_agnt_fax2")==null?"":request.getParameter("con_agnt_fax2"));
	client.setCon_agnt_email2	(request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2").trim());
	client.setCon_agnt_dept2	(request.getParameter("con_agnt_dept2")==null?"":request.getParameter("con_agnt_dept2"));
	client.setCon_agnt_title2	(request.getParameter("con_agnt_title2")==null?"":request.getParameter("con_agnt_title2"));
	client.setLic_no		(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
	client.setCms_sms		(request.getParameter("cms_sms")==null?"":request.getParameter("cms_sms"));
	
	
	
%>
<script language='javascript'>
<%	if(al_db.updateNewClient2(client)){%>
		alert('수정되었습니다');
		parent.location='/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>';		
<%	}else{%>
		alert('수정되지 않았습니다');
<%	}%>
</script>
</body>
</html>
