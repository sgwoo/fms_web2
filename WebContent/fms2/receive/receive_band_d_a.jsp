<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.receive.*,  acar.user_mng.*"%>
<%@ page import="acar.doc_settle.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	int flag = 0;	
	
	String from_page 	= "";
		
	from_page = "/fms2/receive/receive_d7_frame.jsp";	


	//해지의뢰삭제 - 결재요청전 담당자 기안문서 또는 관리팀장(지점장)
	if(!re_db.deleteClsBand(rent_mng_id, rent_l_cd))	flag += 1;
	if(!re_db.deleteDocSettleBand(rent_l_cd))	flag += 1; //추심
	if(!re_db.deleteDocSettleSuit(rent_l_cd))	flag += 1; //소송	
		
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

<%	if(flag != 0){ 	//추심테이블에 삭제 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//추심테이블에 삭제 성공.. %>
	
    alert('처리되었습니다');
   	fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
