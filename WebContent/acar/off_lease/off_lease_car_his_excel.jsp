<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.offls_yb.*" %>
<jsp:useBean id="olyD" scope="page" class="acar.offls_yb.Offls_ybDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
	
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_off_lease_car_his_excel.xls");
%>
	
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	int count =0;

	Vector his = olyD.getCarHisList(car_mng_id);
	int his_size = his.size();
	
	//자산양수차량
	Hashtable ht_ac = shDb.getCarAcInfo(car_mng_id);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>
<table border="1" cellspacing="1" cellpadding="1" width=953>
  <tr bgcolor="#00FFFF" valign="middle">
    <td width=29 align=center height="26"><b><font face="바탕" size="2"></font></b></td>
    <td width=150 align=center height="26"><b><font face="바탕" size="2">상호</font></b></td>
    <td width=100 align=center height="26"><b><font face="바탕" size="2">계약자</font></b></td>
    <td width=300 align=center height="26"><b><font face="바탕" size="2">대여기간</font></b></td>
  </tr>
  <%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){
 			count++;
	%>
  <tr valign="middle"> 
    <td width=29 align=center bgcolor="#00FFFF" height="21"><b><font face="바탕" size="2"><%=count%></font></b></td>
    <td width=150 align=left height="21"><font face="바탕" size="2">&nbsp;<%=ht_ac.get("CAR_OFF_NM")%></font></td>
    <td width=100 align=center height="21"><font face="바탕" size="2">자산양수</font></td>
    <td width=300 align=center height="21"><font face="바탕" size="2"><%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_INIT_REG_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht_ac.get("SH_BASE_DT")))%></font></td>
  </tr>
  <%}%>  
  <%for(int i = 0 ; i < his_size ; i++){
			CarHisBean ch = (CarHisBean)his.elementAt(i);
			count++;
  %>
  <tr valign="middle"> 
    <td width=29 align=center bgcolor="#00FFFF" height="21"><b><font face="바탕" size="2"><%=count%></font></b></td>
    <td width=150 align=left height="21"><font face="바탕" size="2">&nbsp;<%=AddUtil.subData(ch.getFirm_nm(), 9)%></font></td>
    <td width=100 align=center height="21"><font face="바탕" size="2"><%=AddUtil.subData(ch.getClient_nm(), 4)%></font></td>
    <td width=300 align=center height="21"><font face="바탕" size="2"><%=AddUtil.ChangeDate2(ch.getRent_st_dt())%> ~ <%if(ch.getRent_ed_dt().equals("")){ out.println(AddUtil.getDate()); }else{ out.println(AddUtil.ChangeDate2(ch.getRent_ed_dt())); }%></font></td>
  </tr>
  <%}%>
</table>
</body>
</html>