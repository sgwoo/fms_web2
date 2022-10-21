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
	cm_bean.setChe_kd(che_kd);				//��������
	cm_bean.setChe_st_dt(che_st_dt);		//����������ȿ�Ⱓ1
	cm_bean.setChe_end_dt(che_end_dt);		//����������ȿ�Ⱓ2
	cm_bean.setChe_dt(che_dt);				//����������������
	cm_bean.setChe_no(che_no);				//�ǽ��ڰ�����ȣ 
	cm_bean.setChe_comp(che_comp);			//�ǽ��ھ�ü�� 
	cm_bean.setChe_amt(che_amt);			//�˻�ݾ�
	cm_bean.setChe_km(che_km);				//�˻�� ����Ÿ� 
	cm_bean.setMaint_st_dt(maint_st_dt);	//�����˻���ȿ�Ⱓ ������
	cm_bean.setMaint_end_dt(maint_end_dt);  //�����˻���ȿ�Ⱓ ������
	cm_bean.setUpdate_id(user_id);  //������
	cm_bean.setChe_remark(che_remark);  //Ư�̻��� 

	System.out.println("car_maint=" + car_mng_id + ":" +user_id + "�����˻�(����)��ȿ�Ⱓ :" + maint_st_dt + ":" + maint_end_dt + "�˻�(����)��ȿ�Ⱓ:"+ che_st_dt + ":" + che_end_dt ); 

	CusReg_Database cr_db = CusReg_Database.getInstance();
	if(gubun.equals("i")){
		cm_bean.setReg_id(user_id);  //������
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
		alert("��ϵǾ����ϴ�.");
	<%}else if(gubun.equals("u")){%>
		alert("�����Ǿ����ϴ�.");
	<%}%>
	parent.parent.location.href = "cus_reg_maint.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&client_id=<%=client_id%>&go_url=<%=go_url%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
