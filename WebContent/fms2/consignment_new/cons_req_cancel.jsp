<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String req_code	= request.getParameter("req_code")==null?"":request.getParameter("req_code");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String br_id2 	= request.getParameter("br_id2")==null?"":request.getParameter("br_id2");
	
	
	Vector vt = cs_db.getConsignmentNotPayOffList(off_id, req_dt, br_id2);
	int vt_size = vt.size();
	
	boolean flag2 = true;
	
	
%>

<%	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
				
		// 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		//문서품의-확인
		DocSettleBean doc = d_db.getDocSettleCommi("2", String.valueOf(ht.get("CONS_NO")));
	
		String doc_bit 	= "7";
		String doc_step = "2";
	
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettleCancel(doc.getDoc_no(), doc_bit, doc_step); //특정비트의 결재일을 없앰				
		
		out.println(String.valueOf(ht.get("CONS_NO"))+"&nbsp;");
		out.println(String.valueOf(ht.get("FROM_DT"))+"&nbsp;");
		out.println(String.valueOf(ht.get("CAR_NO"))+"&nbsp;");
		out.println(String.valueOf(ht.get("FROM_PLACE"))+"&nbsp;");
		out.println(String.valueOf(ht.get("TO_PLACE"))+"&nbsp;");
		out.println("<br>");
			
	}
	

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<script language='javascript'>
<!--
	alert("취소하였습니다.");
//-->
</body>
</html>
