<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String wm_id = request.getParameter("wm_id")==null?"":request.getParameter("wm_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	Vector works = cr_db.getWork_sub(car_mng_id,wm_id);
		
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
function getWork_part(){
	fm = document.form1;
	var ws_id = fm.work.options[fm.work.selectedIndex].value;
	fm.target = "inner3";
	fm.action = "work_part.jsp?car_mng_id=<%= car_mng_id %>&wm_id=<%= wm_id %>&ws_id="+ws_id;
	fm.submit();
}
function item_sel(wk_st){
	fm = document.form1;
	if(wk_st=='R')		name = '탈착';
	else if(wk_st=='X')	name = '교환';
	else if(wk_st=='B')	name = '판금';
	else if(wk_st=='A')	name = '조정';
	else if(wk_st=='O')	name = '오버홀';
	else if(wk_st=='S')	name = '수리';
	
	parent.inner4.form1.item_st.value = '부수';
	parent.inner4.form1.item_id.value = fm.work.options[fm.work.selectedIndex].value;
	parent.inner4.form1.item.value = fm.work.options[fm.work.selectedIndex].text;
	parent.inner4.form1.wk_st.value = name;
}
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line align="center">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF"> 
                    <td class=title width="100%">부수작업</td>
                </tr>
                <% if(works.size()>0){%>
                <tr bgcolor="#FFFFFF">
                    <td><select name="work" multiple size="6" onChange="javascript:getWork_part()">
    			  	<%for(int i=0; i<works.size(); i++){
    					Hashtable work = (Hashtable)works.elementAt(i); %>			
                    <option value="<%= work.get("WS_ID") %>"><%= work.get("WS_NM") %></option>
    				<% } %>
                  </select></td>
                </tr>
              <%}else{ %>
                <tr bgcolor="#FFFFFF" align=center> 
                    <td>해당 부수작업이 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
	<tr>
		<td><a href="javascript:item_sel('R');"><img src=../images/center/button_tc.gif border=0 align=absmiddle></a>
				<a href="javascript:item_sel('X');"><img src=../images/center/button_gh.gif border=0 align=absmiddle></a> <a href="javascript:item_sel('B');"><img src=../images/center/button_pg.gif border=0 align=absmiddle></a>
				<a href="javascript:item_sel('A');"><img src=../images/center/button_joj.gif border=0 align=absmiddle></a> <a href="javascript:item_sel('O');"><img src=../images/center/button_overhall.gif border=0 align=absmiddle></a>
				<a href="javascript:item_sel('S');"><img src=../images/center/button_sr.gif border=0 align=absmiddle></a></td>
	</tr>	
</table>
</form>
</body>
</html>
