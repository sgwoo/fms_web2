<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.con_ins_m.*"%>
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
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String ext_tm = request.getParameter("ext_tm")==null?"":request.getParameter("ext_tm");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn = request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	int cust_amt = request.getParameter("cust_amt")==null?0:Util.parseDigit(request.getParameter("cust_amt"));
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	String cust_pay_dt = request.getParameter("cust_pay_dt")==null?"":request.getParameter("cust_pay_dt");
	String cust_plan_dt = request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	
	boolean flag = true;
		
	InsMScdBean cng_ins_ms = ae_db.getScd(m_id, l_cd, c_id, accid_id, serv_id, ext_tm);
//	cng_ins_ms.setCust_amt(cust_amt);
	cng_ins_ms.setCust_pay_dt(cust_pay_dt.trim());
	cng_ins_ms.setCust_plan_dt(cust_plan_dt);
	cng_ins_ms.setPay_amt(pay_amt);
	cng_ins_ms.setExt_dt(ext_dt);
	cng_ins_ms.setUpdate_id(user_id);
	
	if(cmd.equals("u")){
		flag = ae_db.updateInsMScd(cng_ins_ms);
//	}else if(cmd.equals("d")){
//		flag = ae_db.updateInsMScd(cng_ins_ms);
	}else{
		flag = ae_db.updateInsMScd(cng_ins_ms, cmd, pay_yn);
	}
	
	
	//연체료 계산
	if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
		flag = ae_db.calDelay(cng_ins_ms.getRent_mng_id(), cng_ins_ms.getRent_l_cd() , "3");
	}	
%>
<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.i_in.document.URL='/fms2/con_ins_m/ins_m_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>';
<%	}%>
</script>
