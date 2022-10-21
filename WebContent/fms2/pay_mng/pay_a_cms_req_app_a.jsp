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
	
	
	String bank_code 	= request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String non_id2 	= request.getParameter("non_id2")==null?"N":request.getParameter("non_id2");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	String doc_step = "3";
	
	if(non_id2.equals("1")){
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettleNon(doc_no, user_id, doc_bit, doc_step);
	}else{
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	}
	out.println("문서처리전 결재<br>");
	
	
	//은행코드 미등록분 정리
	
	
	
	
	
	
	
	if(!from_page.equals("/fms2/pay_mng/pay_m_frame.jsp")){//사후결재에는 필요없다.
	
		String pay_dt 				= request.getParameter("p_pay_dt")==null?"":request.getParameter("p_pay_dt");
		String vid[] 				= request.getParameterValues("reqseq");
		String reqseq 				= "";
		String reqseq_c				= "";
		String m_cau				= "";
		int    m_amt 				= 0;
		
		int vid_size 		= vid.length;
		int bc_size 		= 0;
		
		out.println("출금 선택건수="+vid_size+"<br><br>");
		
		
		//지급처리
		for(int i=0;i < vid_size;i++){
			
			reqseq = vid[i];
			
			//1. 출금원장 수정-------------------------------------------------------------------------------------------
			
			PayMngBean pay 	= pm_db.getPay(reqseq);
			
			//현금지출
			if(pay.getP_way().equals("1")){
				pay.setP_pay_dt		(pay_dt);
				pay.setP_step		("4");
				
			//계좌이체
			}else if(pay.getP_way().equals("5")){
				
				pay.setA_pay_dt			(pay_dt);
				pay.setP_step			("3");//송금요청
				
			//선불카드/후불카드/카드할부
			}else if(pay.getP_way().equals("2")||pay.getP_way().equals("3")||pay.getP_way().equals("7")){
				
				if(!pay.getBank_no().equals("") && !pay.getA_bank_no().equals("")){
					pay.setA_pay_dt			(pay_dt);
					pay.setP_step			("3");//송금요청
				}else{
					pay.setP_pay_dt		(pay_dt);
					pay.setP_step		("4");
				}
				
			//자동이체
			}else if(pay.getP_way().equals("4")){
				
				if(!pay.getBank_no().equals("") && !pay.getA_bank_no().equals("")){
					pay.setA_pay_dt			(pay_dt);
					pay.setP_step			("3");//송금요청
				}else{
					pay.setP_pay_dt		(pay_dt);
					pay.setP_step		("4");
				}
			}
			
			//=====[PAY_LEGDER] update=====
			if(!pm_db.updatePayA(pay)) flag += 1;
			
		}
		
		//=====[PAY_ACT] update=====
		if(!pm_db.updatePayAntApp(bank_code, user_id)) flag += 1; //pay_act 승인자
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/pay_mng/pay_r_frame.jsp";
		String sub 		= "송금결재완료";
		String cont 	= "송금결재완료합니다. 송금처리하십시오.";
		String target_id = doc.getUser_id1();
		String m_url = "/fms2/pay_mng/pay_r_frame.jsp";
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals("")){
			if(!cs_bean.getWork_id().equals("")){
				target_id = cs_bean.getWork_id();
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
	
	}
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