<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*, tax.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int count = 0;
	
	
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String vid1[] 	= request.getParameterValues("rent_l_cd");
	String vid2[] 	= request.getParameterValues("firm_nm");
	String vid3[] 	= request.getParameterValues("car_no");
	String vid4[] 	= request.getParameterValues("bad_amt");
	String vid5[] 	= request.getParameterValues("cls_use_mon");
	String vid6[] 	= request.getParameterValues("bad_debt_cau");
	String vid7[] 	= request.getParameterValues("bad_cls_amt");
	String vid8[] 	= request.getParameterValues("bad_fine_amt");
	String vid9[] 	= request.getParameterValues("bad_serv_amt");
	String vid_num		= "";
	
	int vid_size = vid1.length;
	
//	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		String title 	= "[소액채권대손처리요청]"+vid1[i]+" "+vid2[i];
		String content 	= "차량번호 : "+vid3[i]+"\n해지경과월 : "+vid5[i]+"\n미수채권 : "+vid4[i]+" (해지정산금"+vid7[i]+",과태료"+vid8[i]+",면책금"+vid9[i]+")\n\n대손사유 : "+vid6[i];
		
		
		cp_bean.setIn_id	(ck_acar_id);
		cp_bean.setTitle	(title);
		cp_bean.setContent	(content);
		cp_bean.setOut_id	("");
		cp_bean.setSub_id	("000004");
		
		count = cp_db.insertCooperation(cp_bean);
	}
	
	if(vid_size>0){
		
		UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
		UsersBean target_bean 	= umd.getUsersBean("000004");
		
		String sub 		= "소액채권대손처리요청 업무협조 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 소액채권대손처리요청 업무협조를 요청하셨습니다. 확인바랍니다.";
		
		String url 		= "/fms2/cooperation/cooperation_frame.jsp";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
  					"<BACKIMG>4</BACKIMG>"+
  					"<MSGTYPE>104</MSGTYPE>"+
  					"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
  					"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
					
					//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					//보낸사람
					xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  				"    <MSGICON>10</MSGICON>"+
  				"    <MSGSAVE>1</MSGSAVE>"+
  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
  				"  	 </ALERTMSG>"+
  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
	}
	%>
<script language='javascript'>
<%		if(count==0){	%>	alert('에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'settle_sc.jsp';
	fm.target = 'c_body';
	fm.submit();
	
	parent.window.close();
</script>
</body>
</html>