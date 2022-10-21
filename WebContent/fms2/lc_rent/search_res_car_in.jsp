<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="e_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//기존차량 선택시 보유차 리스트 출력 페이지
	
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String car_st 	=  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd 	=  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd 	=  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	if(t_wd.equals("")) car_cd="";
	
	if(client_id.equals("000228")) client_id="";
%>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='search_ext_car.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=760>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    <%		Vector wt_cars = e_db.getReservationCarList(s_kd, t_wd, car_cd, client_id);
    		int car_size = wt_cars.size();
    		
    		if(car_size > 0){
    			for(int i = 0 ; i < car_size ; i++){
    				Hashtable car = (Hashtable)wt_cars.elementAt(i);%>
    		    <tr>
        			<td width='50' align='center'><%=i+1%></td>				
        			<td width='100' align='center'><a href="javascript:parent.select_car('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '<%=car.get("CAR_COMP_ID")%>', '<%=car.get("CAR_MNG_ID")%>', '<%=car.get("CAR_NO")%>', '<%=car.get("OFF_LS")%>', '<%=car.get("CAR_NM")%>', '<%=car.get("CAR_NAME")%>','<%=car.get("DELI_DT")%>','<%=car.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true"><%=car.get("CAR_NO")%></a></td>
        			<td width='270'>&nbsp;<span title='<%=car.get("CAR_NM")%> <%=car.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(car.get("CAR_NM")+" "+car.get("CAR_NAME")), 15)%></span></td>
        			<td width='80' align='center'><%=car.get("RENT_ST_NM")%></td>
        			<td width='150' align='center'><span title='<%=car.get("CUST_NM")%>'><%=Util.subData(String.valueOf(car.get("CUST_NM")), 10)%></span></td>
        			<td width='130' align='center'><%=car.get("DELI_DT")%></td>															
    		    </tr>
    <%			}
    		}else{%>
    		    <tr>
    			    <td align='center' colspan='6'>등록된 데이타가 없습니다</td>
    		    </tr>
    <%		}%>
    		</table>
	    <td>
	</tr>	
</table>
</form>
</body>
</html>