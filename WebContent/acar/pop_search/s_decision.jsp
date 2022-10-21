<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String swd = request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String str = request.getParameter("str")==null?"":request.getParameter("str");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>결재인 검색</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		document.form1.submit();
	}
	
	function sezip(zip_str, addr_str){
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;

		if(idx != ""){
			window.opener.form1.zip[idx].value = zip_str;
			window.opener.form1.addr[idx].value = addr_str;
		}else if(str == "r"){
			window.opener.form1.t_r_site_zip.value = zip_str;
			window.opener.form1.t_r_site_addr.value = addr_str;
		}else if(str == "g"){
			window.opener.form1.t_car_mgr_zip.value = zip_str;
			window.opener.form1.t_car_mgr_addr.value = addr_str;
		}else{
			window.opener.form1.addr.focus();			
			window.opener.form1.zip.value = zip_str;
			window.opener.form1.addr.value = addr_str;
		}
		window.close();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}
	function set_decision(arg){
		opener.document.form1.decision_1.value = arg;
		this.close();
	}
-->
</script>

</head>
<body onload="javascript:document.form1.swd.focus();">
<p>
<form name='form1' action='s_zip.jsp' method='post'>

<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>
		
    <td align='left'><< 결재인 검색 >></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=300>
				<tr>
					
          <td class='title'> 성명</td>
					<td align='center'>
						<input type='text' name='swd' size='10' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            <a href='#' onMouseOver="window.status=''; return true">검색</a> 
          </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>

	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=301>
        <tr> 
          <td class='title' width='34'>연번</td>
          <td class='title' width='82'> 영업소</td>
          <td width="56" class='title'>부서</td>
          <td width="52" class='title'>직위</td>
          <td width="71" class='title'> 성명</td>
        </tr>
        <tr> 
          <td align='center'>1</td>
          <td align='center'>본사 </td>
          <td><div align="center">총무팀</div></td>
          <td><div align="center">부장</div></td> 
          <td><a href="javascript:set_decision('안보국')"><div align="center"> 안보국 </div></a></td> 
        </tr>
        <tr> 
          <td align='center'>2</td>
          <td align='center'>본사</td>
          <td><div align="center">영업팀</div></td>
          <td><div align="center">차장</div></td>
          <td><a href="javascript:set_decision('정채달')"><div align="center">정채달</div></a></td>
        </tr>
        <tr> 
          <td colspan='5'> 검색된 결과가 없습니다 </td>
        </tr>
      </table>
		</td>
	</tr>
</table>
</body>
</html>