<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.car_shed.CarShedDatabase"/>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String brch 		= request.getParameter("brch")		==null?"":request.getParameter("brch");
	String shed_st 	= request.getParameter("shed_st")	==null?"":request.getParameter("shed_st");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	
	Vector sheds = cs_db.getCarShedList(brch, shed_st, gubun1);
	int shed_size = sheds.size();
%>
<body>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=3% class=title align=center>����</td>
            		<td width=30% class=title>��Ī</td>
            		<td width=10% class=title>����������</td>
            		<td width=10% class=title>���������</td>
            		<td width=10% class=title>�Ѹ���</td>
            		<td width=10% class=title>�������</td>
            		<td width=10% class=title>������</td>
            		<td width=17% class=title>�Ӵ���Ⱓ</td>

            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 width='100%'>
<%
	if(shed_size > 0){
		float tot_lend_tot_ar = 0;			//�Ѹ��� �հ�		(20190717)
		float tot_lend_cap_ar = 0;		//������� �հ�
		float tot_lend_cap_car = 0;		//������ �հ�
		
		for(int i = 0 ; i < shed_size ; i++){
			Hashtable shed = (Hashtable)sheds.elementAt(i);
			
			//�λ�-���������(����������)�� ����Ʈ���� ���� (���� 1�ǻ��̶� �̷��Ը� ó��. 20190718)
			if(String.valueOf(shed.get("SHED_ID")).equals("0023")){		continue;		}
			
			if(!String.valueOf(shed.get("LEA_ST")).equals("0")){
			
			tot_lend_tot_ar 	+= AddUtil.parseFloat(String.valueOf(shed.get("LEND_TOT_AR")).replaceAll(",",""));	
			tot_lend_cap_ar	+= AddUtil.parseFloat(String.valueOf(shed.get("LEND_CAP_AR")).replaceAll(",",""));			
			tot_lend_cap_car	+= AddUtil.parseFloat(String.valueOf(shed.get("LEND_CAP_CAR")).replaceAll(",",""));	
%>
				<tr>
					<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=3% align="center"><%= i+1%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=30% align='center'><a href="javascript:parent.view_shed('<%=shed.get("SHED_ID")%>','<%=shed.get("SHED_ST")%>')" onMouseOver="window.status=''; return true"><%=shed.get("SHED_NM")%></a></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=10% align='center'><%=shed.get("BR_NM")%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=10% align='center'><%=shed.get("MNG_AGNT")%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=10% align='center'><%=shed.get("LEND_TOT_AR")%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=10% align='center'><%=shed.get("LEND_CAP_AR")%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=10% align='center'><%=shed.get("LEND_CAP_CAR")%></td>
            		<td <%if(String.valueOf(shed.get("USE_YN")).equals("����")){%>class='is'<%}%> width=17% align='center'><%=shed.get("LEA_ST_DT")%>~<%=shed.get("LEA_END_DT")%></td>
				</tr>
<%		}}%>
				<tr>
					<td colspan="4" class="title">�հ�</td>
					<td class="title"><%=AddUtil.parseDecimal(tot_lend_tot_ar)%></td>
					<td class="title"><%=AddUtil.parseDecimal(tot_lend_cap_ar)%></td>
					<td class="title"><%=AddUtil.parseDecimal(tot_lend_cap_car)%></td>
					<td class="title"></td>
				</tr>
<%	}
	else
	{
%>
				<tr>
					<td colspan='7' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
<%
	}
%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>