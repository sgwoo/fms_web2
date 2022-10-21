<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dept_id 	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String sch_chk 	= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String sch_st 	= "";
	
	if(dept_id.equals("0001")) 		sch_st="B";
	else if(dept_id.equals("0002")) sch_st="M";
	else if(dept_id.equals("0003")) sch_st="G";
	int count = 0;
	
	int use_days = 0;
	use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));
	String dt = "";
	
	for(int i=0; i<use_days; i++){
	
		dt = rs_db.addDay(st_dt, i);
		
		String c_sysdate = "";
		c_sysdate = af_db.checkSunday(dt);
		if(!c_sysdate.equals(dt))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			continue;
		
		c_sysdate = af_db.checkHday(dt);
		if(!c_sysdate.equals(dt))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
			continue;
		
		ScheduleDatabase csd = ScheduleDatabase.getInstance();
		
		cs_bean.setStart_year	(dt.substring(0,4));
		cs_bean.setStart_mon	(dt.substring(4,6));
		cs_bean.setStart_day	(dt.substring(6,8));
		cs_bean.setUser_id		(user_id);
		cs_bean.setSeq			(0);
		cs_bean.setTitle		(title);
		cs_bean.setContent		(content);
		cs_bean.setSch_kd		("2");
		cs_bean.setSch_st		(sch_st);
		cs_bean.setSch_chk		(sch_chk);
		cs_bean.setWork_id		(work_id);
		
		count = csd.insertCarSche(cs_bean);
	}
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%if(count==1){%>
	alert("정상적으로 등록되었습니다.");
//	parent.LoadSche();
<%}else{%>
	alert("입력 오류!!");
<%}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>