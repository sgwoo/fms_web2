<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.settle_acc.*, acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.ext.*, acar.forfeit_mng.*, acar.con_ins_m.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin="15">
<%
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");	
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String today 		= request.getParameter("today")		==null?"":request.getParameter("today");
					
	String client_id 	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");
	int    seq		= request.getParameter("seq")		==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String page_st 		= request.getParameter("page_st")	==null?"":request.getParameter("page_st");	
	
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String idx 		= request.getParameter("idx")		==null?"":request.getParameter("idx");
	
	
	String doc_no	 	= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");
	
	String bad_cau		= request.getParameter("bad_cau")	==null?"":request.getParameter("bad_cau");
	String bad_yn 		= request.getParameter("bad_yn")	==null?"":request.getParameter("bad_yn");
	String bad_st 		= request.getParameter("bad_st")	==null?"":request.getParameter("bad_st");
	String bad_st2 		= request.getParameter("bad_st2")	==null?"":request.getParameter("bad_st2");
	String reject_cau 	= request.getParameter("reject_cau")	==null?"":request.getParameter("reject_cau");		
	String req_dt 		= request.getParameter("req_dt")	==null?"":request.getParameter("req_dt");		
	String car_call_yn 	= request.getParameter("car_call_yn")	==null?"":request.getParameter("car_call_yn");
	String pol_place	= request.getParameter("pol_place")	==null?"":request.getParameter("pol_place");	//관할 경찰서 id추가	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int count = 0;
	
	String doc_step = "2";
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	
	out.println("doc_no="+doc_no+"<br>");
	
	
	
	//계약정보 등록	
	String vid1[] 		= request.getParameterValues("item_seq");
	String vid2[] 		= request.getParameterValues("rent_mng_id");
	String vid3[] 		= request.getParameterValues("rent_l_cd");
	String vid4[] 		= request.getParameterValues("a_fee_tm");
	String vid5[] 		= request.getParameterValues("fee_tm");
	String vid6[] 		= request.getParameterValues("fee_est_dt");
	String vid7[] 		= request.getParameterValues("dly_mon");
	String vid8[] 		= request.getParameterValues("t_rent_start_dt");
	String vid9[] 		= request.getParameterValues("t_rent_end_dt");
	String vid10[] 		= request.getParameterValues("t_con_mon");
	String vid11[] 		= request.getParameterValues("add_rent_start_dt");
	String vid12[] 		= request.getParameterValues("add_rent_end_dt");
	String vid13[] 		= request.getParameterValues("add_tm");
	String vid14[] 		= request.getParameterValues("credit_doc_id");	
	String vid15[] 		= request.getParameterValues("dly_fee_amt");	
	
	String rent_l_cd_str = "";		//계약번호 담은 변수 생성	
	for(int j=0;j < vid3.length;j++){
		rent_l_cd_str += vid3[j]; 	//계약번호 담기
		rent_l_cd_str += ", ";
	}
	
	if(doc_no.equals("")){
	
		//고객별 고소장접수요청등록리스트
		Vector vt = s_db.getBadComplaintReqDocList(client_id);
		int vt_size = vt.size();
		
		seq = vt_size+1;
		
		//요청내용 및 처리구분 관리
		BadComplaintReqBean bean = new BadComplaintReqBean();
		
		bean.setClient_id	(client_id);
		bean.setSeq		(seq);
		bean.setBad_cau		(bad_cau);		//요청사유
		bean.setReg_id		(user_id);		//등록자
		bean.setPol_place	(pol_place);	//관할 경찰서 추가
		
		flag1 = s_db.insertBadComplaintReq(bean);
						
		for(int j=0;j < vid1.length;j++){				
			//요청내용 및 처리구분 관리
			BadComplaintReqBean item_bean = new BadComplaintReqBean();			
			item_bean.setBad_comp_cd	(client_id+""+String.valueOf(vt_size+1));
			item_bean.setSeq		(AddUtil.parseInt(vid1[j]));
			item_bean.setRent_mng_id	(vid2[j]);
			item_bean.setRent_l_cd		(vid3[j]);
			item_bean.setA_fee_tm		(vid4[j]);
			item_bean.setFee_tm		(vid5[j]);
			item_bean.setFee_est_dt		(vid6[j]);
			item_bean.setDly_mon		(vid7[j]);			
			item_bean.setT_rent_start_dt	(vid8[j]);
			item_bean.setT_rent_end_dt	(vid9[j]);
			item_bean.setT_con_mon		(vid10[j]);
			item_bean.setAdd_rent_start_dt	(vid11[j]==null?"":vid11[j]);
			item_bean.setAdd_rent_end_dt	(vid12[j]==null?"":vid12[j]);
			item_bean.setAdd_tm		(vid13[j]==null?"":vid13[j]);
			item_bean.setCredit_doc_id	(vid14[j]);
			item_bean.setDly_fee_amt	(vid15[j]==null?0:AddUtil.parseDigit(vid15[j]));
			
			flag2 = s_db.insertBadComplaintReqItem(item_bean);
									
			//out.println("item_bean.getBad_comp_cd()="+item_bean.getBad_comp_cd()+"<br>");
			//out.println("item_bean.getSeq()="+item_bean.getSeq()+"<br>");
			//out.println("item_bean.getRent_mng_id()="+item_bean.getRent_mng_id()+"<br>");
			//out.println("item_bean.getRent_l_cd()="+item_bean.getRent_l_cd()+"<br><br><br>");
		}
		
		
		//전자문서등록			
		String sub 	= "고소장접수요청";
		String cont 	= sub;		
		doc.setDoc_st	("49");
		doc.setDoc_id	(client_id+""+String.valueOf(vt_size+1));
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("채권담당자");
		doc.setUser_nm3	("총무팀장");
		doc.setUser_nm4	("고객지원팀장");
		doc.setUser_id1	("");
		doc.setUser_id2	(nm_db.getWorkAuthUser("고소장담당"));
		doc.setUser_id3	(nm_db.getWorkAuthUser("본사총무팀장"));
		doc.setUser_id4	(nm_db.getWorkAuthUser("본사관리팀장")); //202008추가  1->4->2->3 
		doc.setDoc_bit	("1");//수신단계
		doc.setDoc_step	("1");//기안
		
		//=====[doc_settle] insert=====
		flag3 = d_db.insertDocSettle(doc);
								
		DocSettleBean doc2 = d_db.getDocSettleCommi("49", client_id+""+String.valueOf(vt_size+1));
		doc.setDoc_no(doc2.getDoc_no());
		
		doc_no = doc2.getDoc_no();						
	
	}else{
	
		//고소장접수요청
		BadComplaintReqBean bean = s_db.getBadComplaintReq(client_id, seq);
			
		bean.setBad_cau				(bad_cau);		//요청사유
		bean.setPol_place			(pol_place);	//관할 경찰서 추가
		
		if(doc_bit.equals("4")||doc_bit.equals("2") ||doc_bit.equals("u") ){			
			bean.setBad_yn			(bad_yn);		//진행구분	
			if(bad_yn.equals("N")){			
				bean.setReject_cau	(reject_cau);		//미진행사유			
				
			}
		}	
				
		if(doc_bit.equals("3")){			
			bean.setBad_st			(bad_st);		//처리결과
			bean.setReject_cau		(reject_cau);		//기각사유
		}
		
		if(doc_bit.equals("req")){
			bean.setReq_dt			(req_dt);		//접수일자
		}
		
		if(doc_bit.equals("call")){				
			bean.setCar_call_yn		(car_call_yn);		//차량회수여부
		}
		
		if(doc_bit.equals("u")){	
			if(doc.getDoc_bit().equals("1")){	
				bean.setBad_cau			(bad_cau);		//요청사유
			}else if(doc.getDoc_bit().equals("2") || doc.getDoc_bit().equals("4") ){	
				bean.setBad_cau			(bad_cau);		//요청사유
				bean.setBad_yn			(bad_yn);		//진행구분	
				if(bad_yn.equals("N")){			
					bean.setReject_cau	(reject_cau);		//미진행사유
				
				}
			}else if(doc.getDoc_bit().equals("3")){	
				bean.setBad_cau			(bad_cau);		//요청사유
				bean.setBad_st			(bad_st);		//처리결과
				bean.setReject_cau		(reject_cau);		//기각사유
			}
		}
					

		if(doc_bit.equals("d") || doc_bit.equals("a")){
			if(doc_bit.equals("d")){
				//삭제
				flag1 = s_db.deleteBadComplaintReq(bean);	
				
				flag1 = d_db.deleteDocSettle(doc.getDoc_st(), doc.getDoc_id());
			}
			
		}else{					
			flag1 = s_db.updateBadComplaintReq(bean);
		}
		
		
		if(doc_bit.equals("2") || doc_bit.equals("u")){	
			for(int j=0;j < vid1.length;j++){				
				//요청내용 및 처리구분 관리
				BadComplaintReqBean item_bean = new BadComplaintReqBean();			
				item_bean.setBad_comp_cd	(client_id+""+String.valueOf(seq));
				item_bean.setSeq		(AddUtil.parseInt(vid1[j]));
				item_bean.setA_fee_tm		(vid4[j]);
				item_bean.setFee_tm		(vid5[j]);
				item_bean.setFee_est_dt		(vid6[j]);
				item_bean.setDly_mon		(vid7[j]);			
				item_bean.setT_rent_start_dt	(vid8[j]);
				item_bean.setT_rent_end_dt	(vid9[j]);
				item_bean.setT_con_mon		(vid10[j]);
				item_bean.setAdd_rent_start_dt	(vid11[j]==null?"":vid11[j]);
				item_bean.setAdd_rent_end_dt	(vid12[j]==null?"":vid12[j]);
				item_bean.setAdd_tm		(vid13[j]==null?"":vid13[j]);
				item_bean.setCredit_doc_id	(vid14[j]);
				item_bean.setDly_fee_amt	(vid15[j]==null?0:AddUtil.parseDigit(vid15[j]));
							
				flag2 = s_db.updateBadComplaintReqItem(item_bean);
			}							
		}
			
	
		//고객지원팀장  미진행결정
		if(doc_bit.equals("4") && bad_yn.equals("N")){
			doc_step = "3";
			//flag3 = d_db.updateDocSettle(doc_no, "XXXXXX", "3",  "3");	//총무팀장 	
			//flag3 = d_db.updateDocSettle(doc_no, "XXXXXX", "2",  "2");  //고소담당자 	
			
			flag3 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "3",  "3"); //총무팀장 	//결재스킵
			flag3 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");  //고소담당자 					
					
		}
		
		//고소장담당자 미진행결정
		if(doc_bit.equals("2") && bad_yn.equals("N")){
			doc_step = "3";
		//	flag3 = d_db.updateDocSettle(doc_no, "XXXXXX", "3",  "3");	//총무팀장 	
			flag3 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "3",  "3");
		}
	
		if(doc_bit.equals("3")){
			doc_step = "3";
		}			
	
	}
	
	//관할경찰서 정보
	FineGovBean govBean = FineDocDb.getFineGov(pol_place);
	String pol_name = govBean.getGov_nm();
	//out.println("pol_name >>>>>>>>>>>>>" + pol_name);
		
	
	if(doc_bit.equals("1") || doc_bit.equals("2") || doc_bit.equals("3") || doc_bit.equals("4") ){	
		
		flag3 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);  // doc_step = '3'인경우 완료 
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------			
		String sub 		= "고소장접수요청 결재";
		String cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청합니다.";
		String url 		= "/fms2/settle_acc/bad_complaint_doc.jsp?client_id="+client_id+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=1|s_kd=1|t_wd=";
		String target_id 	= doc.getUser_id4();  //2020년 08부터 시행 
	//	String target_id 	= doc.getUser_id2();
		String m_url = "/fms2/settle_acc/bad_complaint_doc_frame.jsp";
		
		if(doc_bit.equals("4")){  //고객지원팀장 
			target_id 	= doc.getUser_id2();
				
			if(bad_yn.equals("N")){//미진행
				sub 		= "고소장접수요청 미진행 통보";
				cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청을 진행하지 않습니다. \n\n미진행사유:"+reject_cau;
				target_id 	= doc.getUser_id1();
			}
		}
		
		if(doc_bit.equals("2")){   //소송담당자 
			target_id 	= doc.getUser_id3();
				
			if(bad_yn.equals("N")){//미진행
				sub 		= "고소장접수요청 미진행 통보";
				cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청을 진행하지 않습니다. \n\n미진행사유:"+reject_cau;
				target_id 	= doc.getUser_id1();
			}
		}

		if(doc_bit.equals("3")){  //총무팀장 
			sub 		= "고소장접수요청 결재완료";
			cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청 팀장 결재하였습니다. \n\n";
			/* cont		+= "[계약번호:"+rent_l_cd_str+"] 고소장 요청 결제 완료 및 "+request.getParameter("pol_name")+"로 발송됩니다.";	//계약번호 및 관할 경찰서 추가 */
			cont		+= "[계약번호:"+rent_l_cd_str+"] 고소장 요청 결제 완료 및 "+pol_name+"로 발송됩니다.";	//계약번호 및 관할 경찰서 추가
			url 		= "/fms2/settle_acc/bad_complaint_doc_frame.jsp?client_id="+client_id+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=2|s_kd=1|t_wd="+request.getParameter("firm_nm");
			target_id 	= doc.getUser_id2();
			
			if(bad_st.equals("3")){//기각
				sub 	= "고소장접수요청 기각";
				cont 	= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청이 기각되었습니다. \n\n기각사유:"+reject_cau;
			}else if(bad_st.equals("2")){//보류
				sub 	= "고소장접수요청 보류";
				cont 	= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청이 보류되었습니다. \n\n보류사유:"+reject_cau;				
			}
		}
			
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
				"<ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
				"    <SUB>"+sub+"</SUB>"+
				"    <CONT>"+cont+"</CONT>"+
				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		if(doc_bit.equals("1")){
			xml_data += "    <TARGET>2006007</TARGET>";
		}
		
		if(doc_bit.equals("3") && bad_st.equals("1")){ //결제 승인시 기안자에게도 쿨메신저 보냄
			
			String target_id2 	= doc.getUser_id1();
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		}		
	
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
			
		flag4 = cm_db.insertCoolMsg(msg);
				
		

	}else if(doc_bit.equals("a")){
		//수정 보류에서 승인/기각으로 변경된 경우
		
		if(doc.getDoc_step().equals("3")){
		
			//고소장접수요청
			BadComplaintReqBean bean = s_db.getBadComplaintReq(client_id, seq);
		
			if(bean.getBad_st().equals("2") && !bad_st2.equals("2")){
		
				bean.setBad_st(bad_st2);		//처리결과
					
				flag1 = s_db.updateBadComplaintReq(bean);
				
				
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------			
				String sub 		= "고소장접수요청 결재완료";
				String cont		= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청 팀장 결재하였습니다. \n\n";
				       /* cont		+= "[계약번호:"+rent_l_cd_str+"] 고소장 요청 결제 완료 및 "+request.getParameter("pol_name")+"로 발송됩니다.";	//계약번호 및 관할 경찰서 추가 */
				       cont		+= "[계약번호:"+rent_l_cd_str+"] 고소장 요청 결제 완료 및 "+pol_name+"로 발송됩니다.";	//계약번호 및 관할 경찰서 추가
				String url 		= "/fms2/settle_acc/bad_complaint_doc_frame.jsp?client_id="+client_id+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=2|s_kd=1|t_wd="+request.getParameter("firm_nm");
				String target_id 	= doc.getUser_id2();
				String m_url ="/fms2/settle_acc/bad_complaint_doc_frame.jsp";
		
				if(bad_st.equals("3")){//기각
					sub 	= "고소장접수요청 기각";
					cont 	= "[ "+request.getParameter("firm_nm")+" ] 고소장접수요청이 기각되었습니다. \n\n기각사유:"+reject_cau;
				}
		
				
				//사용자 정보 조회
				UsersBean target_bean1 	= umd.getUsersBean(doc.getUser_id2());
				UsersBean target_bean2 	= umd.getUsersBean(doc.getUser_id1());
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
						"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				if(!doc.getUser_id2().equals(user_id)){
					xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
				}
				
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
			
				flag4 = cm_db.insertCoolMsg(msg);
				
			}									
		}		
	}			

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name="doc_no" 	value="<%=doc_no%>">		
<input type='hidden' name="seq" 	value="<%=seq%>">
</form>
<script language='javascript'>
<%	if(flag1){	%>	

	alert('처리되었습니다.');
		
	var fm = document.form1;	
	fm.action = 'bad_complaint_doc.jsp';
	
	<%if(doc_bit.equals("d")){%>
	fm.action = 'bad_complaint_doc_frame.jsp';
	<%}%>
	
	fm.target = 'd_content';
	fm.submit();
	
	//parent.self.window.close();
	
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>