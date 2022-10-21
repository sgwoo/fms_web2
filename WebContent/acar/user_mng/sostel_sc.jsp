<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.partner.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_nm = request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String user_h_tel = request.getParameter("user_h_tel")==null?"":request.getParameter("user_h_tel");	
	String in_tel = request.getParameter("in_tel")==null?"":request.getParameter("in_tel");
	String i_fax = request.getParameter("i_fax")==null?"":request.getParameter("i_fax");
	String hot_tel = request.getParameter("hot_tel")==null?"":request.getParameter("hot_tel");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	UsersBean user_r [] = umd.getUserAllSostel(s_br_id, dept_id, user_nm);
	
	Vector vt = po_db.PartnerAll(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>(주)아마존카 연락망</title>
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
/*
function BranchAdd()
{
	
	var SUBWIN="./branch_office_i.jsp";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=750, height=400, scrollbars=yes");
}
*/


function DeptAdd()
{
	
	var SUBWIN="./dept_i.jsp";	
	window.open(SUBWIN, "DeptList", "left=100, top=100, width=300, height=380, scrollbars=yes");
}
function UserAdd()
{
	
	var SUBWIN="./user_id.jsp?cmd=i";	
	window.open(SUBWIN, "UserList", "left=100, top=100, width=450, height=550, scrollbars=no");
}
function UserDisp(user_id,auth_rw)
{
	
	var SUBWIN="./user_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=430, height=180, scrollbars=no");
}
function UserUpdate(user_id,auth_rw)
{
	
	var SUBWIN="../menu/info_u.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "UserDisp", "left=100, top=10, width=500, height=650, scrollbars=yes");
}
function AuthAdd( arg )
{
	
	var SUBWIN="./user_auth_i.jsp" + "?user_id=" + arg;	
	window.open(SUBWIN, "UserList", "left=100, top=100, width=500, height=400, scrollbars=yes");
}
function Sostel()
{
	var SUBWIN	="./sostel.jsp";
	window.open(SUBWIN, "Sostel", "left=100, top=100, width=800, height=600, scrollbars=yes");
}

function BranchAdd()
{
	
	var SUBWIN="/fms2/sos_cus/partner_office.jsp";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=350, scrollbars=yes");
}

function BranchUpdate(po_id)
{
	
	var SUBWIN="/fms2/sos_cus/partner_office_u.jsp?po_id="+po_id;	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=350, scrollbars=yes");
}

	//통보하기	
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470");
	}	
	
	function popup_agentfms(id, pw){
		var fm = document.form2;
		fm.name.value = id;
		fm.passwd.value = pw;
		fm.action = "https://fms5.amazoncar.co.kr/agent/index.jsp";
		fm.target = "_blank";
		fm.submit();
	}
	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 7px;}
.style4 {color: #737373; font-size: 7px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 7px;}
-->

</style>

</head>
<!-- MeadCo ScriptX -->
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>

<body>

<table border=0 cellspacing=0 cellpadding=0  width=100%>
<form action="" name="form2" method="post">
  <input type="hidden" name="name" value="">
  <input type="hidden" name="passwd" value="">
  <input type="hidden" name="s_width" value="<%=s_width%>">
  <input type="hidden" name="s_height" value="<%=s_height%>">
</form>
	<tr>
        <td align="right">
		<a href="#" onClick="window.open('./sostel_sc_print.jsp')"><img src=../images/center/button_print.gif border=0 align=absmiddle></a>				
        </td>
    </tr>

	<tr>
        <td class=h></td>
    </tr>
    <!-- 임원 시작 -->
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
					<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>        
            	</tr>
<%
	for(int i=0; i<user_r.length; i++){
		user_bean = user_r[i];
%>
	<%if(user_bean.getUser_id().equals("000003")){%>          	
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center>&nbsp;</td>
            		<td align=center>&nbsp;</td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<% } %>
	<%if(user_bean.getUser_id().equals("000004")){%>           	
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<% } %> 
	<%if(user_bean.getUser_id().equals("000005")){%>          	
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
    			<% } %> 
<% } %> 
            </table>
        </td>
    </tr>
    <!--  임원 끝 -->
    <tr>
        <td class=h></td>
    </tr>
    <!--  영업기획팀 시작 -->
   
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
			<tr>
				<td class=title>영업기획팀</td>				
				<td colspan="3" class=title>대표전화 : <a href="tel:02)757-0802" target="_blank">02)757-0802</a></td>
				<td colspan="2" class=title>FAX : 02)757-0803</td>
				<td colspan="2" class=title></td>
			  </tr>
            	<tr>
					<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>     
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0020") && !user_bean.getUser_id().equals("000005")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
			
            </table>
        </td>
    </tr>
    <!--  영업기획팀 끝 -->
    <tr>
        <td class=h></td>
    </tr>
    <!--  영업팀 시작 -->
   
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
			<tr>
				<td class=title>영업팀</td>				
				<td colspan="3" class=title>대표전화 : <a href="tel:02)757-0802" target="_blank">02)757-0802</a></td>
				<td colspan="2" class=title>FAX : 02)757-0803</td>
				<td colspan="2" class=title></td>
			  </tr>
            	<tr>
					<td width=10% class=title>본사</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td> 
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0001")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
			
            </table>
        </td>
    </tr>
    <!--  영업팀 끝 -->
    <tr>
        <td class=h></td>
    </tr>
     <!--  고객지원팀  시작 -->

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>고객지원팀</td>					
					<td colspan="3" class=title>대표전화 : <a href="tel:02)392-4242" target="_blank">02)392-4242</a></td>
					<td colspan="2" class=title>FAX : 02)3775-4243</td>
					<td colspan="2" class=title></td>
           		</tr>
            	<tr>
            		<td width=10% class=title>본사</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td> 
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0002")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%><%//= user_bean.getArea_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
			
            </table>
        </td>
    </tr>
        <tr>
        <td class=h></td>
    </tr>
     <!--  총무팀 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>총무팀</td>					
					<td colspan="3" class=title>대표전화 : <a href="tel:02)392-4243" target="_blank">02)392-4243</a></td>
					<td colspan="2" class=title>FAX : 02)757-0803</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td> 
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0003")&& !user_bean.getUser_id().equals("000004")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  총무팀 끝 -->
	<tr>
        <td class=h></td>
    </tr>
    <!--  IT팀 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>IT팀</td>
					<td colspan="3" class=title></td>
					<td colspan="2" class=title>FAX : 02)757-0803</td>
					<td colspan="2" class=title>웹팩스 : 0506-200-1864</td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i]; 
%>
<%if(user_bean.getDept_id().equals("0005")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  IT팀 끝 -->
    
    
    
	<tr>
        <td class=h></td>
    </tr>
  <!--  강서지점 시작 -->
  <tr>
      <td class=line2></td>
  </tr>
	<tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>강서지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:02)2636-9920" target="_blank">02)2636-9920</a></td>
					<td colspan="2" class=title>FAX : 02)2636-9928</td>
					<td colspan="2" class=title></td>
           		</tr>
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0014")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
			
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
  <!--  구로지점 시작 -->
  <tr>
      <td class=line2></td>
  </tr>
	<tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>부천지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:02)2038-7575" target="_blank">02)2038-7575</a></td>
					<td colspan="2" class=title>FAX : 02)2038-7577</td>
					<td colspan="2" class=title></td>
           		</tr>
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0015")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
			
            </table>
        </td>
    </tr>
    <!--  구로지점 끝 -->
  
	<tr>
        <td class=h></td>
    </tr>
     <!--  강남 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>강남지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:02)537-5877" target="_blank">02)537-5877</a></td>
					<td colspan="2" class=title>FAX : 02)537-5977</td>
					<td colspan="2" class=title> </td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0009")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  강남 끝 -->
	<tr>
        <td class=h></td>
    </tr>
     <!--  종로 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>광화문지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:02)2038-8661" target="_blank">02)2038-8661</a></td>
					<td colspan="2" class=title>FAX : 02)2038-8540</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0017")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  종로 끝 -->
	<tr>
        <td class=h></td>
    </tr>
 <!--  송파 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>송파지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:02)2038-2492" target="_blank">02)2038-2492</a></td>
					<td colspan="2" class=title>FAX : 02)2038-6786</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0018")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  송파 끝 -->	
     <!--  인천 시작 -->
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>인천지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:032)554-8820" target="_blank">032)554-8820</a></td>
					<td colspan="2" class=title>FAX : 032)719-8765</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0012")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  인천 끝 -->
    
    
     <!--  수원 시작 -->
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>수원지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:031)546-8858" target="_blank">031)546-8858</a></td>
					<td colspan="2" class=title>FAX : 031)546-8838</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0013")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  수원 끝 -->    
    
	<tr>
        <td class=h></td>
    </tr>
       <!--  부산지점 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>부산지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:051)851-0606" target="_blank">051)851-0606</a></td>
					<td colspan="2" class=title>FAX : 051)851-1036</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
					<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0007")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  부산지점 끝 -->
    <tr>
        <td class=h></td>
    </tr>
     <!--  대전지점 시작 -->

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>대전지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:042)824-1770" target="_blank">042)824-1770</a></td>
					<td colspan="2" class=title>FAX : 042)824-1870</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0008")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  대전지점 끝 -->

	<tr>
        <td class=h></td>
    </tr>
     <!--  광주 시작 -->

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>광주지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:062)385-0133" target="_blank">062)385-0133</a></td>
					<td colspan="2" class=title>FAX : 062)385-0775</td>
					<td colspan="2" class=title> </td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0010")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  광주 끝 -->
	<tr>
        <td class=h></td>
    </tr>
     <!--  대구 시작 -->

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title>대구지점</td>
					<td colspan="3" class=title>대표전화 : <a href="tel:053)582-2998" target="_blank">053)582-2998</a></td>
					<td colspan="2" class=title>FAX : 053)582-2999</td>
					<td colspan="2" class=title></td>
           		</tr> 
            	<tr>
            		<td width=10% class=title>구분</td>
            		<td width=8% class=title>직급</td>
            		<td width=9% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=5% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
            		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("0011")){%>
            	<tr>
            		<td align="center"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
             		<% } %></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  대구 끝 -->
	
	<tr>
        <td class=h></td>
    </tr>
	<!--  지점  -->
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td width=10% class=title>파주지점</td>					
					<td width=40% align=center>대표전화 : <a href="tel:031)959-7626" target="_blank">031)959-7626</a></td>
					<td width=10% class=title>포천지점</td>
					<td width=40% align=center>대표전화 : <a href="tel:031)532-3379" target="_blank">031)532-3379</a></td>
           		</tr>            				
            </table>
        </td>
    </tr>
	 <tr>
        <td class=h></td>
    </tr>
	 <!--  에이전트 시작 -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
					<td width=10% class=title>구분</td>
            		<td width=17% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=20% class=title>웹팩스</td>
            		<td width=15% class=title>사무실(직통)</td>
               		<td width=23% class=title>E-MAIL</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("1000")&&!user_bean.getUser_id().equals("000270")){%>
            	<tr>
            		<td align="center">에이전트</td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><a href="tel:<%= user_bean.getUser_m_tel()%>" target="_blank"><%= user_bean.getUser_m_tel()%></a> <a href="javascript:req_fee_start_act('알림', '', '<%=user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true" title='<%=user_bean.getUser_nm()%>에게 메모/메세지/문자로 알리기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><a href="tel:<%= user_bean.getHot_tel()%>" target="_blank"><%= user_bean.getHot_tel() %></a></td>
            		<td align=center><%=user_bean.getUser_email()%>            		
            		    <%if(nm_db.getWorkAuthUser("에이전트지원",ck_acar_id) || nm_db.getWorkAuthUser("월마감전산담당자",ck_acar_id)){            		    	
            		    	UsersBean agent_user = umd.getUsersBean(user_bean.getUser_id());
            		    %>
            		    <a href="javascript:popup_agentfms('<%=agent_user.getId()%>','<%=agent_user.getUser_psd()%>')" onMouseOver="window.status=''; return true" title='에이전트FMS'><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="에이전트FMS"></a>
            		    <%} %>
            		</td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
			
            </table>
        </td>
    </tr>
    <!--  에이전트 끝 -->
    <tr>
        <td class=h></td>
    </tr>
	
     <!--  협력업체 시작 -->
	<tr>
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>협력업체</span> &nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:BranchAdd()"><%//if(user_id.equals("000096")){%><img src=/acar/images/center/button_reg_hluc.gif align=absmiddle border=0><%//}%></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
		<!--
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=15% class=title>구분</td>
            		<td width=10% class=title>직급</td>
            		<td width=15% class=title>성명</td>
            		<td width=15% class=title>H.P</td>
            		<td width=15% class=title>내선</td>
            		<td width=15% class=title>웹팩스</td>
            		<td width=15% class=title>직통</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
<%if(user_bean.getDept_id().equals("8888")){%>
            	<tr>
            		<td align="center"><%= user_bean.getDept_nm()%></td>
					<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><%= user_bean.getUser_m_tel()%></td>
            		<td align=center><%= user_bean.getIn_tel()%></td>
            		<td align=center><%= user_bean.getI_fax()%></td>
            		<td align=center><%= user_bean.getHot_tel() %></td>
            	</tr>
				<%}%>
<%}%>

<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%> 
            </table>
        </td>
    </tr>
	-->
	
	<table border=0 cellspacing=1 width=100%>
	<tr>
		<td width=10% class=title align="center">구분</td>
		<td width=15% class=title align="center">업체</td>
		<td width=10% class=title align="center">성명</td>
		<td width=10% class=title align="center">H.P</td>
		<td width=10% class=title align="center">내선</td>
		<td width=10% class=title align="center">팩스</td>
		<td width=10% class=title align="center">담당자</td>
		<td width=10% class=title align="center">사무실(직통)</td>
	</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
	<tr>
		<td align="center"><%=ht.get("PO_GUBUN2")%></td>
		<td align="center"><a href="javascript:BranchUpdate('<%=ht.get("PO_ID")%>')"><%=ht.get("PO_NM")%></a></td>
		<td align="center"><%=ht.get("PO_OWN")%></td>
		<td align="center"><a href="tel:<%=ht.get("PO_M_TEL")%>" target="_blank"><%=ht.get("PO_M_TEL")%></a></td>
		<td align="center"><a href="tel:<%=ht.get("PO_O_TEL")%>" target="_blank"><%=ht.get("PO_O_TEL")%></a></td>
		<td align="center"><%=ht.get("PO_FAX")%></td>
		<td align="center"><%=ht.get("PO_AGNT_NM")%></td>
		<td align="center"><%=ht.get("PO_AGNT_O_TEL")%></td>
	</tr>
<%}
}else{%>            	
    <tr>
        <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
    </tr>
<%}%>        	    
	<!-- 예비 
	<tr>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
	</tr>
	-->
</table>
    <!--  협력업체 끝 -->
</table>
</body>
</html>
<script>
function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = false; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 20.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 20.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>