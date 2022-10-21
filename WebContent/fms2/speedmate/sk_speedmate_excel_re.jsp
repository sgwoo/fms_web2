<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.speedmate.*" %>
<jsp:useBean id="sm_db" scope="page" class="acar.speedmate.SpeedMateDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_sk_speedmate_excel_re.xls");
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = sm_db.SpeedMateExcelList_re2(s_kd, st_dt, end_dt);		// 연체 구분자 추가 		2018.03.23
	int vt_size = vt.size();
%>

<html>
<head>
	<title>FMS</title>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<style>
		.title{
			border-top: thin black solid;
			border-left: thin black solid;
			border-right: thin black solid;
			border-bottom: thin black solid;
		}
		.in_border{
			border-top: thin black solid;
			border-left: thin black solid;
			border-right: thin black solid;
			border-bottom: thin black solid;
		}
		.no_border{
			border: 0px solid white;
			font-size:12px;
		}
		.red_font{
			font-size: 30px;
			color: red;
		}
	</style>
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="14" align="center">(주)아마존카 차량 리스트 </td>
	</tr>		
	<tr>
	  <td colspan="14" align="right"><%if(s_kd.equals("1")){%><%=AddUtil.getDate()%> 기준<%}else{%>기간 : <%=st_dt%>~<%=end_dt%><%}%></td>
	</tr>			
	<tr>
	  <td class="title">연번</td> 
	  <td class="title">차량번호</td>	  
	  <td class="title">차종</td>	  	  
	  <td class="title">차명</td>
	  <td class="title">차정</td>
	  <td class="title">유종</td>
	  <td class="title">현주행거리</td>			
	  <td class="title">연식</td>				  
	  <td class="title">변속기</td>
	  <td class="title">SK_CODE</td>
	  <td class="title">담당자</td>
  	  <td class="title">연락처</td>
	  <td class="title">구분</td>
	  <td class="title">연체</td>
	  <td class="no_border"></td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<%if(ht.get("DLY_COUNT").equals("0") || ht.get("DLY_COUNT").equals("")){%>
	<tr>
	  <td class="in_border" align="center"><%=i+1%></td>
	  <td class="in_border" align="center"><%=ht.get("차량번호")%></td>	  
	  <td class="in_border" align="center"><%=ht.get("차종")%></td>	  	  
	  <td class="in_border" align="center"><%=ht.get("차명")%></td>
	  <td class="in_border" align="center"><%=ht.get("차정")%></td>
	  <td class="in_border" align="center"><%=ht.get("유종")%></td>
	  <td class="in_border" align="center"><%=ht.get("현주행거리")%></td>	  
	  <td class="in_border" align="center"><%=ht.get("연식")%></td>
	  <td class="in_border" align="center"><%=ht.get("변속기")%></td>
	  <td class="in_border" align="center" style='mso-number-format:\@;'><%=ht.get("SK_CODE")%></td>
	  <td class="in_border" align="center"><%=ht.get("담당자")%></td>
	  <td class="in_border" align="center"><%=ht.get("연락처")%></td>
	  <td class="in_border" align="center"><%=ht.get("구분")%></td>
	  <td class="in_border" align="center"></td>
	  <td class="no_border"></td>
	</tr>
	<%}else{%>
	<tr>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=i+1%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("차량번호")%></td>	  
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("차종")%></td>	  	  
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("차명")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("차정")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("유종")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("현주행거리")%></td>	  
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("연식")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("변속기")%></td>
	  <td class="in_border" align="center" style='mso-number-format:\@; background-color:#e6b9b8;'><%=ht.get("SK_CODE")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("담당자")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("연락처")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("구분")%></td>
	  <td class="in_border" align="center" style='background-color:#e6b9b8;'><%=ht.get("DLY_COUNT")%></td>
	  <td class="no_border" align="center" style='background-color:#e6b9b8;'><%if(String.valueOf(ht.get("CAR_ST")).equals("4")){%>해당 월렌트 연체 차량은 작업 전 필히 당사 담당자와 확인 하시고 작업을 진행 해주세요.<%}%></td>
	</tr>
	<%}%>
	<%	}%>
	<tr>
		<td class="red_font" colspan="14">※ 연체 : 연체가 1개월 이상일 때 연체 횟수를 표시합니다. 해당 차량은 작업 전 필히 당사 담당자와 확인 하시고 작업을 진행 해주세요.</td>
	</tr>
  </table>
</form>

</body>
</html>
