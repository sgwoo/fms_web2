<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, tax.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
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
	

	
	
	
	String resend_st 	= request.getParameter("resend_st")	==null?"":request.getParameter("resend_st");
	String am_ax_code  	= request.getParameter("am_ax_code")	==null?"":request.getParameter("am_ax_code");
	String am_good_amt 	= request.getParameter("am_good_amt")	==null?"":request.getParameter("am_good_amt");
	String email 		= request.getParameter("email")		==null?"":request.getParameter("email");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");
	
	
	int count = 0;
	int flag = 0;
	
	
	//결제연동 기발행건이 있는지 확인한다.
	Hashtable ht_ax = rs_db.getAxHubCase(am_ax_code);
	
	

	
	
			//재발급휴대폰번호로 수정한다.			
			count = rs_db.updateAxHub(am_ax_code, ck_acar_id, m_tel);
				
		
			String sendname 	= "(주)아마존카";
			String sendphone 	= "02-392-4243";
			String msg 		= "";
			String title 		= "";
			
			msg = "아마존카 인증번호는 ["+am_ax_code+"]입니다. 월렌트홈페이지에서 결제하시기 바랍니다. -아마존카-";
			
			int i_msglen = AddUtil.lengthb(msg);
		
			String msg_type = "0";
		
			//80이상이면 장문자
			if(i_msglen>80){
				msg_type = "5";
				title = "아마존카 결제인증번호";
			}
						
			IssueDb.insertsendMail_V5_H(sendphone, sendname, m_tel, c_firm_nm, "", "", msg_type, title, msg, "", "", ck_acar_id, "ax_hub");						
		
	
	

%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();
		<%if(from_page.equals("/acar/res_stat/res_rent_u.jsp")){%>
		parent.opener.location	='/acar/res_stat/res_rent_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}else{%>
		parent.opener.location	='/acar/rent_mng/res_rent_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}%>
		
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
