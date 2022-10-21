<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.secondhand.*, acar.insur.*, acar.memo.*, acar.admin.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function popup(url, table_width)
	{
		var fm = document.form1;
		fm.table_width.value = table_width;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int idx = 0;	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='table_width' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    <td colspan=10>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>기타현황</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>

  <!--1-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. ARS시스템파트너현황 
	    &nbsp;&nbsp;<a href="javascript:popup('select_stat_etc_list1.jsp','650')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>					 
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <tr>
	  <td><hr></td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <% idx = 0; %>
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ <b>기준년도</b> - <input type='text' size='4' name='settle_year' maxlength='4' class='default' value='<%=AddUtil.getDate2(1)-1%>'>
		  년도
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>
  <!--1-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 년도별 비즈톡(알림톡/친구톡/문자)발송현황 
	    &nbsp;&nbsp;<a href="javascript:popup('select_stat_etc_list_y1.jsp','2540')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>					 
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>  
  <!--2-->
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%idx++;%><%=idx%>. 년도별 스캔파일 현황
	    &nbsp;&nbsp;<a href="javascript:popup('select_stat_etc_list_y2.jsp','1000')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>					 
	  </td>
  </tr>
  <tr>
	  <td>&nbsp;</td>
  </tr>    
  <tr>
	  <td>&nbsp;</td>
  </tr>
      
    

  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
