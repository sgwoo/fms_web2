<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%

	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	String s_mon = s_sys.substring(5,7);
	String s_day = s_sys.substring(8,10);
	
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이					
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function search(){
	var fm = document.form1;
	fm.submit();
}
//-->
</script>
</head>

<body>

<table width="100%" border="0" cellspacing="1" cellpadding="0">
<form name='form1' method='post' action='cus0602_ds_sc.jsp' target='dsc_body'>
<input type="hidden" name="off_id" value="<%= off_id %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송 내역</span></td>
  </tr>
  <tr> 
      <td><table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width="150">&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>
              <select name='s_kd'>
                <option value="0" selected>전체</option>
                <option value="2">탁송구분</option>
                <option value="3">차량번호</option>
             
              </select></td>
            <td width="70"> <input type='text' name='t_wd' size='12' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
            </td>
            <td width="150">&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>
              <select name='sort_gubun'>
                <option value="0" selected>의뢰일자</option>
                <option value="1">차량번호</option>
             
              </select> </td>
            <td width="165"> <input type='radio' name='sort' value='asc' checked onClick='javascript:search()'>
              오름차순 
              <input type='radio' name='sort' value='desc' onClick='javascript:search()'>
              내림차순 </td>
            <td width="200"><img src=/acar/images/center/arrow_gjnw.gif align=absmiddle> 
              <select name='year'>
                <option value="1999" <%if(s_year.equals("1999")){%>selected<%}%>>1999</option>
                <option value="2000" <%if(s_year.equals("2000")){%>selected<%}%>>2000</option>
                <option value="2001" <%if(s_year.equals("2001")){%>selected<%}%>>2001</option>
    			<option value='2002' <%if(s_year.equals("2002")){%>selected<%}%>>2002</option>
    			<option value='2003' <%if(s_year.equals("2003")){%>selected<%}%>>2003</option>
    			<option value='2004' <%if(s_year.equals("2004")){%>selected<%}%>>2004</option>
    			<option value='2005' <%if(s_year.equals("2005")){%>selected<%}%>>2005</option>
    			<option value='2006' <%if(s_year.equals("2006")){%>selected<%}%>>2006</option>
    			<option value='2007' <%if(s_year.equals("2007")){%>selected<%}%>>2007</option>
    			<option value='2008' <%if(s_year.equals("2008")){%>selected<%}%>>2008</option>
              </select>년
              <select name='month'>
                <option value=''>--</option>			  
                <option value='01' <%if(s_mon.equals("01")){%>selected<%}%>>01</option>
    			<option value='02' <%if(s_mon.equals("02")){%>selected<%}%>>02</option>
    			<option value='03' <%if(s_mon.equals("03")){%>selected<%}%>>03</option>
    			<option value='04' <%if(s_mon.equals("04")){%>selected<%}%>>04</option>
    			<option value='05' <%if(s_mon.equals("05")){%>selected<%}%>>05</option>
    			<option value='06' <%if(s_mon.equals("06")){%>selected<%}%>>06</option>
    			<option value='07' <%if(s_mon.equals("07")){%>selected<%}%>>07</option>
    			<option value='08' <%if(s_mon.equals("08")){%>selected<%}%>>08</option>
    			<option value='09' <%if(s_mon.equals("09")){%>selected<%}%>>09</option>
    			<option value='10' <%if(s_mon.equals("10")){%>selected<%}%>>10</option>
    			<option value='11' <%if(s_mon.equals("11")){%>selected<%}%>>11</option>
    			<option value='12' <%if(s_mon.equals("12")){%>selected<%}%>>12</option>
              </select>월
            </td>
            <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
          </tr>
        </table></td>
  </tr>
</form>
</table>
</body>
</html>
