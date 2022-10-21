<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="au_bean" class="acar.user_mng.AuthBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String base = request.getParameter("base")==null?"":request.getParameter("base");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MenuBean bme_r [] = umd.getMaMenuAll(m_st, m_st2, "b");
	MenuBean mme_r [] = umd.getMaMenuAll(m_st, m_st2, "m");
//	MenuBean sme_r [] = umd.getMaMenuAll(m_st, m_st2, "s");
	AuthBean au_r [] = umd.getAuthMaMeAll(user_id, m_st, m_st2);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function SMenuReg(){
		var theForm = document.SMenuForm;
		
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
//입력체크
function CheckField()
{
	var theForm = document.SMenuForm;
	if(theForm.m_st.value=="" || theForm.m_st2.value=="" || theForm.m_cd.value=="")
	{
		alert("메뉴를 선택하십시요.");
		theForm.m_st.focus();
		return false;
	}
	if(theForm.sort.value=="")
	{
		alert("순위를 입력하십시요.");
		theForm.sort.focus();
		return false;
	}
	return true;
}
	function SMenuSearch(){
		var theForm = document.SMenuSearchForm;
		var theForm1 = document.SMenuForm;
		theForm.m_st.value = theForm1.m_st.value;
		theForm.m_st2.value = theForm1.m_st2.value;
		theForm.m_cd.value = theForm1.m_cd.value;
		theForm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./my_menu_null_ui.jsp" name="SMenuForm" method="POST" >
<input type="hidden" name="cmd" value="">
<input type="hidden" name="user_id" value="<%=user_id%>">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
	  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>마이 메뉴관리</span></span></td>
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
	            	<td width=60 class=title>대메뉴</td>
			        <td width=130>&nbsp;
					  <select name="m_st" onChange="javascript:SMenuSearch()">
                      <option value="">선택</option>
                      <%for(int i=0; i<bme_r.length; i++){
        			bme_bean = bme_r[i];%>
                      <option value="<%= bme_bean.getM_st() %>" <%if(m_st.equals(bme_bean.getM_st())){%>selected<%}%>><%= bme_bean.getM_nm() %>
                      <%}%>
                    </select></td>
	            	<td width=60 class=title>중메뉴</td>
			        <td width=130>&nbsp;
			          <select name="m_st2" onChange="javascript:SMenuSearch()">
                        <option value="">선택</option>
                        <%for(int i=0; i<mme_r.length; i++){
        			mme_bean = mme_r[i];%>
                        <option value="<%= mme_bean.getM_st2() %>" <%if(m_st2.equals(mme_bean.getM_st2())){%>selected<%}%>><%= mme_bean.getM_nm() %>
                        <%}%>
                    </select></td>
			        <td width=60 class=title>소메뉴</td>
			        <td width=200>&nbsp;
			          <select name="m_cd" onChange="javascript:SMenuSearch()">
                        <option value="">선택</option>
						<%	for(int i=0; i<au_r.length; i++){
					    	au_bean = au_r[i];
							if(au_bean.getAuth_rw().equals("0")) continue;%>		
                        <option value="<%=au_bean.getM_cd()%>" <%if(m_cd.equals(au_bean.getM_cd())){%>selected<%}%>><%=au_bean.getM_nm()%>
                        <%}%>
                    </select></td>
	            	<td width=60 class=title>순위</td>
			        <td>&nbsp;<input type="text" name="sort" value="" size="2" class=num></td>
            	</tr>
		    </table>
        </td>
    </tr>
    <tr>
    	<td align=right><a href="javascript:SMenuReg()"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;&nbsp;<a href="javascript:self.close();window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a></td>
    </tr>
</table>
</form>
<form action="./my_menu_i.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="m_st" value="<%=m_st%>">
<input type="hidden" name="m_st2" value="<%=m_st2%>">
<input type="hidden" name="m_cd" value="<%=m_cd%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>