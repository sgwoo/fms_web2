<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.coolmsg.*, acar.doc_settle.*, acar.car_sche.*, acar.consignment.*, card.*, acar.insur.*, acar.pay_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String m_doc_code = request.getParameter("m_doc_code")==null?"":request.getParameter("m_doc_code");
	String seq1 	= request.getParameter("seq1")==null?"":request.getParameter("seq1");
	String seq2 	= request.getParameter("seq2")==null?"":request.getParameter("seq2");
	String buy_user_id = request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String mode   	= request.getParameter("mode")==null?"":request.getParameter("mode");
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
		
	String cng_dt 		= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 		= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	String ins_doc_st 	= request.getParameter("ins_doc_st")==null?"":request.getParameter("ins_doc_st");
	String reject_cau 	= request.getParameter("reject_cau")==null?"":request.getParameter("reject_cau");
	int d_fee_amt		= request.getParameter("d_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("d_fee_amt"));
		
	//변경내용
	InsurChangeBean d_bean = ins_db.getInsChangeDoc(m_doc_code, "3");
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//탁송의뢰
	ConsignmentBean b_cons = new ConsignmentBean();
	
	//카드정보
	CardDocBean cd_bean = new CardDocBean();
	
	//출금원장
	PayMngBean pay 	=  new PayMngBean();
	
	//출금원장
	PayMngBean item	=  new PayMngBean();
		
	//처리상태
	int flag = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
	boolean flag7 = true;
		
	String reg_code  	= Long.toString(System.currentTimeMillis());
		
	//보험담당자일때 보험변경문서 수정한다.
	if(doc_bit.equals("1") || doc_bit.equals("2") || doc_bit.equals("u")){
		
		if(m_doc_code.equals("") && doc_bit.equals("1")){
			//doc insert
			
			d_bean.setIns_doc_no		(reg_code);
			d_bean.setCar_mng_id		("000000");
			d_bean.setIns_st			("0");
			d_bean.setCh_dt				(cng_dt);
			d_bean.setCh_etc			(cng_etc);
			d_bean.setD_fee_amt			(d_fee_amt);
			d_bean.setUpdate_id			(user_id);
			d_bean.setDoc_st			("3");
			if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
			
			//기안자
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String b_cont 	= request.getParameter("cont")==null?"":request.getParameter("cont");
			
			// 
			String sub 	= "비용경감요청문서 품의";
			String cont 	= "["+b_cont+"] 비용경감요청문서를 등록하였으니 결재바랍니다.";
			
			String user_id2 = nm_db.getWorkAuthUser("본사관리팀장");
			
			doc.setDoc_st	("33");
			doc.setDoc_id	(reg_code);
			doc.setSub	(sub);
			doc.setCont	(cont);
			doc.setEtc	(cng_etc);
			doc.setUser_nm1	("기안자");
			doc.setUser_nm2	("고객지원팀장");
			doc.setUser_nm3	("");
			doc.setUser_nm4	("");
			doc.setUser_nm5	("");
			doc.setUser_id1	(user_id);
			doc.setUser_id2	(user_id2);
			doc.setUser_id3	("");
			doc.setDoc_bit	("0");
			doc.setDoc_step	("0");//기안
			
			//=====[doc_settle] insert=====
			flag6 = d_db.insertDocSettle2(doc);
			
			
			doc = d_db.getDocSettleCommi("33", reg_code);
			
			doc_no = doc.getDoc_no();
			
			String doc_step = "1";
			
			flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
			
			m_doc_code = reg_code;
			
			
			//=====[consignment/card_doc/pay] update=====
			flag1 = cs_db.updateM_doc_code(st, seq1, seq2, reg_code);
						
			
			//쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			String url 		= "/fms2/consignment_new/cons_oil_doc_frame.jsp";
			String m_url  = "/fms2/consignment_new/cons_oil_doc_frame.jsp";
			String target_id = doc.getUser_id2();
			
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
			
			flag7 = cm_db.insertCoolMsg(msg);
		
		}else{
			//doc update
			
			//보험변경문서수정-------------------------------------------
			d_bean.setCh_dt				(cng_dt);
			d_bean.setCh_etc			(cng_etc);
			d_bean.setUpdate_id			(user_id);
			if(d_bean.getIns_doc_st().equals("") && !ins_doc_st.equals("")){
				d_bean.setIns_doc_st		(ins_doc_st);
			}
			d_bean.setReject_cau		(reject_cau);
			
			if(!ins_db.updateInsChangeDoc(d_bean)) flag += 1;
						
			//팀장 결재이면 문서 결재 완료
			if(doc_bit.equals("2")){
				String doc_step = "3";
				
				flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
				
				
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
				//기안자
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
				String b_cont 	= request.getParameter("cont")==null?"":request.getParameter("cont");
				
				String sub 		= "비용경감요청 승인";
				String cont 		= "["+b_cont+"] 비용경감요청이 승인되었습니다.";
				
				String target_id 	= doc.getUser_id1();
				String url 			= "/fms2/con_fee/fee_doc_u.jsp?st="+st+"|m_doc_coded="+m_doc_code+"|seq1="+seq1+"|seq2="+seq2+"|buy_user_id="+buy_user_id+"|doc_bit="+doc_bit+"|doc_no="+doc_no;
				String m_url  ="/fms2/con_fee/fee_doc_frame.jsp";
				
				int m_amt = d_bean.getD_fee_amt();
								
				
				if(ins_doc_st.equals("N")){
					sub 		= "비용경감요청 기각";
					cont 		= "["+b_cont+"] 비용경감요청이 기각됨을 알립니다. 기각사유는 ["+reject_cau+"] 입니다.";
					m_amt = 0;
				}
								
				//=====[consignment/card_doc/pay] update=====
				flag1 = cs_db.updateM_amt(st, seq1, seq2, m_amt);
				
				
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
				
				flag7 = cm_db.insertCoolMsg(msg);
				
			}
		}
	}
	
	
	if(doc_bit.equals("d")){
		if(!ins_db.deleteInsChangeDoc3(d_bean)) flag += 1;
	}
%>
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
  <input type='hidden' name='st' 		value='<%=st%>'>
  <input type='hidden' name='m_doc_code' value='<%=m_doc_code%>'>
  <input type='hidden' name='seq1' 		value='<%=seq1%>'>
  <input type='hidden' name='seq2' 		value='<%=seq2%>'>
  <input type='hidden' name='buy_user_id' value='<%=buy_user_id%>'>
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>      
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>            
</form>
<script language='javascript'>
<%	if(!flag1){	%>
		alert("처리하지 않았습니다");
<%	}else{		%>		
		alert("처리되었습니다");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='cons_oil_doc_u.jsp';
		<%if(doc_bit.equals("d")){%>
		fm.action='cons_oil_frame.jsp';
		<%}%>
		fm.submit();	
<%	}			%>
</script>
</body>
</html>