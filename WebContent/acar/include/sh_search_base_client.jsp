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
	//�˾������� ����
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("�˻��ܾ �Է��Ͻʽÿ�."); fm.t_wd.focus(); return; }
		theURL = "/acar/pop_search/s_client.jsp?type=search&s_con="+fm.s_kd.value+"&t_wd="+fm.t_wd.value+"&m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&go_url=<%= go_url %>";
		window.open(theURL,'search_open','scrollbars=yes,status=no,resizable=yes,width=670,height=450,left=50,top=50');
	}		
//-->
</script>

  <tr> 
    <td bgcolor="#878751" <%if(!colspan.equals("")){%>colspan='<%=colspan%>'<%}%>>  <table width="0%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="12">&nbsp;</td>
          <td><font color="#ffffff">�˻�</font></td>
          <td width="5">&nbsp;</td>
          <td> <select name="s_kd">
				  <option value="1" <%if(s_kd.equals("1") || s_kd.equals(""))%>selected<%%>>��ȣ</option>
				  <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>
            </select> <input type="text" name="t_wd" value="<%=t_wd%>" onKeyDown="javascript:enter();" style='IME-MODE: active'> 
          </td>
          <td width="5">&nbsp;</td>
          <td> <a href="javascript:SearchopenBrWindow()"><img src="/acar/images/bbs/but_search.gif" width="50" height="18" border="0" align="middle"></a> 
        </tr>
      </table></td>
  </tr>
