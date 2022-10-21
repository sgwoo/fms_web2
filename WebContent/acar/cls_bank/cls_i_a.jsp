<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String alt_tm = request.getParameter("alt_tm")==null?"":request.getParameter("alt_tm");
	int flag = 0;
	
	ClsBankBean cls = new ClsBankBean();
	
	cls.setLend_id(lend_id);
	cls.setRtn_seq(rtn_seq);
	cls.setCls_rtn_dt(request.getParameter("cls_rtn_dt"));
	cls.setNalt_rest(request.getParameter("nalt_rest")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest")));
	cls.setCls_rtn_int(request.getParameter("cls_rtn_int")==null?"":request.getParameter("cls_rtn_int"));
	cls.setMax_pay_dt(request.getParameter("max_pay_dt")==null?"":request.getParameter("max_pay_dt"));
	cls.setCls_rtn_fee(request.getParameter("cls_rtn_fee")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_fee")));
	cls.setCls_rtn_int_amt(request.getParameter("cls_rtn_int_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_int_amt")));
	cls.setDly_alt(request.getParameter("dly_alt")==null?0:AddUtil.parseDigit(request.getParameter("dly_alt")));
	cls.setBe_alt(request.getParameter("be_alt")==null?0:AddUtil.parseDigit(request.getParameter("be_alt")));
	cls.setCls_rtn_amt(request.getParameter("cls_rtn_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_amt")));
	cls.setBk_code(request.getParameter("bk_code")==null?"":request.getParameter("bk_code"));
	cls.setAcnt_no(request.getParameter("acnt_no")==null?"":request.getParameter("acnt_no"));
	cls.setAcnt_user(request.getParameter("acnt_user")==null?"":request.getParameter("acnt_user"));
	cls.setCls_rtn_cau(request.getParameter("cls_rtn_cau")==null?"":request.getParameter("cls_rtn_cau"));
	cls.setCls_rtn_fee_int(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
	cls.setReg_id(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));
	cls.setReg_dt(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	cls.setNalt_rest_1(request.getParameter("nalt_rest_1")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest_1")));
	cls.setNalt_rest_2(request.getParameter("nalt_rest_2")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest_2")));
	cls.setCls_etc_fee	(request.getParameter("cls_etc_fee")	==null?0:AddUtil.parseDigit(request.getParameter("cls_etc_fee")));
	
	ClsBankBean cls2 = as_db.getClsBankCase(lend_id, rtn_seq, cls.getCls_rtn_dt());
	
	if(cls2.getCls_rtn_dt().equals("")){//기입력분 체크
		if(!as_db.insertClsBank(cls))	flag += 1;
	}
	
	//할부스케줄 생성 및 정리
	if(!as_db.updateScdBank(cls, alt_tm))	flag += 1;
	
	//할부스케줄 잔액 재계산 20210721
	
	
	//재리스 계산
	String  d_flag1 =  as_db.call_sp_bank_scd_rest(lend_id, rtn_seq, alt_tm);
	
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag != 0){ 	//해지테이블에 삽입 실패%>
		alert('등록 오류발생!');
<%	}else{ 			//해지테이블에 삽입 성공..%>
			alert('처리되었습니다');
			fm.action='../bank_mng/bank_reg_frame.jsp';		
			fm.target='d_content';		
			parent.window.close();		
			fm.submit();			
<%	}%>
</script>
</body>
</html>