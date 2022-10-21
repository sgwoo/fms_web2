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
<!--
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

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>

<body>
<form name='form1' method='post' action='./off_ls_stat_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 매각사후관리 > <span class=style5>경매낙찰현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
          당월 
          <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
          조회기간
          &nbsp;&nbsp;
          <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          ~ 
          <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g_gy.gif align=absmiddle>&nbsp;
		  <select name='gubun1'>
          <option value='' >전체</option> 
          <option value='rt' <%if(gubun1.equals("rt")){%>selected<%}%>>렌트</option>
          <option value='ls' <%if(gubun1.equals("ls")){%>selected<%}%>>리스</option>
        </select>
		&nbsp;
          <a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
      </td>
    </tr>
    <tr> 
      <td>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='gubun'>
          <option value='all' >전체</option> 
          <option value='car_no'      <%if(gubun.equals("car_no")){	%>selected<%}%>>차량번호</option>
          <option value='car_nm'      <%if(gubun.equals("car_nm")){	%>selected<%}%>>차명</option>
          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>
          <option value='jg_code'     <%if(gubun.equals("jg_code")){	%>selected<%}%>>차종코드</option>
        </select>       
        <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()">
      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      	<img src=../images/center/arrow_gmj.gif align=absmiddle> 
        <select name="s_au" >
          <option value=""       <%if(s_au.equals("")){		%> selected <%}%>>전체</option>
			<option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>현대글로비스(주)-시화</option>
			<option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>현대글로비스(주)-분당</option>
			<option value="020385" <%if(s_au.equals("020385")){	%> selected <%}%>>에이제이셀카 주식회사</option>
			<option value="003226" <%if(s_au.equals("003226")){	%> selected <%}%>>서울오토</option>
			<option value="011723" <%if(s_au.equals("011723")){   %> selected <%}%>>서울자동차경매</option>
			<option value="013222" <%if(s_au.equals("013222")){   %> selected <%}%>>동화엠파크 주식회사</option>
			<option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>롯데렌탈(주)</option>
        </select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src=../images/center/arrow_cj.gif align=absmiddle>
        <select name="gubun2">
   		  <option value=""  <% if(gubun2.equals("")) out.print("selected"); %>>전체</option>
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
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="radio" name="gubun3" value="" <%if(gubun3.equals(""))%>checked<%%>>전체&nbsp;
		<input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>가솔린&nbsp;
		<input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>디젤&nbsp;
		<input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>일반승용LPG&nbsp;
		<input type="radio" name="gubun3" value="4" <%if(gubun3.equals("4"))%>checked<%%>>기타차종LPG&nbsp;
    </tr>
  </table>
</form>
</body>
</html>