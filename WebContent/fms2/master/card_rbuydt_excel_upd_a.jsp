<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.* "%>
<%@ include file="/acar/cookies.jsp"%>


<%
	InsDatabase ai_db = InsDatabase.getInstance();

	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//������
	String value1[]  = request.getParameterValues("value1");//û��������
	String value2[]  = request.getParameterValues("value2");//ī���ȣ
	String value3[]  = request.getParameterValues("value3");//�����
	String value4[]  = request.getParameterValues("value4");//�����
	String value5[]  = request.getParameterValues("value5");//���ݾ�
	String value6[]  = request.getParameterValues("value6");//�ŷ�ó
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int size = 0;
	int flag = 0;
	
	for(int i=start_row ; i <= value_line ; i++){
		
		if (value0[i].length() < 8) continue;
		
		//insertInsExcel

		InsurExcelBean ins = new InsurExcelBean();
		ins.setReg_code		("card"+reg_code);
		ins.setSeq			(i);
		ins.setReg_id		(ck_acar_id);
		ins.setGubun		("1");
		ins.setValue01		(value0[i]);
		ins.setValue02		(value1[i]);
		ins.setValue03		(value2[i]);
		ins.setValue04		(value3[i]);
		ins.setValue05		(value4[i]);
		ins.setValue06		(String.valueOf(AddUtil.parseDigit(value5[i])));
		ins.setValue07		(value6[i]);
		
		if(!ai_db.insertInsExcel(ins)){
			flag += 1;
		}else{
			size++;	
		}
	}
	
	if(size >0){
		String  d_flag1 =  ai_db.call_sp_ins_excel_etc_act("7", "card"+reg_code);
	}
	
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
<form action="" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--
alert('ó���Ǿ����ϴ�. ���ϳ����� 1���̻��̸� ó������ �ʽ��ϴ�.');
//-->
</SCRIPT>
</BODY>
</HTML>