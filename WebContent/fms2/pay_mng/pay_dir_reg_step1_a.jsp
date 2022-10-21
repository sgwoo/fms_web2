<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*, acar.cus0601.*, acar.accid.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="cr_bean"  class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_bean"  class="acar.car_register.CarMaintBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	Cus0601_Database   	c61_db 	= Cus0601_Database.getInstance();
	AccidDatabase      	as_db 	= AccidDatabase.getInstance();
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

 	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���


	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;

	String deposit_no 	= request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no");
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 	= request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String acct_code_st 	= request.getParameter("acct_code_st")==null?"":request.getParameter("acct_code_st");
	String accid_yn 	= request.getParameter("accid_yn")==null?"":request.getParameter("accid_yn");
	String serv_yn 		= request.getParameter("serv_yn")==null?"":request.getParameter("serv_yn");
	String maint_yn 	= request.getParameter("maint_yn")==null?"":request.getParameter("maint_yn");
	String rep_cont  	= request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String reqseq 		= "";
	
	String value3[] = request.getParameterValues("user_nm");


	//�����
	UsersBean sender_bean 	= umd.getUsersBean(user_id);


	PayMngBean bean = new PayMngBean();
	
	bean.setReqseq			("");
	bean.setP_est_dt		(request.getParameter("p_est_dt")==null?"":request.getParameter("p_est_dt"));
	bean.setReg_st			("D");
	bean.setP_way			(request.getParameter("p_way")==null?"5":request.getParameter("p_way"));
	bean.setOff_st			(request.getParameter("off_st")==null?"":request.getParameter("off_st"));
	bean.setOff_id			(request.getParameter("off_id")==null?"":request.getParameter("off_id"));
	bean.setOff_nm			(request.getParameter("off_nm")==null?"":request.getParameter("off_nm"));
	bean.setOff_tel			(request.getParameter("off_tel")==null?"":request.getParameter("off_tel"));
	bean.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	bean.setVen_name		(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	
	if(!bean.getOff_nm().equals("") && bean.getVen_name().equals("")) 					bean.setVen_name(bean.getOff_nm()	);
	else if(bean.getOff_nm().equals("") && !bean.getVen_name().equals("")) 					bean.setOff_nm	(bean.getVen_name()	);
	
	if(bean.getOff_st().equals("other") && bean.getOff_id().equals("") && !bean.getVen_code().equals("")) 	bean.setOff_id	(bean.getVen_code()	);
	
	bean.setAmt			(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_amt")));
	
	if(!bean.getP_way().equals("1")){	
		bean.setBank_id			(request.getParameter("bank_id")==null?"":request.getParameter("bank_id"));
		bean.setBank_nm			(request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm"));
		bean.setBank_no			(request.getParameter("bank_no")==null?"":request.getParameter("bank_no"));
		bean.setBank_acc_nm		(request.getParameter("bank_acc_nm")==null?"":request.getParameter("bank_acc_nm"));//�Աݰ��� ������
	}
	
	
	if(!deposit_no.equals("")){
		//��������
		Hashtable acc = ps_db.getDepositma(deposit_no);
		
		bean.setA_bank_id	(String.valueOf(acc.get("BANK_CODE"))==null?"":String.valueOf(acc.get("BANK_CODE")));
		bean.setA_bank_nm	(String.valueOf(acc.get("CHECKD_NAME"))==null?"":String.valueOf(acc.get("CHECKD_NAME")));
		bean.setA_bank_no	(deposit_no);
	}
	bean.setCard_id			(request.getParameter("card_id")==null?"":request.getParameter("card_id"));
	bean.setCard_nm			(request.getParameter("card_nm")==null?"":request.getParameter("card_nm"));
	bean.setCard_no			(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
	bean.setVen_st			(request.getParameter("ven_st")==null?"":request.getParameter("ven_st"));//�ŷ�ó����
	bean.setS_idno			(request.getParameter("off_idno")==null?"":request.getParameter("off_idno"));
	bean.setTax_yn			(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));//���ݰ�꼭��Ͽ���
	bean.setCash_acc_no		(request.getParameter("cash_acc_no")==null?"":request.getParameter("cash_acc_no"));//���ݰ�꼭��Ͽ���	
	bean.setAt_once			(request.getParameter("at_once")==null?"":request.getParameter("at_once"));//��ݽð�
	bean.setReg_id			(user_id);
	bean.setP_step			("0");
	bean.setAcct_code_st		(acct_code_st);
	
	
	//���ϰ��ߺ�üũ
	int pay_chk_cnt  =  pm_db.getPayRegChk(bean);
	
	
	if(!bean.getOff_st().equals("off_id"))	pay_chk_cnt = 0;
	
	
	
		
		if(acct_code_st.equals("2")) 	bean.setR_acct_code	("25300");//�����
		
		//������ü(����ó) �����ڵ�-code
		if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getBankCode("", bean.getBank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setBank_cms_bk(String.valueOf(ht.get("CMS_BK")));
				bean.setBank_id(String.valueOf(ht.get("CMS_BK")));
			}
		}
		//������ü(����ó) �����ڵ�-�׿���
		if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getBank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setBank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		//������ü(����ó) �����ڵ�-code
		if(!bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getBankCode("", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setA_bank_cms_bk(String.valueOf(ht.get("CMS_BK")));
				bean.setA_bank_id(String.valueOf(ht.get("CMS_BK")));
			}
		}
		//������ü(����ó) �����ڵ�-�׿���
		if(bean.getA_bank_id().equals("") && !bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setA_bank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		//������ü(����ó) �����ڵ�
		if(bean.getA_bank_nm().equals("����") && bean.getA_bank_id().equals("")){
			bean.setA_bank_id("260");
		}		
		//������ü(����ó) �����ڵ�
		if(bean.getA_bank_nm().equals("����") && bean.getA_bank_id().equals("null")){
			bean.setA_bank_id("260");
		}				
		
		if(AddUtil.lengthb(bean.getVen_name()) > 30 )	bean.setVen_name	(AddUtil.substringb(bean.getVen_name(),30 ));
		
		
		reqseq = pm_db.insertPay(bean);
		



	if(pay_chk_cnt>0){
		System.out.println("[��ݿ����������-�����Է°�]"+reqseq);
	}



	System.out.println("[��ݿ����������1�ܰ�------------------"+reqseq);


	if(!reqseq.equals("")){
		
		//trade_his �ŷ�ó�����̷µ��
		if(!bean.getVen_code().equals("")){
			Hashtable ven_his = neoe_db.getTradeHisCase(bean.getVen_code());	//�״�� ���
			if(String.valueOf(ven_his.get("VEN_ST")).equals("") && !String.valueOf(ven_his.get("VEN_ST")).equals(bean.getVen_st())){
				TradeBean t_bean = new TradeBean();
				t_bean.setCust_code	(String.valueOf(ven_his.get("CUST_CODE")));
				t_bean.setCust_name	(String.valueOf(ven_his.get("CUST_NAME")));
				t_bean.setS_idno	(String.valueOf(ven_his.get("S_IDNO")));
				t_bean.setDname		(String.valueOf(ven_his.get("DNAME")));
				t_bean.setMail_no	(String.valueOf(ven_his.get("MAIL_NO")));
				t_bean.setS_address	(String.valueOf(ven_his.get("S_ADDRESS")));
				t_bean.setMd_gubun	(String.valueOf(ven_his.get("MD_GUBUN")));
				t_bean.setDc_rmk	(String.valueOf(ven_his.get("DC_RMK")));
				t_bean.setVen_st	(bean.getVen_st());
				t_bean.setUser_id	(user_id);
				if(!neoe_db.insertTradeHis(t_bean)) flag2 += 1;	//�״�� ���
				
				System.out.println("�ŷ�ó�����̷µ��");
			}
		}
		
		//���¾�ü �׿����ڵ�/���¹�ȣ �־��ֱ�
		if(bean.getOff_st().equals("off_id") && !bean.getBank_no().equals("")){
			c61_soBn = c61_db.getServOff(bean.getOff_st());
			if(c61_soBn.getVen_code().equals("")){
				c61_soBn.setVen_code	(bean.getVen_code());
				
				if(c61_soBn.getAcc_no().equals("")){
					c61_soBn.setBank	(bean.getBank_nm());
					c61_soBn.setAcc_no	(bean.getBank_no());
				}
				flag4 = c61_db.updateServOff(c61_soBn);
			}else{
				if(c61_soBn.getAcc_no().equals("")){
					c61_soBn.setBank	(bean.getBank_nm());
					c61_soBn.setAcc_no	(bean.getBank_no());
					flag4 = c61_db.updateServOff(c61_soBn);
				}
			}
			System.out.println("���¾�ü �׿����ڵ�/���¹�ȣ �־��ֱ�");
		}
	
	}
	
	System.out.println("pay_chk_cnt="+pay_chk_cnt);
	System.out.println("reqseq="+reqseq);
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
		fm.action = 'pay_dir_reg_step2.jsp';
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
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>      
</form>
<script language='javascript'>
<!--
<%	if(pay_chk_cnt>0){%>
		alert("����ó�� ���¾�ü�̸鼭 �ŷ�����, ����ó��, �ݾ��� ������ ���� �̹� ���ϵǾ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.");
<%	}%>		


<%	if(reqseq.equals("")){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("1�ܰ� ����Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
