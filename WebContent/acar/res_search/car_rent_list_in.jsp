<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	Vector conts = rs_db.getResSearchList("", "", "", "", "", "", "", "", "", 0, "1", car_no, "a.car_no", "asc");
	int cont_size = conts.size();
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=550>	
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=550>
	  <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
        <tr> 
          <td width=30 align="center"><%=i+1%></td>
          <td width=90 align="center"><a href="javascript:parent.SetCarRent('<%=reserv.get("CAR_MNG_ID")%>')"><%= reserv.get("CAR_NO")%></a></td>
          <td width=220 align="center"><%= reserv.get("CAR_NM")%>&nbsp;<%= reserv.get("CAR_NAME")%></td>
          <td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
          <td width=60 align="center"><%= reserv.get("DPM")%>cc</td>
          <td width=70 align="center"><%= reserv.get("COLO")%></td>
        </tr>
	  <%	}
  		}else{%> 			
        <tr> 
          <td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
        </tr>
      <%}%>
      </table>
    </td>
  </tr>
</table>
</body>
</html>