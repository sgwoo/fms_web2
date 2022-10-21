<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.ext.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cls_tm = request.getParameter("cls_tm")==null?"":request.getParameter("cls_tm");
	String vat_st = request.getParameter("vat_st")==null?"":request.getParameter("vat_st");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn = request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	int cls_s_amt = request.getParameter("cls_s_amt")==null?0:Util.parseDigit(request.getParameter("cls_s_amt"));
	int cls_v_amt = request.getParameter("cls_v_amt")==null?0:Util.parseDigit(request.getParameter("cls_v_amt"));
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	String cls_est_dt = request.getParameter("cls_est_dt")==null?"":request.getParameter("cls_est_dt");
	String ht_rent_seq = request.getParameter("ht_rent_seq")==null?"":request.getParameter("ht_rent_seq");
	
	boolean flag = true;
	
	ExtScdBean cng_cls = ae_db.getScd(m_id, l_cd, cls_tm);
	cng_cls.setExt_pay_amt(pay_amt);
	cng_cls.setExt_s_amt(cls_s_amt);
	cng_cls.setExt_v_amt(cls_v_amt);
	cng_cls.setExt_pay_dt(pay_dt);
	cng_cls.setExt_est_dt(cls_est_dt);
	cng_cls.setExt_dt(ext_dt);
	cng_cls.setUpdate_id(user_id);
	
	if(cmd.equals("u")){
		flag = ae_db.updateClsScd(cng_cls);
	}else{
		flag = ae_db.updateClsScd(cng_cls, cmd, pay_yn, vat_st);
	}
	
	// 입금 취소면 하위 생성된 스케쥴 삭제
	if(cmd.equals("c")){
		flag = ae_db.dropExtScd(m_id, l_cd, ht_rent_seq, String.valueOf(Integer.parseInt(cls_tm)+1));
	}	
	
	//연체료 계산
	if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
		flag = ae_db.calDelay(cng_cls.getRent_mng_id(), cng_cls.getRent_l_cd() , "4");
	}	
%>
<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.i_in.document.URL='/fms2/con_cls/cls_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>';
<%	}%>
</script>

