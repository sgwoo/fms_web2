<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	
	
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	PayMngDatabase    	pm_db	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

 	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이


	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;

	String deposit_no 	= request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no");
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 	= request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String reqseq 		= "";
	
	String value3[] = request.getParameterValues("user_nm");


	
	


	PayMngBean bean = new PayMngBean();
	
	bean.setReqseq			("");
	bean.setP_est_dt		(request.getParameter("p_est_dt")==null?"":request.getParameter("p_est_dt"));
	bean.setReg_st			("D");
	bean.setP_way				(request.getParameter("p_way")==null?"5":request.getParameter("p_way"));
	bean.setOff_st			(request.getParameter("off_st")==null?"":request.getParameter("off_st"));
	bean.setOff_id			(request.getParameter("off_id")==null?"":request.getParameter("off_id"));
	bean.setOff_nm			(request.getParameter("off_nm")==null?"":request.getParameter("off_nm"));
	bean.setOff_tel			(request.getParameter("off_tel")==null?"":request.getParameter("off_tel"));
	bean.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	bean.setVen_name		(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	
	if(!bean.getOff_nm().equals("") && bean.getVen_name().equals("")) 			bean.setVen_name(bean.getOff_nm()	);
	else if(bean.getOff_nm().equals("") && !bean.getVen_name().equals("")) 	bean.setOff_nm	(bean.getVen_name()	);
	
	bean.setAmt					(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_amt")));
	
	bean.setBank_id			(request.getParameter("bank_id")==null?"":request.getParameter("bank_id"));
	bean.setBank_nm			(request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm"));
	bean.setBank_no			(request.getParameter("bank_no")==null?"":request.getParameter("bank_no"));
	bean.setBank_acc_nm	(request.getParameter("bank_acc_nm")==null?"":request.getParameter("bank_acc_nm"));//입금계좌 예금주
	
	if(!deposit_no.equals("")){
		//계좌정보
		Hashtable acc = ps_db.getDepositma(deposit_no);
		
		bean.setA_bank_id	(String.valueOf(acc.get("BANK_CODE"))==null?"":String.valueOf(acc.get("BANK_CODE")));
		bean.setA_bank_nm	(String.valueOf(acc.get("CHECKD_NAME"))==null?"":String.valueOf(acc.get("CHECKD_NAME")));
		bean.setA_bank_no	(deposit_no);
	}
	bean.setVen_st			(request.getParameter("ven_st")==null?"":request.getParameter("ven_st"));//거래처유형
	bean.setS_idno			(request.getParameter("off_idno")==null?"":request.getParameter("off_idno"));
	bean.setTax_yn			("");//세금계산서등록여부
	bean.setCash_acc_no	("");//세금계산서등록여부	
	bean.setAt_once			("N");//출금시간
	bean.setReg_id			(user_id);
	bean.setP_step			("0");
	bean.setAcct_code_st("1");
	
	//동일건중복체크
	int pay_chk_cnt  =  pm_db.getPayRegChk(bean);
	if(!bean.getOff_st().equals("off_id"))	pay_chk_cnt = 0;
	

		
		//계좌이체(지출처) 은행코드-code
		if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getBankCode("", bean.getBank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setBank_cms_bk(String.valueOf(ht.get("CMS_BK")));
				bean.setBank_id(String.valueOf(ht.get("CMS_BK")));
			}
		}
		//계좌이체(지출처) 은행코드-네오엠
		if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getBank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setBank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		//계좌이체(지출처) 은행코드-code
		if(!bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getBankCode("", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setA_bank_cms_bk(String.valueOf(ht.get("CMS_BK")));
				bean.setA_bank_id(String.valueOf(ht.get("CMS_BK")));
			}
		}
		//계좌이체(지출처) 은행코드-네오엠
		if(bean.getA_bank_id().equals("") && !bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setA_bank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		//계좌이체(지출처) 은행코드
		if(bean.getA_bank_nm().equals("신한") && bean.getA_bank_id().equals("")){
			bean.setA_bank_id("260");
		}		
		//계좌이체(지출처) 은행코드
		if(bean.getA_bank_nm().equals("신한") && bean.getA_bank_id().equals("null")){
			bean.setA_bank_id("260");
		}				
		
		if(AddUtil.lengthb(bean.getVen_name()) > 30 )	bean.setVen_name	(AddUtil.substringb(bean.getVen_name(),30 ));
		
		
		reqseq = pm_db.insertPay(bean);
		



	if(pay_chk_cnt>0){
		System.out.println("[출금원장직접등록-동일입력건]"+reqseq);
	}

	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(bean.getOff_id());
	
	//사용자
	UsersBean buyer_bean 	= new UsersBean();
	if(!value3[0].equals("")){
		buyer_bean = umd.getUserNmBean(value3[0]);
	}	
	
	//출금원장
	PayMngBean bean2 = new PayMngBean();
	
	bean2.setR_est_dt		(request.getParameter("p_est_dt")==null?"":request.getParameter("p_est_dt"));
	bean2.setP_gubun		("99");
	bean2.setP_cd1			(request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id"));
	bean2.setP_cd2			(request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd"));
	bean2.setP_cd3			(request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"));
	bean2.setP_cd4			(request.getParameter("accid_id")==null?"":request.getParameter("accid_id"));
	bean2.setP_cd5			(request.getParameter("serv_id")==null?"":request.getParameter("serv_id"));
	bean2.setP_cd6			(request.getParameter("maint_id")==null?"":request.getParameter("maint_id"));
	bean2.setP_st1			("99");
	bean2.setP_st2			("차량유류대");
	bean2.setP_st3			("계좌이체");
	
	bean2.setI_amt			(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_amt")));
	bean2.setI_s_amt		(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_amt")));
	bean2.setI_v_amt		(0);
	bean2.setSub_amt1		(0);
	bean2.setSub_amt2		(0);
	bean2.setSub_amt3		(0);
	bean2.setSub_amt4		(0);
	bean2.setSub_amt5		(0);
	bean2.setSub_amt6		(0);
	bean2.setAcct_code	(acct_code);
	bean2.setP_cont			(request.getParameter("p_cont")==null?"":request.getParameter("p_cont"));
	bean2.setBuy_user_id(request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id"));//사용자
	
	if(bean2.getBuy_user_id().equals("")){
		bean2.setBuy_user_id		(buyer_bean.getUser_id());//사용자
	}
	
	bean2.setAcct_code_g	(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	bean2.setAcct_code_g2	(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	bean2.setP_cont				(bean2.getP_cont()+" - 업무용 전기차충전");
	bean2.setUser_su			("");
	bean2.setUser_cont		("");
	bean2.setCost_gubun	("");
	
	if(AddUtil.lengthb(bean2.getP_cont())   > 100)	bean2.setP_cont		(AddUtil.substringb(bean2.getP_cont(),  100));
	
	bean2.setReqseq	(reqseq);
	bean2.setI_seq		(1);
	
	bean2.setTot_dist		(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));
		
	if(!pm_db.insertPayItem(bean2)) flag1 += 1;
	

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pay_dir_user_reg1_step2.jsp';
		fm.target = 'd_content';
		fm.submit();
		
	}
//-->
</script>
</head>
<body>
<form name='form1' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='reqseq'    value='<%=reqseq%>'>    
  <input type='hidden' name='i_seq' value='1'>      
</form>
<script language='javascript'>
<!--
<%	if(pay_chk_cnt>0){%>
		alert("지출처가 협력업체이면서 거래일자, 지출처명, 금액이 동일한 건이 이미 기등록되어 있습니다. 확인하십시오.");
<%	}%>		


<%	if(reqseq.equals("")){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("1단계 등록하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
