<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.free_time.*,  acar.car_sche.*, acar.coolmsg.*, acar.doc_settle.*"%>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="fc_bean" class="acar.free_time.Free_CancelBean" scope="page"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
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
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String start_date = request.getParameter("start_date")==null?"":request.getParameter("start_date");
	String end_date = request.getParameter("end_date")==null?"":request.getParameter("end_date");
	
	String o_work_id = request.getParameter("o_work_id")==null?"":request.getParameter("o_work_id");
	String work_id = request.getParameter("work_id")==null?"":request.getParameter("work_id");
	
	int count = 0;
	boolean flag6 = true;
	   
	count = fsd.UpdateFreeWorkCng(user_id, doc_no, work_id);
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
			
		
	UsersBean target_bean1 	= umd.getUsersBean(o_work_id);
	UsersBean target_bean2 	= umd.getUsersBean(work_id);
		
	String sub 		= "휴가결재 업무대체자 변경 안내";
	String cont 	= "["+user_bean.getUser_nm()+"]님의 휴가("+start_date+"~"+end_date+") 신청서 업무대체자가 "+target_bean1.getUser_nm()+"님에서 "+target_bean2.getUser_nm()+"님으로 변경되었습니다. 업무에 참고하십시오.";	
	String xml_data = "";
			
			xml_data = "";	
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL></URL>";
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>"; //받는사람
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>"; //받는사람
			xml_data += "    <SENDER>"+user_bean.getId()+"</SENDER>"+	//보낸사람
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
	
<% if(count>0){%>
		alert("정상적으로 업무대체자가 변경되었습니다.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
				
<%	}%>
		
//-->
</script>

</body>
</html>