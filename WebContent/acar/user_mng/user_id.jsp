<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String user_id = "";
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String taste = "";
	String special = "";
	String sa_code = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("user_id") !=null) user_id = request.getParameter("user_id");
	if(request.getParameter("cmd") !=null) cmd = request.getParameter("cmd");
	
	user_bean 	= umd.getUsersBean(user_id);
	
	if(cmd.equals("i")) user_bean 	= new UsersBean();
	
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 			= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_i_tel 	= user_bean.getUser_i_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	user_work 	= user_bean.getUser_work();
	in_tel 		= user_bean.getIn_tel();
	hot_tel		= user_bean.getHot_tel();
	taste		= user_bean.getTaste();
	special		= user_bean.getSpecial();
	
	DeptBean dept_r [] = umd.getDeptAll();
	BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

function UserAdd()
{
	var theForm = document.form1;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value= "i";
	theForm.target="i_no";
	theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;
	theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
	theForm.submit();
}
function UserUp()
{
	var theForm = document.form1;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value= "u";
	theForm.target="i_no";
	theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;
	theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
	theForm.submit();
}
function CheckField()
{
	var theForm = document.form1;
	
	if(theForm.br_id.value=="")
	{
		alert("지점을 선택하십시요.");
		theForm.br_id.focus();
		return false;
	}
	if(theForm.dept_id.value=="")
	{
		alert("부서를 선택하십시요.");
		theForm.dept_id.focus();
		return false;
	}
	if(theForm.user_nm.value=="")
	{
		alert("이름을 입력하십시요.");
		theForm.user_nm.focus();
		return false;
	}
	if(theForm.user_ssn1.value=="")
	{
		alert("주민등록번호를 입력하십시요.");
		theForm.user_ssn1.focus();
		return false;
	}
	if(theForm.user_ssn2.value=="")
	{
		alert("주민등록번호를 입력하십시요.");
		theForm.user_ssn2.focus();
		return false;
	}
	if(theForm.id.value=="")
	{
		alert("ID를 입력하십시요.");
		theForm.id.focus();
		return false;
	}
	if(theForm.user_psd.value=="")
	{
		alert("비밀번호를 입력하십시요.");
		theForm.user_psd.focus();
		return false;
	}
	
	<%if(!ck_acar_id.equals("000029")){%>
	if(theForm.user_psd.value.length<6)
	{
		alert("비밀번호는 6자리 이상이여야 합니다.");	
		theForm.user_psd.focus();
		return false;
	}
	
	//운전면허번호 자리수체크 및 formating 로직 추가(2018.02.07)
	if(theForm.lic_no.value!=""){
		var chk_lic_no_res = CheckLic_no(theForm.lic_no.value);
		if(chk_lic_no_res=='N'){	return false;	}
	}	
	<%}%>
	
	//에이전트 등록일 경우 영업사원코드 필수입력(20181105)
	if(theForm.dept_id.value=="1000"){
		if(theForm.sa_code.value=="" || theForm.sa_code.value.length!=6){
			alert("영업사원코드 6자리를 입력해주세요.");	
			theForm.sa_code.focus();
			return false;
		}
		if(theForm.agent_id.value=="" || theForm.agent_id.value.length!=6){
			alert("에이전트관리번호 5자리를 입력해주세요. 에이전트관리번호는 에이전트관리 세부페이지에서 확인할 수 있습니다. ");	
			theForm.agent_id.focus();
			return false;
		}
		var regExp = /^[0-9]+$/;
		if(!regExp.test(theForm.sa_code.value)){
			alert("영업사원코드는 숫자만 입력가능합니다.");
			theForm.sa_code.focus();
			return false;
		}
	}
	return true;
}
function CheckUserID()
{
	var theForm = document.form1;
	var theForm1 = document.UserIDCheckForm;
	theForm1.user_id.value=theForm.id.value;
	theForm1.target = "i_no";
	theForm1.submit();
}
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') CheckUserID();
}	
function view_sa_code(){
	var dept_id = $("#dept_id option:selected").val();
	if(dept_id=='1000'){
		internet_num.style.display	= 'none';
		sa_code_num.style.display	= '';
	}else{
		internet_num.style.display	= '';
		sa_code_num.style.display	= 'none';
	}
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
<table border=0 cellspacing=0 cellpadding=0 width=98%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>사용자등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" width=100%>
            	<tr>			    	
              <td class=title width=23%>지점</td>			    	
              <td width=27%> 
                <select name="br_id">
			    			<option value="">선택</option>
<%
    for(int i=0; i<br_r.length; i++){
        br_bean = br_r[i];
%>
            				<option value="<%= br_bean.getBr_id() %>"><%= br_bean.getBr_nm() %></option>
<%}%>
						</select>
						<script language="javascript">
						document.form1.br_id.value = '<%=br_id%>';
						</script>
              </td>			    	
              <td class=title width=23%>부서</td>			        
              <td width=27%> 
                <select name="dept_id" id="dept_id" onchange="javascript:view_sa_code();">
			    			<option value="">선택</option>
<%
    for(int i=0; i<dept_r.length; i++){
        dept_bean = dept_r[i];
%>
            				<option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
<%}%>								
						</select>
						<script language="javascript">
						document.form1.dept_id.value = '<%=dept_id%>';
						</script>
              </td>
			    </tr>
            	<tr>
			    	
              <td class=title>성명</td>
			    	<td>
                <input type="text" name="user_nm" value="<%=user_nm%>" size="17" class=text style='IME-MODE: active'>
              </td>
			    	
              <td class=title>주민등록번호</td>
			    	<td>
					  <input type="text" name="user_ssn1" value="<%=user_ssn1%>" size="6" maxlength=6 class=text>-<input type="password" name="user_ssn2" value="<%=user_ssn2%>" size="7" maxlength=7 class=text></td>
			    
            	</tr>
            	<tr>
			    	
              <td class=title_p><a href="javascript:CheckUserID()" title="ID 중복 확인">ID</a></td>
			    	<td>
                <input type="text" name="id" value="<%=id%>" size="17" class=text onKeyDown='javascript:enter()' style="ime-mode:disabled">
              </td>
			    	<td class=title>비밀번호</td>
			        <td>
					  <input type="password" name="user_psd" value="<%=user_psd%>" size="17" class=text>
              </td>
            	</tr>
            	<tr>			    	
              <td class=title>운전면허번호</td>
			    	<td>
                <input type="text" name="lic_no" value="<%=lic_no%>" size="17" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
              </td>			    	
              <td class=title>면허취득일자</td>
			        <td>
                <input type="text" name="lic_dt" value="<%=lic_dt%>" size="17" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              </td>
            	</tr>
            	<tr>
			    	<td class=title>전화</td>
			    	<td>
                <input type="text" name="user_h_tel" value="<%=user_h_tel%>" size="17" class=text>
              </td>
			    	<td class=title>휴대폰</td>
			        <td>
                <input type="text" name="user_m_tel" value="<%=user_m_tel%>" size="17" class=text>
              </td>
            	</tr>
				<tr>
				<td class=title>내선번호</td>
				<td><input type="text" name="in_tel" value="<%=in_tel%>" size="17" class=text></td>
				<td class=title>직통전화</td>
				<td><input type="text" name="hot_tel" value="<%=hot_tel%>" size="17" class=text></td>
				</tr>
				<tr>
				<td class=title>취미</td>
				<td><input type="text" name="taste" value="<%=taste%>" size="17" class=text></td>
				<td class=title>특기</td>
				<td><input type="text" name="special" value="<%=special%>" size="17" class=text></td>
				</tr>
           	<tr id="internet_num">
		      <td class=title>무선인터넷<br>사용자번호</td>
		      <td colspan="3">
			    <input type="text" name="user_i_tel" value="<%=user_i_tel%>" size="17" class=text></td>			  
           	</tr>
           	<tr id="sa_code_num" style="display: none;">
		      <td class=title>영업사원코드</td>
			  <td><input type="text" name="sa_code" value="" size="10" class=text></td> 
		      <td class=title>에이전트관리번호</td>
			  <td><input type="text" name="agent_id" value="" size="10" class=text></td> 
           	</tr>
				
            	<tr>
			    	<td class=title>직위</td>
			    	<td>
                <input type="text" name="user_pos" value="<%=user_pos%>" size="16" class=text>
              </td>
			    	<td class=title>권한</td>
			        <td>
			        	<select name="user_aut">
			        		<option value="">선택</option>
			    			<option value="F">대여료변경</option>
						</select>
						<script language="javascript">
						document.form1.user_aut.value = '<%=user_aut%>';
						</script>
			        </td>
            	</tr>
            	<tr>
			    	<td class=title>보안메일</td>
			    	<td>
                <input type="text" name="mail_id" value="<%=user_bean.getMail_id()%>" size="16" class=text style="ime-mode:disabled">
              </td>
			    	<td class=title>채권유형</td>
			    	<td>
					<select name="loan_st">
			        		<option value="">없음</option>
			    			<option value="1">1군(고객지원)</option>
			    			<option value="2">2군(영업)</option>
													
						</select>
              </td>
            	</tr>
					<%	String email_1 = "";
						String email_2 = "";
						if(!user_email.equals("")){
							int mail_len = user_email.indexOf("@");
							if(mail_len > 0){
								email_1 = user_email.substring(0,mail_len);
								email_2 = user_email.substring(mail_len+1);
							}
						}
					%>									
            	<tr>
			    	<td class=title>이메일</td>
			    	<td colspan=3>
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='15' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
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
							    </select>
						        <input type='hidden' name='user_email' value='<%=user_email%>'>
                <!--<input type="text" name="user_email" value="<%=user_email%>" size="51" class=text style="ime-mode:disabled">-->
              </td>
            </tr>
			<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('t_zip').value = data.zonecode;
							document.getElementById('t_addr').value = data.address +" (" + data.buildingName +")" ;
							
						}
					}).open();
				}
			</script>			
           	<tr>
		      <td class=title>주소</td>
		      <td colspan=3>
				<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=user_bean.getZip()%>">
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" name="t_addr" id="t_addr" size="41" value="<%=user_bean.getAddr()%>">
	
              </td>
           	</tr>
           	<tr>
		      <td class=title>담당업무</td>
		      <td colspan=3>
			    <textarea name="user_work" cols="49" rows="5" class="text"><%=user_work%></textarea></td>
           	</tr>
				
            	<tr>
			    	<td class=title>입사년월일</td>
			    	<td colspan=3>
					  <input type="text" name="enter_dt" value="<%=enter_dt%>" size="16" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              </td>
            	</tr>								
            </table>
        </td>
    </tr>
     <tr>
        <td>
            <table border="0" cellspacing="0" width=430>
                <tr><td align="right">
<%
	if(user_id.equals(""))
	{
%>
        <a href="javascript:UserAdd()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
<%
	}else{
%>
        <a href="javascript:UserUp()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
<%
	}
%>
            </td></tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="user_ssn" value="">
<input type="hidden" name="cmd" value="">
</form>
</center>
<form action="user_id_check_null.jsp" name="UserIDCheckForm" method="post">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="h_id" value="<%=id%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>