<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.con_ins_h.*, acar.accid.*, tax.*, acar.bill_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="aih_db" scope="page" class="acar.con_ins_h.AddInsurHDatabase"/>
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
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn = request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String pay_gu = request.getParameter("pay_gu")==null?"":request.getParameter("pay_gu");
	int req_amt = request.getParameter("req_amt")==null?0:Util.parseDigit(request.getParameter("req_amt"));
	int pay_amt = request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	int s_amt 	= request.getParameter("s_amt")==null?0:Util.parseDigit(request.getParameter("s_amt"));
	int v_amt 	= request.getParameter("v_amt")==null?0:Util.parseDigit(request.getParameter("v_amt"));
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	int seq_no = request.getParameter("seq_no")==null?0:Util.parseDigit(request.getParameter("seq_no"));
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();	
	
	
	InsHScdBean cng_ins_hs = aih_db.getScd(m_id, l_cd, c_id, accid_id);
	cng_ins_hs.setReq_amt(req_amt);
	cng_ins_hs.setPay_amt(pay_amt);
	cng_ins_hs.setPay_dt(pay_dt);
	cng_ins_hs.setExt_dt(ext_dt);
	cng_ins_hs.setUpdate_id(user_id);
	
	boolean flag = true;
	int count = 0;
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	String tax_yn = "N";
	String tax_no = "";
	
	if(cmd.equals("p")){//입금처리
		
		MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, seq_no);
		ma_bean.setIns_pay_amt	(pay_amt);	//입금액
		ma_bean.setIns_pay_dt	(pay_dt);	//입금일자
		ma_bean.setIns_req_st	("2");
		ma_bean.setPay_gu		(pay_gu);
		count = as_db.updateMyAccid(ma_bean);
		
		
	}else{//입금취소&청구금액 수정&입금일자 수정
		
		flag = aih_db.updateInsHScd(cng_ins_hs, cmd, pay_yn);
		
	}
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = '/tax/issue_3/issue_3_sc9.jsp';		
		fm.target = 'd_content';			
		fm.submit();
	}
	
	function go_step2(){
		var fm = document.form1;
		fm.action = '/tax/tax_mng/tax_mng_u_m.jsp';		
		fm.target = 'd_content';			
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="rent_mng_id" value="<%=m_id%>">  	
<input type="hidden" name="rent_l_cd" value="<%=l_cd%>">  	
<input type="hidden" name="car_mng_id" value="<%=c_id%>">  	
<input type="hidden" name="client_id" value="<%=cont.get("CLIENT_ID")%>">  	
<input type="hidden" name="site_id" value="<%=cont.get("R_SITE")%>">  	
<input type="hidden" name="accid_id" value="<%=accid_id%>">  	
<input type="hidden" name="seq_no" value="<%=seq_no%>">  	
<input type="hidden" name="pay_amt" value="<%=pay_amt%>">  	
<input type="hidden" name="s_amt" value="<%=s_amt%>">  	
<input type="hidden" name="v_amt" value="<%=v_amt%>">  	
<input type="hidden" name="tax_no" value="<%=tax_no%>">  	
<input type="hidden" name="mode" value="">  	
<input type="hidden" name="go_url" value="/acar/con_ins_h/ins_h_frame_s.jsp">  	
<input type="hidden" name="reg_gu" value="3_9">  	
<input type="hidden" name="sender_id" value="<%=user_id%>">  	
<input type="hidden" name="target_id" value="000093">  	
<input type="hidden" name="coolmsg_sub" value="대차료계산서발행요청">  	
<input type="hidden" name="coolmsg_cont" value="▣ 대차료계산서발행요청 :: <%=cont.get("FIRM_NM")%>, <%=cont.get("CAR_NO")%>, 사고일시:<%=a_bean.getAccid_dt()%>">  	
</form>
<script language='javascript'>
<!--
	function accid_tax_msg(){
		var fm = document.form1;	
		fm.action='/fms2/coolmsg/cool_msg_send.jsp';
		fm.target='i_null';
		fm.submit();
	}

	<%if(tax_yn.equals("Y")){%>
//		accid_tax_msg();
		go_step();
	<%}else if(tax_yn.equals("U")){%>
//		accid_tax_msg();
		go_step2();
	<%}else{%>	
		
		parent.i_in.document.URL='/acar/con_ins_h/ins_h_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>';
	<%}%>		
//-->
</script>
<iframe src="about:blank" name="i_null" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
