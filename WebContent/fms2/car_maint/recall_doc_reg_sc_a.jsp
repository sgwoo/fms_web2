<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
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
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
		
	
	
	String doc_id =  FineDocDb.getFineGovNoNext("리콜");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");  //제조사
	
	int count = 0;
	boolean flag = true;
	boolean flag2 = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//공문 테이블
		FineDocBn.setDoc_id	(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setPrint_dt		(request.getParameter("print_dt")==null?"":request.getParameter("print_dt"));
		FineDocBn.setF_reason		(request.getParameter("f_reason")==null?"":request.getParameter("f_reason"));
		FineDocBn.setF_result		(request.getParameter("f_result")==null?"":request.getParameter("f_result"));	
		FineDocBn.setReg_id		(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));
		FineDocBn.setPrint_id		(request.getParameter("print_id")==null?"":request.getParameter("print_id"));
		FineDocBn.setH_mng_id		(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id		(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
		FineDocBn.setGov_id		(car_comp_id);
		FineDocBn.setMng_pos		(request.getParameter("code")==null?"":request.getParameter("code"));
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));   //대상구분
		FineDocBn.setS_dt		(request.getParameter("s_dt")==null?"":request.getParameter("s_dt"));   //개시일(제조일자)
		FineDocBn.setE_dt		(request.getParameter("e_dt")==null?"":request.getParameter("e_dt"));   //종료일(제조일자)
		FineDocBn.setIp_dt		(request.getParameter("ip_dt")==null?"":request.getParameter("ip_dt"));   //시행기간
		FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));   //시행기간
			
		FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setTitle	(request.getParameter("title")==null?"":request.getParameter("title"));
		FineDocBn.setRemarks	(request.getParameter("remarks")==null?"":request.getParameter("remarks"));
			
		flag = FineDocDb.insertFineDoc(FineDocBn);
        			
		//공문 리스트
		String car_mng_id[] = request.getParameterValues("car_mng_id");
		String rent_mng_id[] = request.getParameterValues("rent_mng_id");
		String rent_l_cd[]  = request.getParameterValues("rent_l_cd");
		String rent_s_cd[]  = request.getParameterValues("rent_s_cd");
		String firm_nm[] 	= request.getParameterValues("firm_nm");
		
		String car_no[] 	 = request.getParameterValues("car_no");	
		String car_nm[] 	 = request.getParameterValues("car_nm");	
		String rent_way_nm[] 	 = request.getParameterValues("rent_way_nm");	
		String mng_id[] 	 = request.getParameterValues("mng_id");	
		String car_num[] 	 = request.getParameterValues("car_num");	
	
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
						
		for(int i=0; i<size; i++){
				
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i + 1);
			FineDocListBn.setRent_mng_id	(rent_mng_id[i]);
			FineDocListBn.setRent_l_cd		(rent_l_cd[i]);
			FineDocListBn.setRent_s_cd		(rent_s_cd[i]);
			FineDocListBn.setFirm_nm		(firm_nm[i]==null?"":firm_nm[i]);
			
			FineDocListBn.setCar_no			(car_no[i]==null?"":car_no[i]);
			FineDocListBn.setVar1			(car_nm[i]==null?"":car_nm[i]);
			FineDocListBn.setVar2			(rent_way_nm[i]==null?"":rent_way_nm[i]);
			FineDocListBn.setVar3			(mng_id[i]==null?"":mng_id[i]);
			FineDocListBn.setPaid_no		(car_num[i]==null?"":car_num[i]);
				
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
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
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

<%	}%>

</script>
</body>
</html>

