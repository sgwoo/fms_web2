<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "04");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	
	coe_bean = cod.getCarOffEmpBean(emp_id);
	
	CarCompBean cc_r [] = cod.getCarCompAll();

	CodeBean cd_r [] = c_db.getCodeAllCms("0003");		//금융사명을 가져온다.

	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	

	//담당자변경이력
	CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id); 
	coh_bean = cohList[cohList.length-1];
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function CarOffEmpUp(){
	var theForm = document.form1;
	if(!CheckField())	return;
	if(!confirm('수정하시겠습니까?'))	return;
	theForm.emp_ssn.value = theForm.emp_ssn1.value+theForm.emp_ssn2.value;
	if(theForm.email_1.value != '' && theForm.email_2.value != ''){
		theForm.emp_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
	}else{
		theForm.emp_email.value = '';		
	}
	theForm.cmd.value = "u";
	theForm.target = "i_no";
	theForm.submit();
}
function CheckField(){
	var theForm = document.form1;
	if(theForm.emp_nm.value==""){			alert("이름을 입력하십시요.");			theForm.emp_nm.focus();			return false;	}
	else if(theForm.cng_rsn2.value==""){	alert("지정사유를 선택해주세요!");		theForm.cng_rsn2.focus();	return false;	}	
	else if(theForm.car_comp_id.value==""){alert("소속사를 선택하십시요.");		theForm.car_comp_id.focus();	return false;	}
	else if(theForm.car_off_nm.value==""){	alert("근무처를 입력하십시요.");		theForm.car_off_nm.focus();		return false;	}	
	else if(theForm.car_off_id.value==""){	alert("대리점명을 선택하십시요.");		theForm.car_off_nm.focus();		return false;	}	
	else if(theForm.emp_m_tel.value==""){	alert("휴대폰번호를 입력하십시요.");	theForm.emp_m_tel.focus();		return false;	}
//	else if(theForm.email_1.value==""){	 alert("이메일을 입력하십시요.");		theForm.emp_email.focus();		return false;	}
	else if(theForm.upd_dt.value==""){		alert("변경등록일자를 입력하십시요.");	theForm.reg_dt.focus();		return false;	}
	else if(theForm.upd_id.value==""){		alert("변경등록담당자를 입력하십시요.");theForm.reg_id.focus();		return false;	}
	else if(theForm.use_yn[1].checked==true && theForm.sms_denial_rsn.value==""){
							alert("SMS 수신거부일 경우 사유를 입력하십시요!"); theForm.sms_denial_rsn.focus(); return false; }
	return true;
}
function CarOffSearch(){
	var theForm = document.form1;
	var car_comp_id = theForm.car_comp_id.value;
	var car_off_nm = theForm.car_off_nm.value;
	var SUBWIN="./car_off_s_open.jsp?car_comp_id="+car_comp_id+"&car_off_nm="+car_off_nm;	
	window.open(SUBWIN, "CarOffList", "left=100, top=100, width=560, height=400, scrollbars=yes");
}

function search_zip(idx){
	window.open("./zip_s.jsp?idx="+idx, "우편번호검색", "left=100, height=200, width=350, height=300, scrollbars=yes");
}
	
	
//중복체크
function name_check(){
	var fm = document.form1;	
	fm.name.value = document.form1.emp_nm.value;
	fm.action ="./name_check.jsp";
	fm.target = "i_no";
	fm.submit();	
}
function sms_denial(arg){
	if(arg=='N'){
		tr_denial.style.display = "";
		document.form1.sms_denial_rsn.focus();
	}else{
		tr_denial.style.display = "none";
		document.form1.sms_denial_rsn.value = "";
	}
}
function go_page(arg){
	if(arg=="b"){
		document.location.href = "./car_office_p_frame.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";	
	}
}
-->
</script>
</head>

<body>
<form action="./car_off_null_p_ui.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="emp_id" value="<%=emp_id%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="cng_rsn" value="<%=cng_rsn%>">
<input type="hidden" name="car_off_id" value="<%=coe_bean.getCar_off_id()%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="upd_id" value="<%= user_id %>">
<input type="hidden" name="upd_dt" value="<%= AddUtil.getDate(4) %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업사원수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><div align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href="javascript:CarOffEmpUp()" onMouseOver="window.status=''; return true"> 
          <img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;
		  <a href="javascript:history.go(-1)" onMouseOver="window.status=''; return true"> 
          <img src="/acar/images/center/button_cancel.gif" align="absmiddle" border="0"></a>&nbsp;
	    <%}%>		  
		  <a href="javascript:go_page('b')" onMouseOver="window.status=''; return true"> 
          <img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></div></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>담당자관리</span></td>
                </tr>
                <tr> 
                    <td width="20">&nbsp;</td>
                    <td width="100%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=16% class="title">담당자</td>
                                            <td width=34%>&nbsp; <select name='damdang_id'>
                                                <%if(user_size > 0){
                    								for(int i = 0 ; i < user_size ; i++){
                    									Hashtable user = (Hashtable)users.elementAt(i); %>
                     								  <option value='<%=user.get("USER_ID")%>' <% if(coh_bean.getDamdang_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>		
                    			                <%	}
                    							}		%>
                                              </select></td>
                                            <td width=16% class="title">지정(변경)일자</td>
                                            <td width=34%>&nbsp; 
                                              <input name="cng_dt" type="text" class="text" value="<%= AddUtil.getDate() %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td class="title">지정사유</td>
                                            <td colspan="3">&nbsp; <select name="cng_rsn2">
                                                <option value="1" <% if(coh_bean.getCng_rsn().equals("1")) out.println("selected");%>>1.최근계약</option>
                                                <option value="2" <% if(coh_bean.getCng_rsn().equals("2")) out.println("selected");%>>2.대면상담</option>
                                                <option value="3" <% if(coh_bean.getCng_rsn().equals("3")) out.println("selected");%>>3.전화상담</option>
                                                <option value="4" <% if(coh_bean.getCng_rsn().equals("4")) out.println("selected");%>>4.전산배정</option>
                                                <option value="5" <% if(coh_bean.getCng_rsn().equals("5")) out.println("selected");%>>5.기타</option>
                                              </select></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객기초사항관리</span></td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=16% class="title">* 성명</td>
                                            <td width=34%>&nbsp; <input type="text" name="emp_nm" value="<%= coe_bean.getEmp_nm() %>" size="12" class=text> 
                                              <a href="javascript:name_check();"><img src=/acar/images/center/button_in_check_jb.gif align=absmiddle border=0></a></td>
                                            <td width=6% rowspan="2" class="title">연락처</td>
                                            <td width=10% class="title">전화</td>
                                            <td width=34%>&nbsp; <input type="text" name="emp_h_tel" value="<%= coe_bean.getEmp_h_tel() %>" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">소득구분</td>
                                            <td>&nbsp; <input type="radio" name="cust_st" value="2" <% if(coe_bean.getCust_st().equals("2")) out.println("checked"); %>>
                                              사업소득&nbsp; <input type="radio" name="cust_st" value="3" <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>
                                              기타사업소득</td>
                                            <td class="title">* 핸드폰</td>
                                            <td>&nbsp; <input type="text" name="emp_m_tel" value="<%= coe_bean.getEmp_m_tel() %>" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">주민등록번호</td>
                                            <td>&nbsp; <input type="text" name="emp_ssn1" value="<%= coe_bean.getEmp_ssn1() %>" size="6" maxlength=6 class=text>
                                              - 
                                              <input type="text" name="emp_ssn2" value="<%= coe_bean.getEmp_ssn2() %>" size="7" maxlength=7 class=text> 
                                              <input type="hidden" name="emp_ssn" value="" size="18" class=text></td>
                                            <td colspan="2" class="title">성별</td>
                                            <td>&nbsp; <input type="radio" name="emp_sex" value="1" <% if(coe_bean.getEmp_sex().equals("1")) out.println("checked"); %>>
                                              남성 
                                              <input type="radio" name="emp_sex" value="2" <% if(coe_bean.getEmp_sex().equals("2")) out.println("checked"); %>>
                                              여성 </td>
                                        </tr>
					<%	String email_1 = "";
						String email_2 = "";
						if(!coe_bean.getEmp_email().equals("")){
							int mail_len = coe_bean.getEmp_email().indexOf("@");
							if(mail_len > 0){
								email_1 = coe_bean.getEmp_email().substring(0,mail_len);
								email_2 = coe_bean.getEmp_email().substring(mail_len+1);
							}
						}
					%>						  
										
                                        <tr> 
                                            <td class="title">* 메일주소</td>
                                            <td colspan="4">&nbsp; 
											  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>선택하세요</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">직접 입력</option>
								  <option value="">메일 없음</option>
							    </select>
						        <input type='hidden' name='emp_email' value='<%=coe_bean.getEmp_email()%>'>
								<!--<input type="text" name="emp_email" value="<%= coe_bean.getEmp_email() %>" size="30" class=text>-->
                                            </td>
                                        </tr>
										<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
										<script>
														function openDaumPostcode() {
															new daum.Postcode({
																oncomplete: function(data) {
																	document.getElementById('emp_post').value = data.zonecode;
																	document.getElementById('emp_addr').value = data.roadAddress;
																	
																}
															}).open();
														}
										</script>							
										<tr>
											<td class=title>현주소</td>
											<td colspan=5>&nbsp;
											<input type="text" name='emp_post' id="emp_post" value="<%= coe_bean.getEmp_post() %>" size="7" maxlength='7'>
											<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
											&nbsp;&nbsp;<input type="text" name='emp_addr' id="emp_addr" value="<%= coe_bean.getEmp_addr() %>" size="100">

										</tr>
										<!--
                                        <tr> 
                                            <td class="title"> 현주소</td>
                                            <td colspan="4">&nbsp; <input type="text" name="emp_post" value="<%//= coe_bean.getEmp_post() %>" size="7" class=text> 
                                              <a href="javascript:search_zip(1)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>&nbsp;<br> 
                                              &nbsp; <input type="text" name="emp_addr" value="<%//= coe_bean.getEmp_addr() %>" size="90" class=text> 
                                            </td>
                                        </tr>
										-->
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>근무처관리(*)</span></td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td colspan="2" class="title">제작사명</td>
                                            <td>&nbsp; <select name="car_comp_id" disabled>
                                                <option value="">==선택==</option>
                                                <%for(int i=0; i<cc_r.length; i++){
                    							cc_bean = cc_r[i]; 
                    							if(cc_bean.getNm().equals("에이전트") && coe_bean.getCar_comp_id().equals("")) continue;%>
                                                <option value="<%= cc_bean.getCode() %>" <%if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                                                <%}%>
                                              </select></td>
                                            <td colspan="2" class="title">직위</td>
                                            <td>&nbsp; <input type="text" name="emp_pos" value="<%= coe_bean.getEmp_pos() %>" size="21" class=text> 
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td width=6% rowspan="2" class="title">근무처</td>
                                            <td width=10% class="title">상호(부서명)</td>
                                            <td width=34%>&nbsp; <input type="text" name="car_off_nm" value="<%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %>" size="20" disabled> 
                                              <a href="javascript:CarOffSearch()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a> 
                                            </td>
                                            <td width=6% rowspan="2" class="title">연락처</td>
                                            <td width=10% class="title">전화</td>
                                            <td width=34%>&nbsp; <input type="whitetext" name="car_off_tel" value="<%= coe_bean.getCar_off_tel() %>" size="21" disabled></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">구분</td>
                                            <td>&nbsp;<input type="radio" name="car_off_st" value="1"  <% if(coe_bean.getCar_off_st().equals("1")) out.println("checked"); %> disabled>
                                              지점 
                                              <input type="radio" name="car_off_st" value="2"  <% if(coe_bean.getCar_off_st().equals("2")) out.println("checked"); %> disabled>
                                              대리점</td>
                                            <td class="title">FAX</td>
                                            <td>&nbsp; <input type="whitetext" name="car_off_fax" value="<%= coe_bean.getCar_off_fax() %>" size="21" disabled></td>
                                        </tr>
										 <script>
											function openDaumPostcode2() {
												new daum.Postcode({
													oncomplete: function(data) {
														document.getElementById('car_off_post').value = data.zonecode;
														document.getElementById('car_off_addr').value = data.roadAddress;
														
													}
												}).open();
											}
										</script>
                                        <tr> 
                                            <td colspan="2" class="title">주소</td>
                                            <td colspan="4">&nbsp;
											<input type="text" name="car_off_post"  id="car_off_post" size="7" maxlength='7' value="<%=coe_bean.getCar_off_post()%>" disabled>
											<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기" disabled><br>
											&nbsp;<input type="text" name="car_off_addr" id="car_off_addr" size="65" value="<%= coe_bean.getCar_off_addr() %>" disabled>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예금계좌관리</span></td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=16% class="title">은행명</td>
                                            <td width=34%>&nbsp; 
                                            	<input type='hidden' name="bank" 			value="<%= coe_bean.getEmp_bank() %>">
                                            	<select name="emp_bank_cd" style="width:135">
                                                <option value="">==선택==</option>
                                                <%
                    					for(int i=0; i<cd_r.length; i++){
                    						cd_bean = cd_r[i];
                    						//신규인경우 미사용은행 제외
																if(cd_bean.getUse_yn().equals("N"))	 continue;
                    				%>
                                                <option value="<%= cd_bean.getCode() %>" <% if(cd_bean.getNm().equals(coe_bean.getEmp_bank())||cd_bean.getCode().equals(coe_bean.getBank_cd())) out.print("selected"); %>><%= cd_bean.getNm() %></option>
                                                <%}%>
                                              </select></td>
                                            <td width=16% class="title">예금주명</td>
                                            <td width=34%>&nbsp; <input type="text" name="emp_acc_nm" value="<%= coe_bean.getEmp_acc_nm() %>" size="23" class=text></td>
                                        </tr>
                                        <tr> 
                                            <td class="title">계좌번호</td>
                                            <td colspan="3">&nbsp; <input type="text" name="emp_acc_no" value="<%= coe_bean.getEmp_acc_no() %>" size="23" class=text></td>
                                        </tr>
                                        <tr>
                                            <td class="title">동기화</td>
                                            <td colspan="3">&nbsp; <input type="checkbox" name="commi_eq" value="Y" checked>
                                            <font color="#666666">현재 지급 대기 중인 영업수당이 있다면 <font color=red><b>영업수당문서의 은행계좌번호</b></font></font>도 변경 </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>SMS관리</span></td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width=16% class="title">수신여부</td>
                                            <td>&nbsp;<input type="radio" name="use_yn" value="Y" <% if(coe_bean.getUse_yn().equals("Y")) out.print("checked"); %>  onClick="javascript:sms_denial('Y');">
                    							수신&nbsp;&nbsp;
                    							<input type="radio" name="use_yn" value="N" <% if(coe_bean.getUse_yn().equals("N")) out.print("checked"); %>  onClick="javascript:sms_denial('N');">
                    							거부</td>
                                        </tr>
                                        <tr id="tr_denial" style="display:<% if(coe_bean.getUse_yn().equals("Y")){%>none<%}else{%>''<%}%>;">
                                            <td class="title">수신거부사유</td>
                                            <td>&nbsp; <input type="text" name="sms_denial_rsn" value="<%= coe_bean.getSms_denial_rsn() %>" size="70" class=text>
                                              <font color="#666666"> ※한글100자이내</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>	
                <tr> 
                    <td class=h></td>
                </tr>		
                <tr> 
                    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사기거래 관련 주의요망</span></td>
                </tr>                		
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr>
                                            <td width="16%" class="title">내용
                                            </td>
                                            <td width="84%">&nbsp;<textarea name="fraud_care" rows="5" cols="100"><%= coe_bean.getFraud_care() %></textarea></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>                                	  
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;<font color="#666666">※ 먼저 <font color="#0066FF">중복체크</font>를 클릭하여 핸드폰번호와 메일주소를 확인하여, 중복 입력이 되지 않도록 
        하시기 바랍니다.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color="#666666">※ <font color="#0066FF">* 표시</font>는 필히 선택 및 입력하시기 바랍니다.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;※<font color="#666666"> <font color="#0066FF">근무처관리</font>는 검색을 클릭하여 선택하시기 바랍니다.</font></td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<form name="form2" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="name" value="">
<input type="hidden" name="from_page" value="/acar/car_office/car_office_p_u.jsp">
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="50" height="50" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

