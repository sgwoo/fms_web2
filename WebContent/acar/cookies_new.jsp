<%
	String user_id = "";
	String br_id = "";
	String dept_id = "";
	String user_aut = "";
	String s_width = "";
	String s_height = "";
	
	Cookie cookies[] = request.getCookies();
	if(cookies != null){ //��Ű�� ������
		for (int i = 0 ; i < cookies.length ; i++){
			String name = cookies[i].getName();
			
			if (name.equals("acar_id")) {//����� ���̵�
				user_id =  cookies[i].getValue();
			}
			if (name.equals("acar_br")) {//����� �Ҽӿ�����
				br_id =  cookies[i].getValue();
			}
			if (name.equals("acar_de")) {//����� �ҼӺμ�
				dept_id = cookies[i].getValue();
			}
			if (name.equals("acar_aut")) {//����� ���� ����
				user_aut = cookies[i].getValue();
			}
			if (name.equals("s_width")) {//����� ����� ������-����
				s_width = cookies[i].getValue();
			}
			if (name.equals("s_height")) {//����� ����� ������-����
				s_height = cookies[i].getValue();
			}
		}
	}else{ //��Ű�� ������
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
	if (user_id.equals("")){//��Ű�� ����.
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
	if (user_id.equals("000122")){//����� �ڵ��ƿ�
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
%>