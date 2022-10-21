<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
	String tae_no 		= request.getParameter("tae_no")==null?"":request.getParameter("tae_no");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));

	String fee_tm 		= request.getParameter("r_fee_tm")==null?"":request.getParameter("r_fee_tm");
	String c_all 		= request.getParameter("c_all")==null?"N":request.getParameter("c_all");
	String rent_start_dt 	= request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt");
	String use_start_dt 	= request.getParameter("use_start_dt");
	String use_end_dt 	= request.getParameter("use_end_dt");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String fee_est_dt 	= request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");	
	int scd_size 		= request.getParameter("scd_size")==null?0:AddUtil.parseInt(request.getParameter("scd_size"));
	int fee_pay_tm 		= AddUtil.parseDigit(request.getParameter("t_fee_pay_tm"));
	int f_fee_tm 		= AddUtil.parseDigit(request.getParameter("r_fee_tm"));
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String maxday_yn1 	= request.getParameter("maxday_yn1")==null?"":request.getParameter("maxday_yn1");
	String maxday_yn2 	= request.getParameter("maxday_yn2")==null?"":request.getParameter("maxday_yn2");
	String maxday_yn3 	= request.getParameter("maxday_yn3")==null?"":request.getParameter("maxday_yn3");
	String maxday_yn4 	= request.getParameter("maxday_yn4")==null?"":request.getParameter("maxday_yn4");
	String s_max_tm 	= request.getParameter("s_max_tm")==null?"":request.getParameter("s_max_tm");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	

	//납입 종료일
	rent_end_dt = c_db.minusDay(c_db.addMonth(rent_start_dt, fee_pay_tm), 1);
	
	//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
	if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
		rent_end_dt = c_db.addMonth(rent_start_dt, fee_pay_tm);
	}
	
	
	out.println("납입 종료일 : "+rent_end_dt+"<br>");
	//1회차 시작일
	String f_use_s_dt 	= use_start_dt;
	//1회차 실종료일
	String f_use_e_dt 	= use_end_dt;
	//2회차 실시작일
	String use_s_dt 	= c_db.addDay(use_end_dt, 1);
	//마지막 종료일
	String use_e_dt 	= request.getParameter("rent_end_dt");
	
	String fm_use_e_dt = "";
	int flag = 0;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	
	Vector fees = new Vector();
	int fee_size = 0;
	
	
	//대여기본정보
	ContFeeBean cont_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	
	
	//대여료스케줄 한회차 정보
	FeeScdBean b_fee_scd = af_db.getScdFeeEst(m_id, l_cd, rent_st, rent_seq, fee_tm, "0");





	/*선택회차부터 모두 변경*/
	if(c_all.equals("Y")){
		fees = af_db.getScdGroupCngEst(m_id, l_cd, rent_st, rent_seq, fee_tm, "ALL");	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}else if(c_all.equals("N")){
		fees = af_db.getScdGroupCngEst(m_id, l_cd, rent_st, rent_seq, fee_tm, "ONE");	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}else if(c_all.equals("M")){
		fees = af_db.getScdGroupCngEst(m_id, l_cd, rent_st, rent_seq, fee_tm, s_max_tm);	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}



	for(int i = 0 ; i < fee_size ; i++){
		FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
		
		String o_use_s_dt = AddUtil.replace(fee.getUse_s_dt(),"-","");
		String o_use_e_dt = AddUtil.replace(fee.getUse_e_dt(),"-","");
		
		//사용기간 시작일
		if(i+1 == fee_size && c_all.equals("Y")){
			fee.setUse_e_dt	(rent_end_dt);
		}else{
			fee.setUse_e_dt	(c_db.addMonth(use_end_dt, count1));//'YYYY-MM-DD'
			
			String s_cng_dt = AddUtil.replace(fee.getUse_e_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(use_end_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
				
			//말일		
			if(maxday_yn1.equals("Y")){							
				fee.setUse_e_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setUse_e_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
						
		}
		
		
		//사용기간 만료일
		if(i==0 || c_all.equals("N")){
			fee.setUse_s_dt	(use_start_dt);
		}else{
			fee.setUse_s_dt	(c_db.addDay(fm_use_e_dt, 1));
		}
		
		
		
		//사용기간 변경인 경우 대여료 일자계산
		if(!o_use_s_dt.equals(AddUtil.replace(fee.getUse_s_dt(),"-","")) || !o_use_e_dt.equals(AddUtil.replace(fee.getUse_e_dt(),"-",""))){

			//첫회차와 마지막회차만 일자계산
			if(i==0 || i+1==fee_size){
				out.println("o_use_s_dt="+o_use_s_dt);
				out.println("fee.getUse_s_dt()="+fee.getUse_s_dt());
				out.println("o_use_e_dt="+o_use_e_dt);
				out.println("fee.getUse_e_dt()="+fee.getUse_e_dt());
				out.println("<br>");
			
		
				//일자계산
				Hashtable u_ht = af_db.getUseMonDay(fee.getUse_e_dt(), fee.getUse_s_dt());
				
				if(i==0){
					u_ht = af_db.getUseMonDay2(fee.getUse_e_dt(), fee.getUse_s_dt());
				}
										
				int u_mon = AddUtil.parseInt(String.valueOf(u_ht.get("U_MON")));
				int u_day = AddUtil.parseInt(String.valueOf(u_ht.get("U_DAY")));
			
				int cont_fee_amt = cont_fee.getFee_s_amt()+cont_fee.getFee_v_amt();
				int scd_fee_amt  = af_db.getUseMonDayAmt(cont_fee_amt, u_mon, u_day);
			
				fee.setFee_s_amt	(af_db.getSupAmt(scd_fee_amt));
				fee.setFee_v_amt	(scd_fee_amt-fee.getFee_s_amt());
				
				if(u_mon == 0){
					fee.setEtc("일자계산내역:"+cont_fee_amt+"원(월대여료VAT포함)/30일*"+u_day+"일");
				}else{
					fee.setEtc("일자계산내역:"+cont_fee_amt+"원(월대여료VAT포함)*"+u_mon+"개월+"+cont_fee_amt+"원/30일*"+u_day+"일");
				}
			}else{
				fee.setEtc("");
			}
		}else{
			fee.setEtc("");
			fee.setFee_s_amt	(cont_fee.getFee_s_amt());
			fee.setFee_v_amt	(cont_fee.getFee_v_amt());
		}
		
		
		//발행예정일
		if(i==0 || c_all.equals("N")){
			fee.setReq_dt	(req_dt);
		}else{
			fee.setReq_dt	(c_db.addMonth(req_dt, count1));
						
			String s_cng_dt = AddUtil.replace(fee.getReq_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(req_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn2.equals("Y")){							
				fee.setReq_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setReq_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
		}
			
		fee.setR_req_dt		(af_db.getValidDt(fee.getReq_dt()));
		
		
		//세금일자
		if(i==0 || c_all.equals("N")){
			fee.setTax_out_dt	(tax_out_dt);
		}else{
			fee.setTax_out_dt	(c_db.addMonth(tax_out_dt, count1));
						
			String s_cng_dt = AddUtil.replace(fee.getTax_out_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(tax_out_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn3.equals("Y")){							
				fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setTax_out_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
		}	
		
		
		//입금예정일	
		if(i==0 || c_all.equals("N")){
			fee.setFee_est_dt	(fee_est_dt);
		}else{
			fee.setFee_est_dt	(c_db.addMonth(fee_est_dt, count1));
						
			String s_cng_dt = AddUtil.replace(fee.getFee_est_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(fee_est_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn4.equals("Y")){							
				fee.setFee_est_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setFee_est_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
		}	
		
		fee.setR_fee_est_dt	(af_db.getValidDt(fee.getFee_est_dt()));
		
		
		//마지막회차
		if(i+1 == fee_size && c_all.equals("Y")){
		
			if(cont_fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee.getFee_est_dt(),"-",""))){
				fee.setFee_est_dt			(fee.getUse_e_dt());
				fee.setTax_out_dt			(fee.getUse_e_dt());
				fee.setR_fee_est_dt			(af_db.getValidDt(fee.getFee_est_dt()));
			}
				
			//대여만료일(마지막사용기간종료일)보다 입금예정일이 더 작을수도 없다.   use_e_dt > fee_est_dt			
			if(cont_fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee.getUse_e_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee.getFee_est_dt(),"-",""))){
				fee.setFee_est_dt		(fee.getUse_e_dt());
				fee.setTax_out_dt		(fee.getUse_e_dt());
				fee.setR_fee_est_dt		(af_db.getValidDt(fee.getFee_est_dt()));
			}
							
			//if(AddUtil.parseInt(AddUtil.replace(fee.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee.getReq_dt(),"-",""))){
			
				//일수
				int max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(fee.getUse_s_dt(), fee.getUse_e_dt()));
				
				if(max_tm_add_l_use_days > 15 ){								
					fee.setReq_dt		(c_db.addDay(fee.getUse_e_dt(), -15));
				}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
					fee.setReq_dt		(c_db.addDay(fee.getUse_e_dt(), -10));
				}else{
					fee.setReq_dt		(c_db.addDay(fee.getUse_e_dt(), -5));
				}
										
				fee.setR_req_dt			(fee.getReq_dt());
			//}		
		
		}		
		
		
		
		fee.setUpdate_id	(user_id);
		
		
		
		if(!af_db.updateFeeScdEst(fee)) flag += 1;
		
		
		count1++;
		
		fm_use_e_dt = fee.getUse_e_dt();
				
		
	}
	
	
	//총금액확인
	int total_amt3 	= 0;
	FeeScdBean max_fee = new FeeScdBean();
	//예비스케줄 리스트
	Vector fee_scd_est = af_db.getScdFeeEstList(m_id, l_cd);
	int fee_scd_est_size = fee_scd_est.size();
	for(int j = 0 ; j < fee_scd_est_size ; j++){
    Hashtable ht = (Hashtable)fee_scd_est.elementAt(j);
    total_amt3 	= total_amt3 + AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT")));
    if(j+1==fee_scd_est_size){
    	max_fee = af_db.getScdFeeEst(m_id, l_cd, String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")), String.valueOf(ht.get("TM_ST1")));
    }
  }
  int o_total_fee_amt = (f_fee.getFee_s_amt()+f_fee.getFee_v_amt())*AddUtil.parseInt(f_fee.getCon_mon())-(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt());
  if(o_total_fee_amt > total_amt3){
  	max_fee.setFee_s_amt	(af_db.getSupAmt(o_total_fee_amt-total_amt3));
		max_fee.setFee_v_amt	(o_total_fee_amt-total_amt3-max_fee.getFee_s_amt());
		if(!af_db.updateFeeScdEst(max_fee)) flag += 1;
  }


%>
<form name='form1' method='post'>
<input type='hidden' name='rent_mng_id' value='<%=m_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=l_cd%>'>
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
  <input type='hidden' name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name="mode" 			value="<%=mode%>">
</form>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("스케줄이 변경되지 않았습니다");
		//location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='/fms2/lc_rent/lc_start_doc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>
