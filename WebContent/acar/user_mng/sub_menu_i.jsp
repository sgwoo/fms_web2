<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="sub_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_cd = "";
	int seq_no = 0;
	String sm_nm = "";
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("m_st") !=null) m_st = request.getParameter("m_st");
	if(request.getParameter("m_cd") !=null) m_cd = request.getParameter("m_cd");
	if(request.getParameter("sm_nm") !=null) sm_nm = request.getParameter("sm_nm");
	if(request.getParameter("seq_no") !=null) seq_no = Util.parseInt(request.getParameter("seq_no"));
		
		
	MenuBean sub_r [] = umd.getSubMenuAll(m_st, m_cd);

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function OfficeDelete()
{
	alert("정상적으로 삭제되었습니다.");
	self.close()

}
function UpdateList(st,cd,seq_no,nm)
{
	var theForm = document.SubMenuForm;
	theForm.m_st.value = st;
	theForm.m_cd.value = cd;
	theForm.seq_no.value = seq_no;
	theForm.sm_nm.value = nm;

}
function SubMenuReg()
{
	var theForm = document.SubMenuForm;
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target="i_no";
	theForm.submit();
}
function SubMenuUp()
{
	var theForm = document.SubMenuForm;
	var nm = theForm.sm_nm.value;
	if(!confirm(nm + '을 수정하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.target="i_no";
	theForm.submit();
}
function SubMenuDel()
{
	var theForm = document.SubMenuForm;
	var nm = theForm.sm_nm.value;
	var delCount = 0;
	
	for (i=0 ; i <theForm.ch_seq_no.length; i++) {
    	if (theForm.ch_seq_no[i].checked){
			delCount++;
	    }
    }
	if(delCount==0)
	{
		alert("먼저 삭제할 목록을 선택하십시요.");
		return;
	}
	if(!confirm('삭제하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "d";
	theForm.target="i_no";
	theForm.submit();
}
function SubMenuSearch()
{
	var theForm = document.SubMenuSearchForm;
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./sub_menu_null_ui.jsp" name="SubMenuForm" method="POST" >
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
            	<tr>
	            	<td>메뉴명 : <input type="hidden" name="m_st" value="<%= m_st %>"><input type="hidden" name="m_cd" value="<%= m_cd %>"><input type="hidden" name="seq_no" value=""><input type="text" name="sm_nm" value="" size="32" class=text></td>
			    </tr>
			    <tr>
	            	<td align=right><a href="javascript:SubMenuReg()">등록</a>&nbsp;<a href="javascript:SubMenuUp()">수정</a>&nbsp;<a href="javascript:SubMenuDel()">삭제</a>&nbsp;<a href="javascript:self.close();window.close();">닫기</a></td>
			    </tr>
		    </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class=title width="30"></td>
                    <td class=title>메뉴명</td>
                    
                </tr>
<%
    for(int i=0; i<sub_r.length; i++){
        sub_bean = sub_r[i];
%>
                <tr>
                    <td align=center><input type="checkbox" name="ch_seq_no" value="<%= sub_bean.getSeq_no() %>"></td>
                    <td align=center><a href="javascript:UpdateList('<%= sub_bean.getM_st() %>','<%= sub_bean.getM_cd() %>','<%= sub_bean.getSeq_no() %>','<%= sub_bean.getSm_nm() %>')"><%= sub_bean.getSm_nm() %></a></td>
                </tr>
<%}%>                
            </table>
        </td>
    </tr>
</table>
<%
	}else{
%>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td align=right><a href="javascript:self.close();window.close();">닫기</a></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class=title>메뉴명</td>
 
                </tr>
<%
    for(int i=0; i<sub_r.length; i++){
        sub_bean = sub_r[i];
%>
                <tr>
                    <td align=center><%= sub_bean.getSm_nm() %></td>
                </tr>
<%}%>                
            </table>
        </td>
    </tr>
</table>
<%
	}
%>
<input type="hidden" name="cmd" value="">
</form>
<form action="./sub_menu_i.jsp" name="SubMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="m_st" value="<%=m_st%>">
<input type="hidden" name="m_cd" value="<%=m_cd%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>