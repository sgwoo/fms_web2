<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,acar.memo.*, acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.cont.*,acar.client.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");

	String s_cd 		= request.getParameter("s_cd")		==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");		
	String f_page 		= request.getParameter("f_page")	==null?"":request.getParameter("f_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
		
	String scd_rent_st 	= request.getParameter("scd_rent_st")	==null?"":request.getParameter("scd_rent_st");
	String scd_tm 		= request.getParameter("scd_tm")	==null?"":request.getParameter("scd_tm");
	
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String c_firm_nm 	= request.getParameter("c_firm_nm")	==null?"":request.getParameter("c_firm_nm");
	String c_client_nm 	= request.getParameter("c_client_nm")	==null?"":request.getParameter("c_client_nm");
	String est_dt 		= request.getParameter("est_dt")	==null?"":request.getParameter("est_dt");
	
		
	boolean flag3 = true;
	boolean flag4 = true;
	int count = 1;
	int count_cust = 0;
	int count2 = 0;
	String cms_reg_msg = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
		
		
		
	//월렌트연장스케줄 자동이체 관련
	String cms_reg_yn 	= request.getParameter("cms_reg_yn")	==null?"":request.getParameter("cms_reg_yn");
				
	if(rc_bean.getRent_st().equals("12") && cms_reg_yn.equals("Y")){
		
		//자동이체를 위한 cont 빈통 만들기
			
		String rm_rent_mng_id = c_id;
		String rm_rent_l_cd   = "RM00000"+s_cd;
							
				
		//단기대여 대여정보 등록
		RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
		rf_bean.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
		rf_bean.setCms_bank	(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
		rf_bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
		count = rs_db.updateRentFee(rf_bean);
			
			
		ContBaseBean base = a_db.getCont(rm_rent_mng_id, rm_rent_l_cd);
		if(base.getRent_mng_id().equals("")){
			//=====[cont] update=====
			base.setRent_mng_id	(rm_rent_mng_id);
			base.setRent_l_cd	(rm_rent_l_cd);
			base.setCar_st		("4");
			base.setCar_gu		("3");
			base.setUse_yn		("Y");
			base.setCar_mng_id	(c_id);
			base.setClient_id	(rc_bean.getCust_id());
			base.setBrch_id		(rc_bean.getBrch_id());
			base.setRent_dt		(rc_bean.getRent_dt());
			base.setBus_id		(rc_bean.getBus_id());
			base.setBus_id2		(rc_bean.getMng_id());
			base.setMng_id		(rc_bean.getMng_id());
			base = a_db.insertContBaseNew(base);
		}
			
			
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);
			
		//고객정보
		ClientBean client = al_db.getNewClient(base.getClient_id());
			
		cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
		cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
		cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
		cms.setCms_day		("1");
		cms.setCms_etc		(rm_rent_l_cd);
		cms.setCms_tel		(client.getO_tel());
		cms.setCms_m_tel	(client.getM_tel());
		cms.setCms_email	(client.getCon_agnt_email());
		cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")	==null?"":request.getParameter("cms_dep_ssn"));			
		cms.setApp_dt		(AddUtil.getDate());
		
		if(!est_dt.equals("")){
			cms.setCms_day		(AddUtil.replace(est_dt,"-","").substring(6,8));
			cms.setCms_start_dt	(est_dt);
		}
			
		if(cms.getSeq().equals("")){
			cms.setRent_mng_id	(rm_rent_mng_id);
			cms.setRent_l_cd	(rm_rent_l_cd);
			cms.setReg_st		("1");
			cms.setReg_id		(user_id);
			cms.setCms_st		("1");
			//=====[cms_mng] insert=====
			flag3 = a_db.insertContCmsMng(cms);
		}else{
			cms.setUpdate_id	(user_id);
			//=====[cms_mng] update=====
			flag3 = a_db.updateContCmsMng(cms);
		}
		
		//월렌트 연장 1회차 입금예정일
		ScdRentBean   sr_bean = rs_db.getScdRentCase(s_cd, "3");	
			
		//자동이체담당자에게 통보
		String memo_title 	= "월렌트-";
	
		
		memo_title += car_no+" "+c_firm_nm+" "+c_client_nm;		//+" "+AddUtil.getTimeHMS()+ " 입금예정일:" + sr_bean.getEst_dt() 
		
		//이체일자 추가
		if(!est_dt.equals("")){
			memo_title = memo_title + ", 이체예정일 : "+est_dt+" ";
		}
		
		String sub4 	= "월렌트 [수시] CMS 자동이체 신청";
		String cont4 	= "월렌트 [수시] CMS 자동이체 신청("+memo_title+")되었으니 확인하시기 바랍니다.";
		String url4	= "/acar/rent_mng/res_rent_u.jsp?s_cd="+s_cd+"|c_id="+c_id;
						
		UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("CMS관리"));
		
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
		if(!cs_bean4.getUser_id().equals("") && !cs_bean4.getWork_id().equals("")){
			String target_id4 = cs_bean4.getWork_id();
			target_bean4 	= umd.getUsersBean(target_id4);
		}
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String xml_data4 = "";
		xml_data4 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
					 "    <BACKIMG>4</BACKIMG>"+
					 "    <MSGTYPE>104</MSGTYPE>"+
					 "    <SUB>"+sub4+"</SUB>"+
  					 "    <CONT>"+cont4+"</CONT>"+
					 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"</URL>"; 						 
		xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
		xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 					 "    <MSGICON>10</MSGICON>"+
 					 "    <MSGSAVE>1</MSGSAVE>"+
 					 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
 					 "  </ALERTMSG>"+
 					 "</COOLMSG>";
			
		CdAlertBean msg4 = new CdAlertBean();
		msg4.setFlddata(xml_data4);
		msg4.setFldtype("1");
			
		flag4 = cm_db.insertCoolMsg(msg4);
					
	}
		
		
%>
<script language='javascript'>
<%	if(flag3){%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();
		parent.opener.location  ='/acar/rent_mng/res_rent_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
