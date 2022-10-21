<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="card.*" %>

<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	int year =AddUtil.getDate2(1);
	String s_sys = Util.getDate();
	String byear = s_sys.substring(0,4);
	
	String bgubun = request.getParameter("bgubun")==null?"1":request.getParameter("bgubun");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function SearchUser()
{
	var theForm = document.UserSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}

//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>예산한도관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<form action="./budget_mng_sc.jsp" name="UserSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
	            	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yd.gif" >&nbsp; 
	            	
	            	
	            	   <select name="byear">
				<%for(int i=2010; i<=year; i++){%>
				<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
		&nbsp;년&nbsp;&nbsp;
		  				&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gshm.gif" >&nbsp;
	            		  <select name='bgubun'>
				    			<option value='1' <%if(bgubun.equals("1")){%>selected<%}%>>복지비</option>
				    			<option value='3' <%if(bgubun.equals("3")){%>selected<%}%>>팀장활동비</option>
				  <!--  			<option value='2' <%if(bgubun.equals("2")){%>selected<%}%>>유류대</option>   -->
				    		
				    	</select>&nbsp;
	  				</td>
					<td>&nbsp;&nbsp;<a href="javascript:SearchUser()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
            	</tr>
            </table>
            <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="user_id" value="<%=user_id%>">
        </td>
    </tr>
</form>

</table>
</body>
</html>