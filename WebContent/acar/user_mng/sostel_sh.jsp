<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	DeptBean dept_r [] = umd.getDeptAll();
	BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_ts.css"></link>


<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
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
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>(주)아마존카 연락망</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./sostel_sc.jsp" name="UserSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td width=60 align=right><img src=../images/center/arrow_gmg.gif align=absmiddle></td>
            		<td width=1>&nbsp;</td>
            		<td width=100>
            			<select name="s_br_id">
            				<option value="">전체</a>
<%
    for(int i=0; i<br_r.length; i++){
        br_bean = br_r[i];
%>
            				<option value="<%= br_bean.getBr_id() %>" <%if(s_br_id.equals(br_bean.getBr_id()))%>selected<%%>><%= br_bean.getBr_nm() %></option>
<%}%>            			</select>
            		</td>
            		<td width=30 align=right><img src=../images/center/arrow_bs.gif align=absmiddle></td>
            		<td width=1>&nbsp;</td>
            		<td width=90>
            			<select name="dept_id">
            				<option value="">전체</a>
<%
    for(int i=0; i<dept_r.length; i++){
        dept_bean = dept_r[i];
%>
            				<option value="<%= dept_bean.getCode() %>" <%if(dept_id.equals(dept_bean.getCode()))%>selected<%%>><%= dept_bean.getNm() %></option>
<%}%>	       			</select>
            		</td>
            		<td width=85><input type="text" name="user_nm" size="10" value="<%=user_nm%>"></td>
					<td><a href="javascript:SearchUser()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
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