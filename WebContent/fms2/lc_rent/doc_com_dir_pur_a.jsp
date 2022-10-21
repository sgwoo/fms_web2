<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.doc_settle.* "%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_st 	= request.getParameter("doc_st")==null?"":request.getParameter("doc_st");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");


	boolean flag = true;	
						
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st	("17");
	doc.setDoc_id	(rent_l_cd);
	doc.setSub		("법인고객 자동차 영업직원 활동 보고서");
	doc.setCont		("");
	doc.setEtc		(request.getParameter("etc")==null?"":request.getParameter("etc"));			
	doc.setUser_nm1	("등록자");
	doc.setUser_id1	(ck_acar_id);
	doc.setDoc_bit	("1");	
	doc.setDoc_step	("3");	
	doc.setSeq		(1);
	doc.setVar01	(request.getParameter("var01")==null?"":request.getParameter("var01"));
	doc.setVar02	(request.getParameter("var02")==null?"":request.getParameter("var02"));
	doc.setVar03	(request.getParameter("var03")==null?"":request.getParameter("var03"));
	doc.setVar04	(request.getParameter("var04")==null?"":request.getParameter("var04"));
	doc.setVar05	(request.getParameter("var05")==null?"":request.getParameter("var05"));
	doc.setVar06	(request.getParameter("var06")==null?"":request.getParameter("var06"));
	doc.setVar07	(request.getParameter("var07")==null?"":request.getParameter("var07"));
	doc.setVar08	(request.getParameter("var08")==null?"":request.getParameter("var08"));
	doc.setVar09	(request.getParameter("var09")==null?"":request.getParameter("var09"));
	
	if(doc.getVar01().equals("") && doc.getVar02().equals("") && doc.getVar03().equals("") && doc.getVar04().equals("") && doc.getVar05().equals("")){
		flag = false;
	}else{
		
		if(mode.equals("upd")){
			//=====[doc_settle_var] insert=====
			flag = d_db.updateDocSettleVar(doc);
		}else{
			//=====[doc_settle] insert=====
			flag = d_db.insertDocSettle(doc);
		
			DocSettleBean o_doc = d_db.getDocSettleCommi("17", rent_l_cd);							
		
			doc.setDoc_no	(o_doc.getDoc_no());

			//=====[doc_settle_var] insert=====
			flag = d_db.insertDocSettleVar(doc);
			
			//미등록시 삭제
			DocSettleBean doc_var = d_db.getDocSettleVar(o_doc.getDoc_no(), 1);
			if(doc_var.getDoc_no().equals("")){
				flag = d_db.deleteDocSettle("17", rent_l_cd);
			}
		}
		
	}

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(flag==true){%>
		alert("정상적으로 처리되었습니다.");		
		parent.window.close();
		parent.opener.location.reload();
	
<%		}else{
			if(doc.getVar01().equals("") && doc.getVar02().equals("") && doc.getVar03().equals("") && doc.getVar04().equals("") && doc.getVar05().equals("")){%>
				alert("입력값이 없습니다. 에러발생!");
			<%}else{%>
				alert("에러발생!");
			<%}%>
<%		}%>

</script>
</body>
</html>

