<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.Date"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<style type="text/css">
<!--
	td,body {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	th {font-size:12px; font-family:굴림; font-weight : bold; text-decoration:none; color:white}
	a:link {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:visited {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:hover {  font-size: 12px; text-decoration: blink; color:red}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
	
	}
//-->
</script>
</head>
<body onLoad="self.focus()">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	Hashtable reserv = rs_db.getReserveSearchCase(c_id);
%>
<form name="form1" method="post" action="">
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='mode' value=''>
 <input type='hidden' name='year' value=''>
 <input type='hidden' name='month' value=''>   
 <input type='hidden' name='date' value=''>    
  <table border=0 cellspacing=0 cellpadding=0 width=675>
    <tr> 
      <td colspan="2"><font color="navy">예약시스템 -> 영업지원</font><font color="red">차량위치</font></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" height="22"><img src="/acar/off_ls_hpg/img/icon_red.gif" width="7" height="7">&nbsp;<font color="navy">차량번호 
        : <%=reserv.get("CAR_NO")%> &nbsp;&nbsp;<img src="/acar/off_ls_hpg/img/icon_red.gif" width="7" height="7">&nbsp;<font color="navy">차명 
        : <%=reserv.get("CAR_NAME")%></font></font></td>
    </tr>
    <tr> 
      <td height="22"><img src="/acar/off_ls_hpg/img/icon_red.gif" width="7" height="7">&nbsp;<font color="navy">주차장 
        :
        <select name="car_park">
          <option value="1">파천교</option>
        </select>
        차량위치: 
        <input type="text" name="car_place" value="A-19" size="10" class=text>
        차량상태: 
        <input type="text" name="car_state" value="양호" size="35" class=text>
        </font> </td>
      <td height="22" align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
      <td colspan="2"> <iframe src="./car_map_in.jsp?c_id=<%=c_id%>" name="inner"  width="675" height="420" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >	
      </td>
    </tr>
  </table>
</form>
</body>
</html>