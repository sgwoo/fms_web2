<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
		
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
	var theForm = document.from1;
	theForm.target = "c_foot";
	theForm.submit();
}

//-->
</script>
</head>
<body>
<form action="./over_time_sc.jsp" name="from1" method="POST" target="c_foot">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1> 인사관리 > 업무일지관리 > <span class=style5>특근수당 신청</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jggs.gif align=absmiddle>&nbsp;
			<select name="st_year">
                        <%for(int i=2016; i<=year; i++){%>
                        <option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
                        <%}%>
                      </select> <select name="st_mon">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
                        <%}%>
                      </select>
					&nbsp;<a href="javascript:search();"><img src="/acar/images/center/button_search.gif" border="0" align=absmiddle></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>  