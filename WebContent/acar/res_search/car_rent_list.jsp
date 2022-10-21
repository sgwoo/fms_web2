<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function SetCarRent(car_mng_id)	{
		var theForm = opener.document.form1;
		opener.ReLoadRes(car_mng_id);
		self.close();	
	}
	
	//검색하기
	function search(){
		var fm = document.form1;		
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=570>	
<form name="form1" method="post" action="car_rent_list.jsp">
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>	  
  <tr>        
    <td colspan="2">차량번호: 
      <input type="text" name="car_no" size="15" class=text>
      <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
    </td>
  </tr>
  <tr>
    <td class=line width="550">            
      <table border=0 cellspacing=1>
        <tr> 
          <td class=title width="30">연번</td>
          <td class=title width="90">차량번호</td>
          <td class=title width="220">차명</td>
          <td class=title width="80">연식</td>
          <td class=title width="60">배기량</td>
          <td class=title width="70">색상</td>
        </tr>
      </table>
    </td>
	<td width="20">&nbsp;</td>
  </tr>		
  <tr>
	<td colspan="2"><iframe src="car_rent_list_in.jsp?gubun=<%=gubun%>&rent_l_cd=<%=rent_l_cd%>&firm_nm=<%=firm_nm%>&car_no=<%=car_no%>" name="inner" width="570" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	</iframe></td>
  </tr>
</form>		
</table>
</body>
</html>