<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	CusReg_Database cr_db = CusReg_Database.getInstance();
	Vector cars = cr_db.getCarList(t_wd);

%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_car(car_mng_id,client_id){
	var fm = document.form1;
	fm.action = 'cus_reg_maint.jsp?car_mng_id='+car_mng_id+'&client_id='+client_id;
	fm.target = 'c_body';
	fm.submit();
	this.close();
}
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form name="form1" method="post">	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <tr>
          <td class=title width="30">연번</td>
          <td class=title width="30">구분</td>		  
          <td class=title width="100">차량번호</td>
          <td class=title width="240">차량명</td>
        </tr>
        <%	for(int i=0; i<cars.size(); i++){
        	Hashtable car = (Hashtable)cars.elementAt(i);%>
        <tr>
          <td align="center"><%= i+1 %></td>
          <td align="center"><%= car.get("USE_YN") %></td>		  
          <td align="center"><a href="javascript:view_car('<%= car.get("CAR_MNG_ID") %>','<%= car.get("CLIENT_ID") %>')"><%= car.get("CAR_NO") %></a></td>
          <td align="left">&nbsp;<%= car.get("CAR_NM") %> <%= car.get("CAR_NAME") %></td>
        </tr>
        <%	}%>
        <% 	if(cars.size() == 0) { %>
        <tr> 
          <td colspan=4 align=center height=25>등록된 데이타가 없습니다.</td>
        </tr>
        <%	}%>
      </table>
        </td>
    </tr>
    <tr>
      <td><font color="#666666">* 구분 : Y 대여 / N 해지 / '' 미결</font>&nbsp;</td>
    </tr>	
</form>
</table>

</body>
</html>