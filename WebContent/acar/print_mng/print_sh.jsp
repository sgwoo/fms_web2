<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	
	
	Vector buss = m_db.getUserList(br_id, "bus_id2", "Y");
	int bus_size = buss.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//검색조건 선택시 해당 리스트 조회
	function getSearchList(cmd){
		var fm = document.form1;
		fm.cmd.value = cmd;
		fm.target="nodisplay";
		fm.action="print_null.jsp";		
		fm.submit();
	}
	
	//검색하기
	function search(){
		var fm = document.form1;
		fm.target="c_foot";
		fm.action="print_sc.jsp";		
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
<form name='form1' method='post' action='print_sc.jsp' target='c_foot'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="cmd" value="">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0"  width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > <span class=style5>인쇄정보</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr> 
		<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<select name='s_gubun1'>
				<option value="1" <%if(s_gubun1.equals("1")){%>selected<%}%>>세금계산서</option>
				<option value="2" <%if(s_gubun1.equals("2")){%>selected<%}%>>거래명세서</option>
			</select>&nbsp;&nbsp;
			<img src=../images/center/arrow_isgb.gif align=absmiddle> 
			<select name='s_gubun2' >
				<option value="">전체</option>
				<option value="Y" <%if(s_gubun2.equals("Y")){%>selected<%}%>>인쇄</option>
				<option value="N" <%if(s_gubun2.equals("N")){%>selected<%}%>>미인쇄</option>
			</select>&nbsp;&nbsp;		
			<img src=../images/center/arrow_bhi.gif align=absmiddle>
			<select name='s_yy'>
				<option value="">전체</option>
					<%for(int i=2004	; i<=AddUtil.getDate2(1); i++){%>
				<option value="<%=i%>" <%if(AddUtil.parseInt(s_yy) == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select>
			<select name='s_mm'>
				<option value="">전체</option>
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(AddUtil.parseInt(s_mm) == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
			</select>&nbsp;&nbsp;
				<img src=../images/center/arrow_yuddj.gif align=absmiddle>
			<select name='s_gubun3' onChange='javascript:search();'>
				<option value=''>전체</option>
				<%for (int i = 0 ; i < bus_size ; i++){
				Hashtable bus = (Hashtable)buss.elementAt(i);%>
				<option value='<%=bus.get("USER_ID")%>' <%if(s_gubun3.equals(String.valueOf(bus.get("USER_ID")))){%>selected<%}%>><%=bus.get("USER_NM")%></option>
				<%}%>
			</select>&nbsp;&nbsp;
				&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>
			<select name='s_kd'>
				<option value='' <%if(s_kd.equals("")){%>selected<%}%>>전체 </option>
				<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
				<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약자 </option>
				<!--          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>아이디</option>-->
			</select>		
				<input type='text' name='t_wd' size='10' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				<a href='javascript:search();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_search.gif" align=absmiddle border="0"></a></td>
					
				<!--입력값-->
	</tr>
</table>
</form>  
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
