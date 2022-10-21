<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");	
	String gu_nm 		= request.getParameter("gu_nm")		==null?"":request.getParameter("gu_nm");		

	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");	
	
	String destname 	= request.getParameter("destname")	==null?"":request.getParameter("destname");
	String destphone 	= request.getParameter("destphone")	==null?"":request.getParameter("destphone");
	String firm_nm 		= request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");

	String user_id 		= login.getCookieValue(request, "acar_id");
	String user_nm 		= login.getAcarName(user_id);

		
	String msg = "";
	
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
<!--
	.phonemsgbox {
		width:100px; height:105px;
		font-family:����ü;
		font-size:9pt;
		overflow:hidden;
		border-style:none;
		border-top-width:0px;
		border-bottom-width:0px;
		background:none;
	}

	.phonemsglen {
		font-family:����ü;
		font-size:9pt;
		overflow:hidden;
		border-style:none;
		border-top-width:0px;
		border-bottom-width:0px;
		background:none;
	}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
	function SelText()
	{ 		
		document.form1.txtMessage.msglen = 0;
	}

	//�޽��� �Է½� string() ���� üũ
	function checklen()
	{
		var msgtext, msglen;
		var maxlen = 0;
	
		msgtext = document.form1.txtMessage.value;
		msglen 	= document.form1.msglen.value;
		
		if(document.form1.auto_yn.checked == false){
			maxlen = 80;
		}else{
			maxlen = 58;
		
			if(document.form1.user_pos.value==""){
				msgtext = msgtext+"-�Ƹ���ī "+document.form1.s_bus[document.form1.s_bus.selectedIndex].text+"-";
			}else{
				msgtext = msgtext+"-�Ƹ���ī "+document.form1.user_pos.value+" "+document.form1.s_bus[document.form1.s_bus.selectedIndex].text+"-";
			}		
		}
		maxlen = 2000;
		
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
			if(l>maxlen)
			{
				alert("�޽������� ��� ���� �̻��� ���� ���̽��ϴ�.\n �޽��������� �ѱ� "+(maxlen/2)+"��, ����"+(maxlen)+"�ڱ����� ���� �� �ֽ��ϴ�.");
				temp = document.form1.txtMessage.value.substr(0,i);
				document.form1.txtMessage.value = temp;
				l = lastl;
				break;
			}
			lastl = l;
			i++;
		}
		
		form1.msglen.value=l;
	
		var msg_cnt = Math.floor(l/80);
		if(l%80 != 0) msg_cnt++;
		form1.msg_cnt.value=msg_cnt;	
	}



	//���ڳ��� �߼��ϱ�
	function send(){ 
		fm = document.form1;
	
		
		if(fm.txtMessage.value=="")	{
			alert("���� ���� ������ �Է��� �ּ���!!");
			fm.txtMessage.focus();
			return;
		}
	
			if(fm.destphone.value=="")	{
				alert("���Ź�ȣ�� �Է��� �ּ���!!");
				fm.destphone.focus();
				return;
			}
	
			if(!confirm("�ش� ���ڳ����� �߼��Ͻðڽ��ϱ�?"))	return;
			fm.target = "i_no";				
			fm.action = "send_case.jsp";
			fm.submit();		

	}


	

//-->
</script>


</head>

<body leftmargin="15">
<form method="post" name="form1">
<input name="user_nm" 	type="hidden" value="<%= user_nm %>">
<input name="msg" 	type="hidden">
<input name="mode" 	type="hidden">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > <span class=style5>SMS�߼�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=10>
					  <br>
					  <span class=style4>�� �ܹ��ڴ� 80byte ������ ���ҵǾ� ���۵˴ϴ�. �幮�ڴ� 2000byte�̳� ���ڿ��� �����մϴ�.</span></td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width="15%">�޴»��</td>
                    <td>&nbsp;
					<input type="text" name="destname" size="15" class="text" value="<%=destname%>"></td>
					<td class="title" width="15%">���Ź�ȣ</td>
                    <td>&nbsp;
					<input type="text" name="destphone" size="15" class="text" value="<%=destphone%>"></td>
                </tr>		
                <tr> 
                    <td class="title">����</td>
                    <td colspan="3">&nbsp;
						<textarea name="txtMessage" cols='60' rows='7'><%=msg%></textarea> </td>
                </tr>
                <tr> 
                    <td class="title" width="80">ȸ�Ź�ȣ</td>
                    <td colspan="3">&nbsp;
					<%-- <input type="text" name="user_m_tel" size="15" class="text" value="<%=user_m_tel%>"></td> --%>
					<input type="text" name="user_m_tel" size="15" class="text" value="<%=sender_bean.getUser_m_tel()%>"></td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	 <tr> 
        <td align="center"><a href="javascript:send();"><img src="/acar/images/center/button_send_smsgo.gif"  align="absmiddle" border="0"></a></td>
    </tr>

</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
