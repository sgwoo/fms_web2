<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*, acar.accid.*, acar.secondhand.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="cr_bean"  class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_bean"  class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="siBn2"    class="acar.cus_reg.Serv_ItemBean" scope="page"/>
<jsp:useBean id="shDb" 	   class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	CusReg_Database    	cr_db 	= CusReg_Database.getInstance();
	CarServDatabase    	csD 	= CarServDatabase.getInstance();
	AccidDatabase      	as_db 	= AccidDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	CarRegDatabase     	crd 	= CarRegDatabase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	


	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;

	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    i_seq 	    = request.getParameter("i_seq")==null?0:AddUtil.parseInt(request.getParameter("i_seq"));
	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 = request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String accid_yn 	= request.getParameter("accid_yn")==null?"":request.getParameter("accid_yn");
	String serv_yn 		= request.getParameter("serv_yn")==null?"":request.getParameter("serv_yn");
	String maint_st 	= request.getParameter("maint_st")==null?"":request.getParameter("maint_st");
	String maint_yn 	= request.getParameter("maint_yn")==null?"":request.getParameter("maint_yn");
	String rep_cont  	= request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String buy_user_nm  = request.getParameter("buy_user_nm")==null?"":request.getParameter("buy_user_nm");

	String value3[] = request.getParameterValues("user_nm");
	String buyer_nm = buy_user_nm;



	//사용자
	UsersBean buyer_bean 	= new UsersBean();
	if(!buyer_nm.equals("")){
		buyer_bean = umd.getUserNmBean(buyer_nm);
	}
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//출금원장
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//출금원장
	PayMngBean bean = pm_db.getPayItem(reqseq, i_seq);
	
	if(bean.getP_gubun().equals("99")){
		bean.setR_est_dt		(request.getParameter("r_est_dt")==null?"":request.getParameter("r_est_dt"));
		bean.setP_gubun			("99");
		bean.setP_cd1			(request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id"));
		bean.setP_cd2			(request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd"));
		bean.setP_cd3			(request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"));
		bean.setP_cd4			(request.getParameter("accid_id")==null?"":request.getParameter("accid_id"));
		bean.setP_cd5			(request.getParameter("serv_id")==null?"":request.getParameter("serv_id"));
		bean.setP_cd6			(request.getParameter("maint_id")==null?"":request.getParameter("maint_id"));
		bean.setP_st1			("99");
		bean.setP_st2			(request.getParameter("acct_code_nm")==null?"5":request.getParameter("acct_code_nm"));
	}
	
	if(pay.getP_way().equals("1")) 	bean.setP_st3("현금");
	if(pay.getP_way().equals("2")) 	bean.setP_st3("선불카드");
	if(pay.getP_way().equals("3")) 	bean.setP_st3("후불카드");
	if(pay.getP_way().equals("4")) 	bean.setP_st3("자동이체");
	if(pay.getP_way().equals("5")) 	bean.setP_st3("계좌이체");
	if(pay.getP_way().equals("7")) 	bean.setP_st3("카드할부");
	
	bean.setI_amt			(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_amt")));
	bean.setI_s_amt			(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_s_amt")));
	bean.setI_v_amt			(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit4(request.getParameter("buy_v_amt")));
	bean.setSub_amt1		(request.getParameter("sub_amt1")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt1")));
	bean.setSub_amt2		(request.getParameter("sub_amt2")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt2")));
	bean.setSub_amt3		(request.getParameter("sub_amt3")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt3")));
	bean.setSub_amt4		(request.getParameter("sub_amt4")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt4")));
	bean.setSub_amt5		(request.getParameter("sub_amt5")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt5")));
	bean.setSub_amt6		(request.getParameter("sub_amt6")==null?0:AddUtil.parseDigit4(request.getParameter("sub_amt6")));
	
	if(acct_code.equals("")){
		acct_code = bean.getAcct_code();
	}else{
		bean.setAcct_code		(acct_code);	
	}
	
	bean.setP_cont			(request.getParameter("p_cont")==null?"":request.getParameter("p_cont"));
	
	bean.setBuy_user_id		(request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id"));//사용자
	if(bean.getBuy_user_id().equals("")){
		bean.setBuy_user_id		(buyer_bean.getUser_id());//사용자
	}
	
	//복리후생비,접대비,여비교통비,차량유류대,차량정비비,통신비
	if(acct_code.equals("81100") || acct_code.equals("81300") || acct_code.equals("81200") || acct_code.equals("45800") || acct_code.equals("45700") || acct_code.equals("45600") || acct_code.equals("46000") || acct_code.equals("81400")){
		bean.setAcct_code_g	(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	}
	//복리후생비&유류대
	if(acct_code.equals("81100") || acct_code.equals("45800")){
		bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	}
	//차량유류비,차량정비비,사고수리비
	if(acct_code.equals("45800") || acct_code.equals("45700") || acct_code.equals("45600") || acct_code.equals("46000")){
		bean.setO_cau		(request.getParameter("o_cau")==null?"":request.getParameter("o_cau"));
		bean.setCall_t_nm	(request.getParameter("call_t_nm")==null?"":request.getParameter("call_t_nm"));
		bean.setCall_t_tel	(request.getParameter("call_t_tel")==null?"":request.getParameter("call_t_tel"));
		bean.setCall_t_chk	(request.getParameter("call_t_chk")==null?"N":request.getParameter("call_t_chk"));  //개시전 재리스
	}
	bean.setUser_su			(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	bean.setUser_cont		(request.getParameter("user_cont")==null?"":request.getParameter("user_cont"));
	bean.setCost_gubun		(request.getParameter("cost_gubun")==null?"":request.getParameter("cost_gubun"));
	
	if(bean.getReqseq().equals("")){
		bean.setReqseq		(reqseq);
		bean.setI_seq		(i_seq);
		
		if(!pm_db.insertPayItem(bean)) flag1 += 1;
	}else{
		if(!pm_db.updatePayItem(bean)) flag1 += 1;
	}


	//사고처리
	if(mode.equals("i") && acct_code.equals("45600")){
		AccidentBean accid = as_db.getAccidentBean(bean.getP_cd3(), bean.getP_cd4());
		//사고 미연결
		if(accid.getCar_mng_id().equals("")){
			String accid_dt 	= request.getParameter("accid_dt")==null?"":request.getParameter("accid_dt");
			String r_accid_dt 	= request.getParameter("r_accid_dt")==null?"":request.getParameter("r_accid_dt");
			
			if(accid_dt.equals("")) accid_dt = r_accid_dt;
			if(accid_dt.equals("")) accid_dt = pay.getP_est_dt();
			
			accid = as_db.getAccidentBeanPay(bean.getP_cd3(), accid_dt, pay.getOff_id(), (int)bean.getI_amt());
			
			if(accid.getCar_mng_id().equals("")){
				if(accid_yn.equals("Y")){//약식등록
				
					accid.setRent_mng_id	(bean.getP_cd1());
					accid.setRent_l_cd		(bean.getP_cd2());
					accid.setCar_mng_id		(bean.getP_cd3());
					accid.setAccid_st		(accid_st);
					accid.setAccid_dt		(accid_dt+""+"0000");
					accid.setReg_dt			(AddUtil.getDate());//접수일자
					accid.setReg_id			(bean.getBuy_user_id());//접수자
					accid.setSettle_st		("0");//처리상태-진행중
					
					String accid_id = as_db.insertAccident(accid);
					
					bean.setP_cd5(accid_id);
				}
			}else{
				bean.setP_cd5(accid.getAccid_id());
			}
		}
	}




	//정비처리 : 차량정비비-일반정비 || 사고수리비
	if(mode.equals("i")){
	if((acct_code.equals("45700") && (acct_code_g.equals("6") || acct_code_g.equals("21"))) || acct_code.equals("45600")){
		
		ServInfoBean siBn = cr_db.getServInfo(bean.getP_cd3(), bean.getP_cd5());
		
		//정비 미연결
		if(siBn.getCar_mng_id().equals("")){
		
			String serv_dt  	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
			String r_serv_dt  	= request.getParameter("r_serv_dt")==null?"":request.getParameter("r_serv_dt");
			String tot_dist 	= request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
			int r_labor 		= request.getParameter("r_labor")==null?0:AddUtil.parseDigit(request.getParameter("r_labor"));
			int r_amt 			= request.getParameter("r_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_amt"));
			int r_dc 			= request.getParameter("r_dc")==null?0:AddUtil.parseDigit(request.getParameter("r_dc"));
			int r_j_amt			= r_amt-r_dc;
			
			
			if(serv_dt.equals("")) serv_dt = r_serv_dt;
			if(serv_dt.equals("")) serv_dt = pay.getP_est_dt();
			
			if(tot_dist.equals("0")){
				//차량정보
				Hashtable sh_ht = shDb.getBase(bean.getP_cd3(), AddUtil.replace(serv_dt,"-",""));
				if(!String.valueOf(sh_ht.get("TODAY_DIST")).equals("null")){
					tot_dist 		= String.valueOf(sh_ht.get("TODAY_DIST"))==null?"":String.valueOf(sh_ht.get("TODAY_DIST"));
				}
			}
			
			siBn = cr_db.getServInfoPay(bean.getP_cd3(), serv_dt, pay.getOff_id(), (int)bean.getI_amt(), rep_cont);
			
			if(siBn.getCar_mng_id().equals("")){
				if(serv_yn.equals("Y")){
					ServiceBean si = new ServiceBean();
					//정비등록처리
					si.setRent_mng_id		(bean.getP_cd1());
					si.setRent_l_cd			(bean.getP_cd2());
					si.setCar_mng_id		(bean.getP_cd3());
					si.setAccid_id			(bean.getP_cd4());
					si.setServ_jc			("9");
					si.setServ_st			("2");
					if(acct_code.equals("45600") && accid_st.equals("4"))					si.setServ_st		("4");//운행자차
					if(acct_code.equals("45600") && accid_st.equals("5"))					si.setServ_st		("5");//사고자차
					if(acct_code.equals("45600") && accid_st.equals("7"))					si.setServ_st		("7");//재리스정비
					if(acct_code.equals("45700") && acct_code_g.equals("21"))				si.setServ_st		("7");//재리스정비
					si.setChecker			(bean.getBuy_user_id());
					si.setServ_dt			(AddUtil.replace(serv_dt,"-",""));
					si.setTot_dist			(tot_dist);
					si.setCust_serv_dt		(si.getServ_dt());
					si.setOff_id			(pay.getOff_id());
					si.setRep_cont			(rep_cont);
					si.setNext_serv_dt		(si.getServ_dt());
					si.setNext_rep_cont		("");
					si.setRep_amt			((int)bean.getI_amt());
					si.setSup_amt			((int)bean.getI_s_amt());
					si.setAdd_amt			((int)bean.getI_v_amt());
					si.setTot_amt			((int)bean.getI_amt());
					if(!pay.getOff_id().equals("000620") && !pay.getOff_id().equals("002105")){
						si.setJung_st		("1");
					}
					si.setReg_id			(user_id);
					
					String serv_id = csD.insertService(si);
					
					//서비스아이템
					siBn2.setCar_mng_id		(bean.getP_cd3());
					siBn2.setServ_id		(serv_id);
					siBn2.setItem			(rep_cont);
					siBn2.setCount			(1);
					siBn2.setPrice			(r_amt+r_labor);
					siBn2.setAmt			(r_amt);
					siBn2.setLabor			(r_labor);
					siBn2.setBpm			("2");
					siBn2.setReg_id			(user_id);
					int si_result = cr_db.insertServItem(siBn2);
					
					siBn = cr_db.getServInfo(bean.getP_cd3(), serv_id);
					siBn.setRep_amt			((int)bean.getI_amt());
					siBn.setSup_amt			((int)bean.getI_s_amt());
					siBn.setAdd_amt			((int)bean.getI_v_amt());
					siBn.setSpdchk_dt		(AddUtil.replace(serv_dt,"-",""));
					siBn.setChecker_st		("3");
					siBn.setSpd_chk			("1:radiobutton30/1:radiobutton31/1:radiobutton32/1:radiobutton33/1:radiobutton11/1:radiobutton12/1:radiobutton13/1:radiobutton14/1:radiobutton15/1:radiobutton16/1:radiobutton17/1:radiobutton18/3:radiobutton19/1:radiobutton10/1:radiobutton0/1:radiobutton1/1:radiobutton2/1:radiobutton4/1:radiobutton5/1:radiobutton6/1:radiobutton7/1:radiobutton9/1:radiobutton8/1:radiobutton3/1:radiobutton24/1:radiobutton25/1:radiobutton26/1:radiobutton27/1:radiobutton28/1:radiobutton29/1:radiobutton23/1:radiobutton22/1:radiobutton21/1:radiobutton20/");
					//정산용
					siBn.setR_labor			(r_labor);
					siBn.setR_amt			(r_amt);
					siBn.setR_dc			(r_dc);
					siBn.setR_j_amt			(r_j_amt);
					siBn.setUpdate_id		(user_id);
					flag3 = cr_db.updateService_g(siBn);
					
					bean.setP_cd5(serv_id);
				}
			}else{
				bean.setP_cd5(siBn.getServ_id());
			}
		}else{
			//정비비 금액수정
			if(siBn.getRep_amt() == 0){
				siBn.setRep_amt		((int)bean.getI_amt());
				siBn.setSup_amt		((int)bean.getI_s_amt());
				siBn.setAdd_amt		((int)bean.getI_v_amt());
				siBn.setTot_amt		((int)bean.getI_amt());
				siBn.setUpdate_id	(user_id);
				flag3 = cr_db.updateService_g(siBn);
			}
		}
	}
	}



	//검사처리 : 차량정비비-정기검사/정밀검사
	if(mode.equals("i")){
	if(acct_code.equals("45700") && (acct_code_g.equals("7") || acct_code_g.equals("8")) ){
		
		cm_bean = crd.getCarMaint(bean.getP_cd3(), bean.getP_cd6());
		
		//검사 미연결
		if(cm_bean.getCar_mng_id().equals("")){
		
			String maint_dt  	= request.getParameter("maint_dt")==null?"":request.getParameter("maint_dt");
			String r_maint_dt  	= request.getParameter("r_maint_dt")==null?"":request.getParameter("r_maint_dt");
			String tot_dist2 	= request.getParameter("tot_dist2")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist2"));
			String maint_st_dt 	= request.getParameter("maint_st_dt")==null?"":AddUtil.ChangeString(request.getParameter("maint_st_dt"));
			String maint_end_dt = request.getParameter("maint_end_dt")==null?"":AddUtil.ChangeString(request.getParameter("maint_end_dt"));
			
			if(maint_dt.equals("")) maint_dt = r_maint_dt;
			if(maint_dt.equals("")) maint_dt = pay.getP_est_dt();
			
			if(tot_dist2.equals("0")){
				//차량정보
				Hashtable sh_ht = shDb.getBase(bean.getP_cd3(), AddUtil.replace(maint_dt,"-",""));
				if(!String.valueOf(sh_ht.get("TODAY_DIST")).equals("null")){
					tot_dist2 		= String.valueOf(sh_ht.get("TODAY_DIST"))==null?"":String.valueOf(sh_ht.get("TODAY_DIST"));
				}
			}
			
			cm_bean = crd.getCarMaintPay(bean.getP_cd3(), maint_dt, (int)bean.getI_amt());
			
			if(cm_bean.getCar_mng_id().equals("")){
				if(maint_yn.equals("Y")){
					
				}
			}else{
				bean.setP_cd6(String.valueOf(cm_bean.getSeq_no()));
			}
		}
	}
	}



	int user_su 	= request.getParameter("user_su")==null?0:AddUtil.parseInt(request.getParameter("user_su"));
	
	String value1[] = request.getParameterValues("user_case_id");
	String value2[] = request.getParameterValues("money");
	
	if(!pm_db.deletePayItemUser(reqseq, i_seq)) flag2 += 1;
	
	int cnt = 0;
	//참가자 등록
	if(user_su > 0){
		for(int i=0;i < user_su;i++){
			int user_pay_amt = value2[i]==null?0:AddUtil.parseDigit(value2[i]);
			if(user_pay_amt>0){
				PayMngUserBean pu_bean = new PayMngUserBean();
				pu_bean.setReqseq	(reqseq);
				pu_bean.setI_seq	(i_seq);
				pu_bean.setU_seq	(i+1);
				pu_bean.setPay_user	(value1[i]==null?"":value1[i]);
				if(pu_bean.getPay_user().equals("")){
					//사용자
					String user_case_nm = value3[i+1]==null?"":AddUtil.replace(value3[i+1]," ","");
					UsersBean pu_user_bean 	= umd.getUserNmBean(user_case_nm);
					pu_bean.setPay_user	(pu_user_bean.getUser_id());
				}
				pu_bean.setPay_amt	(value2[i]==null?0:AddUtil.parseDigit(value2[i]));
				if(!pm_db.insertPayItemUser(pu_bean)) flag3 += 1;
				cnt ++;
			}
		}
	}
	
	
	
	//아이템 변경에 따른 원장 금액변경
	if(!pm_db.updatePayAmt(reqseq)) flag1 += 1;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if('<%=from_page%>' == '')  	fm.action = 'pay_upd_step1_in.jsp';
		else 				fm.action = '<%=from_page%>';		
		fm.target = 'd_content';
		fm.submit();
		
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>  
</form>
<script language='javascript'>
<!--
<%	if(flag1>0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("수정하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
