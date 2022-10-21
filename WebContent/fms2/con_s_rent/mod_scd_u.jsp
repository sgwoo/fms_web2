<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");

	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn 	= request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String tm 	= request.getParameter("tm")==null?"":request.getParameter("tm");	
		
	String est_dt 	= request.getParameter("est_dt")==null?"":request.getParameter("est_dt");	
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	int pay_amt 	= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	
	
	boolean flag = true;
	int count = 1;
	
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	
	ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, rent_st, tm);
	
	if(cmd.equals("p")){//입금
		sr_bean.setPay_dt	(pay_dt);
		sr_bean.setPay_amt	(pay_amt);
	}else if(cmd.equals("u")){//수정
		sr_bean.setEst_dt	(est_dt);
		sr_bean.setPay_dt	(pay_dt);
		sr_bean.setPay_amt	(pay_amt);
	}
	sr_bean.setReg_id(user_id);
	count = rs_db.updateScdRent(sr_bean);


	if(cmd.equals("p") && (sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt()-pay_amt) > 0){//입금처리후 잔액발생->한회차 스케줄 생성
		int j_amt = sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt()-pay_amt;
		sr_bean.setTm		(Integer.toString(AddUtil.parseInt(tm)+1));
		sr_bean.setRent_s_amt	((new Double(j_amt/1.1)).intValue());
		sr_bean.setRent_v_amt	(j_amt-sr_bean.getRent_s_amt());
		sr_bean.setEst_dt	(pay_dt);
		sr_bean.setPay_dt	("");
		sr_bean.setPay_amt	(0);
		count = rs_db.insertScdRent(sr_bean);
	}
%>
<script language='javascript'>
<%	if(count == 0){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.i_in.document.URL='/fms2/con_s_rent/con_s_rent<%=rc_bean.getRent_st()%>_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&s_cd=<%=s_cd%>';
<%	}%>
</script>
