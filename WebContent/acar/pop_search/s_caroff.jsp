<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
%>

<html>
<head><title>�ڵ��������� ��ȸ</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchCarOffP();
	}
	function SearchCarOffP(){
		var fm = document.form1;
		fm.action = "s_caroff_in.jsp";
		fm.target = "inner";
		fm.submit();
	}

	//������-����� ����
	function set_caroff(car_off_id, car_comp_nm, car_off_nm){
	<%if(mode.equals("reg")){%>
		opener.document.form1.car_off_id.value = car_off_id;
		opener.document.form1.car_off_nm.value = car_comp_nm+' '+car_off_nm;
	<%}else{%>
		<%if(go_url.equals("")){%>
		opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&car_off_id="+car_off_id;
		<%}else{%>
		opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&car_off_id="+car_off_id;
		<%}%>	
	<%}%>
	this.close();
	}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.gu_nm.focus();">
<form name='form1' action='./s_car_off.jsp' method='post'>
 <input type='hidden' name='mode' value='<%=mode%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- �ڵ��������� ��ȸ -</font></td>
    </tr>
    <tr> 
      <td align='left'> <select name="gubun" onChange="javascript:cng_input();">
          <option value='1' <%if(gubun.equals("1") || gubun.equals("")){%> selected <%}%>> �ڵ��������� </option>	  
        </select> <input type="text" class="text" name="gu_nm" size="15" value="<%= gu_nm %>"  onKeyDown='javascript:enter()' style='IME-MODE: active'> 
        <a href="javascript:SearchCarOffP()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="�˻�"></a> 
      </td>
      <td width="14%" align='right'></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="10%">����</td>
            <td class='title' width="20%">������</td>
            <td class='title' width="20%">��������</td>
            <td class='title' width="30%">�����Ҹ�</td>
            <td class='title' width="20%">����ó</td>
          </tr>
        </table></td>
    </tr>
  </table>
<table width="520" border="0" cellspacing="0" cellpadding="0" >
  <tr> 
    <td><iframe src="./s_caroff_in.jsp?gubun=<%=gubun%>&gu_nm=<%=gu_nm%>" name="inner" width="520" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
  </tr>
  <tr> 
    <td><table width="500" border="0" cellspacing="1" cellpadding="1">
        <tr> 
          <td><div align="right">
              <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt=""></a></div></td>
        </tr>
      </table></td>
  </tr>

</table>
</form>
</body>
</html>