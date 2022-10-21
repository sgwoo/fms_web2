<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String base = request.getParameter("base")==null?"":request.getParameter("base");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	MenuBean bme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "b");
	MenuBean mme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "m");
	MenuBean sme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "s");
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function UpdateList(st,st2,cd,nm,url,note,seq,base){
		var theForm = document.SMenuForm;
		theForm.m_st.value = st;
		theForm.m_st2.value = st2;
		theForm.m_cd.value = cd;
		theForm.m_nm.value = nm;
		theForm.url.value = url;
		theForm.note.value = note;
		theForm.seq.value = seq;
		theForm.base.value = base;
	}

	function SMenuReg(){
		var theForm = document.SMenuForm;
		
		if(theForm.m_cd.value != "")	{ alert("이미 등록된 메뉴입니다."); return; }
		
		if(!CheckField())
		{
			return;
		}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "i";
		theForm.action="xml_s_menu_null_ui.jsp";
		theForm.target="i_no";
		theForm.submit();
	}

	function SMenuUp(){
		var theForm = document.SMenuForm;
		
		if(theForm.m_cd.value == ""){ alert("수정할 메뉴를 선택하십시오."); return; }
		
		if(!CheckField())
		{
			return;
		}
		var nm = theForm.m_nm.value;
		if(!confirm(nm + '을 수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.action="xml_s_menu_null_ui.jsp";
		theForm.target="i_no";
		theForm.submit();
	}

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
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "d";
		theForm.action="xml_s_menu_null_ui.jsp";
		theForm.target="i_no";
		theForm.submit();
	}
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
		theForm.m_st2.value = theForm1.m_st2.value;
		theForm.action="xml_s_menu_i.jsp";
		theForm.submit();
	}
	
	function set_auth(idx, m_cd){
		var theForm = document.SMenuForm;	
		theForm.m_cd.value = m_cd;
		<%if(sme_r.length>1){%>
		theForm.auth.value = theForm.s_auth[idx].value;
		<%}else{%>
		theForm.auth.value = theForm.s_auth.value;
		<%}%>
		theForm.cmd.value = "auth";
		theForm.action="xml_s_menu_null_ui.jsp";
		theForm.target="i_no";
		theForm.submit();		
	}
	
	function set_user_auth(m_cd){
		var fm = document.SMenuForm;
		fm.action = 'xml_s_menu_user_auth.jsp?m_st='+fm.m_st.value+'&m_st2='+fm.m_st2.value+'&m_cd='+m_cd;
		fm.target = '_blank';
		fm.submit();
	}

	function set_user_auth_agent(m_cd){
		var fm = document.SMenuForm;
		fm.action = 'xml_s_menu_user_auth_agent.jsp?m_st='+fm.m_st.value+'&m_st2='+fm.m_st2.value+'&m_cd='+m_cd;
		fm.target = '_blank';
		fm.submit();
	}
	
	function set_user_auth_out(m_cd){
		var fm = document.SMenuForm;
		fm.action = 'xml_s_menu_user_auth_out.jsp?m_st='+fm.m_st.value+'&m_st2='+fm.m_st2.value+'&m_cd='+m_cd;
		fm.target = '_blank';
		fm.submit();
	}
	
	function menuTestOpen(){
		var fm = document.SMenuForm;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_m_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("메뉴를 선택하세요.");
			return;
		}	
		
		if(confirm('메뉴 테스트를 진행하시겠습니까?')){		
			fm.target = "_blank";
			fm.action = "xml_s_menu_open_tester.jsp";
			fm.submit();	
		}		
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.SMenuForm;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_m_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}		
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./xml_s_menu_null_ui.jsp" name="SMenuForm" method="POST" >
<input type="hidden" name="auth" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>소메뉴관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr>
    	<td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_lmenu.gif"  border="0" align=absmiddle> 
    		<select name="m_st" onChange="javascript:SMenuSearch()">
    			<option value="">선택</option>
				<%for(int i=0; i<bme_r.length; i++){
        			bme_bean = bme_r[i];%>
    			<option value="<%= bme_bean.getM_st() %>" <%if(m_st.equals(bme_bean.getM_st())){%>selected<%}%>><%= bme_bean.getM_nm() %></a>
				<%}%>
    		</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/acar/images/center/arrow_mmenu.gif"  border="0" align=absmiddle> &nbsp;
    		<select name="m_st2" onChange="javascript:SMenuSearch()">
    			<option value="">선택</option>
				<%for(int i=0; i<mme_r.length; i++){
        			mme_bean = mme_r[i];%>
    			<option value="<%= mme_bean.getM_st2() %>" <%if(m_st2.equals(mme_bean.getM_st2())){%>selected<%}%>><%= mme_bean.getM_nm() %></a>
				<%}%>
    		</select>	
    		<%if(nm_db.getWorkAuthUser("메뉴테스트",ck_acar_id)){%>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    		<input type="button" class="button" value="메뉴테스트" onclick="javascript:menuTestOpen();">&nbsp;
    		<%} %>		
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
	            	<td width=8% class=title>소메뉴</td>
			        <td width=15%>&nbsp;<input type="hidden" name="m_cd" value=""><input type="text" name="m_nm" value="" size="17" class=text></td>
	            	<td width=8% class=title>URL</td>
			        <td width=34%>&nbsp;<input type="text" name="url" value="" size="40" class=text></td>
			        <td width=5% class=title>연번</td>
			        <td width=5%>&nbsp;<input type="text" name="seq" value="" size="2" class=text></td>
	            	<td width=5% class=title>비고</td>
			        <td width=10%>&nbsp;<input type="text" name="note" value="" size="10" class=text></td>
	            	<td width=5% class=title>기본</td>
			        <td width=5%>&nbsp;<input type="text" name="base" value="" size="2" class=text></td>					
			    </tr>
		    </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
    	<td align=right><a href="javascript:SMenuReg()"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>&nbsp;<a href="javascript:SMenuUp()"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></a>&nbsp;<a href="javascript:SMenuDel()"><img src="/acar/images/center/button_delete.gif"  border="0" align=absmiddle></a>&nbsp;<a href="javascript:self.close();window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td width="5%" class=title><%if(nm_db.getWorkAuthUser("메뉴테스트",ck_acar_id)){%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><%}else{%>선택<%}%></td>
                    <td width="18%" class=title>소메뉴</td>
                    <td width="24%" class=title>URL</td>
                    <td width="5%" class=title>비고</td>
                    <td width="4%" class=title>연번</td>
                    <td width="5%" class=title>기본<br>페이지</td>
                    <td width="12%" class=title>기본권한부여<br>(일괄처리)</td>
		                <td width="9%" class=title>사용자별<br>권한부여<br>(당사직원)</td>
		                <td width="9%" class=title>사용자별<br>권한부여<br>(에이전트)</td>
   		              <td width="9%" class=title>사용자별<br>권한부여<br>(외부)</td>
                </tr>
<%	for(int i=0; i<sme_r.length; i++){
    	sme_bean = sme_r[i];%>
                <tr>
                    <td align=center><input type="checkbox" name="ch_m_cd" value="<%= sme_bean.getM_cd() %>"><input type="hidden" name="m_url" value="<%= sme_bean.getM_st() %>||<%= sme_bean.getM_st2() %>||<%= sme_bean.getM_cd() %>||<%= sme_bean.getUrl() %>"></td>
                    <td align=center><a href="javascript:UpdateList('<%= sme_bean.getM_st() %>','<%= sme_bean.getM_st2() %>','<%= sme_bean.getM_cd() %>','<%= sme_bean.getM_nm() %>','<%= sme_bean.getUrl() %>','<%= sme_bean.getNote() %>','<%= sme_bean.getSeq() %>','<%= sme_bean.getBase() %>')"><%= sme_bean.getM_nm() %></a></td>
                    <td>&nbsp;<span title="<%= sme_bean.getNote() %>"><%= sme_bean.getUrl() %></span></td>
                    <td align=center><%= sme_bean.getNote() %></td>
                    <td align=center><%= sme_bean.getSeq() %></td>
                    <td align=center><%= sme_bean.getBase() %></td>
                    <td align=center>
					  <select name="s_auth">
                	  	<option value="0">0</option>
               	 		<option value="1" selected>1</option>
                		<option value="2" >2</option>
                		<option value="3" >3</option>
                		<option value="4" >4</option>
                		<option value="5" >5</option>
                		<option value="6" >6</option>
              	      </select>
					  <%if(auth_rw.equals("6")){%>
					  <a href="javascript:set_auth('<%=i%>','<%= sme_bean.getM_cd() %>');"><img src="/acar/images/center/button_in_gh.gif"  border="0" align=absmiddle></a>
					  <%}%>
					</td>
					<td align=center><%if(auth_rw.equals("6")){%><a href="javascript:set_user_auth('<%= sme_bean.getM_cd() %>');"><img src="/acar/images/center/button_in_gh.gif"  border="0" align=absmiddle></a><%}%></td>
					<td align=center><%if(auth_rw.equals("6")){%><a href="javascript:set_user_auth_agent('<%= sme_bean.getM_cd() %>');"><img src="/acar/images/center/button_in_gh.gif"  border="0" align=absmiddle></a><%}%></td>
					<td align=center><%if(auth_rw.equals("6")){%><a href="javascript:set_user_auth_out('<%= sme_bean.getM_cd() %>');"><img src="/acar/images/center/button_in_gh.gif"  border="0" align=absmiddle></a><%}%></td>
                </tr>
<%	}%>                
            </table>
        </td>
    </tr>
	<tr>
	  <td>[권한] 0:접근제한 1:읽기 2:쓰기 3:수정 4:쓰기+수정 5:삭제 6:전체
	  </td>
	</tr>
</table>
<input type="hidden" name="cmd" value="">
</form>
<form action="./xml_s_menu_i.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="m_st" value="<%=m_st%>">
<input type="hidden" name="m_st2" value="<%=m_st2%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>