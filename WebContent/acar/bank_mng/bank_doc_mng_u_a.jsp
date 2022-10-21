<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
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
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String yn = request.getParameter("yn")==null?"":request.getParameter("yn");
	String cltr_chk = request.getParameter("cltr_chk")==null?"":request.getParameter("cltr_chk");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn"); //리스자금 여부
			
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //롯데오토리스에서만 사용 (202204) ( 수정할때는 사용 안함)
	
	int count = 0;
	boolean flag = true;
	
	if(cmd.equals("y")){
		FineDocDb.upregyn(doc_id, yn);
	}else if (cmd.equals("cltr_chk")){
		FineDocDb.upcltr_chk(doc_id, cltr_chk);
	}else{
	
		//이의신청공문 테이블
		FineDocBn = FineDocDb.getFineDoc(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setGov_id		(gov_id);
		FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setUpd_id		(user_id);
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos	(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setTitle	(request.getParameter("title")==null?"":request.getParameter("title"));	
		FineDocBn.setApp_doc1	(request.getParameter("app_doc1")==null?"N":request.getParameter("app_doc1"));
		FineDocBn.setApp_doc2	(request.getParameter("app_doc2")==null?"N":request.getParameter("app_doc2"));
		FineDocBn.setApp_doc3	(request.getParameter("app_doc3")==null?"N":request.getParameter("app_doc3"));
		FineDocBn.setApp_doc4	(request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4"));
		FineDocBn.setApp_doc5	(request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5"));
		FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));  //대출실행일
		FineDocBn.setFilename	(request.getParameter("filename")==null?"":request.getParameter("filename")); //대출금리
		FineDocBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));  //대출상환조건
		
		FineDocBn.setCltr_rat		(request.getParameter("cltr_rat")==null?"":request.getParameter("cltr_rat"));  //근저당
		FineDocBn.setCltr_amt		(request.getParameter("cltr_amt")==null?0:AddUtil.parseDigit(request.getParameter("cltr_amt")) );  //근저당
		
		FineDocBn.setOff_id		(request.getParameter("off_id")==null?"":request.getParameter("off_id"));  //대출 담당자
		FineDocBn.setSeq		(request.getParameter("seq")==null?0:AddUtil.parseDigit(request.getParameter("seq")) );  //대출 담당자
					
		flag = FineDocDb.updateFineDoc(FineDocBn);
		
		// 대출내역 금액 등 변경사항 반영
		flag = FineDocDb.updateFineDocList(doc_id, gov_id, cltr_rat);
		
		// 대출신청 후 차량 등록시 해당 정보 갱신
		flag = FineDocDb.updateFineDocListCar();
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
<%if(cmd.equals("y")||cmd.equals("d")){%>
	alert("정상적으로 처리되었습니다.");

	parent.window.close();
<%}else{%>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.opener.location.reload();
			parent.window.close();	
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%}%>
</script>
</body>
</html>

