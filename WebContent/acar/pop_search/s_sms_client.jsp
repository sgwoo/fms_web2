<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String s_con = request.getParameter("s_con")==null?"":request.getParameter("s_con");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>����ȸ</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	function search(){
		var fm = document.form1;
		fm.action='./s_client.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	function select(client_id){		
		var fm = document.form1;
		if(fm.type.value == 'search'){
			<%if(go_url.equals("")){%>
			opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id;
			<%}else{%>
			opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id;
			<%}%>
			this.close();
		}else{
			<% if((m_st+m_st2+m_cd).equals("020101")){ %>
				fm.action='./s_client_set.jsp?page_gubun=RES&client_id='+client_id;	//h_page_gubun=RES:������ ����
			<% }else{ %>		
				fm.action='./s_client_set.jsp?page_gubun=EXT&client_id='+client_id;	//h_page_gubun=EXT:������ ����
			<% } %>		

			//fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</head>

<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' action='' method='post'>
 <input type='hidden' name='type' value='<%=type%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=450>
    <tr> 
      <td align='left'><font color="#666600">- SMS �߼۸�ܻ� ��ȸ -</font></td>
    </tr>
    <tr> 
      <td class="line" align='left'><table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td width="100" class='title'>���</td>
          <td> �����</td>
        </tr>
        <tr>
          <td class='title'>���</td>
          <td ><input name="radiobutton" type="radio" value="radiobutton" checked>
����
  <input type="radio" name="radiobutton" value="radiobutton">
����</td>
        </tr>
      </table></td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>
    <tr> 
      <td class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td class='title'>�����</td>
            <td ><select name="s_bus_id">
             <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                              <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                              <%		}
        					}		%>
            </select></td>
          </tr>
          <tr> 
            <td width="100" class='title'>��籸��</td>
            <td><select name='s_con'>
              <option value="1">���ʿ�����</option>
              <option value="2" selected>���������</option>
              <option value="3">���������</option>
                                    </select></td>
          </tr>
          <tr>
            <td class='title'>��󱸺�</td>
            <td ><select name='s_con'>
              <option value="" selected>��ü</option>
              <option value="1">��ǥ��</option>
              <option value="2">�����̿���</option>
              <option value="3">����������</option>
              <option>ȸ�������</option>
                                    </select></td>
          </tr>
          <tr>
            <td class='title'>��ȣ</td>
            <td ><input type="text" name="textfield24" size="30" class="text"> 
              <span class="style1">(����) </span></td>
          </tr>
        </table></td>
    </tr>
  </table>
  <table width="450" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><table width="450" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td align="right">
                <a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="Ȯ��"></a>
                <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="�ݱ�"></a>
			</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
