<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	
			//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
	
	from_page = "/agent/cls_cont/lc_cls_d_frame.jsp";	
	

	//해지의뢰삭제 - 결재요청전 담당자 기안문서 또는 관리팀장(지점장)
	if(!ac_db.deleteClsEtc(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteClsEtcTax(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteClsEtcSub(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteCarCredit(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteCarReco(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteClsEtcOver(rent_mng_id, rent_l_cd))	flag += 1;
	if(!ac_db.deleteClsContEtc(rent_mng_id, rent_l_cd))	flag += 1; //선수금정산
	if(!r_db.deleteClsCarExam(rent_mng_id, rent_l_cd))	flag += 1;  //사업장 조사
	if(!r_db.deleteClsCarGur(rent_mng_id, rent_l_cd))	flag += 1;  //사업장 조사 //보증인
	if(!ac_db.deleteDocSettleCls(rent_l_cd))	flag += 1; //기안문서
	if(!ac_db.deleteClsEtcAdd(rent_mng_id, rent_l_cd))	flag += 1; //기안문서
	if(!ac_db.deleteClsEtcDetail(rent_mng_id, rent_l_cd))	flag += 1; //기안문서
	if(!ac_db.deleteClsEtcMore(rent_mng_id, rent_l_cd))	flag += 1; //기안문서
	

	//권한
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

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
