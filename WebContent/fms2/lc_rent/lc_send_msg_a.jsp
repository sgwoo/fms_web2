<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_office.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String fee_size 	= request.getParameter("fee_size")		==null?"":request.getParameter("fee_size");
	String zip_cnt 		= request.getParameter("zip_cnt")		==null?"":request.getParameter("zip_cnt");
	String now_stat	 	= request.getParameter("now_stat")		==null?"":request.getParameter("now_stat");
	
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String msg_st 		= request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	String trf_amt_send 		= request.getParameter("trf_amt_send")==null?"":request.getParameter("trf_amt_send");
	
	

	
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();

	
	//cont 
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	
%>


<%
	if(msg_st.equals("con_amt_pay_req") && pur.getCon_amt_pay_req().equals("")){
	
			pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
			pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
			pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
			pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
			
			pur.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
			pur.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
			pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
			
			if(trf_amt_send.equals("Y") && pur.getTrf_amt_pay_req().equals("")){
				pur.setTrf_st5		(pur.getTrf_st0());
				pur.setCard_kind5	(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
				pur.setCardno5		(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
				pur.setTrf_cont5	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
				pur.setAcc_st5		(pur.getAcc_st0());
				pur.setTrf_est_dt5	(pur.getCon_est_dt());
			}
			
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
			
			flag5 = a_db.updateCarPurPayReq(pur, msg_st);

			if(trf_amt_send.equals("Y") && pur.getTrf_amt_pay_req().equals("")){
				flag5 = a_db.updateCarPurPayReq(pur, "trf_amt_pay_req");
			}
			
			String trf_st0_nm = "송금";
			
			if(pur.getTrf_st0().equals("3")){
				trf_st0_nm = "카드";
			}	

	
			// 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm	= client.getFirm_nm();
			String sub 			= "차량계약금 송금요청";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" "+c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")+" "+emp2.getCar_off_nm()+" "+AddUtil.parseDecimal(pur.getCon_amt())+"원 ] 차량계약금 "+trf_st0_nm+" 요청합니다.";
			String url 			= "";
			String target_id = nm_db.getWorkAuthUser("출금담당");
			String target_id2 = "";
			
			if(msg_st.equals("trf_amt5_pay_req")){
				sub 			= "임시운행보험료 송금요청";
				cont 		= "[ "+rent_l_cd+" "+firm_nm+" "+c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")+" "+emp2.getCar_off_nm()+" "+AddUtil.parseDecimal(pur.getTrf_amt5())+"원 ]  &lt;br&gt; &lt;br&gt; 임시운행보험료 "+trf_st0_nm+" 요청합니다.";
			}
			
			if(trf_amt_send.equals("Y") && pur.getTrf_amt_pay_req().equals("")){
				sub 			= "차량계약금 및 임시운행보험료 송금요청";
				cont 		= "[ "+rent_l_cd+" "+firm_nm+" "+c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")+" "+emp2.getCar_off_nm()+" "+AddUtil.parseDecimal(pur.getCon_amt()+pur.getTrf_amt5())+"원 ]  &lt;br&gt; &lt;br&gt; 차량계약금 및 임시운행보험료 "+trf_st0_nm+" 요청합니다.";
			}
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id2 = nm_db.getWorkAuthUser("입금담당");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
 						
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			if(!target_id2.equals("")){
				UsersBean target_bean2 	= umd.getUsersBean(target_id2);
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			}
			
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
			flag3 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저("+rent_l_cd+" "+sub+" )-----------------------"+target_bean.getUser_nm());
		
	%>
	
<script language='javascript'>
<%		if(!flag3){	%>	
	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');	
<%		}else{%>
	alert('처리되었습니다.');
<%		}%>
</script>

<%	}%>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>
  <input type='hidden' name='rent_st'	 		value=''>
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
</form>
<script language='javascript'>
	var fm = document.form1;
	fm.action = '<%=from_page2%>';
	
	window.close();
	
	fm.target = 'd_content';
		
	<%if(from_page2.equals("/agent/lc_rent/lc_c_c_car.jsp") || from_page2.equals("/fms2/lc_rent/lc_c_c_car.jsp")){%>
		fm.target = 'c_foot';
	<%}%>

	//fm.submit();
	

</script>
</body>
</html>