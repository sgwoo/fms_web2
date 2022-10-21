<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
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
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
%>


<%
	String tint_no	 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	String tint_st	 	= request.getParameter("tint_st")==null?"":request.getParameter("tint_st");
	String off_id	 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String req_id	 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	
	
	TintBean tint 	= new TintBean();
	
	String sup_off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String sup_est_dt 	= request.getParameter("sup_est_dt")==null?"":request.getParameter("sup_est_dt");
	String sup_est_h 	= request.getParameter("sup_est_h")	==null?"":request.getParameter("sup_est_h");
	
	tint.setTint_st			(tint_st);
	tint.setTint_yn			("Y");
	
	tint.setCom_nm			(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
	tint.setModel_nm		(request.getParameter("model_nm")==null?"":request.getParameter("model_nm"));
	tint.setTint_su			(request.getParameter("tint_su")==null? 0:AddUtil.parseDigit(request.getParameter("tint_su")));		
	tint.setEtc				(request.getParameter("sup_etc")==null?"":request.getParameter("sup_etc"));
	tint.setSup_est_dt		(sup_est_dt+sup_est_h);
	tint.setOff_id			(off_id);
	tint.setOff_nm			(off_nm);
	tint.setReg_id			(req_id);
	tint.setReg_dt			(AddUtil.getDate());	
	tint.setTint_amt		(request.getParameter("tint_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_amt")));		
	tint.setR_tint_amt		(tint.getTint_amt());	
	tint.setB_tint_amt		(request.getParameter("b_tint_amt")==null? 0:AddUtil.parseDigit(request.getParameter("b_tint_amt")));

	
	//=====[consignment] insert=====
	tint_no = t_db.insertCarTint(tint);
	
	if(tint_no.equals("")){
		result++;
	}
	
	%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="tint_no" 			value="<%=tint_no%>">
</form>
<script language='javascript'>
	var flag = 0;	
	
<%		if(result>0){	%>	
	alert('용품의뢰 등록 에러입니다.\n\n확인하십시오');		flag = 1;
<%		}else{	%>		
	alert('등록되었습니다.');
	var fm = document.form1;		
	fm.action = 'tint_w_frame.jsp';
	fm.target = 'd_content';
	fm.submit();		
<%		}	%>		
</script>
</body>
</html>