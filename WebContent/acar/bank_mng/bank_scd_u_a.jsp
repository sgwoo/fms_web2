<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.bank_mng.*, acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	int scd_size 	= request.getParameter("scd_size")==null?0:Integer.parseInt(request.getParameter("scd_size"));
	String update_msg = request.getParameter("update_msg")==null?"": request.getParameter("update_msg");
	int flag = 0;
	
	
	String table = "";
	if(AddUtil.parseInt(lend_id) < 12)	table = "bank_sche";
	else								table = "scd_bank";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();

	/* 1회차 결재일, 결재액수 update */
	BankRtnBean br = new BankRtnBean();
	br.setLend_id(lend_id);
	br.setSeq(rtn_seq);
	br.setFst_pay_dt(request.getParameter("fst_pay_dt"));
	br.setFst_pay_amt(request.getParameter("fst_pay_amt").equals("")?0:Util.parseDigit(request.getParameter("fst_pay_amt")));
	if(!abl_db.updateBankRtn_fst(br))	flag += 1;

	/* 스케줄 insert */
	String alt_tm[] = request.getParameterValues("alt_tm");
	String est_dt[] = request.getParameterValues("alt_est_dt");
	String alt_prn[] = request.getParameterValues("alt_prn_amt");
	String alt_int[] = request.getParameterValues("alt_int_amt");
	String alt_rest[] = request.getParameterValues("alt_rest");
	String pay_dt[] 	= request.getParameterValues("alt_pay_dt");
	
	
	for(int i = 0 ; i < scd_size ; i++){
		BankScdBean scd = abl_db.getBankScd(table, lend_id, rtn_seq, alt_tm[i]);
		
		scd.setAlt_est_dt(est_dt[i]);
		scd.setAlt_prn_amt(alt_prn[i].equals("")?0:Util.parseDigit(alt_prn[i]));
		scd.setAlt_int_amt(alt_int[i].equals("")?0:Util.parseDigit(alt_int[i]));
		scd.setAlt_rest(alt_rest[i].equals("")?0:Util.parseDigitLong(alt_rest[i]));
		scd.setPay_dt(pay_dt[i]);
		scd.setR_alt_est_dt(af_db.getValidDt(scd.getAlt_est_dt()));
		
		
		if(i+1==scd_size && scd.getAlt_prn_amt()+scd.getAlt_int_amt()+scd.getAlt_rest() == 0){
			if(!abl_db.deleteBankScd(scd))	flag += 1;
		}else{
			if(!abl_db.updateBankScd(table, scd))	flag += 1;
		}
		

	}
	
	//관련담당자 메시지 발송
	if(!update_msg.equals("")){

		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
		String sub 			= "묶음 할부상환스케줄 변동";
		String cont 		= "[ "+lend_id+"-"+rtn_seq+" : "+update_msg+" ] 묶음 할부상환스케줄 변동되었습니다. 확인바랍니다.";
		
		String target_id1 = nm_db.getWorkAuthUser("할부금중도상환담당");
		String target_id2 = nm_db.getWorkAuthUser("세금계산서담당자");
		String target_id3 = nm_db.getWorkAuthUser("출금담당");
		String target_id4 = nm_db.getWorkAuthUser("할부스케줄담당자");
		
		CarScheBean cs_bean1 = csd.getCarScheTodayBean(target_id1);
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id2);
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(target_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_id4);
		
		if(!cs_bean1.getUser_id().equals(""))	target_id1 = cs_bean1.getWork_id();
		if(!cs_bean2.getUser_id().equals(""))	target_id2 = cs_bean2.getWork_id();
		if(!cs_bean3.getUser_id().equals(""))	target_id3 = cs_bean3.getWork_id();
		if(!cs_bean4.getUser_id().equals(""))	target_id4 = cs_bean4.getWork_id();
		
		//사용자 정보 조회
		UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
		
		UsersBean target_bean1 	= umd.getUsersBean(target_id1);
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		UsersBean target_bean3 	= umd.getUsersBean(target_id3);
		UsersBean target_bean4 	= umd.getUsersBean(target_id4);
		
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL></URL>";
		
		//if(!target_bean1.getId().equals(sender_bean.getId())){
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
		//}
		//if(!target_bean2.getId().equals(sender_bean.getId())){
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		//}
		//if(!target_bean3.getId().equals(sender_bean.getId())){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		//}
		//if(!target_bean4.getId().equals(sender_bean.getId())){
			xml_data += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
		//}
				
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
						"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		boolean flag3 = cm_db.insertCoolMsg(msg);	
		
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('수정되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('수정되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='bank_scd_u.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
