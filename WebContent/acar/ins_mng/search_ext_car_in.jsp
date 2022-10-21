<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="e_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�������� ���ý� ������ ����Ʈ ��� ������
	
	String car_st 		=  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd 		=  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd 		=  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_gu	 	= request.getParameter("car_gu")==null?"":request.getParameter("car_gu");
	
	if(t_wd.equals("")) car_cd="";
	
	Vector wt_cars = new Vector();
	int car_size = 0;
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
<input type='hidden' name='car_gu' value='<%=car_gu%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    		
    <%		if(!t_wd.equals("")){
    			wt_cars = e_db.getExistingCarList(s_kd, t_wd, car_cd, car_gu);
    			car_size = wt_cars.size();
    		
	    		if(car_size > 0){
    				for(int i = 0 ; i < car_size ; i++){
    					Hashtable car = (Hashtable)wt_cars.elementAt(i);%>
    		    <tr>
        			<td width='50' align='center'><%=i+1%></td>				
        			<td width='100' align='center'><a href="javascript:parent.select_car('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '<%=car.get("CAR_COMP_ID")%>', '<%=car.get("CAR_MNG_ID")%>', '<%=car.get("CAR_NO")%>', '<%=car.get("OFF_LS")%>', '<%=car.get("CAR_NM")%>', '<%=car.get("CAR_NAME")%>')" onMouseOver="window.status=''; return true"><%=car.get("CAR_NO")%></a></td>
        			<td width='270'>&nbsp;<span title='<%=car.get("CAR_NM")%> <%=car.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(car.get("CAR_NM")+" "+car.get("CAR_NAME")), 15)%></span></td>
        			<td width='80' align='center'><%=car.get("RENT_ST_NM")%></td>
        			<td width='150' align='center'><span title='<%=car.get("CUST_NM")%>'><%=Util.subData(String.valueOf(car.get("CUST_NM")), 10)%></span></td>
        			<td align='center'><%=car.get("DELI_DT")%></td>															
    		    </tr>
    <%				}
    			}
    		}else{%>
    		    <tr>
    			    <td align='center'>�˻��ܾ�� �˻��ϼ���</td>
    		    </tr>
    <%		}%>
    		</table>
	    <td>
	</tr>	
</table>
</form>
</body>
</html>