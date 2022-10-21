<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, acar.ext.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<%
	
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
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String tae_no 	= request.getParameter("tae_no")==null?"":request.getParameter("tae_no");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String fee_tm 			= request.getParameter("r_fee_tm")==null?"":request.getParameter("r_fee_tm");
	String c_all 			= request.getParameter("c_all")==null?"N":request.getParameter("c_all");
	String rent_start_dt 	= request.getParameter("rent_start_dt");
	String rent_end_dt 		= request.getParameter("rent_end_dt");
	int scd_size 			= request.getParameter("scd_size")==null?0:AddUtil.parseInt(request.getParameter("scd_size"));
	int fee_pay_tm 			= AddUtil.parseDigit(request.getParameter("t_fee_pay_tm"));
	int f_fee_tm 			= AddUtil.parseDigit(request.getParameter("r_fee_tm"));
	
	//분할청구
	String rtn_st 			= request.getParameter("rtn_st")		==null?"":request.getParameter("rtn_st");					//통합여부
	String rtn_yn 			= request.getParameter("rtn_yn")		==null?"N":request.getParameter("rtn_yn");					//분할처리하면서 대여료분할까지 할건지
	int    rtn_tm 			= request.getParameter("rtn_tm")		==null?0:AddUtil.parseInt(request.getParameter("rtn_tm"));	//분할갯수
	String rtn_firm_nm[] 	= request.getParameterValues("rtn_firm_nm");
	String rtn_client_id[] 	= request.getParameterValues("rtn_client_id");
	String rtn_site_id[] 	= request.getParameterValues("rtn_site_id");
	String rtn_fee_amt[] 	= request.getParameterValues("rtn_fee_amt");
	String rtn_fee_s_amt[] 	= request.getParameterValues("rtn_fee_s_amt");
	String rtn_fee_v_amt[] 	= request.getParameterValues("rtn_fee_v_amt");
	String rtn_type[] 		= request.getParameterValues("rtn_type");
	
	int flag = 0;
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	
	Vector fees = new Vector();
	int fee_size = 0;


	//변경이력 등록
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id	(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm		(request.getParameter("r_fee_tm"));
	cng.setAll_st		(c_all);
	cng.setGubun		("대여료분할");
	cng.setB_value		("");
	cng.setA_value		("");
	cng.setCng_id		(user_id);
	cng.setCng_cau		("");
	if(!af_db.insertFeeScdCng(cng)) flag += 1;


out.println("c_all="+c_all+"<br>");
out.println("fee_tm="+fee_tm+"<br>");
out.println("f_fee_tm="+f_fee_tm+"<br>");



	//분할청구 ------------------------------------------------------------------------
	
	if(rtn_st.equals("Y")){
		
		for(int i = 0 ; i < rtn_tm ; i++){
		
			FeeRtnBean rtn = af_db.getFeeRtn(m_id, l_cd, rtn_client_id[i], rtn_site_id[i], AddUtil.parseDigit(rtn_fee_amt[i]));
			rtn.setRent_st		(rent_st);
			rtn.setRent_seq		(String.valueOf(i+1));
			rtn.setClient_id	(rtn_client_id[i]);
			rtn.setR_site		(rtn_site_id[i]);
//			rtn.setRtn_est_dt	(fee_fst_dt);
			rtn.setRtn_amt		(AddUtil.parseDigit(rtn_fee_amt[i]));
			rtn.setRtn_move_st	("0");
			rtn.setUpdate_id	(user_id);
			rtn.setRtn_type		(rtn_type[i]);
			if(rtn.getRent_l_cd().equals("")){
				rtn.setRent_mng_id	(m_id);
				rtn.setRent_l_cd	(l_cd);
				if(!af_db.insertFeeRtn(rtn))	flag3 += 1;
			}
			out.println("분할청구금액 : "+rtn_fee_amt[i]+"<br>");
		}
	}
	
	ExtScdBean ext = ae_db.getAGrtScd(m_id, l_cd, rent_st, "1", "1");//선납금
	
	
	if(rtn_yn.equals("Y")){
		
		/*선택회차부터 모두 변경*/
		if(c_all.equals("Y")){
			fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_seq, fee_tm, "ALL");	//해당 회차를 포함해 그 이후의 대여료 및 잔액 모두를 vector로 리턴
			fee_size = fees.size();
		}else if(c_all.equals("N")){
			fees = af_db.getScdGroupCngNew(m_id, l_cd, rent_seq, fee_tm, "ONE");	//해당 회차에 속한 대여료 및 잔액 모두를 vector로 리턴
			fee_size = fees.size();
		}
		
		out.println("fee_size="+fee_size+"<br>");
		
		
		
		for(int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			
			
			for(int j = 0 ; j < rtn_tm ; j++){
			
				FeeRtnBean rtn = af_db.getFeeRtn(m_id, l_cd, rtn_client_id[j], rtn_site_id[j], AddUtil.parseDigit(rtn_fee_amt[j]));
				
				if(rtn_type[1].equals("4")){
					
					//선납금균등분할
					if(rtn.getRtn_type().equals("4")){
						fee.setTm_st2("4");					//4-선납금균발행목적
						fee.setUpdate_id(user_id);
						fee.setRent_seq	(rtn.getRent_seq());
						fee.setFee_s_amt(AddUtil.parseDigit(rtn_fee_s_amt[j]));
						fee.setFee_v_amt(AddUtil.parseDigit(rtn_fee_v_amt[j]));
					
						//선납금매월균등발행스케줄인 경우 선납금 입금여부 반영
						if(fee.getTm_st2().equals("4") && a_db.getPpPaySt(fee.getRent_mng_id(), fee.getRent_l_cd(), fee.getRent_st(), "1").equals("입금")){
							fee.setRc_yn			("1");
							fee.setRc_dt			(ext.getExt_pay_dt());
							fee.setRc_amt			(fee.getFee_s_amt()+fee.getFee_v_amt());
						}
					
						if(!af_db.insertFeeScd(fee)) flag += 1;
						
						//out.println("선납금균등분할 insertFeeScd<br>");
					}	
					
				//대여요금분활	
				}else{
					//rent_seq=1 이면 금액수정
					if(rtn.getRent_seq().equals("1")){
						fee.setUpdate_id(user_id);
						fee.setFee_s_amt(AddUtil.parseDigit(rtn_fee_s_amt[j]));
						fee.setFee_v_amt(AddUtil.parseDigit(rtn_fee_v_amt[j]));
						if(!af_db.updateFeeScd(fee)) flag += 1;
						//out.println("대여요금분활 updateFeeScd<br>");
					//스케줄 신규 생성
					}else{
						fee.setUpdate_id(user_id);
						fee.setRent_seq	(rtn.getRent_seq());
						fee.setFee_s_amt(AddUtil.parseDigit(rtn_fee_s_amt[j]));
						fee.setFee_v_amt(AddUtil.parseDigit(rtn_fee_v_amt[j]));
						if(!af_db.insertFeeScd(fee)) flag += 1;
						//out.println("대여요금분활 insertFeeScd<br>");
					}
				}	
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
