<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String emp_id = "";						//영업사원ID
    String car_off_id = "";					//영업소ID
    String car_off_nm = "";					//영업소명칭
    String car_comp_id = "";					//자동차회사ID
    String car_comp_nm = "";					//자동차회사 명칭
    String cust_st = "";						//고객구분
    String emp_nm = "";						//성명
    String emp_ssn = "";						//주민등록번호
    String car_off_tel = "";					//사무실전화
    String car_off_fax = "";					//팩스
    String emp_m_tel = "";					//핸드폰
    String emp_pos = "";						//직위
    String emp_email = "";					//이메일
    String emp_bank = "";					//은행
    String emp_acc_no = "";					//계좌번호
    String emp_acc_nm = "";					//예금주
    String emp_post = "";
    String emp_addr = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("car_off_id") != null) car_off_id = request.getParameter("car_off_id");
	if(request.getParameter("car_off_nm") != null) car_off_nm = request.getParameter("car_off_nm");
	if(request.getParameter("car_comp_id") != null) car_comp_id = request.getParameter("car_comp_id");
	if(request.getParameter("car_comp_nm") != null) car_comp_nm = request.getParameter("car_comp_nm");

	CodeBean cd_r [] = c_db.getCodeAll("0003");	//은행명을 가져온다.
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function search_zip()
{
	window.open("./zip_s_p.jsp", "우편번호검색", "left=100, height=200, width=350, height=300, scrollbars=yes");
}
function CarOffEmpReg()
{
	var theForm = document.CarOffEmpForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.emp_ssn.value = theForm.emp_ssn1.value+""+theForm.emp_ssn2.value;
	theForm.cmd.value = "i";
	theForm.target = "i_no"
	theForm.submit();
}
function CheckField()
{
	var theForm = document.CarOffEmpForm;
	if(theForm.emp_nm.value=="")
	{
		alert("이름을 입력하십시요.");
		theForm.emp_nm.focus();
		return false;
	}
	if(theForm.emp_m_tel.value=="")
	{
		alert("휴대폰번호를 입력하십시요.");
		theForm.emp_m_tel.focus();
		return false;
	}
	return true;
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">

<table border=0 cellspacing=0 cellpadding=0 width="800">
<form action="./car_off_p_open_null_ui.jsp" name="CarOffEmpForm" method="POST" >
	<tr>
    	<td ><font color="navy">영업지원 -> 자동차영업소관리 -> </font><font color="red">영업사원등록</font></td>
    </tr>
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="3" width="800">
            	<tr>
			    	<td width=100 align="right">자동차회사 : </td>
			    	<td width=150><%= car_comp_nm %><input type="hidden" name="car_comp_id" value="<%= car_comp_id %>"></td>
			    	<td width=100 align="right">자동차영업소 : </td>
			        <td width=150><%= car_off_nm %><input type="hidden" name="car_off_id" value="<%= car_off_id %>"></td>
			    	<td  width=300 align="right">
            			<a href="javascript:CarOffEmpReg()" onMouseOver="window.status=''; return true">등록</a>&nbsp;
			    	</td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title>고객구분</td>
                    <td align=center colspan=5>
                    	<input type="radio" name="cust_st" value="2"  <% if(cust_st.equals("2")||cust_st.equals("")) out.println("checked"); %>>사업소득&nbsp;
                    	<input type="radio" name="cust_st" value="3"  <% if(cust_st.equals("3")) out.println("checked"); %>>기타사업소득&nbsp;
                    </td>
                    
                    
                </tr>
                <tr>
                    <td class=title width=120>성명</td>
               		<td align=center width=140><input type="hidden" name="emp_id" value="<%= emp_id %>"><input type="text" name="emp_nm" value="<%= emp_nm %>" size="21" class=text></td>
                    <td class=title width=120>주민등록번호</td>
               		<td align=center width=150><input type="text" name="emp_ssn1" value="" size="6" maxlength=6 class=text> - <input type="text" name="emp_ssn2" value="" size="7" maxlength=7 class=text><input type="hidden" name="emp_ssn" value="<%= emp_ssn %>"></td>
               		<td class=title width=120>핸드폰번호</td>
               		<td align=center width=150><input type="text" name="emp_m_tel" value="<%= emp_m_tel %>" size="23" class=text></td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('emp_post').value = data.zonecode;
								document.getElementById('emp_addr').value = data.address;
								
							}
						}).open();
					}
				</script>				
               	<tr>
                    <td class=title width=120>주소</td>
               		<td colspan=5>&nbsp;
					<input type="text" name='emp_post' id="emp_post" value="<%= emp_post %>" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='emp_addr' id="emp_addr" value="<%=emp_addr%>" size="90">
					
					</td>
               	</tr>
                <tr>
                    
               		<td class=title>직위</td>
               		<td align=center><input type="text" name="emp_pos" value="<%= emp_pos %>" size="21" class=text></td>
               		<td class=title>E-MAIL</td>
               		<td align=center colspan=3><input type="text" name="emp_email" value="<%= emp_email %>" size="69" class=text></td>
                </tr>
                
                <tr>
                    <td class=title>계좌개설은행</td>
               		<td align=center>
						<select name="emp_bank" style="width:135">
							<option value="">선택</option>
<%
    for(int i=0; i<cd_r.length; i++){
        cd_bean = cd_r[i];
%>
            				<option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
<%}%> 					</select>
						<script>
						document.CarOffEmpForm.emp_bank.value = '<%= emp_bank %>';
						</script>
               		</td>
               		<td class=title>계좌번호</td>
               		<td align=center><input type="text" name="emp_acc_no" value="<%= emp_acc_no %>" size="23" class=text></td>
               		<td class=title>예금주</td>
               		<td align=center ><input type="text" name="emp_acc_nm" value="<%= emp_acc_nm %>" size="23" class=text></td>
                </tr>
            </table>
        </td>
    </tr>

</table>
<input type="hidden" name="cmd" value="">
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</body>
</html>
