<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String brch 		= request.getParameter("brch")		==null?"":request.getParameter("brch");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList();	/* 영업소 조회 */
	int brch_size = branches.size();
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function reg_car_shed()
	{
		parent.location = "/acar/car_shed/cshed_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>";
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

<body>
<form name='form1' action='/acar/car_shed/cshed_sc.jsp' method='post' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>차고지관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_glyus.gif> <select name='brch'>
			<option value=''>전체</option>
<%
		if(brch_size > 0)
		{
			for (int i = 0 ; i < brch_size ; i++)
			{
				Hashtable branch = (Hashtable)branches.elementAt(i);
%>			          	<option value='<%=branch.get("BR_ID")%>' <%if(brch.equals(String.valueOf(branch.get("BR_ID"))))%>selected<%%>><%= branch.get("BR_NM")%></option>
<%			}
		}
%>			
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<select name="gubun1">
				<option value="" <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
				<option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>진행중</option>
				<option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>계약만료</option>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	 <!--<select name='shed_st' >
			<option value=''>전체</option>
			<option value='1'>차고지관리</option>
			<option value='2'>사무실관리</option>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
    		<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
		<input type="button" class="button" value="차고지등록" onclick="javascript:reg_car_shed();">				
<%	}%>    		
    		</td>
    </tr>
</table>
</form>
</body>
</html>