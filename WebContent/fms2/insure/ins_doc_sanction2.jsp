<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.bill_mng.*, acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String c_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	
	String ins_doc_no 	= request.getParameter("ins_doc_no")	==null?"":request.getParameter("ins_doc_no");
	String doc_no 		= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String cng_dt 		= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 		= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	String ins_doc_st 	= request.getParameter("ins_doc_st")	==null?"":request.getParameter("ins_doc_st");
	String reject_cau 	= request.getParameter("reject_cau")	==null?"":request.getParameter("reject_cau");
	String doc_bit 		= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");
	String car_st 		= request.getParameter("car_st")	==null?"":request.getParameter("car_st");
	int o_fee_amt		= request.getParameter("o_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	int n_fee_amt		= request.getParameter("n_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_fee_amt"));
	int d_fee_amt		= request.getParameter("d_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("d_fee_amt"));
	String cng_s_dt		= request.getParameter("cng_s_dt")	==null?"":request.getParameter("cng_s_dt");
	String cng_e_dt		= request.getParameter("cng_e_dt")	==null?"":request.getParameter("cng_e_dt");
	String r_fee_est_dt		= request.getParameter("r_fee_est_dt")	==null?"":request.getParameter("r_fee_est_dt");
	
	//계약조회
	Hashtable ht_cont = as_db.getRentCase(rent_mng_id, rent_l_cd);	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);	
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//보험정보
	ins = ins_db.getInsCase(c_id, ins_st);
	
	//보험변경
	InsurChangeBean d_bean = ins_db.getInsChangeDoc(ins_doc_no);
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	
	
	//처리상태
	int flag = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	
	System.out.println("====보험변경문서처리====");	
	System.out.println("ins_doc_no="+d_bean.getIns_doc_no());
	System.out.println("d_fee_amt="+d_fee_amt);
	
	
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String sub 		= "보험계약사항 변경요청문서 결재요청";
	String cont 		= "["+firm_nm+"] 자동차보험 사항 변경을 결재 요청합니다.";
	String target_id 	= "";
	String url 		= "/fms2/insure/ins_doc_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+ins_doc_no;
	String m_url = "/fms2/insure/ins_doc_frame.jsp";
	
	
	//보험담당자일때 보험변경문서 수정한다.
	if(doc_bit.equals("3") || doc_bit.equals("u")){
		String ch_amt[] 						= request.getParameterValues("ch_amt");
		String ch_before[] 						= request.getParameterValues("ch_before");
		String ch_after[] 						= request.getParameterValues("ch_after");
		
		
		
		//보험변경문서수정-------------------------------------------
		d_bean.setCh_dt				(cng_dt);
		d_bean.setCh_s_dt			(cng_s_dt);
		d_bean.setCh_e_dt			(cng_e_dt);						
		d_bean.setCh_etc			(cng_etc);
		d_bean.setUpdate_id			(user_id);
		d_bean.setO_fee_amt			(o_fee_amt);
		d_bean.setN_fee_amt			(n_fee_amt);
		d_bean.setD_fee_amt			(d_fee_amt);
		d_bean.setR_fee_est_dt		(r_fee_est_dt);
		
		if(doc_bit.equals("3")){
			if(d_bean.getIns_doc_st().equals("") && !ins_doc_st.equals("")){
				d_bean.setIns_doc_st		(ins_doc_st);
			}
			d_bean.setReject_cau			(reject_cau);
		}
		
		if(!ins_db.updateInsChangeDoc(d_bean)) flag += 1;
		
		
		//승인
		if(doc_bit.equals("3") && ins_doc_st.equals("Y")){
				
			System.out.println("d_bean.getD_fee_amt()="+d_bean.getD_fee_amt());
		
		
			for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean bean = (InsurChangeBean)ins_cha.elementAt(i);
				bean.setCh_amt			(AddUtil.parseDigit(ch_amt[i]));
				bean.setCh_before		(ch_before[i]);
				bean.setCh_after		(ch_after[i]);
				if(!ins_db.updateInsChangeDocList(bean)) flag += 1;
			}
		}	
		
	}
	
	
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";
	
	
	//기각		
	if(ins_doc_st.equals("N")){
		doc_step = "3";
	}
	
	
	if(doc_bit.equals("3")){
		if(d_fee_amt==0 || base.getCar_st().equals("2")) doc_step = "3";
	
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
							
		target_id = doc.getUser_id4();
			
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id();
			
		sub 		= "보험변경에 따른 대여료스케줄 변경요청";
		cont 		= "["+car_no+"] 보험변경이 되어 대여료스케줄 변경을 요청합니다. 월대여료 "+Util.parseDecimal(d_bean.getO_fee_amt())+"원에서 "+Util.parseDecimal(d_bean.getN_fee_amt())+"원으로 변경 (월반영금액 "+Util.parseDecimal(d_bean.getD_fee_amt())+"원)";
		
		url 		= "/fms2/insure/ins_doc_u4.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+ins_doc_no;
		cs_bean2 = csd.getCarScheTodayBean(target_id);
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id();
								
		if(ins_doc_st.equals("N")){
			sub 		= "보험변경요청 기각";
			cont 		= "["+car_no+"] 보험변경요청이 기각됨을 알립니다. 기각사유는 ["+reject_cau+"] 입니다.";
			target_id 	= doc.getUser_id1();
		}

			
		//쿨메신저 알람 등록----------------------------------------------------------------------------------------
					
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
			
		//if(doc_bit.equals("3") && ins_doc_st.equals("N")){
		//	target_bean 	= umd.getUsersBean(doc.getUser_id4());
		//	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//}
			
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
			
		if(!doc_step.equals("3")){
			flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저(보험변경문서결재)"+car_no+"-----------------------"+target_bean.getUser_nm());
		}
	}
	
	if(doc_bit.equals("d")){
		if(!ins_db.deleteInsChangeDoc(d_bean)) flag += 1;
	}
	
	//삭제요청
	if(doc_bit.equals("d_req")){
		sub 		= "보험계약사항 변경요청문서 삭제요청";
		cont 		= "["+firm_nm+" "+car_no+"] 보험변경문서를 삭제요청합니다. 확인하여주십시오.";
		url 		= "/fms2/insure/ins_doc_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+ins_doc_no;
		target_id 	= nm_db.getWorkAuthUser("부산보험담당");		
				
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
	}
	
	//사후처리 결재
	if(doc_bit.equals("5")){
		flag1 = d_db.updateDocSettleAfterCom(doc_no, user_id);
	}
	
	//유효기간 연장
	if(doc_bit.equals("cng_e_dt")){
		d_bean.setCh_e_dt			(cng_e_dt);						
		if(!ins_db.updateInsChangeDoc(d_bean)) flag += 1;
	}
	
	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>  
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 		value="<%=rent_st%>">   
  <input type='hidden' name="c_id" 		value="<%=c_id%>">
  <input type='hidden' name="ins_st"		value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 		value="<%=doc_no%>">       
  <input type="hidden" name="ins_doc_no"	value="<%=ins_doc_no%>">       
</form>
<script language='javascript'>
<%	if(!flag1){%>
		alert("처리하지 않았습니다");
<%	}else{		%>		
		alert("처리되었습니다");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='ins_doc_frame.jsp';
		fm.submit();	
<%	}%>

</script>
</body>
</html>