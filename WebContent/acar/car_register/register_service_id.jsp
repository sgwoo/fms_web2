<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.car_register.*" %>
<jsp:useBean id="cm_bean" class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarRegDatabase crd = CarRegDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	String rent_mng_id = "";
	String rent_l_cd = "";
	String car_mng_id = ""; 		//�ڵ���������ȣ
	int seq_no = 0;					//SEQ_NO
	String che_kd = "";				//��������
	String che_st_dt = "";			//����������ȿ�Ⱓ1
	String che_end_dt = "";			//����������ȿ�Ⱓ2
	String che_dt = "";				//����������������
	String che_no = "";				//�ǽ��ڰ�����ȣ
	String che_comp = "";			//�ǽ��ھ�ü�� 
	int che_amt = 0;				//�ǽú��ݾ� �߰� 2004.01.07.
	int che_km = 0;					//����Ÿ�	2004.01.13.
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("rent_mng_id") != null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") != null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("seq_no") != null) seq_no = Util.parseInt(request.getParameter("seq_no"));
	if(request.getParameter("che_kd") != null) che_kd = request.getParameter("che_kd");
	if(request.getParameter("che_st_dt") != null) che_st_dt = request.getParameter("che_st_dt");
	if(request.getParameter("che_end_dt") != null) che_end_dt = request.getParameter("che_end_dt");
	if(request.getParameter("che_dt") != null) che_dt = request.getParameter("che_dt");
	if(request.getParameter("che_no") != null) che_no = request.getParameter("che_no");
	if(request.getParameter("che_comp") != null) che_comp = request.getParameter("che_comp");
	if(request.getParameter("che_amt") != null) che_amt = AddUtil.parseDigit(request.getParameter("che_amt"));
	if(request.getParameter("che_km") != null) che_km = AddUtil.parseDigit(request.getParameter("che_km"));	
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		cm_bean.setCar_mng_id(car_mng_id);
		cm_bean.setSeq_no(seq_no);				//SEQ_NO
		cm_bean.setChe_kd(che_kd);				//��������
		cm_bean.setChe_st_dt(che_st_dt);			//����������ȿ�Ⱓ1
		cm_bean.setChe_end_dt(che_end_dt);			//����������ȿ�Ⱓ2
		cm_bean.setChe_dt(che_dt);				//����������������
		cm_bean.setChe_no(che_no);				//�ǽ��ڰ�����ȣ 
		cm_bean.setChe_comp(che_comp);				//�ǽ��ھ�ü�� 
		cm_bean.setChe_amt(che_amt);			//�˻�ݾ�
		cm_bean.setChe_km(che_km);				//�˻�� ����Ÿ�
		cm_bean.setChe_km(che_km);				//�˻�� ����Ÿ�
		cm_bean.setReg_id(user_id);				//���/����
		
		if(cmd.equals("i"))
		{
			count = crd.insertCarMaint(cm_bean);
		}else if(cmd.equals("u")){
			count = crd.updateCarMaint(cm_bean);
		}
	}
	
	CarMaintBean cm_r [] = crd.getCarMaintAll(car_mng_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
			//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function CarMaintReg()
{
	var theForm = document.CarMaintForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;

	if(theForm.car_mng_id.value == "")
	{
		alert('���ȭ���� ����� ����Ͻʽÿ�');
		return;
	}
	if(theForm.seq_no.value!="")
	{
		alert("�������� �����մϴ�.");
		return;
	}
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.submit();
}
function CarMaintUp()
{
	var theForm = document.CarMaintForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;

	if(theForm.car_mng_id.value == "")
	{
		alert('���ȭ���� ����� ����Ͻʽÿ�');
		return;
	}
	if(theForm.seq_no.value=="")
	{
		alert("�����ϰ��� �ϴ� ������ �����ϼ���.");
		return;
	}
	if(!CheckField())
	{
		return;
	}
	if(!confirm('�����Ͻðڽ��ϱ�?'))
	{
		return;
	}//else{
	//	theForm.new_che_st_dt.value = prompt("���ŵ� �������� �Է��� �ּ���!","");
	//	theForm.new_che_end_dt.value = prompt("���ŵ� �������� �Է��� �ּ���!","");		
	//}
	
	theForm.cmd.value = "u";
	theForm.submit();
}
function ChangeDT( arg )
{
	var theForm = document.CarMaintForm;
	if(arg=="st_dt")
	{
		theForm.che_st_dt.value = ChangeDate(theForm.che_st_dt.value);
	}else if(arg=="end_dt"){
		theForm.che_end_dt.value = ChangeDate(theForm.che_end_dt.value);
	}else if(arg=="dt"){
		theForm.che_dt.value = ChangeDate(theForm.che_dt.value);
	}
}
function CheckField()
{
	var theForm = document.CarMaintForm;
	

	if(theForm.che_kd.value=="")
	{
		alert('���������� �����Ͻʽÿ�.');
		theForm.che_kd.focus();
		return false;
	}
	
	if(theForm.che_st_dt.value=="")
	{
		alert('�������� ��ȿ�Ⱓ�� �Է��Ͻʽÿ�.');
		theForm.che_st_dt.focus();
		return false;
	}
	if(theForm.che_end_dt.value=="")
	{
		alert('�������� ��ȿ�Ⱓ�� �Է��Ͻʽÿ�.');
		theForm.che_end_dt.focus();
		return false;
	}
	return true;
}
function MaintUp(seq_no,che_kd,che_st_dt,che_end_dt,che_dt,che_no,che_comp,che_amt,che_km)
{
	var theForm = document.CarMaintForm;
	var theForm1 = parent.c_body.CarRegForm;
	theForm.car_mng_id.value = theForm1.car_mng_id.value;
	theForm.seq_no.value = seq_no;
	theForm.che_kd.value = che_kd;
	theForm.che_st_dt.value = che_st_dt;
	theForm.che_end_dt.value = che_end_dt;
	theForm.che_dt.value = che_dt;
	theForm.che_no.value = che_no;
	theForm.che_comp.value = che_comp;
	theForm.che_amt.value = parseDecimal(che_amt);
	theForm.che_km.value = parseDecimal(che_km);
}
//-->
</script>
</head>
<body>
<form action="register_service_id.jsp" name="CarMaintForm" method="POST" >

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����˻� ���</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100% cellpadding=0>
          <%
	if(cmd.equals("ud"))
	{
%>
                <tr> 
                    <td class=title rowspan=2>��������</td>
                    <td class=title colspan=3>�������� ��ȿ�Ⱓ</td>
                    <td class=title colspan=4>�˻系��</td>
                </tr>
                <tr> 
                    <td class=title>�����Ϻ���</td>
                    <td class=title>�����ϱ���</td>
                    <td class=title>��������</td>
                    <td class=title>�����</td>
                    <td class=title>�˻��</td>
                    <td class=title>���</td>
                    <td class=title>����Ÿ�(Km)</td>
                </tr>
          <%
    for(int i=0; i<cm_r.length; i++){
        cm_bean = cm_r[i];
%>
                <tr> 
                    <td align="center"><%if(cm_bean.getChe_kd().equals("1")){%>����˻�
        								<% }else if(cm_bean.getChe_kd().equals("2")){%>�������а˻�
        								<% }else if(cm_bean.getChe_kd().equals("3")){%>��������
        								<% } %></td>
                    <td align="center"><%=cm_bean.getChe_st_dt()%></td>
                    <td align="center"><%=cm_bean.getChe_end_dt()%></td>
                    <td align="center"><%=cm_bean.getChe_dt()%></td>
                    <td align="center"><%= c_db.getNameById(cm_bean.getChe_no(),"USER")%></td>
                    <td align="center"><%=cm_bean.getChe_comp()%></td>
                    <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_amt())%>&nbsp;&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_km())%>&nbsp;&nbsp;</td>
                </tr>
          <%}%>
          <% if(cm_r.length == 0) { %>
                <tr> 
                    <td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
          <%}%>
          <%
	}else{
%>
                <tr> 
                    <td class=title rowspan=2>��������</td>
                    <td class=title colspan=3>�������� ��ȿ�Ⱓ</td>
                    <td class=title colspan=4>�˻系��</td>
                    <td class=title rowspan=2></td>
                </tr>
                <tr> 
                    <td class=title>�����Ϻ���</td>
                    <td class=title>�����ϱ���</td>
                    <td class=title>��������</td>
                    <td class=title>�����</td>
                    <td class=title>�˻��</td>
                    <td class=title>���(��)</td>
                    <td class=title>����Ÿ�(Km)</td>
                </tr>
          <%
    for(int i=0; i<cm_r.length; i++){
        cm_bean = cm_r[i];
%>
                <tr> 
                    <td align="center"><a href="javascript:MaintUp('<%=cm_bean.getSeq_no()%>','<%=cm_bean.getChe_kd()%>','<%=cm_bean.getChe_st_dt()%>','<%=cm_bean.getChe_end_dt()%>','<%=cm_bean.getChe_dt()%>','<%=cm_bean.getChe_no()%>','<%=cm_bean.getChe_comp()%>','<%=cm_bean.getChe_amt()%>','<%=cm_bean.getChe_km()%>')">
        			<%if(cm_bean.getChe_kd().equals("1")){%>����˻�
        			<% }else if(cm_bean.getChe_kd().equals("2")){%>�������а˻�
        			<% }else if(cm_bean.getChe_kd().equals("3")){%>��������
        			<% } %></a></td>
                    <td align="center"><%=cm_bean.getChe_st_dt()%></td>
                    <td align="center"><%=cm_bean.getChe_end_dt()%></td>
                    <td align="center"><%=cm_bean.getChe_dt()%></td>
                    <td align="center"><%= c_db.getNameById(cm_bean.getChe_no(),"USER")%></td>
                    <td align="center"><%=cm_bean.getChe_comp()%></td>
                    <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_amt())%>&nbsp;&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_km())%>&nbsp;&nbsp;</td>
                    <td align="center">&nbsp;</td>
                </tr>
          <%}%>
                <tr> 
                    <td width=10% align="center"><select name="che_kd">
        				<option value="">����</option>
                        <option value="1">����˻�</option>			
                        <option value="2">�������а˻�</option>
        				<option value="3">��������</option>
                      </select></td>
                    <td width=10% align="center"><input type="text" name="che_st_dt" value="" size="11" class=text onBlur="javascript:ChangeDT('st_dt')"></td>
                    <td width=10% align="center"><input type="text" name="che_end_dt" value="" size="11" class=text onBlur="javascript:ChangeDT('end_dt')"></td>
                    <td width=10% align="center"><input type="text" name="che_dt" value="" size="11" class=text onBlur="javascript:ChangeDT('dt')"></td>
                    <td width=12% align="center"><select name='che_no'>
                       <%if(user_size > 0){
        							for(int i = 0 ; i < user_size ; i++){
        								Hashtable user = (Hashtable)users.elementAt(i); 
        				%>
        		          				     <option value='<%=user.get("USER_ID")%>' <% if(che_no.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
        		                <%	}
        						}		%>
        					</select></td>
                    
                  
                    <td width=13% align="center"><input type="text" name="che_comp" value="" size="15" class=text></td>
                    <td width=10% align="center"><input type="text" name="che_amt" value="" size=10 class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                    <td width=10% align="center"><input type="text" name="che_km" value="" size=10 class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                    <td width=15% align="center"><!--
                    <a href="javascript:CarMaintReg()"><img src="/acar/images/center/button_in_plus.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;--> 
                    <!-- �˻�� �˻��Ͽ����� �߰��� - car_reg, car_maint�� ���� ����ؾ� �ϱ⿡ -->
        			<a href="javascript:CarMaintUp()"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a></td>
                </tr>
          <%
	}
%>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="new_che_st_dt" value="">
<input type="hidden" name="new_che_end_dt" value="">
</form>
	
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