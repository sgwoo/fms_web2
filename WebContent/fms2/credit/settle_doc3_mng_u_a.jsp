<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>

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

	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	System.out.println("확인");
	System.out.println(gov_addr);
	
	//최고장 테이블
	FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
	FineDocBn.setMng_dept	(mng_dept);
	FineDocBn.setGov_addr	(gov_addr);
	FineDocBn.setTitle		(title);
	FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
	
	FineDocBn.setF_result	(request.getParameter("f_result")==null?"":request.getParameter("f_result"));
	FineDocBn.setF_reason	(request.getParameter("f_reason")==null?"":request.getParameter("f_reason"));
	
	FineDocBn.setAmt1(request.getParameter("amt1")==null?0:AddUtil.parseDigit(request.getParameter("amt1")));
	FineDocBn.setAmt2(request.getParameter("amt2")==null?0:AddUtil.parseDigit(request.getParameter("amt2")));	
	
//	Enumeration formNames=request.getFileNames();  // 폼의 이름 반환
//	String formName=(String)formNames.nextElement(); // 자료가 많을 경우엔 while 문을 사용
//	String fileName=request.getFilesystemName(formName)==null?"":request.getFilesystemName(formName); // 파일의 이름 얻기
/* 	if(!fileName.equals("")){
		FineDocBn.setFilename	(fileName);
	}
	 */
		
	flag = FineDocDb.updateFineDoc(FineDocBn);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</head>
<body>
<form name='form1' action='http://fms2.amazoncar.co.kr/fms2/credit/settle_doc_mng_c.jsp' target='d_content' method='post'>
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
			alert("정상적으로 처리되었습니다.\n\n");
			parent.opener.location.reload();
			parent.window.close();
<%		}else{%>
			alert("에러발생!");
<%		}%>
	
</script>
</body>
</html>

