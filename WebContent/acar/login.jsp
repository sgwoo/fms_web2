<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.database.*, acar.util.*, acar.beans.*, acar.ma.*"%>
<%
	String id = request.getParameter("id")==null?"":request.getParameter("id");
	String pw = request.getParameter("pw")==null?"":request.getParameter("pw");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	
	Login login = Login.getInstance();
	String result = "0";
	String user_id = "";
	int count = 0;
	
//	if(login.hasCookie(request, "acar_id")){//�α��� ��Ű Ȯ��
//		result = "9";
//	}else{
		//����� ID&PW Ȯ��
		result = login.getLogin(id, pw, response);
		
		//loginó��=�α�����,���ó��
		if(result.length() == 6){
			String login_time = Util.getLoginTime();//�α��νð�
			String login_ip = request.getRemoteAddr();//�α���IP
			user_id = result;
			
			//���������
			MaUserDatabase u_db = MaUserDatabase.getInstance();
			MaUsersBean ubean = u_db.getUserCase(user_id);
			
			//ip_log ���
			count = login.insertLoginLog(login_ip, user_id, login_time);
			//��ٰ���
			count = login.insertAttend(login_ip, user_id, login_time);
			
			System.out.println("[�α���] DT:"+login_time+", ID:"+user_id+"("+ubean.getUser_nm()+")");
		}
//	}
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
<script language='javascript'>
<!--
<%	if(result.length() == 6){
		login.setDisplayCookie(s_width, s_height, response);//���÷��� ������ ��Ű����%>
	var SUBWIN="menu/emp_frame.jsp";	
	var newwin=window.open("","newFMS","scrollbars=yes, status=yes, resizable=1, fullscreen=yes" );
	if (document.all){
		newwin.moveTo(0,0);
		newwin.resizeTo(screen.width,screen.height-50);
	}	
	newwin.location=SUBWIN;
<%	}else{%>
<%		if(result.equals("9")){%>
			alert('�̹� �α��εǾ� �ֽ��ϴ�.\n\n�����ִ� FMS�� �α׾ƿ� �Ͻʽÿ�.');
<%		}else if(result.equals("2")){%>
			alert('�����ͺ��̽� �����Դϴ�.\n\n�������� �����Ͻʽÿ�.');	
<%		}else{%>
			alert('ID�� PWD�� Ʋ���ϴ�.');
<%		}%>
<%	}%>
//-->
</script>
</HEAD>
<BODY>
</BODY>
</HTML>