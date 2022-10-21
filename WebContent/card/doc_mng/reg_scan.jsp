<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String cardno 	= request.getParameter("cardno")  ==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")  ==null?"":request.getParameter("buy_id");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
		function file_save(){
		var fm = document.form1;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.CARD_DOC%>";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">

  <input type='hidden' name="cardno" 	value="<%=cardno%>">
  <input type='hidden' name="buy_id" 			value="<%=buy_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>카드 영수증 스캔등록</span></span></td>
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
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              
                <tr>
                    <td class='title'>스캔파일</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=cardno%><%=buy_id%>' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.CARD_DOC%>' />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:file_save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        &nbsp;<a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
