<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*, acar.accid.*, acar.secondhand.*, acar.user_mng.*, acar.car_register.*"%>
<%@ page import="acar.coolmsg.*, tax.* "%>
<jsp:useBean id="cr_bean"  class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_bean"  class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="siBn2"    class="acar.cus_reg.Serv_ItemBean" scope="page"/>
<jsp:useBean id="shDb" 	   class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="cm_db"    class="acar.coolmsg.CoolMsgDatabase" scope="page" />
<jsp:useBean id="IssueDb"  class="tax.IssueDatabase" scope="page" />
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
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	CusReg_Database    	cr_db 	= CusReg_Database.getInstance();
	CarServDatabase    	csD 	= CarServDatabase.getInstance();
	AccidDatabase      	as_db 	= AccidDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	
	

	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	boolean flag5 = true;
	int flag6 = 0;

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
	int    total_amt1	= request.getParameter("total_amt1")==null?0:AddUtil.parseDigit(request.getParameter("total_amt1"));
	int    total_amt2	= request.getParameter("total_amt2")==null?0:AddUtil.parseDigit(request.getParameter("total_amt2"));
	
	String value3[] = request.getParameterValues("user_nm");
	String buyer_nm = value3[0]==null?"":value3[0];



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
	
	//정비처리 : 차량정비비-일반정비 || 사고수리비
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
				if(!String.valueOf(sh_ht.get("TOT_DIST")).equals("null")){
					tot_dist 		= String.valueOf(sh_ht.get("TOT_DIST"))==null?"":String.valueOf(sh_ht.get("TOT_DIST"));
				}
			}
			
			siBn = cr_db.getServInfoPay(bean.getP_cd3(), serv_dt, pay.getOff_id(), (int)bean.getI_amt(), rep_cont);
			
			if(siBn.getCar_mng_id().equals("")){
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
					int si_result = cr_db.insertServItem(siBn2);
					
					siBn = cr_db.getServInfo(bean.getP_cd3(), serv_id);
					siBn.setRep_amt			((int)bean.getI_amt());
					siBn.setSup_amt			((int)bean.getI_s_amt());
					siBn.setAdd_amt			((int)bean.getI_v_amt());
					siBn.setSpdchk_dt		(AddUtil.replace(serv_dt,"-",""));
					siBn.setChecker_st		("3");
					//정산용
					siBn.setR_labor			(r_labor);
					siBn.setR_amt			(r_amt);
					siBn.setR_dc			(r_dc);
					siBn.setR_j_amt			(r_j_amt);
					flag3 = cr_db.updateService_g(siBn);
					
					if(!pm_db.updateServiceSpdchk(bean.getP_cd3(), serv_id)) flag1 += 1;
					
					bean.setP_cd5(serv_id);
					bean.setServ_reg_yn("Y");
					
					
					//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
					
					String sub 		= "[출금]정비약식등록";
					String cont 	= "출금원장 등록과 관련하여 차량정비비와 연결되는 정비를 약식으로 등록하였습니다. "+bean.getP_cont();
					String target_id = bean.getBuy_user_id();
					
					//사용자 정보 조회
					UsersBean target_bean 	= umd.getUsersBean(target_id);
					
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
  								"    <SUB>"+sub+"</SUB>"+
				  				"    <CONT>"+cont+"</CONT>"+
 								"    <URL></URL>";
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data += "    <SENDER></SENDER>"+
		  						"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
  								"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
  								"</COOLMSG>";
					
					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");
					
					flag5 = cm_db.insertCoolMsg(msg);
					System.out.println("쿨메신저("+bean.getP_cd3()+" "+bean.getP_cd5()+" [출금원장] 정비약식등록)-----------------------"+target_bean.getUser_nm());
					
					//3. SMS 등록-------------------------------
					String smsg 		= sub+":"+bean.getP_cont();
					String sendname 	= "(주)아마존카";
					String sendphone 	= "02-392-4243";
					IssueDb.insertsendMail(sendphone, sendname, target_bean.getUser_m_tel(), target_bean.getUser_nm(), "", "", smsg);
			}else{
				bean.setP_cd5(siBn.getServ_id());
			}
			if(!pm_db.updatePayItem(bean)) flag1 += 1;
		}else{
			//정비비 금액수정
			if(siBn.getRep_amt() == 0){
				siBn.setRep_amt		((int)bean.getI_amt());
				siBn.setSup_amt		((int)bean.getI_s_amt());
				siBn.setAdd_amt		((int)bean.getI_v_amt());
				siBn.setTot_amt		((int)bean.getI_amt());
				flag3 = cr_db.updateService_g(siBn);
			}
		}
	}
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
		fm.action = 'pay_upd_step1_in.jsp';
		fm.target = 'UPDATE_PAY_ITEM';
		fm.submit();
		
		parent.window.close();
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>      
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
