<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String col_st 		= request.getParameter("col_st")==null?"":request.getParameter("col_st");
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_u_seq 	= request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq");
	String car_c_seq 	= request.getParameter("car_c_seq")==null?"":request.getParameter("car_c_seq");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String use_yn 		= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	
	//자동차회사 리스트
	CarCompBean cc_r [] = umd.getCarCompAll();
	
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.title {height:33px !important;}
select {
	width: 220px !important;
	font-size: 13px !important;
	font-weight: bold;
}
.input {
	padding-left: 4px;
}
.title{ padding : 5px 0px 1px 0px; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">

	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	//로딩시 자동차회사=현대의 차종코드 출력하기
	function init(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = '<%=car_comp_id%>';
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	function CarNmReg(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}	
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.car_c_dt.value = "<%=AddUtil.ChangeString(AddUtil.getDate())%>";
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.submit();
	}
	
	function downloadExcel(){
		var theForm = document.form1;
		var SUBWIN="car_col_excel.jsp?";		
		window.open(SUBWIN, "CarColExcel", "left=0, top=0, width=1050, height=700, scrollbars=yes, status=yes, resizable=yes");
	}

	function CarNmUp(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(theForm.car_c_seq.value == ''){ alert('아직 등록되지 않은 색상입니다.');}
		if(!confirm('수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}

	function CarNmDel(){
		var theForm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.submit();
	}

	function Search(){
		var fm = document.form1;
		var fm2 = document.SearchCarNmForm;
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;
		fm2.use_yn.value = fm.use_yn.value;
		fm2.col_st.value = fm.col_st.value;
		
		if(fm.code.value==""){
			alert("차명을 선택해주세요.");
			fm.code.focus();
			return false;
		}
		//fm2.car_u_seq.value = fm.view_dt.value.substr(0,2);		
		//fm2.view_dt.value = fm.view_dt.value.substr(2);
		
		fm2.target="i_in";
		fm2.submit();
	}

	function CheckField(){
		var theForm = document.form1;
		if(theForm.car_comp_id.value==""){
			alert("자동차회사를 선택해주세요.");
			theForm.car_comp_id.focus();
			return false;
		}
		if(theForm.code.value==""){
			alert("차명을 선택해주세요.");
			theForm.code.focus();
			return false;
		}
		if(theForm.car_c.value==""){
			alert("색상을 입력해주세요.");
			theForm.car_d.focus();
			return false;
		}
		if(theForm.col_st.value==""){
			alert("내장 / 외장을 구분해주세요.");
			theForm.col_st.focus();
			return false;
		}
		if(theForm.car_c_p.value==""){
			alert("금액을 입력해주세요.");
			theForm.car_d_p.focus();
			return false;
		}
		if(theForm.car_c_dt.value==""){
			alert("등록일자가 없습니다. 새로고침 해주세요.");
			theForm.car_c_dt.focus();
			return false;
		}				
		return true;
	}
	
	function ColTrim(){	//트림별 외장 색상 관리
		var fm=document.form1;
		var fm2 = document.form2;
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		
		if(fm.code.value==""){
			alert("차명을 선택해주세요.");
			fm.code.focus();
			return false;
		}
		
		var SUBWIN="./car_col_trim.jsp?auth_rw="+fm2.auth_rw.value+"&car_comp_id="+fm2.car_comp_id.value+"&code="+fm2.code.value;
		window.open(SUBWIN, "ColTrimSelect", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes, resizable=no");
	}
	
	function ColImgReg(){	//색상 이미지 등록 및 삭제
		var fm=document.form1;
		var fm2 = document.form2;
		
		if(fm.code.value==""){
			alert("차명을 선택해주세요.");
			theForm.code.focus();
			return false;
		}

		if(fm.car_c.value==""  || fm.car_c_seq.value=="" || fm.car_u_seq.value==""){
			alert("색상을 선택해주세요.");
			theForm.car_d.focus();
			return false;
		}
		
		if(fm.col_st.value!="1"){
			alert("색상 이미지는 외장만 입력할 수 있습니다");
			fm.col_st.focus();
			return false;
		}
				
		var SUBWIN="./car_col_trim_img.jsp?auth_rw="+fm2.auth_rw.value+"&car_comp_id="+fm.car_comp_id.value+"&code="+fm.code.value+"&car_u_seq="+fm.car_u_seq.value+"&car_c_seq="+fm.car_c_seq.value+"&car_c="+fm.car_c.value;
		window.open(SUBWIN, "ColImgSelect", "left=100, top=100, width=400, height=200, scrollbars=no, status=yes, resizable=no");
	}

	//색상표등록
	function reg_col_catalog(){
		var car_comp_id = form1.car_comp_id.value;
		var car_code = form1.code.value;
		var content_seq = car_comp_id + '^' + car_code + '^';
		var content_code = 'CAR_COL_CAT';
		
		if(car_code=='' || car_code==null){	alert("차명을 선택해주세요."); 	return;		}
		window.open("car_col_catalog_scan.jsp?content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=10, top=10, width=720, height=200, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function AllSelect(){
		var frame =document.getElementById('i_in');
		var child_document = frame.contentDocument;
		var fm = document.form1;
		var child_fm = child_document.CarNmForm;
		
		var check_val = child_document.getElementsByName('check_value');
		var check_val_length = child_document.getElementsByName('check_value').length;
		
		if (fm.ch_all.checked == true) {
			for (var i=0; i < check_val_length; i++) {
				if (check_val_length == 1) {
					child_fm.check_value.checked = true;
				} else {
					child_fm.check_value[i].checked = true;
				}
			}
		} else {
			for (var i=0; i<check_val_length; i++) {
				if (check_val_length == 1) {
					child_fm.check_value.checked = false;
				} else {
					child_fm.check_value[i].checked = false;
				}
			}
		}
		
		for(var i=0; i<len; i++){
			var ck = elements[i];
			if(ck.name == 'check_value'){
				++cnt;
			}
		}
		
	}
</script>
</head>
<body leftmargin="15"  onLoad="javascript:init()">

<form action="./car_col_null_ui.jsp" name="form1" method="POST" >
	<table border=0 cellspacing=0 cellpadding=0 width="900">
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td class="navigation">&nbsp;<span class=style1>MASTER> <span class=style5>색상관리</span>
						</span></td>
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
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
					<tr>
						<td align="right" class=title width="12%">자동차회사</td>
						<td width="33%">&nbsp; 
							<select name="car_comp_id"onChange="javascript:GetCarCode()" class="select">
									<%for(int i=0; i<cc_r.length; i++){
		        						        cc_bean = cc_r[i];%>
									<option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%> selected <%%>><%= cc_bean.getNm() %></option>
									<%	}	%>
							</select>
						</td>
						<td align="right" class=title width="12%">차명</td>
						<td width="*">&nbsp; 
							<select name="code" class="select">
									<option value="">전체</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right" class=title>구분</td>
						<td>&nbsp; 
							<select name="col_st" class="select">
								<option value="">내/외장/가니쉬</option>
								<option value="1">외장</option>
								<option value="2">내장</option>
								<option value="3">가니쉬</option>
							</select>
						</td>
						<td align="right" class=title>사용 / 미사용</td>
						<td>&nbsp; 
							<select name="use_yn" class="select">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
							</select>&nbsp;
						<input type="button" class="button" value="검색" onclick="javascript:Search();">
						</td>
					</tr>
					<tr>
						<td align="right" class=title>색상</td>
						<td colspan="3">&nbsp;
							<input type="hidden" name="car_c_seq" value=""> 
							<input type="text" name="car_c" id="car_c" value="" size="38" class="input" placeholder="&#39; &#34; &#60; &#62; 등의 특수문자는 입력이 불가능 합니다.">
							&nbsp;<input type="button" class="button btn-submit" value="색상 이미지 등록 및 삭제" onclick="javascript:ColImgReg();"> 
						</td>
					</tr>
					<tr>
						<td align="right" class=title>금액</td>
						<td >&nbsp; 
							<input class="input" name="car_c_p" value="" size="10" style="text-align: right;" onBlur='javascript:this.value=parseDecimal(this.value);'> 원
						</td>					
						<td align="right" class=title>조정잔가</td>
						<td colspan="3">&nbsp; 
							<input type="text" name="jg_opt_st" value="" size="5" class="input">
						</td>
					</tr>
					<tr>
						<td align="right" class=title>비고</td>
						<td colspan="3">&nbsp;
							<input type="text" name="etc" value="" size="60" class="input">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
			<td align="right">
			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				<input type="button" class="button" value="Excel" onclick="javascript:downloadExcel();"> <%}%> 
			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				<input type="button" class="button" value="등록" onclick="javascript:CarNmReg();"> <%}%> 
			<%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				<input type="button" class="button" value="수정" onclick="javascript:CarNmUp();"> <%}%> 
			<%if(auth_rw.equals("4") || auth_rw.equals("6")){%>
				<input type="button" class="button" value="삭제" onclick="javascript:CarNmDel();"> <%}%> 
			<%if(auth_rw.equals("4") || auth_rw.equals("6")){%>
				<input type="button" class="button" value="색상표등록" onclick="javascript:reg_col_catalog();"> <%}%>
			<input type="button" class="button" value="닫기" onclick="javascript:self.close();window.close();">
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="0" width=900>
					<tr>
						<td class='line'>
							<table border="0" cellspacing="1" cellpadding="0" width=880>
								<tr>
									<td class=title width="4%">
										<input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">
									</td>
									<td class=title width="4%">연번</td>
									<td class=title width="6%">구분</td>
									<td class=title width="20%">색상</td>
									<td class=title width="10%">색상이미지</td>
									<td class=title width="5%">조정<br />잔가</td>
									<td class=title width="7%">금액</td>
									<td class=title width="*">비고</td>
									<td class=title width="5%">사용<br />여부</td>
									<td class=title width="9%">등록일자</td>
								</tr>
							</table>
						</td>
						<td width="20">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<iframe src="./car_col_i_in.jsp?auth_rw=<%=auth_rw%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&car_id=<%=car_id%>"
					name="i_in" id="i_in" width="900" height="490" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="0" width=900>
				 	<tr>
						<td>	
							<input type="button" class="button btn-submit" value="트림별 외장 색상 관리" onclick="javascript:ColTrim();">
						</td>
						<td align="right">	
							
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="car_c_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>">
	<input type="hidden" name="car_u_seq" value="">
</form>
<form action="./car_mst_null.jsp" name="form2" method="post">
	<input type="hidden" name="sel" value="">
	<input type="hidden" name="car_comp_id" value="">
	<input type="hidden" name="code" value="">
	<input type="hidden" name="car_id" value="">   
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="mode" value="">
	<input type="hidden" name="from_page" value="/acar/car_mst/car_mst_sh.jsp">
</form>
<form action="./car_col_i_in.jsp" name="SearchCarNmForm" method="post">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
	<input type="hidden" name="code" value="<%=code%>">
	<input type="hidden" name="col_st" value="<%=col_st%>">
	<input type="hidden" name="use_yn" value="<%=use_yn%>">
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script>
	//색상명에 특수문자 입력 방지
	var regex = /[\'\"<>]/gi;
	var car_c;
	
	// 색상명 ' " < > 제한
	$("#car_c").bind("keyup",function(){
		car_c = $("#car_c").val();
		if(regex.test(car_c)){
			$("#car_c").val(car_c.replace(regex,""));
		}
	});
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>
