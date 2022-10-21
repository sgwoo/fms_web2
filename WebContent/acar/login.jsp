<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.database.*, acar.util.*, acar.beans.*, acar.ma.*"%>
<%
	String id = request.getParameter("id")==null?"":request.getParameter("id");
	String pw = request.getParameter("pw")==null?"":request.getParameter("pw");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	
	Login login = Login.getInstance();
	String result = "0";
	String user_id = "";
	int count = 0;
	
//	if(login.hasCookie(request, "acar_id")){//로그인 쿠키 확인
//		result = "9";
//	}else{
		//사용자 ID&PW 확인
		result = login.getLogin(id, pw, response);
		
		//login처리=로그파일,출근처리
		if(result.length() == 6){
			String login_time = Util.getLoginTime();//로그인시간
			String login_ip = request.getRemoteAddr();//로그인IP
			user_id = result;
			
			//사용자정보
			MaUserDatabase u_db = MaUserDatabase.getInstance();
			MaUsersBean ubean = u_db.getUserCase(user_id);
			
			//ip_log 등록
			count = login.insertLoginLog(login_ip, user_id, login_time);
			//출근관리
			count = login.insertAttend(login_ip, user_id, login_time);
			
			System.out.println("[로그인] DT:"+login_time+", ID:"+user_id+"("+ubean.getUser_nm()+")");
		}
//	}
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
<script language='javascript'>
<!--
<%	if(result.length() == 6){
		login.setDisplayCookie(s_width, s_height, response);//디스플레이 사이즈 쿠키설정%>
	var SUBWIN="menu/emp_frame.jsp";	
	var newwin=window.open("","newFMS","scrollbars=yes, status=yes, resizable=1, fullscreen=yes" );
	if (document.all){
		newwin.moveTo(0,0);
		newwin.resizeTo(screen.width,screen.height-50);
	}	
	newwin.location=SUBWIN;
<%	}else{%>
<%		if(result.equals("9")){%>
			alert('이미 로그인되어 있습니다.\n\n열려있는 FMS를 로그아웃 하십시오.');
<%		}else if(result.equals("2")){%>
			alert('데이터베이스 오류입니다.\n\n전산팀에 문의하십시오.');	
<%		}else{%>
			alert('ID와 PWD가 틀립니다.');
<%		}%>
<%	}%>
//-->
</script>
</HEAD>
<BODY>
</BODY>
</HTML>