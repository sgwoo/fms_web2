<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_pre_sc_in_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String eco_yn 		= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");
	String car_nm2 		= request.getParameter("car_nm2")		==null?"":request.getParameter("car_nm2");
	String car_nm3 		= request.getParameter("car_nm3")		==null?"":request.getParameter("car_nm3");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt = cop_db.getCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,
			 												e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, "", eco_yn, car_nm2, car_nm3);	//22
	int vt_size = vt.size();
			 												
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<% int col_cnt = 32;%>
<table border="0" cellspacing="0" cellpadding="0" width='<%=col_cnt*150%>'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(��)�Ƹ���ī ������� ����Ʈ (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='<%=col_cnt*150%>'>
        <tr> 
            <td width='150' align='center' style="font-size : 8pt;">�������</td>
            <td width='150' align='center' style="font-size : 8pt;">�����ȣ</td>
            <td width='150' align='center' style="font-size : 8pt;">��û�Ͻ�</td>
            <td width='150' align='center' style="font-size : 8pt;">��������</td>
            <td width='150' align='center' style="font-size : 8pt;">����</td>
            <td width="150" align='center' style="font-size : 8pt;">���</td>
            <td width="150" align='center' style="font-size : 8pt;">�������</td>
            <td width="150" align='center' style="font-size : 8pt;">�������</td>
            <td width="150" align='center' style="font-size : 8pt;">���Ͻ�����</td>
            <td width="150" align='center' style="font-size : 8pt;">����÷��ѿ���</td>
            <td width='150' align='center' style="font-size : 8pt;">�Һ��ڰ�</td>
            <td width="150" align='center' style="font-size : 8pt;">�������</td>
            <td width='150' align='center' style="font-size : 8pt;">������</td>
            <td width='150' align='center' style="font-size : 8pt;">���౸��</td>
            <td width='150' align='center' style="font-size : 8pt;">������</td>
            <td width='150' align='center' style="font-size : 8pt;">����ȣ</td>
            <td width='150' align='center' style="font-size : 8pt;">���ּ�</td>
			<td width='150' align='center' style="font-size : 8pt;">����ó</td>
            <td width='150' align='center' style="font-size : 8pt;">�޸�</td>
            <td width='150' align='center' style="font-size : 8pt;">����ȣ</td>
            <td width='150' align='center' style="font-size : 8pt;">�����</td>
            <td width='150' align='center' style="font-size : 8pt;">�������������</td>
            <td width='150' align='center' style="font-size : 8pt;">����</td>
            <td width='150' align='center' style="font-size : 8pt;">����������</td>
            <td width='150' align='center' style="font-size : 8pt;">������Ʈ����</td>
            <td width='150' align='center' style="font-size : 8pt;">��ü��������</td>
            <td width='150' align='center' style="font-size : 8pt;">�������޹��</td>
            <td width='150' align='center' style="font-size : 8pt;">ī��/������</td>
            <td width='150' align='center' style="font-size : 8pt;">��������</td>
            <td width='150' align='center' style="font-size : 8pt;">ī��/���¹�ȣ</td>
            <td width='150' align='center' style="font-size : 8pt;">����/������</td>
            <td width='150' align='center' style="font-size : 8pt;">�������⿹����</td>
        </tr>
        <%	for(int i = 0 ; i < vt_size ; i++){
   					Hashtable ht = (Hashtable)vt.elementAt(i);
   					
   					String engine = "";
   					if (ht.get("ECO_YN").equals("0")) {
   						engine = "���ָ�����";
   					} else if (ht.get("ECO_YN").equals("1")) {
   						engine = "��������";	
   					} else if (ht.get("ECO_YN").equals("2")) {
   						engine = "LPG����";	
   					} else if (ht.get("ECO_YN").equals("3")) {
   						engine = "���̺긮��";	
   					} else if (ht.get("ECO_YN").equals("4")) {
   						engine = "�÷����� ���̺긮��";	
   					} else if (ht.get("ECO_YN").equals("5")) {
   						engine = "������";	
   					} else if (ht.get("ECO_YN").equals("6")) {
   						engine = "������";	
   					}
    	%>
        <tr> 
            <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_OFF_NM")%></td>
            <td align='center' style="font-size : 8pt;"><%=ht.get("COM_CON_NO")%></td>
            <td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
       		<td align='center' style="font-size : 8pt;"><%=engine%></td>
       		<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("OPT")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("COLO")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("IN_COL")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("GARNISH_COL")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("BLUE_COL")%></td>
            <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_AMT")%></td>
            <td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></td>
            <td align='center' style="font-size : 8pt;"><%=ht.get("BUS_NM")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("STATUS")%></td>
        	<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_REG_DT")))%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("FIRM_NM")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("ADDR")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CUST_TEL")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("MEMO")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("RENT_L_CD")%></td>
        	<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
        	<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CON_AMT")%></td>
        	<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_PAY_DT")))%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("AGENT_VIEW_YN")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("BUS_SELF_YN")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("TRF_ST0")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CON_BANK")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("ACC_ST0")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CON_ACC_NO")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CON_ACC_NM")%></td>
        	<td align='center' style="font-size : 8pt;"><%=ht.get("CON_EST_DT")%></td>
        </tr>
		    <%	}%>
</table>
<script language='javascript'>
<!--
	
//-->
</script>
</body>
</html>

