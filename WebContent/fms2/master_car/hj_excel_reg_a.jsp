<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.cus_reg.*, acar.customer.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	String dt1 		= request.getParameter("dt1")==null?"":request.getParameter("dt1");			//����-��������
	String dt2 		= request.getParameter("dt2")==null?"":request.getParameter("dt2");			//����-��������
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//��������
	String value1[]  = request.getParameterValues("value1");//������ȣ
	String value2[]  = request.getParameterValues("value2");//������
	String value3[]  = request.getParameterValues("value3");//���
	String value4[]  = request.getParameterValues("value4");//�ݾ�
	String value5[]  = request.getParameterValues("value5");//���翹����

	
	String m1_no = "";  		//�Ƿ�no
	String mng_id = ""; 		//������
	String car_mng_id  = ""; 
	String rent_l_cd 	= "";
	String m1_dt = "";  		//�Ƿ���
	String m1_chk = "4";  		//�Ƿڱ��� //������ ���
	String che_nm = "" ;
	String  off_id = "";
	
	//3:�����ڵ���,  6: �̽��͹ڴ븮(����),  2:��������� 
	if ( gubun1.equals("1")  ) {
		che_nm = 	 "��������"; //�˻��
		m1_chk = "4";
		off_id = "000286";
	} else if (gubun1.equals("2") ) {
		che_nm = 	 "�����ڵ���"; //�˻��
		m1_chk = "7";
		off_id = "010097";
	} else if (gubun1.equals("3") ) {
		che_nm = 	 "������������"; //�˻��
		m1_chk = "8";
		off_id = "008462";
	} else {
		che_nm = 	 "�������ڵ����˻��"; //�˻��
		m1_chk = "9";
		off_id = "011827";
	}
	
	String reg_dt = ""; 		//�����
	String che_dt = "";  		//�˻���
	String che_type = ""; 		//�˻�����
	int che_amt = 0;  		//�˻�ݾ�
	String req_dt = "";   		//û����
	String car_no = "";			//������ȣ
	String c_no = "";
	String vid_num = "";
	
	boolean flag = true;
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		
		car_no 	= value1[i] ==null?"":value1[i];
		c_no 	= value1[i] ==null?"":value1[i];
	//	c_no		= car_no.substring(car_no.length()-4, car_no.length());
		
	//	m1_no = value0[i] ==null?"":value0[i] + c_no;
//	System.out.println("c_no= " +c_no);
//	System.out.println("m1_no= " +m1_no);
	

		che_dt			= value0[i] ==null?"":value0[i]; //����
		che_type		= value3[i] ==null?"":value3[i];	//�׸�
		che_amt			= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ","")); 	//�ݾ�
		req_dt			= value5[i] ==null?"":value5[i];	//���翹����
		car_no			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");	//������ȣ

		CarMaintReqBean cmrb = new CarMaintReqBean();
		
		
		Hashtable ht = mc_db.speed_Serach(car_no, che_dt);
		
		
		m1_dt 			= cr_db.getMaster_dt(String.valueOf(ht.get("CAR_MNG_ID")));
		

		//���
		cmrb.setM1_no		(m1_no);
		cmrb.setM1_dt		(m1_dt);
		cmrb.setM1_chk		(m1_chk);
		cmrb.setChe_dt		(che_dt);
		cmrb.setChe_type	(che_type);
		cmrb.setChe_amt		(che_amt);
		cmrb.setChe_nm		(che_nm);
		cmrb.setReq_dt		(req_dt);
		cmrb.setM1_content(c_no);
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));
		cmrb.setMng_id		(String.valueOf(ht.get("MNG_ID")));
		cmrb.setOff_id		(off_id);
/*
		System.out.println("<br>");
		System.out.println(car_no+"<br>");
		System.out.println(car_mng_id);
		System.out.println(rent_mng_id);
		System.out.println(rent_l_cd);
*/
		if(mc_db.insertHj_car(cmrb)){
			//�������
			result[i] = "����ó���Ǿ����ϴ�.";
		}else{
			//��Ͽ���
			result[i] = "����� ���� �߻�";
		}				

	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
	
		
	System.out.println(che_nm);
	System.out.println(m1_chk);
	System.out.println(off_id);
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ����ϱ�
</p>
<form action="master_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("����ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='car_no'     value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>