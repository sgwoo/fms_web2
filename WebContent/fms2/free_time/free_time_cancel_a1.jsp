<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.free_time.*,  acar.car_sche.*, acar.doc_settle.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //의뢰자
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String doc_no 			= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String cancel_tit 	= request.getParameter("cancel_tit")==null?"":request.getParameter("cancel_tit");
	String cancel_cmt 	= request.getParameter("cancel_cmt")==null?"":request.getParameter("cancel_cmt");
	String cancel_dt 	= request.getParameter("cancel_dt")==null?"":request.getParameter("cancel_dt");
			
	
	String cancel 	= request.getParameter("cancel")==null?"":request.getParameter("cancel");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String start_date = request.getParameter("start_date")==null?"":request.getParameter("start_date");
	String end_date = request.getParameter("end_date")==null?"":request.getParameter("end_date");
	
	int count = 0;
	
	int count2 = 0;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag = true;
	
	String target_id1 	= "";

	String target_id 	= "";
	String sender_id 	= "";
		
	String login_id 	= request.getParameter("login_id")==null?ck_acar_id:request.getParameter("login_id");	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
			
			//문서품의
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("22", doc_no);
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	if(sender_bean.getDept_id().equals("0001")  ) {  		// 부서코드가 영업팀, 강남영업, 인천
		if(sender_bean.getUser_id().equals("000005")||sender_bean.getUser_id().equals("000028")||sender_bean.getUser_id().equals("000057")||sender_bean.getUser_id().equals("000077")||sender_bean.getUser_id().equals("000144")){
			target_id1 = "000005";						// 타겟은 000005 (영업부 기획팀장-정채달)
		}else{
			target_id1 = "000028";						// 타겟은 000028 (영업부 팀장-김진좌)
		}	
		
		
	}else if( sender_bean.getDept_id().equals("0002") ||   sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //고객지원
			target_id1 = "000026";
						
	}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018")  ) { //수원
			if( sender_bean.getLoan_st().equals("1")){ //관리
				target_id1 = "000026";
			}else { //영업
				target_id1 = "000028";
			}
						
	}else if(sender_bean.getDept_id().equals("0003")) {
			target_id1 = "000004";

	}else if(sender_bean.getDept_id().equals("0005")) {
			target_id1 = "000237";
			
	}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
			if(sender_bean.getUser_id().equals("000053")){
				target_id1 = "000004";
			}else{
				target_id1 = "000053";
			}
			
	}else if(sender_bean.getDept_id().equals("0008")) {
			if(sender_bean.getUser_id().equals("000052")){
				target_id1 = "000004";
			}else{
				target_id1 = "000052";
			}
	}else if(sender_bean.getDept_id().equals("0010")) {//광주지점  , 광지점장  연차시 총무팀장
			if(sender_bean.getUser_id().equals("000219")){
				target_id1 = "000004";
			}else{
				target_id1 = "000219";
			}
	}else if(sender_bean.getDept_id().equals("0011")) {		//대구지점 윤영탁, 대구지점장 연차시 총무팀장
			if(sender_bean.getUser_id().equals("000054")){
				target_id1 = "000004";
			}else{
				target_id1 = "000054";
			}
	}
			
		
	if(cmd.equals("c")){ //팀장 결재
	
	//	count2 = fsd.Cancel_free(user_id, start_date, end_date);  //년차 삭제		
		
		flag =  fsd.UpdateCancel_freetime(doc_no, user_id);		
		count = fsd.UpdateCancel_check(doc_no, user_id);
				
		
		
	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		login_id = doc.getUser_id2();
					
		flag1 = d_db.updateDocSettleOt2(doc_no, "2", "3", login_id, "22");			
		
			
	// 메신져 끝

	}	
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("i")){
		if(count==1){
%>
		alert("정상적으로 취소 신청되었습니다.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
				
<%	}

}else if(cmd.equals("c")){
		if(count2==1){
%>
		alert("결재되었습니다.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();
				
<%	}
	
}else if(cmd.equals("s_cm")){
		if(count==1){
%>
		alert("메세지 재전송 되었습니다.");
		fm.action='free_time_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();	
						
<%	}
}
%>
//-->
</script>

</body>
</html>