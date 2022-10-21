<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.tint.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit		= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String trf_st		= request.getParameter("trf_st")==null?"":request.getParameter("trf_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag9 = true;
	int result = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
%>


<%
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	if(trf_st.equals("0")){
		pur.setCon_pay_dt	("");
	}else if(trf_st.equals("1")){
		pur.setTrf_pay_dt1	("");
	}else if(trf_st.equals("2")){
		pur.setTrf_pay_dt2	("");
	}else if(trf_st.equals("3")){
		pur.setTrf_pay_dt3	("");
	}else if(trf_st.equals("4")){
		pur.setTrf_pay_dt4	("");
	}else if(trf_st.equals("5")){
		pur.setTrf_pay_dt5	("");
	}
	pur.setPur_pay_dt	("");
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	%>
<script language='javascript'>
<%		if(!flag4){	%>	alert('출고정보 수정 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">   
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>      
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='mode'	 			value='<%=mode%>'>     
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_doc_u.jsp';
	if(fm.mode.value=='view'){
		fm.target = 'View_PUR_DOC';
	}else{
		fm.target = 'd_content';
	}
	fm.submit();
</script>
</body>
</html>