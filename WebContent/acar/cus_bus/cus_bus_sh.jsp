<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String year = AddUtil.getDate(1);
	String mon = AddUtil.getDate(2);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.target = "c_body";
		fm.action = "cus_bus_sc.jsp";
		fm.submit()
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
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������ > <span class=style5>�뿩������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gygsi.gif align=absmiddle>&nbsp;
            <select name='year'>
        	  <option value='2007' <% if(year.equals("2007")) out.print("selected"); %>>2007��</option>
    		  <option value='2008' <% if(year.equals("2008")) out.print("selected"); %>>2008��</option>
    		  <option value='2009' <% if(year.equals("2009")) out.print("selected"); %>>2009��</option>
    		  <option value='2010' <% if(year.equals("2010")) out.print("selected"); %>>2010��</option>
    		  <option value='2011' <% if(year.equals("2011")) out.print("selected"); %>>2011��</option>
    		  <option value='2012' <% if(year.equals("2012")) out.print("selected"); %>>2012��</option>
    		  <option value='2013' <% if(year.equals("2013")) out.print("selected"); %>>2013��</option>
    		  <option value='2014' <% if(year.equals("2014")) out.print("selected"); %>>2014��</option>
            </select> <select name='mon'>
              <option value=''>��ü</option>
              <option value='01' <% if(mon.equals("01")) out.print("selected"); %>>01��</option>
              <option value='02' <% if(mon.equals("02")) out.print("selected"); %>>02��</option>
              <option value='03' <% if(mon.equals("03")) out.print("selected"); %>>03��</option>
              <option value='04' <% if(mon.equals("04")) out.print("selected"); %>>04��</option>
              <option value='05' <% if(mon.equals("05")) out.print("selected"); %>>05��</option>
              <option value='06' <% if(mon.equals("06")) out.print("selected"); %>>06��</option>
              <option value='07' <% if(mon.equals("07")) out.print("selected"); %>>07��</option>
              <option value='08' <% if(mon.equals("08")) out.print("selected"); %>>08��</option>
              <option value='09' <% if(mon.equals("09")) out.print("selected"); %>>09��</option>
              <option value='10' <% if(mon.equals("10")) out.print("selected"); %>>10��</option>
              <option value='11' <% if(mon.equals("11")) out.print("selected"); %>>11��</option>
              <option value='12' <% if(mon.equals("12")) out.print("selected"); %>>12��</option>
            </select>&nbsp;&nbsp;<a href='javascript:search();'><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
</table>
</form>  
</body>
</html>
