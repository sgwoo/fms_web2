<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}
function Search()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}

function show_dt(arg){
	fm = document.form1;
	if(arg=='3'){
		td_blank.style.display = "none";	
		td_dt.style.display = "";
		fm.st_dt.focus();
	}else{
		td_blank.style.display = "";	
		td_dt.style.display = "none";	
	}
}
function cng_sh(){
	location.href = "./v5_sms_result_sh.jsp";
	parent.c_foot.location.href = "./v5_sms_result_sc.jsp";
}

//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./v5_sms_result_sc2.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>SMS문자전송결과(Biz5)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td width="16%" align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jhgb.gif"  border="0" align=absmiddle>&nbsp;
        <select name='gubun' onChange="javascript:cng_sh();">
          <option value='1'  >발신</option>
          <option value='2' selected >수신</option>
        </select></td>
      <td width=16%><img src="/acar/images/center/arrow_dsgb.gif"  border="0" align=absmiddle>&nbsp;
        <select name='dest_gubun'>
          <option value='' selected>전체</option>
          <option value='1' >영업사원</option>
          <option value='2' >계약자</option>
		  <option value='3' >당사직원</option>
        </select></td>
      <td width="13%"><img src="/acar/images/center/arrow_day_ss.gif"  border="0" align=absmiddle>&nbsp;
        <select name='rslt_dt' onChange="javascript:show_dt(this.value);">
          <option value=''>전체</option>
		  <option value='4' >당월</option>		
          <option value='1' selected>당일</option>
          <option value='2' >전일</option>
          <option value='3' >기간</option>
        </select></td>
      <td id="td_blank" style="display:''" width=185>&nbsp;</td>
      <td id="td_dt" style="display:none;" width=17%><input type="text" name="st_dt" size="12" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'> ~
				  <input type="text" name="end_dt" size="12" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ssj.gif"  border="0" align=absmiddle>&nbsp;&nbsp;&nbsp;
	  			<input type="text" name="dest_nm" size="10" class="text" onKeyDown="javascript:EnterDown();">
	            </td>
      <td>&nbsp;        </td>
      <td><img src="/acar/images/center/arrow_jr.gif"  border="0" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <select name='sort'>
          <option value='1' selected>발신자</option>
          <option value='2' >도착시간</option>
        </select></td>
      <td><input type="radio" name="sort_gubun" value="asc" >
오름차순
  <input type="radio" name="sort_gubun" value="desc">
내림차순</td>
      <td><a href="javascript:Search()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>