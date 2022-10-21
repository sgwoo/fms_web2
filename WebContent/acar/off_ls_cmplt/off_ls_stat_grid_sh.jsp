<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
 
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
	String deep_yn 	= request.getParameter("deep_yn")		==null?"":request.getParameter("deep_yn");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
	function EnterDown()
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search()
	{
		var theForm = document.form1;
		theForm.target = "c_foot";
		theForm.submit();
	}
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
			theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2")
		{
			theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}
	}
	
	function cng_dt(){
		var fm = document.form1;
		if(fm.dt.options[fm.dt.selectedIndex].value == '3'){ //기간
			esti.style.display 	= '';
		}else{
			esti.style.display 	= 'none';
		}
	}
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>

<body>
<form name='form1' method='post' action='./off_ls_stat_grid_sc.jsp'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'> 
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
			<td colspan="4">
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;
							<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 >매각사후관리 > <span class=style5>경매낙찰현황(grid)</span></span>
						</td>
						<td width=7>
							<img src=../images/center/menu_bar_2.gif width=7 height=33>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h colspan="4"></td>
		</tr>
		<tr>
			<td width="100px">&nbsp;&nbsp;
				<select name="dt" onChange='javascript:cng_dt()'>
					<option value='2' <%if(dt.equals("2")){%> selected <%}%>>당월</option>
					<option value='4' <%if(dt.equals("4")){%> selected <%}%>>당해</option>
					<option value='1' <%if(dt.equals("1")){%> selected <%}%>>전월</option>
					<option value='3' <%if(dt.equals("3")){%> selected <%}%>>조회기간</option>
				</select>
				
			</td>
			<td width="175px" id="esti" style="display:none;"> 
				<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')"> ~ 
				<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
			</td>
			<!-- <td width="150px"> -->
			<td width="120px">
				<img src=../images/center/arrow_g_gy.gif align=absmiddle>&nbsp; 
				<select name='gubun1'>
					<option value=''>전체</option>
					<option value='rt' <%if(gubun1.equals("rt")){%> selected <%}%>>렌트</option>
					<option value='ls' <%if(gubun1.equals("ls")){%> selected <%}%>>리스</option>
				</select> &nbsp;  
			</td>
			<td>
				<img src=../images/center/arrow_cj.gif align=absmiddle> 
				<select name="gubun2">
					<option value="" <% if(gubun2.equals("")) out.print("selected"); %>>전체</option>
					<option value="8" <% if(gubun2.equals("8")) out.print("selected"); %>>소형승용(LPG)</option>
					<option value="5" <% if(gubun2.equals("5")) out.print("selected"); %>>중형승용(LPG)</option>
					<option value="4" <% if(gubun2.equals("4")) out.print("selected"); %>>대형승용(LPG)</option>
					<option value="9" <% if(gubun2.equals("9")) out.print("selected"); %>>경승용</option>
					<option value="3" <% if(gubun2.equals("3")) out.print("selected"); %>>소형승용</option>
					<option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>중형승용</option>
					<option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>대형승용</option>
					<option value="6" <% if(gubun2.equals("6")) out.print("selected"); %>>RV</option>
					<option value="10" <% if(gubun2.equals("10")) out.print("selected"); %>>승합</option>
					<option value="7" <% if(gubun2.equals("7")) out.print("selected"); %>>화물</option>
					<option value="20" <% if(gubun2.equals("20")) out.print("selected"); %>>수입차</option>
				</select>&nbsp;
				&nbsp;
				딥러닝 :
				<select name='deep_yn'>
					<option value=''>전체</option>
					<option value='N' <%if(deep_yn.equals("N")){%> selected <%}%>>미분석차량</option>
					<option value='Y' <%if(deep_yn.equals("Y")){%> selected <%}%>>분석차량</option>
				</select>
					
				<a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
			</td>
		</tr>
	</table>
</form>
</body>
</html>