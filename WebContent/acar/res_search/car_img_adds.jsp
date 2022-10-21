<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>

<html>
<head>
<title><%=car_no%> 차량사진 올리기</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
</head>
<body leftmargin="15">
<form name='form1' action='car_img_add_a.jsp' method='post'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
  <table border=0 cellspacing=0 cellpadding=0 width='600'>
    <tr> 
      <td><font color="navy">예약시스템 -> 영업지원 -> </font><font color="red">차량사진관리</font></td>
    </tr>
    <tr> 
      <td align='right'><a href='javascript:close();'><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
      </td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="1" width=100%>
          <tr> 
            <td class=title width="40" rowspan="2"><%=nm%></td>
            <td width="120" align="center" valign="middle" rowspan="2"> 
              <%if(!img.equals("")){%>
              <img src="https://fms3.amazoncar.co.kr/images/carImg/<%=img%>.gif" width="120" height="79" name="f"> 
              <%}else{%>
              <img src="../off_ls_hpg/img/no_photo.gif" width="120" height="76" name="f"> 
              <%}%>
            </td>
            <td width="400" valign="bottom" align="center"> 
              <input type="file" name="filename" size="40">
            </td>
          </tr>
          <tr> 
            <td width="400" valign="bottom" align="right"> <a href="javascript:save();" onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp; 
              <a href="javascript:img_delete();" onMouseOver="window.status=''; return true"><img src="/images/del.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>