<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line);
	
	String ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");//����-���������
	String ins_end_dt = request.getParameter("ins_end_dt")==null?"":request.getParameter("ins_end_dt");//����-���踸����
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//�����ȣ
	String value1[]  = request.getParameterValues("value1");//���ǹ�ȣ
	String value2[]  = request.getParameterValues("value2");//������ȣ
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	
	String o_ins_con_no = "";
	String ins_con_no 	= "";
	String car_no 		= "";
	int    ins_amt1 	= 0;
	int    ins_amt2 	= 0;
	int    ins_amt3 	= 0;
	int    ins_amt4 	= 0;
	int    ins_amt5 	= 0;
	int    ins_amt6 	= 0;
	int    ins_amt7 	= 0;
	int flag = 0;
	

	InsDatabase ai_db = InsDatabase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		
		o_ins_con_no 		= value0[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"-",""),"_ ","")," ","");
		ins_con_no 		= value1[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"-",""),"_ ","")," ","");
		car_no 			= value2[i] ==null?"":AddUtil.replace(value2[i]," ","");
		
		//����
		/*
		out.println(value0[i]);
		out.println(value1[i]);
		out.println(value2[i]);
		out.println(value3[i]);
		out.println(value4[i]);
		out.println(value5[i]);
		out.println(value6[i]);
		out.println(value7[i]);
		out.println(value8[i]);
		out.println(value10[i]);
		out.println(value11[i]);
		out.println(value12[i]);
		out.println(value13[i]);
		if(1==1)return;
		*/
		
		
		
		//�ֱٺ��� ��ȸ-------------------------------------------------
		InsurBean ins = ai_db.getInsConNoExcelCase(o_ins_con_no);
		
		if(ins.getIns_start_dt().equals(AddUtil.replace(ins_end_dt,"-",""))){
			InsurBean ins2 = ai_db.getInsCase(ins.getCar_mng_id(), ins.getIns_st());
			ins2.setIns_con_no(ins_con_no);
			ins2.setExp_st("S");
			
			if(!ai_db.updateIns(ins2))	flag = 1;
			
			if(flag != 0)	result[i] = "���� ������ ���� �߻�";
			else			result[i] = "���� �����Ǿ����ϴ�.";
		}else{
			if(!ins.getIns_start_dt().equals(AddUtil.replace(ins_end_dt,"-",""))){
				result[i] = "���������("+ins.getIns_start_dt()+")�� Ʋ���ϴ�.";
			}
		}
		
	}
	int ment_cnt=0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ���� ����ϱ�
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("���� �����Ǿ����ϴ�.")) continue;
		ment_cnt++;%>
<input type='hidden' name='ins_con_no' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='car_no'     value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
//		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>