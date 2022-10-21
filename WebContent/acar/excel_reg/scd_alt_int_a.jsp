<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.debt.*, acar.cont.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_register.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	int t_fst_pay_amt = request.getParameter("t_fst_pay_amt")==null?0:AddUtil.parseDigit(request.getParameter("t_fst_pay_amt"));
	String update_msg = request.getParameter("update_msg")==null?"": request.getParameter("update_msg");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//회차
	String value1[]  = request.getParameterValues("value1");//이자
	
	String alt_tm 		= "";
	int alt_int 		= 0;
	
	boolean flag = true;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	for(int i=start_row ; i < value_line ; i++){
	
		alt_tm 			= value0[i] ==null?"":String.valueOf(AddUtil.parseInt(AddUtil.replace(value0[i]," ","")));
		alt_int			= value1[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value1[i],"_","")," ",""));
		
		//상환스케줄정보
		DebtScdBean pay_scd = new DebtScdBean();
		pay_scd = d_db.getADebtScd(car_id, alt_tm);
		pay_scd.setAlt_int	(alt_int);
		if(alt_int > 0 && (pay_scd.getAlt_prn()+pay_scd.getAlt_int() > t_fst_pay_amt || pay_scd.getAlt_prn()+pay_scd.getAlt_int() < t_fst_pay_amt)){
			pay_scd.setAlt_prn(t_fst_pay_amt-pay_scd.getAlt_int());
		}
		flag = d_db.updateDebtScd(pay_scd);
			
		if(flag){
			result[i] = "정상처리되었습니다.";
		}else{
			result[i] = "스케줄 등록시 오류";
		}
	}
	
	Vector debts = d_db.getDebtScd(car_id);
	int debt_size = debts.size();
	
	int alt_rest = 0;
	
	for(int i = 0 ; i < debt_size ; i++){
		DebtScdBean a_debt = (DebtScdBean)debts.elementAt(i);
		if(i > 0){
			a_debt.setAlt_rest(alt_rest-a_debt.getAlt_prn());
			flag = d_db.updateDebtScd(a_debt);
		}
		alt_rest = a_debt.getAlt_rest();		
	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	
	int ment_cnt=0;
	
	//관련담당자 메시지 발송
	if(!update_msg.equals("")){

		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		if(!car_id.equals("")){
			cr_bean = crd.getCarRegBean(car_id);			
		}
				
		String sub 			= "개별 할부상환스케줄 변동";
		String cont 		= "[ "+car_id+" "+cr_bean.getCar_no()+" : "+update_msg+" ] 개별 할부상환스케줄 변동되었습니다. 확인바랍니다.";
		
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
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 보험 등록하기
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리되었습니다.")) continue;
		ment_cnt++;%>
<input type='hidden' name='value0' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='value1' value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result' value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='ment_cnt' value='<%=ment_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>