<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.bill_mng.*, acar.user_mng.*, acar.coolmsg.* "%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 			= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_dt 		= request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	String cng_st 		= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");	
	String ven_cng_st 	= request.getParameter("ven_cng_st")==null?"":request.getParameter("ven_cng_st");	
	String upd_auth 	= request.getParameter("upd_auth")==null?"":request.getParameter("upd_auth");	
	String cl_nm_change = request.getParameter("cl_nm_change")==null?"":request.getParameter("cl_nm_change");
	String cl_nm_change2 = request.getParameter("cl_nm_change2")==null?"":request.getParameter("cl_nm_change2");
	
	boolean flag = true;
	int flag2 = 0;
	
	//변경전데이타
	ClientBean client_be = al_db.getNewClient(client_id);
	
	String cl_nm_before = client_be.getClient_nm();	
	String o_o_addr = client_be.getO_addr();
	String o_firm_nm = client_be.getFirm_nm();
	String o_enp_no = client_be.getEnp_no1()+""+client_be.getEnp_no2()+""+client_be.getEnp_no3();
	String o_ssn = client_be.getSsn1()+""+client_be.getSsn2();
	
	client_be.setReg_id(user_id);

	//이력관리-이력테이블에 등록하기
	if(cng_st.equals("Y")){
		flag = al_db.insertClientEnp(client_be, AddUtil.addZero(seq), cng_dt);
	}
	
	
	String o_ven_code = client_be.getVen_code();
	
	String t_zip[] = request.getParameterValues("t_zip");
	String t_addr[] = request.getParameterValues("t_addr");
	
	
	
	//변경후데이타
	ClientBean client = client_be;
	
	client.setClient_st	(request.getParameter("client_st")==null?"":request.getParameter("client_st"));
	client.setOpen_year	(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
	client.setClient_nm	(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
	client.setFirm_nm	(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	
	if(upd_auth.equals("Y")){
		client.setSsn1		(request.getParameter("ssn1")==null?"":request.getParameter("ssn1"));
		client.setSsn2		(request.getParameter("ssn2")==null?"":request.getParameter("ssn2"));
		//개인사업자는 생년월일만
		if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
			client.setSsn2	("");
		}
		client.setEnp_no1	(request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1"));
		client.setEnp_no2	(request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2"));
		client.setEnp_no3	(request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3"));
		client.setTaxregno(request.getParameter("taxregno")==null?"":request.getParameter("taxregno"));
	}
	client.setBus_cdt	(request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"));
	client.setBus_itm	(request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"));
	client.setO_addr	(t_addr[0]);
	client.setO_zip		(t_zip[0]);
	client.setHo_addr	(t_addr[1]);
	client.setHo_zip	(t_zip[1]);
	client.setUpdate_id	(user_id);
	
	String n_o_addr = client.getO_addr();
	String n_firm_nm = client.getFirm_nm();
	String n_enp_no = client.getEnp_no1()+""+client.getEnp_no2()+""+client.getEnp_no3();
	String n_ssn = client.getSsn1()+""+client.getSsn2();
	
	
	//네오엠거래처관련처리--------------------------------------
	
	if(ven_cng_st.equals("1") || ven_cng_st.equals("3")){//자동등록, 거래처변경
	
		//중복체크
		String ven_code ="";
		if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("2", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
		if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(client.getFirm_nm(),15), client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());	//-> neoe_db 변환
		
		if(ven_code.equals("")){
						
			TradeBean t_bean = new TradeBean();
			
			t_bean.setCust_name	(AddUtil.substringb(client.getFirm_nm(),30));
			t_bean.setS_idno		(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			t_bean.setId_no			(client.getSsn1()+client.getSsn2());
			t_bean.setDname			(AddUtil.substring(client.getClient_nm(),15));
			t_bean.setMail_no		(client.getO_zip()); //우편번호
			t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
			t_bean.setUptae			(AddUtil.substringb(client.getBus_cdt(),30));
			t_bean.setJong			(AddUtil.substringb(client.getBus_itm(),30));
			
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
		t_bean.setS_idno		(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		t_bean.setId_no			(client.getSsn1()+client.getSsn2());
		t_bean.setDname			(AddUtil.substring(client.getClient_nm(),15));
		t_bean.setMail_no		(client.getO_zip());
		t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
		t_bean.setUptae			(AddUtil.substringb(client.getBus_cdt(),30));
		t_bean.setJong			(AddUtil.substringb(client.getBus_itm(),30));
		t_bean.setUser_id		(user_id);
		t_bean.setMd_gubun	("Y");
		
		if(client.getClient_st().equals("2")){
			t_bean.setS_idno("8888888888");
		}
				
		if(!neoe_db.updateTrade(t_bean)) flag2 += 1;	//-> neoe_db 변환
		
	}
	
	//2. 새로운 데이타 수정하기
	flag = al_db.updateClient3(client);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	

	//개인사업자의 사업자등록증 내역 추가시 대표자의 이름이 변경되면 과태료 담당자에게 쿨메신저 발송
	if(cl_nm_change.equals("Y")){
		String sub 		 = "사업자등록증 대표자 수정";
		String cont 	 = "개인사업자 [ "+client.getFirm_nm()+" ] 의 대표자 성명이 [ "+cl_nm_before+" ] 에서 [ "+client.getClient_nm()+" ] 으로 변경되었습니다.  &lt;br&gt; &lt;br&gt; 변경된 대표자의 생년월일과 일치하는 운전면허번호 인지 확인바랍니다.";
		String target_id = nm_db.getWorkAuthUser("과태료담당자");
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"  <ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//동일거래처 영업담당자 현황
		Vector conts = a_db.getLcRentClientBusid2(client_id);
		int cont_size = conts.size();
		
		if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)conts.elementAt(i);							
				UsersBean target_bean2 	= umd.getUsersBean(String.valueOf(ht.get("BUS_ID2")));
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";			
			}
		}
		
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		cm_db.insertCoolMsg(msg);
	}
	
	//법인의 사업자등록증 내역 변경시 대표자의 이름이 변경되면 내근직이 수정했을때 계약담당자한테 쿨메신저 발송
	if(cl_nm_change2.equals("Y")){
		String sub 		 = "사업자등록증 대표자 수정";
		String cont 	 = "법인 [ "+client.getFirm_nm()+" ] 의 대표자 성명이 [ "+cl_nm_before+" ] 에서 [ "+client.getClient_nm()+" ] 으로 변경되었습니다.  &lt;br&gt; &lt;br&gt; 연대보증인, 계약자 운전면허번호 등 확인바랍니다.";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"  <ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";
		
		//동일거래처 영업담당자 현황
		Vector conts = a_db.getLcRentClientBusid2(client_id);
		int cont_size = conts.size();
		
		if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)conts.elementAt(i);							
				UsersBean target_bean 	= umd.getUsersBean(String.valueOf(ht.get("BUS_ID2")));
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";			
			}
		}
					
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		cm_db.insertCoolMsg(msg);
	}
	
	//법인의 사업자등록증 내역 변경시 대표자의 이름이 변경되면 보험담당자에게 쿨메신저 발송(20191105)
	if(cl_nm_change2.equals("Y")){
		
		//고객의 계약내역을 fetch
		Vector conts = l_db.getContList(client_id);
		int cont_size = conts.size();
		String xml_content = "";
		if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable cont = (Hashtable)conts.elementAt(i);
				if(!String.valueOf(cont.get("IS_RUN")).equals("해약")){
					xml_content += "["+cont.get("RENT_L_CD")+" ("+cont.get("CAR_NO")+") ] ";	
				}			
			}
		}
		String target_id = nm_db.getWorkAuthUser("보증보험담당자");			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String sub 	 = "법인 대표자 변경";
		String cont 	 = "법인 [ "+client.getFirm_nm()+" ] 의 대표자 성명이 [ "+cl_nm_before+" ] 에서 [ "+client.getClient_nm()+" ] 으로 변경되었습니다.  &lt;br&gt; &lt;br&gt; 보증보험 관련사항 확인바랍니다. \n\n"
		                     + xml_content;
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"  <ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>"+
					"	 <TARGET>"+target_bean.getId()+"</TARGET>"+
					"    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		cm_db.insertCoolMsg(msg);
	}
	
	//고객피보험자 고객인지 확인
	Vector vts1 = al_db.getClientInsurFnmList(client_id);
	int vt_size1 = vts1.size();
	if(vt_size1 > 0 ){
		if(cl_nm_change.equals("Y") || cl_nm_change2.equals("Y") || !o_o_addr.equals(n_o_addr) || !o_firm_nm.equals(n_firm_nm) || !o_enp_no.equals(n_enp_no) || !o_ssn.equals(n_ssn)){
			
			String xml_content = "";
			if(vt_size1 > 0){
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable cont = (Hashtable)vts1.elementAt(i);
					xml_content += "["+cont.get("CAR_NO")+"] ";	
				}
			}
			
			String target_id = nm_db.getWorkAuthUser("보험담당자");			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String sub 	 = "고객피보험자 고객변경";
			String cont  = "고객피보험자 고객정보가 변경되었습니다.  &lt;br&gt; &lt;br&gt; 보험 관련사항 확인바랍니다.  &lt;br&gt; &lt;br&gt; \n\n"
			                     + xml_content;
			
			if(cl_nm_change.equals("Y") || cl_nm_change2.equals("Y")){
				cont = cont + " #대표자변경";
			}
			if(!o_o_addr.equals(n_o_addr)){
				cont = cont + " #사업자주소변경";
			}
			if(!o_firm_nm.equals(n_firm_nm)){
				cont = cont + " #상호변경";
			}
			if(!o_enp_no.equals(n_enp_no)){
				cont = cont + " #사업자번호변경";
			}
			if(!o_ssn.equals(n_ssn)){
				if(client.getClient_st().equals("1")){
					cont = cont + " #생년월일변경";	
				}				
			}
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"  <ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL></URL>"+
						"	 <TARGET>"+target_bean.getId()+"</TARGET>"+
						"    <SENDER>"+sender_bean.getId()+"</SENDER>"+
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			cm_db.insertCoolMsg(msg);
		}
	}
	
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
	function open_client_mail(){
		var SUBWIN="client_cont_cng.jsp?client_id=<%=client_id%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&from_page=<%=from_page%>";	
		window.open(SUBWIN, "ClientContCng", "left=3, top=50, width=1240, height=800, resizable=yes, scrollbars=yes, status=yes");
	}

<%
	if(flag)
	{
%>
		alert('수정되었습니다');
		
		<%if(!o_o_addr.equals(n_o_addr)){%>
		alert('사업장주소가 변경되었습니다. 계약의 우편물주소도 확인하여 수정해주십시오.');
		open_client_mail();
		<%}%>		
		
		parent.window.close();		
		
		var fm = document.form1;
		
		if(fm.from_page.value == '/tax/tax_mng/tax_mng_sc.jsp'){
		
		}else{	
			fm.target = "d_content";		
			fm.action = "/fms2/client/client_c.jsp";				
			fm.submit();		
		}
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