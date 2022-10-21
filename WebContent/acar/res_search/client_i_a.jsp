<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String page_gubun 	= request.getParameter("h_page_gubun")==null?"":request.getParameter("h_page_gubun");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	int count =0;
	int flag = 0;


	ClientBean client = new ClientBean();
	

		
		boolean flag1 = true;
		boolean flag2 = true;
		
		String client_st  	= request.getParameter("client_st");
		String zip[] 		= request.getParameterValues("t_zip");
		String addr[] 		= request.getParameterValues("t_addr");
		String firm_nm[] 	= request.getParameterValues("firm_nm");
		String client_nm[] 	= request.getParameterValues("client_nm");
		String ssn1[] 		= request.getParameterValues("ssn1");
		String ssn2[] 		= request.getParameterValues("ssn2");
		String enp_no1[] 	= request.getParameterValues("enp_no1");
		String enp_no2[] 	= request.getParameterValues("enp_no2");
		String enp_no3[] 	= request.getParameterValues("enp_no3");
		String h_tel[] 		= request.getParameterValues("h_tel");
		String o_tel[] 		= request.getParameterValues("o_tel");
		String m_tel[] 		= request.getParameterValues("m_tel");
		String homepage[] 	= request.getParameterValues("homepage");
		String fax[] 		= request.getParameterValues("fax");
		String bus_cdt[] 	= request.getParameterValues("bus_cdt");
		String bus_itm[] 	= request.getParameterValues("bus_itm");
		String t_open_year[] = request.getParameterValues("t_open_year");
		String repre_ssn1[] = request.getParameterValues("repre_ssn1");
		String repre_ssn2[] = request.getParameterValues("repre_ssn2");
	
	
		client.setClient_st		(client_st);

		//법인
		if (client_st.equals("1") || client_st.equals("6")) {
		
			client.setO_addr		(addr[0]);	//사업장주소
			client.setO_zip			(zip[0]);
			client.setHo_addr		(addr[1]); 	//본점주소
			client.setHo_zip		(zip[1]);
			client.setFirm_nm		(firm_nm[0]);
			client.setClient_nm		(client_nm[0]);
			client.setSsn1			(ssn1[0]);
			client.setSsn2			(ssn2[0]);
			client.setEnp_no1		(enp_no1[0]);
			client.setEnp_no2		(enp_no2[0]);
			client.setEnp_no3		(enp_no3[0]);
			client.setBus_cdt		(bus_cdt[0]);
			client.setBus_itm		(bus_itm[0]);
			client.setOpen_year		(t_open_year[0]);
			client.setH_tel			(h_tel[0]);
			client.setO_tel			(o_tel[0]);
			client.setM_tel			(m_tel[0]);
			client.setHomepage		(homepage[0]);
			client.setFax			(fax[0]);
			client.setRepre_ssn1	(repre_ssn1[0]);
			client.setRepre_ssn2	("");
			client.setRepre_addr	(addr[2]);
			client.setRepre_zip		(zip[2]);
			client.setFirm_st		(request.getParameter("firm_st")==null?"":request.getParameter("firm_st"));
			client.setEnp_yn		(request.getParameter("enp_yn")==null?"":request.getParameter("enp_yn"));
			client.setEnp_nm		(request.getParameter("enp_nm")==null?"":request.getParameter("enp_nm"));
			client.setFirm_type		(request.getParameter("firm_type")==null?"":request.getParameter("firm_type"));
			client.setFound_year	(request.getParameter("found_year")==null?"":request.getParameter("found_year"));
			client.setRepre_st		(request.getParameter("repre_st")==null?"":request.getParameter("repre_st"));
			client.setTaxregno		(request.getParameter("taxregno")==null?"":request.getParameter("taxregno"));
		
		//개인사업자
		} else if (client_st.equals("3") || client_st.equals("4") || client_st.equals("5")) {
		
			client.setHo_addr		(addr[4]);	//사업자주소
			client.setHo_zip		(zip[4]);
			client.setO_addr		(addr[3]);	//사업장주소
			client.setO_zip			(zip[3]);
			client.setFirm_nm		(firm_nm[1]);
			client.setClient_nm		(client_nm[1]);
			client.setSsn1			(ssn1[1]);
			client.setSsn2			("");
			client.setEnp_no1		(enp_no1[1]);
			client.setEnp_no2		(enp_no2[1]);
			client.setEnp_no3		(enp_no3[1]);
			client.setBus_cdt		(bus_cdt[1]);
			client.setBus_itm		(bus_itm[1]);
			client.setOpen_year		(t_open_year[1]);
			client.setH_tel			(h_tel[1]);
			client.setO_tel			(o_tel[1]);
			client.setM_tel			(m_tel[1]);
			client.setFax			(fax[1]);
			client.setHomepage		(homepage[1]);
			client.setRepre_ssn1	(repre_ssn1[1]);
			client.setRepre_ssn2	("");
			client.setRepre_addr	(addr[4]);
			client.setRepre_zip		(zip[4]);
		
		//개인
		} else if (client_st.equals("2")) {   //자택주소
			
			client.setHo_addr		(addr[5]);
			client.setHo_zip		(zip[5]);
			client.setO_addr		(addr[5]);
			client.setO_zip			(zip[5]);
			client.setFirm_nm		(firm_nm[2]);
			client.setClient_nm		(firm_nm[2]);
			client.setSsn1			(ssn1[2]);
			client.setSsn2			(ssn2[2]);
			client.setH_tel			(h_tel[2]);
			client.setM_tel			(m_tel[2]);
			client.setFax			(fax[2]);
			client.setComm_addr		(addr[6]);
			client.setComm_zip		(zip[6]);
			client.setJob			(request.getParameter("job")==null?"":request.getParameter("job"));
			client.setPay_st		(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
			client.setCom_nm		(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
			client.setWk_year		(request.getParameter("wk_year")==null?"":request.getParameter("wk_year"));
			client.setPay_type		(request.getParameter("pay_type")==null?"":request.getParameter("pay_type"));
			client.setDept			(request.getParameter("dept")==null?"":request.getParameter("dept"));
			client.setTitle			(request.getParameter("title")==null?"":request.getParameter("title"));
			client.setNationality	(request.getParameter("nationality")==null?"":request.getParameter("nationality"));
		}
	
		//공통부분
		client.setPrint_st	 	(request.getParameter("print_st")==null?"1":request.getParameter("print_st"));
		client.setCar_use		(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
		client.setCon_agnt_nm	(request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm"));
		client.setCon_agnt_o_tel(request.getParameter("con_agnt_o_tel")==null?"":request.getParameter("con_agnt_o_tel"));
		client.setCon_agnt_m_tel(request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel"));
		client.setCon_agnt_fax	(request.getParameter("con_agnt_fax")==null?"":request.getParameter("con_agnt_fax"));
		client.setCon_agnt_email(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
		client.setCon_agnt_dept	(request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept"));
		client.setCon_agnt_title(request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title"));
		client.setEtax_not_cau	(request.getParameter("etax_not_cau")==null?"":request.getParameter("etax_not_cau"));
		client.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));	
		client.setDly_sms		(request.getParameter("dly_sms")==null?"":request.getParameter("dly_sms"));
		client.setEtc_cms		(request.getParameter("etc_cms")==null?"":request.getParameter("etc_cms"));
		client.setFine_yn		(request.getParameter("fine_yn")==null?"":request.getParameter("fine_yn"));
		client.setItem_mail_yn	(request.getParameter("item_mail_yn")==null?"":request.getParameter("item_mail_yn"));
		client.setTax_mail_yn	(request.getParameter("tax_mail_yn")==null?"":request.getParameter("tax_mail_yn"));
		client.setPrint_car_st 	(request.getParameter("print_car_st")==null?"":request.getParameter("print_car_st"));
		client.setEtax_item_st 	(request.getParameter("etax_item_st")==null?"":request.getParameter("etax_item_st"));
		client.setReg_id	 	(user_id);
	
		//주민(법인)등록번호와 사업자등록번호로 중복체크
		count = al_db.checkSSN(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
	
		if(count == 0){
			//네오엠 거래처 처리-------------------------------
			AddBillMngDatabase bmd = AddBillMngDatabase.getInstance();
			NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
			//중복체크
			String ven_code ="";
			if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("2", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		
			if(ven_code.equals("")){
					
				TradeBean t_bean = new TradeBean();
			
				t_bean.setCust_name	(AddUtil.substring(client.getFirm_nm(),15));
				t_bean.setS_idno	(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
				t_bean.setId_no		(client.getSsn1()+client.getSsn2());
				t_bean.setDname		(AddUtil.substring(client.getClient_nm(),15));
				t_bean.setMail_no	(client.getO_zip());
				t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
				t_bean.setUptae		(AddUtil.substring(client.getBus_cdt(),15));
				t_bean.setJong		(AddUtil.substring(client.getBus_itm(),15));
			
				if(client.getClient_st().equals("2")){
					t_bean.setS_idno("8888888888");
				}
			
				if(!neoe_db.insertTrade(t_bean)) flag += 1;	
			
				if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("2", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
				if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			
				client.setVen_code	(ven_code);
				
			}else{
				client.setVen_code	(ven_code);
			}
		
			//거래처정보
			client = al_db.insertNewClient(client);
		
			client_id 	= client.getClient_id()==null?"":client.getClient_id();
		
		}
		
%>
	<script language='javascript'>
<%	if(count == 0){
		if(client != null){ //정상
			if(page_gubun.equals("NEW")){	%>
				alert('정상적으로 등록되었습니다');
<%			}%>


				parent.location.href = "client_s_p.jsp?rent_st=<%=rent_st%>&h_con=1&h_wd=<%=client.getFirm_nm()%>";
			
<%		}else{ //에러
			if(page_gubun.equals("NEW")){	%>
				alert('등록되지 않았습니다');
<%			}
		}
	}else{%>
				alert('이미 등록된 주민(법인)등록번호입니다.\n\n확인하십시오.');
<%	}%>
</script>
</body>
</html>
