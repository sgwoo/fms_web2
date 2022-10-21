<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*"%>
<%//@ include file="/acar/cookies.jsp" %>

<%
	//상위차량의 기본사양 조회 페이지
	
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");	
	
	//자동차회사&차종&자동차명 
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	Hashtable car_b = a_cmb.getCar_b(car_id, car_seq);
	
	String car_b_inc_name = a_cmb.getCar_b_inc_name((String)car_b.get("CAR_B_INC_ID"), (String)car_b.get("CAR_B_INC_SEQ"));	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function open_car_b(car_id, car_seq, car_name){
	fm = document.form1;
	window.open('car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b<%= car_b.get("LEVELNUM") %>", "left=<%= car_b.get("LEFT") %>, top=<%= car_b.get("TOP") %>, width=699, height=600, scrollbars=yes"); 
}

//팝업창 닫기
function Close()
{
	self.close();
	window.close();
}
//-->
</script>
</head>

<body leftmargin=0 topmargin=0>
<form name="form1" method="post">
<table width="682" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <img src=/acar/main_car_hp/images/car_price/bar_basic.gif>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align=center>
            <table width="650" border="0" cellspacing="1" cellpadding="0" bgcolor=bdd3d1>
                <tr>
                    <td align=center style="background-color:e1eded; color:2c7183; font-weight:bold; height=30;"><%= car_name %> 기본사양</td> 
                </tr> 
                <tr> 
                    <td align=center>
                        <table width=97% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
                    <% if(!((String)car_b.get("CAR_B_INC_ID")).equals("")){ %><a href="javascript:open_car_b('<%= car_b.get("CAR_B_INC_ID") %>','<%= car_b.get("CAR_B_INC_SEQ") %>','<%= car_b_inc_name %>');"><%= car_b_inc_name %></a> 외<% } %>  
        				  <%=car_b.get("CAR_B")%></td>
        				    </tr>
        				    <tr>
                                <td style='height:5'></td>
                            </tr>
                        </table>
		            </td> 
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
    <div align="center"><a href="javascript:Close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></div>
</form>
</body>
</html>
