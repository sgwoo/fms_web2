<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus_reg.*"%>
<jsp:useBean id="ex_bean" class="acar.beans.ExcelBean" scope="page"/>
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
	String value0[]  = request.getParameterValues("value0"); //A NO
	String value1[]  = request.getParameterValues("value1"); //B ����
	String value2[]  = request.getParameterValues("value2"); //C �۾��׸� �� ��ǰ��ȣ
	String value3[]  = request.getParameterValues("value3"); //D ����
	String value4[]  = request.getParameterValues("value4"); //E �۾�
	String value5[]  = request.getParameterValues("value5"); //F H,Q,%
	String value6[]  = request.getParameterValues("value6"); //G ��ǰ�ڵ�
	String value7[]  = request.getParameterValues("value7"); //H ��ǰ��
	String value8[]  = request.getParameterValues("value8"); //I ���Ӿ�
	String value9[]  = request.getParameterValues("value9"); //J ���
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
	
	
	int flag = 0;
	int error = 0;	

	CusReg_Database cr_db = CusReg_Database.getInstance();
		
	for(int i=start_row ; i < value_line ; i++){
	
	// excel beanó��	
	   ex_bean.setCell01(car_mng_id);
       ex_bean.setCell02(serv_id);
	    ex_bean.setCell03(user_id);
	    ex_bean.setCell04(value6[i] ==null?"":value6[i]);  //item_cd
	    ex_bean.setCell05(value2[i] ==null?"":value2[i]); //item
	    ex_bean.setCell06(value1[i] ==null?"":value1[i]);  //item_st
	    ex_bean.setCell07(value3[i] ==null?"0":value3[i]);  //���� 
	    ex_bean.setCell08(value7[i] ==null?"0":value7[i]); // ��ǰ��
	    ex_bean.setCell09(value8[i] ==null?"0":value8[i]); //���Ӱ� 
	    ex_bean.setCell10(value4[i] ==null?"":value4[i]);  //wk_st
	    ex_bean.setCell11(value7[i] ==null?"":value7[i]);                
	    ex_bean.setCell12(value8[i] ==null?"":value8[i]);
	    ex_bean.setCell13(value9[i] ==null?"":value9[i]);
	    ex_bean.setCell14(value10[i] ==null?"":value10[i]);
	    ex_bean.setCell15(value11[i] ==null?"":value11[i]);
	    ex_bean.setCell16(value12[i] ==null?"":value12[i]);
	    ex_bean.setCell17(value13[i] ==null?"":value13[i]);
	    ex_bean.setCell18(value14[i] ==null?"":value14[i]);
	    ex_bean.setCell19(value15[i] ==null?"":value15[i]);
	    ex_bean.setCell20(value16[i] ==null?"":value16[i]);
	    
	   	if(cr_db.insertExcelServ(ex_bean) == 0) error++;
	   		   		   	
	}      

   //����ڹ������ν���ȣ��----------------------------------------------------------------------------
	String  d_flag1 =  cr_db.call_sp_insertExcelService(car_mng_id,  serv_id, user_id);
	
	System.out.println("service excel ���ν���ȣ��");
	//--------------------------------------------------------------------------------------------------	
	
	int result_cnt = 0;
   
  
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
	// 	flag = cr_db.delServ_item_all(car_mng_id, serv_id);%>
		document.write("�����߻�");
<%	}else{%>
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
<%	}%>
//-->
</SCRIPT>
</BODY>
</HTML>