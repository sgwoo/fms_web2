<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus0601.*"%>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	String est_st = c61_soBn.getEst_st();
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function save(){	
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
	if (!regNum.test(fm.wash_pay.value)) {
		alert("단가는 숫자로 입력해주세요.");
		fm.wash_pay.focus();
		return;
	}
	
	if (!regNum.test(fm.apply_dt.value)) {
		alert("기준일자는 - 없이 숫자로 입력해주세요.");
		fm.apply_dt.focus();
		return;
	}
	
	if(!confirm('등록 하시겠습니까?')){
		return;
	}

	fm.target="i_no";
	fm.action="cus0605_ds_i_a.jsp";
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
<input type='hidden' name='est_st' value='<%=est_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체관리 > 협력업체관리 > 세차업체관리 > <span class=style5>세차업체 계약정보등록</span></span></td>
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
					<td class='title' width="10%">
						<%if(c61_soBn.getEst_st().equals("개인")){%>
						단가
						<%}else{%>
						단가 (vat 포함)
						<%}%>
					</td>
					<td>&nbsp;<input type="text" name="wash_pay" id="wash_pay"></td>
					<td class='title' width="10%">기준일자</td>
					<td>&nbsp;<input type="text" name="apply_dt" id="apply_dt"></td>
					<td class='title' width="10%">적요</td>
					<td>&nbsp;<input type="text" name="cont_etc" id="cont_etc"></td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
    	<td class=""></td>
    </tr>
	<tr>
	  <td align='right'>
  			<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();">
	  		<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  		<div class="loaderLayer" id="loader">
		  		<div class="loader" id="loaderContent"></div>
		  	</div>
	  	</td>
	</tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="10" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>