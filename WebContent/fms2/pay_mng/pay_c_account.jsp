<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.cont.*, acar.car_office.*, tax.*, acar.car_sche.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_type	= request.getParameter("doc_type")==null?"N":request.getParameter("doc_type");
	String doc_dt	= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");
	
	
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase    	nm_db 	= MaMenuDatabase.getInstance();
	CarOfficeDatabase 	cod 	= CarOfficeDatabase.getInstance();
	
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	
	
	String vid[] 		= request.getParameterValues("ch_cd");
	String reqseq 		= "";
	String target_id 	= "";
	
	int vid_size = vid.length;
	
	String pay_code  = Long.toString(System.currentTimeMillis());
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int result = 0;
	int result2 = 0;
	
	if(sender_bean.getUser_nm().equals("정현미")){
		sender_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("출금담당"));	 
	}	
	
	/*
		
		자동전표 처리
		
	*/
	
	for(int i=0;i < vid_size;i++){
		
		reqseq = vid[i];
		
		//1. 회계코드수정-------------------------------------------------------------------------------------------
		
		//출금원장
		PayMngBean pay 	= pm_db.getPay(reqseq);
		
		if(pay.getVen_name().equals("")){
			//네오엠 거래처명이 있어야 합니다.
			flag2 = false;
			result++;
		}else{
			result2++;
		}
		
		if(flag2)		flag1 = pm_db.updatePayPaycode(reqseq, pay_code);
		
		//출금원장 세부 항목
		Vector vt =  pm_db.getPayItemList(reqseq);
		int vt_size = vt.size();
		for(int j = 0 ; j < 1 ; j++){
				PayMngBean pm = (PayMngBean)vt.elementAt(j);
				//영업수당 부가세분이면 호출
				if(pm.getP_gubun().equals("02") && pm.getP_st4().equals("vat")){
					String  d_flag1 =  pm_db.call_sp_pay_25300_s_autodocu(sender_bean.getUser_nm(), reqseq);
				}
		}
		
		
		flag2 = true;
	}
	
	if(sender_bean.getSa_code().equals("")){
		sender_bean.setSa_code(sender_bean.getId());
	}
	
	
	

	
	System.out.println("<br>* pay_code="+pay_code);
	System.out.println("<br>* sender_nm="+sender_bean.getUser_nm());	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_sp_pay(){
		var fm = document.form1;
		alert("회계처리 프러시저 호출");
		fm.action = "https://fms3.amazoncar.co.kr/acar/admin/call_sp_pay_account.jsp";
		fm.submit();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='size' 		value='<%=vid_size%>'>    
  <input type='hidden' name='pay_code' 	value='<%=pay_code%>'>      
  <input type='hidden' name='doc_type' 	value='<%=doc_type%>'>        
  <input type='hidden' name='doc_dt' 	value='<%=doc_dt%>'>          
  <input type='hidden' name='sender_nm' value='<%=sender_bean.getSa_code()%>'>      
  <input type='hidden' name='kr_nm' value='<%=sender_bean.getUser_nm()%>'>      
</form>  
<script language='javascript'>
<!--
<%	if(result > 0){	%>	alert('조건부합이 '+<%=result%>+'건 입니다.\n\n네오엠거래처를  확인하세요');					<%		}	%>		

<%	if(result2 > 0){	%>
	go_sp_pay();	

<%	}%>	
//-->
</script>
</body>
</html>
