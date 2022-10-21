<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	int flag = 0;
	
	ClientBean client = l_db.getClient(c_id);
		
	client.setClient_st(request.getParameter("s_cl_gbn"));
	client.setClient_nm(request.getParameter("t_client_nm"));
	client.setFirm_nm(request.getParameter("t_firm_nm"));	    
	client.setSsn1(request.getParameter("t_ssn1"));
	client.setSsn2(request.getParameter("t_ssn2"));
	//개인사업자는 생년월일만
	if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
		client.setSsn2	("");
	}
	client.setEnp_no1(request.getParameter("t_enp_no1"));
	client.setEnp_no2(request.getParameter("t_enp_no2"));
	client.setEnp_no3(request.getParameter("t_enp_no3"));
	client.setH_tel(request.getParameter("t_h_tel"));
	client.setO_tel(request.getParameter("t_o_tel"));
	client.setM_tel(request.getParameter("t_m_tel"));
	client.setHomepage(request.getParameter("t_homepage"));
	client.setFax(request.getParameter("t_fax"));
	client.setBus_cdt(request.getParameter("t_cdt"));
	client.setBus_itm(request.getParameter("t_itm"));	
	String zip[] = request.getParameterValues("t_zip");
	String addr[] = request.getParameterValues("t_addr");	
	client.setHo_addr(addr[0]);
	client.setHo_zip(zip[0]);
	client.setO_addr(addr[1]);
	client.setO_zip(zip[1]);
	//추가된 항목
	client.setFirm_price(request.getParameter("t_firm_price").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price")));	client.setFirm_price_y(request.getParameter("t_firm_price_y").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_y")));
	client.setOpen_year(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
	client.setFirm_day(request.getParameter("t_firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day")));
	client.setFirm_day_y(request.getParameter("t_firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_y")));
	client.setUpdate_id(user_id);
	
	if(!al_db.updateClient(client))	flag += 1;
	
	//차량관리자 수정. 이름이 있는 경우만 등록
	if(!request.getParameter("mgr_nm1").equals("")){
		CarMgrBean mgr1 = new CarMgrBean();
		mgr1.setMgr_id("0");
		mgr1.setMgr_st(request.getParameter("mgr_st1")==null?"":request.getParameter("mgr_st1"));
		mgr1.setMgr_nm(request.getParameter("mgr_nm1")==null?"":request.getParameter("mgr_nm1"));
		mgr1.setMgr_dept(request.getParameter("mgr_dept1")==null?"":request.getParameter("mgr_dept1"));
		mgr1.setMgr_title(request.getParameter("mgr_title1")==null?"":request.getParameter("mgr_title1"));
		mgr1.setMgr_tel(request.getParameter("mgr_tel1")==null?"":request.getParameter("mgr_tel1"));
		mgr1.setMgr_m_tel(request.getParameter("mgr_mobile1")==null?"":request.getParameter("mgr_mobile1"));
		mgr1.setMgr_email(request.getParameter("mgr_email1")==null?"":request.getParameter("mgr_email1").trim());
		if(!a_db.updateCarMgrAll(c_id, mgr1))	flag += 1;
	}
	
	if(!request.getParameter("mgr_nm2").equals("")){
		CarMgrBean mgr2 = new CarMgrBean();
		mgr2.setMgr_id("1");
		mgr2.setMgr_st(request.getParameter("mgr_st2")==null?"":request.getParameter("mgr_st2"));
		mgr2.setMgr_nm(request.getParameter("mgr_nm2")==null?"":request.getParameter("mgr_nm2"));
		mgr2.setMgr_dept(request.getParameter("mgr_dept2")==null?"":request.getParameter("mgr_dept2"));
		mgr2.setMgr_title(request.getParameter("mgr_title2")==null?"":request.getParameter("mgr_title2"));
		mgr2.setMgr_tel(request.getParameter("mgr_tel2")==null?"":request.getParameter("mgr_tel2"));
		mgr2.setMgr_m_tel(request.getParameter("mgr_mobile2")==null?"":request.getParameter("mgr_mobile2"));
		mgr2.setMgr_email(request.getParameter("mgr_email2")==null?"":request.getParameter("mgr_email2").trim());
		if(!a_db.updateCarMgrAll(c_id, mgr2))	flag += 1;
	}
	
	if(!request.getParameter("mgr_nm3").equals(""))
	{
		CarMgrBean mgr3 = new CarMgrBean();
		mgr3.setMgr_id("2");
		mgr3.setMgr_st(request.getParameter("mgr_st3")==null?"":request.getParameter("mgr_st3"));
		mgr3.setMgr_nm(request.getParameter("mgr_nm3")==null?"":request.getParameter("mgr_nm3"));
		mgr3.setMgr_dept(request.getParameter("mgr_dept3")==null?"":request.getParameter("mgr_dept3"));
		mgr3.setMgr_title(request.getParameter("mgr_title3")==null?"":request.getParameter("mgr_title3"));
		mgr3.setMgr_tel(request.getParameter("mgr_tel3")==null?"":request.getParameter("mgr_tel3"));
		mgr3.setMgr_m_tel(request.getParameter("mgr_mobile3")==null?"":request.getParameter("mgr_mobile3"));
		mgr3.setMgr_email(request.getParameter("mgr_email3")==null?"":request.getParameter("mgr_email3").trim());
		if(!a_db.updateCarMgrAll(c_id, mgr3))	flag += 1;
	}
%>
<form name='form1' method='post' target='d_content' action='/acar/mng_client/client_s_frame.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
</form>
<script language='javascript'>

<%	if(flag == 0){%>

		alert('수정되었습니다');

<%	}else{%>

		alert('수정되지 않았습니다');

<%	}%>
		document.form1.submit();
</script>
</body>
</html>
