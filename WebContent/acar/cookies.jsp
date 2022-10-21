<jsp:useBean id="memberBean" scope="request" class="acar.util.LoginBean"/>

<%
 
	String ck_acar_id 	= memberBean.getSessionValue(request, "USER_ID");
	String acar_de 		= memberBean.getSessionValue(request, "DEPT_ID");
	String acar_br 		= memberBean.getSessionValue(request, "BR_ID");
	String session_user_nm 		= memberBean.getSessionValue(request, "USER_NM");
	String user_aut 	= memberBean.getSessionValue(request, "USER_AUT");
	String s_width 		= "";
	String s_height 	= "";
	
	boolean isExtStaff = false;
	String extStaffType = "";
	
	if( acar_de.equals("1000") || acar_de.equals("8888") ){
		isExtStaff = true;
		extStaffType = acar_de.equals("1000") ? "A" : "P";
	}
	
	Cookie cookies[] = request.getCookies();
	if(cookies != null){
		for (int i = 0 ; i < cookies.length ; i++){
			String name = cookies[i].getName();
			if (name.equals("s_width")) {
				s_width = cookies[i].getValue();
			}
			if (name.equals("s_height")) {
				s_height = cookies[i].getValue();
			}
		}
	}
	      
	if (!memberBean.isLogin(request)){
		response.sendRedirect("/acar/index.jsp");
		return;
	}
			
	int emp_top_height = 115;
	int sh_line_height = 33;
	int sc_line_height = 40;
	
%>
