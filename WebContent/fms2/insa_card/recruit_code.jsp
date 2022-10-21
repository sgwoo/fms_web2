<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	
	String rc_gubun = request.getParameter("rc_gubun")==null?"":request.getParameter("rc_gubun");
	String rc_code = request.getParameter("rc_code")==null?"":request.getParameter("rc_code");

	InsaRcDatabase icd = new InsaRcDatabase();
	
	// 코드 리스트
	Hashtable ht = icd.getCodeCase(rc_gubun, rc_code);

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function infoCan(){ 
		opener.window.location='recruit_code_sc.jsp';
		close();
	}
	
	function deleteQf(){ 
		var theForm = document.form;
		if(!confirm('삭제하시겠습니까?')){		return;	}
	
		theForm.action = "recruit_code_up.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateQf(){ 
		var theForm = document.form;
		
		if ( theForm.rc_nm.value =="") { alert("입력값이 없습니다."); return; }	
		
		if(!confirm('저장하시겠습니까?')){		return;	}
				
		theForm.action = "recruit_code_up.jsp";
		theForm.submit();
	}
	
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form'class="form"  method='post' target='qfList'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>코드관리</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'><%if(rc_gubun.equals("1")){%>직종<%}else{%>학력조건<%}%></th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_nm" size='40' value="<%=ht.get("RC_NM")==null?"":ht.get("RC_NM") %>"/></td>	        		              		
	        	</tr>	        	
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
                <input type="hidden" name="rc_gubun" value="<%=rc_gubun%>">
        		<input type="hidden" name="rc_code" value="<%=rc_code%>">
				<button value="<%=rc_code%>" style="float:right;" onclick="infoCan();" >닫기</button>
				<button onclick="updateQf();" value="<%=rc_code%>" style="float:right;">저장</button>	
				<button onclick="deleteQf();" value="<%=rc_code%>" style="float:right;">삭제</button>				
        </td>
    </tr>            
  </table>
</form>
</body>
</html>
