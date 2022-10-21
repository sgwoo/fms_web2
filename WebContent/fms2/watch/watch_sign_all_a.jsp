<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<%@ page import="acar.watch.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	WatchDatabase wc_db = WatchDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cm 			= request.getParameter("cm")==null?"":request.getParameter("cm");
	
	String s_day[]		= request.getParameterValues("s_day");
	
	int count = 0;
	int tot_cnt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	

	String target_id = "";
	String watch_type = "";
	
	if(cm.equals("s")){		
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "1";
	}
	if(cm.equals("x")){
		target_id = "000219";
		/* if(sender_bean.getDept_id().equals("0007")||sender_bean.getDept_id().equals("0011")){
			watch_type = "3";	
		}else {
			watch_type = "4";
		} */
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
		target_id = "000219"; 
		watch_type = "3";
	}else if(cm.equals("g")){			
		target_id = "000054"; //윤영탁대리
		watch_type = "7";
	}else if(cm.equals("i1")){			
		target_id = nm_db.getWorkAuthUser("본사관리팀장"); //관리팀장
		watch_type = "8";
	}
	
	if(cmd.equals("gj")){
		if(s_day.length >0){
			for(int i=0;i<s_day.length;i++){
				
				WatchScheBean wc_bean = new WatchScheBean();
				wc_bean.setStart_year(start_year);
				wc_bean.setStart_mon(start_month);
				wc_bean.setStart_day(s_day[i]);
				count = wc_db.updateSign(wc_bean, watch_type);
				if(count==1) tot_cnt++;
			}
		}	
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
  	<input type='hidden' name='start_year' 	value='<%=start_year%>'>
  	<input type='hidden' name='start_month' value='<%=start_month%>'>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%if(cmd.equals("gj")){
	if(tot_cnt==s_day.length){%>
		alert("결재되었습니다!!!");
	//parent.window.location.reload();
<%	}else{%>
		alert("일괄결제 중 오류발생!");
<%	}%>
	parent.opener.location.reload();
	parent.window.close();
<%}%>
//-->
</script>

</body>
</html>
