<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase 		nm_db 	= MaMenuDatabase.getInstance();
	
	out.println("세금계산서 발행하기 3단계"+"<br><br>");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":AddUtil.replace(request.getParameter("tax_out_dt"),"-","");//세금일자
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String mail_auto_yn = request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//메일발행방식	
	
	out.println("reg_st  ="+reg_st+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");
	out.println("tax_out_dt="+tax_out_dt+"<br>");
	out.println("reg_code="+reg_code+"<br><br>");
	
	int flag = 0;
	
	if(nm_db.getWorkAuthUser("전산팀",user_id)) user_id = nm_db.getWorkAuthUser("세금계산서담당자");


	
	
	
	//청구서 메일발송 (web작업)-----------------------------------------------------------
	
	
	Vector vt = IssueDb.getCP_TaxEbillItemMail(reg_code);
	int vt_size = vt.size();
	
	int m_flag = 0;
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject				(String.valueOf(ht.get("RECCONAME"))+"님, (주)아마존카 "+String.valueOf(ht.get("TAX_YEAR"))+"년 "+String.valueOf(ht.get("TAX_MON"))+"월 장기대여료 거래명세서입니다.");
		d_bean.setSql					("SSV:"+String.valueOf(ht.get("AGNT_EMAIL")).trim());
		d_bean.setReject_slist_idx		(0);
		d_bean.setBlock_group_idx		(0);
		d_bean.setMailfrom				("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setMailto				("\""+String.valueOf(ht.get("RECCONAME"))+"\"<"+String.valueOf(ht.get("AGNT_EMAIL")).trim()+">");
		d_bean.setReplyto				("\"아마존카\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto				("\"아마존카\"<return@amazoncar.co.kr>");
		d_bean.setHtml					(1);
		d_bean.setEncoding				(0);
		d_bean.setCharset				("euc-kr");
		d_bean.setDuration_set			(1);
		d_bean.setClick_set				(0);
		d_bean.setSite_set				(0);
		d_bean.setAtc_set				(0);
		d_bean.setGubun					(reg_code);
		d_bean.setRname					("mail");
		d_bean.setMtype       			(0);
		d_bean.setU_idx       			(1);//admin계정
		d_bean.setG_idx					(1);//admin계정
		d_bean.setMsgflag     			(0);
		d_bean.setContent				("http://fms1.amazoncar.co.kr/mailing/tax_bill/bill_doc_simple2.jsp?gubun=1&item_reg_code="+reg_code+"&site_id="+String.valueOf(ht.get("SEQ"))+"&client_id="+String.valueOf(ht.get("CLIENT_ID")));
		if(!IssueDb.insertDEmail(d_bean, "", "")) m_flag += 1;
		
		if(m_flag == 0){
			//2. SMS 등록-------------------------------
			if(!String.valueOf(ht.get("AGNT_M_TEL")).equals("")&&!String.valueOf(ht.get("AGNT_M_TEL")).equals("-")){
				String msg = String.valueOf(ht.get("AGNT_NM"))+"님 "+String.valueOf(ht.get("AGNT_EMAIL"))+"으로 "+String.valueOf(ht.get("TAX_MON"))+"월 거래명세서 발행-아마존카-";
				IssueDb.insertsendMail("02-392-4243", "아마존카", String.valueOf(ht.get("AGNT_M_TEL")), String.valueOf(ht.get("RECCONAME2")), String.valueOf(ht.get("TAX_MON")), "+0.10", msg);
			}
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '2' && fm.tax_out_dt.value == ''){
			fm.action = '/tax/issue_2_item/issue_2_frame.jsp';
			fm.target = 'd_content';					
			alert("정상발급!!");
		}else{
			fm.action = 'issue_1_frame.jsp';
			fm.target = 'd_content';		
			alert("정상발급!!");
		}
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='tax_out_dt' 	value='<%=tax_out_dt%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='tax_code' 	value='<%=reg_code%>'>
<a href="javascript:go_step()">3단계로 가기</a>
<script language='javascript'>
<!--
<%	if(m_flag > 0){//에러발생%>
		alert("거래명세서 이메일 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>		
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
