<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<%@ page import="acar.watch.*, acar.car_sche.*" %>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	WatchDatabase wc_db = WatchDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cm 			= request.getParameter("cm")==null?"":request.getParameter("cm");
	
	String watch_time_st 	= request.getParameter("watch_time_st")==null?"":request.getParameter("watch_time_st");
		
	String watch_ot 	= request.getParameter("watch_ot")==null?"":request.getParameter("watch_ot");
	String watch_gtext 	= request.getParameter("watch_gtext")==null?"":request.getParameter("watch_gtext");
	String watch_ch_nm 	= request.getParameter("watch_ch_nm")==null?"":request.getParameter("watch_ch_nm");
	int watch_amt = 0;
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String watch_type = request.getParameter("watch_type")==null?"":request.getParameter("watch_type");
	
	int count = 0;
	
	boolean flag6 = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();


	
	String target_id = "";
	
	if(cm.equals("x")){
		target_id = "000219"; //광주지점장
		watch_type = "3";
	}else if(cm.equals("s")){		
		target_id = "000026"; //관리팀장
		watch_type = "1";
	}else if(cm.equals("b")){		
		target_id = "000053"; //000053(제인학)
		watch_type = "3";
	}else if(cm.equals("d")){			
		target_id = "000052"; //000052(박영규)
		watch_type = "4";
	}else if(cm.equals("j")){			
		target_id = "000052"; //박영규
		watch_type = "6";
	}else if(cm.equals("g")){			
		target_id = "000054"; //윤영탁
		watch_type = "7";
	}else if(cm.equals("s2")){			
		target_id = "000026"; //관리팀장
		watch_type = "5";
	}	
	

	if(cmd.equals("i")){	
		wc_bean.setWatch_gtext(watch_gtext);
		wc_bean.setStart_year(start_year);
		wc_bean.setStart_mon(start_month);
		wc_bean.setStart_day(start_day);

		count = wc_db.updateWatchReg(wc_bean, watch_type);
		
	}

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>

<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>

<input type='hidden' name='watch_ot' 		value='<%=watch_ot%>'>
<input type='hidden' name='watch_gtext' 	value='<%=watch_gtext%>'>
  <input type='hidden' name='start_year' 	value='<%=start_year%>'>
  <input type='hidden' name='start_month' 	value='<%=start_month%>'>
  <input type='hidden' name='start_day' 	value='<%=start_day%>'>
  
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<% 
if(cmd.equals("s")){
	if(count==1){
	%>
	alert("근무시작!!!!.");
	parent.window.location.reload();
	fm.submit();					
<%	}

}else if(cmd.equals("e")){
	if(count==1){
	%>
	alert("수고하셨습니다!!!");
	parent.window.location.reload();
	fm.submit();					
<%	}
}else if(cmd.equals("i")){
	if(count==1){
	%>
	alert("등록되었습니다!!!");
	parent.window.location.reload();
	fm.submit();					
<%	}
}else if(cmd.equals("gj")){
	if(count==1){
	%>
	alert("결재되었습니다!!!");
	parent.window.location.reload();
	fm.submit();					
<%	}
}
%>
//-->
</script>

</body>
</html>
