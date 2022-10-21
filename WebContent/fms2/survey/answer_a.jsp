<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.call.*, acar.util.*"%>
<jsp:useBean id="poll_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 		= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	SurveyPollBean poll = new SurveyPollBean();
	
	String poll_st = request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_type = request.getParameter("poll_type")==null?"":request.getParameter("poll_type");
	String poll_id = request.getParameter("poll_id")==null?"0":request.getParameter("poll_id");
	String poll_seq = request.getParameter("poll_seq")==null?"":request.getParameter("poll_seq");
	String poll_su = request.getParameter("poll_su")==null?"":request.getParameter("poll_su");
	
	String poll_title = request.getParameter("poll_title")==null?"":request.getParameter("poll_title");
	
	if(poll_title.equals("한글128자/ 영문+숫자 256 글자까지 입력할 수 있습니다.")){
		poll_title = "";
	}
	
	
	boolean flag = true;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;

	
	
	String answer_arr[] = request.getParameterValues("answer"); 
	String answer_rem_value_arr[] = request.getParameterValues("answer_rem_value"); 
	
	int answer_size = 0;
	int answer_rem_size = 0;
	
	if (request.getParameterValues("answer_rem_value") != null ||  request.getParameterValues("answer") != null){
		answer_size = answer_arr.length;
		answer_rem_size = answer_rem_value_arr.length;
	}	
//out.println("poll_su:"+poll_su);	

	String pollsu = poll_db.getPollSearchSu(poll_type, poll_st);

//	out.println("poll_su:"+poll_su);	
//	out.println("pollsu:"+pollsu);	
	
	if(cmd.equals("n_save")){

	if(pollsu.equals(poll_su)){
		pollsu = "true";
	}else{
	
		poll.setPoll_id			(AddUtil.parseInt(poll_id));
		poll.setUse_yn			(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
		poll.setPoll_st			(poll_st);
		poll.setPoll_type		(poll_type);
		poll.setPoll_title		(poll_title);
		poll.setStart_dt		(request.getParameter("start_dt")==null?"0":request.getParameter("start_dt"));
		poll.setEnd_dt			(request.getParameter("end_dt")==null?"99991231":request.getParameter("end_dt"));
		poll.setReg_id			(user_id);
		poll.setPoll_su			(AddUtil.parseInt(poll_su));
		
		poll = poll_db.insertSurvey(poll);  
		
		poll_seq = poll_db.getPollNextSeq(AddUtil.parseInt(poll_id));
		
		
		
		poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
		poll.setContent			(request.getParameter("question")==null?"":request.getParameter("question"));
		poll.setA_seq			(0);
		
		flag = poll_db.insertSurvey_poll(poll);

		for(int i=0; i<answer_size; i++){
			
			poll.setPoll_id			(AddUtil.parseInt(poll_id));
			poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
			poll.setContent			(answer_arr[i]);
			poll.setA_seq			(i+1);
			poll.setChk				(answer_rem_value_arr[i]);
			
			flag = poll_db.insertSurvey_poll(poll);
			
		}
	}
	}else if(cmd.equals("p_save")){	
		poll_seq = poll_db.getPollNextSeq(AddUtil.parseInt(poll_id));
		poll.setPoll_id			(AddUtil.parseInt(poll_id));
		poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
		poll.setContent			(request.getParameter("question")==null?"":request.getParameter("question"));
		poll.setA_seq			(0);
		
		flag = poll_db.insertSurvey_poll(poll);

		for(int i=0; i<answer_size; i++){
			
			poll.setPoll_id			(AddUtil.parseInt(poll_id));
			poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
			poll.setContent			(answer_arr[i]);
			poll.setA_seq			(i+1);
			poll.setChk				(answer_rem_value_arr[i]);
			
			flag = poll_db.insertSurvey_poll(poll);
			
		}
	}else if(cmd.equals("modify")){
		
		poll.setPoll_id			(AddUtil.parseInt(poll_id));
		poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
		poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
		poll.setContent			(request.getParameter("question")==null?"":request.getParameter("question"));
		poll.setA_seq			(0);
		
		flag1 = poll_db.updateSurvey_poll(poll);
		
		for(int i=0; i<answer_size; i++){
			
			poll.setPoll_id			(AddUtil.parseInt(poll_id));
			poll.setPoll_seq		(AddUtil.parseInt(poll_seq));
			poll.setContent			(answer_arr[i]);
			poll.setA_seq			(i+1);
			poll.setChk				(answer_rem_value_arr[i]);
			
			flag2 = poll_db.updateSurvey_poll(poll);
			
		}
		
	}else if(cmd.equals("a_del")){

		poll.setPoll_id			(AddUtil.parseInt(poll_id));
		
		flag2 = poll_db.deleteSurvey_poll_all(poll);
	}else if(cmd.equals("o_del")){

		poll.setPoll_id			(AddUtil.parseInt(poll_id));
		poll.setPoll_seq			(AddUtil.parseInt(poll_seq));
		
		flag2 = poll_db.deleteSurvey_poll_one(poll);	
		
	}else if(cmd.equals("yn_ch")){
	
		poll.setUse_yn			(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
		poll.setPoll_su			(AddUtil.parseInt(poll_su));
		poll.setPoll_title		(request.getParameter("poll_title")==null?"":request.getParameter("poll_title"));
		poll.setStart_dt		(request.getParameter("start_dt")==null?"0":request.getParameter("start_dt"));
		poll.setEnd_dt			(request.getParameter("end_dt")==null?"99991231":request.getParameter("end_dt"));
		poll.setPoll_id			(AddUtil.parseInt(poll_id));

/*
out.println("poll.getUse_yn:"+poll.getUse_yn());
out.println("poll.getPoll_su:"+poll.getPoll_su());
out.println("poll.getPoll_title:"+poll.getPoll_title());
out.println("poll.getStart_dt:"+poll.getStart_dt());
out.println("poll.getEnd_dt:"+poll.getEnd_dt());
out.println("poll.getPoll_id:"+poll.getPoll_id());
		*/
		flag3 = poll_db.updateSurvey_basic(poll);
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>

<body leftmargin="15">

<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='poll_seq' 	value='<%=poll_seq%>'>
  <input type='hidden' name='poll_id' 	value='<%=poll_id%>'>
  
</form>  
<script language='javascript'>
var fm = document.form1;
<%if(cmd.equals("n_save")||cmd.equals("p_save")){%>
	<%if(pollsu.equals("true")){%>
		alert('회차가 중복되었습니다. 다른회차를 입력해주세요.!!!!');
		parent.close();	
	<%}else{%>
		<%if(poll != null && flag==true){%>
			alert('등록되었습니다');
			parent.close();	
			parent.opener.location='survey_list_u.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&poll_id=<%=poll_id%>&poll_seq=<%=poll_seq%>';
		<%}else{%>
			alert('등록되지 않았습니다');
		<%}%>							
	<%}%>
<%}else if(cmd.equals("modify")){%>

	<%if(flag1==true){%>			
		alert('수정 하였습니다');
		parent.close();	
		parent.opener.location='survey_list_u.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&poll_id=<%=poll_id%>&poll_seq=<%=poll_seq%>';
	<%}else{%>	
		alert('수정되지 않았습니다');
	<%}%>

<%}else if(cmd.equals("yn_ch")){%>

	<%if(flag3==true){%>			
		alert('기본정보를 수정 하였습니다');
		parent.opener.location='survey_list_u.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&poll_id=<%=poll_id%>&poll_seq=<%=poll_seq%>';
	<%}else{%>	
		alert('수정되지 않았습니다');
	<%}%>
	
<%}else if(cmd.equals("o_del")){%>

	<%if(flag2==true){%>			
		alert('삭제되었습니다');
		parent.opener.location='survey_list_u.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&poll_id=<%=poll_id%>&poll_seq=<%=poll_seq%>';
	<%}else{%>	
		alert('삭제되지 않았습니다');
	<%}%>
<%}else if(cmd.equals("a_del")){%>

	<%if(flag2==true){%>			
		alert('삭제되었습니다');
	//	parent.close();	
		//parent.opener.location='survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
		fm.action='./survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
		fm.target='d_content';
		fm.submit();		
	<%}else{%>	
		alert('삭제되지 않았습니다');
	<%}%>	
<%}%>
</script>
</body>
</html>

