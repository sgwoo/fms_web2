<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<!-- ���ڹ߼� ���� �бⰡ ���� ../acar/memo/memo_send_mini.jsp �ҽ� ������� ���� �ۼ�.(20180717)-->
<!-- ����������� �������� ���� ������ �� ����ڿ��� �޽����߼� -->
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String send_id 			= request.getParameter("send_id")==null?"":request.getParameter("send_id");
	String rece_id 			= request.getParameter("rece_id")==null?"":request.getParameter("rece_id");
	String m_title 			= request.getParameter("m_title")==null?"":request.getParameter("m_title");
	String m_content 		= request.getParameter("m_content")==null?"":request.getParameter("m_content");
	String agent_emp_nm 	= request.getParameter("agent_emp_nm")==null?"":request.getParameter("agent_emp_nm");
	String agent_emp_m_tel 	= request.getParameter("agent_emp_m_tel")==null?"":request.getParameter("agent_emp_m_tel");
	String send_st		 	= request.getParameter("send_st")==null?"":request.getParameter("send_st");
	
	String agent_mng_emp    = nm_db.getWorkAuthUser("������Ʈ����");
	
	if(send_id.equals("agent_mng")){
		send_id = agent_mng_emp;
	}
	
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	
	
	
	
	String rent_mng_id = "";
	
	CommiBean emp2;
	
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
	fm.action='memo_send_mini_a.jsp';
	fm.target="i_no";
	fm.submit();	
}

function sel_phone_num(num){
	var send_st = '<%=send_st%>';
	if(send_st!="1"){
		fm = document.form1;
		if(num=="02-6263-6390"){	fm.send_id.value = "<%=agent_mng_emp%>";	}
		if(num=="02-6263-6391"){	fm.send_id.value = "<%=agent_mng_emp%>";	}
	}
}
//-->
</script>
</head>
<body onLoad="javascript:self.focus()">
<form action="" name="form1" method="post">
<input type="hidden" name="send_id" value="<%=send_id%>">
<input type="hidden" name="send_st" value="<%=send_st%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="agent_emp_nm" value="<%=agent_emp_nm%>">
<input type="hidden" name="agent_emp_m_tel" value="<%=agent_emp_m_tel%>">
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
                    <td class="title" width="100">�˸����</td>
                    <td>&nbsp;
        			  <input type='radio' name="send_st" value='3' <%if(m_title.equals("�������� �������� �˸�")){%> checked<%}%>> 
        				SMS ����
					 </td>
                </tr>			
                <tr> 
                    <td class="title" width="100">�޴»��</td>
                    <td>&nbsp;
                    	<%if((send_st.equals("1")) && !agent_emp_nm.equals("") && !agent_emp_m_tel.equals("")){%>
                    	������� <%=agent_emp_nm%>&nbsp;<%=agent_emp_m_tel%>
                    	<%}else if(send_st.equals("2")){%>
                    	����������� <%=agent_emp_nm%>&nbsp;<%=agent_emp_m_tel%>
                    	<%}else if(send_st.equals("3")){%>
                    	���ʿ����� <%=agent_emp_nm%>&nbsp;<%=agent_emp_m_tel%>
                    	<%}%>
                    	<input type="hidden" name="rece_id" value="<%=rece_id%>">
                    </td>
                </tr>		
                <tr> 
                    <td class="title" width="100">����</td>
                    <td>&nbsp;
						<input type="text" name="title" size="60" class=text value='<%=m_title%>'> 
		    		</td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;
						<textarea name="content" cols='60' rows='7'><%=m_content%></textarea> </td>
                </tr>
                <tr> 
                    <td class="title" width="100">ȸ�Ź�ȣ</td>
                    <td>&nbsp;
						<select name="send_phone" onchange="javascript:sel_phone_num(this.value);">
					<%if(send_st.equals("1")){ %>
						<%if(!sender_bean.getHot_tel().equals("")){%>
							<option value="<%=sender_bean.getHot_tel()%>">������ȭ : <%=sender_bean.getHot_tel()%></option>
						<%}%>
		        			<option value="<%=sender_bean.getUser_m_tel()%>">��&nbsp;��&nbsp;��&nbsp; : <%=sender_bean.getUser_m_tel()%></option>        			
		        			<option value="<%=sender_bean.getUser_h_tel()%>">��ǥ��ȭ : <%=sender_bean.getHot_tel()%></option>
					<%}else{ %>
					    <%if(!sender_bean.getHot_tel().equals("")){%>
							<option value="<%=sender_bean.getHot_tel()%>">������ȭ : <%=sender_bean.getHot_tel()%> (<%=sender_bean.getUser_nm()%>) </option>
						<%}%>						
					<%} %>
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
        <td align="center"><a href="javascript:send_memo();"><img src=/acar/images/center/button_memo_send.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td>* ��޽��� ����Ϲ��� ������� ����Ʈ�� �޽����� �Ͽ����ϴ�.</td>
    </tr>	
    <tr>
        <td>* ���ڴ� 80byte �ʰ��ÿ� �幮�ڷ� �߼۵˴ϴ�.</td>
    </tr>	
    <tr>
        <td>* ���ڹ߼۽� [����]�� [-�����»���̸�-]�� �پ �����ϴ�.</td>
    </tr>		
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
