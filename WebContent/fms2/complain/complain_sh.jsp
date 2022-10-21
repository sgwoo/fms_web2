<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	
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
function SearchComplain()
{
	var theForm = document.ComplainSearchForm;
	var g_nm = theForm.gubun_nm.value;
	
	theForm.action = 'complain_sc.jsp?gubun_nm='+g_nm;
	
	if(theForm.gubun_st[1].checked == true){
		theForm.action="/fms2/m_bbs/m_bbs_sc.jsp";
		theForm.s_kd.value = theForm.gubun.value;
		theForm.t_wd.value = theForm.gubun_nm.value;
	}
	
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<form action="./complain_sc.jsp" name="ComplainSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="s_kd" value="">  
	<input type='hidden' name="t_wd" value="">  
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
			<td colspan=2>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5>고객불만사항</span></span></td>
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
						<td class=title width=8%>구분</td>
						<td width=32%>&nbsp;
							<input type='radio' name="gubun_st" value='1' <%if(gubun_st.equals("1")){%>checked<%}%>>
     				  고객불만사항
      			  <input type='radio' name="gubun_st" value='2' <%if(gubun_st.equals("2")){%>checked<%}%>>
      			  고객제안함
						</td>
						<td class=title width=8%>검색조건</td>
						<td width=52%>&nbsp;
							<select name="gubun" >
								<option value='' <%if(gubun.equals("")){%>selected<%}%>>전체</option>
								<option value='c_year' <%if(gubun.equals("c_year")){%>selected<%}%>>당해</option>
								<option value='c_mon' <%if(gubun.equals("c_mon")){%>selected<%}%>>당월 </option>
								<option value='title' <%if(gubun.equals("title")){%>selected<%}%>>제목</option>
								<option value='name' <%if(gubun.equals("name")){%>selected<%}%>>작성자</option>
								<option value='reg_dt' <%if(gubun.equals("reg_dt")){%>selected<%}%>>작성일</option>					
							</select>
						&nbsp;<input type='text' name="gubun_nm" size='30' class='text'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right"><a href="javascript:SearchComplain()"><img src="/acar/images/center/button_search.gif" align=absmiddle border=0></a></td>
		</tr>		
	</table>
</form>
</body>
</html>  