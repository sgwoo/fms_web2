<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
		
	String doc_id = FineDocDb.getFineGovNoNext("법무");
	
	int count = 0;
	boolean flag = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//공문 테이블
		FineDocBn.setDoc_id	(doc_id);
		FineDocBn.setDoc_dt	(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setGov_id	(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		FineDocBn.setGov_nm	(request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm"));
		FineDocBn.setTitle	(request.getParameter("title")==null?"":request.getParameter("title"));
		FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setReg_id	(user_id);		
		FineDocBn.setGov_zip	(request.getParameter("gov_zip")==null?"":request.getParameter("gov_zip"));
		FineDocBn.setGov_addr	(request.getParameter("gov_addr")==null?"":request.getParameter("gov_addr"));
		FineDocBn.setEnd_dt	(request.getParameter("end_dt")==null?"":request.getParameter("end_dt")); //유예기간
		
		flag = FineDocDb.insertFineDoc(FineDocBn);

		//공문 리스트
		String car_mng_id[] = request.getParameterValues("car_mng_id");
		String rent_mng_id[]= request.getParameterValues("rent_mng_id");
		String rent_l_cd[]= request.getParameterValues("rent_l_cd");
	
		String firm_nm[] 	= request.getParameterValues("firm_nm");
		String req_dt[] 	= request.getParameterValues("req_dt");
		String pay_dt[] 	= request.getParameterValues("pay_dt");
		String req_amt[] 	= request.getParameterValues("req_amt");
		String pay_amt[] 	= request.getParameterValues("pay_amt");
		String accid_id[] 	= request.getParameterValues("accid_id");
		String seq_no[] 	= request.getParameterValues("seq_no");  //휴대차료연번
		String amt3[] 		= request.getParameterValues("amt3");
		String amt4[] 		= request.getParameterValues("amt4");
		String dly_days[]	= request.getParameterValues("dly_days");
		String amt5[] 		= request.getParameterValues("amt5");
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		
		for(int i=0; i<size; i++){
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i + 1);  //fine_doc_list 연번
			FineDocListBn.setRent_mng_id		(rent_mng_id[i]);
			FineDocListBn.setRent_l_cd		(rent_l_cd[i]);
	
			FineDocListBn.setFirm_nm		(firm_nm[i]==null?"":firm_nm[i]);
			FineDocListBn.setRent_start_dt		(req_dt[i]==null?"":req_dt[i]);
			FineDocListBn.setRent_end_dt		(pay_dt[i]==null?"":pay_dt[i]);
			FineDocListBn.setAmt1			(req_amt[i]==null?0:AddUtil.parseDigit(req_amt[i]));  //청구액
			FineDocListBn.setAmt2			(pay_amt[i]==null?0:AddUtil.parseDigit(pay_amt[i]));  // 입금액
			FineDocListBn.setAmt3			(amt3[i]==null?0:AddUtil.parseDigit(amt3[i]));  // 차액
			FineDocListBn.setAmt4			(amt4[i]==null?0:AddUtil.parseDigit(amt4[i]));  // 차액
			FineDocListBn.setAmt5			(amt5[i]==null?0:AddUtil.parseDigit(amt5[i]));  // 차액
			FineDocListBn.setVar1			(dly_days[i]==null?"":dly_days[i]);
		
			FineDocListBn.setCar_no			(accid_id[i]==null?"":accid_id[i]);
			FineDocListBn.setPaid_no		(seq_no[i]==null?"0":seq_no[i]);			
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
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
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%	}else{%>
			alert("이미 등록된 문서번호입니다. 확인하십시오.");
//			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

