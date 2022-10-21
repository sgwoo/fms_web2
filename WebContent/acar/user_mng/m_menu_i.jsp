<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MenuBean bme_r [] = umd.getMaMenuAll(m_st, m_st2, "b");
	MenuBean mme_r [] = umd.getMaMenuAll(m_st, m_st2, "m");
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//수정할 데이타 셋팅
	function UpdateList(st,st2,cd,nm,url,note,seq){
		var theForm = document.SMenuForm;
		theForm.m_st.value = st;
		theForm.m_st2.value = st2;
		theForm.m_cd.value = cd;
		theForm.m_nm.value = nm;
		theForm.url.value = url;
		theForm.note.value = note;
		theForm.seq.value = seq;
	}
	//등록
	function SMenuReg(){
		var theForm = document.SMenuForm;
				
		if(theForm.m_st2.value != "")	{ alert("이미 등록된 메뉴입니다."); return; }
		
		if(!CheckField())
		{
			return;
		}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.submit();
	}
	//수정
	function SMenuUp(){
		var theForm = document.SMenuForm;
		
		if(theForm.m_st2.value == ""){ alert("수정할 메뉴를 선택하십시오."); return; }
		
		var nm = theForm.m_nm.value;
		
		if(!CheckField())
		{
			return;
		}
		if(!confirm(nm + '을 수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}
	/*
	//삭제
	function SMenuDel(){
		var theForm = document.SMenuForm;
		var delCount = 0;	
		for (i=0 ; i <theForm.ch_m_cd.length; i++) {
    		if (theForm.ch_m_cd[i].checked){
				delCount++;
		    }
	    }
		if(delCount==0){
			alert("먼저 삭제할 목록을 선택하십시요.");
			return;
		}
		if(!confirm('중메뉴 삭제시 소메뉴도 함께 삭제됩니다.\n삭제하시겠습니까?'))
		{
			return;
		}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.submit();
	}
	*/
//입력체크
function CheckField()
{
	var theForm = document.SMenuForm;
	if(theForm.m_nm.value=="")
	{
		alert("메뉴명을 입력하십시요.");
		theForm.m_nm.focus();
		return false;
	}
	if(theForm.m_cd.value!="00" && theForm.url.value=="")
	{
		alert("URL을 입력하십시요.");
		theForm.url.focus();
		return false;
	}
	if(theForm.seq.value=="")
	{
		alert("연번을 입력하십시요.");
		theForm.seq.focus();
		return false;
	}
	return true;
}

	function SMenuSearch(){
		var theForm = document.SMenuSearchForm;
		var theForm1 = document.SMenuForm;
		theForm.m_st.value = theForm1.m_st.value;
		theForm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./m_menu_null_ui.jsp" name="SMenuForm" method="POST" >
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>중메뉴관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_lmenu.gif"  border="0" align=absmiddle> &nbsp; 
    		<select name="m_st" onChange="javascript:SMenuSearch()">
    			<option value="">선택</option>
				<%for(int i=0; i<bme_r.length; i++){
        			bme_bean = bme_r[i];%>
    			<option value="<%= bme_bean.getM_st() %>" <%if(m_st.equals(bme_bean.getM_st())){%>selected<%}%>><%= bme_bean.getM_nm() %></a>
				<%}%>
    		</select>
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
	            	<td width=80 class=title>중메뉴</td>
			        <td width=120>&nbsp;<input type="hidden" name="m_st2" value=""><input type="hidden" name="m_cd" value="00"><input type="text" name="m_nm" value="" size="17" class=text></td>
	            	<td width=60 class=title>URL</td>
			        <td>&nbsp;<input type="text" name="url" value="" size="35" class=text></td>
			        <td width=60 class=title>연번</td>
			        <td width=50>&nbsp;<input type="text" name="seq" value="" size="2" class=text></td>
	            	<td width=60 class=title>비고</td>
			        <td width=100>&nbsp;<input type="text" name="note" value="" size="10" class=text></td>
			    </tr>
		    </table>
        </td>
    </tr>
    <tr><td></td></tr>
    <tr>
    	<td align=right>
    	    <a href="javascript:SMenuReg()"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;
    	    <a href="javascript:SMenuUp()"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></a>&nbsp;
    	    <!--<a href="javascript:SMenuDel()"><img src="/acar/images/center/button_delete.gif"  border="0" align=absmiddle></a>&nbsp;
    	    <a href="javascript:self.close();window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>-->
    	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td width="30" class=title></td>
                    <td width="150" class=title>중메뉴</td>
                    <td class=title>URL</td>
                    <td width="150" class=title>비고</td>
                    <td width="50" class=title>연번</td>
                </tr>
<%	for(int i=0; i<mme_r.length; i++){
    	mme_bean = mme_r[i];%>
                <tr>
                    <td align=center><input type="checkbox" name="ch_m_cd" value="<%= mme_bean.getM_st2() %>"></td>
                    <td align=center><a href="javascript:UpdateList('<%= mme_bean.getM_st() %>','<%= mme_bean.getM_st2() %>','<%= mme_bean.getM_cd() %>','<%= mme_bean.getM_nm() %>','<%= mme_bean.getUrl() %>','<%= mme_bean.getNote() %>','<%= mme_bean.getSeq() %>')"><%= mme_bean.getM_nm() %></a></td>
                    <td>&nbsp;<span title="<%= mme_bean.getNote() %>"><%= mme_bean.getUrl() %></span></td>
                    <td align=center><%= mme_bean.getNote() %></td>
                    <td align=center><%= mme_bean.getSeq() %></td>
                </tr>
<%	}%>                
            </table>
        </td>
    </tr>
</table>
</form>
<form action="./m_menu_i.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="m_st" value="<%=m_st%>">
<input type="hidden" name="m_st2" value="<%=m_st2%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>