<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 no
	String value1[]  	= request.getParameterValues("value1");	//2 �����ñ�
	String value2[]  	= request.getParameterValues("value2");	//3 ������ȣ
	String value3[]  	= request.getParameterValues("value3");	//4 ����
	String value4[]  	= request.getParameterValues("value4");
	String value5[]  	= request.getParameterValues("value5");
	String value6[]  	= request.getParameterValues("value6");
	String value7[]  	= request.getParameterValues("value7");
	String value8[]  	= request.getParameterValues("value8");
	String value9[]  	= request.getParameterValues("value9");
	String value10[] 	= request.getParameterValues("value10");
	String value11[] 	= request.getParameterValues("value11");
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	
	
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		int flag = 0;
				
		String car_no 			= value2[i] ==null?"":AddUtil.replace(value2[i]," ","");
		Hashtable ht = t_db.getCarTintInsBlackFileList(car_no);
		int ht_size = ht.size();
		
		
			
		if(ht_size>0){		
			out.println("������ȣ: "+car_no+" ������: "+ht.get("COM_NM")+" �𵨸�: "+ht.get("MODEL_NM")+" �Ϸù�ȣ: "+ht.get("SERIAL_NO")+"<br>");
		}else{
			out.println("������ȣ: "+car_no+" �ش��ϴ� ������ �˻������ �����ϴ�.<br>");
		}						
		
	}
	
	out.println("��ȸ �Ϸ�");
	if(1==1)return;	
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
</form>

<SCRIPT LANGUAGE="JavaScript">
<!--		

//-->
</SCRIPT>
</BODY>
</HTML>