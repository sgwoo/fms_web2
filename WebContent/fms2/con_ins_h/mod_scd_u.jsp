<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.con_ins_h.*, acar.accid.*"%>
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
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	int seq_no = request.getParameter("seq_no")==null?0:Util.parseDigit(request.getParameter("seq_no"));
	String ext_tm = request.getParameter("ext_tm")==null?"":request.getParameter("ext_tm");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn = request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String pay_gu = request.getParameter("pay_gu")==null?"":request.getParameter("pay_gu");
	int req_amt = request.getParameter("req_amt")==null?0:Util.parseDigit(request.getParameter("req_amt")); //청구
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt")); //입금
	
	int s_amt 	= request.getParameter("s_amt")==null?0:Util.parseDigit(request.getParameter("s_amt"));
	int v_amt 	= request.getParameter("v_amt")==null?0:Util.parseDigit(request.getParameter("v_amt"));
	
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	String req_dt = request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
		
	InsHScdBean cng_ins_hs = ae_db.getHScd(m_id, l_cd, c_id, accid_id, seq_no, ext_tm);
	cng_ins_hs.setPay_amt(pay_amt);
	cng_ins_hs.setPay_gu(pay_gu);
	cng_ins_hs.setPay_dt(pay_dt);
	cng_ins_hs.setReq_dt(req_dt);
	cng_ins_hs.setExt_dt(ext_dt);	
	cng_ins_hs.setUpdate_id(user_id);
		
	boolean flag = true;
	int count = 0;
	
	if(cmd.equals("u")){
		flag = ae_db.updateInsHScd(cng_ins_hs);
	} else if(cmd.equals("d")){
		flag = ae_db.deleteHScd(cng_ins_hs);
	}else{
		flag = ae_db.updateInsHScd(cng_ins_hs, cmd, pay_yn);
	}
	
	//연체료 계산
	if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
		flag = ae_db.calDelay(cng_ins_hs.getRent_mng_id(), cng_ins_hs.getRent_l_cd() , "6");
	}	
%>
<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.i_in.document.URL='/fms2/con_ins_h/ins_h_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>';
<%	}%>
</script>

