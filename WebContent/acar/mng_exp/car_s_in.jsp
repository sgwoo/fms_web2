<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<html>
<head><title>FMS</title>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
<input type='hidden' name='mode' value='PRE'>
<%
	String s_kd 	=  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	if(t_wd.equals("")) if(1==1)return;
	
	Vector cars = ex_db.getCarList(s_kd, t_wd);
	int car_size = cars.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
	if(car_size > 0)
	{
			for(int i = 0 ; i < car_size ; i++)
			{
				Hashtable car = (Hashtable)cars.elementAt(i);
%>
				<tr>
					<td width=20% align='center'><a href="javascript:parent.select_car('<%=car.get("CAR_MNG_ID")%>', '<%=car.get("CAR_NO")%>', '<%=car.get("CAR_NM")%>', '<%=car.get("FIRM_NM")%>', '<%=car.get("CLIENT_NM")%>')" onMouseOver="window.status=''; return true"><%=car.get("CAR_NO")%></a></td>
					<td width=25% align='center'><span title='<%=car.get("CAR_NM")%>'><%=Util.subData(String.valueOf(car.get("CAR_NM")), 6)%></span></td>
					<td width=40% align='center'><span title='<%=car.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(car.get("FIRM_NM")), 9)%></span></td>
					<td width=15% align='center'><%=car.get("CLIENT_NM")%></td>
				</tr>
<%
			}
	}
	else
	{
%>
				<tr>
					<td colspan='4' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
