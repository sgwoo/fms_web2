<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_dt = request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	String cng_st = request.getParameter("cng_st")==null?"":request.getParameter("cng_st");	
	String ven_cng_st = request.getParameter("ven_cng_st")==null?"":request.getParameter("ven_cng_st");	
	
	boolean flag = true;
	int flag2 = 0;
	
	//변경전데이타
	ClientBean client_be = al_db.getNewClient(client_id);
	
	client_be.setReg_id(user_id);

	//이력관리-이력테이블에 등록하기
	if(cng_st.equals("Y")){
		flag = al_db.insertClientEnp(client_be, AddUtil.addZero(seq), cng_dt);
	}
	
	
	String o_ven_code = client_be.getVen_code();
	
	String t_zip[] = request.getParameterValues("t_zip");
	String t_addr[] = request.getParameterValues("t_addr");
	
	
	
	//변경후데이타
	//ClientBean client = new ClientBean();
	ClientBean client = client_be;
	
	//client.setClient_id	(client_id);
	client.setClient_st	(request.getParameter("client_st")==null?"":request.getParameter("client_st"));
	client.setOpen_year	(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
	client.setClient_nm	(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
	client.setFirm_nm	(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	client.setSsn1		(request.getParameter("ssn1")==null?"":request.getParameter("ssn1"));
	client.setSsn2		(request.getParameter("ssn2")==null?"":request.getParameter("ssn2"));
	//개인사업자는 생년월일만
	if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
		client.setSsn2	("");
	}
	client.setEnp_no1	(request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1"));
	client.setEnp_no2	(request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2"));
	client.setEnp_no3	(request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3"));
	client.setBus_cdt	(request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"));
	client.setBus_itm	(request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"));
	client.setO_addr	(t_addr[0]);
	client.setO_zip		(t_zip[0]);
	client.setHo_addr	(t_addr[1]);
	client.setHo_zip	(t_zip[1]);
	client.setUpdate_id	(user_id);
	//client.setVen_code	(o_ven_code);
	client.setTaxregno	(request.getParameter("taxregno")==null?"":request.getParameter("taxregno"));
	
	
	
	
	//네오엠거래처관련처리--------------------------------------
	
	if(ven_cng_st.equals("1") || ven_cng_st.equals("3")){//자동등록, 거래처변경
	
		//중복체크
		String ven_code ="";
		if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("2", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
		if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
		
		if(ven_code.equals("")){
						
			TradeBean t_bean = new TradeBean();
			
			t_bean.setCust_name	(AddUtil.substringb(client.getFirm_nm(),30));
			t_bean.setS_idno	(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			t_bean.setId_no		(client.getSsn1()+client.getSsn2());
			t_bean.setDname		(AddUtil.substring(client.getClient_nm(),15));
			t_bean.setMail_no	(client.getO_zip()); //우편번호
			t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
			t_bean.setUptae		(AddUtil.substringb(client.getBus_cdt(),30));
			t_bean.setJong		(AddUtil.substringb(client.getBus_itm(),30));
			
			if(client.getClient_st().equals("2")){
				t_bean.setS_idno("8888888888");
			}

			if(!neoe_db.insertTrade(t_bean)) flag2 += 1;	//-> neoe_db 변환
			
			if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("2", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
			if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
			
			client.setVen_code	(ven_code);
			
		}else{	
			client.setVen_code	(ven_code);
		}
	}else if(ven_cng_st.equals("2")){//자동수정
	
		TradeBean t_bean = new TradeBean();
		t_bean.setCust_code	(client.getVen_code());
		t_bean.setCust_name	(AddUtil.substringb(client.getFirm_nm(),30));
		t_bean.setS_idno	(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		t_bean.setId_no		(client.getSsn1()+client.getSsn2());
		t_bean.setDname		(AddUtil.substring(client.getClient_nm(),15));
		t_bean.setMail_no	(client.getO_zip());
		t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
		t_bean.setUptae		(AddUtil.substringb(client.getBus_cdt(),30));
		t_bean.setJong		(AddUtil.substringb(client.getBus_itm(),30));
		t_bean.setUser_id	(user_id);
		t_bean.setMd_gubun	("Y");
		
		if(client.getClient_st().equals("2")){
			t_bean.setS_idno("8888888888");
		}
				
		if(!neoe_db.updateTrade(t_bean)) flag2 += 1;	//-> neoe_db 변환
		
	}
	
	//2. 새로운 데이타 수정하기
	flag = al_db.updateClient3(client);
%>
<form name='form1' action='./client_enp_p.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name=t_wd' value='<%=t_wd%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
<script language='javascript'>
<%
	if(flag)
	{
%>
		alert('수정되었습니다');
		parent.window.close();
		
		var fm = document.form1;
		
		if(fm.from_page.value == '/tax/tax_mng/tax_mng_sc.jsp'){
		
		}else{
	//		fm.target = "CLIENT_ENP";
			fm.target = "d_content";		
			fm.action = "/fms2/client/client_c.jsp";				
			fm.submit();		
		}
		
//		parent.location='/acar/mng_client2/client_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>';

<%
	}
	else
	{
%>
		alert('수정되지 않았습니다');
<%
	}
%>
</script>
</body>
</html>
