<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	UsersBean user_r [] = umd.getUserAll(s_br_id, dept_id, user_nm);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

function BranchAdd()
{
	
	var SUBWIN="./branch_office_i.jsp";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=820, height=430, scrollbars=yes");
}
function DeptAdd()
{
	
	var SUBWIN="./dept_i.jsp";	
	window.open(SUBWIN, "DeptList", "left=100, top=100, width=300, height=380, scrollbars=yes");
}
function UserAdd()
{
	
	var SUBWIN="./user_id.jsp?cmd=i";	
	window.open(SUBWIN, "UserList", "left=100, top=100, width=500, height=650, scrollbars=no");
}
function UserDisp(user_id,auth_rw)
{
	
	var SUBWIN="./user_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=430, height=180, scrollbars=no");
}
function UserUpdate(user_id,auth_rw)
{
	
	var SUBWIN="/fms2/menu/info_u.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "InfoUp", "left=100, top=10, width=900, height=800, scrollbars=yes");
}
function AuthAdd( arg )
{
	
	var SUBWIN="./xml_user_auth_i.jsp" + "?user_id=" + arg;	
	window.open(SUBWIN, "UserList", "left=50, top=50, width=500, height=700, scrollbars=yes");
}
function AuthAdd_old( arg )
{
	
	var SUBWIN="./user_auth_i.jsp" + "?user_id=" + arg;	
	window.open(SUBWIN, "UserList", "left=50, top=50, width=500, height=700, scrollbars=yes");
}
function Sostel()
{
	var SUBWIN	="./sostel_frame.jsp";
	window.open(SUBWIN, "Sostel", "left=100, top=100, width=800, height=600, scrollbars=yes");
}

function UserBankUpdate(user_id){
	var SUBWIN="user_bank_u.jsp?user_id="+user_id;	
	window.open(SUBWIN, "UserBankUp", "left=100, top=10, width=500, height=250, scrollbars=yes");
}

function UserAreaUpdate(user_id)
{
	
		var SUBWIN="user_area_u.jsp?user_id="+user_id;	
	window.open(SUBWIN, "UserAreaUp", "left=100, top=10, width=500, height=250, scrollbars=yes");
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

<body>


<table border=0 cellspacing=0 cellpadding=0  width=100%>

	<tr>
        <td align="right">
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
        <a href="javascript:BranchAdd()"><img src=../images/center/button_reg_jj.gif border=0 align=absmiddle></a>&nbsp;
        <a href="javascript:DeptAdd()"><img src=../images/center/button_reg_bs.gif border=0 align=absmiddle></a>&nbsp;
        <a href="javascript:UserAdd()"><img src=../images/center/button_reg_syj.gif border=0 align=absmiddle></a>
<%	}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=4% class=title>연번</td>
            		<td width=7% class=title>근무지</td>
            		<td width=7% class=title>부서</td>
            		<td width=4% class=title>직군</td>
            		<td width=6% class=title>직급</td>
            		<td width=12% class=title>이름</td>
            		<td width=10% class=title>전화</td>
            		<td width=10% class=title>휴대폰</td>
            		<td width=16% class=title>E-MAIL</td>
            		<td width=16% class=title>계좌번호</td>					
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>            		
            		<td width=8% class=title>권한</td>
<%	}else{%>
            		<td width=8% class=title>-</td>
<%	}%>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
            	<tr>
            		<td align="center"><%= i+1%></td>
            		<td align=center><%= user_bean.getBr_nm() %></td>
            		<td align=center><%= user_bean.getDept_nm() %></td>
            		<td align=center>
            		<% if( user_bean.getLoan_st().equals("1") ) {%>고객지원<% } else if( user_bean.getLoan_st().equals("2") ) {%>영업<% } %></td>
            		<td align=center><%= user_bean.getUser_pos() %></td>            			          	
            		<td align=center>
					<a href="javascript:UserUpdate('<%= user_bean.getUser_id() %>',<%=auth_rw%>)"><%= user_bean.getUser_nm() %></a>
					<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
					<br>(<%=user_bean.getSa_code()%>,<%=user_bean.getVen_code()%>)
					<%}%>
            		</td>
            		<td align=center><%= user_bean.getUser_h_tel() %></td>
            		<td align=center><%= user_bean.getUser_m_tel() %></td>
            		<td align=center><%= user_bean.getUser_email() %></td>
            		<td align=center>
					<%if(!user_bean.getDept_nm().equals("외부업체") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id))){%>
					<%		if(user_bean.getBank_no().equals("")){//등록하기%>
					<a href="javascript:UserBankUpdate('<%= user_bean.getUser_id() %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%		}else{%>
					<a href="javascript:UserBankUpdate('<%= user_bean.getUser_id() %>')"><%= user_bean.getBank_nm() %>&nbsp;<%= user_bean.getBank_no() %></a>					
					<%		}%>
					<%}%>					
					</td>					
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>            		
            		<td align=center><a href="javascript:AuthAdd('<%= user_bean.getUser_id() %>')"><img src=../images/center/button_reg_gh.gif border=0 align=absmiddle></a>
            		<a href="javascript:AuthAdd_old('<%= user_bean.getUser_id() %>')">.</a></td>
<%	}else{%>
            		<td align=center>-</td>
<%	}%>
            	</tr>
<%}%>
<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=11 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>  
            </table>
        </td>
    </tr>
</table>
</body>
</html>