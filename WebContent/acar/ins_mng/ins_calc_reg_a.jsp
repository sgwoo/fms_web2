<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*, acar.car_register.*, acar.coolmsg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String client_st = request.getParameter("client_st")==null?"":request.getParameter("client_st"); 	
	String car_name = request.getParameter("car_name2")==null?"":request.getParameter("car_name2"); 	
	String car_b_p_temp = request.getParameter("car_b_p")==null?"":request.getParameter("car_b_p"); 	 
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm"); 	
	String ssn1 = request.getParameter("ssn1")==null?"":request.getParameter("ssn1"); 	
	String ssn2 = request.getParameter("ssn2")==null?"":request.getParameter("ssn2"); 	
	String tel_com = request.getParameter("tel_com")==null?"":request.getParameter("tel_com"); 	
	String m_tel = request.getParameter("m_tel")==null?"":request.getParameter("m_tel"); 	
	String addr = request.getParameter("addr")==null?"":request.getParameter("addr"); 	
	String age_scp = request.getParameter("age_scp")==null?"":request.getParameter("age_scp"); 	
	String age = request.getParameter("age")==null?"":request.getParameter("age"); 	
	String vins_gcp_kd = request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd"); 	
	String job = request.getParameter("job")==null?"":request.getParameter("job"); 	
	String ins_limit = request.getParameter("ins_limit")==null?"":request.getParameter("ins_limit"); 	
	String com_emp_yn = request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn"); 	
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc"); 	
	String t_zip = request.getParameter("t_zip")==null?"":request.getParameter("t_zip"); 	
	String req_st = request.getParameter("req_st")==null?"":request.getParameter("req_st"); 	
	String enp_no = request.getParameter("enp_no")==null?"":request.getParameter("enp_no"); 	
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm"); 	
	String driver_ssn1 = request.getParameter("driver_ssn1")==null?"":request.getParameter("driver_ssn1"); 	
	String driver_rel = request.getParameter("driver_rel")==null?"":request.getParameter("driver_rel");
	
	String reg_code[] = request.getParameterValues("reg_code"); 
	String ins_cost[] = request.getParameterValues("ins_cost"); 
	int result = 0;
	
	InsCalcBean calc = new InsCalcBean();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	if(age_scp.equals("")){
		age_scp = age;
	}
	
	String ssn ="";
	if(ssn2.equals("")) ssn = ssn1;
	else ssn= ssn1+"-"+ssn2;
	
	
	if(req_st.equals("r") || req_st.equals("u")){ //��� �Ǵ� �����϶�
		int car_b_p = 0;
		if(!car_b_p_temp.equals("")){
			car_b_p_temp = car_b_p_temp.replace(",", "");
			car_b_p =  Integer.parseInt(car_b_p_temp); 
		}else{
			car_b_p = 0;
		}
		
		calc.setClientSt(client_st);
		calc.setCarName(car_name);
		calc.setCarBP(car_b_p);
		calc.setClientNm(client_nm);
		calc.setSsn(ssn);
		calc.setTelCom(tel_com);
		calc.setMTel(m_tel);
		calc.setAddr(addr);
		calc.setAgeScp(age_scp);
		calc.setVinsGcpKd(vins_gcp_kd.replace(" ", ""));
		calc.setJob(job);
		calc.setInsLimit(ins_limit);
		calc.setComEmpYn(com_emp_yn);
		calc.setEtc(etc);
		calc.setTZip(t_zip);
		calc.setUpdateId(user_id);
		calc.setUseSt("��û");
		calc.setEnpNo(enp_no);
		calc.setDriverNm(driver_nm);
		calc.setDriverSsn(driver_ssn1);
		calc.setDriverRel(driver_rel);
		
		
		if(req_st.equals("r")){ //����� ��
			reg_code[0]  = Long.toString(System.currentTimeMillis());
			calc.setRegCode(reg_code[0]);
			calc.setRegId(user_id);
			
			if(ai_db.insertInsCalc(calc)) result++; // ���
			
			//�޼��� ������
			if(result > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				UsersBean tuser  = um.getUsersBean("000130");
				
				boolean flag=false;
				String target_id = tuser.getId();
	          	String target_nm = tuser.getUser_nm();
				
				String title = "���Ǻ�������û";
	        	String sender_id = suser.getId();
	        	String sender_nm = suser.getUser_nm();
				
	        	String cont= "���Ǻ�������û�� ��ϵǾ����ϴ�. Ȯ�κ�Ź�帳�ϴ�.";
	        	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/acar/ins_mng/ins_calc_frame.jsp";
	        	
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
		  					"    <BACKIMG>4</BACKIMG>"+
		  					"    <MSGTYPE>104</MSGTYPE>"+
		  					"    <SUB>"+title+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
		 					"    <URL>"+url+"</URL>";
				xml_data += "    <TARGET>"+target_id+"</TARGET>";
				xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
		  					"    <MSGICON>10</MSGICON>"+
		  					"    <MSGSAVE>1</MSGSAVE>"+
		  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
		  					"  </ALERTMSG>"+
		  					"</COOLMSG>"; 
				
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1"); 
				
				CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
				flag = cm_db.insertCoolMsg(msg);
			}
			
		}
		
		if(req_st.equals("u")){ //������ ��
			calc.setRegCode(reg_code[0]);
			if(ai_db.updateInsCalc(calc)) result++; // ����
		}
	}
	if(req_st.equals("d")){ //������ ��
		if(ai_db.deleteInsCalc(reg_code[0])) result++; // ����
	}
	
	if(req_st.equals("c")){ //������ ����� ��
		int size = reg_code.length;
		for(int i=0; i<size; i++){
			if(!ins_cost[i].equals("")){
				calc.setRegCode(reg_code[i]);
				calc.setInsCost(Integer.parseInt(ins_cost[i].replaceAll(",",""))/12);
				user_id=ck_acar_id;
				calc.setUpdateId(user_id);
				if(ai_db.updateInsCost(calc)) result++; // ��������
				
			}
		}
	}
	
	if(req_st.equals("f")){ //�Ϸ�ó��
		if(ai_db.updateInsCalcUseSt(reg_code[0])) result++; // �Ϸ���
		
		//�޼��� ������
	 	if(result > 0){
			UserMngDatabase um = UserMngDatabase.getInstance();
			UsersBean suser  = um.getUsersBean(ck_acar_id);
			UsersBean tuser  = um.getUsersBean(reg_id);
			
			boolean flag=false;
			String target_id = tuser.getId();
          	String target_nm = tuser.getUser_nm();
			
			String title = "���Ǻ�������û";
        	String sender_id = suser.getId();
        	String sender_nm = suser.getUser_nm();
			
        	String cont= "[ "+car_name+" ] ������ ���� �ݾ��� "+ins_cost[0]+"������ ���� �Ǿ����ϴ�. &lt;br&gt; &lt;br&gt; �ڼ��� ������ FMS ������ > ������� >���Ǻ�������û���� Ȯ�� �ٶ��ϴ�";
        	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/acar/ins_mng/ins_calc_frame.jsp";
        	
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+title+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
	 					"    <URL>"+url+"</URL>";
			xml_data += "    <TARGET>"+target_id+"</TARGET>";
			xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
	  					"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
	  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
	  					"  </ALERTMSG>"+
	  					"</COOLMSG>"; 
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1"); 
			
			CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
			flag = cm_db.insertCoolMsg(msg); 
		}
	}
	
	
%> 
<html>
<head>
<title>FMS</title>
<script>
	var result = '<%=result%>';
	var req_st = '<%=req_st%>'
	if(result > 0){
		if(req_st == 'r'){
			alert("��� �Ϸ�");
			parent.location.href = 'ins_calc_frame.jsp';
		}else if(req_st == 'u'){
			alert("���� �Ϸ�");
			parent.location.href = 'ins_calc_frame.jsp';
		}else if(req_st == 'd'){
			alert("���� �Ϸ�");
			parent.location.href = 'ins_calc_frame.jsp';
		}else if(req_st == 'c'){
			alert("��� �Ϸ�");
			parent.parent.location.href = 'ins_calc_frame.jsp';
		}else if(req_st == 'f'){
			alert("�Ϸ� ó�� Ȯ��");
			location.href = 'ins_calc_frame.jsp';
		}
		
	}else{
		if(req_st == 'r'){
			alert("����� �����Ͽ����ϴ�.");
		}else if(req_st == 'u'){
			alert("����� �����Ͽ����ϴ�.");
		}else if(req_st == 'd'){
			alert("������ �����Ͽ����ϴ�.");
		}else if(req_st == 'c'){
			alert("����� �����Ͽ����ϴ�.");
		}else if(req_st == 'f'){
			alert("�Ϸ�ó���� �����Ͽ����ϴ�.");
			
		}
		
	}
</script>
</head>
<body>

</body>
</html>
