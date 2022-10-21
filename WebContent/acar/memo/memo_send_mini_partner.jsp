<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_work 	= request.getParameter("user_work")==null?"":request.getParameter("user_work");
	String send_id 		= request.getParameter("send_id")==null?"":request.getParameter("send_id");
	String rece_id 		= request.getParameter("rece_id")==null?"":request.getParameter("rece_id");
	String m_title 		= request.getParameter("m_title")==null?"":request.getParameter("m_title");
	String m_content 	= request.getParameter("m_content")==null?"":request.getParameter("m_content");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("8888", user_work, "PARTNER", "Y"); //�ܺξ�ü ����Ʈ
	int user_size = users.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function send_memo(){
	fm = document.form1;	
	
	if(fm.rece_id.value == '')		{	alert('�޴»���� �Է��Ͻʽÿ�');	fm.rece_id.focus();			return;	}	
	if(fm.title.value == '')		{	alert('������ �Է��Ͻʽÿ�');		fm.title.focus();			return;	}
	if(fm.content.value == '')		{	alert('������ �Է��Ͻʽÿ�');		fm.content.focus();			return;	}
	
	if(get_length(fm.content.value) > 4000){
		alert("2000�� ������ �Է��� �� �ֽ��ϴ�.");
		return;
	}
		
	if(!confirm("�����ðڽ��ϱ�?")){ return; }	
	fm.action='memo_send_mini_partner_a.jsp';
	fm.target="i_no";
	fm.submit();	
}
//-->
</script>
</head>
<body onLoad="javascript:self.focus()">
<form action="" name="form1" method="post">
<input type="hidden" name="send_id" value="<%=send_id%>">
<input type="hidden" name="cmd" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �޸��� > <span class=style5> �����޸� ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
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
                    <td class="title" width="80">�˸����</td>
                    <td>&nbsp;						
        			  <input type='radio' name="send_st" value='2'>
        				��޽��� �޽���
        			  <input type='radio' name="send_st" value='3' checked>
        				SMS ����
					 </td>
                </tr>			
                <tr> 
                    <td class="title" width="80">�޴»��</td>
                    <td>&nbsp;
						<select name="rece_id">
        			    	<option value="">����</option>
                        	<%if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        	<option value='<%=user.get("USER_ID")%>' <%if(rece_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_M_TEL")%> <%=user.get("USER_NM")%></option>
                        	<%	}
        					}		%>
                    </select></td>
                </tr>			
                <tr> 
                    <td class="title" width="80">����</td>
                    <td>&nbsp;
						<input type="text" name="title" size="60" class=text value='<%=m_title%>'> </td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;
						<textarea name="content" cols='60' rows='7'><%=m_content%></textarea> </td>
                </tr>
                <tr> 
                    <td class="title" width="80">ȸ�Ź�ȣ</td>
                    <td>&nbsp;
			<select name="send_phone">
				<%if(!sender_bean.getHot_tel().equals("")){%>
				<option value="<%=sender_bean.getHot_tel()%>">������ȭ : <%=sender_bean.getHot_tel()%></option>
				<%}%>
        			<option value="<%=sender_bean.getUser_m_tel()%>">��&nbsp;��&nbsp;��&nbsp; : <%=sender_bean.getUser_m_tel()%></option>        			        			
                    	</select> 
                    	(�����϶�)
                    </td>
                </tr>                             
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:send_memo();"><img src=../images/center/button_memo_send.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td>* ���ڴ� 80byte �ʰ��ÿ� �幮�ڷ� �߼۵˴ϴ�.</td>
    </tr>	
    <tr>
        <td>* ���ڹ߼۽� [����]�� [-�����»���̸�-]�� �پ �����ϴ�.</td>
    </tr>	
	<%if(!rece_id.equals("")){%>
    <tr>
        <td>* �޴»���� ������ �� �ֽ��ϴ�. ����� ���� ���� �˸°� �����Ͻʽÿ�.</td>
    </tr>
	<%}%>	
	<%if(!m_content.equals("")){%>
    <tr>
        <td>* ������ ������ �� �ֽ��ϴ�.</td>
    </tr>
	<%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
