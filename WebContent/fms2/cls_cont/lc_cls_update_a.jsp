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
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	String des_zip = request.getParameter("des_zip")==null?"":request.getParameter("des_zip");
	String des_addr = request.getParameter("des_addr")==null?"":request.getParameter("des_addr");
	String des_nm = request.getParameter("des_nm")==null?"":request.getParameter("des_nm");
	String des_tel = request.getParameter("des_tel")==null?"":request.getParameter("des_tel");
	
	String r_date = request.getParameter("r_date")==null?"":request.getParameter("r_date");
	
	int    cls_eff_amt 	= request.getParameter("cls_eff_amt")	==null?0 :AddUtil.parseInt(request.getParameter("cls_eff_amt"));  // 영업효율 경감금액 
	
	int flag = 0;	
		
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String m_gubun = request.getParameter("m_gubun")==null?"":request.getParameter("m_gubun");
	
	if (m_gubun.equals("card_del")) {
		from_page 	=  "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
		//환불로 인한 카드취소요청및 재결재삭제 
		if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //선수금정산		
	} else if (m_gubun.equals("card_r_dt")) {
		from_page 	=  "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	  //
		//카드 취소 승인일 변경 
		if(!ac_db.updateClsContEtcRdate(rent_mng_id, rent_l_cd, r_date))	flag += 1; 
	} else if (m_gubun.equals("lc_cls_eff")) {
		from_page 	=  "/fms2/cls_cont/lc_cls_u3.jsp";	  //
		//영업효율 금액 변경 
		if(!ac_db.updateClsEffAmt(rent_mng_id, rent_l_cd, cls_eff_amt ))	flag += 1; 	
	} else if (m_gubun.equals("upd_des_addr")) {
		from_page 	=  "/fms2/cls_cont/lc_cls_off_d_frame.jsp";		
		//매입옵션시 주소 변경건  
		if(!ac_db.updateClsDesInfo(rent_mng_id, rent_l_cd, des_zip, des_addr, des_nm, des_tel))	flag += 1;  
	}
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
