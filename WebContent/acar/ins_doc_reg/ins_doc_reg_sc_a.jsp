<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="InsDocListBn" scope="page" class="acar.insur.InsDocListBean"/>
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
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	int count = 0;
	boolean flag = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//해지보험요청공문 테이블->이의신청공문 테이블을 사용한다.
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

		//해지보험 리스트
		String car_mng_id[] = request.getParameterValues("car_mng_id");
		String ins_st[] = request.getParameterValues("ins_st");
		String exp_st[] = request.getParameterValues("exp_st");
		String car_no_b[] = request.getParameterValues("car_no_b");
		String car_no_a[] = request.getParameterValues("car_no_a");
		String car_nm[] = request.getParameterValues("car_nm");
		String exp_dt[] = request.getParameterValues("exp_dt");
		String app_st[] = request.getParameterValues("app_st");
		String ins_con_no[] = request.getParameterValues("ins_con_no");		
		
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		
		for(int i=0; i<size; i++){
			InsDocListBn.setDoc_id			(doc_id);
			InsDocListBn.setCar_mng_id		(car_mng_id[i]);
			InsDocListBn.setIns_st			(ins_st[i]);
			InsDocListBn.setExp_st			(exp_st[i]);
			InsDocListBn.setCar_no_b		(car_no_b[i]);
			InsDocListBn.setCar_no_a		(car_no_a[i]);
			InsDocListBn.setCar_nm			(car_nm[i]);
			InsDocListBn.setExp_dt			(exp_dt[i]==null?"":exp_dt[i]);
			InsDocListBn.setApp_st			(app_st[i]==null?"":app_st[i]);
			InsDocListBn.setReg_id			(user_id);
			InsDocListBn.setIns_con_no 		(ins_con_no[i]==null?"":ins_con_no[i]);			
			
			flag = ai_db.insertInsDocList(InsDocListBn, FineDocBn.getDoc_dt());
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

