<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");	//�߼۴��
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	//�߼۹��(����,����)
	//String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	//�з�����
	String cc_id = request.getParameter("cc_id")==null?"":request.getParameter("cc_id");	//�ڵ���ȸ��
	String[] sido = request.getParameterValues("sido");		//����(������,��)
	String[] gugun = request.getParameterValues("gugun");		//����(���ʱ�,��)
	String[] send_gubun = request.getParameterValues("send_gubun");		//�߼۱���	
	String commi_yn = request.getParameter("commi_yn")==null?"":request.getParameter("commi_yn");	//�ŷ�����

	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");	
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
	String user_id = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");	
	String cng_rsn 		= request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector empList = null;
	if(gubun1.equals("1") && gubun2.equals("1")){
		empList = umd.checkEmpNum(cc_id, sido, gugun, send_gubun, commi_yn, user_id);
	}else if(gubun1.equals("1") && gubun2.equals("2")){
		empList = umd.checkEmpNum_20090702(gubun, gu_nm, sort_gubun, sort, commi_yn, cng_rsn, st_dt, end_dt);
	}
	
	
	//��ܼ� �հ�
	int sum = 0;

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
//�ش� ������� �޴�����ȣ �����ϱ�.
function update(idx, id){
	if(!confirm("�ش� ������� �����͸� �����Ͻðڽ��ϱ�?"))	return;
	fm = document.form2;
	fm.gubun.value = "u";
	fm.emp_id.value = id;
alert(form1.destphone[idx].value);	
	fm.emp_m_tel.value = form1.destphone[idx].value;
	fm.target = "i_no";
	fm.submit();
}
//�ش� ������� �ҽ�(DB) �����ϱ�.
function del_source(id){
	if(!confirm("�ش� ������� �����͸� DB���� �����Ͻðڽ��ϱ�?"))		return;
	fm = document.form2;
	fm.gubun.value = "ds";
	fm.emp_id.value = id;
	fm.target = "i_no";
	fm.submit();
}
//�ش� ������� ���Űź� �ϱ�=����Ʈ���� �����ϱ�
function del_list(id){
	if(!confirm("�ش� ������� �����͸� �߼۸�� ����Ʈ���� �����Ͻðڽ��ϱ�?"))		return;
	fm = document.form2;
	fm.gubun.value = "dl";
	fm.emp_id.value = id;
	fm.target = "i_no";
	fm.submit();
}

</script>
</head>

<body>
<form name="form2" method="post" action="car_off_emp_ud.jsp">
<input name="gubun" type="hidden" value="">
<input name="emp_id" type="hidden" value="">
<input name="emp_m_tel" type="hidden" value="">
</form>

<form name="form1" action="./send_list.jsp" method="post">
<input name="sendname" type="hidden" value="">
<input name="sendphone" type="hidden" value="">
<input name="msg" type="hidden" value="">
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#666666"><font color="#0066FF">����</font>�� 
        �ڵ�����ȣ�� �����Ͽ� �ߺ��� �����մϴ�.</font></td>
  </tr>
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#0066FF">����</font><font color="#666666">�� 
        �ش� ��������� �����ͺ��̽����� ������ ������ �մϴ�.</font></td>
  </tr>  
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#0066FF">����</font><font color="#666666">�� 
        �ش� ��������� �˻�����Ʈ���� ���� �մϴ�. �����ͺ��̽����� �����ְ� �˴ϴ�.</font></td>
  </tr>  
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr><td class=line2></td></tr>
	  <tr>
		<td width="30" class="title">����</td>
		<td width="70" class="title">�Ҽӻ�</td>
		<td width="100" class="title">�ٹ�����</td>
		<td width="80" class="title">�ٹ�ó</td>
		<td width="90" class="title">����</td>
		<td width="100" class="title">�޴�����ȣ</td>
		<td width="55" class="title">�ŷ�����</td>
		<td width="166" class="title">&nbsp;</td>
	  </tr>
	
<%
	if(empList.size()>0){
		for(int i=0; i<empList.size(); i++){
			Hashtable ht = (Hashtable)empList.elementAt(i);
			String car_off_nm = (String)ht.get("CAR_OFF_NM");
			sum = i+1;
%>
		<tr>
			<td width="30"  align="center"><%=i+1%></td>
			<td width="70"  align="center"><%= AddUtil.replace((String)ht.get("CAR_COMP_NM"),"�ڵ���","") %></td>
			<td width="100" align="center"><span title="<%= ht.get("CAR_OFF_POST") %>"><%= ht.get("ADDR") %></span></td>
			<td width="80"  align="center"><span title="<%= car_off_nm %>"><%if(car_off_nm.indexOf("������")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"������","(��)"),5));
											}else if(car_off_nm.indexOf("�븮��")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"�븮��","(��)"),5));
											}else{
												out.print(AddUtil.subData(car_off_nm,5));
											}%></span></td>
			<td width="90"  align="center"><input name="destname" type="text" class="white" size="8" readonly="true" value="<%= ht.get("EMP_NM") %>"></td>
			<td width="100"  align="center"><input name="destphone" type="text" class="text" size="14"  value="<%= ht.get("EMP_M_TEL") %>"></td>
			<td width="55"  align="center"><% if(AddUtil.parseInt((String)ht.get("COMMI_CNT"))>0) out.print("Y"); else out.print("N"); %></td>
			<td width="166"  align="center"><a href="javascript:update('<%= i %>','<%= ht.get("EMP_ID") %>');"><img src="/acar/images/center/button_in_modify.gif"  border="0" align="absbottom"></a> | 
			<a href="javascript:del_source('<%= ht.get("EMP_ID") %>');"  title="��������" ><img src="/acar/images/center/button_in_delete.gif"  border="0" align="absbottom"></a> | 
			<a href="javascript:del_list('<%= ht.get("EMP_ID") %>');" title="����Ʈ��������"><img src="/acar/images/center/button_in_remove.gif"  border="0" align="absbottom"></a> </td>
		</tr>		
<% 		}
	}else{ %>
      <tr>
        <td colspan="8"><div align="center">��ȣ ���� ����ڰ� �����ϴ�. </div></td>
        </tr>
<% 	} %>
      <tr>
        <td colspan="8" class="title">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

