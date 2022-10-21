<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.coolmsg.*"%>
<%@ page import="acar.watch.*, acar.car_sche.*" %>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
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
	
	int count = 0;
	
	boolean flag6 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

//sender
	UsersBean sender_bean 	= umd.getUsersBean(member_id);
	
	
	
	String target_id = "";
	String watch_type = "";
	
	if(cm.equals("s")){		
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "1";
	}
	if(cm.equals("x")){

		target_id = "000219"; //광주지점
		if(sender_bean.getDept_id().equals("0007")||sender_bean.getDept_id().equals("0011")){
			watch_type = "3";	
		}else {
			watch_type = "4";
		}
	}else if(cm.equals("b")){		
		target_id = "000053"; //000053(제인학)
		watch_type = "3";
	}else if(cm.equals("d")){			
		target_id = "000052"; //000052(박영규)
		watch_type = "4";
	}else if(cm.equals("s2")){			
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "5";
	}else if(cm.equals("j")){			
		target_id = "000219"; //광주지점
		watch_type = "3";
	}else if(cm.equals("g")){			
		target_id = "000054"; //윤영탁대리
		watch_type = "7";
	}else if(cm.equals("i1")){			
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "8";
	}

	if(cmd.equals("i")){
				
		wc_bean.setWatch_ot(watch_ot);
		wc_bean.setWatch_gtext(watch_gtext);
		wc_bean.setWatch_ch_nm(user_nm);
	
		wc_bean.setStart_year(start_year);
		wc_bean.setStart_mon(start_month);
		wc_bean.setStart_day(start_day);		
		
		count = wc_db.updateWatchReg(wc_bean, watch_type);
		
		count = wc_db.updateInet(wc_bean, watch_type);
		// 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
		String sub 		= "당직일지 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님의 당직일지가 등록 되었습니다. 확인바랍니다.";
		String url 		= "";
		String m_url = "/fms2/watch/watch_frame.jsp";
		if(cm.equals("b")){	
			 url 		= "/fms2/watch/watch_bs.jsp";
		}else if(cm.equals("d")){	
			 url 		= "/fms2/watch/watch_dj.jsp";
		}else if(cm.equals("s2")){	
			 url 		= "/fms2/watch/watch_s2.jsp";
		}else if(cm.equals("j")){	
			 url 		= "/fms2/watch/watch_jj.jsp";
		}else if(cm.equals("g")){	
			 url 		= "/fms2/watch/watch_g.jsp";			 
		}else if(cm.equals("i1")){	
			 url 		= "/fms2/watch/watch_i1.jsp";			 
		} else {
			 url 		= "/fms2/watch/watch_s.jsp";
		}	 
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	
	
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		
		//보낸사람
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		
		  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
	
	
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
	
		flag6 = cm_db.insertCoolMsg(msg);
		
		System.out.println("(당직일지 결재 의뢰)----------------------- "+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + ":" + start_year + start_month + start_day);	
	
	}else if(cmd.equals("s")){				//당직시작 시간등록
							//평일인 경우에 한해서		
			int t_st = Util.parseInt(watch_time_st.substring(11,13)+watch_time_st.substring(14,16));
			
			int day_of_week = 0;
			int nyear = 0;
			int nmonth = 0;
			int nday = 0;
			int h_cnt = 0;
					
			nyear = Integer.parseInt(start_year);
			nmonth = Integer.parseInt(start_month);
			nday = Integer.parseInt(start_day);
										
			day_of_week = calendar.getDayOfWeek(nyear, nmonth, nday);
				
			h_cnt = aa_db.getHolidayCnt(start_year+start_month+start_day);		
				
			if(day_of_week == 1 || day_of_week == 7 ){
				watch_amt=30000;
			}else{
				if (h_cnt > 0 ) {
					watch_amt=30000;
				} else {
				    //부산은 10000 , 대전도 (20110829부터) - 무조건
					if(cmd.equals("B")||cmd.equals("D")||cmd.equals("S2")||cmd.equals("J")||cmd.equals("G")){	
						watch_amt = 10000;
					} else {
						watch_amt = 10000;					
					}	
				}	
			} 
	
			wc_bean.setStart_year(start_year);
			wc_bean.setStart_mon(start_month);
			wc_bean.setStart_day(start_day);
			wc_bean.setWatch_amt(watch_amt);
					
			count = wc_db.updateInst(wc_bean, watch_type);		
			
	/*
	}else if(cmd.equals("e")){			//당직종료 시간등록
				
			wc_bean.setStart_year(start_year);
			wc_bean.setStart_mon(start_month);
			wc_bean.setStart_day(start_day);		
		
			count = wc_db.updateInet(wc_bean, watch_type);
	*/
	}else if(cmd.equals("gj")){
		
			wc_bean.setStart_year(start_year);
			wc_bean.setStart_mon(start_month);
			wc_bean.setStart_day(start_day);		
			
			count = wc_db.updateSign(wc_bean, watch_type);
			
	}

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
