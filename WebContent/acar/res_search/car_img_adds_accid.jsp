<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<jsp:useBean id="p_bean" class="acar.accid.PicAccidBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	
	AccidDatabase ac_db = AccidDatabase.getInstance();
	
	//���:������
	PicAccidBean pa_r [] = ac_db.getPicAccidList(c_id, accid_id);
%>
<html>
<head>
<title>< ������� ���� �ø��� ></title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function save(){
		var fm = document.form1;	
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}
		fm.target = "i_no";
//		fm.target = "CarImgAdd";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=450>
  <form name='form1' action='car_img_adds_a.jsp' method='post' enctype="multipart/form-data">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='cmd' value='i'>
    <tr> 
      <td class=line colspan="2"> 
        <table border=0 cellspacing=1 width=450>
          <tr> 
            <td class=title width="100">���� 1</td>
            <td> 
              <input type="file" name="filename1" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 2</td>
            <td>
              <input type="file" name="filename2" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 3</td>
            <td>
              <input type="file" name="filename3" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 4</td>
            <td>
              <input type="file" name="filename4" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 5</td>
            <td>
              <input type="file" name="filename5" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 6</td>
            <td>
              <input type="file" name="filename6" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 7</td>
            <td>
              <input type="file" name="filename7" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 8</td>
            <td>
              <input type="file" name="filename8" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���� 9</td>
            <td>
              <input type="file" name="filename9" size="30" class=text>
            </td>
          </tr>
          <tr>
            <td class=title width="100">����10</td>
            <td>
              <input type="file" name="filename10" size="30" class=text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td></td>
      <td align="right"><a href="javascript:save()">Ȯ��</a>&nbsp;&nbsp;<a href="javascript:window.close()">�ݱ�</a></td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
