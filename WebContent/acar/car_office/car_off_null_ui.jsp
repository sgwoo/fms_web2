<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*, acar.bill_mng.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");	
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	String ven_autoreg_yn = request.getParameter("ven_autoreg_yn")==null?"":request.getParameter("ven_autoreg_yn");
	
	String car_off_id = "";					//������ID
  String car_comp_id = "";					//�ڵ���ȸ��ID
  String car_comp_nm = "";					//�ڵ���ȸ���̸�
  String car_off_nm = "";					//�����Ҹ�
  String car_off_st = "";					//�����ұ���
  String owner_nm = "";					//������
  String car_off_tel = "";					//�繫����ȭ
  String car_off_fax = "";					//�ѽ�
  String car_off_post = "";				//�����ȣ
  String car_off_addr = "";				//�ּ�
  String bank = "";						//���°�������
  String acc_no = "";						//���¹�ȣ
  String acc_nm = "";						//������
  String agnt_nm = "";					//���ǹ���
  String agnt_m_tel = "";					//���ǹ�����ȭ
	String manager = "";					//����
	String enp_no = "";					//����ڹ�ȣ
	String agnt_email = "";					//���ǹ��ڸ���
	String use_yn = "";					//�ŷ�����
	
  String cmd = "";
	int count = 0;
	int flag = 0;
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert ����
	}
	if(request.getParameter("car_off_id")!=null)	car_off_id 		= request.getParameter("car_off_id");
	if(request.getParameter("car_comp_id")!=null) 	car_comp_id 		= request.getParameter("car_comp_id");
	if(request.getParameter("car_comp_nm")!=null) 	car_comp_nm 		= request.getParameter("car_comp_nm");
	if(request.getParameter("car_off_nm")!=null) 	car_off_nm 		= request.getParameter("car_off_nm");
	if(request.getParameter("car_off_st")!=null) 	car_off_st 		= request.getParameter("car_off_st");
	if(request.getParameter("owner_nm")!=null) 	owner_nm 		= request.getParameter("owner_nm");
	if(request.getParameter("car_off_tel")!=null) 	car_off_tel 		= request.getParameter("car_off_tel");
	if(request.getParameter("car_off_fax")!=null) 	car_off_fax 		= request.getParameter("car_off_fax");
	if(request.getParameter("car_off_post")!=null) 	car_off_post 		= request.getParameter("car_off_post");
	if(request.getParameter("car_off_addr")!=null) 	car_off_addr 		= request.getParameter("car_off_addr");
	if(request.getParameter("bank")!=null) 		bank 			= request.getParameter("bank");
	if(request.getParameter("acc_no")!=null) 	acc_no 			= request.getParameter("acc_no");
	if(request.getParameter("acc_nm")!=null) 	acc_nm 			= request.getParameter("acc_nm");
	if(request.getParameter("agnt_nm")!=null) 	agnt_nm 		= request.getParameter("agnt_nm");
	if(request.getParameter("agnt_m_tel")!=null) 	agnt_m_tel 		= request.getParameter("agnt_m_tel");
	if(request.getParameter("manager")!=null) 	manager 		= request.getParameter("manager");
	if(request.getParameter("enp_no")!=null) 	enp_no 			= request.getParameter("enp_no");
	if(request.getParameter("agnt_email")!=null) 	agnt_email 		= request.getParameter("agnt_email");
	if(request.getParameter("use_yn")!=null) 	use_yn 			= request.getParameter("use_yn");

	
	if(cmd.equals("i")||cmd.equals("u"))
	{
				
		co_bean.setCar_off_id	(car_off_id);
		co_bean.setCar_comp_id	(car_comp_id);
		co_bean.setCar_comp_nm	(car_comp_nm);
		co_bean.setCar_off_nm	(car_off_nm);
		co_bean.setCar_off_st	(car_off_st);
		co_bean.setOwner_nm	(owner_nm);
		co_bean.setCar_off_tel	(car_off_tel);
		co_bean.setCar_off_fax	(car_off_fax);
		co_bean.setCar_off_post	(car_off_post);
		co_bean.setCar_off_addr	(car_off_addr);
		co_bean.setBank		(bank);
		co_bean.setAcc_no	(acc_no);
		co_bean.setAcc_nm	(acc_nm);
		co_bean.setManager	(manager);
		co_bean.setAgnt_nm	(agnt_nm);
		co_bean.setAgnt_m_tel	(agnt_m_tel);
		co_bean.setVen_code	(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		co_bean.setEnp_no	(enp_no);
		co_bean.setAgnt_email	(agnt_email);
		co_bean.setUse_yn	(use_yn);
		
		co_bean.setEnp_reg_st	(request.getParameter("enp_reg_st")==null?"":request.getParameter("enp_reg_st"));
		co_bean.setDoc_st	(request.getParameter("doc_st")==null?"":request.getParameter("doc_st"));
		co_bean.setEst_day	(request.getParameter("est_day")==null?"":request.getParameter("est_day"));
		co_bean.setReq_st	(request.getParameter("req_st")==null?"":request.getParameter("req_st"));
		co_bean.setPay_st	(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
		if(co_bean.getEst_day().equals("D")){
			co_bean.setEst_day(request.getParameter("est_day_sub")==null?"":request.getParameter("est_day_sub"));	
			co_bean.setEst_mon_st(request.getParameter("est_mon_st")==null?"":request.getParameter("est_mon_st"));	
		}else{
			co_bean.setEst_day("");	
		}
		
		co_bean.setBank_cd	(request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd"));
		
		
		if(!co_bean.getBank_cd().equals("")){
			co_bean.setBank		(c_db.getNameById(co_bean.getBank_cd(), "BANK"));
		}
		
		
		if(cmd.equals("i"))
		{
			count = umd.insertCarOff(co_bean);
		}else if(cmd.equals("u")){
			count = umd.updateCarOff(co_bean);
		}
	}
	
	if(cmd.equals("neom") || ven_autoreg_yn.equals("Y"))	
	{
		//�׿��� �ŷ�ó ó��-------------------------------		
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
						
		co_bean.setCar_off_id	(car_off_id);
		co_bean.setCar_comp_id	(car_comp_id);
		co_bean.setCar_comp_nm	(car_comp_nm);
		co_bean.setCar_off_nm	(car_off_nm);
		co_bean.setCar_off_st	(car_off_st);
		co_bean.setOwner_nm		(owner_nm);
		co_bean.setCar_off_tel	(car_off_tel);
		co_bean.setCar_off_fax	(car_off_fax);
		co_bean.setCar_off_post	(car_off_post);
		co_bean.setCar_off_addr	(car_off_addr);
		co_bean.setBank			(bank);
		co_bean.setAcc_no		(acc_no);
		co_bean.setAcc_nm		(acc_nm);
		co_bean.setManager		(manager);
		co_bean.setAgnt_nm		(agnt_nm);
		co_bean.setAgnt_m_tel		(agnt_m_tel);
		co_bean.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		co_bean.setEnp_no		(enp_no);
					
		//�ߺ�üũ
		String ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(car_off_nm,15), "", enp_no);
		
		if(ven_code.equals("") && !enp_no.equals("")){
					
			TradeBean t_bean = new TradeBean();
			
			t_bean.setCust_name	(AddUtil.substring(car_off_nm,15));
			t_bean.setS_idno	(enp_no);
			t_bean.setId_no		("");
			t_bean.setDname		(AddUtil.substring(manager,15));
			t_bean.setMail_no	(car_off_post);
			t_bean.setS_address	(AddUtil.substring(car_off_addr,30));
			t_bean.setUptae		("");
			t_bean.setJong		("");
						
			if(!neoe_db.insertTrade(t_bean)) flag += 1;	
			
			ven_code = neoe_db.getVenCodeChk("1", AddUtil.substring(car_off_nm,15), "", enp_no);
			
			co_bean.setVen_code	(ven_code);
			
		}else{
			co_bean.setVen_code	(ven_code);
		}		
	
		count = umd.updateCarOff(co_bean);		
	
	}
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%
	if(cmd.equals("u") || cmd.equals("neom"))
	{
%>

alert("���������� �����Ǿ����ϴ�.");
    <%if(st.equals("car_off")){%>
		window.close();
		//opener.location.reload();
	<%}else{%>
	<%		if(mode.equals("car_pur")){%>
		var theForm = document.form1;
		theForm.action="/fms2/car_pur/view_car_office.jsp";
		theForm.submit();	
	<%		}else{%>
		var theForm = document.form1;
		theForm.target="d_content";
		theForm.submit();
		//window.location="about:blank";
	<%		}%>	
	<%}%>
<%
	}else{
		if(count==1)
		{
%>
alert("���������� ��ϵǾ����ϴ�.");
var theForm = document.form1;
theForm.target="d_content";
theForm.submit();
//window.location="about:blank";
<%
		}
	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./car_office_frame.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="car_off_id" value="<%=car_off_id%>">
</form>
</body>
</html>