<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String wash_user_nm = request.getParameter("wash_user_nm")==null?"":request.getParameter("wash_user_nm");
	String wash_user_id = request.getParameter("wash_user_id")==null?"":request.getParameter("wash_user_id");
	String wash_user_zip = request.getParameter("wash_user_zip")==null?"":request.getParameter("wash_user_zip");
	String wash_user_addr = request.getParameter("wash_user_addr")==null?"":request.getParameter("wash_user_addr");
	String wash_user_enter_dt = request.getParameter("wash_user_enter_dt")==null?"":request.getParameter("wash_user_enter_dt");
	String wash_user_end_dt = request.getParameter("wash_user_end_dt")==null?"":request.getParameter("wash_user_end_dt");
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
/* $(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
	
}); */

function save(){	
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
	if (!regNum.test(fm.wash_user_id.value)) {
		alert("연락처는 - 없이 숫자로 입력해주세요.");
		fm.wash_user_id.focus();
		return;
	}
	
	if(!confirm('등록 하시겠습니까?')){
		return;
	}

	fm.target="i_no";
	fm.action="cus0605_dm_i_a.jsp";	
	fm.submit();	
	
	fn_layer_popup();
}

function modify() {
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
	if (!regNum.test(fm.wash_user_id.value)) {
		alert("연락처는 - 없이 숫자로 입력해주세요.");
		fm.wash_user_id.focus();
		return;
	}

	fm.target="i_no";
	fm.action="cus0605_dm_i_a.jsp";	
	fm.submit();	
	
	fn_layer_popup();
}

function Close() {
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}


function fn_layer_popup(){  
	var layer = document.getElementById("loader");	
	var layerContent = document.getElementById("loaderContent");	
	layer.style.visibility="visible"; 
	layerContent.style.animation="spin 0.8s linear infinite"; 
}

//-->
</script>
<style>
.loaderLayer {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0px;
  left: 0px;
  visibility: hidden;
  background-color: rgba(112, 113, 102, 0.3);
}
.loader {
  position: absolute;
  top: 45%;
  left: 50%;
  z-index: 1;
  border: 8px solid #f3f3f3;
  border-radius: 50%;
  border-top: 8px solid #3498db;
  width: 30px;
  height: 30px;
  /* -webkit-animation: spin 1s linear infinite; */
  /* animation: spin 0.8s linear infinite; */
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.input_box {width: 100px;}
</style>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>
<input type="hidden" name="seq" value="<%=seq%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<%if(seq == 0) {%>						
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체관리 > 협력업체관리 > 세차업체관리 > <span class=style5>세차업체 직원등록</span></span></td>					
					<%}else {%>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체관리 > 협력업체관리 > 세차업체관리 > <span class=style5>세차업체 직원수정</span></span></td>																
					<%}%>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr>
					<td class='title' width="10%">성명</td>
					<td width="40%">
						<%if(seq == 0) {%>
							&nbsp;<input type="text" name="wash_user_nm" id="wash_user_nm">
						<%}else {%>
							&nbsp;<input type="text" name="wash_user_nm" id="wash_user_nm" value="<%=wash_user_nm%>">
						<%}%>
					</td>					
				</tr>
				<tr>
					<td class='title' width="10%">연락처</td>
					<td width="40%">
						<%if(seq == 0) {%>
							&nbsp;<input type="text" name="wash_user_id" id="wash_user_id">
						<%}else {%>												
							&nbsp;<input type="text" name="wash_user_id" id="wash_user_id" value="<%=wash_user_id%>">
						<%}%>
					</td>
				</tr>
				<tr>
					<td class='title'>주소</td>
					<td>
						<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('wash_user_zip').value = data.zonecode;
										document.getElementById('wash_user_addr').value = data.address +" ("+ data.buildingName+")";										
									}
								}).open();
							}
						</script>
						<%if(seq == 0) {%>
							&nbsp;<input type="text" name="wash_user_zip" id="wash_user_zip" size="7" maxlength='7'>
						<%}else {%>
							&nbsp;<input type="text" name="wash_user_zip" id="wash_user_zip" size="7" maxlength='7' value="<%=wash_user_zip%>">
						<%}%>						
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						<%if(seq == 0) {%>
							&nbsp;<input type="text" name="wash_user_addr" id="wash_user_addr" size="71" style="margin-top: 5px;">
						<%}else {%>
							&nbsp;<input type="text" name="wash_user_addr" id="wash_user_addr" size="71"  value="<%=wash_user_addr%>" style="margin-top: 5px;">
						<%}%>						
					</td>
				</tr>
				<tr>
					<td class='title'>입사일자</td>
					<td>
						<%if(seq == 0) {%>
							&nbsp;<input type="text" name="wash_user_enter_dt" id="wash_user_enter_dt">
						<%}else {%>
							&nbsp;<input type="text" name="wash_user_enter_dt" id="wash_user_enter_dt" value="<%=wash_user_enter_dt%>">
						<%}%>						
					</td>
				</tr>
				<%if(seq != 0) {%>
				<tr>
					<td class='title'>퇴사일자</td>
					<td>
						&nbsp;<input type="text" name="wash_user_end_dt" id="wash_user_end_dt" value="<%=wash_user_end_dt%>">
					</td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>
		<tr>
    	<td class=""></td>
    </tr>
	
	<tr>
	  <td align='right'>
	  		<% if (seq == 0) {%>
	  			<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();">
			<% } else { %>
				<img src="/acar/images/center/button_modify.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="modify();">
			<% }%>
	  		<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  		<div class="loaderLayer" id="loader">
		  		<div class="loader" id="loaderContent"></div>
		  	</div>
	  	</td>
	</tr>
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>