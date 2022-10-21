<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
   //��ũ���� �ΰ��̻��ΰ�� ����
	int cnt = 3; //�˻� ���μ�
    int sh_height = cnt*sh_line_height;
  	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
  	

%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

	//�׸� ���
	function reg_poll()
	{
		var fm = document.form1;	
		fm.target = "d_content";
		fm.action = "poll_i.jsp";
		fm.submit();	
	}
	

	function PollUpdate(seq){	
			var fm = document.form1;	
			fm.target = "d_content";
			fm.poll_id.value = seq;
			fm.submit();	
		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
		
	
	Vector polls = p_db.getPollAll();
	int poll_size = polls.size();
		

%>
<form name='form1' method='post' target='d_content' action='/acar/call/poll_u.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='poll_id' value=''>
<input type='hidden' name='c_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>    
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr>
		<td align='right'><a href='javascript:reg_poll()' onMouseOver="window.status=''; return true"><img src="../images/center/button_reg.gif" align="absmiddle" border="0"></a></td>
	</tr>
<%	}%>	
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr>        
                    <td width=5% class=title>����</td>
                    <td width=10% class=title>������ȭŸ��</td>				  
                    <td width=31% class=title>���ǳ���</td>		  
                    <td width=24% class=title>�亯1</td>
                    <td width=24% class=title>�亯2</td>
                    <td width=6% class=title>��뿩��</td>
                </tr>
    		<%if(poll_size > 0){
    			for(int i = 0 ; i < poll_size ; i++){
    				Hashtable poll = (Hashtable)polls.elementAt(i);%>
                <tr>       
                    <td align=center><%=i+1%></td>
                    <td align=center><%=poll.get("POLL_ST_NM")%></td>
                    <td align=center>
                        <table border=0 cellspacing=0 width=100% cellpadding=3>
                            <tr>        
                                <td><a href="javascript:PollUpdate('<%=poll.get("POLL_ID")%>')"><%=poll.get("QUESTION")%></a></td>
                            </tR>
                        </table>
                    </td>
                    <td align=center>
                        <table border=0 cellspacing=0 width=100% cellpadding=3>
                            <tr>        
                                <td><%=poll.get("ANSWER1")%></td>
                            </tR>
                        </table>
                    </td>
                    <td align=center> <%=poll.get("ANSWER2")%> </td>
                    <td align=center><%=poll.get("USE_YN")%></td>
                </tr>
            <%	}%>
            <%}else{%>
                <tr> 
                    <td colspan=4 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
            <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
