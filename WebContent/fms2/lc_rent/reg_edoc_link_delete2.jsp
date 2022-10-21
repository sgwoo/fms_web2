<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.alink.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 	= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 	= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 	= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 	= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");
	
	String doc_code 	= request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
	
	boolean flag1 = true;
	
	Hashtable ht = ln_db.getALink(link_table, doc_code);
	
	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);	

	//기존문서 미사용처리 - 전자문서 재전송데이터 처리		
	flag1 = ln_db.updateAlinkDocyn(doc_code, link_table, "D");

	String doc_code2  = Long.toString(System.currentTimeMillis());

	//기존문서 미사용처리 - 전자문서 재전송데이터 처리		
	flag1 = ln_db.updateAlinkTmsgSeq(doc_code, link_table, "LC"+doc_code2);
	
	//전자문서 재전송데이터 처리		
	flag1 = ln_db.call_sp_alink_reg_doc(doc_code, link_table);
			
	if(String.valueOf(ht.get("COMPANY_NAME")).equals("")){
		flag1 = false;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
</form>
<script language="JavaScript">
<!--
<%if(flag1){%>

	alert("정상적으로 취소 되었습니다.");
	
	var fm = document.form1;		
	fm.action='reg_edoc_link2.jsp';		
	fm.target='EDOC_LINK2';
	fm.submit();
		
	//parent.window.close();
	
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	//parent.window.close();				
<%}%>

//-->
</script>
</body>
</html>