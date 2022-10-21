<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	//String auth_rw = "";
	
	//if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

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
	var theForm = document.from1;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<form action="./know_how_sc.jsp" name="from1" method="POST" target="c_foot">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5>아마존카 지식IN</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class=line>
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr >
					<td class=title width=8%>검색조건</td>
					<td width=18%>&nbsp;
						<select name="gubun" onChange="javascript:document.from1.gubun_nm.focus()">
							<option value="all">전체</option>
							<option value="current_month">당월</option>
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="user_nm">작성자</option>
							<option value="reg_dt">날짜	</option>
						</select>
					&nbsp;<input type='text' name="gubun_nm" size='22' class='text'></td>
					<td class=title width=10%>카테고리 검색</td>
					<td width=39%>&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value=''  <%if(gubun1.equals("")){%>checked<%}%>>전체&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value='1'  <%if(gubun1.equals("1")){%>checked<%}%>>지식Q&A&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value='2'  <%if(gubun1.equals("4")){%>checked<%}%>>오픈지식&nbsp;
			
						&nbsp;<a href="javascript:SearchBbs()"><img src="/acar/images/center/button_search.gif" align=absmiddle border=0></a></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;* 지식 Q&A는 궁금한 점이나 직원들의 의견을 묻고 싶을 때, 오픈지식은 업무노하우나 직원들과 같이 공유하고 싶은 정보들을 등록하시면 됩니다. </td>
	</tr>
</table>
</form>
</body>
</html>  