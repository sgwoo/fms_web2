<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*, acar.bill_mng.*, acar.common.*, acar.client.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String pp_st 	= request.getParameter("pp_st")==null?"":request.getParameter("pp_st");
	String pp_tm 	= request.getParameter("pp_tm")==null?"":request.getParameter("pp_tm");
	
	String pay_dt	= request.getParameter("pay_dt")==null?Util.getDate():request.getParameter("pay_dt");
	String est_dt	= request.getParameter("est_dt")==null?pay_dt:request.getParameter("est_dt");
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	String ebill	= request.getParameter("ebill")==null?"N":request.getParameter("ebill");
	String tax_branch= request.getParameter("tax_branch")==null?"S1":request.getParameter("tax_branch");
	String enp_no	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
	String ssn		= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String bigo		= request.getParameter("bigo")==null?"":request.getParameter("bigo");
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	//소속영업소 리스트 조회
	
	Hashtable br = c_db.getBranch("S1");  //무조건 본사
	
	//전자입금표일련번호
	String SeqId = IssueDb.getSeqIdNext("PayEBill","PE");
//	System.out.println("SeqId ="+SeqId+"<br>");


	//보증금 입금표발행----------------------------
	if(ebill.equals("Y") && (pp_st.equals("0")||pp_st.equals("5"))){
	
		SaleEBillBean sb_bean = new SaleEBillBean();
		
		sb_bean.setSeqID		(SeqId);
		sb_bean.setDocCode		("03");
		sb_bean.setDocKind		("03");
		sb_bean.setS_EbillKind	("1");//1:일반입금표 2:위수탁입금표
		sb_bean.setRefCoRegNo	("");
		sb_bean.setRefCoName	("");
		sb_bean.setTaxSNum1		("");
		sb_bean.setTaxSNum2		("");
		sb_bean.setTaxSNum3		("");
		sb_bean.setDocAttr		("N");
		sb_bean.setOrigin		("");
		sb_bean.setPubDate		(pay_dt);
		sb_bean.setSystemCode	("KF");
					
		//공급자------------------------------------------------------------------------------
		sb_bean.setMemID		("amazoncar11");
		sb_bean.setMemName		(user_bean.getUser_nm());
		sb_bean.setEmail		("tax@amazoncar.co.kr");				//계산서 담당 메일 주소
		sb_bean.setTel			(user_bean.getHot_tel());
	
		sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName		("(주)아마존카");
		sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
		//공급받는자--------------------------------------------------------------------------
		sb_bean.setRecMemID		("");
		sb_bean.setRecMemName	(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
		sb_bean.setRecEMail		(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email"));
		sb_bean.setRecTel		(request.getParameter("tel")==null?"":request.getParameter("tel"));
		//공급받는자가 개인일때와 법인일대의 처리
		
		sb_bean.setRemarks	(bigo+  "-" + l_cd );
		sb_bean.setRecCoRegNo(enp_no);
		
		sb_bean.setRecCoName	(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
		sb_bean.setRecCoCeo		(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
		sb_bean.setRecCoAddr	(request.getParameter("addr")==null?"":request.getParameter("addr"));
		sb_bean.setRecCoBizType	(request.getParameter("i_sta")==null?"":request.getParameter("i_sta"));
		sb_bean.setRecCoBizSub	(request.getParameter("i_item")==null?"":request.getParameter("i_item"));
		//내용-----------------------------------------------------------------------------------
		//sb_bean.setSupPrice	(request.getParameter("grt_s_amt")==null?0:Util.parseDigit(request.getParameter("grt_s_amt")));
		//sb_bean.setTax		(request.getParameter("grt_v_amt")==null?0:Util.parseDigit(request.getParameter("grt_v_amt")));
		sb_bean.setSupPrice		(pay_amt);
		sb_bean.setTax			(0);
		sb_bean.setPubKind		("N");
		sb_bean.setLoadStatus	(0);
		sb_bean.setPubCode		("");
		sb_bean.setPubStatus	("");
		sb_bean.setItemName1	(bigo);
		
		if(!IssueDb.insertPayEBill(sb_bean)){
			flag3 += 1;
		}else{
		
			//거래처에 메일수신자 정보가 없다면 수정해준다.
			ClientBean client = al_db.getClient(client_id);
			if(client.getCon_agnt_email().equals("")){
				client.setCon_agnt_nm	(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
				client.setCon_agnt_m_tel(request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel"));
				client.setCon_agnt_email(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email").trim());
				client.setUpdate_id		(user_id);
				if(!al_db.updateClient2(client)) flag3 += 1;
			}
			//이동전화가 있으면 입금발행 안내문자를 보낸다.
			String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			if(!AddUtil.replace(agnt_m_tel," ","").equals("")){
				String sendname = "(주)아마존카";
				String sendphone = "02-392-4243";
				if(!agnt_m_tel.equals("")){
					IssueDb.insertsendMail(sendphone, sendname, agnt_m_tel, firm_nm, "", "+0.01", firm_nm+"님 입금표를 발행하였습니다.-아마존카-");
				}
			}
		}
	}


	if(flag3 == 0){
		//선수금 스케줄 입금처리----------------------------
		ExtScdBean pay_grt = ae_db.getAGrtScd(m_id, l_cd, rent_st, pp_st, pp_tm);
		
		if(ebill.equals("Y") && (pp_st.equals("0")||pp_st.equals("5")) ){
			pay_grt.setSeqId(SeqId);
		}
		
		if(mode.equals("pay")){
			pay_grt.setExt_est_dt(est_dt);
			pay_grt.setExt_pay_amt(pay_amt);
			pay_grt.setExt_pay_dt(pay_dt);
			pay_grt.setUpdate_id(user_id);
			if(!ae_db.receiptGrt(pay_grt))  	flag += 1;
		}else{
			if(!ae_db.i_updateGrt(pay_grt)) flag += 1;
		}
	//	System.out.println("mode="+ mode + ": seqid = " + SeqId);

		if(mode.equals("pay")){
			//네오엠 자동전표 처리-------------------------------
			String autodoc	= request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
			int count =0;
			
			NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
			
			//사용자정보-더존
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
			String insert_id = String.valueOf(per.get("SA_CODE"));
					
			if(autodoc.equals("Y")){
			
				AutoDocuBean ad_bean = new AutoDocuBean();
				
				ad_bean.setNode_code("S101");			
				ad_bean.setVen_code	(request.getParameter("ven_code2")==null?"":request.getParameter("ven_code2"));
				ad_bean.setFirm_nm	(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
				ad_bean.setAcct_dt	(request.getParameter("acct_dt")==null?"":request.getParameter("acct_dt"));
				ad_bean.setAcct_code	(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
				ad_bean.setBank_code	(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
				ad_bean.setBank_name	(request.getParameter("bank_name")==null?"":request.getParameter("bank_name"));
				ad_bean.setDeposit_no	(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));
				ad_bean.setAcct_cont	(request.getParameter("acct_cont")==null?"":request.getParameter("acct_cont"));
				ad_bean.setAmt		(pay_amt);
				ad_bean.setInsert_id	(insert_id);
				
				count = neoe_db.insertFeeAutoDocu(ad_bean);
				
				//전표정보 거래처테이블에 추가하기
				ClientBean client = al_db.getClient(client_id);
				if(client.getVen_code().equals("") || client.getBank_code().equals("") || client.getDeposit_no().equals("")){
					client.setVen_code	(ad_bean.getVen_code());
					client.setBank_code	(ad_bean.getBank_code());
					client.setDeposit_no(ad_bean.getDeposit_no());
					if(!al_db.updateClient2(client)) flag2 += 1;
				}
			}
		}
	}
%>
<html>
<head><title>FMS</title></head>
<body>
<form name='form1' action='/fms2/con_grt/grt_u.jsp' method="POST">
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='pp_st' value='<%=pp_st%>'>
<input type='hidden' name='pp_tm' value='<%=pp_tm%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else if(flag3 == 1){%>
		alert('입금표발행 오류발생!');
		location='about:blank';	
<%	}else if(flag2 == 1){%>
		alert('자동전표 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');
		document.form1.target='d_content';
		document.form1.submit();
		parent.close();
<%	}%>
</script>
</body>
</html>
