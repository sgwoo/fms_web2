<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");

	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="fee_dly_stat_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>대여료일별연체현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yd.gif align=absmiddle>
              &nbsp;<select name="s_yy">
                <%for(int i=2011; i<=AddUtil.getDate2(1)+1; i++){%>
                <option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>
              &nbsp;<select name="s_mm">
                <%for(int i=1; i<=12; i++){
                	String i_mm = AddUtil.addZero2(i);%>
                <option value="<%=i_mm%>" <%if(s_mm.equals(i_mm)){%>selected<%}%>><%=i_mm%>월</option>
                <%}%>
              </select>
              &nbsp;
              <a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
      </td>
    </tr>      
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>