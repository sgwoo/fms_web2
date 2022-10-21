<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*,  acar.common.*, acar.call.*, acar.util.*, acar.accid.*, acar.coolmsg.*, acar.user_mng.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<% 
	String m_id 	= request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd");		 
	String c_id 	= request.getParameter("c_id");	
	String s_id 	= request.getParameter("s_id");	
	String accid_id 	= request.getParameter("accid_id");	
	
	String p_gubun 	= request.getParameter("p_gubun");
	String gubun 	= request.getParameter("gubun");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int flag1 = 0;
	int flag2 = 0;
	boolean flag21 = true;
	boolean flag22 = true;
	int count = 0;
	
	String answer_rem0 = "";
	String answer_rem1 = "";
	String answer_rem2 = "";
	String answer_rem3 = "";
	String answer_rem4 = "";
	String answer_rem5 = "";
	String answer_rem6 = "";
	String answer_rem7 = "";
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);	
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
			
	//live_poll정보
	Vector vt_live = p_db.getPollTypeAll("3");  //사고정보
 	int vt_live_size = vt_live.size();
 
	//1. 콜센터 정보-----------------------------------------------------------------------------------------------
	//신규 or 수정
	count = p_db.checkAccidentCall(m_id, l_cd, c_id, accid_id);
    
	if (count > 0) {
	 	/* if (!p_db.deleteAccidentCall(m_id, l_cd, c_id, accid_id)) {
	 		flag1 += 1;
	 	} */
	}
  
	String poll_st 	= request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_id 	= request.getParameter("poll_id")==null?"":request.getParameter("poll_id");
	String accid_dt = request.getParameter("accid_dt")==null?"":request.getParameter("accid_dt");
	
	accid_dt = a_bean.getAccid_dt();
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);	
	}
		
	Vector polls = p_db.getSurvey_Play_Q(poll_st, accid_dt);
	int poll_size = polls.size();	
	
 	/* ContCall insert */
	for (int i = 0; i < poll_size; i++) {
	
		String a_value = request.getParameter("answer"+(i+1));
		
		ContCallBean base = new ContCallBean();
	
		base.setPoll_s_id	(AddUtil.parseDigit(request.getParameter("poll_s_id")));
		base.setRent_mng_id	(request.getParameter("m_id"));
		base.setRent_l_cd	(request.getParameter("l_cd"));
		base.setCar_mng_id	(request.getParameter("c_id"));
		base.setAccid_id	(request.getParameter("accid_id"));		
		base.setPoll_id		(AddUtil.parseDigit(request.getParameter("poll_seq"+(i+1))));
		base.setReg_id	( user_id );			
	 
		if (cmd.equals("i")) {
			base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) ));	 
			if (!p_db.insertAccidentCall(base)) flag1+=1;
		} else if (cmd.equals("u")) {
			base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) ));	 
			if (!p_db.updatetAccidentCall(base)) flag1+=1;
		} else if (cmd.equals("no")) {
			base.setAnswer		("N");
			base.setAnswer_rem	("");
			if (!p_db.insertAccidentCall(base)) flag1+=1;
		}
				
		/* System.out.println("poll_st >>> " + poll_st);
		System.out.println("poll_size >>> " + poll_size);
		System.out.println("base.getPoll_id() >>> " + base.getPoll_id());
		System.out.println("base.getPoll_s_id() >>> " + base.getPoll_s_id());
		System.out.println("base.getAnswer() >>> " + base.getAnswer());
		System.out.println("##################################"); */
		
		// 설문조사시 마지막 질문은 아래와 같다. 
		// "고객불만과 관련해서 대표와의 직접통화를 원하시나요?"
		// 마지막 질문에서 "그렇다"를 선택할 경우
		if (cmd.equals("i")) {
			if (base.getPoll_id() == poll_size) {
				if (base.getAnswer().equals("1")) {
					
					UsersBean sender_bean = umd.getUsersBean(user_id);
					CdAlertBean msg1 = new CdAlertBean();
					CdAlertBean msg2 = new CdAlertBean();
					
					String sub = "[대표와의 직접통화] 요망";
					String cont 	= "[대표와의 직접통화] 계약번호  "+l_cd+" 의 고객이 사고콜과 관련하여 대표와의 직접통화를 바랍니다.";
					String url = "/fms2/survey/call_accident_s_frame.jsp";
					
					String xml_data = "";
					String xml_data2 = "";
					
					//if (poll_st.equals("사고처리")) {
					//고객지원팀장
					xml_data = "<COOLMSG>"+
										"<ALERTMSG>"+
						  				"    <BACKIMG>4</BACKIMG>"+
						  				"    <MSGTYPE>104</MSGTYPE>"+
						  				"    <SUB>"+sub+"</SUB>"+
						  				"    <CONT>"+cont+"</CONT>"+
						 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";				 
					xml_data += "     <TARGET>2002010</TARGET>"; //고객지원팀장
					xml_data += "   <TARGET>2000001</TARGET>"; //대표이사 
					xml_data += "     <SENDER>"+sender_bean.getId()+"</SENDER>"+
						  				"    <MSGICON>10</MSGICON>"+
						  				"    <MSGSAVE>1</MSGSAVE>"+
						  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
						  				"    <FLDTYPE>1</FLDTYPE>"+
						  				"</ALERTMSG>"+
						  				"</COOLMSG>";
					
					msg1.setFlddata(xml_data);
					msg1.setFldtype("1");
					
					flag21 = cm_db.insertCoolMsg(msg1);
					
					System.out.println("쿨메신저(콜센타 대표이사 전화요망 )"+ l_cd  +"--------------------- 영업팀장 ");
					System.out.println("쿨메신저(콜센타 대표이사 전화요망 )"+ l_cd  +"--------------------- 대표이사 ");
					//}
				}		
			}
		}		
	}	
		
	//5. 검색---------------------------------------------------------------------------------------------------
	String use_yn	= request.getParameter("use_yn");
	String auth_rw = request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id");
	String s_bank	= request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd");
	String cont_st = request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst");
	
%>
<script language='javascript'>
<%if (flag1 != 0)	 {%>
		alert('에러입니다.\n\n등록되지 않았습니다');
		location='about:blank';
<%} else {%>
		alert("저장되었습니다");
		<%if(cmd.equals("no")){%>
		parent.parent.location = "car_accident_s_frame.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>";
		<%}else{%>
		parent.parent.location='survey_accident_reg_frame.jsp?mode=2&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&p_gubun=<%=p_gubun%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&poll_st=<%=poll_st%>&accid_dt=<%=accid_dt%>';
		<%}%>
<%}%>
</script>
</body>
</html>
