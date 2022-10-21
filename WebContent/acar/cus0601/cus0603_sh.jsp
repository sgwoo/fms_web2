<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function search(){
	var fm = document.form1;
	fm.submit();
}
function serv_off_reg(){
	var SUBWIN="cus0603_d_cont_i.jsp?auth_rw=<%= auth_rw %>?from_page=<%= from_page %>?off_type=2";
	window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=920, height=450, scrollbars=no");
}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='cus0603_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 업체정보관리 > <span class=style5>납품업체관리</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="173">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>
                      &nbsp;<select name='s_kd'>
                        <option value="1" <% if(s_kd.equals("1")){ %>selected<% } %>>상호</option>
                        <option value="0" <% if(s_kd.equals("0")){ %>selected<% } %>>전체</option>
                        <option value="4" <% if(s_kd.equals("4")){ %>selected<% } %>>대표자</option>
                        <option value="5" <% if(s_kd.equals("5")){ %>selected<% } %>>사업자번호</option>
                        <option value="6" <% if(s_kd.equals("6")){ %>selected<% } %>>업태</option>
                        <option value="7" <% if(s_kd.equals("7")){ %>selected<% } %>>종목</option>
                        <option value="8" <% if(s_kd.equals("8")){ %>selected<% } %>>주소</option>
                    </select></td>
                    <td width="77"><input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                    </td>
                    <td width="160">&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jrjg.gif align=absmiddle>
                      <select name='sort_gubun'>
                        <option value="0" <% if(sort_gubun.equals("0")){ %>selected<% } %>>상호</option>
                        <option value="1" <% if(sort_gubun.equals("1")){ %>selected<% } %>>대표자</option>
                        <option value="2" <% if(sort_gubun.equals("2")){ %>selected<% } %>>사업자번호</option>
                        <option value="3" <% if(sort_gubun.equals("3")){ %>selected<% } %>>주소</option>                        
                      </select> </td>
                    <td width="165"> <input type='radio' name='sort' value='asc' <% if(sort.equals("asc")||sort.equals("")){ %>checked<% } %> onClick='javascript:search()'>
                      오름차순 
                      <input type='radio' name='sort' value='desc' <% if(sort.equals("desc")){ %>checked<% } %> onClick='javascript:search()'>
                      내림차순 </td>
                    <td width="145" align='left'><img src=../images/center/arrow_yus.gif align=absmiddle>
        			<select name='br_id'>
        				<option value=''>전체</option>
        				<%	if(brch_size > 0){
        							for (int i = 0 ; i < brch_size ; i++){
        								Hashtable branch = (Hashtable)branches.elementAt(i);%>
        				<option value='<%= branch.get("BR_ID") %>'  <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
        				<%= branch.get("BR_NM")%> </option>
        				<%							}
        						}		%>
        			</select></td>
                    <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif align=absmiddle border=0></a>
                      <%// if(!auth_rw.equals("1")){ %><a href='javascript:serv_off_reg()' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif align=absmiddle border=0><%// } %></a>&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
