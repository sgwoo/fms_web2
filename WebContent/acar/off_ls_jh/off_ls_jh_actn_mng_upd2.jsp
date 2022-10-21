<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String savePath="D:\\Inetpub\\wwwroot\\data\\action"; // 저장할 디렉토리 (절대경로)

	int sizeLimit = 30 * 1024 * 1024 ; // 20메가까지 제한 넘어서면 예외발생
	
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit);

	String auth_rw = multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");

	String filename="";
	String offls_file = multi.getParameter("offls_file")==null?"":multi.getParameter("offls_file");
	int out_amt = multi.getParameter("out_amt")==null?0:AddUtil.parseDigit(multi.getParameter("out_amt"));
	
	String car_mng_id = multi.getParameter("car_mng_id")==null?"":multi.getParameter("car_mng_id");
	String seq = multi.getParameter("seq")==null?"01":multi.getParameter("seq");
	String actn_st = multi.getParameter("actn_st")==null?"":multi.getParameter("actn_st");
	String actn_cnt = multi.getParameter("actn_cnt")==null?"":multi.getParameter("actn_cnt");
	String actn_num = multi.getParameter("actn_num")==null?"":multi.getParameter("actn_num");
	String actn_dt = multi.getParameter("actn_dt")==null?"":AddUtil.ChangeString(multi.getParameter("actn_dt"));
	int st_pr = multi.getParameter("st_pr")==null?0:AddUtil.parseDigit(multi.getParameter("st_pr"));
	int hp_pr = multi.getParameter("hp_pr")==null?0:AddUtil.parseDigit(multi.getParameter("hp_pr"));
	String ama_jum = multi.getParameter("ama_jum")==null?"":multi.getParameter("ama_jum");
	String ama_rsn = multi.getParameter("ama_rsn")==null?"":multi.getParameter("ama_rsn");
	String ama_nm = multi.getParameter("ama_nm")==null?"":multi.getParameter("ama_nm");
	String actn_jum = multi.getParameter("actn_jum")==null?"":multi.getParameter("actn_jum");
	String actn_rsn = multi.getParameter("actn_rsn")==null?"":multi.getParameter("actn_rsn");
	String actn_nm = multi.getParameter("actn_nm")==null?"":multi.getParameter("actn_nm");
	String gubun = multi.getParameter("gubun")==null?"":multi.getParameter("gubun");
	String mode = multi.getParameter("mode")==null?"":multi.getParameter("mode");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//한글이 깨지는 문제 -MultipartRequest
 	offls_file=new String(offls_file.getBytes("8859_1"),"euc-kr");  
	
	String formName ="";	
	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
	
	formName = (String)formNames.nextElement();   // 폼에서 type이 file인것의 이름(name)을 반환(예 : upload1)
	filename = multi.getFilesystemName(formName); // 파일의 이름 얻기
	
	
	Offls_auctionBean auction = olaD.getAuction(car_mng_id, seq);
	
	auction.setActn_st(actn_st);
	auction.setActn_cnt(actn_cnt);
	auction.setActn_num(actn_num);
	auction.setActn_dt(actn_dt);
	auction.setSt_pr(st_pr);
	auction.setHp_pr(hp_pr);
	auction.setAma_jum(ama_jum);
	auction.setAma_rsn(ama_rsn);
	auction.setAma_nm(ama_nm);
	auction.setActn_jum(actn_jum);
	auction.setActn_rsn(actn_rsn);
	auction.setActn_nm(actn_nm);
	auction.setModify_id(user_id);
	auction.setOut_amt(out_amt);
	if(filename == null) {
		auction.setOffls_file(offls_file);
	}else {
		auction.setOffls_file(filename);
	}
	
	int result = 0;

	if(auction.getCar_mng_id().equals("")){
		auction.setDamdang_id("000004");
		auction.setSeq(seq);
		auction.setCar_mng_id(car_mng_id);
		result = olaD.insAuction(auction);
		result = olaD.updAuction(auction);
	}else{
		result = olaD.updAuction(auction);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.parent.location.href = "off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>&flag=y";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
