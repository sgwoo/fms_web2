<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.cont.*,  acar.forfeit_mng.*, acar.pay_mng.*, acar.res_search.*, acar.client.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String vid1[] = request.getParameterValues("m_id");
	String vid2[] = request.getParameterValues("l_cd");
	String vid3[] = request.getParameterValues("c_id");
	String vid4[] = request.getParameterValues("seq_no");
	
	int vid_size = 0;
	vid_size = vid1.length;
	
	String proxy_est_dt = request.getParameter("proxy_est_dt")==null?"":request.getParameter("proxy_est_dt");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String reg_type = request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	String act_union_yn = request.getParameter("act_union_yn")==null?"":request.getParameter("act_union_yn");
	String reg_st = request.getParameter("reg_st")==null?"":request.getParameter("reg_st");
	
	
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	
	int flag = 0;
	int flag1 = 0;
	int flag2 = 0;
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	AddForfeitDatabase 	a_fdb 	= AddForfeitDatabase.getInstance();
	ForfeitDatabase 	fdb 	= ForfeitDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	String search_code  = Long.toString(System.currentTimeMillis());
	String reqseq		= "";
	String p_cont 		= "";
	
	String client_id          ="";
	String site_id 		= "";
		
	//과태료정보
	
	for(int i=0;i < vid_size;i++){
		
		ch_m_id = vid1[i];
		ch_l_cd = vid2[i];
		ch_c_id = vid3[i];
		ch_seq_no = vid4[i];
		
		if(reg_st.equals("1")){
			//과태료납부예정일자 등록 - 청구는 납부일 + 15 일이후 도래되는 스케쥴의 입금예정일
			if(!a_fdb.updateForfeitProxyDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), proxy_est_dt, user_id, gubun )) flag += 1;
			// 과태료에 발송일 저장
	 		if(!a_fdb.updateForfeitPrintDemDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), user_id)) flag2 += 1;
		}
		
		f_bean = a_fdb.getForfeitDetailAll(ch_c_id, ch_m_id, ch_l_cd, ch_seq_no);
		
		FineGovBn = FineDocDb.getFineGov(f_bean.getPol_sta());
		
		rl_bean = fdb.getCarRent(ch_c_id, ch_m_id, ch_l_cd);
		
		
		//계약정보		
		ContBaseBean base 	= a_db.getContBaseAll(ch_m_id, ch_l_cd);
		client_id = base.getClient_id();
	
		if(base.getTax_type().equals("2")){//지점
			site_id = base.getR_site();
		}else{
			site_id = "";
		}
				
		//거래처정보
		ClientBean client = al_db.getNewClient(client_id);
	
		
		//대차이용시
		if(!f_bean.getRent_s_cd().equals("")){//예약시스템 등록 차량이면
			//단기계약정보
			RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), ch_c_id);
			//고객정보
			RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
			String rent_st = rc_bean.getRent_st();
			
			if(rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("10")||rent_st.equals("12")){
				client = al_db.getNewClient(rc_bean.getCust_id());
			}
		
		}
				
		String ven_type = "";
		String s_idno = "";
		
		String client_st = client.getClient_st(); //2:개인
		
		String i_ssn = "";		
		i_ssn = client.getSsn1() + client.getSsn2();
			
		String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
		if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
			
		String i_addr 		= client.getO_addr();
		String i_sta 		= client.getBus_cdt();
		String i_item 		= client.getBus_itm();
		
		String i_ven_code = "";
		i_ven_code	= client.getVen_code();	
	
		if(base.getTax_type().equals("2")){//지점	
			if(! base.getR_site().equals("")){
				//거래처지점정보
				ClientSiteBean site = al_db.getClientSite(client_id, site_id);
				
				i_ven_code = site.getVen_code();
				if(!i_ven_code.equals("")){
								i_enp_no 		= site.getEnp_no();
								i_addr 			= site.getAddr();
								i_sta 			= site.getBus_cdt();
								i_item 			= site.getBus_itm();
								i_ven_code		= site.getVen_code();
								i_ssn 		    	= "";								
				}	
			}
		}
		
		if(i_ven_code.equals("")) i_ven_code = neoe_db.getVenCode(i_ssn, i_enp_no);
		
		Hashtable vendor = neoe_db.getVendorCase(i_ven_code);
		
	
	
		//출금원장 등록
		PayMngBean bean = new PayMngBean();
		
		bean.setReqseq		("");
		bean.setP_est_dt	(proxy_est_dt);
		bean.setP_gubun		("21");
		bean.setP_way		("1");
		bean.setP_st1		("21");
		bean.setP_st2		("과태료");
		bean.setP_st3		("현금");
		bean.setP_st4		("일일납입");
		bean.setP_st5		(rl_bean.getCar_no());
		bean.setP_cd1		(ch_c_id);
		bean.setP_cd2		(ch_seq_no);
		bean.setP_cd3		(ch_m_id);
		bean.setP_cd4		(ch_l_cd);
		bean.setP_cd5		(f_bean.getVio_dt());
		bean.setAmt			((long)f_bean.getPaid_amt());
		bean.setSub_amt1((long)f_bean.getPaid_amt());
		bean.setSub_amt2((long)f_bean.getPaid_amt2());
		bean.setBank_id		("");
		bean.setBank_nm		(FineGovBn.getBank_nm());
		bean.setBank_no		(FineGovBn.getBank_no());
		
		//입금계좌 처리
		if(!bean.getBank_nm().equals("") && bean.getBank_id().equals("")){
			Hashtable bank = ps_db.getBankCode("", bean.getBank_nm());
			if(String.valueOf(bank.get("CMS_BK")).equals("null")){
				
			}else{
				bean.setBank_id(String.valueOf(bank.get("CMS_BK")));
			}
		}
		bean.setBank_acc_nm	(FineGovBn.getGov_nm());
		
		bean.setOff_st		("gov_id");
		bean.setOff_id		(FineGovBn.getGov_id());
		bean.setOff_nm		(FineGovBn.getGov_nm());
		
		
		bean.setVen_code	(i_ven_code);
		bean.setVen_name	(String.valueOf(vendor.get("VEN_NAME")));
		
		//적요
		p_cont = "과태료 "+f_bean.getVio_cont()+" ";
		if(f_bean.getFault_st().equals("2")){
			p_cont += "업무상과실 "+c_db.getNameById(f_bean.getFault_nm(),"USER")+" ";
		}else{
			if(!f_bean.getRent_s_cd().equals("")){//예약시스템 등록 차량이면
				//단기계약정보
				RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), ch_c_id);
				//고객정보
				RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
				String rent_st = rc_bean.getRent_st();
				if(rent_st.equals("1"))		rent_st = "단기대여 ";
				else if(rent_st.equals("2"))	rent_st = "정비대차 ";
				else if(rent_st.equals("3"))	rent_st = "사고대차 ";
				else if(rent_st.equals("4"))	rent_st = "업무대여 ";
				else if(rent_st.equals("5"))	rent_st = "업무지원 ";
				else if(rent_st.equals("6"))	rent_st = "차량정비 ";
				else if(rent_st.equals("7"))	rent_st = "차량점검 ";
				else if(rent_st.equals("8"))	rent_st = "정비대차 ";
				else if(rent_st.equals("9"))	rent_st = "보험대차 ";
				else if(rent_st.equals("10"))	rent_st = "지연대차 ";
				else if(rent_st.equals("12"))	rent_st = "월렌트 ";
				
				p_cont += rent_st;
				
				if(rc_bean2.getCust_st().equals("직원"))		p_cont += rc_bean2.getCust_nm();
				else 											p_cont += rc_bean2.getFirm_nm(); 
			}else{
				p_cont += rl_bean.getFirm_nm();
			}
		}
		p_cont += " "+rl_bean.getCar_no()+" "+rl_bean.getCar_nm();
		bean.setP_cont		(p_cont);
		
		bean.setBuy_user_id	(f_bean.getMng_id());
		if(bean.getBuy_user_id().equals("")){
			bean.setBuy_user_id(rl_bean.getBus_id2());
		}
		bean.setAcct_code	("12400");
		
		bean.setP_step		("0");
		bean.setReg_st		("S");
		bean.setReg_id		(user_id);
		bean.setSearch_code	(search_code);
		if(bean.getBank_no().equals("")){
			bean.setBank_acc_nm("");
		}
		bean.setVen_st		("0");
		bean.setTax_yn		("N");
		bean.setAcct_code_st("1");
		bean.setAct_union_yn(act_union_yn);
		
		if(!bean.getBank_no().equals("")){
			bean.setP_way		("5");
		}
				
		if(gubun.equals("1") && reg_type.equals("2")){
			//묶음 (한국도로공사 엑셀등록분) - 
		//	bean.setAcct_code	("13400");//가지급금처리
		//	bean.setVen_code	("003957");
		//	bean.setVen_name	("한국도로공사");
			
			reqseq = pm_db.insertPaySearch(bean);
		}else{
			reqseq = pm_db.insertPay(bean);
			
			bean.setI_seq		(1);
			bean.setI_amt		(bean.getAmt());
			bean.setI_s_amt	(bean.getAmt());
			if(!pm_db.insertPayItem(bean)) flag1 += 1;
		}
	}
		
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){		
	
		var fm = document.form1;
		<%if(gubun.equals("1") && reg_type.equals("2")){%>
		fm.action = '/fms2/pay_mng/pay_list_reg_a_step2.jsp';
		<%}else{%>
		fm.action = 'forfeit_r_frame.jsp';
		fm.target = "d_content";
		<%}%>
		fm.submit();

		parent.window.close();		
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
<input type='hidden' name='from_page' value='/fms2/forfeit_mng/forfeit_s_frame.jsp'>
</form>
<a href="javascript:go_step2()">다음 단계로 가기</a>
<script language='javascript'>
<!--
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("등록되었습니다.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>