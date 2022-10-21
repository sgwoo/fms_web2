<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.res_search.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String seq_no = request.getParameter("seq_no")==null?"1":request.getParameter("seq_no");//사고관리일련번호
	String coolmsg_sub = request.getParameter("coolmsg_sub")==null?"":request.getParameter("coolmsg_sub");
	String coolmsg_cont = request.getParameter("coolmsg_cont")==null?"":request.getParameter("coolmsg_cont");
	
	int count = 0;
	boolean flag2 = true;
	
	
	MyAccidBean ma_bean 	= as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
	
	count = as_db.updateMyAccidDocReqDt(ma_bean);
	
	String app_doc4 	= request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4");//첨부문서
	String app_doc5 	= request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5");//첨부문서
	String app_doc6 	= request.getParameter("app_doc6")==null?"N":request.getParameter("app_doc6");//첨부문서
	String app_doc7 	= request.getParameter("app_doc7")==null?"N":request.getParameter("app_doc7");//첨부문서
	String app_doc8 	= request.getParameter("app_doc8")==null?"N":request.getParameter("app_doc8");//첨부문서
	String app_doc9 	= request.getParameter("app_doc9")==null?"N":request.getParameter("app_doc9");//첨부문서
	String app_doc10 	= request.getParameter("app_doc10")==null?"N":request.getParameter("app_doc10");//첨부문서
	
	String app_docs = "^Y^Y^Y^"+app_doc4+"^"+app_doc5+"^"+app_doc6+"^"+app_doc7+"^"+app_doc8+"^"+app_doc9+"^"+app_doc10;
	
	ma_bean.setApp_docs		(app_docs);//대여청구 첨부문서
	ma_bean.setUpdate_id	(ck_acar_id);
	count = as_db.updateMyAccid(ma_bean);
	
	
		  //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
			String sub 		= coolmsg_sub;
			String cont 	= coolmsg_cont;
			
			String url 		= "/fms2/accid_doc/accid_mydoc_reg_frame.jsp";
			
			String target_id = "000144";  //담당자 - 김태연
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
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
			
			flag2 = cm_db.insertCoolMsg(msg);

%>

<form name='form1' method='post' action='../accid_mng/accid_s_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
</form>
<script language='javascript'>
<%		if(count == 0){	%>
		alert('에러입니다.\n\n처리되지 않았습니다');
		location='about:blank';
<%		}else{	%>
		alert("처리되었습니다");
		var fm = document.form1;
		fm.action = "accid_u_in<%=mode%>.jsp";		
		fm.target = "c_foot";		
		fm.submit();			
<%		}	%>
</script>
</body>
</html>
