<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
	String user_email = "";
	String user_pos = "";
	String user_aut = "";
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("user_id") !=null) user_id = request.getParameter("user_id");
	
	if(!user_id.equals(""))
	{
		user_bean = umd.getUsersBean(user_id);
				
		br_id = user_bean.getBr_id();
		br_nm = user_bean.getBr_nm();
		user_nm = user_bean.getUser_nm();
		id = user_bean.getId();
		user_psd = user_bean.getUser_psd();
		user_cd = user_bean.getUser_cd();
		user_ssn = user_bean.getUser_ssn();
		user_ssn1 = user_bean.getUser_ssn1();
		user_ssn2 = user_bean.getUser_ssn2();
		dept_id = user_bean.getDept_id();
		dept_nm = user_bean.getDept_nm();
		user_h_tel = user_bean.getUser_h_tel();
		user_m_tel = user_bean.getUser_m_tel();
		user_email = user_bean.getUser_email();
		user_pos = user_bean.getUser_pos();
		user_aut = user_bean.getUser_aut();
	}
	
	
		DeptBean dept_r [] = umd.getDeptAll();
		BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function UserDisp()
{
	var theForm = document.UserDispForm;
	
	theForm.cmd.value= "ud";
	
	theForm.submit();
}

//-->
</script>
</head>
<body  onLoad="self.focus()">
<center>
<table border=0 cellspacing=0 cellpadding=0 width=400>
	<tr>
    	<td ><font color="navy">MASTER -> 사용자관리 -> </font><font color="red">사용자정보</font></td>
    </tr>
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
    <tr>
        <td>
        <table border="0" cellspacing="0" width=400>
        <tr><td align="right"><a href="javascript:UserDisp()">수정</a>&nbsp;</td></tr>
        </table>
       </td>
    </tr>
<%
	}
%>
<form action="./user_id.jsp" name="UserDispForm" method="POST" >
	<tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=400>
            	<tr>
			    	<td class=title width=80>지점</td>
			    	<td align=center width=120><%=br_nm%>
			    	</td>
			    	<td align=center class=title width=80>부서</td>
			        <td align=center width=120><%=dept_nm%></td>
			    </tr>
            	<tr>
			    	<td class=title>이름</td>
			    	<td align=center><%=user_nm%></td>
			    	<td class=title>주민들록번호</td>
			    	<td align=center><%=user_ssn1%> - <%=user_ssn2%></td>
			    
            	</tr>
            	<tr>
			    	<td class=title>ID</td>
			    	<td align=center><%=id%></td>
			    	<td class=title>비밀번호</td>
			        <td align=center><%=user_psd%></td>
            	</tr>
            	<tr>
			    	<td class=title>전화</td>
			    	<td align=center><%=user_h_tel%></td>
			    	<td class=title>휴대폰</td>
			        <td align=center><%=user_m_tel%></td>
            	</tr>
            	<tr>
			    	<td class=title>직위</td>
			    	<td align=center><%=user_pos%></td>
			    	<td class=title>권한</td>
			        <td>
			        	<select name="user_aut">
			        		<option value="">선택</option>
			    			<option value="F">대여료변경</option>
						</select>
						<script language="javascript">
						document.UserDispForm.user_aut.value = '<%=user_aut%>';
						</script>
			        </td>
            	</tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="user_ssn" value="">
<input type="hidden" name="cmd" value="">
</form>
</center>
<script>
<%
	if(cmd.equals("u"))
	{
%>
alert("정상적으로 수정되었습니다.");

<%
	}else{
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
<%
		}
	}
%>
</script>
</body>
</html>