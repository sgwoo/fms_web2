<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<%@ include file="/acar/cookies_new.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	
	String q_kd1 = request.getParameter("q_kd1")==null?"":request.getParameter("q_kd1");
	String q_kd2 = request.getParameter("q_kd2")==null?"2":request.getParameter("q_kd2");
	String q_wd = request.getParameter("q_wd")==null?"":request.getParameter("q_wd");//�˻���
	
	//��ȸ
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getRentList(br_id, "", q_kd2, q_wd);
	int accid_size = accids.size();
%> 

<html>
<head>
<title>:: �����˻� ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.action = 'search_sh.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//��༱��
	function Disp(m_id, l_cd, c_id){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;		
		fm.c_id.value = c_id;				
		fm.action = 'search_sc.jsp';
		fm.submit();
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_sh.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="q_kd1" value='<%=q_kd1%>'>
<input type='hidden' name="m_id" value=''>
<input type='hidden' name="l_cd" value=''>
<input type='hidden' name="c_id" value=''>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>�˻�����: 
        <select name='q_kd2'>
          <option value='1' <%if(q_kd2.equals("1"))%>selected<%%>>��ȣ</option>
          <option value='2' <%if(q_kd2.equals("2"))%>selected<%%>>������ȣ</option>
        </select>
        <input type="text" name="q_wd" value="<%=q_wd%>" size="15" class=text onKeyDown="javasript:enter()">
        <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/bbs/but_inquiry.gif" width="50" height="18" border="0"></a> 
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="4%">����</td>
            <td class=title width="8%">����</td>
            <td class=title width="15%">����ȣ</td>
            <td class=title width="25%">��ȣ</td>
            <td class=title width="15%">������ȣ</td>
            <td class=title width="20%">���Ⱓ</td>
            <td class=title width="13%">��������</td>
          </tr>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr align="center"> 
            <td><%=i+1%></td>
            <td> 
              <%if(accid.get("USE_YN").equals("Y")){%>
              �뿩 
              <%}else{%>
              ���� 
              <%}%>
            </td>
            <td><a href="javascript:Disp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
            <td><%=accid.get("FIRM_NM")%></td>
            <td><%=accid.get("CAR_NO")%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_END_DT")))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("CLS_DT")))%></td>
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/bbs/but_close.gif" width="50" height="18" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>