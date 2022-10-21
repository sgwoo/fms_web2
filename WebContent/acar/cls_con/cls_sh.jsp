<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
	//검색하기
	function search()
	{
		document.form1.submit();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//단어/날짜검색 여부에 따라 입력 셋팅
	function set_input()
	{
		var fm = document.form1;
		var kd = fm.s_kd.options[fm.s_kd.selectedIndex].value;
		if((kd == '4') || (kd == '5') || (kd == '6')){
			td_text.style.display = 'none';
			td_term.style.display = 'block';
		}else{
			td_text.style.display = 'block';
			td_term.style.display = 'none';
		}
	}
		
	//미해약 선택시 해양구분 전체를 디폴트로
	function set_cls_st()
	{
		var fm = document.form1;
		if(fm.r_cls[1].checked == true) 
			fm.s_cls_st.options[0].selected = true;
	}
-->
</script>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"R/W":request.getParameter("auth_rw");
	String r_cls = request.getParameter("r_cls")==null?"0":request.getParameter("r_cls");
	String s_cls_st = request.getParameter("s_cls_st")==null?"0":request.getParameter("s_cls_st");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");	
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");	
%>
<form name='form1' method='post' target='c_body' action='./cls_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">계약관리 -> </font><font color="red">중도해지관리 </font>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='400' colspan='2' align='left'>
						해약:
						<input type='radio' name='r_cls' value='0' <%if(r_cls.equals("0")){%>checked<%}%> onClick='javascript:set_cls_st()'>해약
						<input type='radio' name='r_cls' value='1' <%if(r_cls.equals("1")){%>checked<%}%> onClick='javascript:set_cls_st()'>미해약&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						해약구분:
						<select name='s_cls_st'>
							<option value='0' <%if(s_cls_st.equals("0")){%>selected<%}%>>전체	</option>
							<option value='1' <%if(s_cls_st.equals("1")){%>selected<%}%>>출고전해지 	</option>
							<option value='2' <%if(s_cls_st.equals("2")){%>selected<%}%>>중도해지 		</option>
							<option value='3' <%if(s_cls_st.equals("3")){%>selected<%}%>>출고전차종변경 </option>
							<option value='4' <%if(s_cls_st.equals("4")){%>selected<%}%>>출고후차종변경 </option>
							<option value='5' <%if(s_cls_st.equals("5")){%>selected<%}%>>영업소변경 	</option>
						</select>
					</td>
				</tr>
				<tr>
					<td width='180' align='left'>
						기타검색조건:
						<select name='s_kd' onChange='javascript:set_input()'>
							<option value='0' <%if(s_kd.equals("0")){%>selected<%}%>>전체</option>
							<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호	</option>
							<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약자	</option>
							<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
							<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>계약일 </option>
							<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>대여개시일 </option>
							<option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>해약일 </option>
							<option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>영업담당자 </option>
							<option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>계약번호 </option>
							<option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>영업소	</option>
							
<!--	정렬 : 계약일자 -->
						</select>
					</td>
					<td width='620' id='td_text' align='left'>
						<input type='text' name='t_wd' size='15' class='text' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true">검색</a>
					</td>
					<td width='620' id='td_term' style='display:none' align='left'>
						<input type='text' name='t_st_dt' size='8' class='text'>~
						<input type='text' name='t_end_dt' size='8' class='text' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true">검색</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>