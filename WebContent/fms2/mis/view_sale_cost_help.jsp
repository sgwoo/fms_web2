<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">

  <table border="0" cellspacing="0" cellpadding="0" width="750">
   <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ȿ�� > <span class=style5>����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>        
    <tr>
      <td>&nbsp;</td>
    </tr>  
<%	int num = 1;%>
  <tr> 
  	  <td><%=num%>. ������� : 6���� �̻� ��� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 6���� �̸� ���� : �Ѱ�ళ������ ����ȿ�� ������ �ݿ�</td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. ���� �縮������ ������� �� �縮������ �������� 50% </td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. ����Ŀ �߰�Ź�ۺ�� = �� ���� ����Ŀ Ź�۷� - �������α׷����� ����Ŀ Ź�۷�</td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. ����Ŀ �߰�D/C : �������� �ݿ� (2017��8������ �߰� ����ȿ�� �̹ݿ�) </td>
  </tr>
  <!--
  <tr> 
  	  <td><%=num%>. ������ ����� �����ݾ� = ������ ����� �����ݾ� - �Ű�� ���뿩���Ѿ��� 3% ((�����뿩��*���Ⱓ+������)*3%) </td>
  </tr>
  -->
<%	num++;%>
  <tr> 
  	  <td><%=num%>. ��������/�縮������/��������</td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * �ߵ������� ��쿡�� ���� ����Ǿ��� ����ȿ���� �� ������ �� �����Ƿ�, �ߵ����� ������ ����ȿ���� �ٽ� �����Ͽ�  </td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ���� ����ȿ�� = ���̿�Ⱓ ����ȿ�� - ���Ⱓ ����ȿ��</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. �߰��̿� (����ȿ��)
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��༭�� �ۼ����� �ʰ� �߰��� �̿��� �Ⱓ�� ���ؼ��� ���� �����Ͽ� ���� �̿��� �Ⱓ ��ŭ�� ����ȿ���� �ݿ�����</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. ���������
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������ݹ߻� = ���� ������ �޾ƾ� �� �ݾ� - �����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> = ���·�/��Ģ��, ä��ȸ�����, ����ȸ�����, ��å��, ��ü����, ��ü�뿩�� ��</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> ������� ��������/�縮������/�������꿡�� �� �ݿ��� ���̹Ƿ� ���⼭�� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������ݼ��� = ������� ������ �� ���ݾ�</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ->  ��������/�縮������/�������꿡�� ���̳ʽ� ó���Ǿ��� �κ��� ���⼭ ������� �޾� �÷����� �ǵ����� ȿ�� �߻�</td>
  </tr>
<%	num++;%>
  <tr>   
  	  <td><%=num%>. ����ȿ���� �ͼӵǴ� ����� </td>
  </tr>  
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * �߰��̿� : ���� ��������� </td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * ���°������ : ���°� �������</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * �� �ΰ����� ������ ��� ����ȿ���� ���ʿ�����(�������� ���� �������)���� �ͼӵ� </td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. �򰡹ݿ� ������</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ����/�縮��/���� - �뿩������</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������/�縮������/��������/�߰��̿� - ��������</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ���°������ - �°�����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������ݹ߻� - ��������</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������ݼ��� - ��������</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. �ߵ����� ����� ���׺� �߻��� (�������� ���� ����)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��������� ������ �ߵ����� ������� ������ �� ���	</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> ������� ���ʿ����ڿ� ��������� ���ʿ����ڰ� ���� ��� : �Ϲ����� ��������� �߻�/������ ���� �����ϰ� ó��</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> ������� ���ʿ����ڿ� ��������� ���ʿ����ڰ� �ٸ� ��� : ����� ���׺� ��ŭ�� ������� ���ʿ����� ����ȿ������ ����</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * ��Ÿ�� ������ �ߵ����� ������� ������ �� ���</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> �⺻�����δ� �Ϲ����� ��������� �߻�/������ ���� �����ϰ� ó���ϵ�,</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Ư���� ������ �ִ� ��� ���������� �Ǵ��Ͽ� ���� ��������ڿ��� �ͼӽ�ų �� ����</td>
  </tr>    
<%	num++;%>
  <tr>
    <td><%=num%>. ��� ����ȿ���� �򰡴� 2009-01-01 ���� �뿩���õ� �ǿ��� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��, ����°������� �뿩������ ������ ���� ���߰��̿� ������ 2009-01-01 ���� ��ุ�� ���� �� �ݿ�)  
    </td>
  </tr>
  </table>
</form>
</body>
</html>
