<%@include file="/acar/sessionAuth.jsp" %>
<%@include file="/acar/cookies.jsp" %>
<%

String user_id = ck_acar_id;
String br_id = acar_br;
String dept_id = acar_de;

	/*
	
	String ck_acar_id = "";
	String acar_de = "";
	String acar_br = "";
	String user_id = "";
	String br_id = "";
	String user_aut = "";
	String s_width = "";
	String s_height = "";
	
	Cookie cookies[] = request.getCookies();
	if(cookies != null){ //쿠키가 있으면
		for (int i = 0 ; i < cookies.length ; i++){
			String name = cookies[i].getName();
			
			if (name.equals("acar_id")) {//사용자 아이디
				ck_acar_id =  cookies[i].getValue();
				user_id = ck_acar_id;
			}
			if (name.equals("acar_br")) {//사용자 소속영업소
				acar_br =  cookies[i].getValue();
				br_id = acar_br;
			}
			if (name.equals("acar_de")) {//사용자 소속부서
				acar_de = cookies[i].getValue();
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
		response.sendRedirect("index.jsp");
		return;
	}
	
	if (ck_acar_id.equals("")){//쿠키가 없다.
		response.sendRedirect("index.jsp");
		return;
	}
	if (ck_acar_id.equals("000122")){//퇴사자 자동아웃
		response.sendRedirect("index.jsp");
		return;
	}

	int emp_top_height = 115;	//탑메뉴 길이
	int sh_line_height = 33;	//검색 라인 길이
	int sc_line_height = 40;	//통계 라인 길이
	*/
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String t_wd1 = request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 = request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String s_br = request.getParameter("s_br")==null?"":request.getParameter("s_br");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String gubun8 = request.getParameter("gubun8")==null?"":request.getParameter("gubun8");
	String chk1 = request.getParameter("chk1")==null?"":request.getParameter("chk1");
	String chk2 = request.getParameter("chk2")==null?"":request.getParameter("chk2");
	String chk3 = request.getParameter("chk3")==null?"":request.getParameter("chk3");
	String chk4 = request.getParameter("chk4")==null?"":request.getParameter("chk4");
	String chk5 = request.getParameter("chk5")==null?"":request.getParameter("chk5");
	String chk6 = request.getParameter("chk6")==null?"":request.getParameter("chk6");
	String chk7 = request.getParameter("chk7")==null?"":request.getParameter("chk7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"1":request.getParameter("idx");
	
	String cgs_ok = request.getParameter("cgs_ok")==null?"":request.getParameter("cgs_ok");  //추가
	String dggj_ok = request.getParameter("dggj_ok")==null?"":request.getParameter("dggj_ok"); //추가
	
	String hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
%>
