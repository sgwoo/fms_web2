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
		theURL = "/acar/pop_search/s_caremp.jsp?type=search&gubun="+fm.s_kd.value+"&gu_nm="+fm.t_wd.value+"&m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&go_url=<%= go_url %>";
//		window.open(theURL,'search_open','scrollbars=yes,status=no,resizable=yes,width=570,height=380,left=50,top=50');
	}		
//-->
</script>

  <tr> 
    <td bgcolor="#878751" <%if(!colspan.equals("")){%>colspan='<%=colspan%>'<%}%>> <table width="0%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="12">&nbsp;</td>
          <td><font color="#ffffff">담당자</font></td>
          <td width="5">&nbsp;</td>
          <td> <select name="s_kd">
			  <option value='2' <%if(s_kd.equals("2") || s_kd.equals("")){%> selected <%}%>> 강주원 </option>
			</select>
          </td>
          <td width="5">&nbsp;</td>
          <td> <a href="javascript:SearchopenBrWindow()"><img src="/acar/images/bbs/but_search.gif" width="50" height="18" border="0" align="middle"></a> 
        </tr>
      </table></td>
  </tr>
