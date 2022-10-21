<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.debt.*"%>
<%@ page import="acar.util.*, acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_register.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	int tot_amt_tm	= request.getParameter("t_tot_amt_tm").equals("")?0:Util.parseDigit(request.getParameter("t_tot_amt_tm"));
	String car_id = request.getParameter("car_id")==null?"": request.getParameter("car_id");
	String update_msg = request.getParameter("update_msg")==null?"": request.getParameter("update_msg");
	int flag = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	/* 1회차 결재일, 결재액수 update */
	ContDebtBean c_debt = a_db.getContDebt(m_id, l_cd);
	c_debt.setFst_pay_dt(request.getParameter("t_fst_pay_dt"));
	c_debt.setFst_pay_amt(request.getParameter("t_fst_pay_amt").equals("")?0:Util.parseDigit(request.getParameter("t_fst_pay_amt")));

	if(!a_db.updateContDebt(c_debt))	flag += 1;
	/* 스케줄 insert */	
	String alt_tm[] 	= request.getParameterValues("t_alt_tm");
	String est_dt[] 	= request.getParameterValues("t_est_dt");
	String alt_prn[] 	= request.getParameterValues("t_alt_prn");
	String alt_int[] 	= request.getParameterValues("t_alt_int");
	String alt_amt[] 	= request.getParameterValues("t_alt_amt");
	String alt_rest[] 	= request.getParameterValues("t_rest_amt");
	String pay_dt[] 	= request.getParameterValues("t_pay_dt");
	
	for(int i = 0 ; i < tot_amt_tm ; i++)
	{	
		DebtScdBean debt = d_db.getADebtScd(car_id, alt_tm[i]);
		debt.setAlt_est_dt(est_dt[i]);
		debt.setAlt_prn(alt_prn[i].equals("")?0:Util.parseDigit(alt_prn[i]));
		debt.setAlt_int(alt_int[i].equals("")?0:Util.parseDigit(alt_int[i]));
		debt.setPay_dt(pay_dt[i]);
		debt.setAlt_rest(alt_rest[i].equals("")?0:Util.parseDigit(alt_rest[i]));
		debt.setR_alt_est_dt(af_db.getValidDt(debt.getAlt_est_dt()));
		
		if(!d_db.updateDebtScd(debt))	flag += 1;
	}
	
	//관련담당자 메시지 발송
	if(!update_msg.equals("")){
		
		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		if(!car_id.equals("")){
			cr_bean = crd.getCarRegBean(car_id);			
		}
				
		String sub 			= "개별 할부상환스케줄 변동";
		String cont 		= "[ "+l_cd+" "+cr_bean.getCar_no()+" : "+update_msg+" ] 개별 할부상환스케줄 변동되었습니다. 확인바랍니다.";
		
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
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('수정되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('수정되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='debt_scd_u.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
