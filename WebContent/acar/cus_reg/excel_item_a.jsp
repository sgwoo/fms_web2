<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus_reg.*"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//��ȣ
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");//�۾��׸� �� ��ȯ��ǰ
	String value5[]  = request.getParameterValues("value5");//�۾�
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");//H,Q,%
	String value8[]  = request.getParameterValues("value8");//��ǰ�ڵ�
	String value9[]  = request.getParameterValues("value9");//��ǰ����
	String value10[] = request.getParameterValues("value10");//����
	String value11[] = request.getParameterValues("value11");//���
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	
	int flag = 0;
	int error = 0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		Serv_ItemBean siBn = new Serv_ItemBean();
		siBn.setCar_mng_id	(car_mng_id);
		siBn.setServ_id		(serv_id);
		siBn.setItem_st		("���۾�");
		siBn.setItem_id		("");
		siBn.setItem		(value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));
		siBn.setWk_st		(value5[i] ==null?"":AddUtil.replace(value5[i],"?",""));
		siBn.setCount		(value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"?","")));
		siBn.setItem_cd		(value8[i] ==null?"":AddUtil.replace(value8[i],"?",""));
		siBn.setPrice		(0);
		siBn.setAmt			(value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],"?","")));
		siBn.setLabor		(value10[i] ==null?0:AddUtil.parseDigit(AddUtil.replace(value10[i],"?","")));
		siBn.setBpm			("2");
		siBn.setReg_id		(user_id);
		
		if(siBn.getItem().equals("")) continue;
		
		//�ߺ�üũ
		//if(cr_db.getServ_itemCheck(siBn.getCar_mng_id(), siBn.getServ_id(), siBn.getItem(), siBn.getLabor(), siBn.getAmt()) == 0){
			if(cr_db.insertServItem(siBn) == 0) error++;
		//}
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ����(û��)������ ����ϱ�
</p>
<SCRIPT LANGUAGE="JavaScript">
<!--		
<%	if(error > 0){//�����߻��� �ʱ�ȭ
		flag = cr_db.delServ_item_all(car_mng_id, serv_id);%>
		document.write("�����߻�");
<%	}else{%>
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
<%	}%>
//-->
</SCRIPT>
</BODY>
</HTML>