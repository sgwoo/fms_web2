<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.target = "c_body";
		fm.action = "cus_app_sc.jsp";
		fm.submit()
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
-->
</script>
</head>
<body leftmargin="15">
<form name=form1 method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  	  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리> <span class=style5>고객평가관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_shm.gif align=absmiddle>&nbsp; 
        <input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp; 
        <select name='sort_gubun'>
		  <option value='firm_nm'>상호</option>
          <option value='client_nm'>계약자</option>
          <option value='rent_dt'>최초거래일</option>
          <option value='cnt'>계약건수</option>
        </select> <input type='radio' name='sort' value='asc' checked>
        오름차순 
        <input type='radio' name='sort' value='desc'>
        내림차순 &nbsp;&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absbottom" border="0"></a> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>
