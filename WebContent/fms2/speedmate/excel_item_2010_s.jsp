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
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//A������
	String value1[]  = request.getParameterValues("value1");//B������ȣ 
	String value2[]  = request.getParameterValues("value2");//C��������
	String value3[]  = request.getParameterValues("value3");//D����Ÿ�
	String value4[]  = request.getParameterValues("value4");//E���񳻿�
	String value5[]  = request.getParameterValues("value5");//F����
	String value6[]  = request.getParameterValues("value6");//G��ǰ����
	String value7[]  = request.getParameterValues("value7");//H��ǰ����
	String value8[]  = request.getParameterValues("value8");//I�հ�

	int flag = 0;
	int error = 0;
	int count = 0;
	String car_no 		= "";
	String js_dt 		= "";
	String off_id		= "";
	String off_id2		= "";
	
	int cnt = 0;
	
	String gubun = "";
	
		
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

System.out.println("���ǵ����Ʈ ��� ����");		
//serv_item 
	for(int i=start_row ; i < value_line ; i++){
	
	car_no 			= value1[i] ==null?"":value1[i];
	js_dt			= value2[i] ==null?"":value2[i];

	gubun			= value5[i] ==null?"":value5[i];
	
	Hashtable ht = cu_db.speed_Serach(car_no, js_dt);
	
	car_mng_id = String.valueOf(ht.get("CAR_MNG_ID")); 
	rent_mng_id = String.valueOf(ht.get("RENT_MNG_ID")); 
	rent_l_cd = String.valueOf(ht.get("RENT_L_CD")); 

	if(rent_mng_id.equals("null") && rent_l_cd.equals("null")){	
		Hashtable ht2 = cu_db.Serach2(car_no, js_dt);
		car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID")); 
		rent_mng_id = String.valueOf(ht2.get("RENT_MNG_ID")); 
		rent_l_cd = String.valueOf(ht2.get("RENT_L_CD")); 
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
		cuBn.setCount		(value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"?","")));
		cuBn.setPrice		(value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"?","")));
		
		if(gubun.equals("����")){
			cuBn.setLabor		(value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"?","")));   // cuBn.getCount() * cuBn.getPrice()  ����
		}else{
			cuBn.setAmt			(value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"?","")));   // cuBn.getCount() * cuBn.getPrice()  ����
		}

		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
	//	if(cuBn.getItem().equals("")) continue;
					
		//�ߺ�üũ
		ServInfoBean siBn = new ServInfoBean();
		siBn.setCar_mng_id	(car_mng_id);
		siBn.setServ_dt		(value2[i] ==null?"":value2[i]);
		siBn.setTot_dist	(value3[i] ==null?"":value3[i]);
			
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}	
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
	
		car_no 			= value1[i] ==null?"":value1[i];
		js_dt			= value2[i] ==null?"":value2[i];
		tot_dist		= value3[i] ==null?"":value3[i];
		String offnm 	= value0[i] ==null?"":value0[i];
		
		Hashtable ht = cu_db.speed_Serach(car_no, js_dt);
		car_mng_id = String.valueOf(ht.get("CAR_MNG_ID")); 
		rent_mng_id = String.valueOf(ht.get("RENT_MNG_ID")); 
		rent_l_cd = String.valueOf(ht.get("RENT_L_CD"));
	
		if(rent_mng_id.equals("null") && rent_l_cd.equals("null")){	
			Hashtable ht2 = cu_db.Serach2(car_no, js_dt);
			car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID")); 
			rent_mng_id = String.valueOf(ht2.get("RENT_MNG_ID")); 
			rent_l_cd = String.valueOf(ht2.get("RENT_L_CD")); 
		}
		
		serv_id = cu_db.getServ_id(car_mng_id);
		off_id = cu_db.getOff_id(offnm, "sm");
		
		Hashtable ht2 = cu_db.getServ_id2(car_mng_id, serv_id);
		
		String serv_id2 = String.valueOf(ht2.get("SERV_ID"));
		
//System.out.println("ht2.CAR_MNG_ID= "+ht2.get("CAR_MNG_ID"));
System.out.println("car_no="+car_no + "|js_dt=" + js_dt);
System.out.println("ht2.AMT= "+ht2.get("AMT"));
System.out.println("ht2.LABOR= "+ht2.get("LABOR"));
//System.out.println("ht2.SERV_ID= "+ht2.get("SERV_ID"));
//System.out.println("serv_id= "+serv_id);	
//System.out.println("serv_id2= "+serv_id2);	
		
		amt = AddUtil.parseInt(String.valueOf(ht2.get("AMT")));
		labor = AddUtil.parseInt(String.valueOf(ht2.get("LABOR")));

System.out.println("AMT= "+amt);
System.out.println("LABOR= "+labor);

		
		long samt = Math.round((amt+labor) * 1.1);
		long damt = Math.round(samt - (amt+labor));

		if(off_id.equals("")){
		
			String off_nm = "���ǵ����Ʈ " + offnm;
			
			ServOffBean soBn = new ServOffBean();
			soBn.setOff_nm(off_nm);
			soBn.setReg_id(user_id);
			soBn.setCar_comp_id("0041");
			soBn.setOff_st("6");
			soBn.setOff_type("1");
			
			count = cu_db.insertServOff(soBn);
		}
		
		off_id = cu_db.getOff_id(offnm, "sm");	
		
		if(!serv_id2.equals("null")){										//serv_id2�� null�� �ƴҶ��� ����
			ServInfoBean siBn = new ServInfoBean();
			siBn.setCar_mng_id(car_mng_id);
			siBn.setServ_id(serv_id2);
			siBn.setRent_mng_id(rent_mng_id);
			siBn.setRent_l_cd(rent_l_cd);
			siBn.setServ_st("2");
			siBn.setOff_id(off_id);//���ǵ����Ʈ ������ ��Ͻ�
			siBn.setServ_dt(value2[i] ==null?"":value2[i]);
			siBn.setChecker(String.valueOf(ht.get("MNG_ID")));
			siBn.setSpdchk_dt(value2[i] ==null?"":value2[i]);
			siBn.setTot_dist(tot_dist);//����Ÿ� �߰�
			siBn.setRep_cont(rep_cont);
			siBn.setTot_amt(AddUtil.parseInt(String.valueOf(samt)));
			siBn.setRep_amt(AddUtil.parseInt(String.valueOf(samt)));
			siBn.setR_labor(labor);
			siBn.setR_amt(amt);
			siBn.setAdd_amt(AddUtil.parseInt(String.valueOf(damt)));
			siBn.setSup_amt(amt+labor);
			siBn.setR_j_amt(amt);
			siBn.setJung_st("1");
			siBn.setChecker_st("1");
			siBn.setSpd_chk(chk_ids);
			siBn.setReg_id(user_id);
		
			//�ߺ�üũ
			if(cu_db.getServiceCheck(siBn.getCar_mng_id(), siBn.getServ_id()) == 0){
				int result1 = cu_db.insertService(siBn);
			}
		
		}


	}
//System.out.println("car_mng_id= "+car_mng_id);	
	System.out.println("���ǵ����Ʈ ��� ����");	
	
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