<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
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
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	DocSettleBean doc = new DocSettleBean();
//System.out.println("doc_no: "+doc_no);	
//System.out.println("doc_bit: "+doc_bit);
	if(doc_no.equals("") && doc_bit.equals("1")){
	
		//0. 탁송
		String cons_no		[] 		= request.getParameterValues("cons_no");
		String seq			[] 		= request.getParameterValues("seq");
		
		int    size	 	= request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
		
		String req_code  = Long.toString(System.currentTimeMillis());
		
		for(int i = 0 ; i < size ; i++){
			
			//1. 탁송의뢰 수정-------------------------------------------------------------------------------------------
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no[i], AddUtil.parseInt(seq[i]));
			
			cons.setReq_code(req_code);
			
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignment(cons);
			//out.println(i+"번 탁송의뢰 수정<br>");
		}
		
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= "탁송료청구";
		String cont 	= "[탁송업체: "+off_nm+", 청구일자: "+req_dt+"] 탁송료청구 결재를 요청합니다.";
		String target_id = "";
		
		doc.setDoc_st("3");//탁송료청구
		doc.setDoc_id(req_code);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id2.equals("S3")||br_id2.equals("S4")||br_id2.equals("S5")||br_id2.equals("S6")){
			doc.setUser_nm1("탁송관리자");
			doc.setUser_nm2("총무팀장");
			doc.setUser_id1(user_id);
			doc.setUser_id2("000004");//총무팀장
			doc.setDoc_bit("1");
			doc.setDoc_step("2");
		}else{
			doc.setUser_nm1("탁송관리자");
			doc.setUser_nm2("지점장");
			doc.setUser_id1(user_id);			
			doc.setDoc_bit("1");
			doc.setDoc_step("2");

			if(br_id.equals("B1")){
				doc.setUser_id2("000053");
			}else if(br_id.equals("D1")){
				doc.setUser_id2("000052");
			}else if(br_id.equals("G1")){
				doc.setUser_id2("000054");
			}else if(br_id.equals("J1")){
// 				doc.setUser_id2("000118");
 				doc.setUser_id2("000219");
			}
		}
		

		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		//out.println("문서처리전 등록<br>");
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/consignment_new/cons_req_doc_frame.jsp";
		String m_url  = "/fms2/consignment_new/cons_req_doc_frame.jsp";
//		if(sender_bean.getBr_id().equals("B1"))			target_id = nm_db.getWorkAuthUser("부산출납");
//		else if(sender_bean.getBr_id().equals("D1"))	target_id = nm_db.getWorkAuthUser("대전출납");
//		else											target_id = doc.getUser_id2();
		target_id = doc.getUser_id2();
		
		//출금담당자가 휴가일때 업무대체자가 전결처리
		CarScheBean cs_bean = csd.getCarScheTodayBean(nm_db.getWorkAuthUser("출금담당"));
		if(!cs_bean.getUser_id().equals("")){
			if(!cs_bean.getWork_id().equals("")){
				//출금담당자휴가시 업무대체자가 전결처리
				if(cs_bean.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자
					if(AddUtil.getTimeAM().equals("오전")){
						target_id = cs_bean.getWork_id();
					}								
				}else if(cs_bean.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자
					if(AddUtil.getTimeAM().equals("오후")){				
						target_id = cs_bean.getWork_id();
					}
				}else{//연차
					target_id = cs_bean.getWork_id();
				}												
			}
		}
		
		if(doc.getDoc_step().equals("3")){
			url 		= "/fms2/consignment_new/cons_non_pay_frame.jsp";
			m_url   = "/fms2/consignment_new/cons_non_pay_frame.jsp";
			sub 		= "탁송료 결재 완결";
			cont 		= "[탁송업체: "+off_nm+", 청구일자: "+req_dt+"] 탁송료 지출을 결재 완결하니 출금 집행하세요";
		}
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
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
		System.out.println("쿨메신저(탁송문서결재)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
		//System.out.println("쿨메신저(탁송료청구)-----------------------"+br_id);
	}
	
	if(!doc_no.equals("") && doc_bit.equals("2")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		doc = d_db.getDocSettle(doc_no);
		
		String doc_step = "3";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		out.println("문서처리전 결재<br>");
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/consignment_new/cons_non_pay_frame.jsp";
		String sub 		= "탁송료 결재 완결";
		String cont 	= "[탁송업체: "+off_nm+", 청구일자: "+req_dt+"] 탁송료 지출을 결재 완결하니 출금 집행하세요";
		String target_id = "";
		String m_url  = "/fms2/consignment_new/cons_non_pay_frame.jsp";
//		if(sender_bean.getBr_id().equals("B1"))			target_id = nm_db.getWorkAuthUser("부산보험담당");
		if(sender_bean.getBr_id().equals("B1"))			target_id = nm_db.getWorkAuthUser("부산출납");
		else if(sender_bean.getBr_id().equals("D1"))	target_id = nm_db.getWorkAuthUser("대전출납");
		else											target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
//		target_id = nm_db.getWorkAuthUser("영업수당회계관리자");

		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals("")){
			if(!cs_bean.getWork_id().equals("")){
				//출금담당자휴가시 업무대체자가 전결처리
				if(cs_bean.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자
					if(AddUtil.getTimeAM().equals("오전")){
						target_id = cs_bean.getWork_id();
					}								
				}else if(cs_bean.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자
					if(AddUtil.getTimeAM().equals("오후")){				
						target_id = cs_bean.getWork_id();
					}
				}else{//연차
					target_id = cs_bean.getWork_id();
				}												
			}
		}
		
		//CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		
		if(!cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
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
		//System.out.println("쿨메신저(탁송료결재)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
		//System.out.println("쿨메신저(탁송료결재)-----------------------"+br_id);
	}
	
	
	
	if(msg_send_bit.equals("2")){
	
		doc = d_db.getDocSettle(doc_no);
		
		String sub 		= "탁송료청구";
		String cont 	= "[탁송업체: "+off_nm+", 청구일자: "+req_dt+"] 탁송료청구 결재를 요청합니다.";
		String target_id = "";
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/consignment_new/cons_req_doc_frame.jsp";
		String m_url  = "/fms2/consignment_new/cons_req_doc_frame.jsp";
		UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id2());
		sender_bean 			= umd.getUsersBean(doc.getUser_id1());
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
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
		System.out.println("쿨메신저(탁송문서결재)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
		//System.out.println("쿨메신저(탁송료청구)-----------------------"+br_id);
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('탁송 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
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