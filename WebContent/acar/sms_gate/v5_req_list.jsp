<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String senddate = request.getParameter("senddate")==null?"":request.getParameter("senddate");
	String cmid 	= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Hashtable ht = umd.getSmsResult_V5_req(cmid, senddate);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	msg = (String)ht.get("MSG_BODY");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>

<body>
<form name="form1" method="post">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>SMS���ڿ��೻��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr><%	String send_name = c_db.getNameById((String)ht.get("SEND_NAME"), "USER");
						if(send_name.equals("")) send_name = (String)ht.get("SEND_NAME"); %>
                    <td class="title" width=12%>�߽���</td>
                    <td width=38%>&nbsp;<%= send_name %></td>
                    <td width=12% class="title">ȸ�Ź�ȣ</td>
                    <td width=38%>&nbsp;<%= ht.get("SEND_PHONE") %></td>
                </tr>
                <tr>
                    <td class="title">�����޼��� </td>
                    <td colspan="3">&nbsp;<textarea name="msg" rows="5" cols="100" onKeyUp="javascript:checklen()" style='IME-MODE: active'><%= msg %></textarea>
        			  &nbsp;&nbsp;<input class="whitenum" type="text" name="msglen" size="2" maxlength="2" readonly value=0>
					</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߼� ���</span></td>
    </tr>
    <tr> 
        <td>
            <table width="1000" border="0" cellspacing="0" cellpadding="0">
                <tr><td class=line2></td></tr>
                <tr> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="100" class="title">����</td>
                        <td width="200" class="title">�����ڸ�</td>
                        <td width="150" class="title">�����ڹ�ȣ</td>
                        <td width="100" class="title">����</td>
                        <td width="100" class="title">���</td>
                        <td width="200" class="title">���޵�(��)�ð�</td>
                        <td width="150" class="title">��������ð�</td>
                      </tr>
                    </table></td>
                </tr>
      </table></td>
  </tr>
  <tr>
    <td><iframe src="v5_req_list_in.jsp?cmid=<%=cmid%>" name="inner" width="1020" height="400" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
            </iframe></td>
  </tr>
</table>
</form>
<script language="JavaScript">
<!--
checklen();

//�޽��� �Է½� string() ���� üũ
function checklen()
{
	var msgtext, msglen;
	var maxlen = 0;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	maxlen = 80;
	
	var i=0,l=0;
	var temp,lastl;
	
	//���̸� ���Ѵ�.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		/*
		if(l>maxlen)
		{
			alert("�޽������� ��� ���� �̻��� ���� ���̽��ϴ�.\n �޽��������� �ѱ� "+(maxlen/2)+"��, ����"+(maxlen)+"�ڱ����� ���� �� �ֽ��ϴ�.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		*/
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
}	
//-->
</script>
</body>
</html>