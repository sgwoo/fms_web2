<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	
	
	white = "white";
	disabled = "disabled";
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%>>
<form name='form1' action='/agent/consignment/cons_conf_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;Agent > <span class=style1>탁송관리 > <span class=style5>탁송료미확인현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>		
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td class=title width=10%>검색조건</td>
                  <td>&nbsp;
        		    <select name='s_kd' disabled>           
                      <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>의뢰자</option>           	  
                    </select>
        			&nbsp;&nbsp;&nbsp;
        			<input type='text' name='t_wd' size='25' class='whitetext' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		  </td>        		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><%if(white.equals("")){%>
		<a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
    	<%}%></td>
    </tr>
</table>
</form>
</body>
</html>
