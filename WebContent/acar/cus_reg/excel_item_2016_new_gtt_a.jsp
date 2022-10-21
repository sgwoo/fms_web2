<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus_reg.*,  acar.beans.*"%>

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
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0"); //A NO
	String value1[]  = request.getParameterValues("value1"); //B ����
	String value2[]  = request.getParameterValues("value2"); //C �۾��׸� �� ��ǰ��ȣ
	String value3[]  = request.getParameterValues("value3"); //D ����
	String value4[]  = request.getParameterValues("value4"); //E 
	String value5[]  = request.getParameterValues("value5"); //F ����
	String value6[]  = request.getParameterValues("value6"); //G 
	String value7[]  = request.getParameterValues("value7"); //H 
	String value8[]  = request.getParameterValues("value8"); //I 
	String value9[]  = request.getParameterValues("value9"); //J �۾� 
	String value10[] = request.getParameterValues("value10");//K 
	String value11[] = request.getParameterValues("value11");//L H,Q,%
	String value12[] = request.getParameterValues("value12");//M
	String value13[] = request.getParameterValues("value13");//N
	String value14[] = request.getParameterValues("value14");//O
	String value15[] = request.getParameterValues("value15");//P ��ǰ�ڵ�
	String value16[] = request.getParameterValues("value16");//Q
	String value17[] = request.getParameterValues("value17");//R
	String value18[] = request.getParameterValues("value18");//S ��ǰ��
	String value19[] = request.getParameterValues("value19");//T
	String value20[] = request.getParameterValues("value20");//U ���Ӿ�
	String value21[] = request.getParameterValues("value21");
		
	int flag = 0;
	int error = 0;
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
	// excel beanó��	
		ExcelBean ex_bean = new ExcelBean();
	    ex_bean.setCell01(car_mng_id);
       ex_bean.setCell02(serv_id);
	    ex_bean.setCell03(user_id);
	    ex_bean.setCell04(reg_code);
	    ex_bean.setCell05("-"); //item_cd
	    ex_bean.setCell06(value2[i] ==null?"":AddUtil.replace(value2[i],"?","")); //item;
	    ex_bean.setCell07(value1[i] ==null?"":value1[i]);
	    ex_bean.setCell08(value11[i] ==null?"0": AddUtil.replace(value11[i],"?",""));// ����
	    ex_bean.setCell09(value18[i] ==null?"0": AddUtil.replace(value18[i],"?",""));//E��ǰ��
		 ex_bean.setCell10(value20[i] ==null?"0": AddUtil.replace(value20[i],"?",""));//F���Ӿ�	  
	    ex_bean.setCell11(value9[i] ==null?"-":AddUtil.replace(value9[i],"?","")); //wk_st
	    ex_bean.setCell12(Integer.toString(i+1)); // ����
	    
	   	if(cr_db.insertExcelServ(ex_bean) == 0) error++;
	   		   		   	
	}      

   //����ڹ������ν���ȣ��----------------------------------------------------------------------------
	String  d_flag1 =  cr_db.call_sp_insertExcelService(car_mng_id,  serv_id, user_id, reg_code);
	
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
//		flag = cr_db.delServ_item_all(car_mng_id, serv_id);%>
		document.write("�����߻�");
<%	}else{%>
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
<%	}%>
//-->
</SCRIPT>
</BODY>
</HTML>