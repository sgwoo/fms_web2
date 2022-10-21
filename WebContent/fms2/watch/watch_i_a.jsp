<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.watch.*, acar.car_sche.*, acar.user_mng.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	WatchDatabase wc_db = WatchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	
	String ch_cd[]		= request.getParameterValues("ch_cd");
	
	String start_day	= "";
	int vid_size 		= ch_cd.length;
			
	int count = 0;
	String today = AddUtil.getDate(4);
	String regday = "";
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	int watch_amt = request.getParameter("watch_amt")==null?0:Util.parseInt(request.getParameter("watch_amt"));
	
	String watch_type = "";

	int s_year =0;
	int s_month = 0;
	int s_day =0;
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;

	for(int i=0;i < vid_size;i++){
		start_day = ch_cd[i];
		
	
		if(start_year.equals(""))
		{
			nyear = calendar.getThisYear();
			nmonth = calendar.getThisMonth();
			nday = calendar.getThisDay();
		}else{
			nyear = Integer.parseInt(start_year);
			nmonth = Integer.parseInt(start_month);
			nday = Integer.parseInt(start_day);
		}
		
		String thisyear = Integer.toString(nyear);
		String thismonth = Integer.toString(nmonth);
		String thisday = Integer.toString(nday);
	
		if(thismonth.length() == 1)
			thismonth = "0"+thismonth;
	
		int day_of_week = 0;
	
		// 해당월의 마지막 날짜 가져오기....
		int last_day = calendar.getMonthLastDay(nyear,nmonth); 
						
		day_of_week = calendar.getDayOfWeek(nyear, nmonth, nday);
		
		regday = start_year+""+start_month+""+start_day;
		
		int h_cnt =  aa_db.getHolidayCnt(regday);
		
		if(day_of_week == 1 || day_of_week == 7 ){
				
				if(cmd.equals("B")||cmd.equals("D")){	
			    	watch_amt = 30000; // 2017. 10. 27 | 기존 20,000원에서 30,000원으로 변경
			    } else {
					watch_amt=50000;
				}	
				
				
		}else{		
			if (h_cnt > 0 ) {
				if(cmd.equals("B")||cmd.equals("D")){	
			    	watch_amt = 30000; // 2017. 10. 27 | 기존 20,000원에서 3,0000원으로 변경
			    } else {
					watch_amt=50000;
				}	
			} else {
			    //부산은 10000 - 무조건
			    if(cmd.equals("B")||cmd.equals("D")){	
			    	watch_amt = 15000; // 2017. 10. 27 | 기존 10,000원에서 15,000원으로 변경
			    } else {
					watch_amt = 20000;					
				}	
			}		
		} 
			
		//날짜점검
		if(AddUtil.parseInt(today) < AddUtil.parseInt(regday)||nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
	
			if(cmd.equals("S")){
				watch_type  = "1";
			}else if(cmd.equals("B")){
				watch_type  = "3";
			}else if(cmd.equals("D")){
				watch_type  = "4";
			}else if(cmd.equals("J")){
				watch_type  = "6";
			}else if(cmd.equals("G")){
				watch_type  = "7";
			}else if(cmd.equals("s2")){
				watch_type  = "5";
			}else if(cmd.equals("i1")){
				watch_type  = "8";
			}	
								
			wc_bean.setStart_year	(start_year);
			wc_bean.setStart_mon	(start_month);
			wc_bean.setStart_day	(start_day);
			wc_bean.setWatch_amt	(watch_amt);
			
			if(cmd.equals("B")){ // 2017.10.27 | 부산, 대구, 대전, 광주 지점 통합관리로 인한 일괄 등록 실시
				count = wc_db.insertWatchSche(wc_bean, "3");
				count += wc_db.insertWatchSche(wc_bean, "4");
			}else {
				count = wc_db.insertWatchSche(wc_bean, watch_type);	
			}
	
		}else{
			count = 1;
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<script language="JavaScript">
<!--
	<%if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	<%}else{%>
	alert("Error !!!!!!!!!!!!!!!!!!!!");	
	<%}%>
	parent.location.reload();

//-->
</script>
</body>
</html>