<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<jsp:useBean id="sw_bean" scope="page" class="acar.insa_card.Insa_SwBean"/>  
<%@ include file="/acar/cookies.jsp" %>

<%
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	
	String savePath = "D:\\Inetpub\\wwwroot\\data\\insa_card"; // 저장할 디렉토리 (절대경로)
 	int sizeLimit = 10 * 1024 * 1024 ; // 5메가까지 제한 넘어서면 예외발생
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw 	= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id	= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");//로그인-ID
	String br_id 	= multi.getParameter("br_id")==null?"":multi.getParameter("br_id");//로그인-영업소
	
	
%>

<%
	//insa_sw
	String sw_gubun = multi.getParameter("sw_gubun")==null?"":multi.getParameter("sw_gubun");
	int seq = multi.getParameter("seq")==null?1:Util.parseInt(multi.getParameter("seq"));
	String sw_name = multi.getParameter("sw_name")==null?"":multi.getParameter("sw_name");
	String sw_ssn = multi.getParameter("sw_ssn")==null?"":multi.getParameter("sw_ssn");
	String sw_addr = multi.getParameter("sw_addr")==null?"":multi.getParameter("sw_addr");
	String sw_tel = multi.getParameter("sw_tel")==null?"":multi.getParameter("sw_tel");
	String sw_my_gubun = multi.getParameter("sw_my_gubun")==null?"":multi.getParameter("sw_my_gubun");
	String sw_st_dt = multi.getParameter("sw_st_dt")==null?"":multi.getParameter("sw_st_dt");
	String sw_ed_dt = multi.getParameter("sw_ed_dt")==null?"":multi.getParameter("sw_ed_dt");
	String sw_up_dt = multi.getParameter("sw_up_dt")==null?"":multi.getParameter("sw_up_dt");
	String sw_insu_nm = multi.getParameter("sw_insu_nm")==null?"":multi.getParameter("sw_insu_nm");
	String sw_insu_no = multi.getParameter("sw_insu_no")==null?"":multi.getParameter("sw_insu_no");
	String sw_insu_money = multi.getParameter("sw_insu_money")==null?"":multi.getParameter("sw_insu_money");
	String sw_jesan = multi.getParameter("sw_jesan")==null?"":multi.getParameter("sw_jesan");

	//한글이 깨지는 문제 -multipartrequest
	sw_gubun		= new String(sw_gubun.getBytes("8859_1"),"euc-kr");
	sw_name		= new String(sw_name.getBytes("8859_1"),"euc-kr");
	sw_addr	= new String(sw_addr.getBytes("8859_1"),"euc-kr");
	sw_ssn	= new String(sw_ssn.getBytes("8859_1"),"euc-kr");
	sw_tel		= new String(sw_tel.getBytes("8859_1"),"euc-kr");
	sw_my_gubun	= new String(sw_my_gubun.getBytes("8859_1"),"euc-kr");
	sw_st_dt		= new String(sw_st_dt.getBytes("8859_1"),"euc-kr");
	sw_ed_dt		= new String(sw_ed_dt.getBytes("8859_1"),"euc-kr");
	sw_up_dt	= new String(sw_up_dt.getBytes("8859_1"),"euc-kr");
	sw_insu_nm		= new String(sw_insu_nm.getBytes("8859_1"),"euc-kr");
	sw_insu_no	= new String(sw_insu_no.getBytes("8859_1"),"euc-kr");
	sw_insu_money		= new String(sw_insu_money.getBytes("8859_1"),"euc-kr");
	sw_jesan		= new String(sw_jesan.getBytes("8859_1"),"euc-kr");

	
	int count = 0;
	
	InsaCardDatabase icd = InsaCardDatabase.getInstance();	
	
	sw_bean.setUser_id(user_id);
	sw_bean.setSeq(seq);
	sw_bean.setSw_gubun(sw_gubun);
	sw_bean.setSw_name(sw_name);
	sw_bean.setSw_ssn(sw_ssn);
	sw_bean.setSw_addr(sw_addr);
	sw_bean.setSw_tel(sw_tel);
	sw_bean.setSw_my_gubun(sw_my_gubun);
	sw_bean.setSw_st_dt(sw_st_dt);
	sw_bean.setSw_ed_dt(sw_ed_dt);
	sw_bean.setSw_up_dt(sw_up_dt);
	sw_bean.setSw_insu_nm(sw_insu_nm);
	sw_bean.setSw_insu_no(sw_insu_no);
	sw_bean.setSw_insu_money(sw_insu_money);
	sw_bean.setSw_jesan(sw_jesan);
	

	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
	
		String formName=(String)formNames.nextElement(); // 자료가 많을 경우엔 while 문을 사용
		String fileName=multi.getFilesystemName(formName)==null?"":multi.getFilesystemName(formName); // 파일의 이름 얻기
		
		if(!fileName.equals("")){
			sw_bean.setSw_file	(fileName);
		}
		
	count = icd.insertSw(sw_bean);
	
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
<%if(count == 1){%>
	alert("정상적으로 처리되었습니다.");
	parent.location.close();			
<%}else{%>
	alert("에러발생!");
<%}%>

</script>
</body>
</html>

