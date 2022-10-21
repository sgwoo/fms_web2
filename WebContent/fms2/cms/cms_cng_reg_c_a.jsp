<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cms.*,  acar.user_mng.*, acar.coolmsg.*,acar.car_sche.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cms_db" scope="page" class="acar.cms.CmsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html><head><title>FMS</title>
</head>
<body>
<%
	//자동이체 등록/수정 처리 페이지
		
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int flag = 0;
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
   int reg_cnt = 0;
	
	//첨부파일이 등록되었는지 확인 - 당일날짜로 확인 
	int cnt9 = cms_db.getCmsCngFileCnt(rent_l_cd, AddUtil.getDate(), "9");  //통장사본 
	int cnt38 = cms_db.getCmsCngFileCnt(rent_l_cd, AddUtil.getDate(), "38"); //동의서   
	
	reg_cnt = cnt9+ cnt38;
	
	String est_dt = cms_db.getCmsFeeEst_dt(rent_mng_id, rent_l_cd);
	
	if ( reg_cnt > 1) {   //통장사본, 동의서 둘다 있어야 함.
	
			//저장후 입금담당자에게 메세지 발송  - 입금담당자 이관처리후 cms_mng에 해당 정보 update 
			
			CmsCngBean bean = new CmsCngBean();
				
			bean.setRent_mng_id	(rent_mng_id);
			bean.setRent_l_cd	(rent_l_cd);
			bean.setReq_id(user_id);
			bean.setCms_bank	(request.getParameter("cms_bank")==null?"":request.getParameter("cms_bank"));
			bean.setCms_acc_no	(request.getParameter("cms_acc_no")==null?"":request.getParameter("cms_acc_no"));
			bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")==null?"":request.getParameter("cms_dep_nm"));
			bean.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
			bean.setOld_cms_bank	(request.getParameter("old_cms_bank")==null?"":request.getParameter("old_cms_bank"));
			bean.setOld_cms_acc_no	(request.getParameter("old_cms_acc_no")==null?"":request.getParameter("old_cms_acc_no"));
			bean.setEst_dt	(est_dt);
					
			if(!cms_db.insertCmsCng(bean))	flag += 1;
					
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
									
			String sub 		= "자동이체 변경 요청 처리 요망";
			String cont 	= "[계약번호:"+rent_l_cd+"]  자동이체 변경을 요청합니다.";	
				
			String url = 	"/fms2/cms/cms_req_frame.jsp";
				
			String target_id = nm_db.getWorkAuthUser("CMS관리");  
		//	String target_id ="000063";
					
			CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id); 
			if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id();   
												
				//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//	xml_data += "    <TARGET>2006007</TARGET>";
		
			
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
				
			System.out.println("쿨메신저(자동이체 변경 요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
					
	}
		
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+	
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&client_id="+client_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&from_page="+from_page+"";
	
%>

<script language='javascript'>

<%	if(cnt9 == 0  ){%>
		alert(' 통장사본을 등록한후 처리하세요!!!!');	
<%	} else if( cnt38 == 0 ){%>
		alert('CMS동의서 등록한후 처리하세요!!!!');			
<%	} else	{ 
		  if (flag != 0){%>
		    	alert("처리되지 않았습니다");
		<%	} else{%>
				alert('처리되었습니다');
			  	top.window.close();
		<%	}%>
<%	}%>
</script>
</body>
</html>
