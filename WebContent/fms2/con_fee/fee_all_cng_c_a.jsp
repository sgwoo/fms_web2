<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String use_s_dt = request.getParameter("use_s_dt")==null?"":request.getParameter("use_s_dt");
	String use_e_dt = request.getParameter("use_e_dt")==null?"":request.getParameter("use_e_dt");
	String fee_est_dt = request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String req_dt = request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt = request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	
	String comm_value = request.getParameter("comm_value")==null?"":request.getParameter("comm_value");
	String maxday_yn1 = request.getParameter("maxday_yn1")==null?"":request.getParameter("maxday_yn1");
	String maxday_yn2 = request.getParameter("maxday_yn2")==null?"":request.getParameter("maxday_yn2");
	String maxday_yn3 = request.getParameter("maxday_yn3")==null?"":request.getParameter("maxday_yn3");
	String fee_est_day_cng = request.getParameter("fee_est_day_cng")==null?"":request.getParameter("fee_est_day_cng");
	
	String tm_st2_4_yn = request.getParameter("tm_st2_4_yn")==null?"":request.getParameter("tm_st2_4_yn");
	String req_dt2 = request.getParameter("req_dt2")==null?"":request.getParameter("req_dt2");
	String tax_out_dt2 = request.getParameter("tax_out_dt2")==null?"":request.getParameter("tax_out_dt2");
	String maxday_yn4 = request.getParameter("maxday_yn4")==null?"":request.getParameter("maxday_yn4");
	

	String vid[] 		= request.getParameterValues("ch_l_cd");
	int vid_size 			= vid.length;
	String vid_num		= "";
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);

	out.println(vid_size+" <br><br>");
	
	String m_id = "";
	String l_cd = "";
	String rent_st = "";
	String rent_seq = "";
	String fee_tm = "";
	String tm_st2 = "";
	String t_use_s_dt = "";
	String t_use_e_dt = "";
	int    t_fee_s_amt = 0;
	int    t_fee_v_amt = 0;
	int    r_t_fee_s_amt = 0;
	int    r_t_fee_v_amt = 0;
	
	String fm_use_e_dt = "";
	int flag = 0;
	boolean flag3 	= true;
	boolean flag4 	= true;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	
	for(int l=0; l<vid_size; l++){
		vid_num = vid[l];
		int s=0;
		String app_value[] = new String[10];
		StringTokenizer st = new StringTokenizer(vid_num,"|");
		while(st.hasMoreTokens()){
			app_value[s] = st.nextToken();
			s++;
		}
		
		m_id = app_value[0];
		l_cd = app_value[1];
		rent_st = app_value[2];
		rent_seq = app_value[3];
		fee_tm = app_value[4];
		tm_st2 = app_value[5];
		t_use_s_dt = app_value[6];
		t_use_e_dt = app_value[7];
		t_fee_s_amt = AddUtil.parseInt(app_value[8]);
		t_fee_v_amt = AddUtil.parseInt(app_value[9]);
		r_t_fee_s_amt = 0;
		r_t_fee_v_amt = 0;
		
		out.println(m_id+" ");
		out.println(l_cd+" ");
		out.println(rent_st+" ");
		out.println(rent_seq+" ");
		out.println(fee_tm+" ");
		out.println(tm_st2+" ");
		out.println(t_use_s_dt+" ");
		out.println(t_use_e_dt+" ");
		out.println(t_fee_s_amt+" ");
		out.println(t_fee_v_amt+" <br>");
		
		//대여기본정보
		ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);	
		
		//대여료스케줄 한회차 정보
		FeeScdBean b_fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "0");
		
		//대여료스케줄 리스트
		Vector fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "ALL");	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
		int fee_size = fees.size();
		
		//대여료 스케줄
		if(!tm_st2.equals("4")){
			
				//납입 종료일
				String rent_end_dt = t_use_e_dt;
				//1회차 시작일
				String f_use_s_dt 	= use_s_dt;
				//1회차 실종료일
				String f_use_e_dt 	= use_e_dt;
				//스케줄 사용기간 만료일
				String r_use_end_dt = "";
				
				//변경이력 등록
				FeeScdCngBean cng = new FeeScdCngBean();
				cng.setRent_mng_id	(m_id);
				cng.setRent_l_cd		(l_cd);
				cng.setFee_tm				(fee_tm);
				cng.setAll_st				("Y");
				cng.setGubun				("대여료스케줄일괄처리");
				cng.setB_value			(b_fee_scd.getUse_s_dt()+"~"+b_fee_scd.getUse_e_dt());
				cng.setA_value			(use_s_dt+"~"+use_e_dt);
				cng.setCng_id				(user_id);
				cng.setCng_cau			("대여료스케줄일괄처리");
				if(!af_db.insertFeeScdCng(cng)) flag += 1;
				
				for(int i = 0 ; i < fee_size ; i++){
					FeeScdBean fee_scd = (FeeScdBean)fees.elementAt(i);
					int fee_reckon_yn = 0;	
					fee_scd.setFee_est_dt		(c_db.addMonth(fee_est_dt, i));
					fee_scd.setReq_dt				(c_db.addMonth(req_dt, i));
					fee_scd.setTax_out_dt		(c_db.addMonth(tax_out_dt, i));
					//변경첫회차
					if(i==0){
						fee_scd.setUse_s_dt		(f_use_s_dt);				//1회차 사용기간 시작일
						fee_scd.setUse_e_dt		(f_use_e_dt);				//1회차 사용기간 종료일
						fee_reckon_yn = 1;
					//변경마지막회차
					}else if(i+1==fee_size){
						//기간시작일은 전회차 다음날로 한다.
						fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));
						fee_scd.setUse_e_dt		(rent_end_dt);
						fee_reckon_yn = 2;
					//변경중간회차	
					}else{
						//2회차 기간시작일은 전회차 다음날로 한다.
						fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));
						fee_scd.setUse_e_dt		(c_db.addMonth(f_use_e_dt, i));
					}
					//대여료 일자계산하기
					if(fee_reckon_yn==1){
						Hashtable mon_ht = af_db.getUseMonDay(fee_scd.getUse_e_dt(), fee_scd.getUse_s_dt());
						int u_mon = AddUtil.parseInt(String.valueOf(mon_ht.get("U_MON")));
						int u_day = AddUtil.parseInt(String.valueOf(mon_ht.get("U_DAY")));
						int fee_amt	= af_db.getUseMonDayAmt(fee.getFee_s_amt()+fee.getFee_v_amt(), u_mon, u_day);
						fee_scd.setFee_s_amt	(af_db.getSupAmt(fee_amt));
						fee_scd.setFee_v_amt	(fee_amt-fee_scd.getFee_s_amt());
					}else if(fee_reckon_yn==2){
						Hashtable mon_ht = af_db.getUseMonDay(fee_scd.getUse_e_dt(), fee_scd.getUse_s_dt());
						int u_mon = AddUtil.parseInt(String.valueOf(mon_ht.get("U_MON")));
						int u_day = AddUtil.parseInt(String.valueOf(mon_ht.get("U_DAY")));
						int fee_amt	= af_db.getUseMonDayAmt(fee.getFee_s_amt()+fee.getFee_v_amt(), u_mon, u_day);
						fee_scd.setFee_s_amt	(af_db.getSupAmt(fee_amt));
						fee_scd.setFee_v_amt	(fee_amt-fee_scd.getFee_s_amt());
						//fee_scd.setFee_s_amt	(t_fee_s_amt-r_t_fee_s_amt);
						//fee_scd.setFee_v_amt	(t_fee_v_amt-r_t_fee_v_amt);
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-",""))){
							fee_scd.setFee_est_dt(fee_scd.getUse_e_dt());
						}	
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-",""))){
							fee_scd.setReq_dt		(fee_scd.getUse_e_dt());
						}	
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getTax_out_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-",""))){
							fee_scd.setTax_out_dt(fee_scd.getUse_e_dt());
						}
					}else{
						fee_scd.setFee_s_amt	(fee.getFee_s_amt());
						fee_scd.setFee_v_amt	(fee.getFee_v_amt());
					}
					if(fee_reckon_yn < 2 && maxday_yn1.equals("Y")){
						String s_cng_dt = AddUtil.replace(fee_scd.getUse_e_dt(),"-",""); 
						int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
						int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
						int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						fee_scd.setUse_e_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
					}
					if(fee_reckon_yn < 2 && maxday_yn2.equals("Y")){
						String s_cng_dt = AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
						int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
						int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
						int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						fee_scd.setFee_est_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
					}
					if(fee_reckon_yn < 2 && maxday_yn3.equals("Y")){
						String s_cng_dt = AddUtil.replace(fee_scd.getTax_out_dt(),"-",""); 
						int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
						int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
						int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						fee_scd.setTax_out_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
					}
					fee_scd.setR_fee_est_dt	(af_db.getValidDt(fee_scd.getFee_est_dt()));
					fee_scd.setR_req_dt			(af_db.getValidDt(fee_scd.getReq_dt()));
					if(AddUtil.parseInt(AddUtil.replace(fee_scd.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
						fee_scd.setR_req_dt		(fee_scd.getReq_dt());
					}	
					
					if(!af_db.updateFeeScd(fee_scd)) flag += 1;
					
					//마지막회차
					if(fee_reckon_yn == 2){
					
						int max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
						
						if(max_tm_add_l_use_days > 15 ){
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -15));
						}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -10));
						}else{
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -5));
						}
						fee_scd.setR_req_dt			(fee_scd.getReq_dt());
						
						if(!af_db.updateFeeScd(fee_scd)) flag += 1;
						
						//마지막회차 사용기간이 1달이상일때 나누기
						if(max_tm_add_l_use_days > 40 ){
							FeeScdBean add_fee_scd = fee_scd;
							//한달치
							fee_scd.setFee_s_amt		(fee.getFee_s_amt());
							fee_scd.setFee_v_amt		(fee.getFee_v_amt());
							fee_scd.setUse_e_dt			(c_db.addMonth(f_use_e_dt, i));
							fee_scd.setFee_est_dt		(c_db.addMonth(fee_est_dt, i));
							fee_scd.setReq_dt				(c_db.addMonth(req_dt, i));
							fee_scd.setTax_out_dt		(c_db.addMonth(tax_out_dt, i));
							fee_scd.setR_fee_est_dt	(af_db.getValidDt(fee_scd.getFee_est_dt()));
							fee_scd.setR_req_dt			(af_db.getValidDt(fee_scd.getReq_dt()));
							if(AddUtil.parseInt(AddUtil.replace(fee_scd.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
								fee_scd.setR_req_dt		(fee_scd.getReq_dt());
							}
							
							if(!af_db.updateFeeScd(fee_scd)) flag += 1;
							
							add_fee_scd.setFee_tm				(String.valueOf(AddUtil.parseInt(fee_scd.getFee_tm())+1));
							add_fee_scd.setFee_s_amt		(add_fee_scd.getFee_s_amt()-fee.getFee_s_amt());
							add_fee_scd.setFee_v_amt		(add_fee_scd.getFee_v_amt()-fee.getFee_v_amt());
							add_fee_scd.setUse_s_dt			(c_db.addDay(fee_scd.getUse_e_dt(), 1));
							add_fee_scd.setFee_est_dt		(c_db.addMonth(fee_est_dt, i+1));
							add_fee_scd.setReq_dt				(c_db.addMonth(req_dt, i+1));
							add_fee_scd.setTax_out_dt		(c_db.addMonth(tax_out_dt, i+1));
							if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getFee_est_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-",""))){
								add_fee_scd.setFee_est_dt(add_fee_scd.getUse_e_dt());
							}	
							if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-",""))){
								add_fee_scd.setReq_dt		(add_fee_scd.getUse_e_dt());
							}	
							if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getTax_out_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-",""))){
								add_fee_scd.setTax_out_dt(add_fee_scd.getUse_e_dt());
							}
							add_fee_scd.setR_fee_est_dt	(af_db.getValidDt(add_fee_scd.getFee_est_dt()));
							add_fee_scd.setR_req_dt			(af_db.getValidDt(add_fee_scd.getReq_dt()));
							if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){
								add_fee_scd.setR_req_dt		(add_fee_scd.getReq_dt());
							}
							if(!af_db.insertFeeScd(add_fee_scd)) flag += 1;
							
						}
						
						if(max_tm_add_l_use_days <= 0 ){
							if(!af_db.dropFeeScdNew(m_id, l_cd, fee_scd.getRent_st(), fee_scd.getRent_seq(), fee_scd.getFee_tm(), fee_scd.getTm_st1())) flag += 1; 
						}
					
					}
					
					
					r_use_end_dt = fee_scd.getUse_e_dt();
					r_t_fee_s_amt = r_t_fee_s_amt + fee_scd.getFee_s_amt();
					r_t_fee_v_amt = r_t_fee_v_amt + fee_scd.getFee_v_amt();
					
					
					
					//기발행 거래명세서 계산서 미발행상태일 경우 기발행 거래명세서 계산서예정일자도 변경 할것..
					if(AddUtil.parseInt(AddUtil.replace(b_fee_scd.getR_req_dt(),"-","")) <= AddUtil.parseInt(AddUtil.getDate(4)) || AddUtil.parseInt(AddUtil.replace(b_fee_scd.getTax_out_dt(),"-","")) <= AddUtil.parseInt(AddUtil.getDate(4)) ){
						
						int chk_cnt1 = af_db.getTaxDtChk(l_cd, rent_st, rent_seq, fee_scd.getFee_tm());
						String item_id = "";
						
						//계산서 미발행상태
						if(chk_cnt1 ==0){
							item_id = af_db.getTaxItemDtChk(l_cd, fee_scd.getRent_st(), fee_scd.getRent_seq(), fee_scd.getFee_tm());
							if(!item_id.equals("")){
								//거래명세서 조회
								TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
								int tax_cng_cnt = 0;
								//계산서발급일자 변경시 처리
								if(!ti_bean.getTax_est_dt().equals(AddUtil.replace(fee_scd.getTax_out_dt(),"-",""))){
									ti_bean.setTax_est_dt	(fee_scd.getTax_out_dt());
									if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
									tax_cng_cnt++;
								}
								//공급가액 변경시 처리
								TaxItemListBean til_bean = IssueDb.getTaxItemListScdFeeCase(item_id, l_cd, fee_scd.getFee_tm());
								int item_hap_num = ti_bean.getItem_hap_num();
								if(til_bean.getItem_supply() > fee_scd.getFee_s_amt() || til_bean.getItem_supply() < fee_scd.getFee_s_amt()){
									//공급가가 감소한 경우
									if(til_bean.getItem_supply() > fee_scd.getFee_s_amt()){
										item_hap_num = item_hap_num - (til_bean.getItem_supply()-fee_scd.getFee_s_amt());
									}
									//공급가가 증가한 경우
									if(til_bean.getItem_supply() < fee_scd.getFee_s_amt()){
										item_hap_num = item_hap_num + (fee_scd.getFee_s_amt()-til_bean.getItem_supply());
									}
									ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(item_hap_num))+"원");
									ti_bean.setItem_hap_num(item_hap_num);
									if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
									til_bean.setItem_supply	(fee_scd.getFee_s_amt());
									til_bean.setItem_value	(fee_scd.getFee_v_amt());
									tax_cng_cnt++;
								}
								if(tax_cng_cnt>0){
									if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
								}
								String reg_code = til_bean.getReg_code();
								//거래명세서 리스트 조회
								Vector tils	            	= IssueDb.getTaxItemListCase(item_id);
								int til_size           	 	= tils.size();
								int n_item_hap_num 		= 0;
								for(int k = 0 ; k < til_size ; k++){
									TaxItemListBean til_bean2 = (TaxItemListBean)tils.elementAt(k);
									n_item_hap_num = n_item_hap_num + til_bean2.getItem_supply() + til_bean2.getItem_value();
								}
								ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(n_item_hap_num))+"원");
								ti_bean.setItem_hap_num(n_item_hap_num);
								if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
							
								//변경된 거래명세서 이메일 재발송 : 프로시저 호출
								String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("", sender_bean.getId(), reg_code, item_id, "", "", "");		
							
							}
						}	
					}
					
				}	

				//결제일변경
				if(fee_est_day_cng.equals("Y")){
					if(maxday_yn2.equals("Y")){
						fee.setFee_est_day	("99");
					}else{
						fee.setFee_est_day	(fee_est_dt.substring(6,8));
					}
					if(!a_db.updateContFeeNew(fee))	flag += 1;
				
					//자동이체정보도 수정
					ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
					if(!cms.getRent_mng_id().equals("")){
						cms.setCms_day(fee.getFee_est_day());
						if(cms.getCms_day().equals("99")){
							cms.setCms_day("31");
						}
						cms.setUpdate_id	(user_id);
						flag3 = a_db.updateContCmsMng(cms);
					}
				}

		
				
		//선납금균등발행 스케줄 : 이미 입금된것이라 스케줄 변동은 없다.
		}else{
			if(tm_st2_4_yn.equals("Y")){ //선납금균등발행스케줄도 일괄 처리한다 선택시
				
				//변경이력 등록
				FeeScdCngBean cng = new FeeScdCngBean();
				cng.setRent_mng_id	(m_id);
				cng.setRent_l_cd		(l_cd);
				cng.setFee_tm				(fee_tm);
				cng.setAll_st				("Y");
				cng.setGubun				("대여료스케줄일괄처리");
				cng.setB_value			(b_fee_scd.getReq_dt()+", "+b_fee_scd.getTax_out_dt());
				cng.setA_value			(req_dt2+", "+tax_out_dt2);
				cng.setCng_id				(user_id);
				cng.setCng_cau			("대여료스케줄일괄처리-선납금균등발행 스케줄");
				if(!af_db.insertFeeScdCng(cng)) flag += 1;
				
				for(int i = 0 ; i < fee_size ; i++){
					FeeScdBean fee_scd = (FeeScdBean)fees.elementAt(i);
					fee_scd.setReq_dt				(c_db.addMonth(req_dt2, i));
					fee_scd.setTax_out_dt		(c_db.addMonth(tax_out_dt2, i));
					if(maxday_yn4.equals("Y")){
						String s_cng_dt = AddUtil.replace(fee_scd.getTax_out_dt(),"-",""); 
						int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
						int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
						int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						fee_scd.setTax_out_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
					}
					if(!af_db.updateFeeScd(fee_scd)) flag += 1;
				}
				
			}
		}
		
	}

	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="client_id" 		value="<%=client_id%>">
</form>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("스케줄이 변경되지 않았습니다");
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='c_foot';
		fm.action='./fee_all_cng_c.jsp';
		fm.submit();	
		//parent.window.close();	
<%	}			%>
</script>
</body>
</html>