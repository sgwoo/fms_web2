<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*, acar.cc.*"%>
<jsp:useBean id="c_db" scope="page" class="acar.ma.CodeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd =  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	if(t_wd.equals("")) car_cd="";
	
%>
<html>
<head>
<title>기존차량리스트</title>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body>

<form name='form1' action='./ext_car_s.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value=''>
<input type='hidden' name='car_cd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=450>
<%	/*		Vector wt_cars = e_db.getExistingCarList(s_kd, t_wd, car_cd);
			int car_size = wt_cars.size();
			if(car_size > 0){
				for(int i = 0 ; i < car_size ; i++){
					Hashtable car = (Hashtable)wt_cars.elementAt(i);	*/%>
				<tr>
					
            <td width='30' align='center'><input type="radio" name="select_car" value="" onClick="javascript:parent.select_car('000001', 'S105HB4R00001', '0001', 'H', 'B4', '000006', '서울34허1234', '20050101', '5', '에쿠스', 'JS350 VALUE', '106', '대형승용III', '3500')"></td>
					<td width='30' align='center'>1</td>				
					<td width='100' align='center'>S105HB4R00001</td>
					<td width='100' align='center'>서울34허1234</td>
					<td align='center'>에쿠스 JS350 VALUE</td>
				</tr>
<%	/*			}
			}else{ */	%>
				<tr>
					<td align='center' colspan='5'>등록된 데이타가 없습니다</td>
				</tr>
<%		//	}		%>
			</table>
		<td>
	</tr>	
</table>
</form>
</body>
</html>