<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.credit.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	//String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
		
	int flag = 0;
	String from_page 	= "";	
				
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();	//14:월렌트해지
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
	} else if (cls_st.equals("14") ) {	
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
	}
	
		  //r_over_amt가 있다면 - 산출금액이 있다면	      
	 if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) > 0 ) {
	        		
	     	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
		
			co.setRent_mng_id(rent_mng_id);
		 	co.setRent_l_cd(rent_l_cd);
			co.setRent_days(request.getParameter("rent_days")==null?0:	AddUtil.parseDigit(request.getParameter("rent_days"))); //이용일
			co.setCal_dist(request.getParameter("cal_dist")==null?0:	AddUtil.parseDigit(request.getParameter("cal_dist"))); //약정거리
			co.setFirst_dist(request.getParameter("first_dist")==null?0:	AddUtil.parseDigit(request.getParameter("first_dist"))); //최초주행거리
			co.setLast_dist(request.getParameter("last_dist")==null?0:	AddUtil.parseDigit(request.getParameter("last_dist"))); //최종주행거리
			co.setReal_dist(request.getParameter("real_dist")==null?0:	AddUtil.parseDigit(request.getParameter("real_dist"))); //실운행거리
			co.setOver_dist(request.getParameter("over_dist")==null?0:	AddUtil.parseDigit(request.getParameter("over_dist"))); //초과운행거리
			co.setAdd_dist(request.getParameter("add_dist")==null?0:	AddUtil.parseDigit(request.getParameter("add_dist"))); //서비스마일리지
			co.setJung_dist(request.getParameter("jung_dist")==null?0:	AddUtil.parseDigit(request.getParameter("jung_dist"))); //정산기준운행거리
			co.setR_over_amt(request.getParameter("r_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("r_over_amt"))); //산출금액
			co.setM_over_amt(request.getParameter("m_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("m_over_amt"))); //감액
			co.setJ_over_amt(request.getParameter("j_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("j_over_amt"))); //정산금액		
			co.setM_saction_id(request.getParameter("m_saction_id")==null?"":	request.getParameter("m_saction_id")); //결재자
			co.setM_reason(request.getParameter("m_reason")==null?"":request.getParameter("m_reason")); //사유

			boolean cr3_flag = ac_db.updateClsEtcOver(co);	
	} 
		
	//세금계산서는 기안자 수정시 update 하지 않음 - 
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 수정 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 수정 성공.. %>
	
    alert('처리되었습니다');				
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>

