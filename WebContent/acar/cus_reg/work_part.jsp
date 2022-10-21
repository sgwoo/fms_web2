<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String wm_id = request.getParameter("wm_id")==null?"":request.getParameter("wm_id");
	String ws_id = request.getParameter("ws_id")==null?"":request.getParameter("ws_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	Vector parts = cr_db.getWork_part(car_mng_id,wm_id,ws_id);
		
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
function part_sel(){
	fm = document.form1;
	parent.inner4.form1.item_st.value = '부품';
	parent.inner4.form1.item_id.value = fm.part.options[fm.part.selectedIndex].value;
	parent.inner4.form1.item.value = fm.part.options[fm.part.selectedIndex].text;
	parent.inner4.form1.wk_st.value = '';
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
                    <td class=title width="100%">부품 내역</td>
                </tr>
                <% if(parts.size()>0){%>
                <tr bgcolor="#FFFFFF">
                    <td><select name="part" multiple size="6" ondblclick="javascript:part_sel();">
    			  	<%for(int i=0; i<parts.size(); i++){
    					Hashtable part = (Hashtable)parts.elementAt(i); %>			
                    <option value="<%= part.get("WP_ID") %>"><%= part.get("WP_NM") %></option>
    				<% } %>
                  </select></td>
                </tr>
                <%}else{ %>
                <tr align=center> 
                    <td>해당 부품이 없습니다.</td>
                </tr>
            <% } %>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
