<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.commi_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"commi_excel_pl_1.xls");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<style type="text/css">
<!--
.style2 {font-size: 9px}
-->
</style>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	Vector commis = ac_db.getCommiListPl(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int commi_size = commis.size();
	
	int count = 0;
%>
<table border="0" cellspacing="0" cellpadding="0" width='830'>
	<tr>
		<td>
			<table border="1" cellspacing="1" cellpadding="0">
				<tr align="center" bgcolor="#FFFF00">
					<td width='30'>연번</td>
			        <td width='70'>영업사원</td>
			        <td width='100'>주민번호</td>
			        <td width='200'>주소</td>										
					<td width='80'>업종코드</td>
					<td width='80'>지급수수료</td>
					<td width='80'>소득세</td>										
					<td width='80'>주민세</td>										
					<td width='30'>세율</td>																									
					<td width='80'>지급일자</td>					
			    </tr>
                <%if(commi_size > 0){%>
                <%	for(int i = 0 ; i < commi_size ; i++){
						Hashtable commi = (Hashtable)commis.elementAt(i);
						if(String.valueOf(commi.get("TAX_RT")).equals("3.3")){		
							count++;
				%>
				<tr>
		  			<td  align='center' width='30'><%=count%></td>
          			<td align='center' width='70'><%=commi.get("EMP_NM")%></td>
          			<td align='center' width='100'><%=AddUtil.ChangeSsn(String.valueOf(commi.get("EMP_SSN")))%></td>
          			<td align='center' width='200'><%=commi.get("EMP_ADDR")%></td>		  		  
          			<td align='center' width='80'>940911</td>
          			<td align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></td>
          			<td align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></td>
          			<td align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></td>
          			<td align='center'  width='30'><%=commi.get("TAX_RT")%></td>
          			<td align='center'  width='80'><%=commi.get("SUP_DT")%></td>
				</tr>
				<%		}
					}%>
				<%}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>

