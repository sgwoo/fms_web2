<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_b_dt = request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");	
	
	//자동차회사&차종&자동차명 
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	Vector car_nmList = a_cmb.getCar_nmList(car_comp_id, car_cd, car_b_dt);
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//자명 선택시 해당 코드 보내기
	function set_car_b_inc(car_id, car_seq, car_name){
		opener.document.form1.car_b_inc_id.value = car_id;
		opener.document.form1.car_b_inc_seq.value = car_seq;
		window.opener.form1.car_b_inc_name.value = car_name;
		self.close();		
	}
	
//-->
</script>
</head>

<body>
<table width="450" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="450" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="45">연번</td>
                    <td class="title" width="225">차명</td>
                    <td class="title" width="95">차량가격</td>
                    <td class="title" width="85">기준일자</td>
                </tr>
                <% if(car_nmList.size()>0){
        			for(int i=0; i<car_nmList.size(); i++){
        				Hashtable car_nm = (Hashtable)car_nmList.elementAt(i); %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td>&nbsp;<a href="javascript:set_car_b_inc('<%= car_nm.get("CAR_ID") %>','<%= car_nm.get("CAR_SEQ") %>','<%= car_nm.get("CAR_NAME") %>');"><%= car_nm.get("CAR_NAME") %></a></td>
                    <td align="right"><%= car_nm.get("CAR_B_P") %> 원&nbsp;</td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)car_nm.get("CAR_B_DT")) %></td>
                </tr>
                <% }
        		}else{ %>
                <tr> 
                    <td colspan="4" align="center">해당 차명 없습니다.</td>
                </tr>
                <% } %>
          </table>
      </td>
  </tr>
</table>
</body>
</html>

