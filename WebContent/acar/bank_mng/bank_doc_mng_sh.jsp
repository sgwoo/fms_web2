<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase" />
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cpt = request.getParameter("s_cpt")==null?"":request.getParameter("s_cpt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector fines = FineDocDb.getFineDocRegGovList(br_id);
	int fine_size = fines.size();
	
	CodeBean[] banks = c_db.getLendCptCdAll(gubun);
	int bank_size = banks.length;
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
	//디스플레이 타입
	function cng_dt() {
		var fm = document.form1;
		if (fm.gubun2.options[fm.gubun2.selectedIndex].value == '5') { //기간
			td_dt1.style.display = '';
			td_dt2.style.display = 'none';
		} else {
			td_dt1.style.display = 'none';
			td_dt2.style.display = '';
		}
	}

	function search() {
		var fm = document.form1;
		if (fm.st_dt.value != '') {
			fm.st_dt.value = ChangeDate3(fm.st_dt.value);
		}
		if (fm.end_dt.value != '') {
			fm.end_dt.value = ChangeDate3(fm.end_dt.value);
		}
		if (fm.st_dt.value != '' && fm.end_dt.value == '') {
			fm.end_dt.value = fm.st_dt.value;
		}

		if (fm.s_kd.options[fm.s_kd.selectedIndex].value == '3') { //금융사
			fm.t_wd.value = fm.s_cpt.options[fm.s_cpt.selectedIndex].value;
		}

		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue == '13')
			search();
	}

	function cng_input() {
		var fm = document.form1;

		if (fm.s_kd.options[fm.s_kd.selectedIndex].value == '3') { //금융사
			td_input.style.display = 'none';
			finance.style.display = '';
			td_cpt.style.display = '';
		} else if (fm.s_kd.options[fm.s_kd.selectedIndex].value == '2' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '4') {
			td_input.style.display = '';
			finance.style.display = 'none';
			td_cpt.style.display = 'none';
		} else {
			td_input.style.display = 'none';
			finance.style.display = 'none';
			td_cpt.style.display = 'none';			
		}
	}
	
	function cng_input2() {
		var fm = document.form1;

		fm.action ="bank_doc_mng_sh.jsp";
		fm.target="_self";						
		fm.submit();
	}
</script>
</head>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
	<form name='form1' action='bank_doc_mng_sc.jsp' target='c_foot'
		method='post'>
		<input type='hidden' name='auth_rw' value='<%=auth_rw%>'> <input
			type='hidden' name='user_id' value='<%=user_id%>'> <input
			type='hidden' name='br_id' value='<%=br_id%>'> <input
			type='hidden' name='sh_height' value='<%=sh_height%>'>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
				<td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
						<tr>
							<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
							<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>
							&nbsp; <span class=style1>재무회계 >구매자금관리 > <span class=style5>대출요청 공문발행대장</span></span></td>
							<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class=h></td>
			</tr>
			<tr>
				<td>
					<table border="0" cellspacing="0" cellpadding="0" width=100%>
						<tr>
							<td width='21%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<img src=../images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
								<select name='gubun4'>
									<option value="1" <%if(gubun4.equals("1"))%> selected <%%>>시행일자</option>
									<option value="2" <%if(gubun4.equals("2"))%> selected <%%>>실행일자</option>
								</select>&nbsp;
								<select name="gubun2" onChange='javascript:cng_dt()'>
									<option value="">전체</option>
									<option value="3" <%if(gubun2.equals("3"))%> selected <%%>>당일</option>
									<option value="4" <%if(gubun2.equals("4"))%> selected <%%>>당월</option>
									<option value="6" <%if(gubun2.equals("6"))%> selected <%%>>당해</option>
									<option value="7" <%if(gubun2.equals("7"))%> selected <%%>>전월</option>
									<option value="5" <%if(gubun2.equals("5"))%> selected <%%>>기간</option>
								</select>
							</td>
							<td width='*'>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="200" id=td_dt1 style="display:<%if(!gubun2.equals("5")){%>none<%}else{%>''<%}%>">&nbsp;
											<input type="text" name="st_dt" size="11" value="<%=AddUtil.ChangeDate2(st_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> ~ 
											 <input type="text" name="end_dt" size="11" value="<%=AddUtil.ChangeDate2(end_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
										</td>
										<td width="200" id=td_dt2 style="display:<%if(gubun2.equals("5")){%>none<%}else{%>''<%}%>">&nbsp;
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				<td>
			</tr>
			<tr>
				<td>
					<table border="0" cellspacing="0" cellpadding="0" width=100%>					
						<tr>
							<td width='15%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
								<select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
									<option value="" <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
									<!--      <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option> -->
									<option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
									<option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>계약번호</option>
									<option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>금융사</option>
								</select>
							</td>
							<td width='25%' id='finance' <%if(s_kd.equals("3")){%> style="display: ''" <%}else{%> style="display:none" <%}%>s>&nbsp;
								<img src=../images/center/arrow_glcd.gif align=absmiddle>&nbsp;&nbsp;
						    	<select name='gubun' onChange='javascript:cng_input2()'>
									<option value='' <%if(gubun.equals(""))%> selected <%%>>전체</option>
						            <option value='1' <%if(gubun.equals("1"))%> selected <%%>>은행</option>
						            <option value='2' <%if(gubun.equals("2"))%> selected <%%>>캐피탈</option>
						            <option value='3' <%if(gubun.equals("3"))%> selected <%%>>저축은행</option>
						            <option value='4' <%if(gubun.equals("4"))%> selected <%%>>기타금융기관</option>
						        </select>
						    </td>
							<td width='*'>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width='15%' id='td_input' <%if( s_kd.equals("3") ){%>style='display: none' <%}%>>
											&nbsp;<input type='text' name='t_wd' size='16' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
										</td>
										<td width='20%' id='td_cpt' <%if(s_kd.equals("3")){%> style="display:''" <%}else{%> style="display:none" <%}%>>
											<select name='s_cpt''>
												<option value=''>전체</option>
												<%
												    
					        						for(int i=0; i<bank_size; i++){
					        							CodeBean bank=banks[i];
												         
												%>
												<option value='<%= bank.getCode()%>' <%if(s_cpt.equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
        											<%}%>
											</select>	
										</td>	
										<td>									
											&nbsp;<a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
