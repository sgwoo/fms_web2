<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.partner.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%

	int count = 0;
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String off_id 		= request.getParameter("off_id")		==null?"":request.getParameter("off_id");
	String bank_id 		= request.getParameter("bank_id")		==null?"":request.getParameter("bank_id");
	String acc_no 		= request.getParameter("acc_no")		==null?"":request.getParameter("acc_no");
	String etc 		= request.getParameter("etc")	==null?"":request.getParameter("etc");
	String cmd 		= request.getParameter("cmd")		==null?"":request.getParameter("cmd");
	int seq 	= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	String off_st = "serv_off";
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	if(cmd.equals("in")){
		count = se_dt.InsertServ_EmpBank_acc(off_st, off_id, user_id, bank_id, acc_no, etc);
	}else if(cmd.equals("up")){
		count = se_dt.UpdateServ_EmpBank_acc(seq, off_id, user_id, bank_id, acc_no, etc);
	}else if(cmd.equals("de")){
		count = se_dt.DeleteServ_EmpBank_acc(seq, off_id, bank_id);
	}
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<script language="JavaScript">
<!--
	function go_parent(){
		var fm = document.form1;
		fm.action = "serv_emp_frame.jsp";
		fm.target = 'd_content';
		//if(confirm('����������� ���ΰ�ħ �Ͻðڽ��ϱ�?')){	
			fm.submit();
		//}
	}

//-->
</script>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 	value="<%=user_id%>">
  <input type="hidden" name="br_id" 	value="<%=br_id%>">    

</form>
<script language='javascript'>
<%	if(count==1){%>
	<%if(cmd.equals("in")){%>
		alert('���������� ��� �Ǿ����ϴ�.\n\n��ϵ� ������ Ȯ���Ͻ÷��� ���ΰ�ħ�� �ϼ���.');		
	<%}else if(cmd.equals("up")){%>
		alert('���������� ���� �Ǿ����ϴ�.\n\n��ϵ� ������ Ȯ���Ͻ÷��� ���ΰ�ħ�� �ϼ���.');		
	<%}else if(cmd.equals("de")){%>
		alert('���������� ���� �Ǿ����ϴ�.\n\n��ϵ� ������ Ȯ���Ͻ÷��� ���ΰ�ħ�� �ϼ���.');		
	<%}%>
//		go_parent();
//		parent.opener.location.reload();
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');
<%	}	%>

	self.window.close();
	
</script>
<body>
</body>
</html>