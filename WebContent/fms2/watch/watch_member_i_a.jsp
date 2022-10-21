<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.watch.*" %>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String member_st 	= request.getParameter("member_st")==null?"":request.getParameter("member_st");
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String watch_type = request.getParameter("watch_type")==null?"":request.getParameter("watch_type");	
	String week = request.getParameter("week")==null?"":request.getParameter("week");
	String is_registered_watch = request.getParameter("is_registered_watch") == null ? "" : request.getParameter("is_registered_watch");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	int watch_amt = request.getParameter("watch_amt")==null?0:Util.parseInt(request.getParameter("watch_amt"));
	String time_st 		= request.getParameter("time_st")==null?"":request.getParameter("time_st");
	int count = 0;
	int count2 = 0;
	
	// 2017. 10. 24 추가 start
	// 부산,대구와 대전, 광주 통합 건으로 인한 코드 추가
	if(watch_type.equals("34")){
		watch_type = "3";
	}
	// end
	
	if(cmd.equals("S")){// 담당자 일괄등록
	
	String[] ch_mb = request.getParameterValues("ch_mb");

	int mb_size = ch_mb.length;
	String value[] = new String[4];
	
	for(int i=0; i < mb_size; i++){
	
		StringTokenizer st = new StringTokenizer(ch_mb[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;

		}

		start_year		= value[0];
		start_month		= value[1];
		start_day		= value[2];
		member_id		= value[3];

		wc_bean.setStart_year(start_year);
		wc_bean.setStart_mon(start_month);
		wc_bean.setStart_day(start_day);
		wc_bean.setMember_id(member_id);
		wc_bean.setMember_id2(member_id);
		
			if(cmd.equals("S")){
				watch_type  = "1";
			}else if(cmd.equals("B")){
				watch_type  = "3";
			}else if(cmd.equals("D")){
				watch_type  = "4";
			}		
//System.out.println("member_id"+i+": "+member_id);			
		count2 = wc_db.updateWatchScheMB(wc_bean, watch_type);
	
	}
	}else{// 담당자 개별 등록 부분
			wc_bean.setStart_year(start_year);
			wc_bean.setStart_mon(start_month);
			wc_bean.setStart_day(start_day);
			wc_bean.setMember_id(member_id);
		if(Boolean.valueOf(is_registered_watch)){ // 해당 일자에 당직 근무 레코드 자체가 등록되어 있지 않을 경우 야간당직자 등록 시 INSERT
			String regday = start_year+""+start_month+""+start_day;
			int h_cnt =  aa_db.getHolidayCnt(regday);
			
			if(week.equals("1") || week.equals("7") ){
				if(cmd.equals("B") || cmd.equals("D")) watch_amt = 30000;
			    else watch_amt = 50000;
			}else{		
				if (h_cnt > 0 ) {
					if(cmd.equals("B") || cmd.equals("D")) watch_amt = 30000;
				    else  watch_amt = 50000;
				} else {
				    if(cmd.equals("B") || cmd.equals("D")) watch_amt = 15000;
				    else watch_amt = 20000;					
				}		
			}
			wc_bean.setWatch_amt(watch_amt);
			count = wc_db.insertWatchMember(wc_bean, watch_type);
		} else{
			count = wc_db.updateWatchSche(wc_bean, watch_type);
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
	<%if(count2==1){%>
		alert("정상적으로 등록되었습니다.");
		parent.location.reload();
	<%}else if(count==1){%>
		parent.opener.location.reload();
		parent.window.close();
	<%}else{%>
		alert("Error !!!!!!!!!!!!!!!!!!!!");	
	<%}%>
	


//-->
</script>
</body>
</html>