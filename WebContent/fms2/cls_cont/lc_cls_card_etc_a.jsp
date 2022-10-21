<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
		
	boolean flag2 = true;	
	int flag = 0;	
			
	//카드정산인경우 처리할것 
   	//jung_st 가 3인 경우 : 카드정산, 원승인금액 취소, 카드 재출금의뢰로 처리 - 1 row 생성 - 금액은 확인후 다시 수정 
	ClsContEtcBean cct = new ClsContEtcBean();
	cct.setRent_mng_id(rent_mng_id);
	cct.setRent_l_cd	(rent_l_cd);
	cct.setJung_st("3");  //정산구분
	cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //선납금액
	cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //미납입금액
	cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //정산금액(합산정산시)
	cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //환불
	cct.setH5_amt(100); // 생성후 추가 
	cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //청구
	cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //청구정산금액						
	
	cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //카드 취소관련 - 취소할 카드 승인일							

	if(!ac_db.insertClsContEtc(cct))	flag += 1;
		
			
	System.out.println("카드 재결재 금액 별도 생성 - "+rent_l_cd);	

	
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

<%	if(flag != 0){ 	// 결재 실패%>

	alert('등록 오류발생!');

<%	}else{ 			// 결재 성공.. %>
	
    alert('처리되었습니다');
   	fm.action='/fms2/cls_cont/lc_cls_rm_d_frame.jsp';			
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
