<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.common.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*, acar.doc_settle.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%	
	
	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
		
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차대상자
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title 	= request.getParameter("title1")==null?"":request.getParameter("title1");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String sch_chk 	= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String sch_kd 	= request.getParameter("sch_kd")==null?"":request.getParameter("sch_kd");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String sch_st 	= "";
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String target_id1 	= "";

	int count = 0;
	float f_remain = 0;
	
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
	Vector users = c_db.getUserList(sender_bean.getDept_id(), "", "SCH_PRV","Y"); 
	int user_size = users.size();
	
	// 20181228 류길선과장 요청
	// 신달수, 김은철, 김홍찬, 김욱, 강주원, 김우석, 박찬웅, 류선, 윤영탁, 제인학, 박영규 님은 본사 소속이 아닐경우 총무팀장님 결재
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
			
		}else if(sender_bean.getDept_id().equals("0010")) {//광주지점 은 류선 , 류선 연차시 총무팀장
			/* if(sender_bean.getUser_id().equals("000118")){
				target_id1 = "000052";
			}else{
				target_id1 = "000118";
			} */
			target_id1 = "000219"; //류선
					
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
					
	if(cmd.equals("i")){
		
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
						"<CONT>"+cont2+"</CONT>"+
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
			
			ft_bean.setUser_id		(user_id);
			ft_bean.setStart_date	(st_dt);
			ft_bean.setEnd_date		(end_dt);
			ft_bean.setTitle		(title);
			ft_bean.setContent		(content);
			ft_bean.setReg_dt		(reg_dt); 
			ft_bean.setSch_kd		("2");
			ft_bean.setSch_st		(sch_st);
			ft_bean.setSch_chk		(sch_chk);
			ft_bean.setWork_id		(work_id);
		
			
			if (target_id1.equals("XXXXXX")) {
				ft_bean.setCm_check("Y");	//팀장연차시	
			}
				
		   if (  nm_db.getWorkAuthUser("외부개발자",user_id)   ) {   //개발자는 결재없이 
		   			ft_bean.setCm_check("Y");	//팀장연차시	
			}
			
			doc_no = fsd.InsertFree(ft_bean);  //doc_no는 free_time의 doc_no	
			
			
			//포상휴가인 경우 ps_box에 해당 정보 갱신 -20190515
			if (sch_chk.equals("9") ) {
				//
			 int t_cnt = fsd.tour_update(user_id, st_dt, end_dt );
				
			}
				
			int use_days = 0;
			use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));						
			String dt = "";
			String ov_yn = "";
			
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
				
				if(!dt.equals("20171002")){ //2017-10-02는 임시공휴일로 연차처리한다.
					String c_sysdate = "";
					c_sysdate = af_db.checkSunday(dt);
					if(!c_sysdate.equals(dt))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
						continue;
					
					c_sysdate = af_db.checkHday(dt);
					if(!c_sysdate.equals(dt))	/* 휴일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
						continue;
				}
				
				String setcount = "";
				if(title.equals("오전반차") || title.equals("오전반휴") ){				
					setcount = "B1";	
					use_cnt = AddUtil.parseFloat("0.5");
				}else if(title.equals("오후반차") || title.equals("오후반휴")){
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
				cs_bean.setUser_id		(user_id);
				cs_bean.setTitle		(title);
				cs_bean.setContent		(content);
				cs_bean.setSch_kd		("2");
				cs_bean.setSch_st		(sch_st);
				cs_bean.setSch_chk		(sch_chk);
				cs_bean.setWork_id		(work_id);
				cs_bean.setDoc_no		(doc_no);
				cs_bean.setCount		(setcount);
				
				if (target_id1.equals("XXXXXX")) {
					cs_bean.setGj_ck("Y");  //팀장연차시 결재 skip
				} else {
					cs_bean.setGj_ck("N");  //결재전
				}
				
				if(title.equals("오전반차") || title.equals("오전반휴")){			
					cs_bean.setContent(title);
				}else if(title.equals("오후반차") || title.equals("오후반휴")){
					cs_bean.setContent(title);
				}
								
				//이월표시
				cs_bean.setIwol	(""); //기본은 신규 
								
				if ( !due_dt.equals("")) { // 이월 종료일이 있다면 
					if (AddUtil.parseInt(dt) <= AddUtil.parseInt(due_dt) ) { //이월만료일내에 사용이라면 
						 if ( f_remain > 0  ) {
							f_remain = f_remain - use_cnt; 	//0.5 -1 
							 if ( f_remain >= 0  ) {
								cs_bean.setIwol	("Y");
							 }
						 }
					}        					
				}        	
				
				count = csd.insertCarSche(cs_bean);			
			}	 
					
			//1. 문서처리전 등록-------------------------------------------------------------------------------------------
			
			String sub 		= "휴가 신청 등록 안내";
			String cont 	= "["+sender_bean.getUser_nm()+"] 님의 휴가신청서 결재를 요청합니다.";			
															
			DocSettleBean doc = new DocSettleBean();
			doc.setDoc_st("21");//휴가신청
			doc.setDoc_id(doc_no);  //doc_id 는 free_time의 doc_no
			doc.setSub(sub);
			doc.setCont(cont);
			doc.setEtc("");
			doc.setUser_nm1("신청자");
			doc.setUser_nm2("부서팀장");				
			
			doc.setUser_id1(user_id);  //신청자
			doc.setUser_id2(target_id1);  //각팀장	
	
			if (target_id1.equals("XXXXXX")) {
				doc.setDoc_bit("7");//결재 skip
				doc.setDoc_step("3");//기안			
			} else {
				doc.setDoc_bit("1");//수신단계
				doc.setDoc_step("1");//기안		
			}			
			
			//=====[doc_settle] insert=====
			flag1 = d_db.insertDocSettle(doc);				
				
			//문서처리전 등록 끝				
		
			//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
				
			//사용자 정보 조회
			String target_id = "";
				
			target_id = doc.getUser_id2();  //부서팀장
				
			if (!target_id.equals("XXXXXX")) {
					UsersBean target_bean 	= umd.getUsersBean(target_id);
			
					String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
					String m_url 	= "/fms2/free_time/free_time_frame.jsp";
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
								
					System.out.println("쿨메신저(휴가신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no + " " +target_bean.getUser_nm());		
					
					// 메신져 끝				
				
				//부서팀장 결재 패스해도, 총무팀장에게 통보 
				//출산휴가 및 휴직인 경우 총무팀장, 병가도 총무팀장에 통보, 결재는 부서장
				/*
				if ( sch_chk.equals("4") ||  sch_chk.equals("8")||  sch_chk.equals("5")||  sch_chk.equals("9") ) {
				
						xml_data =  "<COOLMSG>"+
								"<ALERTMSG>"+
								"<BACKIMG>4</BACKIMG>"+
								"<MSGTYPE>104</MSGTYPE>"+
								"<SUB>"+sub+"</SUB>"+
								"<CONT>"+cont+"</CONT>"+
								"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				
						
						String sender_id = doc.getUser_id1();			 			
						UsersBean sender_bean2 	= umd.getUsersBean(sender_id);
						
						UsersBean target_bean2 	= umd.getUsersBean("000004");
												
						//받는사람
						xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					
						//보낸사람
						xml_data += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+	
									"    <MSGICON>10</MSGICON>"+
									"    <MSGSAVE>1</MSGSAVE>"+
									"    <LEAVEDMSG>1</LEAVEDMSG>"+
									"    <FLDTYPE>1</FLDTYPE>"+
									"  </ALERTMSG>"+
									"</COOLMSG>";
					
						CdAlertBean msg1 = new CdAlertBean();
						msg1.setFlddata(xml_data);
						msg1.setFldtype("1");
					
						flag6 = cm_db.insertCoolMsg(msg1);
					
						System.out.println("(휴가신청 결과 안내) 출산/병가/휴직/포상----------------------- "+sender_bean2.getUser_nm() + "->" +target_bean2.getUser_nm() + ":" + doc_no);		
										
				}*/ 		
		
		   }
			
			//업무대체자한테 연차 등록안내
			if(!work_id.equals("")){
				
				UsersBean work_bean 	= umd.getUsersBean(work_id);
				
				sub 	= "업무대체자 등록안내";
				cont 	= "["+sender_bean.getUser_nm()+"]님이  휴가예정 기간 ("+st_dt+"~"+end_dt+")에 "+work_bean.getUser_nm()+"님을 대체근무자로 지정했습니다.";
				
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
						
		   if (sender_bean.getId().equals("2000002")||sender_bean.getId().equals("2000003")||sender_bean.getId().equals("2002010") ||sender_bean.getId().equals("2002011")||sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2013011")||sender_bean.getId().equals("2015001")) {//결재권자가 휴가등록시 담당부서원에게 메세지 보내기.
				if(sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005") ||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2013011") ){
					sub 	= "지점장 연차안내";
					cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() +"이  휴가를 ("+st_dt+"~"+end_dt+") 신청했습니다.";			
				}else{
					sub 	= "부서팀장 연차안내";
					cont 	= "["+sender_bean.getUser_nm()+"]팀장이 휴가를 ("+st_dt+"~"+end_dt+") 신청했습니다.";		
				}
												
				//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
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
					//xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					
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
					System.out.println("쿨메신저(팀장 휴가 신청 담당부서팀원에게 전달.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
				// 메신져 끝
		   }
		   
		if (sender_bean.getId().equals("2004005")) {//김태우차장 휴가신청시 박휘영과장에게 전달
	
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
					System.out.println("쿨메신저(김태우차장 휴가신청시 박휘영과장에게 전달.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
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
		// 메신져 끝
       } 		
					
	}else if(cmd.equals("u")){	
			
			ft_bean.setUser_id		(user_id);
			ft_bean.setDoc_no		(doc_no);
			ft_bean.setStart_date	(st_dt);
			ft_bean.setEnd_date		(end_dt);
			ft_bean.setTitle		(title);
			ft_bean.setContent		(content);
			ft_bean.setReg_dt		(reg_dt); 
			ft_bean.setSch_kd		("2");
			ft_bean.setSch_st		(sch_st);
			ft_bean.setSch_chk		(sch_chk);
			ft_bean.setWork_id		(work_id);

			count = fsd.UpdateFree(ft_bean);			
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
		fm.action = "./free_time_frame.jsp";
		fm.target = "d_content";
		
		<%if(go_url.equals("homework_sh.jsp")){%>
		<%}else{%>
		fm.submit();
		<%}%>
	}

	function go_parent_list(){
		var fm = document.form1;
		fm.action = "./free_time_frame.jsp";
		fm.target='d_content';
		<%if(go_url.equals("homework_sh.jsp")){%>
		<%}else{%>
		fm.submit();
		<%}%>
	}

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='start_date' value='<%=st_dt%>'>
<input type='hidden' name='end_date' value='<%=end_dt%>'>
<input type='hidden' name='title' value='<%=title%>'>
<input type='hidden' name='content' value='<%=content%>'>
<input type='hidden' name='sch_kd' value='<%=sch_kd%>'>
<input type='hidden' name='sch_st' value='<%=sch_st%>'>
<input type='hidden' name='sch_chk' value='<%=sch_chk%>'>
<input type='hidden' name='work_id' value='<%=work_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<% if(cmd.equals("i")){	
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
