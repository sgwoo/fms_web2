<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector clients = al_db.getClientList(s_kd, t_wd, "0");
	int client_size = clients.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>

<body>
<table width="800" border="0" cellspacing="1" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding='0' width=800>
              <tr> 
                <td class='title' width="100">��ȣ&nbsp; </td>
                <td class='left' colspan="2">&nbsp;(��)�븲���</td>
                <td class=title width="100">�����</td>
                <td class='left' colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>��뺻����</td>
                <td class='left' colspan="5">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>����� �ּ�</td>
                <td class='left' colspan="5">&nbsp;</td>
              </tr>
              <tr> 
                <td class='title'>ȸ����ȭ��ȣ</td>
                <td class='left' width="148">&nbsp;</td>
                <td class='title' width="100">�޴���</td>
                <td class='left' width="99">&nbsp;</td>
                <td class='title' width="100">������ȭ��ȣ</td>
                <td class='left'>&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td colspan="2">&lt; ��ฮ��Ʈ &gt;</td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='30' class='title'>����</td>
                <td width='80' class='title'>�����</td>
                <td class='title' width="100" >������ȣ</td>
                <td width='80' class='title'>����</td>
                <td width='80' class='title'>���ʵ����</td>
                <td width='70' class='title'>�뿩��ǰ</td>
                <td width='70' class='title'>�뿩�Ⱓ</td>
                <td width='80' class='title'>�뿩������</td>
                <td width='80' class='title'>��ุ����</td>
                <td width='70' class='title'>�������</td>
                <td width='70' class='title'>�������</td>
              </tr>
              <tr> 
                <td align='center'>1</td>
                <td align='center'>2001-01-27</td>
                <td align='center'><span title='����34��6212'>����34��6212</span></td>
                <td align='center'>�׶�ĭ</td>
                <td align='center'>2002-10-29</td>
                <td align='center'>��Ʈ �Ϲݽ�</td>
                <td align='center'>36����</td>
                <td align='center'>2001-02-09</td>
                <td align='center'>2004-02-08</td>
                <td align='center'>������</td>
                <td align='center'>����ȣ</td>
              </tr>
              <tr> 
                <td align='center'>2</td>
                <td align='center'>2001-02-16</td>
                <td width='-2' align='center'><span title='����34��6158'>����34��6158</span></td>
                <td align='center'>�׶�ĭ</td>
                <td align='center'>2002-01-21</td>
                <td align='center'>��Ʈ �Ϲݽ�</td>
                <td align='center'>36����</td>
                <td align='center'>2004-04-01</td>
                <td align='center'>2004-12-31</td>
                <td align='center'>������</td>
                <td align='center'>�̱���</td>
              </tr>
              <tr> 
                <td align='center'>3</td>
                <td align='center'>2001-03-19</td>
                <td width='-2' align='center'><span title='����31��8064'>����31��8064</span></td>
                <td align='center'>�׶�ĭ</td>
                <td align='center'>2001-04-09</td>
                <td align='center'>��Ʈ �Ϲݽ�</td>
                <td align='center'>36����</td>
                <td align='center'>2001-04-09</td>
                <td align='center'>2004-04-08</td>
                <td align='center'>������</td>
                <td align='center'>���</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td>&lt; �ŷ�ó�湮 ������ &gt; </td>
          <td align="right">
            <!--<font color="#666666"> �� <a href="javascript:MM_openBrWindow('client_loop2.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=600,height=600,top=50,left=50')">�ŷ�ó�湮�ֱ�</a> 
              : <font color="#FF0000">�Ѵ�</font></font>-->
          </td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width='80'>���������</td>
                <td width="120">&nbsp;���ֿ�</td>
                <td class='title' width="80">���ʹ湮����</td>
                <td width="120">&nbsp; <input type="text" name="t_wd323" size="10" class=text value="2004-01-01"> 
                </td>
                <td class='title' width="80">�湮�ֱ�</td>
                <td width="120">&nbsp; <input type="text" name="t_wd32332" size="2" class=text value="1">
                  ���� 
                  <input type="text" name="t_wd323322" size="2" class=text value="0">
                  ��</td>
                <td class='title' width="80">�湮Ƚ��</td>
                <td width="120">&nbsp; <input type="text" name="t_wd3233" size="3" class=text value="36">
                  ȸ</td>
              </tr>
            </table></td>
        </tr>
        <tr align="right"> 
          <td colspan="2"><font color="#666666"><a href="#">�湮������ ����</a>||<a href="#">�������߰�����</a>||<a href="#">�ŷ�ó�湮 
            �����ٻ���</a></font></td>
        </tr>
        <tr> 
          <td class=line colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width='29'>ȸ��</td>
                <td class='title' width="100">�����湮������</td>
                <td class='title' width="78">�湮����</td>
                <td class='title' width="59">�湮��</td>
                <td class='title' width="98">�湮����</td>
                <td class='title' width="98">�����</td>
                <td class='title' width="246">��㳻��</td>
                <td class='title' width="39">���</td>
                <td class='title' width="43">����</td>
              </tr>
              <tr> 
                <td align='center'>1</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> ���ֿ�</td>
                <td align="center">&nbsp; ��ȸ�湮</td>
                <td align="center">ȫ�浿</td>
                <td>����湮</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>2</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> ���ֿ�</td>
                <td align="center">&nbsp; �����</td>
                <td align="center">ȫ�浿</td>
                <td>��������</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>3</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> ���ֿ�</td>
                <td align="center">&nbsp; ��ü</td>
                <td align="center">ȫ�浿</td>
                <td>�뿩�� �Ա� ����</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>4</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> ���ֿ�</td>
                <td align="center">&nbsp; ������Ǻ���</td>
                <td align="center">ȫ�浿</td>
                <td>��࿬��</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>5</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> 2004-01-01</td>
                <td align="center"> ���ֿ�</td>
                <td align="center">&nbsp; ��Ÿ</td>
                <td align="center">ȫ�浿</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">U</a></td>
                <td align="center"><a href="#">D</a></td>
              </tr>
              <tr> 
                <td align='center'>6</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
              <tr> 
                <td align='center'>7</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
              <tr> 
                <td align='center'>8</td>
                <td align="center"> 2004-01-01</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><a href="javascript:MM_openBrWindow('vist_reg.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50')">R</a></td>
                <td align="center">-</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="center" colspan="2"><a href="car_serv_reg2.htm">�ŷ�ó�湮 ��� 
            �� �ڵ�������� �̵�</a></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
