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
	
	String answer_dt = "";
	
	String answer_rem0="";
	String answer_rem1="";
	String answer_rem2="";
	String answer_rem3="";
	String answer_rem4="";
	String answer_rem5="";
	String answer_rem6="";
	String answer_rem7="";
	String answer_rem8="";
	
	
	
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
 	int vt_live_size = vt_live.size();
 

	//1. 콜센터 정보-----------------------------------------------------------------------------------------------
    //신규 or 수정
    count  = p_db.checkContCall(m_id, l_cd);
    
    if (count > 0 ) {
   	answer_dt =  p_db.getAnswerDate(m_id, l_cd);
    	if(!p_db.deleteContCall(m_id, l_cd)) flag1+=1;    			
    }	
      		
   	/* ContCall insert */
	for (int i = 0 ; i < vt_live_size ; i++){
		 		 			 	
			ContCallBean base = new ContCallBean();
	
			base.setRent_mng_id	(request.getParameter("m_id"));
			base.setRent_l_cd	(request.getParameter("l_cd"));
			base.setPoll_id		(AddUtil.parseDigit(request.getParameter("poll_id" + i)));
			base.setAnswer		(request.getParameter("answer"+ i));
		
			answer_rem0= request.getParameter("answer_rem0" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem0" + i));  
			answer_rem1= request.getParameter("answer_rem1" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem1" + i));
			answer_rem2= request.getParameter("answer_rem2" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem2" + i));
			answer_rem3= request.getParameter("answer_rem3" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem3" + i));
			answer_rem4= request.getParameter("answer_rem4" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem4" + i));
			answer_rem5= request.getParameter("answer_rem5" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem5" + i));
			answer_rem6= request.getParameter("answer_rem6" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem6" + i));
			answer_rem7= request.getParameter("answer_rem7" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem7" + i));
		
			if ( request.getParameter("answer" + i).equals("1") )
				base.setAnswer_rem	( answer_rem0 );
			if ( request.getParameter("answer" + i).equals("2") )
				base.setAnswer_rem	( answer_rem1 );
			if ( request.getParameter("answer" + i).equals("3") )
				base.setAnswer_rem	( answer_rem2 );		
			if ( request.getParameter("answer" + i).equals("4") )
				base.setAnswer_rem	( answer_rem3 );
			if ( request.getParameter("answer" + i).equals("5") )
				base.setAnswer_rem	( answer_rem4 );
			if ( request.getParameter("answer" + i).equals("6") )
				base.setAnswer_rem	( answer_rem5 );		
			if ( request.getParameter("answer" + i).equals("7") )
				base.setAnswer_rem	( answer_rem6 );
			if ( request.getParameter("answer" + i).equals("8") )
				base.setAnswer_rem	( answer_rem7 );
	  	
	  		answer_rem8= request.getParameter("answer_rem8" + i)==null?"":AddUtil.ChangeBr(request.getParameter("answer_rem8" + i));
	  		if ( request.getParameter("answer" + i).equals("9") )
				base.setAnswer_rem	( answer_rem8 );
				
	  		base.setReg_id(user_id);	
	    	
			if(!p_db.insertContCall(base, answer_dt)) flag1+=1;
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
%>
<script language='javascript'>
<%	if(flag1 != 0)	{	%>
		alert('에러입니다.\n\n등록되지 않았습니다');
		location='about:blank';
<%	}else{	%>
		alert("수정되었습니다");
		parent.location='call_reg_frame.jsp?mode=2&m_id=<%=m_id%>&l_cd=<%=l_cd%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>';
<%	}	%>
</script>
</body>
</html>
