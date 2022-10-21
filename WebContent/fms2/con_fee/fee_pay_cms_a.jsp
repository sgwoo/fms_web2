<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//출금의뢰일자
	String r_adate 	= af_db.getValidDt(c_db.addDay(adate, 1));//실입금일은 출금의뢰일 다음날이다. 공휴일체크
	int flag = 0;
	int count =0;
	
	out.println(adate+"<br>");
	out.println(r_adate+"<br><br>");
	
	if(!r_adate.equals("") && r_adate.substring(4,8).equals("0501")){//노동절 휴무
		r_adate = af_db.getValidDt(c_db.addDay(r_adate, 1));
		
		out.println(r_adate+"<br><br>");
	}
	
	String insert_id = umd.getSaCode(user_id);
	if(insert_id.equals("")){
		//FMS  사용자 정보 조회
		user_bean 	= umd.getUsersBean(user_id);
		//더존 사용자 정보 조회
		Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
		insert_id = String.valueOf(per.get("SA_CODE"));
	}
	
	//[1단계] :  acms 테이블 - 출금의뢰일로 자동이체 결과 조회
	
	
	Vector vt = af_db.getACmsList(adate, "1");//String adate, String aipbit
	int vt_size = vt.size();
	
	out.println("출금의뢰일로 자동이체 결과 조회 = "+vt_size+"건<br><br><br>");
	
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		flag = 0;
		count = 0;
		
		String acode 	= String.valueOf(ht.get("ACODE"));
		String abit 	= String.valueOf(ht.get("ABIT"));
		int aoutamt 	= Util.parseDigit(String.valueOf(ht.get("AOUTAMT")));	//출금액
		int payamt		= aoutamt;//출금처리누계금액
		
		String node_code= acode.substring(0,2)+"01";
		if(node_code.equals("N101"))	node_code = "B201";
		
		
		out.println(i+1+")계약번호="+acode+", 출금액="+aoutamt+", 처리비트="+abit+", ");
		
		
		//[2단계] : scd_fee 테이블 - 자동이체 미반영된 대여료 미입금 스케줄 조회
		
		
		Vector scd = af_db.getScdFeeCmsList(acode, adate);
		int scd_size = scd.size();
		
		String aipbit = "1";
		
		out.println("미반영스케줄="+scd_size+"건, ");
		
		for(int j = 0 ; j < scd_size ; j++){
			Hashtable ht2 = (Hashtable)scd.elementAt(j);
			
			//이미 입금처리한 금액이 있으면 출금처리누계금액에서 빼준다.
			payamt = payamt - Util.parseDigit(String.valueOf(ht2.get("CMS_RC_AMT")));
			out.println(" 기처리금액="+Util.parseDigit(String.valueOf(ht2.get("CMS_RC_AMT"))));
			
			int fee_s_amt 	= Util.parseDigit(String.valueOf(ht2.get("FEE_S_AMT")));
			int fee_v_amt 	= Util.parseDigit(String.valueOf(ht2.get("FEE_V_AMT")));
			int fee_amt		= fee_s_amt+fee_v_amt;
			
			String ven_code = String.valueOf(ht2.get("VEN_CODE"));
			if(ven_code.equals("")){
				if(String.valueOf(ht2.get("CLIENT_ST")).equals("2"))	ven_code = neoe_db.getVenCode(String.valueOf(ht2.get("SSN")),String.valueOf(ht2.get("ENP_NO"))); 
				if(!String.valueOf(ht2.get("CLIENT_ST")).equals("2"))	ven_code = neoe_db.getVenCode2(String.valueOf(ht2.get("SSN")),String.valueOf(ht2.get("ENP_NO")));
				//거래처테이블에 거래처코드 넣기
				af_db.updateClientVenCode(String.valueOf(ht2.get("CLIENT_ID")), ven_code);
			}
			
			FeeScdBean pay_fee = af_db.getScdNew(String.valueOf(ht2.get("RENT_MNG_ID")), String.valueOf(ht2.get("RENT_L_CD")), String.valueOf(ht2.get("RENT_ST")), String.valueOf(ht2.get("RENT_SEQ")), String.valueOf(ht2.get("FEE_TM")), String.valueOf(ht2.get("TM_ST1")));
			
			if(payamt > 0) {
				
				//[3단계] : scd_fee 테이블 - 입금처리, 잔액발생, / autodocu 테이블 - 자동전표생성
				
				if(payamt >= fee_amt){
					out.println("전액입금처리="+fee_amt+", ");
					pay_fee.setRc_yn("1");
					pay_fee.setRc_dt(adate);
					pay_fee.setRc_amt(fee_amt);
					pay_fee.setUpdate_id(user_id);
					pay_fee.setAdate(adate);
					if(!af_db.updateFeeScd(pay_fee))	flag += 1;
					
					//자동전표생성
					AutoDocuBean ad_bean = new AutoDocuBean();
					ad_bean.setNode_code(node_code);
					ad_bean.setVen_code(ven_code);
					ad_bean.setFirm_nm(String.valueOf(ht2.get("FIRM_NM")));
					ad_bean.setAcct_dt(r_adate);
					ad_bean.setAcct_code("10800");//외상매출금
					ad_bean.setBank_code("260");
					ad_bean.setBank_name("신한");
					ad_bean.setDeposit_no("140-004-023871");
					ad_bean.setAcct_cont("CMS-대여료("+String.valueOf(ht2.get("FEE_TM"))+"회차)"+String.valueOf(ht2.get("CAR_NO"))+"("+String.valueOf(ht2.get("FIRM_NM"))+")");
					ad_bean.setAmt(fee_amt);
					ad_bean.setInsert_id(insert_id);
					count = neoe_db.insertFeeAutoDocu(ad_bean);
					
					payamt = payamt - fee_amt;
				}else{
					out.println("부분입금처리="+payamt+", ");
					int rest_amt = fee_amt - payamt;
					int rest_s_amt = (new Double(rest_amt/1.1)).intValue();
					
					pay_fee.setRc_yn("1");
					pay_fee.setRc_dt(adate);
					pay_fee.setRc_amt(payamt);
					pay_fee.setUpdate_id(user_id);
					pay_fee.setAdate(adate);
					if(!af_db.updateFeeScd(pay_fee))	flag += 1;
					
					out.println(" 잔액생성="+rest_amt);
					FeeScdBean rest_fee = new FeeScdBean();
					rest_fee.setRent_mng_id(pay_fee.getRent_mng_id());
					rest_fee.setRent_l_cd(pay_fee.getRent_l_cd());
					rest_fee.setFee_tm(pay_fee.getFee_tm());
					rest_fee.setRent_st(pay_fee.getRent_st());
					rest_fee.setRent_seq(pay_fee.getRent_seq());
					rest_fee.setTm_st1(String.valueOf(Integer.parseInt(pay_fee.getTm_st1())+1));	//잔액대여료. 기존 회차구분+1
					rest_fee.setTm_st2("0");														//일반대여료(not 회차연장대여료)
					rest_fee.setFee_est_dt(pay_fee.getFee_est_dt());								//원 대여료의 입금예정일
					rest_fee.setFee_s_amt(rest_s_amt);
					rest_fee.setFee_v_amt(rest_amt - rest_s_amt);
					rest_fee.setRc_yn("0");															//default는 0(미수금)
					rest_fee.setRc_dt("");
					rest_fee.setRc_amt(0);
					rest_fee.setUpdate_id(user_id);
					rest_fee.setR_fee_est_dt(af_db.getValidDt(pay_fee.getR_fee_est_dt())); 			//수정 : 입금예정일을 그대로 간다.(20031030)
					rest_fee.setBill_yn("Y");
					rest_fee.setRent_seq(pay_fee.getRent_seq());
					rest_fee.setReq_dt		(pay_fee.getReq_dt());
					rest_fee.setR_req_dt	(pay_fee.getR_req_dt());
					rest_fee.setTax_out_dt	(pay_fee.getTax_out_dt());
					rest_fee.setUse_s_dt	(pay_fee.getUse_s_dt());
					rest_fee.setUse_e_dt	(pay_fee.getUse_e_dt());
					
					if(!af_db.insertFeeScdAdd(rest_fee))	flag += 1;
					
					//자동전표생성
					AutoDocuBean ad_bean = new AutoDocuBean();
					ad_bean.setNode_code(node_code);
					ad_bean.setVen_code(ven_code);
					ad_bean.setFirm_nm(String.valueOf(ht2.get("FIRM_NM")));
					ad_bean.setAcct_dt(r_adate);
					ad_bean.setAcct_code("10800");//외상매출금
					ad_bean.setBank_code("260");
					ad_bean.setBank_name("신한");
					ad_bean.setDeposit_no("140-004-023871");
					ad_bean.setAcct_cont("CMS-대여료("+String.valueOf(ht2.get("FEE_TM"))+"회차)"+String.valueOf(ht2.get("CAR_NO"))+"("+String.valueOf(ht2.get("FIRM_NM"))+")");
					ad_bean.setAmt(payamt);
					ad_bean.setInsert_id(insert_id);
					count = neoe_db.insertFeeAutoDocu(ad_bean);
					
					payamt = 0;
				}
			}else{
				//나가기
				continue;
			}
		}
		
		if(payamt == 0) 	aipbit = "2";
		else				aipbit = "3";
		//4단계 : acms 테이블 - 입금반영비트 수정
		out.println("입금반영비트="+aipbit);
		af_db.updateACmsBit(aipbit, acode, adate);
		
		//연체료 세팅
		boolean flag2 = af_db.calDelay(acode);
		
		out.println("<br>");
	}
//	if(1==1)return;
%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
//		location='about:blank';
<%	}else if(count == 1){%>
		alert('자동전표 오류발생!');
//		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');
//		parent.close();
<%	}%>
</script>
</body>
</html>
