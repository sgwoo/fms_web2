<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>


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

  <table border="0" cellspacing="0" cellpadding="0" width="100%">
   <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>��Ȳ �� ��� > �Ű����� > <span class=style5>�Ű������ܰ�������Ȳ ����</span></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>        
  <tr> 
  	  <td>�� �Ű����� �ܰ� ���� �м���󿡼� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. �������� : ����Ʈ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. ���°� : ����Ʈ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. ����� �����ϳ� �����ܰ� 0 : ����Ʈ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. ������� ���� ���� : ����Ʈ���� ������ �м���󿡼� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. �����뿩 ���� : ����Ʈ���� ���� (���� �̷��� �ִ� ������)</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>      
  <tr> 
  	  <td>�� �Ű����� �ܰ� ���� �м� ����Ʈ ���� ���� </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. ������� ���� �ش�� �м���󿡼� ���� -> ����������� ���ش����� ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. ��������� 2009��1��1�Ϻ��� ũ�ų� �������� ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. ������ �뿩�Ⱓ 12�������� �۰ų� ������ �м� ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. �Ű������ 201301���� ũ�ų� �������� ���� ����</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. �Ϲݽ¿� LPG���� ��ü / 1.�ش� / 0.���ش� ���� �����Ͽ� �м�</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>      
  <tr> 
  	  <td>�� �ܰ� �Ѽ��� : �縮������+�������+�Ű�����+�ʰ�����뿩��߻�-�Ű�������</td>
  </tr>
  <tr> 
  	  <td>�� �ܰ����� �հ� : �縮������1+�縮������2+�������+�Ű����� </td>
  </tr>
  <tr> 
  	  <td>�� �ʰ����� �뿩�� �հ� : �������꼭���� �ʰ�����뿩�� ���ް� �� 1.1, ��������� �Ϻμ��ݽ� �ʰ�����뿩�� ���� �׸� ���� �Ұ��ϹǷ�, �߻������� ��ü (���� ä������ �ν�)</td>
  </tr>
    <tr> 
  	  <td>�� �Ű������� �հ� (����/��ǰ/����ǰ������/�߰�������/Ź�۷�) : ����� �Ű������� �հ� (�ڻ������� �߰������ᰡ ���� ��쿡�� �߰������ᵵ �ջ�)</td>
  </tr>  
  <tr> 
  	  <td>�� �����ܰ� ������� ���ǿ��� �Ⱓ : �߰��̿�ȿ�� ���(�뿩������ ���� ���ǿ����� ��ุ��)�̳� ���ǿ���ȿ����ϰ�(�뿩���������� ���ǿ����� ������)���� <br>&nbsp;&nbsp;&nbsp;�����ܰ��� ������� ���� ����� ��� �����뿩�Ⱓ�� ���� �뿩�Ⱓ�� ���̸� �ջ��Ͽ� ǥ��</td>
  </tr>  
  <tr> 
  	  <td>�� ����Ʈ �뿩�Ⱓ : ����Ʈ �뿩�Ⱓ ������ �뿩�Ⱓ �Ѱ����� ǥ�� </td>
  </tr>
  <tr> 
  	  <td>�� �뿩������ : ���� ��ุ�� �Ǵ� �ߵ�������  </td>
  </tr>
  <tr> 
  	  <td>�� ���Կɼ� �ִ� ����/�縮�� ���� �����뿩�Ⱓ : (���� �뿩������- �뿩������)/365*12 �̴�  </td>
  </tr>
    <tr>
        <td class=h></td>
    </tr> 
  <tr> 
  	  <td>�� �����ܰ� ���� DATA :  </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. ��ุ��� �����ܰ�</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. �ߵ��ؾ�� �����ܰ� (�ߵ��ؾ�� ����)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. �߰��̿�ȿ�� ���� (���ǿ��� �� ��ุ��)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. ���ǿ���ȿ�� ���� (���ǿ��� �� ������)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. �߰��� �ڻ����� �߰��� �Ÿűݾ�</td>
  </tr>    
    <tr>
        <td class=h></td>
    </tr>                     
  <tr> 
  	  <td>�� �����ܰ�  </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. ��౸���� ��ุ���� ��� ��� �����ܰ�</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. �ߵ��ؾ��� ��� �ߵ����� ����ȿ������ ����ϰ� �ִ� �ߵ��ؾ��� ���� �����ܰ�</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. ���Կɼ��ִ� ���� ������� ��� ���� ����� �����ܰ�</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. ���ǿ����� ��ุ����� ��� �濵���� > ����ȿ������ > �߰��̿�ȿ������� �������� �����ܰ�</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. ���ǿ����� ������� ��� �������� > ������ > �濵���� > ����ȿ������ > ���ǿ���ȿ������� ����뿩�����ϱ����� �����ܰ�</td>
  </tr>
  <tr>
        <td class=h></td>
    </tr>                     
  <tr> 
  	  <td>�� ������� : ����, ��������, �縮��, �縮������  </td>
  </tr>
  <tr> 
  	  <td>�� �Ű���� (���/���Կɼ�) : ���Կɼ����� �����Կɼ��� �ŵ���, ������0 </td>
  </tr>
  <tr> 
  	  <td>�� �Ű����� (���� ��� �����ܰ� ����) :��ุ���� ��� ���� ��� �����ܰ���, �ߵ��ؾ��� ��� �ߵ����� ����ȿ������ ����ϰ� �ִ� �ߵ��ؾ��� ���� ���� ��� �����ܰ��� �������� ������ ������  </td>
  </tr>
  <tr> 
  	  <td>�� ����Ÿ� : ��Ű��� ��ų�����Ȳ�� ����Ÿ� ����ϰ� ���Կɼ� ���� ��������Ÿ� ��� </td>
  </tr>
  </table>
</form>
</body>
</html>
