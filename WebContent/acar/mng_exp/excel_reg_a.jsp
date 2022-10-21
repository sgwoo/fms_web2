<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*"%>
<%@ page import="acar.mng_exp.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String exp_st 	= request.getParameter("exp_st")==null?"":request.getParameter("exp_st");	//����-����(3:�ڵ�����)
	String dt1 		= request.getParameter("dt1")==null?"":request.getParameter("dt1");			//����-��������
	String dt2 		= request.getParameter("dt2")==null?"":request.getParameter("dt2");			//����-��������
	
	String result[]  = new String[value_line];
	
	String value0[]  = request.getParameterValues("value0");//������ȣ
	String value1[]  = request.getParameterValues("value1");//������
	String value2[]  = request.getParameterValues("value2");//������
	String value3[]  = request.getParameterValues("value3");//���μ���
	String value4[]  = request.getParameterValues("value4");//��������
	String value5[]  = request.getParameterValues("value5");//����

	
	String car_mng_id 	= "";
	String car_no 		= "";
	String exp_start_dt	= "";
	String exp_end_dt 	= "";
	String exp_est_dt 	= "";
	String exp_dt 			= "";
	String car_ext 		= "";
	int    exp_amt 		= 0;

	boolean flag = true;
	
	
	

	for(int i=start_row ; i < value_line ; i++){
		car_mng_id 	= "";
		car_no 			= value0[i] ==null?"":AddUtil.replace(value0[i]," ","");
		exp_start_dt= value1[i] ==null?"":AddUtil.replace(value1[i],".","");
		exp_end_dt	= value2[i] ==null?"":AddUtil.replace(value2[i],".","");
		exp_amt			= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""));
		exp_est_dt	= value4[i] ==null?"":AddUtil.replace(value4[i],".","");
		car_ext			= value5[i] ==null?"":value5[i];
		
		/*
		System.out.println("GenExp-car_no : "+car_no);
		System.out.println("GenExp-exp_start_dt : "+exp_start_dt);
		System.out.println("GenExp-exp_end_dt : "+exp_end_dt);
		System.out.println("GenExp-exp_amt : "+exp_amt);
		System.out.println("GenExp-exp_est_dt : "+exp_est_dt);
		System.out.println("GenExp-car_ext : "+car_ext);
		*/
		
		
		if(!dt1.equals("")) 	exp_est_dt 	= dt1;
		if(!dt2.equals("")) 	exp_dt 		= dt2;

		//��Ÿ��� ����ó�� ------------------------------------------
		
		if(car_mng_id.equals("")) car_mng_id = ex_db.getCarMngID(exp_st, car_no, exp_est_dt);
		//	System.out.println("GenExp-getCarMngID : "+car_mng_id);
		if(car_mng_id.equals("")) car_mng_id = ex_db.getCarMngIDSui(exp_st, car_no, exp_est_dt);
		//	System.out.println("GenExp-getCarMngIDSui : "+car_mng_id);
		out.println("<br>");
		out.println(car_no+"<br>");
	//	System.out.println("GenExp-car_mng_id : "+car_mng_id);
		
		if(!car_mng_id.equals("N")){
		//System.out.println("GenExp-car_mng_idN : "+car_mng_id);		
			GenExpBean exp = ex_db.getGenExp(car_mng_id, exp_st, exp_est_dt);
			
			if(exp.getCar_mng_id().equals("")){
				//���
				exp.setExp_st		(exp_st);
				exp.setCar_mng_id	(car_mng_id);
				exp.setExp_amt		(exp_amt);
				exp.setExp_est_dt	(exp_est_dt);
				exp.setExp_start_dt	(exp_start_dt);
				exp.setExp_end_dt	(exp_end_dt);
				exp.setExp_dt		(exp_dt);
				exp.setCar_ext		(car_ext);
				exp.setCar_no		(car_no);
				if(ex_db.insertGenExp(exp)){
					//�������
					result[i] = "����ó���Ǿ����ϴ�.";
				}else{
					//��Ͽ���
					result[i] = "����� ���� �߻�";
				}
			}
		}else{
			result[i] = "������ȣ�� �߸� �Ǿ��ų� �̹� ��ϵ� ���Դϴ�.";
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
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("����ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
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