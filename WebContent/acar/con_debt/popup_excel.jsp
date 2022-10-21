<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_con_debt_popup_excel.xls");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
//	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
//	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector debts = ad_db.getAllotPayList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<p>* �μ⸦ �ϽǷ��� ���� ��ܸ޴����� ����>������������ ���� -> ���������� �������� ���ο� üũ�ϰ� �μ��Ͻʽÿ�. </p>
<table border="1" cellspacing="0" cellpadding="1" width=950 bordercolor="#000000">
  <tr valign="middle" align="center"> 
    <td width='30'>����</td>
    <td width='100'>����ȣ</td>
    <td>��ȣ</td>
    <td width='90'>������ȣ</td>
    <td width='80'>������</td>
    <td width='40'>ȸ��</td>
    <td width='80'>��ȯ����</td>
    <td width='80'>��ȯ����(��)</td>
    <td width='80'>��ȯ����(��)</td>
    <td width='80'>���Һα�(��)</td>
    <td width='100'>�ܾ׿���(��)</td>
  </tr>
  <%	if(debt_size > 0){
		for(int i = 0 ; i < debt_size ; i++){
			Hashtable allot = (Hashtable)debts.elementAt(i);%>
  <tr> 
    <td width='30' align='center'><%=i+1%></td>
    <td width='100' align='center'><%=allot.get("RENT_L_CD")%></td>
    <td align='center'><%=allot.get("FIRM_NM")%></td>
    <td width='90' align='center'><%=allot.get("CAR_NO")%></td>
    <td width='80' align='center'><%=c_db.getNameById(String.valueOf(allot.get("CPT_CD")), "BANK")%></td>
    <td width='40' align='right'><%=allot.get("ALT_TM")%>ȸ</td>
    <td width='80' align='center'><%=allot.get("ALT_EST_DT")%></td>
    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(allot.get("ALT_PRN")))%></td>
    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(allot.get("ALT_INT")))%></td>
    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(allot.get("ALT_AMT")))%></td>
    <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(allot.get("ALT_REST")))%></td>
  </tr>
  <%		}
	}%>
</table>
</body>
</html>
