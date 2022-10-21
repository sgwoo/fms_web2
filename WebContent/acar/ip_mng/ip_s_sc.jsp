<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.ip_mng.*" %>
<jsp:useBean id="i_bean" class="acar.ip_mng.IPBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	IpMngDatabase imd = IpMngDatabase.getInstance();
	String gubun = "";
	String gubun_nm ="";
	String auth_rw = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("gubun_nm") != null)	gubun_nm = request.getParameter("gubun_nm");
	
	IPBean i_r [] = imd.getIpAll(gubun, gubun_nm);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

function AncReg()
{
	var SUBWIN="./anc_i.jsp";	
	window.open(SUBWIN, "AncReg", "left=100, top=100, width=520, height=350, scrollbars=no");
}
function IpDisp(gubun, user_id)
{
	var SUBWIN="./ip_u.jsp?cmd=" + gubun + "&user_id=" + user_id;	
	window.open(SUBWIN, "IPDisp", "left=100, top=100, width=520, height=200, scrollbars=yes");
}
function IpUpDel(ip, user_id)
{
	var theForm = document.IpUpDelForm;
	theForm.ip.value = ip;
	theForm.user_id.value = user_id;
	theForm.target = "c_foot";
	theForm.submit();
}
function IpSearch(ip)
{
	var SUBWIN="./ip_login.jsp?ip=" + ip;	
	window.open(SUBWIN, "IPLoginDisp", "left=100, top=100, width=550, height=300, scrollbars=yes");
}
//-->
</script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<font color="navy">MASTER -> </font><font color="red">IP 관리</font>
		</td>
	</tr>
	<tr>
		<td>
			<!--table border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td>검색 : </td>
					<td> 
						<select name="gubun" onChange="javascript:document.BbsSearchForm.gubun_nm.focus()">
							<option value="">전체</option>
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="user_nm">작성자</option>
							<option value="reg_dt">날짜	</option>
						</select>
					</td>
					<td><input type='text' name="gubun_nm" size='15' class='text'></td>
					<td><a href="javascript:SearchIP()">검색</a></td>
				</tr>
			</table-->
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		</td>
	</tr>
</table>
<table border=0 cellspacing=0 cellpadding=0 width=98%>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
	<tr>
		<td align='right'>	<a href='javascript:AncReg()' onMouseOver="window.status=''; return true">등록</a>	</td>
	</tr>
<%
	}
%>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td class='title' width='50'>연번</td>
					<td class='title' width='100'>IP주소</td>
					<td class='title' width='100'>사용자</td>
					<td class='title' width='50'>부서</td>
					<td class='title' width='50'>직위</td>
					<td class='title' width='100'>휴대폰</td>
					<td class='title' width='50'>상태</td>
					<td class='title' width='150'>ID</td>
					<td class='title' width='150'>최종로그인일시</td>

				</tr>
            	
<%
    for(int i=0; i<i_r.length; i++){
        i_bean = i_r[i];
%>
            	<tr>
            		<td align="center"><%=i+1%></td>
            		<td align="center"><a href="javascript:IpUpDel('<%=i_bean.getIp()%>','<%=i_bean.getUser_id()%>')" onMouseOver="window.status=''; return true"><%=i_bean.getIp()%></a></td>
            		<td align="center"><%=i_bean.getUser_nm()%></td>
            		<td align="center"><%=i_bean.getDept_nm()%></td>
            		<td align="center"><%=i_bean.getUser_pos()%></td>
            		<td align="center"><%=i_bean.getUser_m_tel()%></td>
            		<td align="center"><%=i_bean.getLoginout()%></td>
            		<td align="center"><%=i_bean.getId()%></td>
            		<td align="center"><a href="javascript:IpSearch('<%=i_bean.getIp()%>')" onMouseOver="window.status=''; return true"><%=i_bean.getLogin_dt()%></a></td>
            		
            		
            	</tr>
<%}%>
<% if(i_r.length == 0) { %>
            <tr>
                <td colspan=10 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
<form action="./ip_u.jsp" name="IpUpDelForm" method="POST">
<input type="hidden" name="ip" value="">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
</body>
</html>