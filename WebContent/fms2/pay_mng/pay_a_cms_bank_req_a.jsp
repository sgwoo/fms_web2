<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	String bc_value01[]			= request.getParameterValues("bc_amt");
	String bc_value02[]		 	= request.getParameterValues("bc_a_deposit_no");
	String bc_value03[]		 	= request.getParameterValues("bc_b_deposit_no");
	String bc_a_deposit_no		= "";
	String bc_b_deposit_no		= "";
	long   bc_amt 				= 0;
	String reqseq_c				= "";
	int    bc_size 				= 0;
	
	String pay_dt 				= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	
	String bc_bank_code  = Long.toString(System.currentTimeMillis());
	
		for(int i=0;i < 15;i++){
			
			bc_amt 			= bc_value01[i]==null?0:AddUtil.parseDigit4(bc_value01[i]);
			bc_a_deposit_no = bc_value02[i]==null?"":bc_value02[i];
			bc_b_deposit_no = bc_value03[i]==null?"":bc_value03[i];
			
			if(bc_amt >0 && !bc_a_deposit_no.equals("")){
				
				bc_size++;
				
				//출금계좌정보
				Hashtable a_acc = ps_db.getDepositma(bc_a_deposit_no);
				//입금계좌정보
				Hashtable b_acc = ps_db.getDepositma(bc_b_deposit_no);
				
				//출금원장
				PayMngBean bc_pay = new PayMngBean();
				
				bc_pay.setReqseq		("");
				bc_pay.setP_way			("5");
				bc_pay.setP_est_dt		(pay_dt);
				bc_pay.setP_est_dt2		(pay_dt);
				bc_pay.setP_req_dt		(pay_dt);
				bc_pay.setA_pay_dt		(pay_dt);
				bc_pay.setReg_st		("A");
				bc_pay.setAmt			(bc_amt);
				bc_pay.setM_amt			(0);
				//입금계좌
				if(!bc_b_deposit_no.equals("")){
					bc_pay.setBank_id		(String.valueOf(b_acc.get("BANK_CODE")));
					bc_pay.setBank_nm		(String.valueOf(b_acc.get("CHECKD_NAME")));
					bc_pay.setBank_no		(bc_b_deposit_no);
					bc_pay.setBank_acc_nm	("(주)아마존카");
				}
				//출금계좌
				bc_pay.setA_bank_id		(String.valueOf(a_acc.get("BANK_CODE")));
				bc_pay.setA_bank_nm		(String.valueOf(a_acc.get("CHECKD_NAME")));
				bc_pay.setA_bank_no		(bc_a_deposit_no);
				bc_pay.setVen_name		("(주)아마존카");
				bc_pay.setOff_nm		("(주)아마존카");
				bc_pay.setBank_code		(bc_bank_code);
				bc_pay.setP_step		("2");
				bc_pay.setReg_id		(user_id);
				
				if(bc_b_deposit_no.equals("")){
					bc_pay.setP_way			("1");
				}
				
				//계좌이체(지출처) 은행코드-code
				if(!bc_b_deposit_no.equals("") && !bc_pay.getBank_nm().equals("") && bc_pay.getP_way().equals("5")){
					Hashtable ht = ps_db.getBankCode("", bc_pay.getBank_nm());
					if(String.valueOf(ht.get("CMS_BK")).equals("null")){
					}else{
						bc_pay.setBank_cms_bk(String.valueOf(ht.get("CMS_BK")));
					}
				}
				//계좌이체(지출처) 은행코드-네오엠
				if(!bc_b_deposit_no.equals("") && !bc_pay.getBank_nm().equals("") && bc_pay.getP_way().equals("5")){
					Hashtable ht = ps_db.getCheckd("A03", bc_pay.getBank_nm());
					if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
					}else{
						bc_pay.setBank_id(String.valueOf(ht.get("CHECKD_CODE")));
					}
				}
				
				//계좌이체(지출처) 은행코드-code
				if(!bc_pay.getA_bank_nm().equals("")){
					Hashtable ht = ps_db.getBankCode("", bc_pay.getA_bank_nm());
					if(String.valueOf(ht.get("CMS_BK")).equals("null")){
					}else{
						bc_pay.setA_bank_cms_bk(String.valueOf(ht.get("CMS_BK")));
					}
				}
				//계좌이체(지출처) 은행코드-네오엠
				if(!bc_pay.getA_bank_nm().equals("")){
					Hashtable ht = ps_db.getCheckd("A03", bc_pay.getA_bank_nm());
					if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
					}else{
						bc_pay.setA_bank_id(String.valueOf(ht.get("CHECKD_CODE")));
					}
				}
				//계좌이체(지출처) 은행코드
				if(bc_pay.getA_bank_nm().equals("신한") && bc_pay.getA_bank_id().equals("")){
					bc_pay.setA_bank_id("260");
				}		
				//계좌이체(지출처) 은행코드
				if(bc_pay.getA_bank_nm().equals("신한") && bc_pay.getA_bank_id().equals("null")){
					bc_pay.setA_bank_id("260");
				}						
				
				
				reqseq_c = pm_db.insertPay(bc_pay);
				
				
				//원장아이템
				bc_pay.setReqseq		(reqseq_c);
				bc_pay.setI_amt			(bc_pay.getAmt());
				bc_pay.setI_s_amt		(bc_pay.getAmt());
				bc_pay.setI_seq			(1);
				bc_pay.setP_gubun		("60");
				bc_pay.setP_gubun_etc	("자금집금");
				bc_pay.setP_st2			("자금집금");
				bc_pay.setP_st3			("계좌이체");
				bc_pay.setR_est_dt		(pay_dt);
				bc_pay.setP_cont		("자금집금("+bc_pay.getA_bank_nm()+""+bc_pay.getA_bank_no()+"->"+bc_pay.getBank_nm()+""+bc_pay.getBank_no()+")");
				bc_pay.setAcct_code		("10300");
				
				if(bc_b_deposit_no.equals("")){
					bc_pay.setP_cont		("현금인출 "+bc_pay.getA_bank_nm()+""+bc_pay.getA_bank_no()+")");
					bc_pay.setP_st3			("현금");
				}
				
				if(!pm_db.insertPayItem(bc_pay)) flag += 1;
				
				if(!bc_pay.getBank_no().equals("")){
					//송금원장
					PayMngActBean bc_act = new PayMngActBean();
					
					bc_act.setActseq		("");
					bc_act.setAct_st		("1");
					bc_act.setAct_dt		(pay_dt);
					bc_act.setAmt			(bc_pay.getAmt());
					bc_act.setOff_nm		("(주)아마존카");
					bc_act.setBank_id		(bc_pay.getBank_id());
					bc_act.setBank_no		(bc_pay.getBank_no());
					bc_act.setBank_nm		(bc_pay.getBank_nm());
					bc_act.setA_bank_id		(bc_pay.getA_bank_id());
					bc_act.setA_bank_nm		(bc_pay.getA_bank_nm());
					bc_act.setA_bank_no		(bc_pay.getA_bank_no());
					bc_act.setBank_cms_bk		(bc_pay.getBank_cms_bk());
					bc_act.setA_bank_cms_bk		(bc_pay.getA_bank_cms_bk());
					bc_act.setAct_bit		("");
					bc_act.setReg_id		(user_id);
					bc_act.setBank_code		(bc_bank_code);
					bc_act.setBank_acc_nm		("(주)아마존카");
					
					if(!pm_db.insertPayAct(bc_act)) flag += 1;
				}
			}
		}
		
	out.println("집금 선택건수="+bc_size+"<br><br>");
	
	DocSettleBean doc = new DocSettleBean();
	
	//2. 문서처리전 등록-------------------------------------------------------------------------------------------
	
	String sub 		= "송금결재";
	String cont 	= "송금결재를 요청합니다.";
	String target_id = "";
	
	doc.setDoc_st	("32");//출금송금
	doc.setDoc_id	(bc_bank_code);
	doc.setSub		(sub);
	doc.setCont		(cont);
	doc.setEtc		("");
	doc.setUser_nm1	("담당자");
	doc.setUser_nm2	("팀장");
	doc.setUser_id1	(user_id);
	doc.setUser_id2	(nm_db.getWorkAuthUser("본사총무팀장"));//총무팀장
	doc.setDoc_bit	("1");
	doc.setDoc_step	("2");
	
	//=====[doc_settle] insert=====
	flag1 = d_db.insertDocSettle(doc);
	
	
	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String url 		= "/fms2/pay_mng/pay_a_frame.jsp";
	String m_url ="/fms2/pay_mng/pay_a_frame.jsp";
	target_id = doc.getUser_id2();//총무팀장
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("")){
		//팀장휴가시 출금담당자가 전결처리
		if(cs_bean.getTitle().equals("오전반휴")){
			//등록시간이 오전(12시전)이라면 대체자
			if(AddUtil.getTimeAM().equals("오전")){
				target_id = nm_db.getWorkAuthUser("출금담당");	
			}								
		}else if(cs_bean.getTitle().equals("오후반휴")){
			//등록시간이 오후(12시이후)라면 대체자
			if(AddUtil.getTimeAM().equals("오후")){				
				target_id = nm_db.getWorkAuthUser("출금담당");	
			}
		}else{//연차
			target_id = nm_db.getWorkAuthUser("출금담당");
		}
			
		
		//출금담당자가 휴가일때 업무대체자가 전결처리
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(nm_db.getWorkAuthUser("출금담당"));
		if(target_id.equals(cs_bean.getUser_id()) && !cs_bean2.getUser_id().equals("")){
		
			if(!cs_bean2.getWork_id().equals("")){
				//출금담당자휴가시 업무대체자가 전결처리
				if(cs_bean2.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자
					if(AddUtil.getTimeAM().equals("오전")){
						target_id = cs_bean2.getWork_id();
					}								
				}else if(cs_bean2.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자
					if(AddUtil.getTimeAM().equals("오후")){				
						target_id = cs_bean2.getWork_id();
					}
				}else{//연차
					target_id = cs_bean2.getWork_id();
				}												
			}
		}
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
	System.out.println("쿨메신저(출금송금결재)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
	%>
	
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">	
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.from_page.value == ''){
			fm.action = 'pay_a_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>