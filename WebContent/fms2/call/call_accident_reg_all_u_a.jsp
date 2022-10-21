<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.call.*, acar.util.*"%>
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
	String c_id 	= request.getParameter("c_id");	
	String s_id 	= request.getParameter("s_id");	
	String accid_id 	= request.getParameter("accid_id");	
	
	String p_gubun 	= request.getParameter("p_gubun");
	String gubun 	= request.getParameter("gubun");
	
	int flag1 = 0;
	int flag2 = 0;
	int count = 0;
	
	String answer_rem0="";
	String answer_rem1="";
	String answer_rem2="";
	String answer_rem3="";
	String answer_rem4="";
	String answer_rem5="";
	String answer_rem6="";
	String answer_rem7="";
		
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
			
     	//live_poll정보
    Vector vt_live		= p_db.getPollTypeAll("3");  //사고정보
 	int vt_live_size = vt_live.size();
 
	//1. 콜센터 정보-----------------------------------------------------------------------------------------------
    //신규 or 수정
    count  = p_db.checkAccidentCall(m_id, l_cd, c_id, accid_id);
    
    if (count > 0 ) {    
    	if(!p_db.deleteAccidentCall(m_id, l_cd, c_id, accid_id)) flag1+=1;    			
    }	    	
  		
   	/* ContCall insert */
	for (int i = 0 ; i < vt_live_size ; i++){		 
		 			 	
			ContCallBean base = new ContCallBean();
	
			base.setRent_mng_id	(request.getParameter("m_id"));
			base.setRent_l_cd	(request.getParameter("l_cd"));
			base.setCar_mng_id	(request.getParameter("c_id"));
			base.setAccid_id		(request.getParameter("accid_id"));		
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
	    	
	    		base.setReg_id	( user_id );
			if(!p_db.insertAccidentCall(base)) flag1+=1;
	}
	
		
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
		parent.location='call_accident_reg_frame.jsp?mode=2&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&p_gubun=<%=p_gubun%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>';
<%	}	%>
</script>
</body>
</html>
