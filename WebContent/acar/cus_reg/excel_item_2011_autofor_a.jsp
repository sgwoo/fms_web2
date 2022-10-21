<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus_reg.*"%>

<%
	Cookie cookies[] = request.getCookies();
	String ck_acar_id = "";
	if(cookies != null){ //��Ű�� ������
		for (int i = 0 ; i < cookies.length ; i++){
			String name = cookies[i].getName();
			
			if (name.equals("acar_id")) {//����� ���̵�
				ck_acar_id =  cookies[i].getValue();
			}
		}
	}
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0"); //A ����
	String value1[]  = request.getParameterValues("value1"); //B ����
	String value2[]  = request.getParameterValues("value2"); //C NO
	String value3[]  = request.getParameterValues("value3"); //D ����
	String value4[]  = request.getParameterValues("value4"); //E �۾��׸� �� ��ǰ��ȣ
	String value5[]  = request.getParameterValues("value5"); //F ����
	String value6[]  = request.getParameterValues("value6"); //G �۾�
	String value7[]  = request.getParameterValues("value7"); //H H,Q,%
	String value8[]  = request.getParameterValues("value8"); //I ��ǰ�ڵ�
	String value9[]  = request.getParameterValues("value9"); //J ��ǰ��
	String value10[] = request.getParameterValues("value10");//K ���Ӿ�
	String value11[] = request.getParameterValues("value11");//L ���
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
		siBn.setItem_st		("-");
		String item_st = value2[i] ==null?"":AddUtil.replace(value2[i],"?","");
		if(item_st.equals("")){
			siBn.setItem_st		("���۾�");
		}
		siBn.setItem_id		("-");
		siBn.setItem		(value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));//B�۾�����
		siBn.setWk_st		(value5[i] ==null?"-":AddUtil.replace(value5[i],"?",""));//G�۾���
		siBn.setCount		(value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"?","")));//D����
//		siBn.setItem_cd		(value0[i] ==null?"":AddUtil.replace(value0[i],"?",""));//A�ڵ�
		siBn.setItem_cd		("-");
		siBn.setAmt			(value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],"?","")));//E��ǰ��
		siBn.setLabor		(value10[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value10[i],"?","")));//F���Ӿ�
		siBn.setPrice		(siBn.getAmt()+siBn.getLabor());
		siBn.setBpm			("2");
		siBn.setReg_id		(ck_acar_id);
				
		
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