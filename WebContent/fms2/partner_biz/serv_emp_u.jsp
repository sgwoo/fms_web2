<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.partner.*" %>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String emp_nm 	= request.getParameter("emp_nm")==null?"1":request.getParameter("emp_nm");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Hashtable sef = se_dt.getServ_emp_find(off_id, emp_nm, seq);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function ServOffReg(){
	var fm = document.form1;

	if(!confirm('담당자를 수정 하시겠습니까?')){ return; }
	fm.cmd.value = "emp_u";
	fm.action = "serv_emp_a.jsp";
	fm.target = "i_no";
	fm.submit();
}


//-->
</script>

</head>
<body leftmargin="10">


<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='off_id' value='<%=off_id%>'> 
<input type='hidden' name='seq' value='<%=seq%>'> 
<div class="navigation">
	<span class=style1>업체정보관리 ></span><span class=style5>담당자 수정</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

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
					<td class="title" width="10%">성명</td>
					<td class="title" width="10%">부서</td>
					<td class="title" width="10%">직책</td>
					<td class="title" width="10%">직급</td>
					<td class="title" width="10%">대표전화</td>
					<td class="title" width="10%">직통전화</td>
					<td class="title" width="10%">팩스</td>
					<td class="title" width="10%">휴대폰</td>
				</tr>
				<tr>
					<td rowspan="4" colspan="1" align="center"><input type="text" name="emp_nm" value="<%=sef.get("EMP_NM")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="dept_nm" value="<%=sef.get("DEPT_NM")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="pos" value="<%=sef.get("POS")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_level" value="<%=sef.get("EMP_LEVEL")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_tel" value="<%=sef.get("EMP_TEL")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_htel" value="<%=sef.get("EMP_HTEL")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_fax" value="<%=sef.get("EMP_FAX")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_mtel" value="<%=sef.get("EMP_MTEL")%>" size="15" class=text></td>
				</tr>
				<tr>
					<td rowspan="1" colspan="3" class="title">E-mail</td>
					<td class="title">최초등록</td>
					<td class="title">변경등록</td>
					<td class="title">담당업무</td>
					<td class="title">유효구분</td>
				</tr>
				<tr>
					<td rowspan="1" colspan="3" align="center"><input type="text" name="emp_email" value="<%=sef.get("EMP_EMAIL")%>" size="50" class=text></td>
					<td align="center"><input type="text" name="reg_dt" value="<%=sef.get("REG_DT")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="upt_dt" value="<%=sef.get("UPT_DT")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_role" value="<%=sef.get("EMP_ROLE")%>" size="15" class=text></td>
					<td align="center">
						<select name="emp_valid">
							<option value="1" <%if(sef.get("EMP_VALID").equals("1")){%> selected <%}%> >유효</option>
							<option value="2" <%if(sef.get("EMP_VALID").equals("2")){%> selected <%}%> >부서변경</option>
							<option value="3" <%if(sef.get("EMP_VALID").equals("3")){%> selected <%}%> >퇴직</option>
							<option value="4" <%if(sef.get("EMP_VALID").equals("4")){%> selected <%}%> >무효</option>
						</select>
					</td>
				</tr>
				  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('emp_post').value = data.zonecode;
									document.getElementById('emp_addr').value = data.address +" (" + data.buildingName +")" ;
									
								}
							}).open();
						}
					</script>			
				<tr>
					<td class="title">주소</td>
					<td rowspan="1" colspan="6">
					&nbsp;<input type="text" name="emp_post" id="emp_post" size="10" maxlength='7' value="<%=sef.get("EMP_POST")%>">&nbsp;<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="emp_addr" id="emp_addr" size="100" value="<%=sef.get("EMP_ADDR")%>">
					</td>
				</tr>
			</table>
        </td>
    </tr>
	<tr> 
        <td align="right">
		<input type="button" class="button" value="수정" onclick="ServOffReg()"/>
		<input type="button" class="button" value="닫기" onclick="window.close()"/>
		<!--<a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">수정</a> 
        &nbsp;&nbsp;<a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">닫기</a> -->
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>