<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="CaNoDb" class="acar.ca.CaNoDatabase" scope="page" />
<%@ include file="/acar/cookies_base.jsp" %>

<%
	Vector vt = CaNoDb.getCaNoList(s_kd, t_wd);
	int size = vt.size();
%>
<html>
<head>
<title>기존차량리스트</title>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%if(size > 0){
				for(int i = 0 ; i < size ; i++){
					Hashtable car = (Hashtable)vt.elementAt(i);	%>
          <tr> 
            <td width="6%"><%= i+1 %></td>
            <td width="20%"><a href="javascript:parent.sel_car('<%= car.get("RENT_MNG_ID") %>','<%= car.get("RENT_L_CD") %>','<%= car.get("CAR_MNG_ID") %>','<%= car.get("CLIENT_ID") %>','<%= car.get("SITE_ID") %>');"><%= car.get("CAR_NO") %></a></td>
            <td width="30%"><%= car.get("CAR_NM") %></td>
            <td width="30%"><%= car.get("FIRM_NM") %></td>
            <td width="14%"><%= car.get("USE_YN") %></td>
          </tr>
          <%	}
			}else{ %>
          <tr> 
            <td align='center' colspan='5'>등록된 데이타가 없습니다</td>
          </tr>
          <%	} %>
        </table>
		<td>
	</tr>	
</table>
</body>
</html>