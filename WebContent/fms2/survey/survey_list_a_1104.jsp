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
	

	String question_arr[] = request.getParameterValues("question"); 
//	String max_arr[] = request.getParameterValues("max"); 
	String q_value_arr[] = request.getParameterValues("q_value"); 
	
	String value[] = new String[2];
//	String answer_arr[] = "";
	for(int k=0; k<q_value_arr.length; k++){
	
		StringTokenizer st = new StringTokenizer( q_value_arr[k], "^" );
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		System.out.println("aaa="+ value[0]);		
		String answer_arr[] = request.getParameterValues("answerQ1");
		
//		String answer_arr[] = request.getParameterValues("answer" + value[0] +"");
		out.println( answer_arr[0] );
		
		//out.print(answer_arr.length);
		
	//	for(int kk=0; kk<answer_arr.length; kk++){
	//		out.println(answer_arr[kk]);
	//	
	//	}
	
	}
		
	
/* 	String answerQ1_arr[] = request.getParameterValues("answerQ"+max);
	
		
//	String answerQ2_arr[] = request.getParameterValues("answerQ2");	
//	String answerQ3_arr[] = request.getParameterValues("answerQ3");	
//	String answerQ4_arr[] = request.getParameterValues("answerQ4");	
//	String answerQ5_arr[] = request.getParameterValues("answerQ5");	
//	String answerQ6_arr[] = request.getParameterValues("answerQ6");	
//	String answerQ7_arr[] = request.getParameterValues("answerQ7");	
//	String answerQ8_arr[] = request.getParameterValues("answerQ8");	
//	String answerQ9_arr[] = request.getParameterValues("answerQ9");	
//	String answerQ10_arr[] = request.getParameterValues("answerQ10");	
	
	String answerremQ1_arr[] = request.getParameterValues("answerremQ1");
//	String answerremQ2_arr[] = request.getParameterValues("answerremQ2");	
//String answerremQ3_arr[] = request.getParameterValues("answerremQ3");	
//	String answerremQ4_arr[] = request.getParameterValues("answerremQ4");	
//	String answerremQ5_arr[] = request.getParameterValues("answerremQ5");	
//	String answerremQ6_arr[] = request.getParameterValues("answerremQ6");	
//	String answerremQ7_arr[] = request.getParameterValues("answerremQ7");	
//	String answerremQ8_arr[] = request.getParameterValues("answerremQ8");	
//	String answerremQ9_arr[] = request.getParameterValues("answerremQ9");	
//	String answerremQ10_arr[] = request.getParameterValues("answerremQ10");

	LivePollBean poll = new LivePollBean();
	
	
	String poll_st = request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_type = request.getParameter("poll_type")==null?"":request.getParameter("poll_type");
	
	if(poll_type.equals("1")){
		if(poll_st.equals("선택")){
			poll_st = "0";
		}else if(poll_st.equals("신규"))	{
			poll_st = "1";
		}else if(poll_st.equals("대차"))	{
			poll_st = "3";
		}else if(poll_st.equals("증차"))	{
			poll_st = "4";
		}else if(poll_st.equals("연장"))	{
			poll_st = "5";
		}else if(poll_st.equals("재리스(신규)"))	{
			poll_st = "6";
		}else if(poll_st.equals("재리스(기존)"))	{
			poll_st = "8";
		}else if(poll_st.equals("월렌트(신규)"))	{
			poll_st = "9";
		}else if(poll_st.equals("월렌트(기존)"))	{
			poll_st = "10";
		}
	}else if(poll_type.equals("2")){
		if(poll_st.equals("선택"))	{
			poll_st = "0";
		}else if(poll_st.equals("순회정비"))	{
			poll_st = "2";
		}
	}else if(poll_type.equals("3")){
		if(poll_st.equals("선택"))	{
			poll_st = "0";
		}else if(poll_st.equals("사고처리"))	{
			poll_st = "7";
		}
	}

	
	poll.setPoll_st			(poll_st);
	poll.setPoll_seq		(request.getParameter("poll_seq")==null?1:Integer.parseInt(request.getParameter("poll_seq")));
	poll.setPoll_type		(poll_type);
	poll.setUse_yn			(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
	poll.setPoll_title		(request.getParameter("poll_title")==null?"":request.getParameter("poll_title"));
	poll.setStart_dt		(request.getParameter("start_dt")==null?"0":request.getParameter("start_dt"));
	poll.setEnd_dt			(request.getParameter("end_dt")==null?"99991231":request.getParameter("end_dt"));
	
	for(int i=0; i<question_arr.length; i++){
		System.out.println(question_arr[i]);
	
	
	poll.setQuestion	(question_arr[i]);
	
	for(int j=0; j<answerQ1_arr.length; j++){
		System.out.println(answerQ1_arr[j]);
	if(j== 0)	poll.setAnswer1		(answerQ1_arr[0]); 
	if(j== 1)	poll.setAnswer2		(answerQ1_arr[1]); 
	if(j== 2)	poll.setAnswer3		(answerQ1_arr[2]); 
	if(j== 3)	poll.setAnswer4		(answerQ1_arr[3]); 
	if(j== 4)	poll.setAnswer5		(answerQ1_arr[4]); 
	if(j== 5)	poll.setAnswer6		(answerQ1_arr[5]); 
	if(j== 6)	poll.setAnswer7		(answerQ1_arr[6]); 
	if(j== 7)	poll.setAnswer8		(answerQ1_arr[7]); 
	if(j== 8)	poll.setAnswer9		(answerQ1_arr[8]); 
	if(j== 9)	poll.setAnswer10	(answerQ1_arr[9]); 
	}
	
	for(int k=0; k<answerremQ1_arr.length; k++){
		System.out.println(answerremQ1_arr[k]);

	if(k== 0) poll.setAnswer1_rem		(answerremQ1_arr[0]);
	if(k== 1) poll.setAnswer2_rem		(answerremQ1_arr[1]);
	if(k== 2) poll.setAnswer3_rem		(answerremQ1_arr[2]);
	if(k== 3) poll.setAnswer4_rem		(answerremQ1_arr[3]);
	if(k== 4) poll.setAnswer5_rem		(answerremQ1_arr[4]);
	if(k== 5) poll.setAnswer6_rem		(answerremQ1_arr[5]);
	if(k== 6) poll.setAnswer7_rem		(answerremQ1_arr[6]);
	if(k== 7) poll.setAnswer8_rem		(answerremQ1_arr[7]);
	if(k== 8) poll.setAnswer9_rem		(answerremQ1_arr[8]);
	if(k== 9) poll.setAnswer10_rem		(answerremQ1_arr[9]);
	
	
	}
	System.out.println("**********************");
	poll = poll_db.insertLivePoll(poll);
	}
	
*/
	
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
</form>  
<script language='javascript'>
var fm = document.form1;
<%//		if(poll != null){%>
			alert('등록되었습니다');
	//		fm.action="survey_list_frame.jsp";
	//		top.window.close();
	//		fm.submit();
			//parent.location='survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
<%//		}else{%>
			alert('등록되지 않았습니다');
<%//	}%>				
</script>
</body>
</html>
