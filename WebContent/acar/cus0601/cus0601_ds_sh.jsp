<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	String s_mon = s_sys.substring(5,7);
	String s_day = s_sys.substring(8,10);
	s_mon = "";
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이					
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
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

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name='form1' method='post' action='cus0601_ds_sc.jsp' target='dsc_body'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="off_id" value="<%= off_id %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비 내역</span></td>
    </tr>
    <tr> 
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td width="300">&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>
                      &nbsp;<select name='s_kd'>
                        <option value="0" selected>전체</option>
                        <option value="1">정비일자</option>
                        <option value="2">정비구분</option>
                        <option value="3">차량번호</option>
                        <option value="4">점검자</option>
                        <option value="5">정비품목</option>
                        <option value="6">지급일자</option>
                      </select>
                      &nbsp;
                      <input type='text' name='t_wd' size='12' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                    </td>
                    <td width=200>&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jrjg.gif align=absmiddle>
                      &nbsp;<select name='sort_gubun'>
                        <option value="0" selected>정비일자</option>
                        <option value="1">차량번호</option>
                        <option value="2">점검자</option>
                        <option value="3">정비품목</option>
                        <option value="4">정비비</option>
                        <option value="5">지급일자</option>
                      </select> </td>
                    <td width=170><input type='radio' name='sort' value='asc' onClick='javascript:search()'>
                      오름차순 
                      <input type='radio' name='sort' value='desc' checked onClick='javascript:search()'>
                      내림차순 </td>
                    <td width=220><img src=../images/center/arrow_gjnw.gif align=absmiddle>
                      &nbsp;<select name='year'>
          			<%for(int i=1999; i<=AddUtil.getDate2(1); i++){%>
          			<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_year)){%> selected <%}%>><%=i%></option>
          			<%}%>
                      </select>년
                      <select name='month'>
                        <option value=''>전체</option>
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
                    <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
