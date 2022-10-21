<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc_kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=promotion_excel_list.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"><!--������ export�� �ѱ۱��� ���� ����-->
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<BODY>

<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String basic_dt 	= request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");

	String acar_id = login.getCookieValue(request, "acar_id");
			
	if(basic_dt.equals("")){
		 basic_dt = AddUtil.getDate(1)+"0101";
	}
	

	//����� ���� ��ȸ
	Vector vt = ic_db.Insa_promotion(basic_dt);
	int vt_size = vt.size();
	
	
%>



<table border="0" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
	<tr> 
        <td class=></td>            
    </tr>
	<tr> 
        <td>��������Ȳ</td>
    </tr>
    <tr> 
        <td class=></td>            
    </tr>
	<tr> 
        <td class=></td>            
    </tr>
	<tr>
		<td class=line>
			<table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
				<tr>
					<td rowspan="3" colspan="1" class="title">����</td>
					<td rowspan="3" colspan="1" class="title">�μ���</td>
					<td rowspan="3" colspan="1" class="title">����</td>
					<td rowspan="3" colspan="1" class="title">����</td>
					<td rowspan="3" colspan="1" class="title">�Ի�����</td>
					<td rowspan="1" colspan="2" class="title">�����Ⱓ</td>
					<td rowspan="1" colspan="4" class="title">��������</td>
					<td rowspan="1" colspan="2" class="title">����(�ɻ�)�������</td>
				</tr>
				<tr>
					<td rowspan="2" colspan="1" class="title">��</td>
					<td rowspan="2" colspan="1" class="title">��</td>
					<td rowspan="2" colspan="1" class="title">����</td>
					<td rowspan="2" colspan="1" class="title">�߷�����</td>
					<td rowspan="1" colspan="2" class="title">�߷��� ����Ⱓ</td>
					<td rowspan="2" colspan="1" class="title">�ɻ�����</td>
					<td rowspan="2" colspan="1" class="title">�ɻ���</td>
				</tr>
				<tr>
					<td class="title">��</td>
					<td class="title">��</td>
				</tr>
<%// if(vt_size > 0)	{
	int count =0;
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			count++;
%> 						
				<tr>
					<td align="center"><%=count%></td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("USER_NM")%></td>
					<td align="center"><%=ht.get("AGE")%>�� <%=ht.get("AGE_MONTH")%>��</td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
					<td align="center"><%=ht.get("YEAR")%></td>
					<td align="center"><%=ht.get("MONTH")%></td>
					<td align="center"><%=ht.get("USER_POS")%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JG_DT")))%></td>
					<td align="center"><%=ht.get("J_YEAR")%></td>
					<td align="center"><%=ht.get("J_MONTH")%></td>
					<td align="center"><%=ht.get("NEXT_POS")%></td>
					<td align="center"></td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=></td>
    </tr>
	<tr>
		<td>�� �������ϱ����� : �ϱ� 20���� <br>�� �������� �ּҿ��ɱ����� �� 30�� �̻�</td>
	</tr>
</table>



</BODY>

</HTML>

