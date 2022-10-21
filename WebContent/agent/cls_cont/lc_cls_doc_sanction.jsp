<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.credit.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String from_page 	= "";
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String reg_id 	= request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");	
	int   fdft_amt2 =   request.getParameter("fdft_amt2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt2"));	 //월렌트인경우 메세지 보내기 체크 
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int result = 0;
	
	String doc_step  = "";
		
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
				
		//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	//출고전해지만
	from_page = "/agent/cls_cont/lc_cls_d_frame.jsp";	
	
		
	//문서 결재여부
	String sub = "";
	String cont = "";
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	if (doc_bit.equals("1")) {  //문서처리전 등록
	
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no + ": rent_l_cd = " + rent_l_cd);
	
		//doc_settle에 저장	
		//2. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		if ( cls_st.equals("8")) {
			sub 		= "매입옵션의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 매입옵션 의뢰 합니다.";
		} else if ( cls_st.equals("7")) {
			sub 		= "출고전해지(신차)의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 출고전해지(신차) 의뢰 합니다.";
		} else if ( cls_st.equals("10")) {
			sub 		= "개시전해지(재리스)의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 개시전해지(재리스) 의뢰 합니다.";	
		} else {
			sub 		= "계약해지정산의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 해지정산 의뢰 합니다.";		
		}	
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("11");//해지정산의뢰 (중도해지, 계약만료, 매입옵션, 출고전해지(신차))
		doc.setDoc_id(rent_l_cd);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("기안자");
		doc.setUser_nm2("고객지원팀장");
		doc.setUser_nm3("회계담당자"); //채권업무도 같이 처리 - 황효심 :20090922
		doc.setUser_nm4("채권담당자");  //사용 - 20091201
		doc.setUser_nm5("총무팀장");
		
		doc.setUser_id1(reg_id);
		
		String user_id2 = "";
		String user_id3 = "";
		String user_id4 = "";
		String user_id5 = "";
			
		doc.setDoc_bit("1");//수신1단계
		doc.setDoc_step("1");//기안		
	
		user_id2 = "000026";//팀장 000006   부산:000053 대전:000052
		user_id3 = nm_db.getWorkAuthUser("해지관리자"); 	
		
		user_id4 = nm_db.getWorkAuthUser("채권관리자"); 	
		user_id5 =  "000004";   // nm_db.getWorkAuthUser("본사총무팀장");  // 총무팀장:000004 영업팀장:000005

				
		//출고전해지(신차), 개시전해지(재리스)		 --에이전트 생략 
		if ( cls_st.equals("7") ) {
			doc.setUser_nm2("영업팀장");
			user_id2 = "000028"; 	
		} else if ( cls_st.equals("10") ) {
				doc.setUser_nm2("고객지원팀장");
				user_id2 = "000026"; 		
		}	
			    	  	
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		CarScheBean cs_bean5 = csd.getCarScheTodayBean(user_id5);
			
		//지점장연차 -> 고객지원팀장, 고객팀장, 영업팀장연차 -> 회계관리자로 		
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("8") ) {
			if(!cs_bean2.getWork_id().equals("") ) {
			   if ( user_id2.equals("000052")  || user_id2.equals("000053") ) {
					user_id2 = "000026";
				} else {
					user_id2 = "XXXXXX"; //생략
				}	
			}		
		}
		
		
		if ( cls_st.equals("7") || cls_st.equals("10") ) {
			if(!cs_bean2.getWork_id().equals("")) user_id2 = "XXXXXX"; //생략
		}
	
		if(!cs_bean3.getWork_id().equals("")) user_id3 =  cs_bean3.getWork_id();    // cs_bean3.getWork_id();
		if(!cs_bean4.getWork_id().equals("")) user_id4 = cs_bean4.getWork_id(); //채권관리자
	//	if(!cs_bean5.getWork_id().equals("")) user_id5 = cs_bean5.getWork_id(); //총무팀장
		if(!cs_bean5.getWork_id().equals("")) user_id5 = "000048"; //총무팀장	
	
	
		if ( cls_st.equals("7")  ||  cls_st.equals("10") ) {
			  user_id5 = "XXXXXX"; 	 //생략	
			  if (!user_id2.equals("XXXXXX") ){ //생략건이 아니면 
				  if ( fdft_amt2   == 0 ) {  //정산금이 없다면  총무팀장으로 
				    	user_id3 = "XXXXXX"; 	 //생략	
				    //	user_id5 = "XXXXXX"; 	 //생략	
				  }	 
			  }		  
			}  	
		
		    	
		doc.setUser_id2(user_id2);//팀장/지점장
		doc.setUser_id3(user_id3);//회계관리자
		doc.setUser_id4(user_id4);//채권관리자
		doc.setUser_id5(user_id5);//총무팀장
					 				
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
				
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		//에이전트가 팀장에게는 메신저로 보낼수 있음.	
		UsersBean sender_bean 	= umd.getUsersBean(reg_id);
		
			//사용자 정보 조회
		String target_id = "";
		   
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
			target_id = doc.getUser_id3();
		}	
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
	//	String url 		= "/agent/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		String url 		= "/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		
			
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
	//	xml_data += "    <TARGET>2006007</TARGET>";  //에이젠트 출고전해지인경우 
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
					
		//sender&target이 같은 경우는 메세지 안감.
		if(!target_bean.getId().equals(sender_bean.getId())){
			
			flag2 = cm_db.insertCoolMsg(msg);			
		
			 if ( cls_st.equals("7")) {
				System.out.println("쿨메신저(출고전해지(신차) 의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
			} else if ( cls_st.equals("10")) {
				System.out.println("쿨메신저(개시전해지(재리스) 의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());					
			} else {
				System.out.println("쿨메신저(해지정산의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			}	
			
		}			
	
	   
		//계약해지의뢰수정
		flag3 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "1", reg_id);  //계약해지의뢰 
		
		//팀장 결재 skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {
			doc = d_db.getDocSettleCommi("11", rent_l_cd);
			doc_no = doc.getDoc_no();
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");
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
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='mode'	 			value='<%=mode%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action ='<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>