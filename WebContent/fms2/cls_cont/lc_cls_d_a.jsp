<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*,  acar.coolmsg.* , acar.insur.*, acar.car_sche.*,  acar.offls_sui.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	int flag = 0;	
	boolean flag2 = true;
	
	String from_page 	= "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
			//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}	

	//해지의뢰삭제 - 결재요청전 담당자 기안문서 또는 관리팀장(지점장)
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_tax"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_sub"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_over"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "car_credit"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "car_reco"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //선수금정산
	if(!r_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_car_exam"))	flag += 1;  //사업장 조사
	if(!r_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_car_gur"))	flag += 1;  //사업장 조사 //보증인
	if(!ac_db.deleteDocSettleCls(rent_l_cd))	flag += 1; //기안문서
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_add"))	flag += 1; //기안문서
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_detail"))	flag += 1; //기안문서
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_more"))	flag += 1; //기안문서
		
	//실제 해지된건 삭제인 경우 - cls_cont , scd_ext (정산금). scd_dly(연체료) , fine(과태료), scd_ext(면책금)   확인하여 처리할 것 , - 해지시 정산되어짐.
			
		//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	String sub = "";
	String cont = "";
	
	//보험해지 사전 통보관련 재안내.	
			//출고전해지가 아닌 경우만 	
	if ( cls_st.equals("7") || cls_st.equals("10")    ) {
		
	} else {
		
			//고객이 피보험자인 경우 && 21세미만인 경우  20160901-해지건 보험안내 전체대상으로 적용 ;
		// 해지완료 시점이 아닌 결재요청시점에 보험담당자에게 전달 
			String ins_st = ai_db.getInsSt(base.getCar_mng_id());
			InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
			Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
			
			//20170207 매각이나 매입옵션일 경우에는 명의이전일 등록 안되어 있으면  문구 바꾸기
			String msgGubun = "계약해지";
			if( cls_st.equals("6") || cls_st.equals("8") ){
				//명의이전일 찾기
				SuiBean sui = sui_db.getSui(base.getCar_mng_id());
				if(sui.getMigr_dt().equals("")){
					if( cls_st.equals("6")  ){ msgGubun = "매각" ; }
					if( cls_st.equals("8")  ){ msgGubun = "매입옵션" ; }
				}
			}
	
			UsersBean sender_bean 	= umd.getUsersBean("999999");
									
			sub 		= "계약해지 결재진행 중 삭제건  보험 확인 요망";
			cont 	=  msgGubun+" ["+ ins_info.get("CAR_NO") + ","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");
					
			String url 		= "/acar/ins_mng/ins_s_frame.jsp"; 
				
			String 			target_id = "";
			target_id = nm_db.getWorkAuthUser("대전보험담당");  //보험 관리자		000070->000193	
			
			CarScheBean cs_bean02 = csd.getCarScheTodayBean(target_id);  	
				
			if(!cs_bean02.getWork_id().equals("")) target_id = cs_bean02.getWork_id();
						
				//사용자 정보 조회
			UsersBean target_bean1 	= umd.getUsersBean(target_id);
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
				
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
	//		CdAlertBean msg1 = new CdAlertBean();
	//		msg1.setFlddata(xml_data);
	//		msg1.setFldtype("1");
				
	//		flag2 = cm_db.insertCoolMsg(msg1);
	//		System.out.println(cont);	
			System.out.println("쿨메신저(해지결재중 삭제요청 보험관리)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+target_bean1.getUser_nm());		
	}			
		
	
//cls_cont는 별도로..... 

   //메세지 삭제 -  cview.cd_message , cview.cd_alert  
    if ( cls_st.equals("8") || cls_st.equals("1")  || cls_st.equals("2")  ) {
	    if (cls_st.equals("8") ) {
	   		cont 	= " [계약번호:"+rent_l_cd+"] 매입옵션 결재요청 합니다.";	 
	    } else if ( cls_st.equals("1")  || cls_st.equals("2") ) {
		   cont 	= " [계약번호:"+rent_l_cd+"] 해지정산 결재요청 합니다.";	 
	    }
	    flag2 = cm_db.deleteCdMessage(cont);
	    System.out.println("쿨메신저(해지결재중 삭제요청 메세지삭제)"+ cont +"---------------------");	
    } 

    //매입옵션 진행 중 삭제인 경우  - 
     if ( cls_st.equals("8") && !cls.getTerm_yn().equals("0") ) {
    	     	 
    	 	Hashtable ht1 = ac_db.getClsInfo(rent_mng_id, rent_l_cd);
    	     		
    		UsersBean sender_bean 	= umd.getUsersBean(cls.getReg_id());
			
			sub 	= "매입옵션 결재진행 중 담당자 취소요청건  확인 요망";
		
			cont 	= "[계약번호:"+rent_l_cd+"] 매입일: "+ cls.getCls_dt() + ", 차량번호 : " + ht1.get("CAR_NO")+ ", 상호: " + ht1.get("FIRM_NM") + " 매입옵션 진행중 담당자가  취소요청을 의뢰하였으니  확인하세요..";	
			
			String url = 	"/fms2/cls_cont/lc_cls_off_d_frame.jsp";
				
			String 		target_id = "";
			target_id = nm_db.getWorkAuthUser("매입옵션관리자");  //000197
												
				//사용자 정보 조회
			UsersBean target_bean1 	= umd.getUsersBean(target_id);
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
				
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
				
			flag2 = cm_db.insertCoolMsg(msg1);	
			System.out.println("쿨메신저(해지결재중 매입옵션 취소요청 )"+ rent_l_cd +", 차량번호 : " + ht1.get("CAR_NO")+ " ---------------------"+target_bean1.getUser_nm());	    		     		 
     }		 
    
     // 결재중 삭제시 기안자에게 메세지 보내기  - 
     if (  !cls.getTerm_yn().equals("0") ) {
    	     	 
    	 	Hashtable ht2 = ac_db.getClsInfo(rent_mng_id, rent_l_cd);
    	   
    	 	UsersBean sender_bean 	= umd.getUsersBean("999999");
    				
			sub 	= " 결재진행 중 삭제 안내";
		
			cont 	= "[계약번호:"+rent_l_cd+"] 해지일: "+ cls.getCls_dt() + ", 차량번호 : " + ht2.get("CAR_NO")+ ", 상호: " + ht2.get("FIRM_NM") + " 결재  진행중  삭제하였으니  확인하세요..";	
			
			String url =  "";
			if (cls_st.equals("8")){
				url = 	"/fms2/cls_cont/lc_cls_off_d_frame.jsp";
			} else {
				url = 	"/fms2/cls_cont/lc_cls_d_frame.jsp";
			}
				
				//사용자 정보 조회
			UsersBean target_bean1 	= umd.getUsersBean(cls.getReg_id());			
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
				
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
				
			flag2 = cm_db.insertCoolMsg(msg1);	
			System.out.println("쿨메신저(해지결재중 삭제 확인요청 )"+ rent_l_cd +", 차량번호 : " + ht2.get("CAR_NO")+ " ---------------------"+target_bean1.getUser_nm());	    		     		 
     }		 
    
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 삭제 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 삭제 성공.. %>
	
    alert('처리되었습니다');
   	fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
