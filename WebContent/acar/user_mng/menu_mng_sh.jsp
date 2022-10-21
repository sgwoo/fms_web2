<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_cd = "";
	String m_nm = "";
	String url = "";
	String note = "";
	int seq = 0;
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}
	
	if(request.getParameter("m_st") !=null)
	{
		m_st = request.getParameter("m_st");
	}else{
		m_st = "01";
	}
	if(request.getParameter("m_cd") !=null) m_cd = request.getParameter("m_cd");
	if(request.getParameter("m_nm") !=null) m_nm = request.getParameter("m_nm");
	if(request.getParameter("url") !=null) url = request.getParameter("url");
	if(request.getParameter("note") !=null) note = request.getParameter("note");
	if(request.getParameter("seq") !=null) seq = Util.parseInt(request.getParameter("seq"));
	
		
	MenuBean bme_r [] = umd.getMenuAll(m_st, "b");

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

function BMenuAdd()
{
	
	var SUBWIN="./b_menu_i.html";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=500, height=300, scrollbars=yes");
}
function SMenuAdd()
{
	
	var SUBWIN="./s_menu_i.html";	
	window.open(SUBWIN, "DeptList", "left=100, top=100, width=500, height=110, scrollbars=yes");
}
function UserAdd()
{
	
	var SUBWIN="./user_i.html";	
	window.open(SUBWIN, "UserList", "left=100, top=100, width=360, height=190, scrollbars=no");
}

function SMenuSearch()
{
	var theForm = document.MenuListForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td ><font color="navy">MASTER -> </font><font color="red">메뉴관리</font></td>
    </tr>
	<form action="./menu_mng_sc.jsp" name="MenuListForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td>대메뉴 : </td>
            		<td>
            			<select name="m_st" onChange="javascript:SMenuSearch()">
<%
    for(int i=0; i<bme_r.length; i++){
        bme_bean = bme_r[i];
%>
    						<option value="<%= bme_bean.getM_st() %>"><%= bme_bean.getM_nm() %></a>
<%}%>
            			</select>
            		</td>
            		
					<td><a href="javascript:SMenuSearch()">검색</a></td>
            	</tr>
            </table>
            <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
        </td>
    </tr>
</form>
	
</table>
</body>
</html>