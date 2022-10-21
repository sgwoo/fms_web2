<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.call.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<% 
	String m_id 	= request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd");		 
	String gubun 	= request.getParameter("gubun");
	int flag1 = 0;
	int flag2 = 0;
	int count = 0;
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String answer_dt = "";
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//계약:고객관련
	ContBaseBean base1 		= a_db.getContBaseAll(m_id, l_cd);
	String rent_st = base1.getRent_st();
	String bus_st = base1.getBus_st();  //6:기존업체
	
	if (rent_st.equals("2"))
		rent_st = "5";
	else if (rent_st.equals("7"))	
		rent_st = "6";
	
	if (rent_st.equals("6") &&	bus_st.equals("6"))
			rent_st = "8";   // 재리스 기존업체
	
			
     	//live_poll정보
    Vector vt_live		= p_db.getPollAll(rent_st, "A", "A");
 //	Vector vt_live		= p_db.getPollAll();
 	int vt_live_size = vt_live.size();
 

	//1. 콜센터 정보-----------------------------------------------------------------------------------------------
    //신규 or 수정
    count  = p_db.checkContCall(m_id, l_cd);
    
    if (count > 0 ) {
   	answer_dt =  p_db.getAnswerDate(m_id, l_cd);
   // 	if(!p_db.deleteContCall(m_id, l_cd)) flag1+=1;    			
    }	

	String poll_st 	= request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_id 	= request.getParameter("poll_id")==null?"":request.getParameter("poll_id");
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");

	Vector polls = p_db.getSurvey_Play_Q(poll_st, cls_dt);
	int poll_size = polls.size();
	
   	/* ContCall insert */
	for (int i = 0 ; i < poll_size ; i++){
	
	String a_value 	= request.getParameter("answer"+(i+1));
	
			ContCallBean base = new ContCallBean();
	
			base.setPoll_s_id	(AddUtil.parseDigit(request.getParameter("poll_s_id")));
			base.setRent_mng_id	(request.getParameter("m_id"));
			base.setRent_l_cd	(request.getParameter("l_cd"));
			base.setPoll_id		(AddUtil.parseDigit(request.getParameter("poll_seq"+(i+1))));
			
	  		base.setReg_id(user_id);	

		if(cmd.equals("i")){
			base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) ));
			if(!p_db.insertContCall(base, answer_dt)) flag1+=1;
		}else if(cmd.equals("u")){
			base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) ));
			if(!p_db.updateCont_Call(base, answer_dt)) flag1+=1;
		}else if(cmd.equals("no")){
			base.setAnswer		("N");
			base.setAnswer_rem	("");
			if(!p_db.insertContCall(base, answer_dt)) flag1+=1;
		}
		
	}
	
	if(!p_db.updateContCallYes(m_id, l_cd)) flag1+=1;
		
	//5. 검색---------------------------------------------------------------------------------------------------

	String use_yn 	= request.getParameter("use_yn");
	String auth_rw 	= request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id");
	String s_bank	= request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>
<script language='javascript'>
<%	if(flag1 != 0)	{	%>
		alert('에러입니다.\n\n등록되지 않았습니다');
		location='about:blank';
<%	}else{	%>
		alert("저장되었습니다");
		<%if(cmd.equals("no")){%>
			parent.parent.location = "rent_cond_rm_frame.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>";
		<%}else{%>
			parent.parent.location='survey_rm_reg_frame.jsp?mode=2&m_id=<%=m_id%>&l_cd=<%=l_cd%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&poll_st=<%=poll_st%>&from_page=<%=from_page%>';
		<%}%>
<%	}	%>
</script>
</body>
</html>
