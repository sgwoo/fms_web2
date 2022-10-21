<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_register.*, acar.cus_reg.*" %>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String rent_mng_id = "";
	String rent_l_cd = "";
	String rpt_no = "";
	String client_nm = "";
	String firm_nm = "";
	int imm_amt = 0;
	String car_mng_id = ""; 					//�ڵ���������ȣ
	String car_no = ""; 						//������ȣ
	String car_num = ""; 					//�����ȣ
	String init_reg_dt = ""; 				//���ʵ����
	String car_kd = ""; 						//����
	String car_use = ""; 					//�뵵
	String car_nm = ""; 						//����
	String car_form = ""; 					//���� 
	String car_y_form = ""; 					//����
	String mot_form = ""; 					//����������
	String dpm = ""; 						//���_��ⷮ
	int taking_p = 0; 					//���_��������
	String tire = ""; 						//���_Ÿ�̾�
	String fuel_kd = ""; 					//���_����������
	String conti_rat = ""; 					//���_����
	String mort_st = ""; 					//�����_����
	String mort_dt = ""; 					//�����_����
	String loan_st = ""; 					//��ϼ�����_��ä����
	int loan_b_amt = 0; 					//��ϼ�����_��ä���Խ�
	int loan_s_amt = 0; 					//��ϼ�����_��ä���ν�
	String loan_s_rat = ""; 					//��ϼ�����_��ä������
	int reg_amt = 0; 					//��ϼ�����_��ϼ�
	int acq_amt = 0; 					//��ϼ�����_��漼
	int no_m_amt = 0; 					//��ϼ�����_��ȣ�����ۺ�
	int stamp_amt = 0; 					//��ϼ�����_��������
	String etc = ""; 						//��ϼ�����_��Ÿ
	String maint_st_dt = ""; 				//�˻���ȿ�Ⱓ1
	String maint_end_dt = ""; 				//�˻���ȿ�Ⱓ2
	String cha_no1 = ""; 					//��������ȣ
	String cha_no2 = ""; 					//��������ȣ2
	String car_end_dt = ""; 					//���ɸ�����
	String test_st_dt = ""; 					//������ȿ�Ⱓ1
	String test_end_dt = ""; 				//������ȿ�Ⱓ2
	String acq_std = ""; 					//��漼_����ǥ��
	int acq_acq = 0; 					//��漼_��漼
	String acq_f_dt = ""; 					//��漼_��������
	String acq_ex_dt = ""; 					//��漼_��������
	String acq_re = ""; 						//��漼_����ó
	String acq_is_p = ""; 					//��漼_�������߱���
	String acq_is_o = ""; 					//��漼_�߱�ó
	String reg_dt = ""; 						//�ۼ�����
	String reg_nm = ""; 						//�ۼ���
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("rent_mng_id") != null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") != null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("rpt_no") != null) rpt_no = request.getParameter("rpt_no");
	if(request.getParameter("firm_nm") != null) firm_nm = request.getParameter("firm_nm");
	if(request.getParameter("client_nm") != null) client_nm = request.getParameter("client_nm");
	if(request.getParameter("imm_amt") != null) imm_amt = Util.parseInt(request.getParameter("imm_amt"));
	if(request.getParameter("car_name") != null) car_name = request.getParameter("car_name");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");

	if(cmd.equals("ud"))
	{
		cr_bean = crd.getCarRegBean(car_mng_id);
		car_mng_id = cr_bean.getCar_mng_id();
		car_no = cr_bean.getCar_no();
		car_num = cr_bean.getCar_num();
		init_reg_dt = cr_bean.getInit_reg_dt();
		car_kd = cr_bean.getCar_kd();
		car_use = cr_bean.getCar_use();
		car_nm = cr_bean.getCar_nm();
		car_form = cr_bean.getCar_form();
		car_y_form = cr_bean.getCar_y_form();
		mot_form = cr_bean.getMot_form();
		dpm = cr_bean.getDpm();
		taking_p = cr_bean.getTaking_p();
		tire = cr_bean.getTire();
		fuel_kd = cr_bean.getFuel_kd();
		conti_rat = cr_bean.getConti_rat();
		mort_st = cr_bean.getMort_st();
		mort_dt = cr_bean.getMort_dt();
		loan_st = cr_bean.getLoan_st();
		loan_b_amt = cr_bean.getLoan_b_amt();
		loan_s_amt = cr_bean.getLoan_s_amt();
		loan_s_rat = cr_bean.getLoan_s_rat();
		reg_amt = cr_bean.getReg_amt();
		acq_amt = cr_bean.getAcq_amt();
		no_m_amt = cr_bean.getNo_m_amt();
		stamp_amt = cr_bean.getStamp_amt();
		etc = cr_bean.getEtc();
		maint_st_dt = cr_bean.getMaint_st_dt();
		maint_end_dt = cr_bean.getMaint_end_dt();
		cha_no1 = cr_bean.getCha_no1();
		cha_no2 = cr_bean.getCha_no2();
		car_end_dt = cr_bean.getCar_end_dt();
		test_st_dt = cr_bean.getTest_st_dt();
		test_end_dt = cr_bean.getTest_end_dt();
		acq_std = cr_bean.getAcq_std();
		acq_acq = cr_bean.getAcq_acq();
		acq_f_dt = cr_bean.getAcq_f_dt();
		acq_ex_dt = cr_bean.getAcq_ex_dt();
		acq_re = cr_bean.getAcq_re();
		acq_is_p = cr_bean.getAcq_is_p();
		acq_is_o = cr_bean.getAcq_is_o();
		reg_dt = cr_bean.getReg_dt();
		reg_nm = cr_bean.getReg_nm();
	}
	
	String m1_dt = "";
	
	m1_dt =  cr_db.getMaster_dt(car_mng_id);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function CarRegReg()
{
	var theForm = document.CarRegForm;
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "nodisplay"
	theForm.submit();
}
function CarRegUp()
{
	var theForm = document.CarRegForm;
	if(!confirm('�����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.target = "nodisplay"
	theForm.submit();
}

function OpenIns()
{
	var theForm = document.CarRegForm;
	var rent_mng_id = theForm.rent_mng_id.value;
	var rent_l_cd = theForm.rent_l_cd.value;
	var car_mng_id = theForm.car_mng_id.value;
	var car_no = theForm.car_no.value;
	var rpt_no = theForm.rpt_no.value;
	var firm_nm = theForm.firm_nm.value;
	var client_nm = theForm.client_nm.value;
	var imm_amt = theForm.imm_amt.value;
	var cmd = theForm.cmd.value;
	var auth_rw = theForm.auth_rw.value
	var car_name = theForm.car_name.value;
	var SUBWIN="./register_ins_id.jsp?auth_rw=" + auth_rw 
				+ "&rent_mng_id=" + rent_mng_id
				+ "&rent_l_cd=" + rent_l_cd 
				+ "&car_mng_id=" + car_mng_id 
				+ "&cmd=" + cmd 
				+ "&car_no=" + car_no 
				+ "&rpt_no=" + rpt_no 
				+ "&firm_nm=" + firm_nm 
				+ "&client_nm=" + client_nm 
				+ "&imm_amt=" + imm_amt
				+ "&car_name=" + car_name;
				alert	
	window.open(SUBWIN, "Ins", "left=100, top=100, width=820, height=430, scrollbars=no");
}
function FootWin(arg)
{
	var theForm = document.CarRegForm;

	if(theForm.cmd.value=='id')
	{
		alert("���ȭ���� ����� �ϴ� �޴��� ����Ͻʽÿ�.");
		return;
	}
	if(arg == 'SER')
	{
		//parent.c_foot.location ='register_service_id.jsp';
		theForm.action = "register_service_id.jsp";
		
	}else if(arg == 'CHA'){
		//parent.c_foot.location ='register_change_id.jsp';
		theForm.action = "register_change_id.jsp";	
	}else if(arg == 'ACQ'){
		//parent.c_foot.location ='register_acquisition_id.jsp';
		theForm.action = "register_acquisition_id.jsp";
	}
	
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeMortDT()
{
	var theForm = document.CarRegForm;
	theForm.mort_dt.value = ChangeDate(theForm.mort_dt.value);
}
//-->
</script>
</head>
<body leftmargin="15">
<form action="./register_null_ui.jsp" name="CarRegForm" method="POST" >
<%
if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td ><font color="navy">�������� -> �ڵ������� -> </font><font color="red">���</font></td>
    </tr>
    <tr>
    	<td align="right">

		</td>
    </tr>
    <tr>
        <td class=line>
            
        <table border="0" cellspacing="1" width=800>
          <tr> 
            <td class=title>���ʵ����</td>
            <td align="center"><%=init_reg_dt%> 
              <input type="hidden" name="init_reg_dt" value="<%=init_reg_dt%>" size="110" class=text onBlur="javascript:CheckDate()">
            </td>
            <td class=title width=120>����</td>
            <td align="center" colspan="3"> 
              <select name="car_ext">
                <option value="1">����</option>
                <option value="2">����</option>
                <option value="6">��õ</option>		
		<option value="7">��õ</option>		
                <option value="3">�λ�</option>
                <option value="4">����</option>
                <option value="5">����</option>
                <option value="9">����</option>
                <option value="8">����</option>
              </select>
              <script>
                    	document.CarRegForm.car_ext.value = '<%=car_ext%>';
                    	</script>
            </td>
          </tr>
          <tr> 
            <td class=title width=120>�ڵ���������ȣ</td>
            <td align="center" width=250><%=car_no%> 
              <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
              <input type="hidden" name="car_no" value="<%=car_no%>" size="39" class=text>
            </td>
            <td class=title width=120>����</td>
            <td align="center" width=125> 
              <select name="car_kd">
                <option value="">����</option>
                <option value="1">�����¿�</option>
                <option value="2">�����¿�</option>
                <option value="3">�����¿�</option>
                <option value="9">�����¿�</option>
                <option value="4">��������</option>
                <option value="5">��������</option>
                <option value="8">����ȭ��</option>
                <option value="7">����ȭ��</option>
                <option value="6">����ȭ��</option>
              </select>
              <script>
                    	document.CarRegForm.car_kd.value = '<%=car_kd%>';
                    	</script>
            </td>
            <td class=title width=50>�뵵</td>
            <td align="center" width=125> 
              <select name="car_use">
                <option value="">����</option>
                <option value="1">������</option>
                <option value="2">�ڰ���</option>
              </select>
              <script>
                    	document.CarRegForm.car_use.value = '<%=car_use%>';
                    	</script>
            </td>
          </tr>
          <tr> 
            <td class=title>����</td>
            <td align="center"><%=car_nm%> 
              <input type="hidden" name="car_nm" value="<%=car_nm%>" size="39" class=text>
            </td>
            <td class=title>���� �� ����</td>
            <td align="center" colspan=3><%=car_form%> 
              <input type="hidden" name="car_form" value="<%=car_form%>" size="20" class=text>
              / <%=car_y_form%> 
              <input type="hidden" name="car_y_form" value="<%=car_y_form%>" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>�����ȣ</td>
            <td align="center"><%=car_num%> 
              <input type="hidden" name="car_num" value="<%=car_num%>" size="39" class=text>
            </td>
            <td class=title>����������</td>
            <td align="center" colspan=3><%=mot_form%> 
              <input type="hidden" name="mot_form" value="<%=mot_form%>" size="49" class=text>
            </td>
          </tr>
        </table>
        </td>
    </tr>
   <tr>
    	<td>< ��� ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=70>��ⷮ</td>
                    <td align="center" width=70><%=dpm%><input type="hidden" name="dpm" value="<%=dpm%>" size="10" class=text></td>
                    <td class=title width=70>��������</td>
                    <td align="center" width=70><%=taking_p%><input type="hidden" name="taking_p" value="<%=taking_p%>" size="10" class=text></td>
                    <td class=title width=70>Ÿ�̾�</td>
                    <td align="center" width=70><%=tire%><input type="hidden" name="tire" value="<%=tire%>" size="10" class=text></td>
                    <td class=title width=80>����������</td>
                    <td align="center" width=300><%=fuel_kd%><input type="hidden" name="fuel_kd" value="<%=fuel_kd%>" size="10" class=text> ( ���� : <%=conti_rat%><input type="hidden" name="conti_rat" value="<%=conti_rat%>" size="6" class=text> km/L )</td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< ����ǵ�� ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=150>����(���� �Ǵ� ����)</td>
                    <td align="center" width=250><%=mort_st%><input type="hidden" name="mort_st" value="<%=mort_st%>" size="39" class=text></td>
                    <td class=title width=150>����</td>
                    <td align="center" width=250><%=mort_dt%><input type="hidden" name="mort_dt" value="<%=mort_dt%>" size="39" class=text onBlur="javascript:ChangeMortDT()"></td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< �˻���ȿ�Ⱓ ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title>�Ⱓ</td>
                    <td><%=maint_st_dt%><input type="hidden" name="maint_st_dt" value="<%=maint_st_dt%>" size="15" class=text> ~ <%=maint_end_dt%><input type="hidden" name="maint_end_dt" value="<%=maint_end_dt%>" size="15" class=text></td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< ��� >&nbsp;&nbsp;
    	<% if (!m1_dt.equals("") ){ %>���� ��Ź�˻� �Ƿ���:<%=m1_dt%><%}%> 
    	</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=150>���ɸ�����</td>
                    <td align="center" width=250><%=car_end_dt%><input type="hidden" name="car_end_dt" value="<%=car_end_dt%>" size="39" class=text></td>
                    <td class=title width=150>������ȿ�Ⱓ</td>
                    <td align="center" width=250><%=test_st_dt%><input type="hidden" name="test_st_dt" value="<%=test_st_dt%>" size="16" class=text> ~ <%=test_end_dt%><input type="hidden" name="test_end_dt" value="<%=test_end_dt%>" size="16" class=text></td>
                </tr>
                <tr>
                    <td class=title>��������ȣ</td>
                    <td align="center" colspan=3><%=cha_no1%><input type="hidden" name="cha_no1" value="<%=cha_no1%>" size="39" class=text> <%=cha_no2%><input type="hidden" name="cha_no2" value="<%=cha_no2%>" size="16" class=text></td>
                </tr>
           </table>
        </td>
    <tr>
    	<td>< ��ϼ�����(�ݾ�) ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width="90" class=title>��ä(ä��)����</td>
                    <td width="150" align="center">
                    	<select name="loan_st">
                    		<option value="">����</option>
                    		<option value="1">����ö��ä(ä��)</option>
                    		<option value="2">�������߰�ä(ä��)</option>
                    	</select>
                    	<script>
                    	document.CarRegForm.loan_st.value = '<%=loan_st%>';
                    	</script>
                    </td>
                    <td width="90" class=title>��ä���Խ�</td>
                    <td width="100" align="center"><%=loan_b_amt%><input type="hidden" name="loan_b_amt" value="<%=loan_b_amt%>" size="10" class=text></td>
                    <td width="90" class=title>��ä���ν�</td>
                    <td width="100" align="center"><%=loan_s_amt%><input type="hidden" name="loan_s_amt" value="<%=loan_s_amt%>" size="10" class=text></td>
                	<td width="90" class=title>��ä������</td>
                    <td width="90" align="center"><%=loan_s_rat%><input type="hidden" name="loan_s_rat" value="<%=loan_s_rat%>" size="10" class=text></td>

                </tr>
                <tr>
                    <td class=title>��ϼ�</td>
                    <td align="center"><%=reg_amt%><input type="hidden" name="reg_amt" value="<%=reg_amt%>" size="10" class=text></td>
                    <td class=title>��漼</td>
                    <td align="center"><%=acq_amt%><input type="hidden" name="acq_amt" value="<%=acq_amt%>" size="10" class=text></td>
                	<td class=title>��ȣ���ۺ�</td>
                    <td align="center"><%=no_m_amt%><input type="hidden" name="no_m_amt" value="<%=no_m_amt%>" size="10" class=text></td>
					<td class=title>��,������</td>
                    <td align="center"><%=stamp_amt%><input type="hidden" name="stamp_amt" value="<%=stamp_amt%>" size="10" class=text></td>
                    
                </tr>
                <tr>
                    <td class=title>��Ÿ</td>
                    <td align="left" colspan=9><%=etc%><input type="hidden" name="etc" value="<%=etc%>" size="10" class=text></td>
                </tr>
           </table>
        </td>
    </tr>
</table>
<%
	}else{
%>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td ><font color="navy">�������� -> �ڵ������� -> </font><font color="red">�̵��</font></td>
    </tr>
    <tr>
    	<td align="right">
<%
	if(cmd.equals("ud"))
	{
%>
            <a href="javascript:CarRegUp()">����</a>&nbsp;
<%
	}else{
%>
			<a href="javascript:CarRegReg()">���</a>&nbsp;
<%}%>  
</td>
    </tr>
    <tr>
        <td class=line>
            
        <table border="0" cellspacing="1" width=800>
          <tr> 
            <td class=title>���ʵ����</td>
            <td align="center"> 
              <input type="text" name="init_reg_dt" value="<%=init_reg_dt%>" size="39" class=text onBlur="javascript:CheckDate()">
            </td>
            <td class=title width=120>����</td>
            <td align="center" colspan="3"> 
              <select name="car_ext">
                <option value="1">����</option>
                <option value="2">����</option>
                <option value="6">��õ</option>		
		<option value="7">��õ</option>		
                <option value="3">�λ�</option>
                <option value="4">�泲</option>
                <option value="5">����</option>
                <option value="9">����</option>
                <option value="8">����</option>
              </select>
              <script>
                    	document.CarRegForm.car_ext.value = '<%=car_ext%>';
                    	</script>
            </td>
          </tr>
          <tr> 
            <td class=title width=120>�ڵ���������ȣ</td>
            <td align="center" width=250> 
              <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
              <input type="text" name="car_no" value="<%=car_no%>" size="39" class=text>
            </td>
            <td class=title width=120>����</td>
            <td align="center" width=125> 
              <select name="car_kd" onChange="javascript:CheckDate()">
                <option value="">����</option>
                <option value="1">�����¿�</option>
                <option value="2">�����¿�</option>
                <option value="3">�����¿�</option>
                <option value="9">�����¿�</option>
                <option value="4">��������</option>
                <option value="5">��������</option>
                <option value="8">����ȭ��</option>
                <option value="7">����ȭ��</option>
                <option value="6">����ȭ��</option>                                
              </select>
              <script>
                    	document.CarRegForm.car_kd.value = '<%=car_kd%>';
                    	</script>
            </td>
            <td class=title width=50>�뵵</td>
            <td align="center" width=125> 
              <select name="car_use">
                <option value="">����</option>
                <option value="1">������</option>
                <option value="2">�ڰ���</option>
              </select>
              <script>
                    	document.CarRegForm.car_use.value = '<%=car_use%>';
                    	</script>
            </td>
          </tr>
          <tr> 
            <td class=title>����</td>
            <td align="center"> 
              <input type="text" name="car_nm" value="<%=car_nm%>" size="39" class=text>
            </td>
            <td class=title>���� �� ����</td>
            <td align="center" colspan=3> 
              <input type="text" name="car_form" value="<%=car_form%>" size="20" class=text>
              <input type="text" name="car_y_form" value="<%=car_y_form%>" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>�����ȣ</td>
            <td align="center"> 
              <input type="text" name="car_num" value="<%=car_num%>" size="39" class=text>
            </td>
            <td class=title>����������</td>
            <td align="center" colspan=3> 
              <input type="text" name="mot_form" value="<%=mot_form%>" size="49" class=text>
            </td>
          </tr>
        </table>
        </td>
    </tr>
   <tr>
    	<td>< ��� ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=80>��ⷮ</td>
                    <td align="center" width=80><input type="text" name="dpm" value="<%=dpm%>" size="10" class=text></td>
                    <td class=title width=80>��������</td>
                    <td align="center" width=80><input type="text" name="taking_p" value="<%=taking_p%>" size="10" class=text></td>
                    <td class=title width=80>Ÿ�̾�</td>
                    <td align="center" width=80><input type="text" name="tire" value="<%=tire%>" size="10" class=text></td>
                    <td class=title width=80>����������</td>
                    <td align="center" width=240><input type="text" name="fuel_kd" value="<%=fuel_kd%>" size="10" class=text> ( ���� <input type="text" name="conti_rat" value="<%=conti_rat%>" size="6" class=text> km/L )</td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< ����ǵ�� ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=150>����(���� �Ǵ� ����)</td>
                    <td align="center" width=250><input type="text" name="mort_st" value="<%=mort_st%>" size="39" class=text></td>
                    <td class=title width=150>����</td>
                    <td align="center" width=250><input type="text" name="mort_dt" value="<%=mort_dt%>" size="39" class=text onBlur="javascript:ChangeMortDT()"></td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< �˻���ȿ�Ⱓ ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title>�Ⱓ</td>
                    <td>&nbsp;<input type="text" name="maint_st_dt" value="<%=maint_st_dt%>" size="15" class=text> ~ <input type="text" name="maint_end_dt" value="<%=maint_end_dt%>" size="15" class=text></td>
                </tr>
          </table>
        </td>
    </tr>
    <tr>
    	<td>< ��� >&nbsp;&nbsp;
    	<% if (!m1_dt.equals("") ){ %>���� ��Ź�˻� �Ƿ���:<%=m1_dt%><%}%> 
    	</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title width=150>���ɸ�����</td>
                    <td align="center" width=250><input type="text" name="car_end_dt" value="<%=car_end_dt%>" size="39" class=text></td>
                    <td class=title width=150>������ȿ�Ⱓ</td>
                    <td align="center" width=250><input type="text" name="test_st_dt" value="<%=test_st_dt%>" size="16" class=text> ~ <input type="text" name="test_end_dt" value="<%=test_end_dt%>" size="16" class=text></td>
                </tr>
                <tr>
                    <td class=title>��������ȣ</td>
                    <td align="center" colspan=3><input type="text" name="cha_no1" value="<%=cha_no1%>" size="39" class=text> <input type="text" name="cha_no2" value="<%=cha_no2%>" size="16" class=text></td>
                </tr>
           </table>
        </td>
    <tr>
    	<td>< ��ϼ�����(�ݾ�) ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width="100" class=title>��ä(ä��)����</td>
                    <td width="100" align="center">
                    	<select name="loan_st">
                    		<option value="">����</option>
                    		<option value="1">����ö��ä(ä��)</option>
                    		<option value="2">�������߰�ä(ä��)</option>
                    	</select>
                    	<script>
                    	document.CarRegForm.loan_st.value = '<%=loan_st%>';
                    	</script>
                    </td>
                    <td width="100" class=title>��ä���Խ�</td>
                    <td width="100" align="center"><input type="text" name="loan_b_amt" value="<%=loan_b_amt%>" size="10" class=text></td>
                    <td width="100" class=title>��ä���ν�</td>
                    <td width="100" align="center"><input type="text" name="loan_s_amt" value="<%=loan_s_amt%>" size="10" class=text></td>
                	<td width="100" class=title>��ä������</td>
                    <td width="100" align="center"><input type="text" name="loan_s_rat" value="<%=loan_s_rat%>" size="10" class=text></td>

                </tr>
                <tr>
                    <td class=title>��ϼ�</td>
                    <td align="center"><input type="text" name="reg_amt" value="<%=reg_amt%>" size="10" class=text></td>
                    <td class=title>��漼</td>
                    <td align="center"><input type="text" name="acq_amt" value="<%=acq_amt%>" size="10" class=text></td>
                	<td class=title>��ȣ���ۺ�</td>
                    <td align="center"><input type="text" name="no_m_amt" value="<%=no_m_amt%>" size="10" class=text></td>
					<td class=title>��,������</td>
                    <td align="center"><input type="text" name="stamp_amt" value="<%=stamp_amt%>" size="10" class=text></td>
                    
                </tr>
                <tr>
                    <td class=title>��Ÿ</td>
                    <td align="left" colspan=9><input type="text" name="etc" value="<%=etc%>" size="10" class=text></td>
                </tr>
           </table>
        </td>
    </tr>
</table>

<%
	}
%>	

<input type="hidden" name="acq_std" value="<%=acq_std%>">
<input type="hidden" name="acq_acq" value="<%=acq_acq%>">
<input type="hidden" name="acq_f_dt" value="<%=acq_f_dt%>">
<input type="hidden" name="acq_ex_dt" value="<%=acq_ex_dt%>">
<input type="hidden" name="acq_re" value="<%=acq_re%>">
<input type="hidden" name="acq_is_p" value="<%=acq_is_p%>">
<input type="hidden" name="acq_is_o" value="<%=acq_is_o%>">

<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rpt_no" value="<%=rpt_no%>">
<input type="hidden" name="firm_nm" value="<%=firm_nm%>">
<input type="hidden" name="client_nm" value="<%=client_nm%>">
<input type="hidden" name="imm_amt" value="<%=imm_amt%>">
<input type="hidden" name="car_name" value="<%=car_name%>">
<input type="hidden" name="reg_dt" value="<%=reg_dt%>">
<input type="hidden" name="reg_nm" value="<%=reg_nm%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
<a href="javascript:FootWin('SER')">������������ ���</a>&nbsp;|
<a href="javascript:FootWin('CHA')">����/��ġ�������</a>&nbsp;|
<a href="javascript:OpenIns()">������</a>&nbsp;|
<a href="javascript:FootWin('ACQ')">��漼</a>
</body>
</html>