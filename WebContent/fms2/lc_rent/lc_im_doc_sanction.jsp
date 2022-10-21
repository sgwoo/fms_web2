<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.fee.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	int result = 0;
	int flag7 = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	if(doc_bit.equals("d")){	
		flag1 = d_db.deleteDocSettleLcIm(doc_no, doc.getDoc_id());
	}else{
	
	
		//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
		//=====[doc_settle] update=====
	
		String doc_step = "2";
	
		//회계담당자 결재이면 문서 결재 완료
		if(doc_bit.equals("2")) doc_step = "3";
	
	
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
	
	
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
		String sub 		= "임의연장 결재 요청";
		String cont 		= "["+firm_nm+"] 임의연장 결재바랍니다.";
		//String url 		= "/fms2/lc_rent/lc_im_frame.jsp";
		String url 		= "/fms2/lc_rent/lc_im_doc_u.jsp?doc_no="+doc.getDoc_no()+"|rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String target_id = "";
		String m_url ="/fms2/lc_rent/lc_im_frame.jsp";
		//if(doc_bit.equals("2"))	target_id = doc.getUser_id3();
		//if(doc_bit.equals("3"))	target_id = doc.getUser_id1();
	
		target_id = doc.getUser_id1();
	
		if(doc_bit.equals("2")){
			sub 		= "임의연장 처리 완료";
			cont 		= "["+firm_nm+"-"+rent_l_cd+"] 임의연장 처리를 완료하였습니다.";
		
		
			//결재완료 처리시 청구구분을 정상으로 돌린다.
			flag5 = af_db.updateFeeImScdBillYn(doc.getDoc_id());
		
			//연체료 재계산
			boolean flag6 = af_db.calDelayDtPrint(rent_mng_id, rent_l_cd, "", "");
		
			//연체횟수
			int dly_mon = af_db.getFeeScdDlyCnt(rent_mng_id, rent_l_cd);
		
			String scd_stop_yn = "";
		
			if(dly_mon>3){
		
				//세금계산서 발행일시중지관리내역 리스트
				Vector ht = af_db.getFeeScdStopList(rent_mng_id, rent_l_cd);
				int ht_size = ht.size();
				for(int i = 0 ; i < ht_size ; i++){
					FeeScdStopBean fee_scd = (FeeScdStopBean)ht.elementAt(i);
				
					//마지막 발행중지가 살아있다면
					if((i+1)==ht_size){
						if(fee_scd.getCancel_dt().equals("")){
							scd_stop_yn = "Y";
						}
					}
				}
			
				if(scd_stop_yn.equals("")){
					//세금계산서 발행 일시중지 등록 ----------------------------------------------------------------------
					FeeScdStopBean fee_scd = new FeeScdStopBean();
					fee_scd.setRent_mng_id	(rent_mng_id);
					fee_scd.setRent_l_cd	(rent_l_cd);
					fee_scd.setStop_st		("1");					//중지구분
					fee_scd.setStop_s_dt	(AddUtil.getDate());	//중지기간
					fee_scd.setStop_e_dt	("99999999");			//중지기간
					fee_scd.setStop_cau		(dly_mon+"회연체-장기연체고객 자동중지(임의연장)");			//중지사유
					fee_scd.setDoc_id		("");					//최고장번호
					fee_scd.setStop_doc_dt	("");					//내용증명발신일자
					fee_scd.setStop_doc		("");					//최고장번호파일
					fee_scd.setStop_tax_dt	("");					//일괄발행일
					fee_scd.setCancel_dt	("");					//중지해제일
					fee_scd.setReg_id		(user_id);
					fee_scd.setSeq			(String.valueOf(ht_size+1));
					if(!af_db.insertFeeScdStop(fee_scd)) flag7 += 1;
				}
			}
		}
	
	
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
	
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
//		xml_data += "    <TARGET>2008006</TARGET>";
	
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
	
		System.out.println("쿨메신저(임의연장결재)"+firm_nm+", doc_bit="+doc_bit+"-----------------------"+target_bean.getUser_nm());
//		System.out.println(xml_data);

	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='flag1'	 		    value='<%=flag1%>'>     
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'lc_im_frame.jsp';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>