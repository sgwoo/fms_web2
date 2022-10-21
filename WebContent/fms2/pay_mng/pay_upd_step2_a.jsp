<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*, acar.accid.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="cr_bean"  class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_bean"  class="acar.car_register.CarMaintBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	AccidDatabase      	as_db 	= AccidDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	


	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;

	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String deposit_no 	= request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no");	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 = request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String accid_yn 	= request.getParameter("accid_yn")==null?"":request.getParameter("accid_yn");
	String serv_yn 		= request.getParameter("serv_yn")==null?"":request.getParameter("serv_yn");
	String maint_yn 	= request.getParameter("maint_yn")==null?"":request.getParameter("maint_yn");
	String rep_cont  	= request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");


	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//출금원장
	PayMngBean bean 	= pm_db.getPay(reqseq);
	
	bean.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	bean.setVen_name		(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	bean.setVen_st			(request.getParameter("ven_st")==null?"":request.getParameter("ven_st"));//거래처유형
	bean.setTax_yn			(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));//세금계산서등록여부	
	bean.setAcct_code_st	(request.getParameter("acct_code_st")==null?"":request.getParameter("acct_code_st"));//미지급금처리여부
	bean.setCash_acc_no		(request.getParameter("cash_acc_no")==null?"":request.getParameter("cash_acc_no"));//세금계산서등록여부
	
	if(!pm_db.updatePay(bean)) flag1 += 1;
	
	
	String vid1[] = request.getParameterValues("i_seq");
	String vid2[] = request.getParameterValues("p_cont");
	
	int vid_size = vid1.length;
	
	for(int i=0;i < vid_size;i++){
		//원장세부내역
		PayMngBean item = pm_db.getPayItem(reqseq, AddUtil.parseInt(vid1[i]));
		item.setP_cont(vid2[i]);
		if(!pm_db.updatePayItem(item)) flag3 += 1;
	}
	
	
	if(flag1 == 0){
		
		//trade_his 거래처변경이력등록
		if(!bean.getVen_code().equals("")){
			Hashtable ven_his = neoe_db.getTradeHisCase(bean.getVen_code());	//그대로 사용
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
				if(!neoe_db.insertTradeHis(t_bean)) flag2 += 1;	//그대로 사용
			}
		}
		
	}
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
		fm.action = 'pay_upd_step2.jsp';
		fm.target = 'd_content';
		fm.submit();
		
		//parent.window.close();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>  
</form>
<script language='javascript'>
<!--
<%	if(flag1>0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("수정하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
