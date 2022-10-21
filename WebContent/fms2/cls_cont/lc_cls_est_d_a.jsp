<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	int flag = 0;	
	
	String from_page 	= "";
	
			//해지의뢰정보
	ClsEstBean cls = ac_db.getClsEstCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
			
	from_page = "/fms2/cls_cont/lc_cls_est_frame.jsp";
	

	//해지의뢰삭제 - 결재요청전 담당자 기안문서 또는 관리팀장(지점장)
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_est"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_est_over"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_est_add"))	flag += 1; //기안문서
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_est_detail"))	flag += 1; //기안문서
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 삭제 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 삭제 성공.. %>
	
    alert('처리되었습니다');
   	fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
