<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String tae_no 	= request.getParameter("tae_no")==null?"":request.getParameter("tae_no");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");	
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));

	int last_fee_tm 		= request.getParameter("last_fee_tm")==null?0:AddUtil.parseInt(request.getParameter("last_fee_tm"));
	int add_tm 				= AddUtil.parseDigit(request.getParameter("add_tm"));
	
	int    fee_amt 				= request.getParameter("fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int    fee_s_amt 			= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int    fee_v_amt 			= request.getParameter("fee_v_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int    f_fee_amt 			= request.getParameter("f_fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("f_fee_amt"));
	int    f_fee_s_amt 		= request.getParameter("f_fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_fee_s_amt"));
	int    f_fee_v_amt 		= request.getParameter("f_fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_fee_v_amt"));
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 		= request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt");
	String f_use_start_dt = request.getParameter("f_use_start_dt")==null?"":request.getParameter("f_use_start_dt");	//1회차사용기간
	String f_use_end_dt 	= request.getParameter("f_use_end_dt")	==null?"":request.getParameter("f_use_end_dt");		//1회차사용기간
	String f_req_dt 			= request.getParameter("f_req_dt")		==null?"":request.getParameter("f_req_dt");			//1회차 발행예정일
	String f_tax_dt 			= request.getParameter("f_tax_dt")		==null?"":request.getParameter("f_tax_dt");			//1회차 세금일자
	String f_est_dt 			= request.getParameter("f_est_dt")		==null?"":request.getParameter("f_est_dt");			//1회차 납입일자
	String etc 						= request.getParameter("etc")==null?"":request.getParameter("etc");


	//처리상태
	int flag = 0;
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	boolean flag12 = true;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;

	String r_use_end_dt = "";
	String req_fst_dt = "";

	out.println("마지막회차 : "+last_fee_tm+"<br>");
	out.println("연장회차 : "+add_tm+"<br>");	
	
	
	//대차대여스케줄 대여횟수 최대값
	last_fee_tm = a_db.getMax_fee_tm(m_id, l_cd);
	
	if(!rent_seq.equals("1")){
		last_fee_tm = a_db.getMax_fee_tm2(m_id, rent_seq);
	}

	//변경이력 등록
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id	(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm		(request.getParameter("last_fee_tm"));
	cng.setAll_st		("");
	cng.setGubun		("회차연장");
	cng.setB_value		("");
	cng.setA_value		(request.getParameter("add_tm"));
	cng.setCng_id		(user_id);
	cng.setCng_cau		(request.getParameter("cng_cau"));
	if(!af_db.insertFeeScdCng(cng)) flag += 1;
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	//출고전대차
	if(rent_st.equals("")){
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
		}
		
		ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
		
			//출고전대차 선입금일경우 메시지 발송
			//입금담당자에게 메시지 발송
			if(taecha.getF_req_yn().equals("Y") && !taecha.getF_req_dt().equals("")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("입금담당"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고전대차 선입금 계약</SUB>"+
		  				"    <CONT>출고전대차 선입금 계약의 대여료스케줄이 추가로 생성되었습니다.  &lt;br&gt; &lt;br&gt; 입금 확인 하십시오.  &lt;br&gt; &lt;br&gt;  "+l_cd+" "+firm_nm+" 월대여료"+taecha.getRent_fee()+"원</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
				
			}				
	}
	
	
	
	//1회차 시작일
	String f_use_s_dt 	= f_use_start_dt;
	//1회차 실종료일
	String f_use_e_dt 	= f_use_end_dt;
	//2회차 실시작일
	String t_use_s_dt 	= c_db.addDay(f_use_end_dt, 1);
	//최종 종료일
	String use_e_dt 	= rent_end_dt;
	
	//대여기간에 따른 1회차 정상종료일
	String r_use_e_dt 	= c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
	int    use_days 	= 0;
	
	int fee_fst_s_amt = 0;
	int fee_fst_v_amt = 0;
	int tot_fee_s_amt = fee_s_amt*add_tm;
	int tot_fee_v_amt = fee_v_amt*add_tm;
	
	//1회차 일할계산 확인----------------------------------------------------------------------
	if(!AddUtil.replace(r_use_e_dt,"-","").equals(AddUtil.replace(f_use_e_dt,"-",""))){//1회차 정상종료일과 실종료일을 비교
		//일수구하기
		use_days 		= AddUtil.parseInt(rs_db.getDay(f_use_s_dt, f_use_e_dt));
		//일할금액계산하기
		fee_fst_s_amt 	= fee_s_amt * use_days / 30;
		fee_fst_v_amt 	= fee_fst_s_amt*10/100;
	}else{
		fee_fst_s_amt 	= fee_s_amt;
		fee_fst_v_amt 	= fee_v_amt;
	}
	
	
	
	//마지막회차 스케줄
	FeeScdBean l_fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, request.getParameter("last_fee_tm"), "0");
	
	count3 = 0;
	count1 = 0;
	
	//스케줄 생성
	for(int i = last_fee_tm ; i < last_fee_tm+add_tm ; i++){
		
		FeeScdBean fee_scd = new FeeScdBean();
		
		fee_scd.setRent_mng_id(m_id);
		fee_scd.setRent_l_cd	(l_cd);
		fee_scd.setRent_seq		(rent_seq);
		fee_scd.setFee_tm		(String.valueOf(i+1));
		if(rent_st.equals("")){
			fee_scd.setRent_st	("1");			// 구분: 신차출고지연대차
			fee_scd.setTm_st2	("2");			// 구분: 2-출고지연
			fee_scd.setTaecha_no(taecha_no);			//출고지연 관리번호
		}else{
			fee_scd.setRent_st(rent_st);		// 구분: 신차/연장
			fee_scd.setTm_st2	("0");			// 구분: 0-일반대여료 (1-회차연장)
		}
		if(tm_st2.equals("4")){
			fee_scd.setTm_st2	("4");			// 구분: 4-선납금균등발행
		}
		fee_scd.setTm_st1		("0");			// 구분: 월대여료(/잔액)
		fee_scd.setRc_yn		("0");															// default값은 미수금 
		fee_scd.setUpdate_id	(user_id);
		fee_scd.setTae_no		(tae_no);
		
		//1회차---------------------------------------------------------------------------------------------
		if(i == last_fee_tm){
			fee_scd.setUse_s_dt				(f_use_s_dt);									//1회차 사용기간 시작일
			fee_scd.setUse_e_dt				(f_use_e_dt);									//1회차 사용기간 종료일
			fee_scd.setFee_est_dt			(f_est_dt);									//1회차 납입일
			fee_scd.setFee_s_amt			(f_fee_s_amt);									//1회차 대여료
			fee_scd.setFee_v_amt			(f_fee_v_amt);									//1회차 대여료
			fee_scd.setEtc						(etc);
			
		//2회차부터----------------------------------------------------------------------------------------
		}else{
			//2회차 기간시작일은 전회차 다음날로 한다.
			fee_scd.setUse_s_dt				(c_db.addDay(r_use_end_dt, 1));
			fee_scd.setUse_e_dt				(c_db.addMonth(f_use_e_dt, count1));
			//마지막회차이면
			if(i == (last_fee_tm+add_tm-1)){
				//예상종료일과 실제만료일을 비교하여 일할계산해야함.
				String r_end_dt = AddUtil.replace(rent_end_dt,"-","");
				String i_end_dt = AddUtil.replace(fee_scd.getUse_e_dt(),"-","");
				//일할계산
				if(!AddUtil.replace(rent_end_dt,"-","").equals(AddUtil.replace(f_use_end_dt,"-","")) && !AddUtil.replace(r_end_dt,"-","").equals(AddUtil.replace(i_end_dt,"-",""))){
					fee_scd.setUse_e_dt		(use_e_dt);
					fee_scd.setFee_est_dt	(c_db.addMonth(f_est_dt, count1));
					if(AddUtil.parseInt(r_end_dt) < AddUtil.parseInt(fee_scd.getFee_est_dt())){
						fee_scd.setFee_est_dt	(r_end_dt);
					}
					//일할금액계산하기
					int l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
					int scd_fee_amt = fee_s_amt+fee_v_amt;
					scd_fee_amt 		= scd_fee_amt * l_use_days / 30;
					fee_fst_s_amt =		(af_db.getSupAmt(scd_fee_amt));
					fee_fst_v_amt = 	(scd_fee_amt-fee_fst_s_amt);
				
					fee_scd.setFee_s_amt	(fee_fst_s_amt);
					fee_scd.setFee_v_amt	(fee_fst_v_amt);
					
					fee_scd.setEtc("일자계산내역:"+(fee_s_amt+fee_v_amt)+"원(월대여료VAT포함)/30일*"+l_use_days+"일");
					
				//정상적용
				}else{
					fee_scd.setFee_est_dt	(c_db.addMonth(f_est_dt, count1));
					fee_scd.setFee_s_amt	(fee_s_amt);								// 2회차부터는 월대여료로 세팅
					fee_scd.setFee_v_amt	(fee_v_amt);
				}
			}else{
					fee_scd.setFee_est_dt	(c_db.addMonth(f_est_dt, count1));
					fee_scd.setFee_s_amt	(fee_s_amt);								// 2회차부터는 월대여료로 세팅
					fee_scd.setFee_v_amt	(fee_v_amt);
			}
			count3++;
		}
		fee_scd.setTax_out_dt				(c_db.addMonth(f_tax_dt, count1));
		fee_scd.setR_fee_est_dt				(af_db.getValidDt(fee_scd.getFee_est_dt()));
		fee_scd.setReq_dt					(c_db.addMonth(f_req_dt, count1));
		fee_scd.setR_req_dt					(af_db.getValidDt(fee_scd.getReq_dt()));
		
		if(AddUtil.parseInt(AddUtil.replace(fee_scd.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
			fee_scd.setR_req_dt				(fee_scd.getReq_dt());
		}
		
		/*
		if(tm_st2.equals("4")){
			fee_scd.setRc_yn				("1");
			fee_scd.setRc_dt				(fee_scd.getFee_est_dt());
			fee_scd.setRc_amt				(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt());
		}
		*/
		
		if(!af_db.insertFeeScd(fee_scd)) flag += 1;
		
		r_use_end_dt 	= fee_scd.getUse_e_dt();
		tot_fee_s_amt 	= tot_fee_s_amt-fee_scd.getFee_s_amt();
		tot_fee_v_amt 	= tot_fee_v_amt-fee_scd.getFee_v_amt();
		count1++;
	}

//out.println("flag="+flag+"<br>");
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
		alert("스케줄이 연장 등록하지 않았습니다");
		//location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 연장 등록되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>