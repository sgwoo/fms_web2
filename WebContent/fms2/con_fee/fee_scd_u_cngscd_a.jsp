<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, tax.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<%
	
	out.println("처리시작...");


	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	String auth 		= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq		= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cng_st 		= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));


	String fee_tm 		= request.getParameter("r_fee_tm")==null?"":request.getParameter("r_fee_tm");
	String c_all 		= request.getParameter("c_all")==null?"N":request.getParameter("c_all");
	String max_auto 	= request.getParameter("max_auto")==null?"N":request.getParameter("max_auto");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String fee_est_dt 	= request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String cng_dt 		= request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	String cng_cau 		= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String s_max_tm 	= request.getParameter("s_max_tm")==null?"":request.getParameter("s_max_tm");
	String comm_value 	= request.getParameter("comm_value")==null?"N":request.getParameter("comm_value");
	String fee_est_day_cng 	= request.getParameter("fee_est_day_cng")==null?"N":request.getParameter("fee_est_day_cng");
	String fee_amt_cng 	= request.getParameter("fee_amt_cng")==null?"N":request.getParameter("fee_amt_cng");
	
	String ins_cng 		= request.getParameter("ins_cng")==null?"N":request.getParameter("ins_cng");
	int ins_cng_amt 	= request.getParameter("ins_cng_amt")==null?0:AddUtil.parseDigit(request.getParameter("ins_cng_amt"));
	String ins_cng_dt 	= request.getParameter("ins_cng_dt")==null?"":request.getParameter("ins_cng_dt");
	String ins_cng_st 	= request.getParameter("ins_cng_st")==null?"":request.getParameter("ins_cng_st");	
	
	String fee_est_y 	= request.getParameter("fee_est_y")==null?"":request.getParameter("fee_est_y");
	String fee_est_m 	= request.getParameter("fee_est_m")==null?"":request.getParameter("fee_est_m");
	String fee_est_d 	= request.getParameter("fee_est_d")==null?"":request.getParameter("fee_est_d");
	
	String maxday_yn 	= request.getParameter("maxday_yn")==null?"":request.getParameter("maxday_yn");
	String maxday_yn2 	= request.getParameter("maxday_yn2")==null?"":request.getParameter("maxday_yn2");
	
	int a_fee_s_amt		= request.getParameter("a_fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("a_fee_s_amt"));
	int a_fee_amt		= request.getParameter("a_fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("a_fee_amt"));
	int fee_amt 		= request.getParameter("fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int fee_s_amt 		= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int fee_v_amt 		= request.getParameter("fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int mon_st		= request.getParameter("mon_st")==null?1:AddUtil.parseInt(request.getParameter("mon_st"));
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	int flag 	= 0;
	int flag2   = 0;
	boolean flag3 	= true;
	boolean flag4 	= true;
	
	
	Vector fees = new Vector();
	int fee_size = 0;
	
	
	out.println("fee_tm="+fee_tm+"<br>");


	//변경이력 등록
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id	(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm		(fee_tm);
	cng.setAll_st		(c_all);
	cng.setCng_id		(user_id);
	cng.setCng_cau		(request.getParameter("cng_cau"));
	if(c_all.equals("M")){
		cng.setCng_cau	(s_max_tm+"회차까지 적용 : "+request.getParameter("cng_cau"));
	}
	if(ins_cng.equals("Y")){
		if(ins_cng_st.equals("2")){
			cng.setCng_cau	(cng.getCng_cau()+", 월대여료 변경처리 - 대여료변경 증감액"+ins_cng_amt+"원, 변경일자"+ins_cng_dt);
		}else{
			cng.setCng_cau	(cng.getCng_cau()+", 월대여료 변경처리 - 보험변경 증감액"+ins_cng_amt+"원, 변경일자"+ins_cng_dt);
		}
		
	}
	
	if(cng_st.equals("fee_amt")){
		cng.setGubun	("대여료");
		cng.setB_value	(request.getParameter("a_fee_amt"));
		cng.setA_value	(request.getParameter("fee_amt"));
		
		if(!cng.getB_value().equals(cng.getA_value()) && fee_amt_cng.equals("Y")){
			//계약-대여료변경이력
			LcRentCngHBean cng_bean = new LcRentCngHBean();
			cng_bean.setRent_mng_id		(m_id);
			cng_bean.setRent_l_cd		(l_cd);
			cng_bean.setCng_item		("fee_amt");
			cng_bean.setOld_value		(cng.getB_value());
			cng_bean.setNew_value		(cng.getA_value());
			cng_bean.setCng_cau		(cng.getCng_cau());
			cng_bean.setCng_id		(ck_acar_id);
			cng_bean.setRent_st		(rent_st);
			cng_bean.setS_amt		(fee_s_amt);
			cng_bean.setV_amt		(fee_v_amt);
			flag4 = a_db.updateLcRentCngH(cng_bean);	
			
			if(c_all.equals("Y") || c_all.equals("M")){
				//분할스케줄의 월대여료 변경시 반영
				FeeRtnBean rtn = af_db.getFeeRtn(m_id, l_cd, rent_st, rent_seq);
				if(!rtn.getRent_l_cd().equals("")){
					rtn.setRtn_amt	(fee_amt);
					if(!af_db.updateFeeRtn(rtn))	flag2 += 1;
				}
			}
		}
		
		
	}else if(cng_st.equals("req_dt")){
		cng.setGubun	("발행예정일");	
		cng.setB_value	(request.getParameter("a_req_dt"));
		cng.setA_value	(request.getParameter("req_dt"));
	}else if(cng_st.equals("tax_out_dt")){
		cng.setGubun	("청구일자");	
		cng.setB_value	(request.getParameter("a_tax_out_dt"));
		cng.setA_value	(request.getParameter("tax_out_dt"));
	}else if(cng_st.equals("fee_est_dt")){
		cng.setGubun	("입금예정일");	
		cng.setB_value	(request.getParameter("a_fee_est_dt"));
		cng.setA_value	(request.getParameter("fee_est_dt"));
		
		if(fee_est_day_cng.equals("Y")){//!cng.getB_value().equals(cng.getA_value()) && 
			//대여기본정보
			ContFeeBean b_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
			String fee_est_day = AddUtil.replace(fee_est_dt,"-","");
			if(fee_est_day.length() == 8){
				fee_est_day = fee_est_d;
				int mon_last_day = AddUtil.getMonthDate(AddUtil.parseInt(fee_est_y), AddUtil.parseInt(fee_est_m));
				if(AddUtil.parseInt(fee_est_day)==mon_last_day){
					b_fee.setFee_est_day	("99");
				}else{
					b_fee.setFee_est_day	(fee_est_day);
				}
				if(!a_db.updateContFeeNew(b_fee))	flag += 1;
				System.out.println("입금예정일변경시 결제일변경(FEE)"+l_cd);
				out.println("입금예정일변경시 결제일변경(FEE)"+l_cd);
				
				
				//자동이체정보도 수정
				ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
				if(!cms.getRent_mng_id().equals("")){
					cms.setCms_day(b_fee.getFee_est_day());
					if(cms.getCms_day().equals("99")){
						cms.setCms_day("31");
					}
					cms.setUpdate_id	(user_id);
					flag3 = a_db.updateContCmsMng(cms);
					System.out.println("입금예정일변경시 결제일변경(CMS)"+l_cd);
					out.println("입금예정일변경시 결제일변경(CMS)"+l_cd);
				}else{
					System.out.println("입금예정일변경시 결제일변경(CMS 정보 없음)"+l_cd);
					out.println("입금예정일변경시 결제일변경(CMS 정보 없음)"+l_cd);
				}
			}
		}
	}
	
	
			
	
	if(!af_db.insertFeeScdCng(cng)) flag += 1;
	


	/*선택회차부터 모두 변경*/
	if(c_all.equals("Y")){
		fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "ALL");	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}else if(c_all.equals("O")){
		fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "ONE");	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}else if(c_all.equals("M")){
		fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, s_max_tm);	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}


out.println("c_all="+c_all+"<br>");
out.println("fee_tm="+fee_tm+"<br>");
out.println("fee_size="+fee_size+"<br>");




	for(int i = 0 ; i < fee_size ; i++){
		FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
		if(cng_st.equals("fee_amt")){
			
			fee.setFee_s_amt	(fee_s_amt);
			fee.setFee_v_amt	(fee_v_amt);
			
			//출고전대차 1회차나 신차 1회차인경우 하루+ 여부
			String day_more_yn = "";
			
			if(i == 0 && fee.getRent_st().equals("1")){
				day_more_yn = af_db.getScdfeeDayMoreYn(fee.getRent_mng_id(), fee.getRent_l_cd(), fee.getRent_st(), fee.getRent_seq(), fee.getFee_tm(), fee.getTm_st1(), fee.getTm_st2());
			}
			
			if(i==0 && ins_cng.equals("Y")){
				
				if(!fee.getUse_s_dt().equals(AddUtil.replace(ins_cng_dt,"-",""))){
					
					//보험변경일전
					int int_fee_amt1 = 0;
					Hashtable dt_ht1 = af_db.getUseMonDay(ins_cng_dt, fee.getUse_s_dt());
					if(day_more_yn.equals("Y")){
						dt_ht1 = af_db.getUseMonDay2(ins_cng_dt, fee.getUse_s_dt());
					} 
					if( AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON"))) + AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) > 0 ){
						int max_fee_amt = ( a_fee_amt*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON"))) ) + ( a_fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) );
						int_fee_amt1 = max_fee_amt;
					}
					//보험변경일포함이후
					int int_fee_amt2 = 0;
					Hashtable dt_ht2 = af_db.getUseMonDay(fee.getUse_e_dt(), c_db.addDay(ins_cng_dt, 1));
					if( AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON"))) + AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) > 0 ){
						int max_fee_amt = ( fee_amt*AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON"))) ) + ( fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) );
						int_fee_amt2 = max_fee_amt;
					}
					
					//딱한달일때 - 실제한달일수로 나눔
					Hashtable dt_ht0 = af_db.getUseMonDay(fee.getUse_e_dt(), fee.getUse_s_dt());
					int use_day2 = 30-AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY")));
					if(day_more_yn.equals("Y")){
						dt_ht0 = af_db.getUseMonDay2(fee.getUse_e_dt(), fee.getUse_s_dt());
					}
					if( AddUtil.parseInt(String.valueOf(dt_ht0.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht0.get("U_DAY"))) ==0 ){
						if( AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) ==0 ){
							int_fee_amt1 = a_fee_amt;
							int_fee_amt2 = 0;
						}else if( AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) ==0 ){
							int_fee_amt1 = 0;
							int_fee_amt2 = fee_amt;
						}else{
							int_fee_amt1 = ( a_fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) );
							int_fee_amt2 = ( fee_amt  /30*use_day2 );
						}
					}
					
					fee.setFee_s_amt	(af_db.getSupAmt(int_fee_amt1+int_fee_amt2));
					fee.setFee_v_amt	(int_fee_amt1+int_fee_amt2-fee.getFee_s_amt());
					
					//fee.setFee_s_amt	(int_fee_s_amt1+int_fee_s_amt2);
					//fee.setFee_v_amt	((int_fee_s_amt1+int_fee_s_amt2)*10/100);
					
					/*
					out.println("<br>u_mon1="+String.valueOf(dt_ht1.get("U_MON")));
					out.println("<br>u_day1="+String.valueOf(dt_ht1.get("U_DAY")));
					out.println("<br>u_mon2="+String.valueOf(dt_ht2.get("U_MON")));
					out.println("<br>u_day2="+String.valueOf(dt_ht2.get("U_DAY")));
					out.println("<br>int_fee_s_amt1="+int_fee_s_amt1);
					out.println("<br>int_fee_s_amt2="+int_fee_s_amt2);
					out.println("<br>a_fee_s_amt="+a_fee_s_amt);
					out.println("<br>fee_s_amt="+fee_s_amt);
					out.println("<br>fee.getFee_s_amt()="+fee.getFee_s_amt());
					*/
					
					String ins_cng_cau = "일할계산내역:";
					if(!String.valueOf(dt_ht1.get("U_MON")).equals("0")) ins_cng_cau += a_fee_amt+"원(월대여료VAT포함)*"+String.valueOf(dt_ht1.get("U_MON"))+"개월";
					if(!String.valueOf(dt_ht1.get("U_MON")).equals("0") && !String.valueOf(dt_ht1.get("U_DAY")).equals("0"))	ins_cng_cau += "+";
					if(!String.valueOf(dt_ht1.get("U_DAY")).equals("0")) ins_cng_cau += a_fee_amt+"원/30*"+String.valueOf(dt_ht1.get("U_DAY"))+"일";
					ins_cng_cau += ")+(";
					if(!String.valueOf(dt_ht2.get("U_MON")).equals("0")) ins_cng_cau += fee_amt+"원(월대여료VAT포함)*"+String.valueOf(dt_ht2.get("U_MON"))+"개월";
					if(!String.valueOf(dt_ht2.get("U_MON")).equals("0") && !String.valueOf(dt_ht2.get("U_DAY")).equals("0"))	ins_cng_cau += "+";
					if(!String.valueOf(dt_ht2.get("U_DAY")).equals("0")) ins_cng_cau += fee_amt+"원/30*"+String.valueOf(dt_ht2.get("U_DAY"))+"일";
					ins_cng_cau += ")";
					
					if( AddUtil.parseInt(String.valueOf(dt_ht0.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht0.get("U_DAY"))) ==0 ){
						if( AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) ==0 ){
							ins_cng_cau = "일할계산내역:";
							ins_cng_cau += a_fee_amt+"원(월대여료VAT포함)/30*30일";
							ins_cng_cau += ")";
						}else if( AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) ==0 ){
							ins_cng_cau = "일할계산내역:";
							ins_cng_cau += fee_amt+"원(월대여료VAT포함)/30*30일";
							ins_cng_cau += ")";
						}else{
							ins_cng_cau = "일할계산내역:";
							ins_cng_cau += a_fee_amt+"원(월대여료VAT포함)/30*"+String.valueOf(dt_ht1.get("U_DAY"))+"일";
							ins_cng_cau += ")+(";
							ins_cng_cau += fee_amt+"원(월대여료VAT포함)/30*"+use_day2+"일";
							ins_cng_cau += ")";
						}
					}
					fee.setEtc	(ins_cng_cau);
					
					//대여변경이력
					FeeScdCngBean cng2 = af_db.getFeeScdCngCase(m_id, l_cd, "", cng.getCng_cau());
					cng2.setCng_cau		(cng.getCng_cau()+ins_cng_cau);
					if(!af_db.updateFeeScdCngCase(cng2)) flag += 1;
					
					//대여기본정보
					ContFeeBean b_fee2 = a_db.getContFeeNew(m_id, l_cd, rent_st);
					b_fee2.setFee_cdt	(b_fee2.getFee_cdt()+" / ["+AddUtil.getDate()+"] "+cng2.getCng_cau());			
					if(!a_db.updateContFeeNew(b_fee2))	flag += 1;
				}
				
			}
			
			
			if(c_all.equals("Y") && max_auto.equals("Y") && (i+1)==fee_size){
				
				Hashtable dt_ht = af_db.getUseMonDay(fee.getUse_e_dt(), fee.getUse_s_dt());
				
				if( AddUtil.parseInt(String.valueOf(dt_ht.get("U_MON"))) + AddUtil.parseInt(String.valueOf(dt_ht.get("U_DAY"))) > 0 ){
					
					int max_fee_amt = ( fee_amt*AddUtil.parseInt(String.valueOf(dt_ht.get("U_MON"))) ) + ( fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht.get("U_DAY"))) );
					
					fee.setFee_s_amt	(af_db.getSupAmt(max_fee_amt));
					fee.setFee_v_amt	(max_fee_amt-fee.getFee_s_amt());
					
					fee.setEtc				("일자계산내역:"+fee_amt+"원(월대여료VAT포함)*"+String.valueOf(dt_ht.get("U_MON"))+"+"+fee_amt+"원/30일*"+String.valueOf(dt_ht.get("U_DAY"))+"일");
					
					//fee.setFee_s_amt	(max_fee_s_amt);
					//fee.setFee_v_amt	(max_fee_s_amt*10/100);
					
				}
				
			}
		}else if(cng_st.equals("req_dt")){
			
			fee.setReq_dt		(c_db.addMonth(req_dt, i));
			if(mon_st == 12) 		fee.setReq_dt		(c_db.addMonth(req_dt, i*12));
			if(comm_value.equals("Y"))	fee.setReq_dt		(req_dt);
			
			String s_cng_dt = AddUtil.replace(fee.getReq_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(req_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn.equals("Y")){							
				fee.setReq_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setReq_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
			
			fee.setR_req_dt		(af_db.getValidDt(fee.getReq_dt()));
						
			
		}else if(cng_st.equals("tax_out_dt")){
			
			fee.setTax_out_dt	(c_db.addMonth(tax_out_dt, i));
			if(mon_st == 12) 		fee.setTax_out_dt	(c_db.addMonth(tax_out_dt, i*12));
			if(comm_value.equals("Y"))	fee.setTax_out_dt	(tax_out_dt);
			
			String s_cng_dt = AddUtil.replace(fee.getTax_out_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_tax_dd 	= AddUtil.parseInt(AddUtil.replace(tax_out_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn.equals("Y")){							
				fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_tax_dd < i_cng_dd ){
					fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_tax_dd));	
				}
			}
						
			
		}else if(cng_st.equals("fee_est_dt")){
			
			fee.setTax_out_dt	(c_db.addMonth(tax_out_dt, i));
			fee.setFee_est_dt	(c_db.addMonth(fee_est_dt, i));
			fee.setReq_dt		(c_db.addMonth(req_dt, i));
			
			if(mon_st == 12){
				fee.setTax_out_dt	(c_db.addMonth(tax_out_dt, i*12));
				fee.setFee_est_dt	(c_db.addMonth(fee_est_dt, i*12));
				fee.setReq_dt		(c_db.addMonth(req_dt, i*12));
			}
			if(comm_value.equals("Y")){
				fee.setTax_out_dt	(tax_out_dt);
				fee.setFee_est_dt	(fee_est_dt);
				fee.setReq_dt		(req_dt);
			}
			
			String s_cng_dt = AddUtil.replace(fee.getTax_out_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_tax_dd 	= AddUtil.parseInt(AddUtil.replace(tax_out_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn.equals("Y")){							
				fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_tax_dd < i_cng_dd ){
					fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_tax_dd));	
				}
			}
			
			s_cng_dt = AddUtil.replace(fee.getFee_est_dt(),"-",""); 
			i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			i_tax_dd 	= AddUtil.parseInt(AddUtil.replace(fee_est_dt,"-","").substring(6,8));
			i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn2.equals("Y")){							
				fee.setFee_est_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_tax_dd < i_cng_dd ){
					fee.setFee_est_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_tax_dd));	
				}
			}			
			
			fee.setR_fee_est_dt	(af_db.getValidDt(fee.getFee_est_dt()));
			fee.setR_req_dt		(af_db.getValidDt(fee.getReq_dt()));
		}
		
		if(AddUtil.parseInt(AddUtil.replace(fee.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee.getReq_dt(),"-",""))){
			fee.setR_req_dt	(fee.getReq_dt());
		}
		
		//거래명세서에 계산서예정일자 수정
		if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt") || cng_st.equals("fee_amt")){
			
			//기발행 거래명세서 계산서 미발행상태일 경우 기발행 거래명세서 계산서예정일자도 변경 할것..
			int chk_cnt1 = af_db.getTaxDtChk(l_cd, rent_st, rent_seq, fee.getFee_tm());
			String item_id = "";
			
			//계산서 미발행상태
			if(chk_cnt1 ==0){
				item_id = af_db.getTaxItemDtChk(l_cd, fee.getRent_st(), fee.getRent_seq(), fee.getFee_tm());
				if(!item_id.equals("")){
					//거래명세서 조회
					TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
					//계산서발급일자 변경시 처리
					if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt")){
						if(!ti_bean.getTax_est_dt().equals(AddUtil.replace(fee.getTax_out_dt(),"-",""))){
							ti_bean.setTax_est_dt	(fee.getTax_out_dt());
							if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
							System.out.println("대여료 스케줄 수정시 거래명세서 계산서예정일자 수정"+ l_cd +" "+fee.getFee_tm());
						}
					}
					if(cng_st.equals("fee_amt")){
						//공급가액 변경시 처리
						TaxItemListBean til_bean = IssueDb.getTaxItemListScdFeeCase(item_id, l_cd, fee.getFee_tm());
						//if(til_bean.getItem_supply() > fee.getFee_s_amt() || til_bean.getItem_supply() < fee.getFee_s_amt()){
							
							int item_hap_num = ti_bean.getItem_hap_num();
							//공급가가 감소한 경우
							if(til_bean.getItem_supply() > fee.getFee_s_amt()){
								item_hap_num = item_hap_num - (til_bean.getItem_supply()-fee.getFee_s_amt());
							}
							//공급가가 증가한 경우
							if(til_bean.getItem_supply() < fee.getFee_s_amt()){
								item_hap_num = item_hap_num + (fee.getFee_s_amt()-til_bean.getItem_supply());
							}
							
							ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(item_hap_num))+"원");
							ti_bean.setItem_hap_num(item_hap_num);
							if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
							System.out.println("대여료 스케줄 수정시 거래명세서 공급가액 수정"+ l_cd +" "+fee.getFee_tm());
							
							
							til_bean.setItem_supply	(fee.getFee_s_amt());
							til_bean.setItem_value	(fee.getFee_v_amt());
							
							if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
							
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
							System.out.println("대여료 스케줄 수정시 거래명세서 공급가액 수정"+ l_cd +" "+fee.getFee_tm());
							
							//변경된 거래명세서 이메일 재발송 : 프로시저 호출
							String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("", sender_bean.getId(), reg_code, item_id, "", "", "");		
							
						//}
					}
				}
			}else{
				System.out.println("대여료 스케줄 수정되었으나, 계산서는 이미 발행한 상태 : "+ l_cd +" "+fee.getFee_tm());
				
				//알람메시지
				String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
				String sub 		= "대여료스케줄 수정안내";
				String cont 	= "["+firm_nm+" " + l_cd +" "+fee.getFee_tm()+"회차]  &lt;br&gt; &lt;br&gt; 대여료 스케줄 수정되었으나,  &lt;br&gt; &lt;br&gt; 계산서는 이미 발행한 상태이니 확인하시기 바랍니다.";
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
			
			
		}
		
		fee.setDly_days			("");	/* 대여 입금예정일을 다시 세팅하면 연체일 및 연체료도 다시 계산해야 한다. */
		fee.setDly_fee			(0);
		fee.setUpdate_id		(user_id);
		//선납금균등대여료 변경은 입금금액도 같이 변경
		if(cng_st.equals("fee_amt") && fee.getTm_st2().equals("4")){
			fee.setRc_amt		(fee.getFee_s_amt()+fee.getFee_v_amt());
		}
		if(!af_db.updateFeeScd(fee)) flag += 1;
		out.println("fee_tm="+fee.getFee_tm());
		out.println(", fee_est_dt="+fee.getFee_est_dt()+"<br>");
		
		if(cng_st.equals("fee_amt") && fee.getTm_st2().equals("4")){
			
		}else{
			//20110125 잔액이 있는지 체크하여 처리
			Vector b_fees = af_db.getScdScdBalance(fee);	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
			int b_fee_size = b_fees.size();
			
			int balance_amt = fee.getFee_s_amt()+fee.getFee_v_amt()-fee.getRc_amt();
			
			if(b_fee_size>0){
				for(int d = 0 ; d < b_fee_size ; d++){
					FeeScdBean b_fee = (FeeScdBean)b_fees.elementAt(d);
					
					if(cng_st.equals("req_dt")){
						b_fee.setReq_dt			(fee.getReq_dt());
						b_fee.setR_req_dt		(fee.getR_req_dt());
					}else if(cng_st.equals("tax_out_dt")){
						b_fee.setTax_out_dt		(fee.getTax_out_dt());
					}else if(cng_st.equals("fee_est_dt")){
						b_fee.setReq_dt			(fee.getReq_dt());
						b_fee.setR_req_dt		(fee.getR_req_dt());
						b_fee.setTax_out_dt		(fee.getTax_out_dt());
						b_fee.setFee_est_dt		(fee.getFee_est_dt());
						b_fee.setR_fee_est_dt		(fee.getR_fee_est_dt());
					}else if(cng_st.equals("fee_amt")){//대여료 변경회차의 잔액이 있는 경우 잔액 재처리
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
								String cont 	= "["+firm_nm+" " + l_cd +" "+b_fee.getFee_tm()+"회차]  &lt;br&gt; &lt;br&gt; 대여료 스케줄 수정되었으나, 잔액이 이상합니다.  &lt;br&gt; &lt;br&gt; 확인하시기 바랍니다.";
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
						}else if(balance_amt<0){
							if(b_fee.getRc_amt()==0){//잔액삭제
								if(!af_db.dropFeeScdNew(m_id, l_cd, b_fee.getRent_st(), b_fee.getRent_seq(), b_fee.getFee_tm(), b_fee.getTm_st1())) flag += 1;
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
			
			//입금액이 월대여료보다 작은데 잔액이 없는 경우 잔액생성
			if(cng_st.equals("fee_amt") && fee.getRc_amt()>0 && fee.getFee_s_amt()+fee.getFee_v_amt() > fee.getRc_amt() && b_fee_size==0){
				FeeScdBean rest_fee = fee;
				int rest_amt 	= fee.getFee_s_amt() + fee.getFee_v_amt() - fee.getRc_amt();
				int rest_s_amt 	= af_db.getAccountSupplyAmt(rest_amt);
				rest_fee.setTm_st1		(String.valueOf(Integer.parseInt(fee.getTm_st1())+1));	//잔액대여료. 기존 회차구분+1
				rest_fee.setFee_s_amt	(rest_s_amt);
				rest_fee.setFee_v_amt	(rest_amt - rest_s_amt);
				rest_fee.setRc_yn		("0");		//default는 0(미수금)
				rest_fee.setRc_dt		("");
				rest_fee.setRc_amt		(0);
				if(!af_db.insertFeeScd(rest_fee))	flag += 1;
			}
		}	
	}
	
	if(ck_acar_id.equals("000029")){
		out.println("대여료스케줄수정완료");
		return;
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
		//location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>