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
	
	Vector cmserrorlist = cms_db.Cms_errorlist();		
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//수정
	function UserUp(){
		var theForm = document.form1;
		if(!CheckField()){ return; }
		theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;	
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;			
		if(!confirm('수정하시겠습니까?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}

	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') CheckUserID();
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
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=900>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 재무회게 > CMS > <span class=style5>CMS이체에러코드</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=900>
                <tr>			    	
                    <td class=title width=200>Error Code</td>			    	
                    <td class=title width=600>Code 명</td>			    	
				</tr>
				<% for(int i=0; i < cmserrorlist.size(); i++){
						Hashtable ec = (Hashtable)cmserrorlist.elementAt(i);
				%>
				<tr>
					<td width=200 align=center>&nbsp;<%=ec.get("ECODE")%></td>
                    <td width=600>&nbsp;<%=ec.get("ENAME")%></td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>			    	
					<td class=title width=><img src=/acar/images/center/button_reg.gif  align=absmiddle>
					<img src=/acar/images/center/button_search.gif  align=absmiddle>
					<img src=/acar/images/center/button_delete.gif  align=absmiddle>
					<img src=/acar/images/center/button_save.gif  align=absmiddle>
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