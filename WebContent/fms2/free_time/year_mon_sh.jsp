<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	int year =AddUtil.getDate2(1);
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function search()
{
	var fm = document.from1;
	if(fm.dt[0].checked == true){
		fm.action='year_mon_sc_in_d.jsp';	
	}else if(fm.dt[1].checked == true){
		fm.action='year_mon_sc_in_y.jsp';	
	}	
	fm.target = "c_foot";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form action="year_mon_sc_in_d.jsp" name="from1" method="POST" target="c_foot">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="sh_height" value="<%=sh_height%>">     
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1> 인사관리 > 근태관리 > <span class=style5>휴가현황보기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;
			<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
				당일 &nbsp;
			<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
				기간 &nbsp;
			<select name="st_year">
				<option value="">전체</option>
				<%for(int i=2009; i<=year; i++){%>
				<option value="<%=i%>" <%if(AddUtil.parseInt(st_year) == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
			<select name="st_mon">
				<option value="">전체</option>
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.parseInt(st_mon) == i){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
				<%}%>
			</select>&nbsp;
			<a href="javascript:search();"><img src="/acar/images/center/button_search.gif" border="0" align=absmiddle></a>
		</td>
	</tr>
</table>
</form>
</body>
</html>  