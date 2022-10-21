<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.master_car.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String jung_dt 	= request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");
	String br_id2 	= request.getParameter("br_id2")==null?"":request.getParameter("br_id2");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String off_nm 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	
	String msg_send_bit 	= request.getParameter("msg_send_bit")==null?"":request.getParameter("msg_send_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	String doc_step = "";
	String url 		= "";
	String sub 		= "";
	String cont 	= "";
	String target_id = "";
	
%>


<%
	DocSettleBean doc = new DocSettleBean();
	
	if(!doc_no.equals("") ) {
				
			doc_step = "2";
			
			doc = d_db.getDocSettle(doc_no);
			
								
			//총무팀장 결재이면 문서 결재 완료
			if(doc_bit.equals("3"))	doc_step = "3";  
			
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		//	doc = d_db.getDocSettle(doc_no);
			
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
			out.println("문서처리전 결재<br>");
				
			//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			url 		= "/fms2/ssmoters/car_maint_req_doc_frame.jsp";
			sub 		= "자동차검사비 지출결의서 결재 요청"; 
			cont 	= "[자동차검사업체: "+off_nm+"] 자동차검사비 지출결의서 결재를 요청합니다.";
					
			if(doc_bit.equals("3"))	{
				url 		= "/fms2/ssmoters/car_maint_req_doc_frame.jsp";
				sub 		= "자동차검사비 지출결의서 결재 완료";
				cont 	= "[자동차검사업체: "+off_nm+", 정산일자: "+jung_dt+"] 자동차검사비 지출결의서 결재를  완결하니 출금 집행하세요";				
			}
						
			if(doc_bit.equals("2") )	target_id = doc.getUser_id3();
				
	
	        if(doc_step.equals("3"))	target_id =  doc.getUser_id1(); // 기안자에게 전달 
					
		//	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		//	if(!cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
	  					"    <CONT>"+cont+"</CONT>"+
	  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			//받는사람
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			//보낸사람
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
			//out.println("쿨메신저 수정<br>");
			if(doc_bit.equals("3"))	{
				System.out.println("쿨메신저(자동차검사 비용결재)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm()+" "+cont);		
			}
			
	}
	
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert(' 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
//	fm.submit();
	
	window.close();
	opener.location.reload();
</script>
</body>
</html>