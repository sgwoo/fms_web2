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
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");   //���� ����� ��� 
		
	boolean flag2 = true;
					
	int flag = 0;	
	
	String from_page 	= "off_ls_after_opt_frame.jsp";	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	//Ȯ�ΰ�
	flag = olsD.updateSuiEtc(car_mng_id, conj_dt, est_dt );
	
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	String mng_id =  "";
	
	String sub2 	= "";
	String cont2	= "";	
	
	if (sui_etc.equals("Y") ) { 
		mng_id = c_db.getOff_ls_after_sui_Mng_id_l_cd(rent_l_cd); //���� ���Կɼ� ��� ����� �������°�   - ���� ���Կɼ� ��Ͻ� 
		sub2 	= "���Կɼ� ���ü��� ������� ";
		cont2	= "[������ȣ:"+cr_bean.getCar_no()+"] ���Կɼ� ������ �����κ���  " +  AddUtil.getDate3(conj_dt)    +  "�� �����Ͽ����ϴ�. ";	
	} else {
		mng_id = c_db.getOff_ls_after_sui_Mng_id(car_mng_id); //���� ���Կɼ� ��� ����� �������°� �߰� 20140312 ���漱
		sub2 	= "���Կɼ� ���ü��� ����߼� ";
		cont2	= "[������ȣ:"+cr_bean.getCar_no()+"] ���Կɼ� ���ü����� ������ " +  AddUtil.getDate3(est_dt)   +  "�� ����߼��� �����Դϴ�.";	
	}
	
	String sendphone = "02-392-4243";
	
	
	/*���Կɼ� ���� ���� ���� ���࿹�� ��Ȳ  ����ڿ��� �޼��� ������*/
		
	UsersBean sender_bean2 	= umd.getUsersBean(user_id);
		
	String url2 		= "/acar/off_ls_after/off_ls_after_opt_frame.jsp";	 
	
	String target_id2 = mng_id;  	
			
	//����� ���� ��ȸ
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
		
	System.out.println("��޽���(���ԿɼǼ�������)"+cr_bean.getCar_no()+"---------------------"+target_bean2.getUser_nm());	
	

%>
<form name='form1' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="car_mng_id" 			value="<%=car_mng_id%>">

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag  >0){ 	%>
	  alert('ó���Ǿ����ϴ�');
     fm.action ='<%=from_page%>';				
     fm.target='d_content';		
     fm.submit();

<%	}else{ 			 %>
		alert('�����߻�!');
  
<%	
	} %>
</script>
</body>
</html>
