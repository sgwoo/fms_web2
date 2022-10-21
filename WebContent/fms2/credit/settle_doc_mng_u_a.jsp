<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.im_email.*, tax.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String s_end_dt = request.getParameter("s_end_dt")==null?"":request.getParameter("s_end_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String mng_dept = request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept");
	String gov_zip = request.getParameter("gov_zip")==null?"":request.getParameter("gov_zip");
	String gov_addr = request.getParameter("gov_addr")==null?"":request.getParameter("gov_addr");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	
	String email 	= request.getParameter("email")==null?"":request.getParameter("email");
	String gov_nm 	= request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
	
	
%>

<%
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//최고장 테이블
	FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
	FineDocBn.setMng_dept	(mng_dept);
	FineDocBn.setGov_addr	(gov_addr);
	FineDocBn.setGov_zip	(gov_zip);
	FineDocBn.setTitle		(title);
	FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
	
	FineDocBn.setF_result		(request.getParameter("f_result")==null?"":request.getParameter("f_result"));
	FineDocBn.setF_reason		(request.getParameter("f_reason")==null?"":request.getParameter("f_reason"));
	
	flag = FineDocDb.updateFineDoc(FineDocBn);
	
	//메일보내기 (결과 등록시 ) 
	
	String subject 		= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
	String msg 			= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4243";
	int seqidx			= 0;
		
	if(!email.equals("")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("credit");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
		
		   if ( title.equals("계약해지 및 납부최고") ) {	
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel.jsp?doc_id="+doc_id);
		   } else if ( title.equals("계약해지 및 차량반납 통보")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_re.jsp?doc_id="+doc_id);
		   }else if ( title.equals("해지통보 및 해지정산금 납입고지")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_2.jsp?doc_id="+doc_id);
		 
		   }
		
		   seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", ""); 
		   
		   		//	 email 주소 변경 
			int cnt1 = FineDocDb.updateFineDocEmail(doc_id, email);
				
	}
			
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' action='settle_doc_mng_c.jsp' target='d_content' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=s_end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
<script>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.window.close();
			document.form1.submit()
//			parent.opener.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
</script>
</body>
</html>

