<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/off/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
//	if(1==1)return;
	
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
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	boolean flag1 = true;

	int flag = 0;		

	
	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);		
		
%>

<%
	if(cng_item.equals("mgr")){
		//관계자정보-----------------------------------------------------------------------------------------------
		
		//car_mgr
		String mgr_id[] 			= request.getParameterValues("mgr_id");
		String mgr_st[] 			= request.getParameterValues("mgr_st");
		String mgr_com[] 			= request.getParameterValues("mgr_com");
		String mgr_dept[] 			= request.getParameterValues("mgr_dept");
		String mgr_nm[] 			= request.getParameterValues("mgr_nm");
		String mgr_title[] 			= request.getParameterValues("mgr_title");
		String mgr_tel[] 			= request.getParameterValues("mgr_tel");
		String mgr_m_tel[] 			= request.getParameterValues("mgr_m_tel");
		String mgr_email[] 			= request.getParameterValues("mgr_email");
		
		String mgr_ssn[] 			= request.getParameterValues("mgr_ssn");
		String mgr_addr[] 			= request.getParameterValues("mgr_addr");
		String mgr_lic_no[] 			= request.getParameterValues("mgr_lic_no");
		String mgr_etc[] 			= request.getParameterValues("mgr_etc");
		
		
		int mgr_size = mgr_st.length;
		
		for(int i = 0 ; i < mgr_size ; i++){
			
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, mgr_st[i]);
			//근무처,부서,성명,직위,전화번호,휴대폰,이메일
			mgr.setMgr_nm		(mgr_nm[i]);
			
			if(base.getCar_st().equals("4")){
				mgr.setSsn		(mgr_ssn[i]);
				mgr.setMgr_addr		(mgr_addr[i]);
				mgr.setLic_no		(mgr_lic_no[i]);		
				mgr.setEtc		(mgr_etc[i]);		
			}else{
				mgr.setMgr_dept		(mgr_dept[i]);
				mgr.setMgr_title	(mgr_title[i]);
				mgr.setMgr_email	(mgr_email[i].trim());
				mgr.setCom_nm		(mgr_com[i]);
				if(i == 0){
					mgr.setMgr_zip		(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
					mgr.setMgr_addr		(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
				}
			}
			mgr.setMgr_tel		(mgr_tel[i]);
			mgr.setMgr_m_tel	(mgr_m_tel[i]);
			
			
			if(!mgr_st[i].equals("")){
				if(!mgr.getRent_l_cd().equals("")){
					//=====[CAR_MGR] update=====
					flag1 = a_db.updateCarMgrNew(mgr);
				}else{
					mgr.setRent_mng_id	(rent_mng_id);
					mgr.setRent_l_cd	(rent_l_cd);
					mgr.setMgr_id		(mgr_id[i]);
					mgr.setMgr_st		(mgr_st[i]);
					
					//=====[CAR_MGR] update=====
					flag1 = a_db.insertCarMgr(mgr);
				}
			}
		}%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('관계자정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	parent.window.close();

</script>
</body>
</html>