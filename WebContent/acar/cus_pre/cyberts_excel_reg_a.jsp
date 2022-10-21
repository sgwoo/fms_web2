<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	//����	�ڵ�����Ϲ�ȣ	�����ȣ	����/��ȣ	����	��ȿ�Ⱓ������	�˻�������
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//�ڵ�����Ϲ�ȣ��
	String value1[]  = request.getParameterValues("value1");//�����ȣ
	String value2[]  = request.getParameterValues("value2");//����/��ȣ
	String value3[]  = request.getParameterValues("value3");//����
	String value4[]  = request.getParameterValues("value4");//��ȿ�Ⱓ������
	String value5[]  = request.getParameterValues("value5");//�˻�������
	String value6[]  = request.getParameterValues("value6");//���ɸ�����
	String value7[]  = request.getParameterValues("value7");//���
	String value8[]  = request.getParameterValues("value8");//���ʵ����

	String car_no = "";			//������ȣ
	
	String vid_num = "";
	String che_1 = "";
	String che_2 = "";
	String che_3 = "";
	String che_4 = "";
	String che_5 = "";
	String che_6 = "";
	String che_7 = "";
	String che_8 = "";
			
	boolean flag = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	mc_db.deleteCyberts();
	
	for(int i=start_row ; i < value_line ; i++){
			
		car_no 	= value0[i] ==null?"":value0[i];  //������ȣ
	
		che_1		= value1[i] ==null?"":value1[i]; 	//�����ȣ
		che_2		= value2[i] ==null?"":value2[i]; 	//����/��ȣ
		che_3		= value3[i] ==null?"":value3[i];	//����
		che_4		= value4[i] ==null?"":value4[i];	//��ȿ�Ⱓ������
		che_5		= value5[i] ==null?"":value5[i];	//�˻�������
		che_6		= value6[i] ==null?"":value6[i];	//���ɸ�����
		che_7		= value7[i] ==null?"":value7[i];	//���
		che_8		= value8[i] ==null?"":value8[i];	//���ʵ����
	
		CarMaintReqBean cmrb = new CarMaintReqBean();
			
		Hashtable ht = mc_db.getCarMngID(car_no);  //����ȣ
		
		//���
		cmrb.setM1_no		(car_no);  //������ȣ		
		cmrb.setChe_type	(che_5);	//�˻�������	 
		cmrb.setChe_nm		(che_3);  //����
		cmrb.setReq_dt		(che_4); //��ȿ�Ⱓ������
		cmrb.setM1_content(che_1); //�����ȣ
		cmrb.setM1_dt(che_8);  //���ʵ����
		cmrb.setJung_dt(che_6);  // ���ɸ�����
		cmrb.setGubun(che_7);  // ���
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));	
/*
		System.out.println("<br>");
		System.out.println(car_no+"<br>");
		System.out.println(car_mng_id);	
		System.out.println(rent_l_cd);
*/
		if(mc_db.insertCyberts(cmrb)){
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
<form action="cyberts_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("����ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='car_no'     value='<%=value0[i] ==null?"":value0[i]%>'>
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