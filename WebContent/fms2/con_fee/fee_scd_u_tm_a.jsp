<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, tax.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String etc 		= request.getParameter("etc")==null?"":request.getParameter("etc");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));

	String rtn_yn 		= request.getParameter("rtn_yn")==null?"":request.getParameter("rtn_yn");
	String use_s_dt 	= request.getParameter("use_s_dt")==null?"":request.getParameter("use_s_dt");
	String use_e_dt 	= request.getParameter("use_e_dt")==null?"":request.getParameter("use_e_dt");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String fee_est_dt 	= request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String max_tm_auto 	= request.getParameter("max_tm_auto")==null?"":request.getParameter("max_tm_auto");
	int fee_amt 		= request.getParameter("fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int fee_s_amt 		= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int fee_v_amt 		= request.getParameter("fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int flag = 0;
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);

	
	//대여기본정보
	ContFeeBean cont_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	if(!cng_cau.equals("")){
		//변경이력 등록
		FeeScdCngBean cng = new FeeScdCngBean();
		cng.setRent_mng_id	(m_id);
		cng.setRent_l_cd	(l_cd);
		cng.setFee_tm		(fee_tm);
		cng.setAll_st		("");
		cng.setGubun		("한회차수정");
		cng.setCng_id		(user_id);
		cng.setCng_cau		(cng_cau);
		if(!af_db.insertFeeScdCng(cng)) flag += 1;
	}


		FeeScdBean o_fee = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
		
		FeeScdBean fee = o_fee;
		fee.setFee_s_amt	(fee_s_amt);
		fee.setFee_v_amt	(fee_v_amt);
		fee.setUse_s_dt		(use_s_dt);
		fee.setUse_e_dt		(use_e_dt);
		fee.setTax_out_dt	(tax_out_dt);
		fee.setReq_dt			(req_dt);
		fee.setR_req_dt		(af_db.getValidDt(fee.getReq_dt()));
		fee.setFee_est_dt	(fee_est_dt);
		fee.setR_fee_est_dt(af_db.getValidDt(fee.getFee_est_dt()));
		fee.setDly_days		("");	/* 대여 입금예정일을 다시 세팅하면 연체일 및 연체료도 다시 계산해야 한다. */
		fee.setDly_fee		(0);
		fee.setUpdate_id	(user_id);
		if(AddUtil.parseInt(AddUtil.replace(fee.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee.getReq_dt(),"-",""))){
			fee.setR_req_dt	(fee.getReq_dt());
		}
		fee.setEtc(etc);
		
		if(fee.getTm_st2().equals("4") && fee.getRc_amt() >0){
			fee.setRc_amt		(fee_s_amt+fee_v_amt);
		}
		
		if(!af_db.updateFeeScd(fee)) flag += 1;


		//20110125 잔액이 있는지 체크하여 처리
		Vector b_fees = af_db.getScdScdBalance(fee);	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
		int b_fee_size = b_fees.size();
		
		int balance_amt = fee.getFee_s_amt()+fee.getFee_v_amt()-fee.getRc_amt();
		
		if(b_fee_size>0){
			for(int d = 0 ; d < b_fee_size ; d++){
				FeeScdBean b_fee = (FeeScdBean)b_fees.elementAt(d);
				
				b_fee.setReq_dt			(fee.getReq_dt());
				b_fee.setR_req_dt		(fee.getR_req_dt());
				b_fee.setTax_out_dt		(fee.getTax_out_dt());
				b_fee.setFee_est_dt		(fee.getFee_est_dt());
				b_fee.setR_fee_est_dt		(fee.getR_fee_est_dt());
				b_fee.setUse_s_dt		(fee.getUse_s_dt());
				b_fee.setUse_e_dt		(fee.getUse_e_dt());
				
				//대여료변경인 경우 재계산
				if(balance_amt>0 || o_fee.getFee_s_amt() > fee.getFee_s_amt() || o_fee.getFee_s_amt() < fee.getFee_s_amt()){
					if(balance_amt>0){
						int b_s_amt = af_db.getAccountSupplyAmt(balance_amt);
						int b_v_amt = balance_amt-b_s_amt;
						b_fee.setFee_s_amt	(b_s_amt);
						b_fee.setFee_v_amt	(b_v_amt);
						balance_amt = b_fee.getFee_s_amt()+b_fee.getFee_v_amt()-b_fee.getRc_amt();
						if(balance_amt<0){
							System.out.println("[대여료스케줄 대여료 수정시 잔액처리 이상 확인 필요] rent_l_cd="+l_cd+", fee_tm="+b_fee.getFee_tm()+"==================");
							
							//알람메시지
							String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
							String sub 		= "대여료스케줄 수정- 잔액확인";
							String cont 	= "["+firm_nm+" " + l_cd +" "+fee_tm+"회차]  &lt;br&gt; &lt;br&gt; 대여료 스케줄 수정되었으나, 잔액이 이상합니다.  &lt;br&gt; &lt;br&gt; 확인하시기 바랍니다.";
							String target_id = user_id;
							boolean m_flag = true;
							
							//사용자 정보 조회
							UsersBean target_bean 	= umd.getUsersBean(target_id);
							
							String xml_data = "";
							xml_data =  "<COOLMSG>"+
						  				"<ALERTMSG>"+
			  							"    <BACKIMG>4</BACKIMG>"+
						  				"    <MSGTYPE>104</MSGTYPE>"+
			  							"    <SUB>"+sub+"</SUB>"+
						  				"    <CONT>"+cont+"</CONT>"+
			 							"    <URL></URL>";
							
							xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
							
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
							
							m_flag = cm_db.insertCoolMsg(msg);
						}
					}else{
						if(b_fee.getRc_amt()==0 && (fee.getFee_s_amt()+fee.getFee_v_amt()-fee.getRc_amt()) == 0){//잔액삭제
							if(!af_db.dropFeeScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, b_fee.getTm_st1())) flag += 1;
						}else{
							System.out.println("[대여료스케줄 대여료 수정시 잔액처리 이상 확인 필요] rent_l_cd="+l_cd+", fee_tm="+b_fee.getFee_tm()+"==================");
							
							//알람메시지
							String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
							String sub 		= "대여료스케줄 수정- 잔액확인";
							String cont 	= "["+firm_nm+" " + l_cd +" "+fee_tm+"회차]  &lt;br&gt; &lt;br&gt; 대여료 스케줄 수정되었으나, 잔액이 이상합니다.  &lt;br&gt; &lt;br&gt; 확인하시기 바랍니다.";
							String target_id = user_id;
							boolean m_flag = true;
							
							//사용자 정보 조회
							UsersBean target_bean 	= umd.getUsersBean(target_id);
							
							String xml_data = "";
							xml_data =  "<COOLMSG>"+
						  				"<ALERTMSG>"+
			  							"    <BACKIMG>4</BACKIMG>"+
						  				"    <MSGTYPE>104</MSGTYPE>"+
			  							"    <SUB>"+sub+"</SUB>"+
						  				"    <CONT>"+cont+"</CONT>"+
			 							"    <URL></URL>";
							
							xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
							
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
							
							m_flag = cm_db.insertCoolMsg(msg);
						}
					}
				}
				
				if(!af_db.updateFeeScd(b_fee)) flag += 1;
			}
		}
		
		//입금액이 월대여료보다 작은데 잔액이 없는 경우 잔행생성
		if(fee.getRc_amt()>0 && fee.getFee_s_amt()+fee.getFee_v_amt() > fee.getRc_amt() && b_fee_size==0){
			FeeScdBean rest_fee = fee;
			int rest_amt 	= fee_amt - fee.getRc_amt();
			int rest_s_amt 	= af_db.getAccountSupplyAmt(rest_amt);
			rest_fee.setTm_st1		(String.valueOf(Integer.parseInt(fee.getTm_st1())+1));	//잔액대여료. 기존 회차구분+1
			rest_fee.setFee_s_amt	(rest_s_amt);
			rest_fee.setFee_v_amt	(rest_amt - rest_s_amt);
			rest_fee.setRc_yn		("0");		//default는 0(미수금)
			rest_fee.setRc_dt		("");
			rest_fee.setRc_amt		(0);
			if(!af_db.insertFeeScd(rest_fee))	flag += 1;
		}



		//기발행 거래명세서 계산서 미발행상태일 경우 기발행 거래명세서 계산서예정일자도 변경 할것..
		int chk_cnt1 = af_db.getTaxDtChk(l_cd, rent_st, rent_seq, fee_tm);
		String item_id = "";
		
		//계산서 미발행상태
		if(chk_cnt1 ==0){
			item_id = af_db.getTaxItemDtChk(l_cd, rent_st, rent_seq, fee_tm);
			if(!item_id.equals("")){
				//거래명세서 조회
				TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
				//계산서예정일변경시 처리
				if(!ti_bean.getTax_est_dt().equals(AddUtil.replace(tax_out_dt,"-",""))){
					ti_bean.setTax_est_dt	(fee.getTax_out_dt());
					if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
					System.out.println("대여료 스케줄 수정시 거래명세서 계산서예정일자 수정"+ l_cd +" "+fee_tm);
				}
				//공급가액변경시 처리
				TaxItemListBean til_bean = IssueDb.getTaxItemListScdFeeCase(item_id, l_cd, fee_tm);
				if(til_bean.getItem_supply() > fee_s_amt || til_bean.getItem_supply() < fee_s_amt){
					
					til_bean.setItem_supply	(fee_s_amt);
					til_bean.setItem_value	(fee_v_amt);
					til_bean.setItem_dt1	(use_s_dt);
					til_bean.setItem_dt2	(use_e_dt);
					
					if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
					
					String reg_code = til_bean.getReg_code();
					
					//거래명세서 리스트 조회
					Vector tils	            	= IssueDb.getTaxItemListCase(item_id);
					int til_size            	= tils.size();
					int o_item_hap_num 		= ti_bean.getItem_hap_num();
					int n_item_hap_num 		= 0;
					for(int i = 0 ; i < til_size ; i++){
						TaxItemListBean til_bean2 = (TaxItemListBean)tils.elementAt(i);
						n_item_hap_num = n_item_hap_num + til_bean2.getItem_supply() + til_bean2.getItem_value();
					}
					ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(n_item_hap_num))+"원");
					ti_bean.setItem_hap_num(n_item_hap_num);
					if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
					System.out.println("대여료 스케줄 수정시 거래명세서 공급가액 수정"+ l_cd +" "+fee_tm);
					
					//변경된 거래명세서 이메일 재발송 : 프로시저 호출
					String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("", sender_bean.getId(), reg_code, item_id, "", "", "");		
				}
			}
		}else{
			System.out.println("대여료 스케줄 수정되었으나, 계산서는 이미 발행한 상태 : "+ l_cd +" "+fee_tm);
			
				//알람메시지
				String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
				String sub 		= "대여료스케줄 수정안내";
				String cont 	= "["+firm_nm+" " + l_cd +" "+fee_tm+"회차]  &lt;br&gt; &lt;br&gt; 대여료 스케줄 수정되었으나,  &lt;br&gt; &lt;br&gt; 계산서는 이미 발행한 상태이니 확인하시기 바랍니다.";
				String target_id = nm_db.getWorkAuthUser("세금계산서담당자");
				boolean m_flag = true;
				
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				
				//사용자 정보 조회
				UsersBean target_bean 	= umd.getUsersBean(target_id);
				
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
  							"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
  							"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
 							"    <URL></URL>";
				
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				
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
				
				m_flag = cm_db.insertCoolMsg(msg);
		}


	//마지막회차 자동으로 맞춤 (1회차스케줄, 분할청구 아닐 경우)
	if(max_tm_auto.equals("Y") && idx == 0 && !rtn_yn.equals("Y")){
		//계약기간 총대여료(부가세포함)
		int o_tot_fee_amt 		= request.getParameter("o_tot_fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_tot_fee_amt"));
		int o_tot_mon 				= request.getParameter("o_tot_mon")==null?0:AddUtil.parseDigit(request.getParameter("o_tot_mon"));
		
		Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", rent_st, "", "", m_id, l_cd, c_id, "", "1");
		int fee_scd_size = fee_scd.size();
		
		int total_amt = 0;
		int count1 = 0;
		String fm_use_e_dt 	= fee.getUse_e_dt();
		String f_use_end_dt = fee.getUse_e_dt();
		
		for(int j = 0 ; j < fee_scd_size ; j++){
			Hashtable ht = (Hashtable)fee_scd.elementAt(j);
			//1회차를 제외하고 사용기간, 발행예정일, 세금일자 변경
			if(j>0){
				FeeScdBean scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, String.valueOf(ht.get("FEE_TM")), String.valueOf(ht.get("TM_ST1")));
				
				//마지막회차
				if((j+1) == fee_scd_size){
					int max_tm_amt = o_tot_fee_amt-total_amt;
					int fee_fst_s_amt 	= af_db.getAccountSamt(max_tm_amt); //공급가계산하기
					int fee_fst_v_amt 	= max_tm_amt-fee_fst_s_amt;
					scd.setFee_s_amt(fee_fst_s_amt);
					scd.setFee_v_amt(fee_fst_v_amt);
					scd.setEtc("계산내역:"+(cont_fee.getFee_s_amt()+cont_fee.getFee_v_amt())+"원(월대여료VAT포함)*"+o_tot_mon+"개월에서 전스케줄합계를 뺀 나머지 금액");
				//중간회차
				}else{
					scd.setUse_e_dt	(c_db.addMonth(f_use_end_dt, count1));
					scd.setEtc("");
				}
				
				scd.setUse_s_dt		(c_db.addDay(fm_use_e_dt, 1));
				scd.setTax_out_dt	(c_db.addMonth(tax_out_dt, j));
				scd.setFee_est_dt	(c_db.addMonth(fee_est_dt, j));
				scd.setR_fee_est_dt	(af_db.getValidDt(scd.getFee_est_dt()));
				scd.setReq_dt		(c_db.addMonth(req_dt, j));
				scd.setR_req_dt		(af_db.getValidDt(scd.getReq_dt()));
				
				if(AddUtil.parseInt(AddUtil.replace(scd.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(scd.getReq_dt(),"-",""))){
					scd.setR_req_dt	(scd.getReq_dt());
				}
				
				if(!af_db.updateFeeScd(scd)) flag += 1;
				
				fm_use_e_dt = scd.getUse_e_dt();
			}
			
			count1++;
			
			//마지막회차 제외한 대여료총액
			if((j+1) < fee_scd_size){
				total_amt 	= total_amt + AddUtil.parseInt(String.valueOf(ht.get("FEE_AMT")));
			}
		}
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
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
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("스케줄이 변경되지 않았습니다");
//		location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>