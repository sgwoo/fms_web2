<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(s_st){
		var fm = document.form1;
		fm.s_st.value = s_st;
		fm.action="ins_p_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form action="./ins_p_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 사고 및 보험 > 보험관리 > <span class=style5>보험기간비용조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan=3 class=h></td>
    </tr>
    <tr> 
        <td width=150>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
            <select name="gubun1">
              <option value=""  <%if(gubun1.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
            </select>
        </td>	
        <td width="350"><img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;  
            <select name="s_kd">
              <option value="1" <%if(s_kd.equals("1")){%>selected<%}%>>차량번호</option>
              <option value="2" <%if(s_kd.equals("2")){%>selected<%}%>>해지환급청구일</option>
              <option value="3" <%if(s_kd.equals("3")){%>selected<%}%>>해지발생사유일</option>			  
              <option value="4" <%if(s_kd.equals("4")){%>selected<%}%>>가입변경일</option>
			  <option value="5" <%if(s_kd.equals("5")){%>selected<%}%>>보험시작일</option>
			  <option value="6" <%if(s_kd.equals("6")){%>selected<%}%>>차액</option>
            </select>
			&nbsp;&nbsp;&nbsp;  
            <input type="text" name="t_wd" size="15" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
        </td>
        <td width="350"><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%>selected<%}%>>차량번호</option>
              <option value="2" <%if(sort.equals("2")){%>selected<%}%>>보험시작일</option>
              <option value="3" <%if(sort.equals("3")){%>selected<%}%>>보험만료일</option>
              <option value="4" <%if(sort.equals("4")){%>selected<%}%>>해지환급청구일</option>
              <option value="5" <%if(sort.equals("5")){%>selected<%}%>>해지발생사유일</option>			  
              <option value="6" <%if(sort.equals("6")){%>selected<%}%>>가입변경일</option>
            </select>
            <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
            오름차순 
            <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onclick='javascript:Search(3)'>
            내림차순 </td>
        <td><a href="javascript:Search(3)"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
</table>
</form>
</body>
</html>