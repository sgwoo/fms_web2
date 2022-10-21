<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,  acar.user_mng.*, acar.util.*,  acar.credit.*"%>
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

	String job = request.getParameter("job")==null?"3":request.getParameter("job");
	
	String from_page 	= "";
	
			
					
	int flag = 0;
	
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	String cls_st = cls.getCls_st_r();
				
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	cls.setUpd_id	(user_id);	
		
	if(cls_st.equals("8")){//매입옵션인경우 
			
		//매입옵션 입금 1 - 정산서 작성시점에
		cls.setOpt_ip_dt1(request.getParameter("opt_ip_dt1")==null?"":			request.getParameter("opt_ip_dt1"));  		 //추가입금일
		cls.setOpt_ip_amt1(request.getParameter("opt_ip_amt1")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt1")));	  //추가입금액 	
		cls.setOpt_ip_bank1(request.getParameter("opt_bank_code1_2")==null?"":		request.getParameter("opt_bank_code1_2"));           //입금은행
		cls.setOpt_ip_bank_no1(request.getParameter("opt_deposit_no1_2")==null?"":request.getParameter("opt_deposit_no1_2"));            //입금구좌
		
		//매입옵션 입금 2 - 정산서 작성시점에
		cls.setOpt_ip_dt2(request.getParameter("opt_ip_dt2")==null?"":			request.getParameter("opt_ip_dt2"));  		 //추가입금일
		cls.setOpt_ip_amt2(request.getParameter("opt_ip_amt2")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt2")));	  //추가입금액 	
		cls.setOpt_ip_bank2(request.getParameter("opt_bank_code2_2")==null?"":		request.getParameter("opt_bank_code2_2"));           //입금은행
		cls.setOpt_ip_bank_no2(request.getParameter("opt_deposit_no2_2")==null?"":request.getParameter("opt_deposit_no2_2"));            //입금구좌	
		
		//System.out.println("m2="+ request.getParameter("opt_deposit_no2_2"));
		
	}
	
	//매입옵션인 경우 매입옵션 입금확인 
	if (cls_st.equals("8")) {
		if(!ac_db.updateClsEtcOpt(cls))	flag += 1;
	}
				
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
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

