<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.call.*, acar.util.*"%>
<jsp:useBean id="poll_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 		= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	LivePollBean poll = new LivePollBean();
	
	
	poll.setQuestion		(request.getParameter("question")==null?"":request.getParameter("question"));
	poll.setAnswer1			(request.getParameter("answer1")==null?"":request.getParameter("answer1"));
	poll.setAnswer2			(request.getParameter("answer2")==null?"":request.getParameter("answer2"));
	poll.setAnswer3			(request.getParameter("answer3")==null?"":request.getParameter("answer3"));
	poll.setAnswer4			(request.getParameter("answer4")==null?"":request.getParameter("answer4"));
	poll.setAnswer5			(request.getParameter("answer5")==null?"":request.getParameter("answer5"));
	poll.setAnswer6			(request.getParameter("answer6")==null?"":request.getParameter("answer6"));
	poll.setAnswer7			(request.getParameter("answer7")==null?"":request.getParameter("answer7"));
	poll.setAnswer8			(request.getParameter("answer8")==null?"":request.getParameter("answer8"));
	poll.setUse_yn			(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
	poll.setAnswer1_rem			(request.getParameter("answer1_rem")==null?"0":"1");
	poll.setAnswer2_rem			(request.getParameter("answer2_rem")==null?"0":"1");
	poll.setAnswer3_rem			(request.getParameter("answer3_rem")==null?"0":"1");
	poll.setAnswer4_rem			(request.getParameter("answer4_rem")==null?"0":"1");
	poll.setAnswer5_rem			(request.getParameter("answer5_rem")==null?"0":"1");
	poll.setAnswer6_rem			(request.getParameter("answer6_rem")==null?"0":"1");
	poll.setAnswer7_rem			(request.getParameter("answer7_rem")==null?"0":"1");
	poll.setAnswer8_rem			(request.getParameter("answer8_rem")==null?"0":"1");
	poll.setPoll_st				(request.getParameter("poll_st")==null?"":request.getParameter("poll_st"));
	poll.setPoll_seq		(request.getParameter("poll_seq")==null?1:Integer.parseInt(request.getParameter("poll_seq")));
	poll.setPoll_type				(request.getParameter("poll_type")==null?"":request.getParameter("poll_type"));
	poll.setAnswer9(request.getParameter("answer9")==null?"":request.getParameter("answer9"));
	poll.setAnswer9_rem(request.getParameter("answer9_rem")==null?"0":"1");
	poll.setAnswer10(request.getParameter("answer10")==null?"":request.getParameter("answer10"));
	poll.setAnswer10_rem(request.getParameter("answer10_rem")==null?"0":"1");
	poll = poll_db.insertLivePoll(poll);
	
%>
<script language='javascript'>
<%		if(poll != null){%>
			alert('등록되었습니다');
			parent.location='/acar/call/poll_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
<%		}else{%>
			alert('등록되지 않았습니다');
<%	}%>				
</script>
</body>
</html>
