<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="e_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd =  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	if(t_wd.equals("")) car_cd="";
%>
<form name='form1' action='./ext_car_s.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=450>
<%			Vector wt_cars = e_db.getExistingCarList(s_kd, t_wd, car_cd);
			int car_size = wt_cars.size();
			if(car_size > 0){
				for(int i = 0 ; i < car_size ; i++){
					Hashtable car = (Hashtable)wt_cars.elementAt(i);	%>
				<tr>
					<td width='30' align='center'><%=i+1%></td>				
					<td width='100' align='center'><%=car.get("RENT_L_CD")%></td>
					<td width='100' align='center'><a href="javascript:parent.select_car('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '<%=car.get("CAR_COMP_ID")%>', '<%=car.get("CAR_MNG_ID")%>', '<%=car.get("CAR_NO")%>', '<%=car.get("OFF_LS")%>', '<%=car.get("CAR_NM")%>', '<%=car.get("CAR_NAME")%>')" onMouseOver="window.status=''; return true"><%=car.get("CAR_NO")%></a></td>
					<td width='220' align='center'><%=car.get("CAR_NM")%> <%=car.get("CAR_NAME")%></td>
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
</body>
</html>