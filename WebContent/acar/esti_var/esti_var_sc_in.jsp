<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	int count = 0;
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>        
    <td>1. �ٽɺ���</td>
  </tr>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width="100">������ȣ</td>
          <td class=title width="100">�����ڵ�</td>
          <td class=title width="500" colspan="2">������</td>
          <td class=title width="100">������</td>
        </tr>
        <tr> 
          <td align="center">F</td>
          <td align="center">a_f</td>
          <td colspan="2">����������</td>
          <td align="right">10%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="4">G</td>
          <td align="center">a_g_1</td>
          <td rowspan="4" width="400">10������ ���Һα�</td>
          <td width="100" align="center">36����</td>
          <td align="right">3,227</td>
        </tr>
        <tr> 
          <td align="center">a_g_2</td>
          <td width="100" align="center">24����</td>
          <td align="right">4,615</td>
        </tr>
        <tr> 
          <td align="center">a_g_3</td>
          <td width="100" align="center">18����</td>
          <td align="right">6,006</td>
        </tr>
        <tr> 
          <td align="center">a_g_4</td>
          <td width="100" align="center">12����</td>
          <td align="right">8,792</td>
        </tr>
        <tr> 
          <td align="center">��</td>
          <td align="center">o_12</td>
          <td colspan="2">Ư�Ҽ� ȯ����(6������)</td>
          <td align="right">82.9%</td>
        </tr>
        <tr> 
          <td align="center">(3)</td>
          <td align="center">g_3</td>
          <td colspan="2">���պ����� ������(������� ���)</td>
          <td align="right">70%</td>
        </tr>
        <tr> 
          <td align="center">(5)</td>
          <td align="center">g_5</td>
          <td colspan="2">���������� ������(�ż����κ������)</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">�߰���</td>
          <td align="center">oa_b</td>
          <td colspan="2">�빰, �ڼ� ���� 1�� ���Խ� �뿩�� �λ��</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">�߰���</td>
          <td align="center">oa_c</td>
          <td colspan="2">��21���̻� �������� ���Խ� �뿩�� �λ�1(�������)</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">(8)</td>
          <td align="center">g_8</td>
          <td colspan="2">�⺻�� �⺻��������</td>
          <td align="right">20%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="3">(9)</td>
          <td align="center">g_9_1</td>
          <td rowspan="3">�⺻�� ��ǥ����(���� ���)</td>
          <td width="100" align="center">36����</td>
          <td align="right">10%</td>
        </tr>
        <tr> 
          <td align="center">g_9_2</td>
          <td width="100" align="center">24����</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">g_9_3</td>
          <td width="100" align="center"><%if(gubun1.equals("1")) {%>18���� <%}else{%>12���� <%}%></td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">(10)</td>
          <td align="center">g_10</td>
          <td colspan="2">�Ϲݽ� ���ô뿩�� �⺻���� ������</td>
          <td align="right">3</td>
        </tr>
        <tr> 
          <td align="center" rowspan="3">(11)</td>
          <td align="center">g_11_1</td>
          <td rowspan="3">�Ϲݽ� ��ǥ����(���� ���)</td>
          <td width="100" align="center">36����</td>
          <td align="right">12%</td>
        </tr>
        <tr> 
          <td align="center">g_11_2</td>
          <td width="100" align="center">24����</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">g_11_3</td>
          <td width="100" align="center">
            <%if(gubun1.equals("1")) {%>
            18����
            <%}else{%>
            12����
            <%}%>
          </td>
          <td align="right">&nbsp;</td>
        </tr>
      </table>
        </td>
    </tr>
  <tr>        
    <td>&nbsp;</td>
  </tr>
  <tr>        
    <td>2. ��Ÿ����</td>
  </tr>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width="100">������ȣ</td>
          <td class=title width="100">�����ڵ�</td>
          <td class=title width="500" colspan="2">������</td>
          <td class=title width="100">������</td>
        </tr>
        <tr> 
          <td align="center" rowspan="2">��</td>
          <td align="center">o_8_1</td>
          <td rowspan="2" width="400">ä��������</td>
          <td width="100" align="center">����</td>
          <td align="right">20%</td>
        </tr>
        <tr> 
          <td align="center">o_8_2</td>
          <td width="100" align="center">���</td>
          <td align="right">15%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="2">��</td>
          <td align="center">a_9_1</td>
          <td rowspan="2">��Ϻδ���</td>
          <td width="100" align="center">����</td>
          <td align="right">69,500</td>
        </tr>
        <tr> 
          <td align="center">a_9_2</td>
          <td width="100" align="center">���</td>
          <td align="right">99,500</td>
        </tr>
        <tr> 
          <td align="center">��</td>
          <td align="center">o_10</td>
          <td colspan="2">���ް���� ������</td>
          <td align="right">100%</td>
        </tr>
        <tr> 
          <td align="center">��</td>
          <td align="center">o_e</td>
          <td colspan="2">������������ �⸻����</td>
          <td align="right">2004-12-31</td>
        </tr>
        <tr> 
          <td align="center">(1)</td>
          <td align="center">g_1</td>
          <td colspan="2">������ ������</td>
          <td align="right">0</td>
        </tr>
      </table>
        </td>
    </tr>
</table>
</body>
</html>