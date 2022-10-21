<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.cont.*, acar.receive.*, acar.doc_settle.*,  acar.user_mng.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
 	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//기존에 등록되어 있는지 여부	
			
	ClsGuarBean cls = new ClsGuarBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setReq_dt(request.getParameter("req_dt"));  //청구일자
	cls.setN_ven_code(request.getParameter("n_ven_code")==null?"":	request.getParameter("n_ven_code"));// 위임업체코드
	cls.setN_ven_name(request.getParameter("n_ven_name")==null?"":	request.getParameter("n_ven_name")); //위임업체명일
	cls.setReq_amt(request.getParameter("req_amt")==null?0:			AddUtil.parseDigit(request.getParameter("req_amt"))); //청구금액
	cls.setReg_id(user_id); //			

	cls.setGuar_nm(request.getParameter("guar_nm")==null?"":request.getParameter("guar_nm"));
	cls.setGuar_tel(request.getParameter("guar_tel")==null?"":request.getParameter("guar_tel"));
	cls.setDamdang_id(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
			
//	cls.setBank_cd(request.getParameter("bank_code")==null?"":request.getParameter("bank_code"));  
	cls.setBank_nm(request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm"));  //
	cls.setBank_no(request.getParameter("bank_no")==null?"":request.getParameter("bank_no"));
		
	if(!r_db.insertClsGuar(cls))	flag += 1;
	
	//결재요청
	//1. 문서처리전 등록-------------------------------------------------------------------------------------------
	/*
	String sub 		= "보증보험 청구의뢰";
	String cont 	= "[계약번호:"+rent_l_cd+"]  보증보험 청구 의뢰 합니다.";
	
											
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("93");//보증보험 청구 결재요청
	doc.setDoc_id(rent_l_cd);  //
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("기안자");
	doc.setUser_nm2("부서팀장");				
	
	doc.setUser_id1(user_id);  //기안자
	
	String user_id2 = "";
	user_id2 = "000004"; //총무팀장
	
	doc.setUser_id2(user_id2);  //

	doc.setDoc_bit("1");//수신단계
	doc.setDoc_step("1");//기안		
		
	
//=====[doc_settle] insert=====
	flag1 = d_db.insertDocSettle(doc);				
	*/
	
	//문서처리전 등록 끝	

 // 2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
   
	String sub 		= "보증보험 청구 진행 ";
	String cont 	= "[계약번호:"+rent_l_cd+"] 보증보험을 청구 하였습니다.!!!";
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//담당자에게 메세지로 알리기		
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	String target_id = base.getBus_id2(); //관리담당자 
//	target_id = doc.getUser_id2();  //부서팀장
	
	UsersBean target_bean 	= umd.getUsersBean(target_id);

	String url 		= "/fms2/receive/gua_d_frame.jsp";						
	
	String xml_data = "";
	
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"<BACKIMG>4</BACKIMG>"+
  				"<MSGTYPE>104</MSGTYPE>"+
  				"<SUB>"+sub+"</SUB>"+
  				"<CONT>"+cont+"</CONT>"+
  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
  				
	
		//받는사람
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	xml_data += "    <TARGET>2017001</TARGET>";  //보증보험 담당자 
	xml_data += "    <TARGET>2006007</TARGET>";  //보증보험 담당자 
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
	
	System.out.println("쿨메신저(보증보험청구진행)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//보증보험청구테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//보증보험청구테이블에 저장 성공.. %>
	
    alert('처리되었습니다');		
   	top.window.close();		
	fm.s_kd.value = '5';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action='/fms2/receive/gua_d_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
