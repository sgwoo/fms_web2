<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_reg.*"%>
<%@ page import="acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.cus_samt.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String vid1[] = request.getParameterValues("car_mng_id");
	String vid2[] = request.getParameterValues("serv_id");
				
	int vid_size = 0;
	vid_size = vid1.length;
	
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");   //7:스피드메이트 10:타이어휠타운 , 9:애니카랜드 8:두꺼비카센타 
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
				
	String from_page = "/fms2/service/serv_doc_frame.jsp";
		
	String ch_c_id="";  
	String ch_s_id="";
			
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	
	int result = 0;
	
	String s_kd_nm = "";
	String off_id = ""; //성수자동차 setting ->검사는 별도 사업자가  시행 (007410)  - 일등전국탁송물류 008411
	
	if( s_kd.equals("7")) {
		s_kd_nm = "스피드메이트";
		off_id = "009694"; //ma_partner의 cd_partner code  off_id = 009694 , 995697
	} else if (s_kd.equals("8") ) {
		s_kd_nm = "두꺼비카센타";
		off_id = "000092";
	} else if (s_kd.equals("9") ) {
		s_kd_nm = "애니카랜드";
		off_id = ""; //대표로
	} else if (s_kd.equals("10") ) {
		s_kd_nm = "타이어휠타운";	
		off_id = "008634";
	} else if (s_kd.equals("11") ) {
		s_kd_nm = "본동자동차";
		off_id = "005392";
	} else if (s_kd.equals("14") ) {
		s_kd_nm = "영남제일자동차";
		off_id = "011605";
	} else if (s_kd.equals("15") ) {
		s_kd_nm = "바로차유리";	
		off_id = "011771";
	}
	
	//String ven_code = "";
		
%>

<% //삭제는 jung_dt 가 없음 - 전산팀만 삭제 가능  - 결재 안한 주거래처만 ( excel 등록건, 타이어휠타운, 두꺼비카센타 등 )
	String jung_dt 	= request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");  //정산일자 ( service.set_dt )
	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
	for(int i=0;i < vid_size;i++){
		
		ch_c_id = vid1[i];
		ch_s_id = vid2[i];
				
		result = cr_db.updateServiceSet(ch_c_id, ch_s_id, user_id , jung_dt, req_code);	//정산 setting   
		      
	}	
   
	String s_yy = "";
	String s_mm = "";
	jung_dt = AddUtil.replace(jung_dt,"-","");	 
	s_yy =  jung_dt.substring(0,4);
	s_mm =  jung_dt.substring(4,6);
	
	int labor_amt = request.getParameter("labor_amt")==null?0: AddUtil.parseInt(request.getParameter("labor_amt")); //공임 
	int j_amt = request.getParameter("j_amt")==null?0: AddUtil.parseInt(request.getParameter("j_amt"));	  //부품 
	int dc_amt = request.getParameter("dc_amt")==null?0: AddUtil.parseInt(request.getParameter("dc_amt"));  //dc  - 공급가 (끝전)
	int add_amt = request.getParameter("add_amt")==null?0: AddUtil.parseInt(request.getParameter("add_amt"));  //부가세
	int add_dc_amt = request.getParameter("add_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("add_dc_amt"));  //dc  - 부가세 (끝전)
		
	//mj_jungsan table insert 추가 
	flag6 = cs_db.updateMJ_Jungsan(off_id, s_yy, s_mm, "1", labor_amt, j_amt, 0,  0, dc_amt, add_amt , add_dc_amt,  user_id);
		 
	System.out.println("정비비 정산 - 일괄청구 처리 ->" + s_kd_nm + " : " + jung_dt + ":" + req_code );
	
	String sub  = "";
	String cont = "";
	String target_id = "";
	String doc_no = "";
	
	String user_id2 = "000026";
//	String user_id2 = "000063";  //test
	
	//지점장연차 -> 고객지원팀장, 고객팀장, 영업팀장연차 -> 회계관리자로
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		
	if(!cs_bean2.getWork_id().equals("") ) {	
		user_id2 = "XXXXXX"; //생략	
	}	
	
	if ( !jung_dt.equals("")  ) {
			
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------		
		DocSettleBean doc = new DocSettleBean();
	  		
		sub 	= s_kd_nm + "정비비  지출결의서 결재 요청 ";
		cont 	= "[ 정산일자: "+jung_dt+"] "+ s_kd_nm + " 정비비 지출결의서 결재를 요청합니다.";			//업체명 추가??	
		target_id = "";
			
		doc.setDoc_st("54");// 자동차 정비비 결재 지급 요청
		doc.setDoc_id(req_code);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc(s_kd);
			
		doc.setUser_nm1("담당자");
		doc.setUser_nm2("고객지원팀장");
		doc.setUser_nm3("총무팀장");
		doc.setUser_id1(user_id);
		doc.setUser_id2(user_id2);//관리팀장
		doc.setUser_id3("000004");//총무팀장
			
		doc.setDoc_bit("1");//수신단계
		doc.setDoc_step("1");//기안
		
				
		//=====[doc_settle] insert=====
		flag3 = d_db.insertDocSettle(doc);
	//	doc_no = doc.getDoc_no();
	     
		//고객팀장 결재 skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {		
			  DocSettleBean doc1 = new DocSettleBean();
		      doc1 = d_db.getDocSettleCommi("54", req_code);
			  doc_no = doc1.getDoc_no();
					
			  flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");		
		}
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
		String url 	= "/fms2/service/serv_doc_frame.jsp";
		sub 	= s_kd_nm + " 정비비  지출결의서 결재 요청 ";
		cont 	= "[ 정산일자: "+jung_dt+"] "+ s_kd_nm + " 정비비 지출결의서 결재를 요청합니다.";			//업체명 추가??	
					
		target_id = "";
			
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
				target_id = doc.getUser_id3();
		}	
				
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
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
			
		flag4 = cm_db.insertCoolMsg(msg);
		//out.println("쿨메신저 수정<br>");
		System.out.println("쿨메신저(자동차 정비비 문서결재요청) "+s_kd_nm+ " : " + jung_dt+"-----------------------"+target_bean.getUser_nm());
	}
%>
<script language='javascript'>
<%	if( result  < 1 ){	%>	alert('수정 에러입니다.\n\n확인하십시오');					<%		}	%>			
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
	alert('처리되었습니다');	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
	
	parent.window.close();	
</script>

</body>
</html>
