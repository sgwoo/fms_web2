<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_service.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*"%>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//��������ȣ
	String cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //û������
	
	int cust_s_amt 	=  request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt")); //û�� ���ް�
	int cust_v_amt 	=  request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt")); //û�� �ΰ���
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
		
	AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
	
	int flag = 0;	
	int count = 0;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String from_page 	= "";

	String no_dft_yn = request.getParameter("no_dft_yn")==null?"":request.getParameter("no_dft_yn"); //��������

	String 	sac_yn =  request.getParameter("sac_yn")==null?"":request.getParameter("sac_yn"); //Ȯ������	
	
	String 	bill_doc_yn =  request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn"); //��꼭 ���࿩��
		
	int c_amt = AddUtil.parseDigit(request.getParameter("cust_amt"));
	
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);
	
	int old_amt = s_bean.getCust_amt();
	
	s_bean.setCust_amt(request.getParameter("cust_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_amt")));
	s_bean.setCust_req_dt(request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"));
	s_bean.setCust_plan_dt(request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"));
	s_bean.setCust_pay_dt(request.getParameter("cust_pay_dt")==null?"":request.getParameter("cust_pay_dt"));  //���������� �ԱݵȰ�� �Ա��ϸ� ������ �� ����.
	s_bean.setNo_dft_yn(no_dft_yn);//��������
	s_bean.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":request.getParameter("no_dft_cau"));//��������
	s_bean.setBill_doc_yn(bill_doc_yn);  //���ݰ�꼭 ���࿩�� 0:�̹��� 1:��������
	s_bean.setBill_mon(request.getParameter("bill_mon")==null?"":request.getParameter("bill_mon"));		
	s_bean.setUpdate_id(user_id);//������
	s_bean.setUpdate_dt(AddUtil.getDate());//��������
	s_bean.setExt_amt(request.getParameter("ext_amt")==null?0:AddUtil.parseDigit(request.getParameter("ext_amt"))); //���Աݾ�
	s_bean.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_s_amt"))); //��������� ���Աݾ�
	s_bean.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_v_amt"))); //��������� ���Աݾ�
	s_bean.setCls_amt(request.getParameter("cls_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_amt"))); //��������� ���Աݾ�
	s_bean.setCust_s_amt(request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt"))); //û�� ���ް���
	s_bean.setCust_v_amt(request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt"))); //û�� �ΰ�����
	s_bean.setExt_cau(request.getParameter("ext_cau")==null?"":request.getParameter("ext_cau"));//���Աݳ���
		
		// ��å�� ����� Ȯ��ó��
	if(!a_csd.updateServiceSac(c_id, serv_id))	flag += 1;			

	int cnt = 0;
	//��å�� ������ �ۼ� ����
	cnt = a_csd.getServiceScdExt(s_bean);
	if ( cnt < 1) {
	   if( !serv_id.equals("")  ){	
		   count = a_csd.insertServiceScdExt(s_bean);
	   }
	}					
		//�ݾ� ������ ��� - �Ա��� �ȵ� ��
	if(!serv_id.equals("") && c_amt != old_amt && s_bean.getCust_pay_dt().equals("")){
//	if(!serv_id.equals("") && c_amt > 0){
		count = a_csd.getServiceScdExtAmt(s_bean);
	}		
	//������ ������ ���
	if (no_dft_yn.equals("Y")) {
		count = a_csd.updateServiceScdExt(s_bean);
	}

//��å���� 0���� ������ ��� bill_yn = 'N' , ��å�� ������ ���� �ȵȰ�� ���� (���Աݺ� ��) -????
//	if(!serv_id.equals("") && c_amt == 0 && no_dft_yn.equals("")){
	if(!serv_id.equals("") && c_amt == 0 ){
		count = a_csd.updateServiceScdExt(s_bean);
	}
	
	// �ι���ī �������� ������ ��û���� ����
	if (  c_id.equals("005938") && accid_id.equals("014279") ) {
		
	} else {
		
		if (bill_doc_yn.equals("1")) {				
			//���ݰ�꼭 �����Ƿ� �޼��� ����  ->��꼭 ���࿩�� 			
		   //�����ȸ - ������ 
			Hashtable ht_c = as_db.getRentCase(m_id, l_cd);
						
				
		  //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
			String sub 	= "��å�ݰ�꼭�����û";
			String cont 	= "�� ��å�ݰ�꼭�����û  &lt;br&gt; &lt;br&gt;  "+ String.valueOf(ht_c.get("FIRM_NM"))+ " &lt;br&gt; &lt;br&gt;  " + String.valueOf(ht_c.get("CAR_NO")) + " &lt;br&gt; &lt;br&gt; ����Ͻ�:" + accid.getAccid_dt() + ", û������:" + cust_req_dt + "���ް�:"+ cust_s_amt + ", �ΰ�:"+cust_v_amt ;  	
										
			String url 	= "";		 
			
			url 		= "/tax/issue_3/issue_3_sc4.jsp";		 
				
			String target_id = nm_db.getWorkAuthUser("���ݰ�꼭�����");  //��å�� ��꼭 �����
			
			//�ް��� ���			
			CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  		
	
			if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id(); //��ü�ٹ���
				
					
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//	xml_data += "    <TARGET>2006007</TARGET>";
			
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
			
			flag2 = cm_db.insertCoolMsg(msg);
				
			System.out.println("��޽���(��å�ݰ�꼭�����Ƿ�)"+ String.valueOf(ht_c.get("CAR_NO"))+"---------------------"+target_bean.getUser_nm());	
		
		}							
	}
			
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="serv_id" value='<%=serv_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//��å�� Ȯ�� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//��å�� Ȯ�� ����.. %>
	
    alert('ó���Ǿ����ϴ�');
    fm.action = "accid_u_frame.jsp";		
	fm.target = "d_content";
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
