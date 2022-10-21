<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.car_sche.*, acar.accid.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//@ author : JHM - 사고처리결과문서관리
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String vid[] 	= request.getParameterValues("ch_cd");
	
	String vid_num="";
	
	String ch_i="";  
	String ch_chk_cnt="";  
	String ch_doc_no="";
		
	int vid_size = vid.length;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	int count = 0;
		
	AccidDatabase as_db = AccidDatabase.getInstance();
		
	//System.out.println("선택건수="+vid_size+"<br><br>");
		
	String doc_bit 	= "2";
	String doc_step = "3";
	String c_id 	= "";
	String accid_id = "";
		
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
				
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
		
				
		while(token1.hasMoreTokens()) {				
				ch_i = token1.nextToken().trim();	
				ch_chk_cnt = token1.nextToken().trim();		
				ch_doc_no = token1.nextToken().trim(); 	
		
		}		
		
		DocSettleBean doc = d_db.getDocSettle(ch_doc_no);
		
		flag1 = d_db.updateDocSettle(ch_doc_no, user_id, doc_bit, doc_step);
		
		c_id 		= doc.getDoc_id().substring(0,6);
		accid_id 	= doc.getDoc_id().substring(6);
				
				
		AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
		
		accid.setSettle_st("1");//종결처리
		
		count = as_db.updateAccident(accid);
				
	
	//	System.out.println("doc_no="+ch_doc_no+"<br>");
	//	System.out.println("c_id="+c_id+"<br>");
	//	System.out.println("accid_id="+accid_id+"<br>");
	//	System.out.println("accid.getCar_mng_id()="+accid.getCar_mng_id()+"<br>");
	//	System.out.println("accid.getAccid_id()="+accid.getAccid_id()+"<br><br>");
		
				
	}
	
		

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  	
</form>
<script language='javascript'>
<%	if(flag1){	%>		
		var fm = document.form1;	
		fm.action = '/fms2/accid_mng/accid_result_frame.jsp';
		fm.target = 'd_content';
		fm.submit();		
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>