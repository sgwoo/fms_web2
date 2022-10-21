<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cms.*" %>
<jsp:useBean id="cms_db" scope="page" class="acar.cms.CmsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	Vector cmsbanklist = cms_db.Cms_banklist();	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	
		function GetUpd(bcode, bname, c_code, reg_dt){
		var fm = parent.document.form1;
		fm.bcode.value = bcode;					
		fm.bname.value = bname;
		fm.c_code.value = c_code;
		fm.reg_dt.value = reg_dt;
	}
	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<center>
<form action="./bank_code_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr>
        <td class=line2></td>
    </tr>			
   
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>			    	
                    <td class=title width=200>이체은행코드</td>			    	
                    <td class=title width=500>이체은행명칭</td>			
                    <td class=title width=200>FMS은행코드</td>		    	
				</tr>
				<% for(int i=0; i < cmsbanklist.size(); i++){
						Hashtable cb = (Hashtable)cmsbanklist.elementAt(i);
				%>
				<tr>
					<td width=200 align=center>&nbsp;<a href="javascript:GetUpd('<%=cb.get("BCODE")%>','<%=cb.get("BNAME")%>','<%=cb.get("C_CODE")%>', '<%=AddUtil.getDate(1)%>')" onMouseOver="window.status=''; return true"><%=cb.get("BCODE")%></a></td></td>
                <td width=500>&nbsp;<%=cb.get("BNAME")%></td>
                <td width=200>&nbsp;<%=cb.get("C_CODE")%></td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>