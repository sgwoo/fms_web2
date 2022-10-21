<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_ins.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_con_ins_popup_excel.xls");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector inss = ai_db.getInsStatList();
	int ins_size = inss.size();
%>
<table border="1" cellspacing="0" cellpadding="1" width=950 bordercolor="#000000">
  <tr valign="middle" align="center"> 
    <td width='30' height="29">연번</td>
    <td width='90' height="29">계약번호</td>
    <td height="29" width="170">상호</td>
    <td width='80' height="29">고객</td>
    <td width='80' height="29">차량번호</td>
    <td width='120' height="29">차명</td>
    <td width='80' height="29">보험회사</td>
    <td width='50' height="29">구분</td>
    <td width='70' height="29">보험시작일</td>
    <td width='70' height="29">보험만료일</td>
    <td width='55' height="29">영업담당</td>
    <td width='55' height="29">관리담당</td>
  </tr>
  <%	if(ins_size > 0){
		for(int i = 0 ; i < ins_size ; i++){
			Hashtable ins = (Hashtable)inss.elementAt(i);%>
  <tr> 
    <td width='30' align='center'><%=i+1%></td>
    <td width='100' align='center'><%=ins.get("RENT_L_CD")%></td>
    <td align='center'><%=ins.get("FIRM_NM")%></td>
    <td align='center'><%=ins.get("CLIENT_NM")%></td>
    <td align='center'><%=ins.get("CAR_NO")%></td>
    <td align='center'><%=ins.get("CAR_NM")%></td>
    <td align='center'><%=ins.get("INS_COM_NM")%></td>
    <td align='center'><%=ins.get("INS_ST")%></td>
    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%></td>
    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
    <td align='center'>&nbsp;<%=c_db.getNameById(String.valueOf(ins.get("BUS_ID2")), "USER")%></td>
    <td align='center'>&nbsp;<%=c_db.getNameById(String.valueOf(ins.get("MNG_ID")), "USER")%></td>
  </tr>
  <%		}
	}%>
</table>
</body>
</html>
