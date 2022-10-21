<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String colspan = request.getParameter("colspan")==null?"":request.getParameter("colspan");
%>

<script language='javascript'>
<!--
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		theURL = "/acar/pop_search/s_clientsite.jsp?type=search&s_kd="+fm.s_kd.value+"&t_wd="+fm.t_wd.value+"&m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&go_url=<%= go_url %>";
		window.open(theURL,'search_open','scrollbars=yes,status=no,resizable=yes,width=670,height=450,left=50,top=50');
	}		
//-->
</script>
  <form name="form1" method="post" action="">
    <tr> 
      <td <%if(!colspan.equals("")){%>colspan='<%=colspan%>'<%}%>> 
	    <jsp:include page="/acar/code/get_code.jsp" flush="true">
	  	  <jsp:param name="f_nm" value="s_kd" />
	  	  <jsp:param name="nm_cd" value="cl_s_kd" />
	  	  <jsp:param name="app_st" value="Y" />
  		  <jsp:param name="value" value="<%=s_kd%>" />
	  	  <jsp:param name="onChange" value="" />
	    </jsp:include>
        <input type="text" name="t_wd" value="<%=t_wd%>" onKeyDown="javascript:enter();" style='IME-MODE: active'>
        <a href="javascript:SearchopenBrWindow()"><img src="../../../images/bbs/but_search.gif" width="50" height="18" border="0"></a>
      </td>
    </tr>
  </form>