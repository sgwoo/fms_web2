<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function search()
	{
		var fm = document.form1;	
		
		if(fm.gubun1.value == '7' && fm.st_dt.value == '' && fm.end_dt.value == ''){
			alert('기간을 입력하십시오.');  return;
		}
		fm.target = "c_foot";
		fm.action = "br_cond_sc.jsp";	
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}



//-->
</script>
</head>
<body>
<form name='form1' action='' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>영업소별계약현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>            		
            	    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            		<select name='gubun1'>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당일</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>전일</option>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>전전일</option>
                          <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>당월</option>
                          <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>전월</option>
                          <option value='6' <%if(gubun1.equals("6")){%>selected<%}%>>전전월</option>
                          <option value='7' <%if(gubun1.equals("7")){%>selected<%}%>>기간 </option>
                        </select>
                        &nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                        &nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;
                        차량구분 : <select name='gubun2'>
                          <option value='' <%if(gubun2.equals("")){%>selected<%}%>>선택</option>
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>신차</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>재리스</option>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>연장</option>
                        </select>
                        <a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle>
                    </a>
            	</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>