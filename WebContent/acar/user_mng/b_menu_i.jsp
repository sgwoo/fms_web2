<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="me_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_st2 = "";
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
	
	MenuBean bme_r [] = umd.getMaMenuAll(m_st, m_st2, "b");

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//������ ����Ÿ ����
function UpdateList(st,st2,cd,nm,url,note,seq)
{
	var theForm = document.BMenuForm;
	theForm.m_st.value = st;
	theForm.m_st2.value = st2;	
	theForm.m_cd.value = cd;
	theForm.m_nm.value = nm;
	theForm.url.value = url;
	theForm.note.value = note;
	theForm.seq.value = seq;
}
//���
function BMenuReg()
{
	var theForm = document.BMenuForm;
	
	if(theForm.m_st.value != ""){ alert("�̹� ��ϵ� �޴��Դϴ�."); return; }
	
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target="i_no";
	theForm.submit();
}
//����
function BMenuUp()
{
	var theForm = document.BMenuForm;
	
	if(theForm.m_st.value == ""){ alert("������ �޴��� �����Ͻʽÿ�."); return; }
		
	if(!CheckField())
	{
		return;
	}
	var nm = theForm.m_nm.value;
	if(!confirm(nm + '�� �����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.target="i_no";
	theForm.submit();
}
/*
//����
function BMenuDel()
{
	var theForm = document.BMenuForm;
	var delCount = 0;
	
	for (i=0 ; i <theForm.ch_m_st.length; i++) {
    	if (theForm.ch_m_st[i].checked){
			delCount++;
	    }
    }
	if(delCount==0)
	{
		alert("���� ������ ����� �����Ͻʽÿ�.");
		return;
	}
	if(!confirm('��޴� ������ �߸޴��� �Ҹ޴��� �Բ� �����˴ϴ�.\n�����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "d";
	theForm.target="i_no";
	theForm.submit();
}
*/
//�Է�üũ
function CheckField()
{
	var theForm = document.BMenuForm;
	if(theForm.m_nm.value=="")
	{
		alert("��޴����� �Է��Ͻʽÿ�.");
		theForm.m_nm.focus();
		return false;
	}
	if(theForm.m_cd.value!="00" && theForm.url.value=="")
	{
		alert("URL�� �Է��Ͻʽÿ�.");
		theForm.url.focus();
		return false;
	}
	if(theForm.seq.value=="")
	{
		alert("������ �Է��Ͻʽÿ�.");
		theForm.seq.focus();
		return false;
	}
	return true;
}
//�޴���ȸ
function BMenuSearch()
{
	var theForm = document.BMenuSearchForm;
	var theForm1 = document.BSMenuForm;
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./b_menu_null_ui.jsp" name="BMenuForm" method="POST" >
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>��޴�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
            	<tr>
	            	<td width=80 class=title>��޴�</td>
			        <td width=120>&nbsp;<input type="hidden" name="m_st" value=""><input type="hidden" name="m_st2" value="00"><input type="hidden" name="m_cd" value="00"><input type="text" name="m_nm" value="" size="15" class=text></td>
	            	<td width=60 class=title>URL</td>
			        <td>&nbsp;<input type="text" name="url" value="" size="35" class=text></td>
			        <td width=60 class=title>����</td>
			        <td width=50>&nbsp;<input type="text" name="seq" value="" size="2" class=text></td>
			        <td width=60 class=title>���</td>
			        <td width=100>&nbsp;<input type="text" name="note" value="" size="10" class=text></td>
			    </tr>
		    </table>
        </td>
    </tr>
    <tR>
        <td></td>
    </tr>
    <tr>
    	<td align=right>
    	    <a href="javascript:BMenuReg()"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;
    	    <a href="javascript:BMenuUp()"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></a>&nbsp;
    	    <!--<a href="javascript:BMenuDel()"><img src="/acar/images/center/button_delete.gif"  border="0" align=absmiddle></a>&nbsp;-->
    	    <!--<a href="javascript:self.close();window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>-->
    	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td width="30" class=title>����</td>
                    <td width="150" class=title>��޴�</td>
                    <td class=title>URL</td>
                    <td width="150" class=title>���</td>
                    <td width="50" class=title>����</td>
                </tr>
<%
    for(int i=0; i<bme_r.length; i++){
        me_bean = bme_r[i];
%>
                <tr>
                    <td align=center><input type="checkbox" name="ch_m_st" value="<%= me_bean.getM_st() %>"></td>
                    <td align=center><a href="javascript:UpdateList('<%= me_bean.getM_st() %>','<%= me_bean.getM_st2() %>','<%= me_bean.getM_cd() %>','<%= me_bean.getM_nm() %>','<%= me_bean.getUrl() %>','<%= me_bean.getNote() %>','<%= me_bean.getSeq() %>')"><%= me_bean.getM_nm() %></a></td>
                    <td align=left>&nbsp;<%= me_bean.getUrl() %></td>
                    <td align=center><%= me_bean.getNote() %></td>
                    <td align=center><%= me_bean.getSeq() %></td>
                </tr>
<%}%>                
            </table>
        </td>
    </tr>
</table>
</form>
<form action="./b_menu_i.jsp" name="BMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>

</body>
</html>