<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//검색조건 선택시 해당 리스트 조회
	
	//검색하기
	function search(){
		var fm = document.form1;
		fm.target="c_foot";
		fm.action="partner_s_sc.jsp";		
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='partner_s_sc.jsp' target='c_foot'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="cmd" value="">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1> 협력업체 > 협력업체로그인 > <span class=style5>담당자관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h colspan=2></td>
	</tr>
	<tr> 
		<td align='left'>
				&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>
			    &nbsp;<select name='s_kd'>
				<option value='' <%if(s_kd.equals("")){%>selected<%}%>>전체 </option>
				<option value='JMJP' <%if(s_kd.equals("JMJP")){%>selected<%}%>>재무제표</option>
				<option value='보험료' <%if(s_kd.equals("보험료")){%>selected<%}%>>보험료 </option>				
			</select>	
			 &nbsp;<select name='use_yn'>
				<option value='' <%if(use_yn.equals("")){%>selected<%}%>>전체 </option>
				<option value='Y' <%if(use_yn.equals("Y")){%>selected<%}%>>Y</option>
				<option value='N' <%if(use_yn.equals("N")){%>selected<%}%>>N </option>				
			</select>	
              	
			<!--	<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> -->		
					<a href='javascript:search();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
				<!--입력값-->
	</tr>
</table>
</form>  
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
