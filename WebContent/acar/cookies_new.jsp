<%
	String user_id = "";
	String br_id = "";
	String dept_id = "";
	String user_aut = "";
	String s_width = "";
	String s_height = "";
	
	Cookie cookies[] = request.getCookies();
	if(cookies != null){ //쿠키가 있으면
		for (int i = 0 ; i < cookies.length ; i++){
			String name = cookies[i].getName();
			
			if (name.equals("acar_id")) {//사용자 아이디
				user_id =  cookies[i].getValue();
			}
			if (name.equals("acar_br")) {//사용자 소속영업소
				br_id =  cookies[i].getValue();
			}
			if (name.equals("acar_de")) {//사용자 소속부서
				dept_id = cookies[i].getValue();
			}
			if (name.equals("acar_aut")) {//사용자 어드민 권한
				user_aut = cookies[i].getValue();
			}
			if (name.equals("s_width")) {//사용자 모니터 사이즈-가로
				s_width = cookies[i].getValue();
			}
			if (name.equals("s_height")) {//사용자 모니터 사이즈-세로
				s_height = cookies[i].getValue();
			}
		}
	}else{ //쿠키가 없으면
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
	if (user_id.equals("")){//쿠키가 없다.
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
	if (user_id.equals("000122")){//퇴사자 자동아웃
		response.sendRedirect("/acar/index.jsp");
		return;
	}
	
%>