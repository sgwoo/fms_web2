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
	String value0[]  = request.getParameterValues("value0");//A��ȣ
	String value1[]  = request.getParameterValues("value1");//B����
	String value2[]  = request.getParameterValues("value2");//C�۾��׸� �� ��ȯ��ǰ
	String value3[]  = request.getParameterValues("value3");//D����
	String value4[]  = request.getParameterValues("value4");//E�۾�
	String value5[]  = request.getParameterValues("value5");//F����
	String value6[]  = request.getParameterValues("value6");//G��ǰ�ڵ�
	String value7[]  = request.getParameterValues("value7");//H��ǰ��
	String value8[]  = request.getParameterValues("value8");//I���Ӱ�
	String value9[]  = request.getParameterValues("value9");//J���
	String value10[] = request.getParameterValues("value10");//
	String value11[] = request.getParameterValues("value11");//
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
		siBn.setItem		(value2[i] ==null?"":AddUtil.replace(value2[i],"?",""));
		siBn.setWk_st		(value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));
		siBn.setCount		(value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"?","")));
		siBn.setItem_cd		(value6[i] ==null?"":AddUtil.replace(value6[i],"?",""));
		siBn.setAmt			(value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"?","")));
		siBn.setLabor		(value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"?","")));
		siBn.setPrice		(siBn.getAmt()+siBn.getLabor());
		siBn.setBpm			("2");
		siBn.setReg_id		(ck_acar_id);

//System.out.println("==========������ ���� ��Ͻ���====================");
//System.out.println("���� : "+ck_acar_id);
//System.out.println("� ������ : "+car_mng_id);
//System.out.println("���° ���񳻿��� :"+serv_id);
//System.out.println("==========������ ���� ��� ��====================");		

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