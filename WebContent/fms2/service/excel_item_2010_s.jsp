<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.customer.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<%

	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); // 2:�����ڵ���:005392
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//����
	String value1[]  = request.getParameterValues("value1");//������ 
	String value2[]  = request.getParameterValues("value2");//������ȣ
	String value3[]  = request.getParameterValues("value3");//����
	String value4[]  = request.getParameterValues("value4");//���񳻿�
	String value5[]  = request.getParameterValues("value5");//�ݾ�
	String value6[]  = request.getParameterValues("value6");//������
	
	int flag = 0;
	int error = 0;
	int count = 0;
	String car_no 		= "";
	String js_dt 		= "";
	String off_id		= "";	
	//String set_dt 		= "";
	int cnt = 0;
	String car_st = "";    
	
	String gubun = "����"; //������ ���� 
			
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

    System.out.println("�����ڵ��� ���� ��� ����" + AddUtil.getTime());	
 
    String regcode  = Long.toString(System.currentTimeMillis());
//serv_item 
	for(int i=start_row ; i < value_line ; i++){
	
		js_dt 			= value1[i] ==null?"":value1[i];
		car_no			= value2[i] ==null?"":value2[i];
	//	set_dt 			= value6[i] ==null?"":value6[i]; // 
			
		Hashtable ht = cu_db.carNo_SearchNewB(car_no, js_dt);
		
		car_mng_id = String.valueOf(ht.get("CAR_MNG_ID")); 
		rent_mng_id = String.valueOf(ht.get("RENT_MNG_ID")); 
		rent_l_cd = String.valueOf(ht.get("RENT_L_CD")); 

		if(rent_mng_id.equals("null") && rent_l_cd.equals("null")){	
			Hashtable ht2 = cu_db.carNo_SearchNew(car_no, js_dt);
			car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID")); 
			rent_mng_id = String.valueOf(ht2.get("RENT_MNG_ID")); 
			rent_l_cd = String.valueOf(ht2.get("RENT_L_CD")); 
		}
		
		if(car_mng_id.equals("null")  ){	
			out.println("������ȣ "+ car_no+" ��Ͽ���  <br>");
			System.out.println("car_no="+car_no + "|js_dt=" + js_dt);
		}
		
//	System.out.println("car_no="+car_no + "|js_dt=" + js_dt);
	
		serv_id = cu_db.getServ_id(car_mng_id);

//System.out.println("setItem= "+value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));
//System.out.println("setCount= "+value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"?","")));
//System.out.println("setPrice= "+value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"?","")));
//System.out.println("setAmt= "+value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"?","")));	
	
		Customer_Bean cuBn = new Customer_Bean();
		cuBn.setCar_mng_id	(car_mng_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("���۾�");
		cuBn.setItem		(value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));
		cuBn.setCount		(1);			
		cuBn.setPrice		(value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ","")));		
		if(gubun.equals("����")){
			cuBn.setLabor		(value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ","")));   // cuBn.getCount() * cuBn.getPrice()  ����
		}else{
			cuBn.setAmt			(value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ","")));   // cuBn.getCount() * cuBn.getPrice()  ����
		}
		
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		cuBn.setRegcode		(regcode);
	
		if(cu_db.insertServItem(cuBn) == 0) error++;  //serv_item insert
		
	}
	
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	String checker = request.getParameter("checker")==null?"":request.getParameter("checker");
	String spdchk_dt = request.getParameter("spdchk_dt")==null?"":AddUtil.ChangeString(request.getParameter("spdchk_dt"));
	String tot_dist = request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String checker_st = request.getParameter("checker_st")==null?"":request.getParameter("checker_st");
	String chk_ids = "";
	
	int amt = 0;
	int labor = 0;
	   	
	//service
	for(int i=start_row ; i < value_line ; i++){
			
		js_dt			= value1[i] ==null?"":value1[i];
		car_no 			= value2[i] ==null?"":value2[i];
	//	set_dt 			= value6[i] ==null?"":value6[i]; // 
		
		Hashtable ht = cu_db.carNo_SearchNewB(car_no, js_dt);
		car_mng_id = String.valueOf(ht.get("CAR_MNG_ID")); 
		rent_mng_id = String.valueOf(ht.get("RENT_MNG_ID")); 
		rent_l_cd = String.valueOf(ht.get("RENT_L_CD"));
		car_st = String.valueOf(ht.get("CAR_ST"));
						
		if(rent_mng_id.equals("null") && rent_l_cd.equals("null")){	
			Hashtable ht2 = cu_db.carNo_SearchNew(car_no, js_dt);
			car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID")); 
			rent_mng_id = String.valueOf(ht2.get("RENT_MNG_ID")); 
			rent_l_cd = String.valueOf(ht2.get("RENT_L_CD")); 
		}
		
		serv_id = cu_db.getServ_id(car_mng_id);
		 
		off_id = "005392"; //�����ڵ���
		
		String mng_id = String.valueOf(ht.get("MNG_ID"));
		if ( mng_id.equals("null")) mng_id = "000026";
		
		Hashtable ht2 = cu_db.getServ_id2(car_mng_id, serv_id);
		
		String serv_id2 = String.valueOf(ht2.get("SERV_ID"));
			
		//System.out.println("ht2.CAR_MNG_ID= "+ht2.get("CAR_MNG_ID"));
		//System.out.println("car_no="+car_no + "|js_dt=" + js_dt);
			
		amt = AddUtil.parseInt(String.valueOf(ht2.get("AMT")));
		labor = AddUtil.parseInt(String.valueOf(ht2.get("LABOR")));

		long samt = Math.round((amt+labor) * 1.1);
		long damt = Math.round(samt - (amt+labor));
			
		if(!serv_id2.equals("null")){										//serv_id2�� null�� �ƴҶ��� ����
			ServInfoBean siBn = new ServInfoBean();
			siBn.setCar_mng_id(car_mng_id);
			siBn.setServ_id(serv_id2);
			siBn.setRent_mng_id(rent_mng_id);
			siBn.setRent_l_cd(rent_l_cd);
			if ( !car_st.equals("2") ) {
			  siBn.setServ_st("7"); //�縮��
			} else {
				siBn.setServ_st("2"); //�Ϲ����� 
			}
			siBn.setOff_id(off_id);//�����ڵ��� ������ ��Ͻ�
			siBn.setServ_dt(value1[i] ==null?"":value1[i]);
			siBn.setChecker(mng_id);
			siBn.setSpdchk_dt(value1[i] ==null?"":value1[i]);
			siBn.setTot_dist(tot_dist);//����Ÿ� �߰�
			siBn.setRep_cont(value4[i] ==null?"":AddUtil.replace(value4[i],"?",""));  //����
			siBn.setTot_amt(AddUtil.parseInt(String.valueOf(samt)));
			siBn.setRep_amt(AddUtil.parseInt(String.valueOf(samt)));
			siBn.setR_labor(labor);
			siBn.setR_amt(amt);
			siBn.setAdd_amt(AddUtil.parseInt(String.valueOf(damt)));
			siBn.setSup_amt(amt+labor);
			siBn.setR_j_amt(amt);
			siBn.setJung_st("1");
			siBn.setSet_dt(value6[i] ==null?"":value6[i]);
			siBn.setChecker_st("1");
			siBn.setSpd_chk(chk_ids);
			siBn.setReg_id(user_id);
		
			//�ߺ�üũ			
			int result1 = cu_db.insertService(siBn);
					
		}

	}
	    
//System.out.println("car_mng_id= "+car_mng_id);	
	System.out.println("�����ڵ��� ������Ÿ ��� ����" + AddUtil.getTime());	
	
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
		flag = cu_db.delServ_item_all(car_mng_id, serv_id);%>
		document.write("�����߻�");
<%	}else{%>
//	action = '';
	parent.window.close();
<%	}%>
//-->
</SCRIPT>
</BODY>
</HTML>
</HTML>