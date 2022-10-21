<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.esti_mng.*"%>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd =  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	if(!t_wd.equals("")){
%>
<form name='form1' action='./ext_car_s.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%			Vector wt_cars = EstiMngDb.getCarOffEmpList(s_kd, t_wd);
			int car_size = wt_cars.size();
			if(car_size > 0){
				for(int i = 0 ; i < car_size ; i++){
					Hashtable car = (Hashtable)wt_cars.elementAt(i);	%>
				<tr>
					<td width='10%' align='center'><%=i+1%></td>				
					<td width='20%' align='center'><%=car.get("CAR_COMP_NM")%></td>
					<td width='50%' align='center'><%=car.get("CAR_OFF_NM")%></td>
					<td width='20%' align='center'><a href="javascript:parent.select_car('<%=car.get("EMP_ID")%>', '<%=car.get("CAR_COMP_NM")%> <%=car.get("CAR_OFF_NM")%>', '<%=car.get("EMP_NM")%>', '<%=car.get("EMP_M_TEL")%>', '<%=car.get("CAR_OFF_FAX")%>')" onMouseOver="window.status=''; return true"><%=car.get("EMP_NM")%></a></td>
				</tr>
<%				}
			}else{	%>
				<tr>
					<td align='center' colspan='4'>등록된 데이타가 없습니다</td>
				</tr>
<%			}		%>
			</table>
		<td>
	</tr>	
</table>
</form>
<%	}%>
</body>
</html>