<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cms.*,  acar.user_mng.*, acar.coolmsg.*,acar.car_sche.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cms_db" scope="page" class="acar.cms.CmsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String from_page 	=  "/fms2/cms/cms_reg_etc_frame.jsp" ;	
		
	int flag = 0;
	
	boolean flag1 = true;
	boolean flag2 = true;
			
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
			
	// 리스트
	String rent_mng_id[] = request.getParameterValues("rent_mng_id");  //
	String rent_l_cd[] = request.getParameterValues("rent_l_cd");   // 
	String old_cms_bank[]  = request.getParameterValues("old_cms_bank");  //
	String old_cms_acc_no[]  = request.getParameterValues("old_cms_acc_no");
	String reg_cnt[] 	= request.getParameterValues("reg_cnt");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
										
	String cms_bank 			= request.getParameter("cms_bank")==null?"":request.getParameter("cms_bank");
	String cms_acc_no 		= request.getParameter("cms_acc_no")==null?"":request.getParameter("cms_acc_no");
	String cms_dep_nm 		= request.getParameter("cms_dep_nm")==null?"":request.getParameter("cms_dep_nm");
	String cms_dep_ssn 		=  request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn");

	String est_dt = "";
	String l_cd = "";
	String scan_l_cd = "";
				
 // 대여계약이 아닌경우 입금된것 처리 - 대출금. 캐쉬백 등 					
	for(int i=0; i<size; i++){

			est_dt = cms_db.getCmsFeeEst_dt(rent_mng_id[i], rent_l_cd[i]);
			
     	 	CmsCngBean bean = new CmsCngBean();
				
			bean.setRent_mng_id	(rent_mng_id[i]);
			bean.setRent_l_cd	(rent_l_cd[i]);
			bean.setReq_id(user_id);
			bean.setCms_bank	(cms_bank);
			bean.setCms_acc_no	(cms_acc_no);
			bean.setCms_dep_nm	(cms_dep_nm);
			bean.setCms_dep_ssn	(cms_dep_ssn);
			bean.setOld_cms_bank	(old_cms_bank[i]);
			bean.setOld_cms_acc_no	(old_cms_acc_no[i]);
			bean.setEst_dt	(est_dt);
			
			l_cd= rent_l_cd[i];
			if ( reg_cnt[i].equals("2") )   scan_l_cd = rent_l_cd[i];		
						
			if(!cms_db.insertCmsCng(bean))	flag += 1;
																								
   }  //for loop						
			
  // cms 스캔  동기화 호출
    String sync = cms_db.call_sp_lc_rent_scanfile_syn3(scan_l_cd, AddUtil.getDate(4));
  			
	//저장후 입금담당자에게 메세지 발송  - 입금담당자 이관처리후 cms_mng에 해당 정보 update 		
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
	String sub 		= "자동이체 변경 요청 처리 요망";
	String cont 	= "[계약번호:"+l_cd+"]  자동이체 변경을 요청합니다.";	
		
	String url = 	"/fms2/cms/cms_req_frame.jsp";
		
	String target_id = nm_db.getWorkAuthUser("CMS관리");  
			
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
	//xml_data += "    <TARGET>2006007</TARGET>";

	
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
		
	System.out.println("쿨메신저(자동이체 변경 요청)"+l_cd+"---------------------"+target_bean.getUser_nm());				
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//테이블에 저장 실패%>
	alert('등록 오류발생!');

<%	}else{ 			//테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
    fm.action='<%=from_page%>';
   
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>

</body>
</html>

