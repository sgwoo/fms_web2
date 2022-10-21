<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	String f_use_start_dt 	= request.getParameter("f_use_start_dt");
	String f_use_end_dt 	= request.getParameter("f_use_end_dt");
	int scd_size 		= request.getParameter("scd_size")==null?0:AddUtil.parseInt(request.getParameter("scd_size"));
	int fee_pay_tm 		= AddUtil.parseDigit(request.getParameter("t_fee_pay_tm"));
	int f_fee_tm 		= AddUtil.parseDigit(request.getParameter("r_fee_tm"));
	
	String maxday_yn 	= request.getParameter("maxday_yn")==null?"":request.getParameter("maxday_yn");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	

	//납입 종료일
	rent_end_dt = c_db.minusDay(c_db.addMonth(rent_start_dt, fee_pay_tm), 1);
	
	//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
	if(rent_st.equals("1") && (base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
		rent_end_dt = c_db.addMonth(rent_start_dt, fee_pay_tm);
	}
	
	
	out.println("납입 종료일 : "+rent_end_dt+"<br>");
	//1회차 시작일
	String f_use_s_dt 	= f_use_start_dt;
	//1회차 실종료일
	String f_use_e_dt 	= f_use_end_dt;
	//2회차 실시작일
	String use_s_dt 	= c_db.addDay(f_use_end_dt, 1);
	//마지막 종료일
	String use_e_dt 	= request.getParameter("rent_end_dt");
	
	String fm_use_e_dt = "";
	int flag = 0;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	Vector fees = new Vector();
	int fee_size = 0;
	
	
	//대여료스케줄 한회차 정보
	FeeScdBean b_fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "0");


	//변경이력 등록
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id	(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm		(request.getParameter("r_fee_tm"));
	cng.setAll_st		(c_all);
	cng.setGubun		("사용기간");
	cng.setB_value		(b_fee_scd.getUse_s_dt()+"~"+b_fee_scd.getUse_e_dt());
	cng.setA_value		(f_use_start_dt+"~"+f_use_end_dt);
	cng.setCng_id		(user_id);
	cng.setCng_cau		(request.getParameter("cng_cau"));
	if(!af_db.insertFeeScdCng(cng)) flag += 1;


	/*선택회차부터 모두 변경*/
	if(c_all.equals("Y")){
		fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "ALL");	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}else if(c_all.equals("N")){
		fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "ONE");	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
		fee_size = fees.size();
	}

out.println("c_all="+c_all+"<br>");
out.println("fee_tm="+fee_tm+"<br>");
out.println("fee_size="+fee_size+"<br>");


	for(int i = 0 ; i < fee_size ; i++){
		FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
		
		if(!fee.getTm_st2().equals("3") && c_all.equals("Y") && i>0 && i+1 == fee_size){
			fee.setUse_e_dt	(rent_end_dt);
		}else{
			fee.setUse_e_dt	(c_db.addMonth(f_use_end_dt, count1));//'YYYY-MM-DD'
			
			String s_cng_dt = AddUtil.replace(fee.getUse_e_dt(),"-",""); 
			int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
			int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
			int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
			int i_req_dd 	= AddUtil.parseInt(AddUtil.replace(f_use_end_dt,"-","").substring(6,8));
			int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
						
			if(maxday_yn.equals("Y")){							
				fee.setUse_e_dt(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
			}else{
				if(i_req_dd < i_cng_dd ){
					fee.setUse_e_dt(s_cng_dt.substring(0,6)+""+AddUtil.addZero2(i_req_dd));	
				}
			}
			
			//사용기간 종료일 일자 맞추기
			/*
			String fee_est_day 	= AddUtil.replace(f_use_end_dt,"-","").substring(6,8);
			String use_e_day 	= AddUtil.replace(fee.getUse_e_dt(),"-","").substring(6,8);
			
			if(AddUtil.parseInt(fee_est_day) < AddUtil.parseInt(use_e_day)){
				fee.setUse_e_dt(fee.getUse_e_dt().substring(0,8)+""+fee_est_day);
			}
			*/
		}
		
		if(i==0){
			fee.setUse_s_dt	(f_use_start_dt);
		}else{
			fee.setUse_s_dt	(c_db.addDay(fm_use_e_dt, 1));
		}
		fee.setUpdate_id	(user_id);
		
		
		
		if(!af_db.updateFeeScd(fee)) flag += 1;
		
		out.println("fee_tm="+fee.getFee_tm());
		out.println(", f_use_start_dt="+fee.getUse_s_dt());
		out.println(", f_use_end_dt="+fee.getUse_e_dt()+"<br>");
		
		count1++;
		
		fm_use_e_dt = fee.getUse_e_dt();
		
		
			//20110125 잔액이 있는지 체크하여 처리
			Vector b_fees = af_db.getScdScdBalance(fee);	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
			int b_fee_size = b_fees.size();
			
			if(b_fee_size>0){
				for(int d = 0 ; d < b_fee_size ; d++){
					FeeScdBean b_fee = (FeeScdBean)b_fees.elementAt(d);
					
					b_fee.setUse_s_dt		(fee.getUse_s_dt());
					b_fee.setUse_e_dt		(fee.getUse_e_dt());
					
					if(!af_db.updateFeeScd(b_fee)) flag += 1;
				}
			}
		
	}

out.println("flag="+flag+"<br>");
//if(1==1)return;
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
<%	if(flag > 0){%>
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
