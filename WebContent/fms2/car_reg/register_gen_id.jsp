<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");

	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String rent_mng_id = "";
	String rent_l_cd = "";
	String car_mng_id = ""; 					//�ڵ���������ȣ
	int seq_no = 0;				//SEQ_NO
	String cha_item = "";				//��������
	String cha_st_dt = "";			//����������ȿ�Ⱓ1
	String cha_end_dt = "";			//����������ȿ�Ⱓ2
	String cha_nm = "";				//
	String cha_st = "";				//
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("rent_mng_id") != null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") != null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("seq_no") != null) seq_no = Util.parseInt(request.getParameter("seq_no"));
	if(request.getParameter("cha_item") != null) cha_item = request.getParameter("cha_item");
	if(request.getParameter("cha_st_dt") != null) cha_st_dt = request.getParameter("cha_st_dt");
	if(request.getParameter("cha_end_dt") != null) cha_end_dt = request.getParameter("cha_end_dt");
	if(request.getParameter("cha_nm") != null) cha_nm = request.getParameter("cha_nm");
	if(request.getParameter("cha_st") != null) cha_st = request.getParameter("cha_st");
	
	/*
	if(cmd.equals("i")||cmd.equals("u"))
	{
		cc_bean.setCar_mng_id(car_mng_id);
		cc_bean.setSeq_no(seq_no);					//SEQ_NO
		cc_bean.setCha_item(cha_item);				//��������
		cc_bean.setCha_st_dt(cha_st_dt);			//����������ȿ�Ⱓ1
		cc_bean.setCha_end_dt(cha_end_dt);			//����������ȿ�Ⱓ2
		cc_bean.setCha_nm(cha_nm);					//����������������
		cc_bean.setCha_st(cha_st);					//����
		
		if(cmd.equals("i"))
		{
			count = crd.insertCarCha(cc_bean);
		}else if(cmd.equals("u")){
			count = crd.updateCarCha(cc_bean);
		}
	}
	*/
	
	Vector exps = ex_db.getExpList(br_id, "3", "", "", "99", car_mng_id, "0", "0");
	int exp_size = exps.size();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function CarChaReg()
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	if(theForm.car_mng_id == "")
	{
		alert('���ȭ���� ����� ����Ͻʽÿ�');
		return;
	}
	if(theForm.seq_no.value!="")
	{
		alert("�������� �����մϴ�.");
		return;
	}
	if(theForm.cha_st.value=="")
	{
		alert("������ �����Ͻʽÿ�.");
		return;
	}

	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.submit();
}
function CarChaUp()
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	if(theForm.car_mng_id == "")
	{
		alert('���ȭ���� ����� ����Ͻʽÿ�');
		return;
	}
	if(theForm.seq_no.value=="")
	{
		alert("��ϸ��� �����մϴ�.");
		return;
	}
	if(!confirm('�����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	theForm.cmd.value = "u";
	theForm.submit();
}
function ChangeDT( arg )
{
	var theForm = document.CarChaForm;
	if(arg=="st_dt")
	{
		theForm.cha_st_dt.value = ChangeDate(theForm.cha_st_dt.value);
	}else if(arg=="end_dt"){
		theForm.cha_end_dt.value = ChangeDate(theForm.cha_end_dt.value);
	}
}
function ChaUp(seq_no,cha_item,cha_st_dt,cha_end_dt,cha_nm,cha_st)
{
	var theForm = document.CarChaForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	theForm.seq_no.value = seq_no;
	theForm.cha_item.value = cha_item;
	theForm.cha_st_dt.value = cha_st_dt;
	theForm.cha_end_dt.value = cha_end_dt;
	theForm.cha_nm.value = cha_nm;
	if(cha_st == '1') theForm.cha_nm[1].selected = true;
	if(cha_st == '2') theForm.cha_nm[2].selected = true;
	if(cha_st == '3') theForm.cha_nm[3].selected = true;		
}
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="/fms2/car_reg/register_gen_id.jsp" name="CarChaForm" method="POST" >
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>   
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
               	<tr>
                    <td class=title width=10%>����</td>
                    <td class=title width=34%>�����Ⱓ</td>	
                    <td class=title width=20%>�ݾ�</td>					
                    <td class=title width=18%>���⿹������</td>
                    <td class=title width=18%>��������</td>
                </tr>

 <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);%>
				
            	<tr>
                	<td align="center"><%=i+1%></td>
                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(exp.get("START_DT")))%> &nbsp;~&nbsp; <%=AddUtil.ChangeDate2(String.valueOf(exp.get("END_DT")))%></td>
                	<td align="right"><%=Util.parseDecimal(String.valueOf(exp.get("AMT")))%>��&nbsp;&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(exp.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(exp.get("PAY_DT")))%></td>

                </tr>
<%}%>
<% if(exp_size == 0) { %>
            <tr>
                <td colspan=5 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
            </tr>
<%}%>

           </table>
        </td>
    </tr>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="seq_no" value="">
</form>
</table>

<script language="JavaScript">
<!--
<%
	if(cmd.equals("u"))
	{
		if(count==1)
		{
%>

alert("���������� �����Ǿ����ϴ�.");
<%
		}
	}else{
		if(count==1)
		{
%>
alert("���������� ��ϵǾ����ϴ�.");
<%
		}
	}
%>
//-->
</script> 
</body>
</html>