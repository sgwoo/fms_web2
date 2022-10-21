<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ca.*"%>
<jsp:useBean id="CaNoDb" class="acar.ca.CaNoDatabase" scope="page"/>
<jsp:useBean id="CaNoBn" class="acar.beans.CaNoBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	Vector CaNoList = CaNoDb.getCaNoList();  

%>
<html>
<head><title>�ڵ�����ȣ ��ȸ</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function setCarNo(car_no_id, car_no, reg_ext){
	pfm = opener.document.form1;
	pfm.car_no_id.value = car_no_id;
	pfm.car_no.value = car_no;
	
	
	if(reg_ext=='1')	pfm.reg_ext.value = "����";
	else if(reg_ext=='2')	pfm.reg_ext.value = "���";	
	
	this.close();
}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' action='s_carno.jsp' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- �ڵ�����ȣ ��ȸ -</font></td>
    </tr>
    <!--
    <tr> 
      <td align='left'> 
        <input type="radio" name="radiobutton" value="radiobutton" checked>
        ��ü 
        <input type="radio" name="radiobutton" value="radiobutton">
        �뿩���� ������ 
        <input type="radio" name="radiobutton" value="radiobutton">
        ������� ������</td>
    </tr>-->
    <tr> 
      <td align='left'> 
        <select name="gubun1">
          <option value="0" selected>����</option>
          <option value="1">����</option>
          <option value="2">���</option>
        </select>
        <font color="#999999">(�̻������ ��ȣ ���) </font></td>
      <td align='right'><a href="s_carno_i.jsp"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="6%">����</td>
            <td class='title' width="20%">������ȣ</td>
            <td class='title' width="30%">���ʵ������</td>
            <td class='title' width="30%">��������</td>
            <td class='title' width="14%">����</td>
          </tr>
          <% if(CaNoList.size()>0){
				for(int i=0; i<CaNoList.size(); i++){ 
					Hashtable ht = (Hashtable)CaNoList.elementAt(i); %>
          <tr> 
            <td><div align="center"><%= i+1 %></div></td>
            <td><div align="center"><a href="javascript:setCarNo('<%= ht.get("CAR_NO_ID") %>','<%= ht.get("CAR_NO") %>','<%= ht.get("REG_EXT") %>');"><%= ht.get("CAR_NO") %></a></div></td>
            <td><div align="center"><%= Util.ChangeDate2((String)ht.get("INIT_REG_DT")) %></div></td>
            <td><div align="center"><%= ht.get("EXP_DT") %></div></td>
            <td><div align="center"></div></td>
          </tr>
          <% 		}
			}else{ %>
          <tr> 
            <td colspan="5"> <div align="center">�ش� �����Ͱ� �����ϴ�.</div></td>
          </tr>
          <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right' colspan="2"><a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a></td>
    </tr>
  </table>
</form>
</body>
</html>

