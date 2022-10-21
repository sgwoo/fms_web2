<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.free_time.*, acar.res_search.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.schedule.* " %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String sch_chk 		= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon 	= request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String title 		= request.getParameter("title1")==null?"":request.getParameter("title1");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String work_id 		= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String ov_yn 		= request.getParameter("ov_yn")==null?"":request.getParameter("ov_yn");
	String sch_st 	= "";
	
	int count = 0;
	float f_remain = 0;
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String target_id1 	= "";
	
	int count = 0;
	float f_remain = 0;
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//받는사람 부서원들 조회
	Vector users = c_db.getUserList(sender_bean.getDept_id(), "", "SCH_PRV","Y"); 
	int user_size = users.size();	
	
	CarScheBean cs_bean = new CarScheBean();
	
	//현지출근, 업무일지 등록
	if(sch_chk.equals("1") || sch_chk.equals("2")){
						
		cs_bean.setStart_year	(start_year);
		cs_bean.setStart_mon	(AddUtil.addZero(start_mon));
		cs_bean.setStart_day	(AddUtil.addZero(start_day));
		cs_bean.setUser_id		(user_id);
		cs_bean.setSch_chk		(sch_chk);
		cs_bean.setTitle		(title);
		cs_bean.setContent		(content);
		cs_bean.setSch_kd		("2");//공유
		cs_bean.setWork_id		(work_id);
		
		if(sender_bean.getLoan_st().equals("1")) 		cs_bean.setSch_st		("M");
		else if(sender_bean.getLoan_st().equals("2")) 	cs_bean.setSch_st		("B");
		else  											cs_bean.setSch_st		("G");
		
		count = c_sd.insertCarSche(cs_bean);
		
	//휴가등록	
	}else{
		
		// 20181228 류길선과장 요청
		// 신달수, 김은철, 김홍찬, 김욱, 강주원, 김우석, 박찬웅, 이수재, 윤영탁, 제인학, 박영규 님은 본사 소속이 아닐경우 총무팀장님 결재
		if (sender_bean.getUser_id().equals("000051") || sender_bean.getUser_id().equals("000050") || 
			sender_bean.getUser_id().equals("000075") || sender_bean.getUser_id().equals("000011") || 
			sender_bean.getUser_id().equals("000010") || sender_bean.getUser_id().equals("000079") || 
			sender_bean.getUser_id().equals("000049") || sender_bean.getUser_id().equals("000219") || 
			sender_bean.getUser_id().equals("000054") || sender_bean.getUser_id().equals("000053") || 
			sender_bean.getUser_id().equals("000052")) {
			
			if (sender_bean.getDept_id().equals("0001")) {
				target_id1 = "000028";
			} else if (sender_bean.getDept_id().equals("0002")) {
				target_id1 = "000026";
			} else if (sender_bean.getDept_id().equals("0003")) {
				target_id1 = "000004";
			} else if (sender_bean.getDept_id().equals("0005")) {
				target_id1 = "000237";
			} else if (sender_bean.getDept_id().equals("0020")) {
				target_id1 = "000005";
			} else {
				target_id1 = "000004";
			}
			
		} else {		
			
			if(sender_bean.getDept_id().equals("0001")  ) {  		// 부서코드가 영업팀, 강남영업, 인천
				target_id1 = "000028";						// 타겟은 000028 (영업부 팀장-김진좌)		
					
			}else if( sender_bean.getDept_id().equals("0020")   ) { //영업 기획
				target_id1 = "000005";
							
			}else if( sender_bean.getDept_id().equals("0002") ||   sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //고객지원
				target_id1 = "000026";
								
			}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018") ) { //수원
				if( sender_bean.getLoan_st().equals("1") ){ //관리
					target_id1 = "000026";
				}else { //영업
					target_id1 = "000028";
				}
								
			}else if(sender_bean.getDept_id().equals("0003")) {
				target_id1 = "000004";
		
			}else if(sender_bean.getDept_id().equals("0005")) {  //it
				target_id1 = "000237";
		
			}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
				/* if(sender_bean.getUser_id().equals("000053")){
					target_id1 = "000004";
				}else{
					target_id1 = "000053";
				} */
				target_id1 = "000053";
					
			}else if(sender_bean.getDept_id().equals("0008")) {
				/* if(sender_bean.getUser_id().equals("000052")){
					target_id1 = "000004";
				}else{
					target_id1 = "000052";
				} */
				target_id1 = "000052";
				
			}else if(sender_bean.getDept_id().equals("0010")) {//광주지점 은 이수재 ->류선, 이수재 연차시 총무팀장 
				/* if(sender_bean.getUser_id().equals("000118")){
					target_id1 = "000052";
				}else{
					target_id1 = "000118";
				} */
				target_id1 = "000219";
						
			}else if(sender_bean.getDept_id().equals("0011")) {		//대구지점 윤영탁대리, 윤영탁대리 연차시 총무팀장
				/* if(sender_bean.getUser_id().equals("000054")){
					target_id1 = "000004";
				}else{
					target_id1 = "000054";
				} */
				target_id1 = "000054";
				
			}
			
		}	
		
		CarScheBean cs_bean2 = c_sd.getCarScheTodayBean(target_id1);  	
		
		//담당팀장 연차시 결재 skip 
		if(!cs_bean2.getWork_id().equals("")) target_id1 = "XXXXXX"; //생략		
		title 		= request.getParameter("title1")==null?"":request.getParameter("title1");
		
		
		//같은 기간에 휴가등록자를 업무대체자로 지정한 다른 휴가등록건이 있는지 체크
			//	System.out.println("st_dt >> " + st_dt);
			//	System.out.println("end_dt >> " + end_dt);
			//	System.out.println("user_id >> " + user_id);
				Vector checkVt = fsd.getWork_idCheck(st_dt, end_dt, user_id);
				int checkVt_size = checkVt.size();
			//	System.out.println("checkVt_size >> " + checkVt_size);
				if(checkVt_size>0){
					System.out.println("대체근무자 지정 확인~~~~!!!!");
					String sub = "대체근무자 지정 확인";
					String cont = "#주의# "+sender_bean.getUser_nm()+"님이 신청한 휴가 기간에는 ";					
					String xml_data = "";
					for(int i = 0; i < checkVt_size; i++){
						Hashtable ht = (Hashtable)checkVt.elementAt(i);
						
						String cont2 = cont+""+ ht.get("USER_NM") + "님의 대체근무자로 지정된 기간이 포함되어 있습니다.\n\n";
						
						cont2 += ht.get("USER_NM") + " (휴가기간: "+ht.get("START_DATE")+" ~ "+ht.get("END_DATE")+") \n";
																		
						xml_data =  "<COOLMSG>"+
								"<ALERTMSG>"+
								"<BACKIMG>4</BACKIMG>"+
								"<MSGTYPE>104</MSGTYPE>"+
								"<SUB>"+sub+"</SUB>"+
								"<CONT>"+cont+"</CONT>"+
								"<URL></URL>"+
								"<TARGET>"+sender_bean.getId()+"</TARGET>"+
								"<SENDER></SENDER>"+	
								"    <MSGICON>10</MSGICON>"+
								"    <MSGSAVE>1</MSGSAVE>"+
								"    <LEAVEDMSG>1</LEAVEDMSG>"+
								"    <FLDTYPE>1</FLDTYPE>"+
								"  </ALERTMSG>"+
								"</COOLMSG>";
	
						CdAlertBean msg = new CdAlertBean();
						msg.setFlddata(xml_data);
						msg.setFldtype("1");
	
						boolean flag_check = cm_db.insertCoolMsg(msg);
					}
						
				}
		
				
		Free_timeBean ft_bean = new Free_timeBean();
		ft_bean.setUser_id		(user_id);
		ft_bean.setStart_date	(st_dt);
		ft_bean.setEnd_date		(end_dt);
		ft_bean.setSch_chk		(sch_chk);
		ft_bean.setTitle		(title);
		ft_bean.setContent		(content);
		ft_bean.setSch_kd		("2");
		ft_bean.setWork_id		(work_id);
		
		if(sender_bean.getLoan_st().equals("1")) 		ft_bean.setSch_st		("M");
		else if(sender_bean.getLoan_st().equals("2")) 	ft_bean.setSch_st		("B");
		else  											ft_bean.setSch_st		("G");
		
		if (target_id1.equals("XXXXXX")) {
			ft_bean.setCm_check("Y");	//팀장연차시	
		}
			
	  	if (  nm_db.getWorkAuthUser("외부개발자",user_id)   ) {   //개발자는 결재없이 
	   			ft_bean.setCm_check("Y");	//팀장연차시	
		}
		
		String doc_no = fsd.InsertFree(ft_bean);  //doc_no는 free_time의 doc_no
		
		//포상휴가인 경우 ps_box에 해당 정보 갱신 -20190515
		if (sch_chk.equals("9") ) {			
		 int t_cnt = fsd.tour_update(user_id, st_dt, end_dt );			
		}
				
		int use_days = 0;
		use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));
		String dt = "";
		
		String save_dt = "";
		String s_remain = ""; 
		String due_dt = "";
		float use_cnt = 0;		
		float iw_cnt = 0;
		
		//연차인경우 이월처리
		if (sch_chk.equals("3") ) {
			Hashtable  vmh  = fsd.getVacationMagam(user_id);
			
			save_dt =  String.valueOf(vmh.get("SAVE_DT")); 
			due_dt =  String.valueOf(vmh.get("DUE_DT")); 
			s_remain =  String.valueOf(vmh.get("REMAIN")); 
			
			if ( !due_dt.equals("") ) 		iw_cnt= fsd.getIwolUseCnt(user_id, save_dt , due_dt);  // 유예기간에 실제 사용된 거 sum 
			
			f_remain = AddUtil.parseFloat(s_remain) - iw_cnt ;  //이월 연차갯수				
		}
		
		//free_time_item에 데이터 넘김	
		for(int i=0; i<use_days; i++){
			
			dt = rs_db.addDay(st_dt, i);
			
			String c_sysdate = "";
			
			c_sysdate = af_db.checkSunday(dt);
			if(!c_sysdate.equals(dt))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				continue;
			
			c_sysdate = af_db.checkHday(dt);
			if(!c_sysdate.equals(dt))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				continue;
			
			String setcount = "";
			if(title.equals("오전반차") || title.equals("오전반휴") ){				
				setcount = "B1";	
				use_cnt = AddUtil.parseFloat("0.5");
			}else if(title.equals("오후반차") || title.equals("오후반휴") ){
				setcount = "B2";	
				use_cnt = AddUtil.parseFloat("0.5");
			}else{
				setcount = "F";	
				use_cnt = 1;
			}
											
			flag1 = fsd.InsertFreeItem(doc_no, user_id, dt,setcount);
						
			//연차등록시 바로 sch_prv에 등록 			
			ScheduleDatabase csd = ScheduleDatabase.getInstance();

			cs_bean.setStart_year	(dt.substring(0,4));
			cs_bean.setStart_mon	(dt.substring(4,6));
			cs_bean.setStart_day	(dt.substring(6,8));
			cs_bean.setUser_id(user_id);
			cs_bean.setTitle(title);
			cs_bean.setContent(content);
			cs_bean.setSch_kd("2");
			cs_bean.setSch_st(sch_st);
			cs_bean.setSch_chk(sch_chk);
			cs_bean.setWork_id(work_id);
			cs_bean.setDoc_no(doc_no);
			
			if (target_id1.equals("XXXXXX")) {
				cs_bean.setGj_ck("Y");  //팀장연차시 결재 skip
			} else {
				cs_bean.setGj_ck("N");  //결재전
			}
			
			cs_bean.setCount(setcount);
				
			if(title.equals("오전반차") || title.equals("오전반휴")){			
				cs_bean.setContent(title);
			}else if(title.equals("오후반차") || title.equals("오후반휴")){
				cs_bean.setContent(title);
			}else{
				cs_bean.setContent(content);
			}
			
//System.out.println("title: "+title);				
//System.out.println("cs_bean.setCount(: "+setcount);
			
//이월표시
			cs_bean.setIwol	(""); //기본은 신규 
							
			if ( !due_dt.equals("")) { // 이월 종료일이 있다면 
				if (AddUtil.parseInt(dt) <= AddUtil.parseInt(due_dt) ) { //이월만료일내에 사용이라면 
					 if ( f_remain > 0  ) {
						f_remain = f_remain - use_cnt; 						
						cs_bean.setIwol	("Y");
					 }
				}        					
			}        	
				
			count = csd.insertCarSche(cs_bean);		
		}
				
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 			= "휴가 신청 등록 안내";
		String cont 		= "["+sender_bean.getUser_nm()+"]님의 휴가신청서 결재를 요청합니다.";
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("21");//연차신청
		doc.setDoc_id	(doc_no);  //doc_id 는 free_time의 doc_no
		doc.setSub		(sub);
		doc.setCont		(cont);
		doc.setEtc		("");
		doc.setUser_nm1	("신청자");
		doc.setUser_nm2	("부서팀장");
		doc.setUser_id1	(user_id);  	//신청자
		doc.setUser_id2	(target_id1);  	//각팀장
		
		if (target_id1.equals("XXXXXX")) {
			doc.setDoc_bit("7");//결재 skip
			doc.setDoc_step("3");//기안			
		} else {
			doc.setDoc_bit("1");//수신단계
			doc.setDoc_step("1");//기안		
		}	
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
				
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
				
		//사용자 정보 조회
		String target_id = "";
				
		target_id = doc.getUser_id2();  //부서팀장
				
		if (!target_id.equals("XXXXXX")) {
					UsersBean target_bean 	= umd.getUsersBean(target_id);
				
			
					String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
				//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
					String m_url = "/fms2/free_time/free_time_frame.jsp";
					String xml_data = "";
					
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			//받는사람
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
			if (sch_chk.equals("9") ) {  //포상휴가 확인  
				xml_data += "    <TARGET>2006007</TARGET>";
			}
		
			//공가에 자가격리이면  - 코로나 한시적 20220-311
			if (sch_chk.equals("7") && title.equals("자가격리") ) {  // 
				xml_data += "    <TARGET>2010002</TARGET>";
				xml_data += "    <TARGET>2006007</TARGET>";
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
			System.out.println("쿨메신저 smartphone(휴가신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no + target_bean.getUser_nm());
		
		}
		
		//업무대체자한테 연차 등록안내
		if(!work_id.equals("")){
			
			UsersBean work_bean 	= umd.getUsersBean(work_id);
			
			sub 	= "업무대체자 등록안내";
			cont 	= "["+sender_bean.getUser_nm()+"]님이 휴가예정 기간 ("+st_dt+"~"+end_dt+")에 "+work_bean.getUser_nm()+"님을 대체근무자로 지정했습니다.";
			
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL></URL>";
			
			//받는사람
			xml_data += "    <TARGET>"+work_bean.getId()+"</TARGET>";
		
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
		}
		
		//부서팀장 / 지점장 연사치 해당부서원에게 메세지로 알려주기.
		if (sender_bean.getId().equals("200002")||sender_bean.getId().equals("2000003")||sender_bean.getId().equals("2002010") ||sender_bean.getId().equals("2002011")||sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006") ||sender_bean.getId().equals("2009006") ||sender_bean.getId().equals("2015001")) {//결재권자가 휴가등록시 담당부서원에게 메세지 보내기.
				if(sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2009006")){
					sub 	= "지점장 연차안내";
					cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() +"이  휴가를 ("+st_dt+"~"+end_dt+") 신청했습니다.";				
				}else{
					sub 	= "부서팀장 연차안내";				
					cont 	= "["+sender_bean.getUser_nm()+"]팀장이 휴가를 ("+st_dt+"~"+end_dt+") 신청했습니다.";		
				}
				
				
				String url 	= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
				String m_url ="/fms2/free_time/free_time_frame.jsp";
				String xml_data = "";
					
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"<BACKIMG>4</BACKIMG>"+
				  				"<MSGTYPE>104</MSGTYPE>"+
				  				"<SUB>"+sub+"</SUB>"+
				  				"<CONT>"+cont+"</CONT>"+
				  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				
					
					if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);
							xml_data += "    <TARGET>"+user.get("ID")+"</TARGET>";
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
					System.out.println("쿨메신저(팀장 휴가 신청 담당부서팀원에게 전달.)-----------------------"+user_bean.getUser_nm() + "  " + doc_no);		
				// 메신져 끝
		 }
		
		if (sender_bean.getId().equals("2004005")) {//김태우과장 휴가신청시 박휘영대리에게 전달
							
			sub 	= "김태우차장 연차안내";
			cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() + "이  휴가를 ("+st_dt+"~"+end_dt+")  신청했습니다.";		
			
						
			String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
			String m_url ="/fms2/free_time/free_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
			
				//받는사람
			xml_data += "    <TARGET>2010003</TARGET>";
			
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
			System.out.println("쿨메신저(김태우과장 휴가신청시 박휘영대리에게 전달.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
		// 메신져 끝
   		} 
		
		if (sender_bean.getId().equals("2010003")) {//박휘영과장 휴가신청시 조선희사원에게 전달
			
			sub 	= "박휘영과장 연차안내";
			cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() + "이 휴가를 ("+st_dt+"~"+end_dt+")  신청했습니다.";		
			
						
			String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
			String m_url ="/fms2/free_time/free_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";		
			
				//받는사람
			xml_data += "    <TARGET>2017009</TARGET>";
			
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
			System.out.println("쿨메신저(김태우과장 휴가신청시 박휘영대리에게 전달.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
		// 메신져 끝
   		} 				
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.location.href = "/smart/main.jsp";
<%	}else{%>
	alert("오류발생!!");
<%	}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>