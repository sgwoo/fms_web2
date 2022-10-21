<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");


	if (save_dt.equals("")) {
		save_dt = pk_db.getParkSaveDt(brid);
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//검색하기

	function search2(save_dt){
		var fm = document.form1
			
		fm.action = "park_sc2.jsp";
		fm.target='c_foot';
		fm.submit();
	}
		function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예비차관리 > <span class=style5>주차장현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
			<select name='s_kd'>				
			<option value='1' selected >차량번호</option>
			<option value='4'>차종</option>

			</select>
			<input type='text' name='t_wd' size='20' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> &nbsp; 
        <select name='sort_gubun'>
			<option value='5'>구분</option>
			<option value='1'>차량번호</option>
			<option value='4'>차명</option>
			<option value='3'>배기량</option>
			<option value='2'>최초등록일</option>
        </select>
        <select name='asc'>
          <option value="asc">오름차순</option>
          <option value="desc">내림차순</option>
        </select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jj.gif align=absmiddle>
		<select name='brid'>
			<!-- <option value=""<%if(br_id.equals(""))%>selected<%%>>전체</option> -->
			<option value="1"<%if(brid.equals("1"))%>selected<%%>>본사</option>
			<option value="3"<%if(brid.equals("3"))%>selected<%%>>부산</option>
			<option value="4"<%if(brid.equals("4"))%>selected<%%>>대전</option>
			<option value="5"<%if(brid.equals("5"))%>selected<%%>>광주</option>
			<option value="6"<%if(brid.equals("6"))%>selected<%%>>대구</option>
        </select>
      &nbsp;<a href="javascript:search2('<%=save_dt%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
	</tr>
    <tr>
    	<td class="h"></td>
	</tr>
</table>
</form> 
</body>
</html>

