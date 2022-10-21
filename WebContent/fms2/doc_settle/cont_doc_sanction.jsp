<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*,acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String ch_item 		= request.getParameter("ch_item")==null?"":request.getParameter("ch_item");
	String doc_user_id1 = request.getParameter("doc_user_id1")==null?"":request.getParameter("doc_user_id1");
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	
	//계약조회
	Hashtable cont_info = as_db.getRentCase(m_id, l_cd);
	
	String ins_doc_no 	= request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String doc_no 		= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String cng_dt 		= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 		= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	String ins_doc_st 	= request.getParameter("ins_doc_st")==null?"":request.getParameter("ins_doc_st");
	String reject_cau 	= request.getParameter("reject_cau")==null?"":request.getParameter("reject_cau");
	String doc_bit 		= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");
	String car_st 		= request.getParameter("car_st")	==null?"":request.getParameter("car_st");
	String link_yn 		= request.getParameter("link_yn")	==null?"":request.getParameter("link_yn");
	
	
	
	String value01 = request.getParameter("value01")	==null?"":request.getParameter("value01");
	String value02 = request.getParameter("value02")	==null?"":request.getParameter("value02");
	String value03 = request.getParameter("value03")	==null?"":request.getParameter("value03");
	String value04 = request.getParameter("value04")	==null?"":request.getParameter("value04");
	String value05 = request.getParameter("value05")	==null?"":request.getParameter("value05");	
	String value06 = request.getParameter("value06")	==null?"":request.getParameter("value06");	

	String ch_after 	= "";
	
	if(value03.equals("")) value03 = " ";

	ch_after 	= value01+"||"+value02+"||"+value03+"||"+value04+"||"+value05+"||"+value06;
	
	//보험변경
	InsurChangeBean d_bean = ins_db.getInsChangeDoc(ins_doc_no);
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	InsurChangeBean cha = new InsurChangeBean();
	for(int i = 0 ; i < ins_cha_size ; i++){
		cha = (InsurChangeBean)ins_cha.elementAt(i);
	}
	
	//처리상태
	int flag = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//보험담당자일때 보험변경문서 수정한다.
	if(doc_bit.equals("1") || doc_bit.equals("u")){
		
		//보험변경문서수정-------------------------------------------
		d_bean.setCh_dt					(cng_dt);
		d_bean.setCh_etc				(cng_etc);
		d_bean.setUpdate_id			(user_id);
		if(doc_bit.equals("1")){	
			ins_doc_st = "Y";
		}
		if(d_bean.getIns_doc_st().equals("") && !ins_doc_st.equals("")){
			d_bean.setIns_doc_st		(ins_doc_st);
		}
		if(!ins_db.updateInsChangeDoc(d_bean)) flag += 1;
		
		cha.setCh_after		(ch_after.trim());
		if(!ins_db.updateInsChangeDocList(cha)) flag += 1;

	}
	
	
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";

	if(doc_bit.equals("1")) doc_step = "3";
	
	if(doc_bit.equals("1")){
	
			flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		
	
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------

			String sub 	= "계약변경요청문서 처리완료";
			String cont 	= "["+firm_nm+" "+car_no+"] 계약변경문서를 결재가 완료되었습니다.";
			String target_id= target_id 	= nm_db.getWorkAuthUser("과태료담당자");
			String url 			= "/fms2/doc_settle/cont_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+ins_doc_no;
			String m_url ="/fms2/doc_settle/cont_doc_frame.jsp";
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
			//스케줄변경자 결재완료후 계약변경관리담당자에게 변경요청한다.
			if(ch_item.equals("차량이용자")){
				sub 		= "차량이용자 확인요청서 완료";
				cont		= "["+firm_nm+" "+car_no+"] 차량이용자 확인요청서가 완료되었습니다.";
			}
			
			//쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
			
			if(link_yn.equals("Y")){
				if(ch_item.equals("차량이용자")){
					CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "차량이용자");
					mgr.setMgr_nm		(value01);
					mgr.setMgr_title	(value02);
					mgr.setMgr_tel		(value03);
					mgr.setMgr_m_tel	(value04);
					mgr.setLic_no		(value05);	
					mgr.setMgr_email	(value06.trim());
					//=====[CAR_MGR] update=====
					flag1 = a_db.updateCarMgrNew(mgr);
				}
			}
			
	}
	
	if(doc_bit.equals("d")){
		if(!ins_db.deleteInsChangeDoc(d_bean)) flag += 1;
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>  
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 		value="<%=rent_st%>">   
  <input type='hidden' name="c_id" 			value="<%=c_id%>">
  <input type='hidden' name="ins_st"		value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 		value="<%=doc_no%>">       
  <input type="hidden" name="ins_doc_no"	value="<%=ins_doc_no%>">       
</form>
<script language='javascript'>
<%	if(!flag1){%>
		alert("처리하지 않았습니다");
<%	}else{		%>		
		alert("처리되었습니다");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='cont_doc_u.jsp';
		<%if(doc_bit.equals("d")){%>
		fm.action='cont_doc_frame.jsp';
		<%}%>
		fm.submit();	
<%	}			%>
</script>
</body>
</html>