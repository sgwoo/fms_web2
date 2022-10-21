<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*"%>
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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String emp_id	 	= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	boolean flag1 = true;
%>


<%
	//1. 영업소사원 지금수수료 청구 수정-----------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 		= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	emp1.setReq_dt		 	(request.getParameter("req_dt")			==null?"":request.getParameter("req_dt"));
	emp1.setReq_cont	 	(request.getParameter("req_cont")		==null?"":request.getParameter("req_cont"));
	emp1.setReq_id			(user_id);
	
	//=====[commi] update=====
	//flag1 = a_db.updateCommiNew(emp1);


	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String doc_etc 	= request.getParameter("doc_etc")==null?"":request.getParameter("doc_etc");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "["+firm_nm+"]지급수수료 지출 결의";
	String cont 	= "아래와 같이 지급수수료 지출을 요청합니다.";
	cont 			= cont+"\n\n"+doc_etc;
	String url 		= "/fms2/lc_rent/commi_pay_s_frame.jsp?s_kd=2|t_wd="+rent_l_cd;
	String m_url = "/fms2/lc_rent/commi_pay_s_frame.jsp";
	
	//사용자 정보 조회
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	



	//3. 문서처리전 등록-------------------------------------------------------------------------------------------
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("1");//영업수당지출요청
	doc.setRent_l_cd(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc(emp1.getReq_cont());
	doc.setReg_id(user_id);
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>


<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>

	var fm = document.form1;
	
	fm.action = '<%=from_page%>';	
	fm.target = 'c_foot';
//	fm.submit();
	
//	parent.window.close();
	window.close();

</script>
</body>
</html>