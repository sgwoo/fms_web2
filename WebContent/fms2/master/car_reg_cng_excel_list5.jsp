<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=car_reg_cng_excel_list5.xls");
%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_ext 	= request.getParameter("car_ext5")==null?"":request.getParameter("car_ext5");
	int car_cnt 	= request.getParameter("car_cnt5")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt5"));
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_dt	 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String car_use	 	= request.getParameter("car_use5")	==null?"":request.getParameter("car_use5");
	String car_fuel 	= request.getParameter("car_fuel")	==null?"":request.getParameter("car_fuel");
		
	Vector vt = ad_db.getCarExtCngExcelList5(car_ext, car_use, st_dt, end_dt, s_dt, car_fuel);
	int vt_size = vt.size();
	
	if(car_cnt > 0 && vt_size > car_cnt) vt_size = car_cnt;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=800>
	<tr>
	  <td colspan="7" align="center"><%=c_db.getNameByIdCode("0032", "", car_ext)%> <%if(!car_ext.equals("")){%>지역번호<%}%> 차량 리스트 <%if(car_cnt>0){%>(<%=car_cnt%>대)<%}%></td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  	  	  	  
	  <td>&nbsp;</td>	  	  	  	  
	  <td>&nbsp;</td>	  	  	  	  
	</tr>			
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="100" class="title">관리번호</td>
	  <td width="150" class="title">차량번호</td>
	  <td width="200" class="title">차명</td>
	  <td width="100" class="title">최초등록일</td>			
	  <td width="100" class="title">차령만료일</td>			
	  <td width="100" class="title">대여만료예정일</td>				  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%=ht.get("CAR_DOC_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	  <td align="center"><%=ht.get("CAR_END_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>	  
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
