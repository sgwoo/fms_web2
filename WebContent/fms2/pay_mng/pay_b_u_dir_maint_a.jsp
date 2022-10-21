<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*, acar.accid.*, acar.secondhand.*, acar.user_mng.*, acar.car_register.*"%>
<%@ page import="acar.coolmsg.*, tax.* "%>
<jsp:useBean id="cr_bean"  class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_bean"  class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.cus_reg.Car_MaintBean" scope="page"/>
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
	AccidDatabase      	as_db 	= AccidDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	CarRegDatabase     	crd 	= CarRegDatabase.getInstance();
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
	
	//검사처리 : 차량정비비-자동차검사
	if(acct_code.equals("45700") && acct_code_g.equals("7")) ){
		
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
				if(!String.valueOf(sh_ht.get("TOT_DIST")).equals("null")){
					tot_dist2 		= String.valueOf(sh_ht.get("TOT_DIST"))==null?"":String.valueOf(sh_ht.get("TOT_DIST"));
				}
			}
			
			cm_bean = crd.getCarMaintPay(bean.getP_cd3(), maint_dt, (int)bean.getI_amt());
			
			if(cm_bean.getCar_mng_id().equals("")){
					cr_bean = crd.getCarRegBean(bean.getP_cd3());
					
					//검사등록처리
					cm_bean2.setCar_mng_id		(bean.getP_cd3());
					if(maint_st.equals("1")){
					 	cm_bean2.setChe_kd		("1");				//점검종별-정기검사
						cm_bean2.setChe_st_dt	(cr_bean.getMaint_st_dt());			//점검정비유효기간1
						cm_bean2.setChe_end_dt	(cr_bean.getMaint_end_dt());		//점검정비유효기간2
					}else if(maint_st.equals("2")){
					 	cm_bean2.setChe_kd		("2");				//점검종별-정기정밀
						cm_bean2.setChe_st_dt	(cr_bean.getMaint_st_dt());			//점검정비유효기간1
						cm_bean2.setChe_end_dt	(cr_bean.getMaint_end_dt());		//점검정비유효기간2
					}else if(maint_st.equals("3")){
					 	cm_bean2.setChe_kd		("3");				//점검종별-정기점검
						cm_bean2.setChe_st_dt	(cr_bean.getTest_st_dt());			//점검정비유효기간1
						cm_bean2.setChe_end_dt	(cr_bean.getTest_end_dt());		//점검정비유효기간2
					}
					cm_bean2.setChe_dt			(maint_dt);					//점검정비점검일자
					cm_bean2.setChe_no			(bean.getBuy_user_id());				//실시자고유번호 
					cm_bean2.setChe_comp		(pay.getOff_nm());			//실시자업체명 
					cm_bean2.setChe_amt			((int)bean.getI_amt());			//검사금액
					cm_bean2.setChe_km			(AddUtil.parseDigit(tot_dist2));				//검사시 주행거리 
					cm_bean2.setMaint_st_dt		(maint_st_dt);				//다음검사유효기간 시작일
					cm_bean2.setMaint_end_dt	(maint_end_dt);  			//다음검사유호기간 만료일
					
					int seq_no = cr_db.insertCarMaint(cm_bean2);
					
					bean.setP_cd6(String.valueOf(seq_no));
					bean.setMaint_reg_yn("Y");
					
					//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
					
					String sub 		= "[출금]검사약식등록";
					String cont 	= "출금원장 등록과 관련하여 차량정비비-검사와 연결되는 검사를 약식으로 등록하였습니다. "+bean.getP_cont();
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
					System.out.println("쿨메신저("+bean.getP_cd3()+" "+bean.getP_cd6()+" [출금원장] 검사약식등록)-----------------------"+target_bean.getUser_nm());
					
					//3. SMS 등록-------------------------------
					String smsg			= sub+":"+bean.getP_cont();
					String sendname 	= "(주)아마존카";
					String sendphone 	= "02-392-4243";
					IssueDb.insertsendMail(sendphone, sendname, target_bean.getUser_m_tel(), target_bean.getUser_nm(), "", "", smsg);
			}else{
				bean.setP_cd6(String.valueOf(cm_bean.getSeq_no()));
			}
			if(!pm_db.updatePayItem(bean)) flag1 += 1;
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
