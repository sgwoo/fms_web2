<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String nm = "";
	String cd = "";
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		if(request.getParameter("nm") !=null) nm = request.getParameter("nm");
		if(request.getParameter("cd") !=null) cd = request.getParameter("cd");
		
		dept_bean.setNm(nm);
		dept_bean.setCode(cd);
		if(cmd.equals("i"))
		{
			count = umd.insertDept(dept_bean);
		}else if(cmd.equals("u")){
			count = umd.updateDept(dept_bean);
		}
	}	
	DeptBean dept_r [] = umd.getDeptAll();

%>
<html>
<head>

<title>부서</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function OfficeReg()
{
	var theForm = document.DeptForm;
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.submit();

}
function OfficeUp()
{
	var theForm = document.DeptForm;
	var nm = theForm.nm.value;
	if(!confirm(nm + '을 수정하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.submit();

}

function UpdateList(cd,nm)
{
	var theForm = document.DeptForm;
	theForm.nm.value= nm;
	theForm.cd.value= cd;
	

}
//-->
</script>
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
<body leftmargin="15">
<form action="./dept_i.jsp" name="DeptForm" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="250">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>부서</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="3">
		    	<td width=48 align=right>&nbsp;&nbsp;<img src=../images/center/arrow_bs.gif align=absmiddle></td>
		        <td><input type="text" name="nm" value="" size="10" class=text></td>
		    	<td align=right><a href="javascript:OfficeReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;<a href="javascript:OfficeUp()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a></td>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="250">
                <tr>
                    <td class=title>부서</td>
                </tr>
<%
    for(int i=0; i<dept_r.length; i++){
        dept_bean = dept_r[i];
%>
                <tr>
                    <td align=center><a href="javascript:UpdateList('<%= dept_bean.getCode() %>','<%= dept_bean.getNm() %>')"><%= dept_bean.getNm() %></a></td>
                </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="cd" value="">
<input type="hidden" name="cmd" value="">
</form>
<script>
<%
	if(cmd.equals("u"))
	{
%>
alert("정상적으로 수정되었습니다.");

<%
	}else{
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
<%
		}
	}
%>
</script>
</body>
</html>