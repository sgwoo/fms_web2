<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*" %>
<jsp:useBean id="fab_bean" class="acar.free_time.AbsenceBean" scope="page"/>

<%
	
	
	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
		
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차대상자
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	String jse_dt = request.getParameter("jse_dt")==null?"":request.getParameter("jse_dt");	
	String kkjss_dt = request.getParameter("kkjss_dt")==null?"":request.getParameter("kkjss_dt");	
	String kmjss_dt = request.getParameter("kmjss_dt")==null?"":request.getParameter("kmjss_dt");	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");

	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String m_start_day = request.getParameter("m_start_day")==null?"":request.getParameter("m_start_day");	 //휴직기간 변경처리
	String m_end_day = request.getParameter("m_end_day")==null?"":request.getParameter("m_end_day");	//휴직기간 변경처리
	String t_dt = request.getParameter("t_dt")==null?"":request.getParameter("t_dt");	//휴직기간 변경처리
		
	int count = 0;
	
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();

	if(cmd.equals("i")){
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(1);
		fab_bean.setGubun		("KK");
		fab_bean.setStart_dt	(start_dt);
		fab_bean.setEnd_dt		(end_dt);
		fab_bean.setJse_dt		(jse_dt);
		fab_bean.setJse_mng		(ck_acar_id); 

		count = fsd.Insert_Absence(fab_bean);
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(2);
		fab_bean.setGubun		("KM");
		fab_bean.setStart_dt	(start_dt);
		fab_bean.setEnd_dt		(end_dt);
		fab_bean.setJse_dt		(jse_dt);
		fab_bean.setJse_mng		(ck_acar_id); 

		count = fsd.Insert_Absence(fab_bean);
		
	}else if(cmd.equals("ii")){
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(1);
		fab_bean.setGubun		("KK");
		fab_bean.setJss_dt		(kkjss_dt);
		fab_bean.setJss_mng		(ck_acar_id); 

		count = fsd.Update_Absence_Jss(fab_bean);
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(2);
		fab_bean.setGubun		("KM");
		fab_bean.setJss_dt		(kmjss_dt);
		fab_bean.setJss_mng		(ck_acar_id); 

		count = fsd.Update_Absence_Jss(fab_bean);
		
	}else if(cmd.equals("u")){
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(1);
		fab_bean.setGubun		("KK");
		fab_bean.setStart_dt	(start_dt);
		fab_bean.setEnd_dt		(end_dt);
		fab_bean.setJse_dt		(jse_dt);
		fab_bean.setJse_mng		(ck_acar_id); 

		count = fsd.Update_Absence_Jse(fab_bean);
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(2);
		fab_bean.setGubun		("KM");
		fab_bean.setStart_dt	(start_dt);
		fab_bean.setEnd_dt		(end_dt);
		fab_bean.setJse_dt		(jse_dt);
		fab_bean.setJse_mng		(ck_acar_id); 

		count = fsd.Update_Absence_Jse(fab_bean);
	}else if(cmd.equals("m")){
		
		fab_bean.setDoc_id		(doc_no);
		fab_bean.setSeq			(1);
		fab_bean.setGubun		("XX");  //휴직기간 변경건 (전산팀에서 처리 - pl 연동 )
		fab_bean.setStart_dt	(m_start_day);
		fab_bean.setEnd_dt		(m_end_day);
		fab_bean.setJse_dt		(t_dt);
		fab_bean.setJse_mng		("999999"); 

		count = fsd.Update_Absence_Jse(fab_bean);	
		
	}
%>
<html>
<head>
<title>FMS</title>

</head>
<script language="JavaScript">
<!--
	function go_parent(){
		var fm = document.form1;
		fm.action = "./absence_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}

	function go_parent_list(){
		var fm = document.form1;
		fm.action = "./absence_frame.jsp";
		fm.target='d_content';
		fm.submit();
	}

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>

<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<% if(cmd.equals("i")||cmd.equals("ii")){	
	if(!doc_no.equals("")){
%>
		alert("정상적으로 등록되었습니다.");
		go_parent_list();
		parent.close();	
<%}
	}else if(cmd.equals("u")){	
 		if(count==1){
%>
		alert("정상적으로 수정되었습니다.");
		go_parent_list();
		parent.close();					
<%}
	}
else { %>
	alert("오류입니다!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>
