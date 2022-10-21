<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*" %>
<%@ page import="acar.res_search.*, acar.secondhand.*, acar.cont.*, acar.user_mng.* "%>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 		scope="page"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="cm_db" 	class="acar.coolmsg.CoolMsgDatabase" 			scope="page"/>
<jsp:useBean id="a_db" 		class="acar.cont.AddContDatabase" 				scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String cmd 			= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	//�������
	String deli_dt 		= request.getParameter("h_deli_dt")==null?"":AddUtil.replace(request.getParameter("h_deli_dt"),"-","");
	String deli_loc 	= request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc");
	String deli_mng_id 	= request.getParameter("deli_mng_id")==null?"":request.getParameter("deli_mng_id");
	String ret_plan_dt 	= request.getParameter("h_ret_plan_dt")==null?"":request.getParameter("h_ret_plan_dt");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int result = 0;
	boolean flag3 = true;
	int count = 1;
	int count1 = 1;
	int count_cust = 0;
	
	//�ܱ�뿩���� ����
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	
	rc_bean.setDeli_dt2		(deli_dt);
	rc_bean.setDeli_loc		(deli_loc);
	rc_bean.setDeli_mng_id	(deli_mng_id);
	rc_bean.setReg_id		(user_id);
	rc_bean.setUse_st		("2");
	rc_bean.setRet_plan_dt	(ret_plan_dt);
	count = rs_db.updateRentContDeli(rc_bean);
	
	
	rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	
	
//	�����Ͻ� ������ �������� ���⼭�� �ʿ����.
	String rent_st 			= rc_bean.getRent_st();
	String rent_start_dt 	= rc_bean.getRent_start_dt_d();
	String rent_end_dt 		= rc_bean.getRent_end_dt_d();
	String ret_dt 			= rent_end_dt;
	String ret_time 		= "00";
	int use_days 			= 0;
	
	if(rent_end_dt.equals("")){
		if(rent_st.equals("2") || rent_st.equals("3")){			ret_dt = rs_db.addDay	(rc_bean.getDeli_dt_d(), 7); //������
		}else if(rent_st.equals("4") || rent_st.equals("5")){	ret_dt = rs_db.addMonth	(rc_bean.getDeli_dt_d(), 1); //�Ѵ�
		}else{													ret_dt = rs_db.addDay	(rc_bean.getDeli_dt_d(), 3); //3��
		}
		ret_time = rc_bean.getRent_end_dt_h();
	}
	
	//�����ϼ�
	use_days = AddUtil.parseInt(rs_db.getDay(rc_bean.getDeli_dt_d(), ret_dt));
	
	for(int i=0; i<use_days; i++){
		ScdCarBean sc_bean = new ScdCarBean();
		sc_bean.setCar_mng_id	(car_mng_id);
		sc_bean.setRent_s_cd	(rent_s_cd);
		sc_bean.setTm			(i+1);
		sc_bean.setDt			(rs_db.addDay(rc_bean.getDeli_dt_d(), i));
		if(i==0){//�뿩����
			sc_bean.setTime		(rc_bean.getDeli_dt_h());
			sc_bean.setUse_st	("0");
		}else if(i > 0 && i==use_days-1){//�뿩���� ������
			sc_bean.setTime		(ret_time);
			sc_bean.setUse_st	("2");
		}else{//�뿩�Ⱓ
			sc_bean.setTime		("");
			sc_bean.setUse_st	("1");
		}
		sc_bean.setReg_id		(user_id);
		count1 = rs_db.insertScdCar(sc_bean);
	}
	
	
	//����ó���϶� �縮�� ���Ȯ���� �ִٸ� �뺸�Ѵ�.
	
	//�������
	ShResBean srBn = shDb.getShRes2(car_mng_id);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	String memo_title 	= "[����]";
	
	if(srBn.getSituation().equals("2")){
		
		if(rc_bean.getRent_st().equals("1")) 		memo_title += "�ܱ�뿩-";
		else if(rc_bean.getRent_st().equals("2")) 	memo_title += "�������-";
		else if(rc_bean.getRent_st().equals("3")) 	memo_title += "������-";
		else if(rc_bean.getRent_st().equals("9")) 	memo_title += "�������-";
		else if(rc_bean.getRent_st().equals("10")) 	memo_title += "��������-";
		else if(rc_bean.getRent_st().equals("4")) 	memo_title += "�����뿩-";
		else if(rc_bean.getRent_st().equals("5")) 	memo_title += "��������-";
		else if(rc_bean.getRent_st().equals("6")) 	memo_title += "��������-";
		else if(rc_bean.getRent_st().equals("7")) 	memo_title += "��������-";
		else if(rc_bean.getRent_st().equals("8")) 	memo_title += "������-";
		else if(rc_bean.getRent_st().equals("11")) 	memo_title += "�����-";
		
		String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
		String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
		String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
		
		memo_title += car_no+" "+c_firm_nm+" "+c_cust_nm+" "+AddUtil.getTimeHMS();
		
		String sub 		= "�縮�����Ȯ�������� ������ ó�� �뺸";
		String cont 	= memo_title+" --> �縮�����Ȯ�� ���¿��� �����Ǿ����� Ȯ���Ͻñ� �ٶ��ϴ�.";
			
		UsersBean target_bean2 	= umd.getUsersBean(srBn.getDamdang_id());
		
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
					 "    <BACKIMG>4</BACKIMG>"+
					 "    <MSGTYPE>104</MSGTYPE>"+
					 "    <SUB>"+sub+"</SUB>"+
  					 "    <CONT>"+cont+"</CONT>"+
					 "    <URL></URL>";
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					 "    <MSGICON>10</MSGICON>"+
					 "    <MSGSAVE>1</MSGSAVE>"+
					 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
					 "  </ALERTMSG>"+
					 "</COOLMSG>";
		
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
		
		flag3 = cm_db.insertCoolMsg(msg2);
		System.out.println("��޽���(�縮�����Ȯ�������� ������ ���� ó�� �뺸)-----------------------"+cont);
	}
	
	
	//����ó���϶�
	if(rc_bean.getUse_st().equals("2")){
		//���� ����ڰ� �����뿩 ������ ���� ��� ���뿩 ������ ��������ڸ� ��������
		if(rc_bean.getRent_st().equals("4")){
			Hashtable cont_view = a_db.getContViewUseYCarCase(car_mng_id);
			UsersBean mng_bean 	= umd.getUsersBean(rc_bean.getCust_id());
			
			if(!mng_bean.getLoan_st().equals("") && String.valueOf(cont_view.get("CAR_ST")).equals("2") && !rc_bean.getCust_id().equals(String.valueOf(cont_view.get("MNG_ID")))){
				ContBaseBean base = a_db.getCont(String.valueOf(cont_view.get("RENT_MNG_ID")), String.valueOf(cont_view.get("RENT_L_CD")));
				base.setMng_id(rc_bean.getCust_id());
				boolean flag1 = a_db.updateContBaseDeli(base);
				System.out.println("[�����뿩-��� ��������� ����]"+memo_title);
			}
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<form action="car_deli_view.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>		
</form>
<script>
<%	if(!rc_bean.getDeli_dt_d().equals("")){%>		
		document.form1.action = "car_deli_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else{%>
		alert("�����߻�!");
<%	}%>
</script>
</body>
</html>