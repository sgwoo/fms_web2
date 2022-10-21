<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cls.*, acar.car_office.* "%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cls_st	 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	int    fee_size	 	= request.getParameter("fee_size")==null?0:AddUtil.parseInt(request.getParameter("fee_size"));
	String fee_tm	 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String con_cd3 		= request.getParameter("con_cd3")==null?"":request.getParameter("con_cd3");
	String con_cd4 		= request.getParameter("con_cd4")==null?"":request.getParameter("con_cd4");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;



	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cls_cont
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id	(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	cls.setTerm_yn		("Y");
	cls.setCls_st		(cls_st);
	cls.setCls_dt		(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
	cls.setCls_cau		(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
	cls.setReg_id		(user_id);
	
	flag1 = as_db.insertCls2(cls);
	
	
	//매각
	if(cls_st.equals("6"))			flag2 = as_db.closeContNoRecon(rent_mng_id, rent_l_cd);
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag1){	%>
		alert('계약 해지정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag2){	%>
		alert('해지처리 에러입니다.\n\n확인하십시오');
<%		}	%>		


	fm.action = 'lc_cls_sui_frame.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>