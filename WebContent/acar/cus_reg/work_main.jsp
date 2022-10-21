<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	//String wm_id = request.getParameter("wm_id")==null?"":request.getParameter("wm_id");
	String wm_nm = request.getParameter("wm_nm")==null?"":request.getParameter("wm_nm");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	Vector works = cr_db.getWork_main(car_mng_id, wm_nm);
		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search_title();
	}
function getWork_sub(){
	fm = document.form1;	
	var wm_id = fm.work.options[fm.work.selectedIndex].value;
	parent.inner2.location.href = "work_sub.jsp?car_mng_id=<%= car_mng_id %>&wm_id="+wm_id;
}
function getWork_part(){
	fm = document.form1;
	var wm_id = fm.work.options[fm.work.selectedIndex].value;
	fm.target = "inner3";
	fm.action = "work_part.jsp?car_mng_id=<%= car_mng_id %>&wm_id="+wm_id;
	fm.submit();
}
function search_title(){
	fm = document.form1;
	var wm_nm = fm.wm_nm.value;
	parent.inner1.location.href = "work_main.jsp?car_mng_id=<%= car_mng_id %>&wm_nm="+wm_nm;
}
function item_sel(wk_st){
	fm = document.form1;
	if(wk_st=='R')		name = '탈착';
	else if(wk_st=='X')	name = '교환';
	else if(wk_st=='B')	name = '판금';
	else if(wk_st=='A')	name = '조정';
	else if(wk_st=='O')	name = '오버홀';
	else if(wk_st=='S')	name = '수리';
	
	parent.inner4.form1.item_st.value = '주작업';
	parent.inner4.form1.item_id.value = fm.work.options[fm.work.selectedIndex].value;
	parent.inner4.form1.item.value = fm.work.options[fm.work.selectedIndex].text;
	parent.inner4.form1.wk_st.value = name;
}
//-->
</script>
</head>

<body onload="document.form1.wm_nm.focus()">
<form name="form1" action="" method="post">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line align="right">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF"> 
                    <td class=title width="50%">주체작업 </td>
                    <td class=title width="50%"> <input type="text" name="wm_nm" size="16" class="text" style='IME-MODE: active' onKeyDown="javascript:enter()"> 
                      <a href="javascript:search_title();" ><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
                <% if(works.size()>0){%>
                <tr bgcolor="#FFFFFF"> 
                    <td><select name="work" multiple size="17" onChange="javascript:getWork_sub();getWork_part();">
                        <%for(int i=0; i<works.size(); i++){
        					Hashtable work = (Hashtable)works.elementAt(i); %>
                        <option value="<%= work.get("WM_ID") %>"><%= work.get("WM_NM") %></option>
                        <% } %>
                      </select></td>
                    <td><div align="center">
                        <table width="99%" height="205" border="0" cellpadding="0" cellspacing="1">
                          <% if(works.size()>0){%>
                          <tr bgcolor="#FFFFFF"> 
                            <td width="50%"><div align="center"><a href="javascript:item_sel('R');"><img src=../images/center/button_tc.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td><div align="center"><a href="javascript:item_sel('X');"><img src=../images/center/button_gh.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td><div align="center"><a href="javascript:item_sel('B');"><img src=../images/center/button_pg.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td><div align="center"><a href="javascript:item_sel('A');"><img src=../images/center/button_joj.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td><div align="center"><a href="javascript:item_sel('O');"><img src=../images/center/button_overhall.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td> <div align="center"><a href="javascript:item_sel('S');"><img src=../images/center/button_sr.gif border=0 align=absmiddle></a></div></td>
                          </tr>
                          <%}else{ %>
                          <% } %>
                        </table>
                    </div>
                    </td>
                </tr>
                <%}else{ %>
                <tr bgcolor="#FFFFFF"> 
                    <td colspan="2" align=center>해당 주체작업이 없습니다.</td>
                </tr>
                <% } %>
            </table>
        </td>
    </tr>
    <tr>		
        <td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>