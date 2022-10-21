<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	if(serv_id.equals(""))	serv_id = cr_db.getServ_id(car_mng_id);
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function next_serv_cng(){
	var fm = document.form1;
	if(fm.next_serv_dt.value==""){	alert("점검예정일을 입력해 주세요!"); 	fm.next_serv_dt.focus(); return; }
	if(fm.next_rep_cont.value==""){	alert("점검예정내용을 입력해 주세요!");	fm.next_rep_cont.focus(); return; }
	
	if(!confirm('해당일자로 수정 하시겠습니까?')){ return; }
	fm.action = "next_serv_cng_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="serv_id" value="<%= serv_id %>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=30%>점검예정일</td>
                    <td width=70% class='left'>&nbsp; <input name="next_serv_dt" type="text"  class="text" value="<%= AddUtil.ChangeDate2(siBn.getNext_serv_dt()) %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr> 
                    <td class='title'>점검예정내용</td>
                    <td class='left'>&nbsp; <textarea name="next_rep_cont" cols="45" rows="3"><%= siBn.getNext_rep_cont() %></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
  	    <td align="right"><a href="javascript:next_serv_cng()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>