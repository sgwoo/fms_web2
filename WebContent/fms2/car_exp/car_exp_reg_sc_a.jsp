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
	
		
%>

<%

	String doc_id = FineDocDb.getFineGovNoNext("환급");
	
	int count = 0;
	boolean flag = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//이의신청공문 테이블
		FineDocBn.setDoc_id	(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setGov_id		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos	(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setH_mng_id	(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id	(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));

		flag = FineDocDb.insertFineDoc(FineDocBn);
		


		//이의신청공문 과태료리스트
		String car_mng_id[] = request.getParameterValues("car_mng_id");
		String seq_no[] = request.getParameterValues("seq_no");
		String rent_mng_id[] = request.getParameterValues("rent_mng_id");
		String rent_l_cd[] = request.getParameterValues("rent_l_cd");
		String rent_s_cd[] = request.getParameterValues("rent_s_cd");
		String firm_nm[] = request.getParameterValues("firm_nm");
		String ssn[] = request.getParameterValues("ssn");
		String enp_no[] = request.getParameterValues("enp_no");
		String rent_start_dt[] = request.getParameterValues("rent_start_dt");
		String rent_end_dt[] = request.getParameterValues("rent_end_dt");
		String paid_no[] = request.getParameterValues("paid_no");
		
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));

				
		for(int i=0; i<size; i++){
		
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i);
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocListCar_exp(FineDocListBn, FineDocBn.getDoc_dt());
		
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

