<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_cd = "";
	String m_nm = "";
	String url = "";
	String note = "";
	int seq = 0;
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("m_st") !=null)
	{
		m_st = request.getParameter("m_st");
	}else{
		m_st = "01";
	}
	if(request.getParameter("m_cd") !=null) m_cd = request.getParameter("m_cd");
	if(request.getParameter("m_nm") !=null) m_nm = request.getParameter("m_nm");
	if(request.getParameter("url") !=null) url = request.getParameter("url");
	if(request.getParameter("note") !=null) note = request.getParameter("note");
	if(request.getParameter("seq") !=null) seq = Util.parseInt(request.getParameter("seq"));
	

	MenuBean sme_r [] = umd.getMenuAll(m_st, "s");

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function DispatchSearch()
{
	var theForm = document.DispatchSearchFrom;
	theForm.submit();
}
function ContractContent(id)
{
	var theForm = document.ContractContentFrom;
	theForm.h_cont_id.value = id;
	theForm.submit();
}
function BMenuAdd()
{
	
	var SUBWIN="./b_menu_i.jsp";	
	window.open(SUBWIN, "BMenu", "left=100, top=100, width=500, height=300, scrollbars=yes");
}
function SMenuAdd()
{
	
	var SUBWIN="./s_menu_i.jsp";	
	window.open(SUBWIN, "SMenu", "left=100, top=100, width=500, height=400, scrollbars=yes");
}
function SubMenuAdd(auth_rw,st,cd)
{
	var SUBWIN="./sub_menu_i.jsp" + "?auth_rw="+auth_rw+"&m_st=" + st + "&m_cd=" + cd;
	window.open(SUBWIN, "SubMenu", "left=100, top=100, width=300, height=300, scrollbars=yes");
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>

	<tr>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
        <td align="right"><a href="javascript:BMenuAdd()">대메뉴등록</a>&nbsp;<a href="javascript:SMenuAdd()">소메뉴등록</a>&nbsp;</td>
<%
	}
%>
    </tr>

    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td class=title>소메뉴명</td>
            		<td class=title>url</td>
            		<td class=title>비고</td>
            		<td class=title>순서</td>

            	</tr>
<%
    for(int i=0; i<sme_r.length; i++){
        sme_bean = sme_r[i];
%>
                <tr>
                    <td align=center><a href="javascript:SubMenuAdd('<%=auth_rw%>','<%= sme_bean.getM_st() %>','<%= sme_bean.getM_cd() %>')"><%= sme_bean.getM_nm() %></a></td>
                    <td align=center><%= sme_bean.getUrl() %></td>
                    <td align=center><%= sme_bean.getNote() %></td>
                    <td align=center><%= sme_bean.getSeq() %></td>

                </tr>
<%}%> 
<% if(sme_r.length == 0) { %>
            <tr>
                <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>           	
            </table>
        </td>
    </tr>
</table>
</body>
</html>