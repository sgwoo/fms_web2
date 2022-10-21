<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
	int rent_amt = request.getParameter("rent_amt")==null?0:Util.parseDigit(request.getParameter("rent_amt"));
	int rent_s_amt = request.getParameter("rent_s_amt")==null?0:Util.parseDigit(request.getParameter("rent_s_amt"));
	int rent_v_amt = request.getParameter("rent_v_amt")==null?0:Util.parseDigit(request.getParameter("rent_v_amt"));
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	int rest_amt = request.getParameter("rest_amt")==null?0:Util.parseDigit(request.getParameter("rest_amt"));

	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String paid_st = request.getParameter("paid_st")==null?"1":request.getParameter("paid_st");
	String tm = request.getParameter("tm")==null?"":request.getParameter("tm");
	String ext_seq = request.getParameter("ext_seq")==null?"":request.getParameter("ext_seq");
	int c_size = request.getParameter("c_size")==null?0:Util.parseDigit(request.getParameter("c_size"));
	int count = 1;

	//삭제
	if(cmd.equals("d")){
		count = rs_db.deleteScdRentNew(s_cd, rent_st, tm);
	}else{
		ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, rent_st, tm);
		sr_bean.setRent_s_amt(rent_s_amt);
		sr_bean.setRent_v_amt(rent_v_amt);
		sr_bean.setRest_amt(rest_amt);
		sr_bean.setEst_dt(est_dt);
		sr_bean.setExt_seq(ext_seq);
		if(cmd.equals("c")){//입금취소
			sr_bean.setPay_dt("");
			sr_bean.setPay_amt(rent_amt);
			sr_bean.setIncom_dt("");
			sr_bean.setIncom_seq(0);
		}else if(cmd.equals("a")){//스케줄추가
			sr_bean.setRent_s_cd(s_cd);
			sr_bean.setRent_st(rent_st);
			sr_bean.setPaid_st(paid_st);
			
			//sr_bean.setTm(String.valueOf(c_size+1));
			
			String next_tm = rs_db.getScdRentNextTm(s_cd, rent_st);
			sr_bean.setTm(next_tm);
			
			sr_bean.setPaid_st(paid_st);
			sr_bean.setPay_dt(pay_dt);
			sr_bean.setPay_amt(pay_amt);
			
			if(pay_dt.equals("")){
			//	sr_bean.setPay_amt(rent_amt);
			}
		}else{//입금처리&수정
			sr_bean.setRent_st(rent_st);
			sr_bean.setPaid_st(paid_st);
			sr_bean.setPay_dt(pay_dt);
			sr_bean.setPay_amt(pay_amt);
		}
		sr_bean.setReg_id(user_id);
		if(cmd.equals("a")){
			count = rs_db.insertScdRent(sr_bean);
		}else{
			count = rs_db.updateScdRent(sr_bean);
		}
		
		/*
		if(cmd.equals("p") && (rent_s_amt+rent_s_amt-pay_amt) > 0){//입금처리후 잔액발생->한회차 스케줄 생성
			int j_amt = rent_s_amt+rent_s_amt-pay_amt;
			sr_bean.setTm(Integer.toString(AddUtil.parseInt(tm)+1));
			sr_bean.setRent_s_amt((new Double(j_amt/1.1)).intValue());
			sr_bean.setRent_v_amt(j_amt-sr_bean.getRent_s_amt());
			sr_bean.setEst_dt(pay_dt);
			sr_bean.setPay_dt("");
			sr_bean.setPay_amt(0);
			count = rs_db.insertScdRent(sr_bean);
		}
		*/
	}
%>
<script language='javascript'>
<%	if(count == 0){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.document.URL='res_fee_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&from_page=<%=from_page%>';
<%	}%>
</script>