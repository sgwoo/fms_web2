<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%

	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
//	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
//	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
		
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String work_st = request.getParameter("work_st")==null?"1":request.getParameter("work_st");
	String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	
		//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id 	= login.getCookieValue(request, "acar_id");
	String br_id 	= login.getCookieValue(request, "acar_br");
	if(br_id.equals("S1")) br_id = "";
	
	
	int tot_amt  = 0;
	int vat_amt  = 0;
	int gr_amt = 0;

	String[] ch_call = request.getParameterValues("ch_all");	

	int vid_size = ch_call.length;
			
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
					
	int flag = 0;
	int count =0;
	boolean flag1 = true;
			
	String value[] = new String[13];
	
	String serv_st		="";
	String car_mng_id	="";
	String serv_id 		="";
	String car_no		="";
	String car_nm		="";
	String client_nm	="";
	String sa_code		="";
	String user_nm		="";
	String item3 		="";
	String labor 		="";
	String amt	 		="";
			
		
	for(int i=0; i < vid_size; i++){
		
		StringTokenizer st = new StringTokenizer(ch_call[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		serv_st		= value[0];
		car_mng_id	= value[1];
		serv_id 	= value[2];
		car_no 		= value[3]+ "(" + value[4] + ")";
		client_nm	= value[5]+ " " + value[8] + " " + value[3] + "("+ value[7]+ ")";
		sa_code		= value[6];
		user_nm		= value[7];
		amt	   = value[9]+ "^" +  value[10];
		st_dt  = value[11];
		end_dt = value[12];
	
			
		//정산정보 정비테이블에 저장하기
							
		if(!serv_id.equals("")){
			//자동차정비등록정보
			ServiceBean sr_bean = cs_db.getServiceId(car_mng_id, serv_id);
		//	System.out.println("set_dt="+sr_bean.getSet_dt());
		//	System.out.println("car_mng_id="+car_mng_id);
		//	System.out.println("serv_id="+serv_id);
		//	System.out.println("work_st="+work_st);
		//	System.out.println("jung_st="+sr_bean.getJung_st());
			
			if(sr_bean.getJung_st().equals("미정산") ){
			    sr_bean.setSet_dt(exp_dt);
			    sr_bean.setJung_st(work_st);
				sr_bean.setUpdate_id(user_id);
				
				flag1 = cs_db.updateServiceAutoDocu(sr_bean);
			}
		}
	
	}

//	System.out.println(end_dt);
	
%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
</form>

<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
<%	}else if(count == 1){%>
		alert('자동전표 오류발생!');
		location='about:blank';		
<%	}else if(!flag1){%>
		alert('자동전표 수정 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');	
		close();
<%	}%>
</script>
종료
</body>
</html>
