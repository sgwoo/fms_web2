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
//		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		theURL = "/acar/pop_search/s_gua.jsp?type=search&gubun="+fm.s_kd.value+"&gu_nm="+fm.t_wd.value+"&m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&go_url=<%= go_url %>";
		window.open(theURL,'search_open','scrollbars=yes,status=no,resizable=yes,width=750,height=430,left=50,top=50');
	}		
//-->
</script>
  <form name="form1" method="post" action="">
    <tr> 
      <td <%if(!colspan.equals("")){%>colspan='<%=colspan%>'<%}%>> 
        <select name="s_kd">
          <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>> 계약번호 </option>		  
          <option value='2' <%if(s_kd.equals("2") || s_kd.equals("")){%> selected <%}%>> 차량번호 </option>
          <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>> 상호 </option>
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" onKeyDown="javascript:enter();" style='IME-MODE: active'>
        <a href="javascript:SearchopenBrWindow()"><img src="../../../images/bbs/but_search.gif" width="50" height="18" border="0"></a>
      </td>
    </tr>
  </form>