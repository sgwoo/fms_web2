<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");// 
	
	String s_user_id= request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");	
	
	out.println("s_user_id =" + s_user_id);
	out.println("user_id =" + user_id);	
	
	int flag = 0;
	int count = 0;
	
	//[1�ܰ�] ������ ����Ÿ�� ������ ����
	if(!umd.deleteAuthCopy(user_id))	flag += 1;
	
	out.println ("1 �ܰ�");
		
	//[2�ܰ�] source ����� -> target ����ڿ��� ���� ���� 
	Vector vt = umd.getUserAuth(s_user_id);
	int vt_size = vt.size();
		
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		flag = 0;
			
		String m_st 	= String.valueOf(ht.get("M_ST"));
		String m_st2 	= String.valueOf(ht.get("M_ST2"));
		String m_cd 	= String.valueOf(ht.get("M_CD"));
		String auth_rw 	= String.valueOf(ht.get("AUTH_RW"));
					
		AuthBean  au_bean = new AuthBean ();
		
		au_bean.setUser_id(user_id); // �߰��� �����
	  	au_bean.setM_st(m_st); 
		au_bean.setM_st2(m_st2); 
		au_bean.setM_cd(m_cd);   
 		au_bean.setAuth_rw(auth_rw);   

		if(!umd.insertAuthCopy(au_bean))	flag += 1;

	}
	
	out.println ("2 �ܰ�");
	
%>
<form name='form1' method="POST">
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('�����߻�!');
//		location='about:blank';
<%	}else if(count == 1){%>
		alert('�����߻�!');
//		location='about:blank';	
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
//		parent.close();
<%	}%>
</script>
</body>
</html>
