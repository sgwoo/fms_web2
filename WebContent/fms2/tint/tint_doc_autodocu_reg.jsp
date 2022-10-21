<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String br_id2 	= request.getParameter("br_id2")==null?"":request.getParameter("br_id2");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String off_nm 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	
	String autodocu_dt 		= request.getParameter("autodocu_dt")	==null?"":request.getParameter("autodocu_dt");
	int autodocu_s_amt 		= request.getParameter("autodocu_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("autodocu_s_amt"));
	int autodocu_v_amt 		= request.getParameter("autodocu_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("autodocu_v_amt"));
	String req_code 		= request.getParameter("req_code")==null?"":request.getParameter("req_code");
	String reqseq			= "";
	
	int flag1 = 0;
	
	
	
	PayMngDatabase    	pm_db	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	Vector vt = ps_db.getPayEstAmt13_2List	("9", req_code+""+off_id, req_dt, off_nm, "");
	int vt_size = vt.size();
	
	
	long t_amt = 0;
			
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				t_amt = t_amt + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				
				//네오엠코드 처리
				if(!String.valueOf(ht.get("VEN_CODE")).equals("") && String.valueOf(ht.get("VEN_NAME")).equals("")){
					Hashtable vendor = neoe_db.getVendorCase(String.valueOf(ht.get("VEN_CODE")));
					ht.put("VEN_NAME", String.valueOf(vendor.get("VEN_NAME")));
				}
				
				//입금계좌 처리
				if(!String.valueOf(ht.get("BANK_NM")).equals("")){
					Hashtable bank = ps_db.getBankCode("", String.valueOf(ht.get("BANK_NM")));
					if(String.valueOf(bank.get("CMS_BK")).equals("null")){
						
					}else{
						ht.put("BANK_CMS_BK", String.valueOf(bank.get("CMS_BK")));
					}
				}
				
				//입금계좌 처리
				if(!String.valueOf(ht.get("BANK_NM")).equals("") && String.valueOf(ht.get("BANK_ID")).equals("")){
					Hashtable bank = ps_db.getCheckd("A03", String.valueOf(ht.get("BANK_NM")));
					if(String.valueOf(bank.get("CHECKD_CODE")).equals("null")){
						
					}else{
						ht.put("BANK_ID", String.valueOf(bank.get("CHECKD_CODE")));
					}
				}
				
				//출금계좌 처리
				if(!String.valueOf(ht.get("A_BANK_NO")).equals("") && String.valueOf(ht.get("A_BANK_NM")).equals("")){
					Hashtable acc = ps_db.getDepositma(String.valueOf(ht.get("A_BANK_NO")));
					ht.put("A_BANK_ID", String.valueOf(acc.get("BANK_CODE")));
					ht.put("A_BANK_NM", String.valueOf(acc.get("CHECKD_NAME")));
				}
				
				//출금계좌 처리
				if(!String.valueOf(ht.get("A_BANK_NM")).equals("")){
					Hashtable bank = ps_db.getBankCode("", String.valueOf(ht.get("A_BANK_NM")));
					if(String.valueOf(bank.get("CMS_BK")).equals("null")){
						
					}else{
						ht.put("A_BANK_CMS_BK", String.valueOf(bank.get("CMS_BK")));
					}
				}
				
				if(String.valueOf(ht.get("EST_DT")).equals("")){
					ht.put("EST_DT", AddUtil.getDate());
				}
				
				
				PayMngBean bean = new PayMngBean();
				
				bean.setReqseq			("");
				bean.setP_est_dt		(autodocu_dt);
				bean.setReg_st			("S");
				bean.setP_way			("5");
				bean.setOff_st			("off_id");
				bean.setOff_id			(String.valueOf(ht.get("OFF_ID"))==null?"":String.valueOf(ht.get("OFF_ID")));
				bean.setOff_nm			(String.valueOf(ht.get("OFF_NM"))==null?"":String.valueOf(ht.get("OFF_NM")));
				bean.setVen_code		(String.valueOf(ht.get("VEN_CODE"))==null?"":String.valueOf(ht.get("VEN_CODE")));
				bean.setVen_name		(String.valueOf(ht.get("VEN_NAME"))==null?"":String.valueOf(ht.get("VEN_NAME")));
				
				if(!bean.getOff_nm().equals("") && bean.getVen_name().equals("")) 		bean.setVen_name(bean.getOff_nm()	);
				else if(bean.getOff_nm().equals("") && !bean.getVen_name().equals("")) 	bean.setOff_nm	(bean.getVen_name()	);
				
				bean.setAmt				(autodocu_s_amt+autodocu_v_amt);
				bean.setBank_id			(String.valueOf(ht.get("BANK_ID"))==null?"":String.valueOf(ht.get("BANK_ID")));
				bean.setBank_nm			(String.valueOf(ht.get("BANK_NM"))==null?"":String.valueOf(ht.get("BANK_NM")));
				bean.setBank_no			(String.valueOf(ht.get("BANK_NO"))==null?"":String.valueOf(ht.get("BANK_NO")));
				bean.setVen_st			("1");//거래처유형
				bean.setS_idno			(String.valueOf(ht.get("S_IDNO"))==null?"":String.valueOf(ht.get("S_IDNO")));
				bean.setTax_yn			("Y");//세금계산서등록여부
				bean.setCash_acc_no		("");//세금계산서등록여부
				bean.setBank_acc_nm		(String.valueOf(ht.get("BANK_ACC_NM"))==null?"":String.valueOf(ht.get("BANK_ACC_NM")));
				bean.setReg_id			(user_id);
				bean.setP_step			("0");
				bean.setAcct_code_st	("");
				
				reqseq = pm_db.insertPay(bean);
				
				
				//출금원장
				PayMngBean item = new PayMngBean();
				item.setReqseq			(reqseq);
				item.setI_seq			(1);
				item.setR_est_dt		(bean.getP_est_dt());
				item.setP_gubun			("13");
				item.setP_cd1			(String.valueOf(ht.get("P_CD1"))==null?"":String.valueOf(ht.get("P_CD1")));
				item.setP_cd2			(String.valueOf(ht.get("P_CD2"))==null?"":String.valueOf(ht.get("P_CD2")));
				item.setP_cd3			(String.valueOf(ht.get("P_CD3"))==null?"":String.valueOf(ht.get("P_CD3")));
				item.setP_cd4			(String.valueOf(ht.get("P_CD4"))==null?"":String.valueOf(ht.get("P_CD4")));
				item.setP_cd5			(String.valueOf(ht.get("P_CD5"))==null?"":String.valueOf(ht.get("P_CD5")));
				item.setP_st1			(String.valueOf(ht.get("P_CD1"))==null?"":String.valueOf(ht.get("P_CD1")));
				item.setP_st2			(String.valueOf(ht.get("P_CD2"))==null?"":String.valueOf(ht.get("P_CD2")));
				item.setP_cd3			(String.valueOf(ht.get("P_CD3"))==null?"":String.valueOf(ht.get("P_CD3")));
				item.setP_cd4			(String.valueOf(ht.get("P_CD4"))==null?"":String.valueOf(ht.get("P_CD4")));
				item.setP_cd5			(String.valueOf(ht.get("P_CD5"))==null?"":String.valueOf(ht.get("P_CD5")));
				item.setI_amt			(autodocu_s_amt+autodocu_v_amt);
				item.setI_s_amt			(autodocu_s_amt);
				item.setI_v_amt			(autodocu_v_amt);
				item.setSub_amt1		(autodocu_s_amt);
				item.setSub_amt2		(autodocu_v_amt);
				item.setSub_amt3		(String.valueOf(ht.get("SUB_AMT3"))==null?0:AddUtil.parseDigit(String.valueOf(ht.get("SUB_AMT3"))));
				item.setSub_amt4		(String.valueOf(ht.get("SUB_AMT4"))==null?0:AddUtil.parseDigit(String.valueOf(ht.get("SUB_AMT4"))));
				item.setSub_amt5		(String.valueOf(ht.get("SUB_AMT5"))==null?0:AddUtil.parseDigit(String.valueOf(ht.get("SUB_AMT5"))));
				item.setAcct_code		(String.valueOf(ht.get("ACCT_CODE"))==null?"":String.valueOf(ht.get("ACCT_CODE")));
				item.setP_cont			(String.valueOf(ht.get("P_CONT"))==null?"":String.valueOf(ht.get("P_CONT")));
				item.setBuy_user_id		(String.valueOf(ht.get("BUY_USER_ID"))==null?"":String.valueOf(ht.get("BUY_USER_ID")));
				if(!pm_db.insertPayItem(item)) flag1 += 1;
				
				
				int flag5 = 0;
				//회계처리 프로시저 호출----------------------------------------------------------------------------
				//System.out.println(reqseq);
				System.out.println(" 회계처리 (미지급금) 프로시저 등록");
				String  d_flag1 =  pm_db.call_sp_pay_25300_s_autodocu(sender_bean.getUser_nm(), reqseq);
				//System.out.println(d_flag1);
				if (!d_flag1.equals("0")) flag5 = 1;
				//--------------------------------------------------------------------------------------------------	
				
			}
	%>
<script language='javascript'>
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
//	fm.submit();
	
//	window.close();
	parent.location.reload();
</script>
</body>
</html>