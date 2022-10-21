<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		
		fm.action="exp_reg_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
		
	
//-->
</script>

</head>
<body>
<form action="./exp_reg_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 영업비용관리 ><span class=style5>자동차등록비용처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gggub.gif align=absmiddle>
        &nbsp;<select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>등록일&nbsp;</option>
        </select>	
		    &nbsp;<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
        </td>
    </tr>    
    <tr> 
        <td width=370>
            <table width="100%" cellspacing=0 border="0" cellpadding="0">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>
                      &nbsp;&nbsp;<select name="s_kd" >
                        <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체&nbsp;&nbsp;&nbsp;</option>
                        <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호&nbsp;&nbsp;&nbsp;</option>
                      </select>
              		  &nbsp;<input type="text" name="t_wd" size="30" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
      	            </td>
                </tr>
            </table>
        </td>
        <td width=285><img src=../images/center/arrow_jrjg.gif align=absmiddle>
            &nbsp;<select name="sort">
              <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
              <option value="5" <%if(sort.equals("5")){%> selected <%}%>>등록일</option>
              <option value="6" <%if(sort.equals("6")){%> selected <%}%>>차량번호</option>
            </select>
            <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
            오름차순 
            <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
            내림차순 </td>
        <td>&nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>    
</table>
</form>
</body>
</html>
