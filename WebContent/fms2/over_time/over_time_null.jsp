<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.over_time.*, acar.user_mng.*, acar.coolmsg.*, acar.doc_settle.*" %>
<jsp:useBean id="ot_bean" scope="page" class="acar.over_time.Over_TimeBean"/>
<jsp:useBean id="doc" scope="page" class="acar.doc_settle.DocSettleBean"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>	
<%@ include file="/acar/cookies.jsp" %>

<%
	String savePath="D:\\Inetpub\\wwwroot\\data\\over_time"; // 저장할 디렉토리 (절대경로)
	
	int sizeLimit = 5 * 1024 * 1024 ; // 5메가까지 제한 넘어서면 예외발생
	
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit);
	
	String user_id 	= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");
//	int seq 		= multi.getParameter("seq")==null?1:Util.parseInt(multi.getParameter("seq"));
	
	String reg_dt	= multi.getParameter("reg_dt")==null?"":multi.getParameter("reg_dt");
	
	String over_sjgj	=	multi.getParameter("over_sjgj")==null?"":multi.getParameter("over_sjgj");
	String over_sjgj_dt	=	multi.getParameter("over_sjgj_dt")==null?"":multi.getParameter("over_sjgj_dt");
	String over_sjgj_op	=	multi.getParameter("over_sjgj_op")==null?"":multi.getParameter("over_sjgj_op");
	
	String over_cont	= multi.getParameter("over_cont")==null?"":multi.getParameter("over_cont");
	String over_cr	= multi.getParameter("over_cr")==null?"":multi.getParameter("over_cr");
	
		
	String jb_time	= multi.getParameter("jb_time")==null?"":multi.getParameter("jb_time");
	String jb_time2 = multi.getParameter("jb_time2")==null?"":multi.getParameter("jb_time2");
	
	String over_addr = multi.getParameter("over_addr")==null?"":multi.getParameter("over_addr");
	
	String over_card1_dt =multi.getParameter("over_card1_dt")==null?"":multi.getParameter("over_card1_dt");
	int over_card1_amt = multi.getParameter("over_card1_amt")==null?0:Util.parseInt(multi.getParameter("over_card1_amt"));
	String over_cash1_dt =multi.getParameter("over_cash1_dt")==null?"":multi.getParameter("over_cash1_dt");
	int over_cash1_amt = multi.getParameter("over_cash1_amt")==null?0:Util.parseInt(multi.getParameter("over_cash1_amt"));
	String over_cash1_file =multi.getParameter("over_cash1_file")==null?"":multi.getParameter("over_cash1_file");
	int over_cash1_cr_amt = multi.getParameter("over_cash1_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_cash1_cr_amt"));
	String over_cash1_cr_dt = multi.getParameter("over_cash1_cr_dt")==null?"":multi.getParameter("over_cash1_cr_dt");
	String over_cash1_cr_jpno = multi.getParameter("over_cash1_cr_jpno")==null?"":multi.getParameter("over_cash1_cr_jpno");
	String over_s_cash1_dt = multi.getParameter("over_s_cash1_dt")==null?"":multi.getParameter("over_s_cash1_dt");
	int over_s_cash1_amt = multi.getParameter("over_s_cash1_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash1_amt"));
	String over_s_cash1_file = multi.getParameter("over_s_cash1_file")==null?"":multi.getParameter("over_s_cash1_file");
	int over_s_cash1_cr_amt = multi.getParameter("over_s_cash1_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash1_cr_amt"));
	String over_s_cash1_cr_jpno =multi.getParameter("over_s_cash1_cr_jpno")==null?"":multi.getParameter("over_s_cash1_cr_jpno");
	
	String over_card2_dt =multi.getParameter("over_card2_dt")==null?"":multi.getParameter("over_card2_dt");
	int over_card2_amt = multi.getParameter("over_card2_amt")==null?0:Util.parseInt(multi.getParameter("over_card2_amt"));
	String over_cash2_dt =multi.getParameter("over_cash2_dt")==null?"":multi.getParameter("over_cash2_dt");
	int over_cash2_amt = multi.getParameter("over_cash2_amt")==null?0:Util.parseInt(multi.getParameter("over_cash2_amt"));
	String over_cash2_file =multi.getParameter("over_cash2_file")==null?"":multi.getParameter("over_cash2_file");
	int over_cash2_cr_amt = multi.getParameter("over_cash2_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_cash2_cr_amt"));
	String over_cash2_cr_dt = multi.getParameter("over_cash2_cr_dt")==null?"":multi.getParameter("over_cash2_cr_dt");
	String over_cash2_cr_jpno = multi.getParameter("over_cash2_cr_jpno")==null?"":multi.getParameter("over_cash2_cr_jpno");
	String over_s_cash2_dt = multi.getParameter("over_s_cash2_dt")==null?"":multi.getParameter("over_s_cash2_dt");
	int over_s_cash2_amt = multi.getParameter("over_s_cash2_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash2_amt"));
	String over_s_cash2_file = multi.getParameter("over_s_cash2_file")==null?"":multi.getParameter("over_s_cash2_file");
	int over_s_cash2_cr_amt = multi.getParameter("over_s_cash2_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash2_cr_amt"));
	String over_s_cash2_cr_jpno =multi.getParameter("over_s_cash2_cr_jpno")==null?"":multi.getParameter("over_s_cash2_cr_jpno");
	
	String over_card3_dt =multi.getParameter("over_card3_dt")==null?"":multi.getParameter("over_card3_dt");
	int over_card3_amt = multi.getParameter("over_card3_amt")==null?0:Util.parseInt(multi.getParameter("over_card3_amt"));
	String over_cash3_dt =multi.getParameter("over_cash3_dt")==null?"":multi.getParameter("over_cash3_dt");
	int over_cash3_amt = multi.getParameter("over_cash3_amt")==null?0:Util.parseInt(multi.getParameter("over_cash3_amt"));
	String over_cash3_file =multi.getParameter("over_cash3_file")==null?"":multi.getParameter("over_cash3_file");
	int over_cash3_cr_amt = multi.getParameter("over_cash3_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_cash3_cr_amt"));
	String over_cash3_cr_dt = multi.getParameter("over_cash3_cr_dt")==null?"":multi.getParameter("over_cash3_cr_dt");
	String over_cash3_cr_jpno = multi.getParameter("over_cash3_cr_jpno")==null?"":multi.getParameter("over_cash3_cr_jpno");
	String over_s_cash3_dt = multi.getParameter("over_s_cash3_dt")==null?"":multi.getParameter("over_s_cash3_dt");
	int over_s_cash3_amt = multi.getParameter("over_s_cash3_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash3_amt"));
	String over_s_cash3_file = multi.getParameter("over_s_cash3_file")==null?"":multi.getParameter("over_s_cash3_file");
	int over_s_cash3_cr_amt = multi.getParameter("over_s_cash3_cr_amt")==null?0:Util.parseInt(multi.getParameter("over_s_cash3_cr_amt"));
	String over_s_cash3_cr_jpno =multi.getParameter("over_s_cash3_cr_jpno")==null?"":multi.getParameter("over_s_cash3_cr_jpno");
	
	int over_card_tot = multi.getParameter("over_card_tot")==null?0:Util.parseInt(multi.getParameter("over_card_tot"));
	int over_cash_tot = multi.getParameter("over_cash_tot")==null?0:Util.parseInt(multi.getParameter("over_cash_tot"));
	int over_s_cash_tot = multi.getParameter("over_s_cash_tot")==null?0:Util.parseInt(multi.getParameter("over_s_cash_tot"));
	
	int over_scgy = multi.getParameter("over_scgy")==null?0:Util.parseInt(multi.getParameter("over_scgy"));
	String over_scgy_dt =multi.getParameter("over_scgy_dt")==null?"":multi.getParameter("over_scgy_dt");
	String over_scgy_pl_dt =multi.getParameter("over_scgy_pl_dt")==null?"":multi.getParameter("over_scgy_pl_dt");
	
	String s_check =multi.getParameter("s_check")==null?"":multi.getParameter("s_check");
	String s_check_dt =multi.getParameter("s_check_dt")==null?"":multi.getParameter("s_check_dt");
	String s_check_id = multi.getParameter("s_check_id")==null?"":multi.getParameter("s_check_id");
	
	String t_check = multi.getParameter("t_check")==null?"":multi.getParameter("t_check");
	String t_check_dt = multi.getParameter("t_check_dt")==null?"":multi.getParameter("t_check_dt");
	String t_check_id = multi.getParameter("t_check_id")==null?"":multi.getParameter("t_check_id");
	
	String cmd		= multi.getParameter("cmd")==null?"":multi.getParameter("cmd");
	String us_id 	= multi.getParameter("us_id")==null?"":multi.getParameter("us_id");
	
	String req_id	 	= multi.getParameter("req_id")==null?"":multi.getParameter("req_id");
	String doc_bit 	= multi.getParameter("doc_bit")==null?"":multi.getParameter("doc_bit");
	String doc_no 	= multi.getParameter("doc_no")==null?"":multi.getParameter("doc_no");
	String doc_step 	= multi.getParameter("doc_step")==null?"":multi.getParameter("doc_step");
	String user_id1 	= multi.getParameter("user_id1")==null?"":multi.getParameter("user_id1");
	
	String start_dt		= multi.getParameter("start_dt")==null?"":multi.getParameter("start_dt");
	String start_h		= multi.getParameter("start_h")==null?"":multi.getParameter("start_h");
	String start_m		= multi.getParameter("start_m")==null?"":multi.getParameter("start_m");
	
	String end_dt		= multi.getParameter("end_dt")==null?"":multi.getParameter("end_dt");
	String end_h		= multi.getParameter("end_h")==null?"":multi.getParameter("end_h");
	String end_m		= multi.getParameter("end_m")==null?"":multi.getParameter("end_m");
	
	String over_time_year		= multi.getParameter("over_time_year")==null?"":multi.getParameter("over_time_year");
	String over_time_mon		= multi.getParameter("over_time_mon")==null?"":multi.getParameter("over_time_mon");
	
//	String jb_time5 = AddUtil.ChangeTime3(String.valueOf(AddUtil.parseLong(AddUtil.ChangeString(end_dt) + end_h + end_m)- AddUtil.parseLong(AddUtil.ChangeString(start_dt) + start_h + start_m)));	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String target_id1 	= "";
	String target_id2 	= "";
	String target_id3 	= "";
	
	String target_id7 	= "";
	String target_id8 	= "";
	String target_id9 	= "";
	String target_id10 	= "";
	
	int count = 0;
	
	String file1 = multi.getParameter("file1")==null?"":multi.getParameter("file1");
	String file2 = multi.getParameter("file2")==null?"":multi.getParameter("file2");
	String file3 = multi.getParameter("file3")==null?"":multi.getParameter("file3");
	String file4 = multi.getParameter("file4")==null?"":multi.getParameter("file4");
	String file5 = multi.getParameter("file5")==null?"":multi.getParameter("file5");
	String file6 = multi.getParameter("file6")==null?"":multi.getParameter("file6");
	
	String filename[] = new String[6];
	
	//한글이 깨지는 문제 -multipartrequest

    over_cont=new String(over_cont.getBytes("8859_1"),"euc-kr");  
 	over_cr=new String(over_cr.getBytes("8859_1"),"euc-kr");  
 	over_addr=new String(over_addr.getBytes("8859_1"),"euc-kr");
 	file1=new String(file1.getBytes("8859_1"),"euc-kr");  
 	file2=new String(file2.getBytes("8859_1"),"euc-kr");  
 	file3=new String(file3.getBytes("8859_1"),"euc-kr");  
 	file4=new String(file4.getBytes("8859_1"),"euc-kr");  
 	file5=new String(file5.getBytes("8859_1"),"euc-kr");
 	file6=new String(file6.getBytes("8859_1"),"euc-kr");
	
	boolean flag6 = true;
	
	OverTimeDatabase otd = OverTimeDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	
	String req_code  = Long.toString(System.currentTimeMillis());

//sender
	UsersBean sender_bean 	= umd.getUsersBean(user_id);

//target	

// 총무팀장
	Vector users1 = c_db.getUserList_over_time("", "", "BODY1","Y"); 
	int user1_size = users1.size();
// 영업팀장
	Vector users2 = c_db.getUserList_over_time("", "", "BODY2","Y"); 
	int user2_size = users2.size();
// 관리팀장
	Vector users3 = c_db.getUserList_over_time("", "", "BODY3","Y"); 
	int user3_size = users3.size();		
// 부산지점장
	Vector users4 = c_db.getUserList_over_time("", "", "BODY4","Y"); 
	int user4_size = users4.size();		
// 대전지점장
	Vector users5 = c_db.getUserList_over_time("", "", "BODY5","Y"); 
	int user5_size = users5.size();				
// 대표이사
	Vector users6 = c_db.getUserList_over_time("", "", "BODY6","Y"); 
	int user6_size = users6.size();	
// 광주지점
	Vector users10 = c_db.getUserList_over_time("", "", "BODY10","Y"); 
	int user10_size = users10.size();
// 대구지점
	Vector users11 = c_db.getUserList_over_time("", "", "BODY11","Y"); 
	int user11_size = users11.size();	
// IT팀장
	Vector users8 = c_db.getUserList_over_time("", "", "BODY8","Y"); 
	int users8_size = users8.size();		
	
	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
		
	int f = 5;
		
	String formName ="";
		
	while( formNames.hasMoreElements() ) {
			  formName = (String)formNames.nextElement();   // 폼에서 type이 file인것의 이름(name)을 반환(예 : upload1)
		//	  System.out.println("formname="+ formName);
			  filename[f] = multi.getFilesystemName(formName); // 파일의 이름 얻기
			  f--;
	 } 
		

    //중복등록 check
	int dup_cnt= 0;
	dup_cnt = otd.getCntOver_time(user_id, start_dt);
	
	if ( dup_cnt < 1)  {
	
		ot_bean.setUser_id(user_id);
		
		ot_bean.setReg_dt(reg_dt); 
		ot_bean.setOver_sjgj(over_sjgj);
		ot_bean.setOver_sjgj_dt(over_sjgj_dt);
		ot_bean.setOver_sjgj_op(over_sjgj_op);
		
		ot_bean.setOver_cont(over_cont);
		ot_bean.setOver_cr(over_cr);
		
		
	//	ot_bean.setJb_time(jb_time5);
		ot_bean.setJb_time2(jb_time2);
		
		ot_bean.setOver_addr(over_addr);
		
		ot_bean.setOver_card1_dt(over_card1_dt);
		ot_bean.setOver_card1_amt(over_card1_amt);
		ot_bean.setOver_cash1_dt(over_cash1_dt);
		ot_bean.setOver_cash1_amt(over_cash1_amt);
		
		ot_bean.setOver_cash1_file(over_cash1_file);
		
		ot_bean.setOver_cash1_cr_amt(over_cash1_cr_amt);
		ot_bean.setOver_cash1_cr_dt(over_cash1_cr_dt);
		ot_bean.setOver_cash1_cr_jpno(over_cash1_cr_jpno);
		ot_bean.setOver_s_cash1_dt(over_s_cash1_dt);
		ot_bean.setOver_s_cash1_amt(over_s_cash1_amt);
		
		ot_bean.setOver_s_cash1_file(over_s_cash1_file);
		
		ot_bean.setOver_s_cash1_cr_amt(over_s_cash1_cr_amt);
		ot_bean.setOver_s_cash1_cr_jpno(over_s_cash1_cr_jpno);
		
		ot_bean.setOver_card2_dt(over_card2_dt);
		ot_bean.setOver_card2_amt(over_card2_amt);
		ot_bean.setOver_cash2_dt(over_cash2_dt);
		ot_bean.setOver_cash2_amt(over_cash2_amt);
		
		ot_bean.setOver_cash2_file(over_cash2_file);
		
		ot_bean.setOver_cash2_cr_amt(over_cash2_cr_amt);
		ot_bean.setOver_cash2_cr_dt(over_cash2_cr_dt);
		ot_bean.setOver_cash2_cr_jpno(over_cash2_cr_jpno);
		ot_bean.setOver_s_cash2_dt(over_s_cash2_dt);
		ot_bean.setOver_s_cash2_amt(over_s_cash2_amt);
		
		ot_bean.setOver_s_cash2_file(over_s_cash2_file);
		
		ot_bean.setOver_s_cash2_cr_amt(over_s_cash2_cr_amt);
		ot_bean.setOver_s_cash2_cr_jpno(over_s_cash2_cr_jpno);
		
		ot_bean.setOver_card3_dt(over_card3_dt);
		ot_bean.setOver_card3_amt(over_card3_amt);
		ot_bean.setOver_cash3_dt(over_cash3_dt);
		ot_bean.setOver_cash3_amt(over_cash3_amt);
		
		ot_bean.setOver_cash3_file(over_cash3_file);
		
		ot_bean.setOver_cash3_cr_amt(over_cash3_cr_amt);
		ot_bean.setOver_cash3_cr_dt(over_cash3_cr_dt);
		ot_bean.setOver_cash3_cr_jpno(over_cash3_cr_jpno);
		ot_bean.setOver_s_cash3_dt(over_s_cash3_dt);
		ot_bean.setOver_s_cash3_amt(over_s_cash3_amt);
		
		ot_bean.setOver_s_cash3_file(over_s_cash3_file);
		
		ot_bean.setOver_s_cash3_cr_amt(over_s_cash3_cr_amt);
		ot_bean.setOver_s_cash3_cr_jpno(over_s_cash3_cr_jpno);
		
		ot_bean.setOver_card_tot(over_card_tot);
		ot_bean.setOver_cash_tot(over_cash_tot);
		ot_bean.setOver_s_cash_tot(over_s_cash_tot);
		
		ot_bean.setOver_scgy(over_scgy);
		ot_bean.setOver_scgy_dt(over_scgy_dt);
		ot_bean.setOver_scgy_pl_dt(over_scgy_pl_dt);
		
		ot_bean.setS_check(s_check);
		ot_bean.setS_check_dt(s_check_dt);
		ot_bean.setS_check_id(s_check_id);
		ot_bean.setT_check(t_check);
		ot_bean.setT_check_dt(t_check_dt);
		ot_bean.setT_check_id(t_check_id);
		
		ot_bean.setStart_dt(start_dt);
		ot_bean.setStart_h(start_h);
		ot_bean.setStart_m(start_m);
		ot_bean.setEnd_dt(end_dt);
		ot_bean.setEnd_h(end_h);
		ot_bean.setEnd_m(end_m);
		ot_bean.setOver_time_year(over_time_year);
		ot_bean.setOver_time_mon(over_time_mon);
		ot_bean.setDoc_no(doc_no);
	
	
		if(filename[0] == null) {
			  ot_bean.setOver_cash1_file(file1);
		}
		else {
			  ot_bean.setOver_cash1_file(filename[0]);
		}
		if(filename[1] == null) {
		  ot_bean.setOver_s_cash1_file(file2);
		}
		else {
		  ot_bean.setOver_s_cash1_file(filename[1]);	
		}
			
		if(filename[2] == null) {
		  ot_bean.setOver_cash2_file(file3);
		}
		else {
		  ot_bean.setOver_cash2_file(filename[2]);	
		}
				
		if(filename[3] == null) {
		  ot_bean.setOver_s_cash2_file(file4);
		}
		else {
		  ot_bean.setOver_s_cash2_file(filename[3]);	
		}
					
		if(filename[4] == null) {
		  ot_bean.setOver_cash3_file(file5);
		}
		else {
		  ot_bean.setOver_cash3_file(filename[4]);	
		}
		
		if(filename[5] == null) {
			ot_bean.setOver_s_cash3_file(file6);
		}
		else{
			ot_bean.setOver_s_cash3_file(filename[5]);
		}
			
		
		doc_no = otd.insertOver_time(ot_bean);

	
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------

		
		String sub 		= "특근신청 등록 안내";
		String cont 	= "["+sender_bean.getUser_nm()+"]님의 특근 신청서가 등록 되었습니다. 확인바랍니다.";
			
	
		if(sender_bean.getDept_id().equals("0001")||sender_bean.getDept_id().equals("0009")) { 
			target_id1 = "000005";
		}else if(sender_bean.getDept_id().equals("0002")) {
			target_id1 = "000026";
		}else if(sender_bean.getDept_id().equals("0003")) {
			target_id1 = "000004";
		}else if(sender_bean.getDept_id().equals("0005")) {
			target_id1 = "000237";
		}else if(sender_bean.getDept_id().equals("0007")) {
			target_id1 = "000053";
		}else if(sender_bean.getDept_id().equals("0008")) {
			target_id1 = "000052";
		}else if(sender_bean.getDept_id().equals("0010")) {
			target_id1 = "000020";
		}else if(sender_bean.getDept_id().equals("0011")) {
			target_id1 = "000054";
		}

		target_id2 = "000004";//총무팀장
		
		Vector vt = otd.Over_Per(user_id, doc_no);

		
//		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("8");//특근신청
		doc.setDoc_id(doc_no);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("특근신청");
		doc.setUser_nm2("부서팀장");

		
		doc.setUser_nm7("인사담당");

		
		doc.setUser_id1(user_id);
		doc.setUser_id2(target_id1);
		
		doc.setUser_id7("000004");
		

		doc.setDoc_bit("1");//수신단계
		doc.setDoc_step("1");//기안
		
		
	//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		
	//문서처리전 등록 끝

		if(sender_bean.getDept_id().equals("0001")){
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user2_size > 0){
				for(int i = 0 ; i < user2_size ; i++){
					Hashtable user2 = (Hashtable)users2.elementAt(i);
					xml_data += "    <TARGET>"+user2.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
		
		
		// 메신져 끝

		}else if(sender_bean.getDept_id().equals("0002")){
			
		
					
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user3_size > 0){
				for(int i = 0 ; i < user3_size ; i++){
					Hashtable user3 = (Hashtable)users3.elementAt(i);
					xml_data += "    <TARGET>"+user3.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
		
		// 메신져 끝
		
		}else if(sender_bean.getDept_id().equals("0003")){
						
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user1_size > 0){
				for(int i = 0 ; i < user1_size ; i++){
					Hashtable user1 = (Hashtable)users1.elementAt(i);
					xml_data += "    <TARGET>"+user1.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
		
		// 메신져 끝	
		}else if(sender_bean.getDept_id().equals("0005")){
						
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user1_size > 0){
				for(int i = 0 ; i < user8_size ; i++){
					Hashtable user8 = (Hashtable)users8.elementAt(i);
					xml_data += "    <TARGET>"+user8.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
		
		// 메신져 끝	

		}else if(sender_bean.getDept_id().equals("0007")){
			
		
					
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user4_size > 0){
				for(int i = 0 ; i < user4_size ; i++){
					Hashtable user4 = (Hashtable)users4.elementAt(i);
					xml_data += "    <TARGET>"+user4.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
		
		// 메신져 끝	

		}else if(sender_bean.getDept_id().equals("0008")){
		
					
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user5_size > 0){
				for(int i = 0 ; i < user5_size ; i++){
					Hashtable user5 = (Hashtable)users5.elementAt(i);
					xml_data += "    <TARGET>"+user5.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );				
		 // 메신져 끝	
		}else if(sender_bean.getDept_id().equals("0010")){
		
					
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user10_size > 0){
				for(int i = 0 ; i < user10_size ; i++){
					Hashtable user10 = (Hashtable)users10.elementAt(i);
					xml_data += "    <TARGET>"+user10.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );				
		
		}else if(sender_bean.getDept_id().equals("0011")){
		
					
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		
			String url 		= "/fms2/over_time/over_time_frame.jsp";
			String m_url = "/fms2/over_time/over_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		
			//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
		
			if(user11_size > 0){
				for(int i = 0 ; i < user11_size ; i++){
					Hashtable user11 = (Hashtable)users11.elementAt(i);
					xml_data += "    <TARGET>"+user11.get("ID")+"</TARGET>";
				}
			}
		
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
			
		
			flag6 = cm_db.insertCoolMsg(msg);
		
		//	System.out.println(xml_data);
			System.out.println("쿨메신저(특근수당 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );				
		
		}//메신져 끝
} //중복이 아니면

%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='us_id' value='<%=us_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<% if(dup_cnt < 1) {
		if(!doc_no.equals("")){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./over_time_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();			
				
<%	}
}else {
%>
	alert("해당일에 특근등록이 이미 등록되었습니다.");
	fm.action='./over_time_frame.jsp';
	fm.target='d_content';
	top.window.close();
	fm.submit();					
<%	}

%>
//-->
</script>
</body>
</html>
