<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='file:///C|/inetpub/wwwroot/include/common.js'></script>
</head>
<body leftmargin="15">
<%
	ClientBean client = new ClientBean();
	String page_gubun = request.getParameter("h_page_gubun");
	int count =0;
	int flag = 0;

	if(page_gubun.equals("NEW")){ //신규등록한 고객
		
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
		client.setHomepage(request.getParameter("t_homepage").equals("http://")?"":request.getParameter("t_homepage"));
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
		client.setOpen_year(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
		//client.setFirm_price(request.getParameter("t_firm_price").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price")));
		//client.setFirm_price_y(request.getParameter("t_firm_price_y").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_y")));
		//client.setFirm_price_b(request.getParameter("t_firm_price_b").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_b")));		
		//client.setFirm_day(request.getParameter("t_firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day")));
		//client.setFirm_day_y(request.getParameter("t_firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_y")));
		//client.setFirm_day_b(request.getParameter("t_firm_day_b").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_b")));
		client.setEtc("오프리스");
		client.setCon_agnt_email(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
		client.setNationality	(request.getParameter("nationality")==null?"":request.getParameter("nationality"));
		
		//주민(법인)등록번호 중복체크
//		count = al_db.checkSSN(client.getSsn1()+client.getSsn2());
		//주민(법인)등록번호와 사업자등록번호로 중복체크
		count = al_db.checkSSN(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		
		if(count == 0){
		
			//네오엠 거래처 처리-------------------------------	
			NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
			
			String ven_code = "";
			
			if (client.getClient_st().equals("2"))  	ven_code = neoe_db.getVenCode(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
			if (!client.getClient_st().equals("2"))  	ven_code = neoe_db.getVenCode2(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
			
			
			if(ven_code.equals("")){
				
				TradeBean t_bean = new TradeBean();
				
				t_bean.setCust_name	(AddUtil.substring(client.getFirm_nm(),15));
				t_bean.setS_idno	(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
				t_bean.setId_no		(client.getSsn1()+client.getSsn2());
				t_bean.setDname		(AddUtil.substring(client.getClient_nm(),15));
				t_bean.setMail_no	(client.getO_zip());  //우편번호
				t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
				t_bean.setUptae		(AddUtil.substring(client.getBus_cdt(),15));
				t_bean.setJong		(AddUtil.substring(client.getBus_itm(),15));
				
				if(client.getClient_st().equals("2")){
					t_bean.setS_idno("8888888888");
				}

				if(!neoe_db.insertTrade(t_bean)) flag += 1;	//-> neoe_db 변환
				
				if (client.getClient_st().equals("2"))  	ven_code = neoe_db.getVenCode(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
				if (!client.getClient_st().equals("2"))  	ven_code = neoe_db.getVenCode2(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
								
				client.setVen_code	(ven_code);
			}else{
				client.setVen_code	(ven_code);
			}
		
			client = al_db.insertNewClient(client);
		}
		
	}else if(page_gubun.equals("EXT")){ // 검색결과고객을 계약기본화면으로 보내준다
		String client_id = request.getParameter("h_c_id");
		client = al_db.getClient(client_id);
	}
%>
	<script language='javascript'>
<%	if(count == 0){
		if(client != null){ //정상
			if(page_gubun.equals("NEW")){	%>
				alert('정상적으로 등록되었습니다');
				
				var fm = parent.opener.form1;
				
				fm.client_id.value 	= <%="'" + client.getClient_id() + "'"%>;
				fm.firm_nm.value 	= <%="'" + client.getFirm_nm() + "'"%>;
								
				if(fm.sui_nm.value == '')	fm.sui_nm.value 	= <%="'" + client.getFirm_nm() + "'"%>;
				if(fm.ssn1.value == '')		fm.ssn1.value 		= <%="'" + client.getSsn1() + "'"%>;
				if(fm.ssn2.value == '')		fm.ssn2.value 		= <%="'" + client.getSsn2() + "'"%>;				
				if(fm.enp_no1.value == '')	fm.enp_no1.value 	= <%="'" + client.getEnp_no1() + "'"%>;
				if(fm.enp_no2.value == '')	fm.enp_no2.value 	= <%="'" + client.getEnp_no2() + "'"%>;
				if(fm.enp_no3.value == '')	fm.enp_no3.value 	= <%="'" + client.getEnp_no3() + "'"%>;								
				if(fm.d_zip.value == '')	fm.d_zip.value 		= <%="'" + client.getO_zip() + "'"%>;
				if(fm.d_addr.value == '')	fm.d_addr.value 	= <%="'" + client.getO_addr() + "'"%>;
				
				parent.window.close();			
					
//				parent.location.href = "client_s_p.jsp?h_con=1&h_wd=<%//=client.getFirm_nm()%>";

<%			}	%>
			
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
