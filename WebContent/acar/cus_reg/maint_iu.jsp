<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.cus_reg.*" %>
<jsp:useBean id="cm_bean" class="acar.cus_reg.Car_MaintBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	int seq_no = request.getParameter("seq_no")==null?0:AddUtil.parseDigit(request.getParameter("seq_no"));
	String che_kd = request.getParameter("che_kd")==null?"":request.getParameter("che_kd");
	String che_st_dt = request.getParameter("che_st_dt")==null?"":request.getParameter("che_st_dt");
	String che_end_dt = request.getParameter("che_end_dt")==null?"":request.getParameter("che_end_dt");
	String che_dt = request.getParameter("che_dt")==null?"":request.getParameter("che_dt");
	String che_no = request.getParameter("che_no")==null?"":request.getParameter("che_no");
	String che_comp = request.getParameter("che_comp")==null?"":request.getParameter("che_comp");
	int che_amt = request.getParameter("che_amt")==null?0:AddUtil.parseDigit(request.getParameter("che_amt"));
	int che_km = request.getParameter("che_km")==null?0:AddUtil.parseDigit(request.getParameter("che_km"));
	String maint_st_dt = request.getParameter("maint_st_dt")==null?"":request.getParameter("maint_st_dt");
	String maint_end_dt = request.getParameter("maint_end_dt")==null?"":request.getParameter("maint_end_dt");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String che_remark = request.getParameter("che_remark")==null?"":request.getParameter("che_remark");
	//int result = 0;	
	
	cm_bean.setCar_mng_id(car_mng_id);
	cm_bean.setSeq_no(seq_no);				//SEQ_NO
	cm_bean.setChe_kd(che_kd);				//점검종별
	cm_bean.setChe_st_dt(che_st_dt);		//점검정비유효기간1
	cm_bean.setChe_end_dt(che_end_dt);		//점검정비유효기간2
	cm_bean.setChe_dt(che_dt);				//점검정비점검일자
	cm_bean.setChe_no(che_no);				//실시자고유번호 
	cm_bean.setChe_comp(che_comp);			//실시자업체명 
	cm_bean.setChe_amt(che_amt);			//검사금액
	cm_bean.setChe_km(che_km);				//검사시 주행거리 
	cm_bean.setMaint_st_dt(maint_st_dt);	//다음검사유효기간 시작일
	cm_bean.setMaint_end_dt(maint_end_dt);  //다음검사유효기간 만료일
	cm_bean.setUpdate_id(user_id);  //수정자
	cm_bean.setChe_remark(che_remark);  //특이사항 

	System.out.println("car_maint=" + car_mng_id + ":" +user_id + "다음검사(점검)유효기간 :" + maint_st_dt + ":" + maint_end_dt + "검사(점검)유효기간:"+ che_st_dt + ":" + che_end_dt ); 

	CusReg_Database cr_db = CusReg_Database.getInstance();
	if(gubun.equals("i")){
		cm_bean.setReg_id(user_id);  //수정자
		seq_no = cr_db.insertCarMaint(cm_bean);
	}else if(gubun.equals("u")){
		seq_no = cr_db.updateCarMaint(cm_bean);
	}else{

	}
  
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(seq_no>0){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.parent.location.href = "cus_reg_maint.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&client_id=<%=client_id%>&go_url=<%=go_url%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
