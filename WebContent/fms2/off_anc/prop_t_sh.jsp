<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*,  acar.off_anc.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	//prop_bbs에서 심사일 조회하기
	Vector vt2 = p_db.getEvalDate();
	int vt_size2 = vt2.size();	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
	

	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body onlp_db="javascript:document.form1.t_wd.focus()">
<form action="./prop_t_sc.jsp" name="form1" method="POST" target="c_foot">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>
						제안현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
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
				<tr>
					<td class=title width=10%>제안일자</td>
					<td width=40%>&nbsp;
						<select name='gubun1'>
							<option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>당일</option>
							<option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당월</option>
							<option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>전월</option>
							<option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>당해</option>
							<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>기간 </option>
						</select>
						&nbsp;
						<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
							~ 
						<input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
					</td>		
					<td class=title width=10%>검색조건</td>
					<td width=40%>&nbsp;
						<select name='s_kd'>
						<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>제목</option>
						<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>내용 </option>
						<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>등록자</option>
						</select>
						&nbsp;
						<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>상태</td>
					<td colspan="3">&nbsp;
						<input type='radio' name="gubun2" value='1' <%if(gubun2.equals("1")){%>checked<%}%>>채택
						<input type='radio' name="gubun2" value='4' <%if(gubun2.equals("4")){%>checked<%}%>>수정채택
						<input type='radio' name="gubun2" value='3' <%if(gubun2.equals("3")){%>checked<%}%>>업무시정채택
						<!--<input type='radio' name="gubun2" value='2' <%if(gubun2.equals("2")){%>checked<%}%>>불채택 -->
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>   
	
</table>
</form>
</body>
</html>