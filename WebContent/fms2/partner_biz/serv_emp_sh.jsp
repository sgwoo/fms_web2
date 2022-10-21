<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getServ_empAll();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function search(){
	var fm = document.form1;
	fm.target = "c_foot";
	fm.submit();
}
function serv_off_reg(){
	var SUBWIN="serv_off_i.jsp?auth_rw=<%= auth_rw %>&gubun1=<%=gubun1%>&cmd=i";
	window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=850, height=400, scrollbars=no");
}

//리스트 엑셀 전환
function pop_excel(kd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_fin_man_excel.jsp?gubun1="+ kd;
	fm.submit();
}	


	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='serv_emp_sc.jsp' target='c_foot'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 style="vertical-align:middle">&nbsp;<span class=style1>협력업체 > 업체정보관리 > <span class=style5>업체명함관리 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
					<td colspan="2" width=14%><img src=/acar/images/center/arrow_g.gif style="vertical-align:middle">&nbsp; 
					  <select name="gubun1" style="width:100px">
                        <%for(int i=0; i<cc_r.length; i++){
        											cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode()%>" <%if(gubun1.equals(cc_bean.getCode())){%>selected<%}%>><%= cc_bean.getNm_cd() %></option>
                        <%}%>
						</select>
				    </td>
					<td width=14%><img src=/acar/images/center/arrow_gsjg.gif style="vertical-align:middle">&nbsp;
                      <select name='s_kd'>
                        <option value="1" <% if(s_kd.equals("1")){ %>selected<% } %>>상호</option>
                        <option value="2" <% if(s_kd.equals("2")){ %>selected<% } %>>사무실전화</option>
                      </select></td>
                    <td width=12%> <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                    </td>
					
                    <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">검색</a>&nbsp; 
                    <% if(!auth_rw.equals("1")){ %>
					<a href='javascript:serv_off_reg()' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">일반등록</a>
					<a href ="excel.jsp" target="_blank" title='명함리스트 엑셀 등록' class="ml-btn-4" style="text-decoration: none;">엑셀등록</a>
					<%if(gubun1.equals("0001")){%>
					<a href ="javascript:pop_excel('<%=gubun1%>' );" title='명함리스트 엑셀 저장' class="ml-btn-4" style="text-decoration: none;">엑셀저장</a>
					<% } %>
					<% } %>&nbsp;&nbsp;&nbsp;&nbsp; 
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
