<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.call.*"%>
<jsp:useBean id="poll_db" class="acar.call.PollDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int chk = 0;
	
	String poll_id = request.getParameter("poll_id")==null?"0":request.getParameter("poll_id");
		
	boolean flag = true;
	
	LivePollBean bean = new LivePollBean();
		
	
	if( cmd.equals("u")){
		bean.setPoll_id(Integer.parseInt(poll_id));
		bean.setQuestion(request.getParameter("question")==null?"":request.getParameter("question"));
		bean.setAnswer1(request.getParameter("answer1")==null?"":request.getParameter("answer1"));
		bean.setAnswer2(request.getParameter("answer2")==null?"":request.getParameter("answer2"));
		bean.setAnswer3(request.getParameter("answer3")==null?"":request.getParameter("answer3"));
		bean.setAnswer4(request.getParameter("answer4")==null?"":request.getParameter("answer4"));
		bean.setAnswer5(request.getParameter("answer5")==null?"":request.getParameter("answer5"));
		bean.setAnswer6(request.getParameter("answer6")==null?"":request.getParameter("answer6"));
		bean.setAnswer7(request.getParameter("answer7")==null?"":request.getParameter("answer7"));
		bean.setAnswer8(request.getParameter("answer8")==null?"":request.getParameter("answer8"));
		bean.setUse_yn(request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn"));
		bean.setAnswer1_rem(request.getParameter("answer1_rem")==null?"0":"1");
		bean.setAnswer2_rem(request.getParameter("answer2_rem")==null?"0":"1");
		bean.setAnswer3_rem(request.getParameter("answer3_rem")==null?"0":"1");
		bean.setAnswer4_rem(request.getParameter("answer4_rem")==null?"0":"1");
		bean.setAnswer5_rem(request.getParameter("answer5_rem")==null?"0":"1");
		bean.setAnswer6_rem(request.getParameter("answer6_rem")==null?"0":"1");
		bean.setAnswer7_rem(request.getParameter("answer7_rem")==null?"0":"1");
		bean.setAnswer8_rem(request.getParameter("answer8_rem")==null?"0":"1");
		bean.setPoll_st(request.getParameter("poll_st")==null?"1":request.getParameter("poll_st"));
		bean.setPoll_seq(request.getParameter("poll_seq")==null?1:Integer.parseInt(request.getParameter("poll_seq")));
		bean.setAnswer9(request.getParameter("answer9")==null?"":request.getParameter("answer9"));
		bean.setAnswer9_rem(request.getParameter("answer9_rem")==null?"0":"1");
		bean.setAnswer10(request.getParameter("answer10")==null?"":request.getParameter("answer10"));
		bean.setAnswer10_rem(request.getParameter("answer10_rem")==null?"0":"1");
			
		flag = poll_db.updatePoll(bean);
			
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="bad_cust_frame.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">

</form>
<script>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.location='/acar/call/poll_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
		
<%		}else{%>
			alert("에러발생!");
<%		}%>
</script>
</body>
</html>