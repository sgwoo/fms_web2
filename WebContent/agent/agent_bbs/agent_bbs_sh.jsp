<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchBbs()
{
	var theForm = document.BbsSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<form action="./agent_bbs_sc.jsp" name="BbsSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Agent > 공지사항 > <span class=style5>공지사항</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class=line>
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr >
					<td class=title width=8%>검색조건</td>
					<td width=14%>&nbsp;
						<select name="gubun" >
							<option value='' <%if(gubun.equals("")){%>selected<%}%>>전체</option>
							<option value='c_year' <%if(gubun.equals("c_year")){%>selected<%}%>>당해</option>
							<option value='c_mon' <%if(gubun.equals("c_mon")){%>selected<%}%>>당월 </option>
							<option value='title' <%if(gubun.equals("title")){%>selected<%}%>>제목</option>
							<option value='content' <%if(gubun.equals("content")){%>selected<%}%>>내용</option>
							<option value='user_nm' <%if(gubun.equals("user_nm")){%>selected<%}%>>작성자</option>
							<option value='reg_dt' <%if(gubun.equals("reg_dt")){%>selected<%}%>>날짜</option>					
						</select>
					&nbsp;<input type='text' name="gubun_nm" size='15' class='text'></td>
					<td class=title width=10%>카테고리 검색</td>
					<td width=42%>&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value='8'  <%if(gubun1.equals("8")){%>checked<%}%>>에이전트&nbsp;
						&nbsp;<a href="javascript:SearchBbs()"><img src="/acar/images/center/button_search.gif" align=absmiddle border=0></a></td>
				</tr>
			</table>
		</td>
		<td width=32>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>  