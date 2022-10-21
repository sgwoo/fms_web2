<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>


<%
	String use_yn = request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	
	String ch_cd[]  = request.getParameterValues("ch_cd");

	String off_id = "";
	String cost_b_dt = "";
	String from_place = "";
	String car_comp_id = "";
	String car_cd = "";
	String car_nm  = "";
	
	String vid_num = "";
	int vid_size = 0;
	vid_size = ch_cd.length;
	
	out.println(use_yn+"<br><br>");
	
	boolean flag = true;
	
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = ch_cd[i];
		
		int s=0; 
		String app_value[] = new String[4];	
		StringTokenizer st2 = new StringTokenizer(vid_num,"^");				
		while(st2.hasMoreTokens()){
			app_value[s] = st2.nextToken();
			s++;
		}		
		
		off_id 		= app_value[0];
		cost_b_dt 	= app_value[1];
		from_place 	= app_value[2];
		car_nm 		= app_value[3];
		
		/*
		out.println(vid_num+" - ");
		out.println(off_id);
		out.println(cost_b_dt);
		out.println(from_place);
		out.println(car_nm+"<br>");
		*/
		
		flag = cs_db.updateConsCostYn(off_id, cost_b_dt, car_comp_id, car_cd, from_place, car_nm, use_yn);
		
	}
		
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<script language='javascript'>
<!--
<%	if(!flag){%>
		alert("에러가 발생하였습니다.");		
<%	}else{//정상%>
		alert("정상처리 되었습니다.");		
		window.close();
<%	}%>

//-->
</script>
</BODY>
</HTML>