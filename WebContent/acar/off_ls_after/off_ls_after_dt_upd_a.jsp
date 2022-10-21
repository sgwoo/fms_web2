<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.* , acar.car_register.*, acar.coolmsg.*,  acar.common.*, acar.user_mng.* "%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%

	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String conj_dt 	= request.getParameter("conj_dt")	==null?"":request.getParameter("conj_dt");		
	String est_dt 	= request.getParameter("est_dt")	==null?"":request.getParameter("est_dt");
	String sui_etc 	= request.getParameter("sui_etc")	==null?"":request.getParameter("sui_etc");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");   //사전 등록인 경우 
		
	boolean flag2 = true;
					
	int flag = 0;	
	
	String from_page 	= "off_ls_after_opt_frame.jsp";	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	//확인건
	flag = olsD.updateSuiEtc(car_mng_id, conj_dt, est_dt );
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	String mng_id =  "";
	
	String sub2 	= "";
	String cont2	= "";	
	
	if (sui_etc.equals("Y") ) { 
		mng_id = c_db.getOff_ls_after_sui_Mng_id_l_cd(rent_l_cd); //새로 매입옵션 계약 담당자 가져오는것   - 해지 매입옵션 등록시 
		sub2 	= "매입옵션 관련서류 우편수령 ";
		cont2	= "[차량번호:"+cr_bean.getCar_no()+"] 매입옵션 서류를 고객으로부터  " +  AddUtil.getDate3(conj_dt)    +  "에 수령하였습니다. ";	
	} else {
		mng_id = c_db.getOff_ls_after_sui_Mng_id(car_mng_id); //새로 매입옵션 계약 담당자 가져오는것 추가 20140312 류길선
		sub2 	= "매입옵션 관련서류 우편발송 ";
		cont2	= "[차량번호:"+cr_bean.getCar_no()+"] 매입옵션 관련서류를 고객에게 " +  AddUtil.getDate3(est_dt)   +  "에 우편발송할 예정입니다.";	
	}
	
	String sendphone = "02-392-4243";
	
	
	/*매입옵션 서류 수령 관련 진행예정 현황  담당자에게 메세지 보내기*/
		
	UsersBean sender_bean2 	= umd.getUsersBean(user_id);
		
	String url2 		= "/acar/off_ls_after/off_ls_after_opt_frame.jsp";	 
	
	String target_id2 = mng_id;  	
			
	//사용자 정보 조회
	UsersBean target_bean2 	= umd.getUsersBean(target_id2);
	
	String xml_data2 = "";
	xml_data2 =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub2+"</SUB>"+
  				"    <CONT>"+cont2+"</CONT>"+
 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"</URL>";
	
	xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
	//xml_data2 += "    <TARGET>2006007</TARGET>";
	
	xml_data2 += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+
  				"    <MSGICON>10</MSGICON>"+
  				"    <MSGSAVE>1</MSGSAVE>"+
  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
  				"  </ALERTMSG>"+
  				"</COOLMSG>";
	
	CdAlertBean msg2 = new CdAlertBean();
	msg2.setFlddata(xml_data2);
	msg2.setFldtype("1");
	
	flag2 = cm_db.insertCoolMsg(msg2);
		
	System.out.println("쿨메신저(매입옵션서류수령)"+cr_bean.getCar_no()+"---------------------"+target_bean2.getUser_nm());	
	

%>
<form name='form1' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="car_mng_id" 			value="<%=car_mng_id%>">

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag  >0){ 	%>
	  alert('처리되었습니다');
     fm.action ='<%=from_page%>';				
     fm.target='d_content';		
     fm.submit();

<%	}else{ 			 %>
		alert('오류발생!');
  
<%	
	} %>
</script>
</body>
</html>
