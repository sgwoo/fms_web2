<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_k_seq 	= request.getParameter("car_k_seq")	==null?"":request.getParameter("car_k_seq");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	
	if(car_comp_id.equals("")) car_comp_id="0001";
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		re_init();
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

	//차종 선택시 기준월 출력하기
	function GetViewDt(){
		re_init();
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.view_dt;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.view_dt";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		fm2.mode.value = '16';
		fm2.target="i_no";
		fm2.submit();
		if(fm.view_dt.value != ''){
			Search();
		}
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
	
	//로딩시
	 function re_init(st){
		var theForm = parent.document.form1;	
		/* if(st == '1'){
			theForm.car_u_seq.value = '';
		} */
		theForm.engine.value 		= '';
		theForm.car_k.value 		= '';
		theForm.car_k_etc.value 		= '';	
		theForm.car_k_dt.value 		= '';			
	} 
		
	function CarNmReg(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		//theForm.target="_blank";
		theForm.submit();
	}

	function CarNmUp(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(theForm.car_k_seq.value == ''){ alert('아직 등록되지 않은 DC입니다.');}
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
	
	//일괄 업그레이드
	function save_upgrade(upgrade_dt){
		var theForm = document.form1;
		if(upgrade_dt == ''){ alert('업그레이드 기준일자를 입력하십시오.'); return;	}
		if(!confirm('업그레이드하시겠습니까?')){	return;	}
		//theForm.upgrade_dt.value = upgrade_dt;
		//theForm.upgrade_seq.value = toInt(theForm.view_dt.value.substr(0,2))+1;
		theForm.cmd.value = "ug";		
		theForm.target="i_no";
		theForm.submit();
		
	}
	
	//일괄미사용처리
	function save_use_yn(){
		var theForm = document.form1;
		if(!confirm('미사용으로 처리하시겠습니까?')){	return;	}
		theForm.cmd.value = "no";		
		theForm.target="i_no";
		theForm.submit();			
	}
	
	function Search(){
		var fm = document.form1;
		var fm2 = document.SearchCarNmForm;
		fm2.car_comp_id.value 	= fm.car_comp_id.value;
		fm2.code.value 		= fm.code.value;
		fm2.car_k_seq.value 	= fm.view_dt.value;		
		fm2.view_dt.value 	= fm.view_dt.value;
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
		if(theForm.car_k_dt.value==""){
			alert("기준일자를 선택해주세요.");
			theForm.car_k_dt.focus();
			return false;
		}			
		if(theForm.engine.value==""){
			alert("엔진을 입력해주세요.");
			theForm.engine.focus();
			return false;
		}	
		if(theForm.car_k.value==""){
			alert("복합연비를 입력해주세요.");
			theForm.car_k.focus();
			return false;
		}
		return true;
	}
	
	//디스플레이 타입
	function cng_input() {
		var fm = document.form1;
		if(fm.ls_yn.checked == true){
			tr_ls1.style.display = "";
			tr_ls2.style.display = "";
		}else{
			tr_ls1.style.display = "none";
			tr_ls2.style.display = "none";
		}
	}	
	

</script>
</head>
<body leftmargin="15" onLoad="javascript:init()">
<form action="./car_km_null_ui.jsp" name="form1" method="POST" >
	<table border=0 cellspacing=0 cellpadding=0 width="700">
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;
							<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
								<span class=style1>Master > <span class=style5>차량연비관리</span></span>
						</td>
						<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<!-- <tr>
			<td class=line2></td>
		</tr> -->
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
					<tr>
						<td colspan="2" align="right" class=title width="*">자동차회사</td>
						<td width="80%">&nbsp; 
							<select name="car_comp_id" onChange="javascript:GetCarCode()">
							<%for(int i=0; i<cc_r.length; i++){
									cc_bean = cc_r[i];%>
								<option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%> selected <%%>><%= cc_bean.getNm() %></option>
							<%}%>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>차명</td>
						<td>&nbsp; 
							<select name="code" onChange="javascript:GetViewDt()">
								<!--onChange="javascript:GetViewDt()"-->
								<option value="">전체</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>기준일자</td>
						<td>&nbsp; 
							<select name="view_dt" onChange="javascript:Search()">
								<!--onChange="javascript:GetCarId()"-->
								<option value="">전체</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>엔진</td>
						<td>&nbsp; 
							<input type="text" name="engine" value="" size="70" class=text>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>복합연비</td>
						<td>&nbsp; 
							<input type="text" name="car_k" value="" size="70" class=text>
							<input type="hidden" name="car_k_seq" value="">
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>비고</td>
						<td>&nbsp; 
							<input type="text" name="car_k_etc" value="" size="70" class=text>&nbsp;
							사용여부&nbsp;<input type="checkbox" name="use_yn" value="Y">
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right" class=title>기준일자</td>
	                    <td>&nbsp; 
	                    	<input type="text" name="car_k_dt" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                      <a href="javascript:CarNmReg()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
                      <%}%>
                      <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmUp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
                      <%}%>
                      <%if(auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmDel()" onMouseOver="window.status=''; return true"><img src=../images/center/button_delete.gif border=0 align=absmiddle></a>
                      <%}%>
                      <a href="javascript:self.close();window.close();" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
      		</td>
		</tr>
	
		<tr>
			<td>
				<table border="0" cellspacing="0" cellpadding="0" width=700>
					<tr>
						<td class='line'>
							<table border="0" cellspacing="1" cellpadding="0" width=680>
								<tr>
									<td width="7%" rowspan="2" class=title>연번</td>
									<td width="17%" rowspan="2" class=title>엔진</td>
									<td width="*" class=title>복합연비</td>
									<td width="28%" class=title>비고</td>
									<td width="10%" class=title>사용여부</td>
								</tr>
							</table>
						</td>
						<td width="20"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<iframe src="./car_km_i_in.jsp?auth_rw=<%=auth_rw%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>" name="i_in" width="700" height="320" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
			</td>
		</tr>
		<tr>
			<td>1. 기준일자 : <input type="text" name="upgrade_dt" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> <a href="javascript:save_upgrade(this.value);"><img src=../images/center/button_upgrade.gif border=0></a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>2. 일괄미사용처리 : <a href="javascript:save_use_yn();"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
			</td>
		</tr>
	</table>
	<input type="hidden" name="cmd" value="">
	<!-- <input type="hidden" name="car_u_seq" value=""> -->
	<!-- <input type="hidden" name="upgrade_dt" value=""> -->
	<input type="hidden" name="upgrade_seq" value="">
</form>
<form action="./car_mst_null.jsp" name="form2" method="post">
	 <input type="hidden" name="sel" value="">
	 <input type="hidden" name="car_comp_id" value="">
	 <input type="hidden" name="code" value="">
	 <!-- <input type="hidden" name="car_id" value=""> -->
	 <input type="hidden" name="view_dt" value="">    
	 <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	 <input type="hidden" name="mode" value="">
</form>
<form action="./car_km_i_in.jsp" name="SearchCarNmForm" method="post">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
	<input type="hidden" name="code" value="<%=code%>">
	<input type="hidden" name="car_k_seq" value="<%=car_k_seq%>">
	<%-- <input type="hidden" name="car_id" value="<%=car_id%>"> --%>
	<%-- <input type="hidden" name="car_u_seq" value="<%=car_u_seq%>"> --%>
	<input type="hidden" name="view_dt" value="<%=view_dt%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>