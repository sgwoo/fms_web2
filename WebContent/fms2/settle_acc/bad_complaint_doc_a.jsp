<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.settle_acc.*, acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.ext.*, acar.forfeit_mng.*, acar.con_ins_m.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin="15">
<%
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");	
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String today 		= request.getParameter("today")		==null?"":request.getParameter("today");
					
	String client_id 	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");
	int    seq		= request.getParameter("seq")		==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String page_st 		= request.getParameter("page_st")	==null?"":request.getParameter("page_st");	
	
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String idx 		= request.getParameter("idx")		==null?"":request.getParameter("idx");
	
	
	String doc_no	 	= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");
	
	String bad_cau		= request.getParameter("bad_cau")	==null?"":request.getParameter("bad_cau");
	String bad_yn 		= request.getParameter("bad_yn")	==null?"":request.getParameter("bad_yn");
	String bad_st 		= request.getParameter("bad_st")	==null?"":request.getParameter("bad_st");
	String bad_st2 		= request.getParameter("bad_st2")	==null?"":request.getParameter("bad_st2");
	String reject_cau 	= request.getParameter("reject_cau")	==null?"":request.getParameter("reject_cau");		
	String req_dt 		= request.getParameter("req_dt")	==null?"":request.getParameter("req_dt");		
	String car_call_yn 	= request.getParameter("car_call_yn")	==null?"":request.getParameter("car_call_yn");		
	String id_cng_req_dt 	= request.getParameter("id_cng_req_dt")	==null?"":request.getParameter("id_cng_req_dt");		
	String id_cng_dt 	= request.getParameter("id_cng_dt")	==null?"":request.getParameter("id_cng_dt");	
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int count = 0;
	
	String doc_step = "2";
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	
	out.println("doc_no="+doc_no+"<br>");
	
	
	
	
	
	//고소장접수요청
	BadComplaintReqBean bean = s_db.getBadComplaintReq(client_id, seq);
			

	if(doc_bit.equals("req")){
		bean.setReq_dt			(req_dt);		//접수일자
	}
		
	if(doc_bit.equals("call")){				
		bean.setCar_call_yn		(car_call_yn);		//차량회수여부
	}
		

	if(doc_bit.equals("id_cng_req")){				
		bean.setId_cng_req_dt		(id_cng_req_dt);	//기간부변경요청
	}

	if(doc_bit.equals("id_cng")){				
		bean.setId_cng_dt		(id_cng_dt);		//기간부변경처리
	}

	flag1 = s_db.updateBadComplaintReq(bean);

		
	
	//영업담당자 채권담당자로 변경	
	if(doc_bit.equals("id_cng")){	
		
		//고객별 계약리스트
		Vector conts = s_db.getContComplaintList(client_id, seq);
		int cont_size = conts.size();	
		
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);	
			
			//cont
			ContBaseBean base = a_db.getCont(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
						
			String new_value = nm_db.getWorkAuthUser("채권관리자");
			
			if(!base.getBus_id2().equals(new_value)){
			
				LcRentCngHBean cng = new LcRentCngHBean();			
				cng.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
				cng.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
				cng.setCng_item		("bus_id2");
				cng.setOld_value	(base.getBus_id2());									
				cng.setNew_value	(new_value);
				cng.setCng_cau		("고소장접수기간부변경");
				cng.setCng_id		(ck_acar_id);
				cng.setRent_st		("");
				cng.setS_amt		(0);
				cng.setV_amt		(0);			
				flag2 = a_db.updateLcRentCngH(cng);			
			
			
				base.setBus_id2		(new_value);			
				//=====[cont] update=====
				flag3 = a_db.updateContBaseNew(base);
			}
			
		}	
	
	}
			
	

	
	
	if(doc_bit.equals("id_cng_req") || doc_bit.equals("id_cng")){	
	
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------			
		String sub 		= "고소장 기간부 담당자 변경 요청";
		String cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장 기간부 담당자 변경 요청합니다.";
		String url 		= "/fms2/settle_acc/bad_complaint_doc.jsp?client_id="+client_id+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=1|s_kd=1|t_wd=";
		String target_id 	= doc.getUser_id2();
		String m_url = "/fms2/settle_acc/bad_complaint_doc_frame.jsp";

		if(doc_bit.equals("id_cng")){
			sub 		= "고소장 기간부 담당자 변경 완료";
			cont 		= "[ "+request.getParameter("firm_nm")+" ] 고소장 기간부 담당자 변경 완료하였습니다.";
			url 		= "/fms2/settle_acc/bad_complaint_doc_frame.jsp?client_id="+client_id+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=2|s_kd=1|t_wd="+request.getParameter("firm_nm");
			target_id 	= doc.getUser_id1();			
		}

			
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
				"<ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
				"    <SUB>"+sub+"</SUB>"+
				"    <CONT>"+cont+"</CONT>"+
				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
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
	
	}			

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name="doc_no" 	value="<%=doc_no%>">		
<input type='hidden' name="seq" 	value="<%=seq%>">		
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'bad_complaint_doc.jsp';
	fm.target = 'd_content';
	fm.submit();
	
	parent.self.window.close();
	
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>