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
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
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
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String cons_no		[] 		= request.getParameterValues("cons_no");
	String seq			[] 		= request.getParameterValues("seq");
	
	int    size	 	= request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
	int    tot_amt 	= request.getParameter("tot_amt")==null?0:AddUtil.parseInt(request.getParameter("tot_amt"));
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	
	for(int i = 0 ; i < size ; i++){
		
		
		//1. 탁송의뢰 수정-------------------------------------------------------------------------------------------
		
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no[i], AddUtil.parseInt(seq[i]));
		
		cons.setPay_dt(pay_dt);
		
		//=====[consignment] update=====
		flag1 = cs_db.updateConsignment(cons);
		out.println(i+"번 탁송의뢰 수정<br>");
		
		/*
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		//문서품의
		DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no[i]);
		
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, "5", doc_step);
		out.println("문서처리전 결재<br>");
		*/
	}
	
	
	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String sub 		= "탁송료 지출";
	String cont 	= "[지급금액:"+tot_amt+"] 탁송료를 지출하였습니다.";
	String target_id="";
	
	if(off_id.equals("000620")) target_id = "000047";//명진공업사
	if(off_id.equals("002371")) target_id = "000094";//코리아탁송
	if(off_id.equals("002740")) target_id = "000095";//전국
	if(off_id.equals("004107")) target_id = "000127";//코리아탁송(부산)
	if(off_id.equals("004171")||off_id.equals("007547")) target_id = "000139";//하이카콤대전
	if(off_id.equals("004107")) target_id = "000127";//코리아탁송(부산)
	if(off_id.equals("011790")) target_id = "000328";//퍼스트드라이브
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";
		
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
		
//		flag3 = cm_db.insertCoolMsg(msg);
//		out.println("쿨메신저 수정<br>");
//		System.out.println("쿨메신저(탁송료지출)"+tot_amt+"-----------------------"+target_bean.getUser_nm());
	
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
	fm.submit();
</script>
</body>
</html>