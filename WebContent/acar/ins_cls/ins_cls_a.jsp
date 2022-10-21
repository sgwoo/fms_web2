<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//자동차관리번호
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");//보험종류-영업용/업무용
	String ins_kd = request.getParameter("ins_kd")==null?"":request.getParameter("ins_kd");//담보종류-전담보/책임보험
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");//해지구분
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	int flag = 0;
	String exp_yn1 = "N";
	
	InsDatabase ins_db = InsDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//보험 중도해지 처리+보험료 수정
	InsurBean ins2 = ins_db.getInsCase(c_id, ins_st);
	if(!cls_st.equals("2")){//보험해지		
		ins2.setIns_sts("3");	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
	}else{//보험승계
		ins2.setIns_sts("5");	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험, 5:승계
	}
	ins2.setUpdate_id(user_id);
	if(ins2.getCom_emp_yn().equals("Y")){
		// ins_com_emp_info 에 데이터가 있는지 확인			
		if(ins_db.getInsComEmpInfoCnt(c_id, ins_st) > 0){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	        Calendar c1 = Calendar.getInstance();
	        String strToday = sdf.format(c1.getTime());
			String ins_ext_dt = strToday;
			
			if(!ins_db.updateInsComEmpInfo(c_id, ins_st, ins_ext_dt, user_id ))	flag += 1;
		}
	}
	
	if(!ins_db.updateIns(ins2))	flag += 1;

	//보험해지등록
	InsurClsBean ins = new InsurClsBean();
	
	ins.setCar_mng_id		(c_id);
	ins.setIns_st			(ins_st);
	ins.setCls_st			(cls_st);
	ins.setExp_st			(request.getParameter("exp_st"		)==null?"":request.getParameter("exp_st"	));
	ins.setExp_aim			(request.getParameter("exp_aim"		)==null?"":request.getParameter("exp_aim"	));
	ins.setExp_dt			(request.getParameter("exp_dt"		)==null?"":request.getParameter("exp_dt"	));
	ins.setReq_dt			(request.getParameter("req_dt"		)==null?"":request.getParameter("req_dt"	));
	
	if(!cls_st.equals("2")){
		if(ins_kd.equals("2")){//책임보험
			ins.setUse_day1	(request.getParameter("use_day"	)==null?0 :Util.parseDigit(request.getParameter("use_day")));
			ins.setUse_amt1	(request.getParameter("use_amt"	)==null?0 :Util.parseDigit(request.getParameter("use_amt")));
			ins.setExp_yn1	(request.getParameter("exp_yn"	)==null?"N":request.getParameter("exp_yn"	));
		}else{//종합보험
			String use_day[] = request.getParameterValues("use_day");
			String use_amt[] = request.getParameterValues("use_amt");
			String exp_yn[] = request.getParameterValues("exp_yn");
			ins.setUse_day1	(AddUtil.parseDigit(use_day[0]));
			ins.setUse_day2	(AddUtil.parseDigit(use_day[1]));
			ins.setUse_day3	(AddUtil.parseDigit(use_day[2]));
			ins.setUse_day4	(AddUtil.parseDigit(use_day[3]));
			ins.setUse_day5	(AddUtil.parseDigit(use_day[4]));
			ins.setUse_day6	(AddUtil.parseDigit(use_day[5]));
			ins.setUse_day7	(AddUtil.parseDigit(use_day[6]));
			ins.setUse_amt1	(AddUtil.parseDigit(use_amt[0]));
			ins.setUse_amt2	(AddUtil.parseDigit(use_amt[1]));
			ins.setUse_amt3	(AddUtil.parseDigit(use_amt[2]));
			ins.setUse_amt4	(AddUtil.parseDigit(use_amt[3]));
			ins.setUse_amt5	(AddUtil.parseDigit(use_amt[4]));
			ins.setUse_amt6	(AddUtil.parseDigit(use_amt[5]));
			ins.setUse_amt7	(AddUtil.parseDigit(use_amt[6]));
			if(exp_yn==null){
				ins.setExp_yn1	("N");
			}else{
				ins.setExp_yn1	(exp_yn[0]==null?"N":exp_yn[0]);
				exp_yn1 = exp_yn[0]==null?"N":exp_yn[0];
			}
			ins.setExp_yn2	("N");
			ins.setExp_yn3	("N");
			ins.setExp_yn4	("N");
			ins.setExp_yn5	("N");
			ins.setExp_yn6	("N");
			ins.setExp_yn7	("N");
		}
		ins.setTot_ins_amt	(request.getParameter("tot_ins_amt"	)==null?0 :Util.parseDigit(request.getParameter("tot_ins_amt"	)));
		ins.setTot_use_amt	(request.getParameter("tot_use_amt"	)==null?0 :Util.parseDigit(request.getParameter("tot_use_amt"	)));
		ins.setNopay_amt	(request.getParameter("nopay_amt"	)==null?0 :Util.parseDigit(request.getParameter("nopay_amt"		)));
		ins.setRtn_est_amt	(request.getParameter("rtn_est_amt"	)==null?0 :Util.parseDigit(request.getParameter("rtn_est_amt"	)));
		ins.setRtn_amt		(request.getParameter("rtn_amt"		)==null?0 :Util.parseDigit(request.getParameter("rtn_amt"		)));
		ins.setRtn_dt		(request.getParameter("rtn_dt"		)==null?"":request.getParameter("rtn_dt"	)); 
		ins.setDif_amt		(request.getParameter("dif_amt"		)==null?0 :Util.parseDigit(request.getParameter("dif_amt"		)));
		ins.setDif_cau		(request.getParameter("dif_cau"		)==null?"":request.getParameter("dif_cau"	)); 
	}
	ins.setReg_id			(user_id);
	
	
	if(!ins_db.insertInsCls(ins))	flag += 1;

	if(!cls_st.equals("2")){//보험해지
		//미납 보험료 스케줄 삭제
		//if(!ins_db.dropInsScd(c_id, ins_st))	flag += 1;
		
		//보험스케줄-해지보험료 스케줄생성시 필요
		Vector ins_scd = ins_db.getInsScds(c_id, ins_st);
		int ins_scd_size = ins_scd.size();
		
		//해지보험료 스케줄 생성
		InsurScdBean scd = new InsurScdBean();
		scd.setCar_mng_id	(c_id);
		scd.setIns_st		(ins_st);
		scd.setIns_tm		(Integer.toString(ins_scd_size+1));
		scd.setIns_est_dt	(ins.getReq_dt());
		
		if(ins2.getIns_com_id().equals("0008")||ins2.getIns_com_id().equals("0038") ||ins2.getIns_com_id().equals("0007") ){
			String ch_est_dt = c_db.addMonth(ins.getReq_dt(), 1);
			ch_est_dt = ch_est_dt.substring(0,8)+"10";
			scd.setIns_est_dt	(ch_est_dt);
		}
		
		scd.setR_ins_est_dt	(ins_db.getValidDt(scd.getIns_est_dt()));
		scd.setPay_amt		(request.getParameter("scd_ins_amt")==null?0 :Util.parseDigit(request.getParameter("scd_ins_amt")));
		scd.setPay_dt		(ins.getRtn_dt());
		if(scd.getPay_dt().equals(""))		scd.setPay_yn("0");
		else								scd.setPay_yn("1");
		scd.setIns_tm2("2");
		
		if(!ins_db.insertInsScd(scd)) flag += 1;
		
	
		
		//업무용 종합보험에서 책임보험으로 전환시 보험 레코드 추가 생성
		int next_ins_st = AddUtil.parseInt(ins_st)+1;
		
		if(car_use.equals("2") && ins_kd.equals("1") && exp_yn1.equals("Y")){
			InsurBean bean = ins_db.getInsCase(c_id, ins_st);
			bean.setIns_st				(Integer.toString(next_ins_st));
			bean.setIns_sts				("1");//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
			bean.setRins_pcp_amt		(request.getParameter("rins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("rins_pcp_amt")));
			bean.setVins_pcp_kd			(request.getParameter("vins_pcp_kd")==null?"":request.getParameter("vins_pcp_kd"));
			bean.setVins_pcp_amt		(0);
			bean.setVins_gcp_kd			(request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd"));
			bean.setVins_gcp_amt		(0);
			bean.setVins_bacdt_kd		(request.getParameter("vins_bacdt_kd")==null?"":request.getParameter("vins_bacdt_kd"));
			bean.setVins_bacdt_kc2		(request.getParameter("vins_bacdt_kc2")==null?"":request.getParameter("vins_bacdt_kc2"));
			bean.setVins_bacdt_amt		(0);
			bean.setVins_canoisr_amt	(0);
			bean.setVins_cacdt_car_amt	(0);
			bean.setVins_cacdt_me_amt	(0);
			bean.setVins_cacdt_cm_amt	(0);
			bean.setVins_cacdt_amt		(0);
			bean.setVins_spe			(request.getParameter("vins_spe")==null?"":request.getParameter("vins_spe"));
			bean.setVins_spe_amt		(0);
			bean.setIns_kd				("2");//책임보험
			bean.setReg_cau				("3");//담보변경
			
		
			if(!ins_db.insertIns(bean))	flag += 1;
		}
	}
	
	//보험해지일경우 기간비용 처리 및 자동전표 생성
	if(cls_st.equals("1") && (ins2.getIns_com_id().equals("0008")||ins2.getIns_com_id().equals("0038") ||ins2.getIns_com_id().equals("0007"))){ //동부화재,렌터카조합 일 경우 미수금 자동전표 처리하기
		
		int scd_ins_amt = request.getParameter("scd_ins_amt")==null?0 :Util.parseDigit(request.getParameter("scd_ins_amt"));
		String p_acct_code = request.getParameter("acct_code")==null?"":request.getParameter("acct_code");//자동전표계정과목
		
		
		
		//기간비용 처리
		boolean b_flag = ins_db.deleteNextPrecostClsInsAct2(c_id, ins_st, ins.getReq_dt(), scd_ins_amt);
		
		
			//자동전표처리용
			Vector vt = new Vector();
			int line = 0;
			int count =0;
			String acct_cont = "[해지보험료환급]"+car_no;
			String acct_code = "";
			
			UsersBean user_bean 	= umd.getUsersBean(user_id);
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
			String insert_id = String.valueOf(per.get("SA_CODE"));
			String dept_code = String.valueOf(per.get("DEPT_CODE"));
			
			//보험사
			Hashtable ins_com = ins_db.getInsCom(ins2.getIns_com_id());
			
			//대여차량선급보험료
			if(ins2.getCar_use().equals("1")){
				acct_code = "13300";
			//리스차량선급보험료
			}else{
				acct_code = "13200";
			}
			
			line++;			
			
			
			//선급보험료
			Hashtable ht1 = new Hashtable();
			ht1.put("DATA_GUBUN", 	"53");
			ht1.put("WRITE_DATE", 	ins.getReq_dt());
			ht1.put("DATA_NO",    	"");
			ht1.put("DATA_LINE",  	String.valueOf(line));
			ht1.put("DATA_SLIP",  	"1");
			ht1.put("DEPT_CODE",  	dept_code);
			ht1.put("NODE_CODE",  	"S101");
			ht1.put("C_CODE",     	"1000");
			ht1.put("DATA_CODE",  	"");
			ht1.put("DOCU_STAT",  	"0");
			ht1.put("DOCU_TYPE",  	"11");
			ht1.put("DOCU_GUBUN", 	"3");
			ht1.put("AMT_GUBUN",  	"4");//대변
			ht1.put("DR_AMT",    	"0");
			ht1.put("CR_AMT",     	scd_ins_amt);
			ht1.put("ACCT_CODE",  	acct_code);
			ht1.put("CHECK_CODE1",	"A19");//전표번호
			ht1.put("CHECK_CODE2",	"A07");//거래처
			ht1.put("CHECK_CODE3",	"A05");//표준적요
			ht1.put("CHECK_CODE4",	"");
			ht1.put("CHECK_CODE5",	"");
			ht1.put("CHECK_CODE6",	"");
			ht1.put("CHECK_CODE7",	"");
			ht1.put("CHECK_CODE8",	"");
			ht1.put("CHECK_CODE9",	"");
			ht1.put("CHECK_CODE10",	"");
			ht1.put("CHECKD_CODE1",	"");//전표번호
			ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
			ht1.put("CHECKD_CODE3",	"");//표준적요
			ht1.put("CHECKD_CODE4",	"");
			ht1.put("CHECKD_CODE5",	"");
			ht1.put("CHECKD_CODE6",	"");
			ht1.put("CHECKD_CODE7",	"");
			ht1.put("CHECKD_CODE8",	"");
			ht1.put("CHECKD_CODE9",	"");
			ht1.put("CHECKD_CODE10","");
			ht1.put("CHECKD_NAME1",	"");//전표번호
			ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
			ht1.put("CHECKD_NAME3",	acct_cont);//표준적요
			ht1.put("CHECKD_NAME4",	"");
			ht1.put("CHECKD_NAME5",	"");
			ht1.put("CHECKD_NAME6",	"");
			ht1.put("CHECKD_NAME7",	"");
			ht1.put("CHECKD_NAME8",	"");
			ht1.put("CHECKD_NAME9",	"");
			ht1.put("CHECKD_NAME10","");
			ht1.put("INSERT_ID",	insert_id);
			
			line++;
			
			//미수금 또는 보통예금
			Hashtable ht2 = new Hashtable();
			ht2.put("DATA_GUBUN", 	"53");
			ht2.put("WRITE_DATE", 	ins.getReq_dt());
			ht2.put("DATA_NO",    	"");
			ht2.put("DATA_LINE",  	String.valueOf(line));
			ht2.put("DATA_SLIP",  	"1");
			ht2.put("DEPT_CODE",  	dept_code);
			ht2.put("NODE_CODE",  	"S101");
			ht2.put("C_CODE",     	"1000");
			ht2.put("DATA_CODE",  	"");
			ht2.put("DOCU_STAT",  	"0");
			ht2.put("DOCU_TYPE",  	"11");
			ht2.put("DOCU_GUBUN", 	"3");
			ht2.put("AMT_GUBUN",  	"3");//차변
			ht2.put("DR_AMT",    	scd_ins_amt);
			ht2.put("CR_AMT",     	"0");
			ht2.put("ACCT_CODE",  	p_acct_code);
			
			if(p_acct_code.equals("10300")){//보통예금
				ht2.put("CHECK_CODE1",	"A03");//금융기관
				ht2.put("CHECK_CODE2",	"F05");//예적금계좌번호
				ht2.put("CHECK_CODE3",	"F10");//자금과목
				ht2.put("CHECK_CODE4",	"A05");//표준적요
				ht2.put("CHECKD_CODE1",	"260");//금융기관
				ht2.put("CHECKD_CODE2",	"140-004-023871");//예적금계좌번호
				ht2.put("CHECKD_CODE3",	"");//자금과목
				ht2.put("CHECKD_CODE4",	"0");//표준적요
				ht2.put("CHECKD_NAME1",	"신한");//금융기관
				ht2.put("CHECKD_NAME2",	"140-004-023871");//예적금계좌번호
				ht2.put("CHECKD_NAME3",	"");//자금과목
				ht2.put("CHECKD_NAME4",	acct_cont);//표준적요
				
			}else{//미수금
				ht2.put("CHECK_CODE1",	"A07");//거래처
				ht2.put("CHECK_CODE2",	"F19");//발생일자
				ht2.put("CHECK_CODE3",	"A19");//전표번호
				ht2.put("CHECK_CODE4",	"A05");//표준적요
				ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
				ht2.put("CHECKD_CODE2",	"");//발생일자
				ht2.put("CHECKD_CODE3",	"");//전표번호
				ht2.put("CHECKD_CODE4",	"0");//표준적요
				ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
				ht2.put("CHECKD_NAME2",	"");//발생일자
				ht2.put("CHECKD_NAME3",	"");//전표번호
				ht2.put("CHECKD_NAME4",	acct_cont);//표준적요
			}
			ht2.put("CHECK_CODE5",	"");
			ht2.put("CHECK_CODE6",	"");
			ht2.put("CHECK_CODE7",	"");
			ht2.put("CHECK_CODE8",	"");
			ht2.put("CHECK_CODE9",	"");
			ht2.put("CHECK_CODE10",	"");
			ht2.put("CHECKD_CODE5",	"");
			ht2.put("CHECKD_CODE6",	"");
			ht2.put("CHECKD_CODE7",	"");
			ht2.put("CHECKD_CODE8",	"");
			ht2.put("CHECKD_CODE9",	"");
			ht2.put("CHECKD_CODE10","");
			ht2.put("CHECKD_NAME5",	"");
			ht2.put("CHECKD_NAME6",	"");
			ht2.put("CHECKD_NAME7",	"");
			ht2.put("CHECKD_NAME8",	"");
			ht2.put("CHECKD_NAME9",	"");
			ht2.put("CHECKD_NAME10","");
			ht2.put("INSERT_ID",	insert_id);
			
			vt.add(ht1);
			vt.add(ht2);
			
			if(line > 0 && vt.size() > 0){

				
				String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getReq_dt(), vt);	//-> neoe_db 변환
				
				if(row_id.equals("")){
					count = 1;
				}
			}
	}
	
%>
<form name='form1' method='post' action='ins_cls_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="c_id" value=''>
<input type='hidden' name="ins_st" value=''>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{	%>
		alert("등록되었습니다");
		var fm = document.form1;
		fm.target = "d_content";		
		fm.submit();
<%	}	%>
</script>
</body>
</html>
