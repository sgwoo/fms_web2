<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	
	out.println("세금계산서 발행하기 3-2단계(전자세금계산서 전송,이메일발송,문자발송)"+"<br><br>");
	
	String tax_no = request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String ebill_st = request.getParameter("ebill_st")==null?"":request.getParameter("ebill_st");
	String flist = request.getParameter("flist")==null?"":request.getParameter("flist");
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String firm_nm 			= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String tax_mon 			= request.getParameter("tax_mon")==null?"":request.getParameter("tax_mon");
	String msg 				= request.getParameter("msg")==null?"":request.getParameter("msg");
	String tax_bigo_t 		= request.getParameter("tax_bigo_t")==null?"":request.getParameter("tax_bigo_t");
	String angt_cng 		= request.getParameter("angt_cng")==null?"N":request.getParameter("angt_cng");
	
	String con_agnt_nm2 		= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");	
	String con_agnt_email2 	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2 	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");
	
	String sendname = "(주)아마존카";
	String sendphone = "02-392-4243";
	
	
	out.println("tax_no     ="+tax_no+"<br>");
	
	int flag = 0;

	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);





	//[5단계] 인포메일러 발송 : d-mail 생성

	if(ebill_st.equals("2") || ebill_st.equals("4")){
	
		//세금계산서 조회
		t_bean.setCon_agnt_nm(con_agnt_nm);
		t_bean.setCon_agnt_dept(con_agnt_dept);
		t_bean.setCon_agnt_title(con_agnt_title);
		t_bean.setCon_agnt_email(con_agnt_email.trim());
		t_bean.setCon_agnt_m_tel(con_agnt_m_tel);
		
		if(angt_cng.equals("Y")){
			if(!IssueDb.updateTax(t_bean, "")) flag += 1;
		}
		
		Hashtable ht = IssueDb.getTaxMailCase("2", "", tax_no, "", "");
		
		//	1. d-mail 등록-------------------------------
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(String.valueOf(ht.get("NAME"))+"님, (주)아마존카 "+String.valueOf(ht.get("TAX_YEAR"))+"년 "+String.valueOf(ht.get("TAX_MON"))+"월 세금계산서입니다.");
		d_bean.setSql				("SSV:"+con_agnt_email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setMailto			("\""+String.valueOf(ht.get("NAME"))+"\"<"+String.valueOf(ht.get("EMAIL")).trim()+">");
		d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(tax_no);
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/tax_bill/index_simple.jsp?gubun=2&tax_no="+tax_no+"&site_id="+String.valueOf(ht.get("SEQ"))+"&client_id="+String.valueOf(ht.get("CLIENT_ID")));
		if(!IssueDb.insertDEmail(d_bean, "", "+6.05")) flag += 1;
		
		if(flag == 0 && ebill_st.equals("2")){
			//2. SMS 등록-------------------------------
			if(!con_agnt_m_tel.equals("")){
				IssueDb.insertsendMail(sendphone, sendname, con_agnt_m_tel, String.valueOf(ht.get("NAME3")), String.valueOf(ht.get("TAX_MON")), "+0.05", msg);
			}
		}
	}
	
	if(ebill_st.equals("5")){
		IssueDb.insertsendMail(sendphone, sendname, con_agnt_m_tel, firm_nm, tax_mon, "", msg);
	}
	
	if(ebill_st.equals("6") || ebill_st.equals("7")){
	
		//세금계산서 조회
		t_bean.setCon_agnt_nm2(con_agnt_nm2);
		t_bean.setCon_agnt_email2(con_agnt_email2.trim());
		t_bean.setCon_agnt_m_tel2(con_agnt_m_tel2);
		
		if(angt_cng.equals("Y")){
			if(!IssueDb.updateTax(t_bean, "")) flag += 1;
		}
		
		Hashtable ht = IssueDb.getTaxMailCase("2", "", tax_no, "", "");
		
		//	1. d-mail 등록-------------------------------
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(String.valueOf(ht.get("NAME"))+"님, (주)아마존카 "+String.valueOf(ht.get("TAX_YEAR"))+"년 "+String.valueOf(ht.get("TAX_MON"))+"월 세금계산서입니다.");
		d_bean.setSql				("SSV:"+con_agnt_email2.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setMailto			("\""+String.valueOf(ht.get("NAME"))+"\"<"+String.valueOf(ht.get("EMAIL")).trim()+">");
		d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(tax_no);
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/tax_bill/index_simple.jsp?gubun=2&tax_no="+tax_no+"&site_id="+String.valueOf(ht.get("SEQ"))+"&client_id="+String.valueOf(ht.get("CLIENT_ID")));
		if(!IssueDb.insertDEmail(d_bean, "", "+6.05")) flag += 1;
		
		if(flag == 0 && ebill_st.equals("6")){
			//2. SMS 등록-------------------------------
			if(!con_agnt_m_tel.equals("")){
				IssueDb.insertsendMail(sendphone, sendname, con_agnt_m_tel2, String.valueOf(ht.get("NAME3")), String.valueOf(ht.get("TAX_MON")), "+0.05", msg);
			}
		}
	}
	
	if(ebill_st.equals("8")){
		IssueDb.insertsendMail(sendphone, sendname, con_agnt_m_tel2, firm_nm, tax_mon, "", msg);
	}	
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		var fm = document.form1;
		<%if(flist.equals("cont")){%>
		fm.action = 'tax_mng_c.jsp';
		<%}else{%>
		fm.action = 'tax_mng_frame.jsp';
		<%}%>
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
<a href="javascript:go_step()">4단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("트러스빌 세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
