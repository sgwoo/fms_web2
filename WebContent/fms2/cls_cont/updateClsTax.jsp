<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cls.*, acar.credit.*, acar.user_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cmd	  		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
		//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
	
		//����ȸ������
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//�⺻����
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	
	//�����Ƿڻ������
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);

	//ä�ǰ�������
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);	
	
		//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	

	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //���ô뿩�� ����Ⱓ
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //���ô뿩�� ����ݾ�
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
			//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }	
				
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ��� (���Ⱓ�� ����� ��� - ��������� )
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    }	
		
		set_cls_s_amt();
	}	

	
	//����ϱ�
	function save(){
		fm = document.form1;
					
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		fm.target = "i_no";
		fm.action = 'updateClsTax_a.jsp'
		fm.submit();
	}
	
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
				
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
								
		obj.value=parseDecimal(obj.value);
			
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //�̳��Դ뿩�� �Ⱓ (���ʱݾ׵� ����ǵ���)
										
			//�ܿ����ô뿩�� 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			//	ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
				
				pay_tm = toInt(fm.con_mon.value)-ifee_tm;
				if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
					fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
					fm.ifee_day.value 	= fm.r_day.value;
				}
			
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
						
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
												    	 
		    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		    		v_rifee_s_amt = 0;
		      		
		    	}  
		    	 			
			}
			
			   //�ܿ�������?
			if(fm.pp_s_amt.value != '0'){
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
			}else{
				fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
			}
			
			if(fm.pp_s_amt.value != '0') {
		 	 
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
		    		
		    		fm.pded_s_amt.value 	= 0;
					fm.tpded_s_amt.value 	= 0;
					fm.rfee_s_amt.value 	= 0;
		    	}   
		    }	
			if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
				fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
			} 
		    
			//�����ݾ�	
			fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
		    					
				
			if(fm.ifee_s_amt.value == '0' ) {
	   	 			
				//�뿩 �������� �����ȵǰ�, �̳��� ���� ��� scd_fee�� ��� nfee_mon, nfee_day ���Ҽ� ����.
			   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ �ȵ� ��� 
				 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
				   	     //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
				   		   	  	   
			   	  	   if (toInt(fm.r_con_mon.value) > 0) {  
				   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //������ - �������� ���� ��
				   	   } else {  //������������ ���  (���ô뿩�ᰡ �ִ� ���)
				   	  	  	 fm.nfee_mon.value = '0';
				   	   } 
		   	  	  
			  	   	 //  if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // �����ϰ� ������ ������ ��	   	  	  	    	  	   
		  	   	    // 	fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	    //   } 
		  	   	       
		  	   	       if ( toInt(replaceString("-","",fm.cls_dt.value)) >= toInt(fm.rent_end_dt.value) ) { // �����ϰ� ������ ��	   	  	  	    	  	   
		  	   	     	  fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	   	   }
				 }
			  } else { //�������� ������ ������ �� ���
		   
			      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� ���� ���
				   	     //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
				   	 
			   	 // 	   if (toInt(fm.r_con_mon.value) > 0) {  
				//   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //������ - �������� ���� ��
				//   	   } else {  //������������ ���  (���ô뿩�ᰡ �ִ� ���)
				 //  	  	  	 fm.nfee_mon.value = '0';
				//   	   } 
		   	  	  
		   	  	  	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // �����ϰ� ������ ������ ��	   	
		   	  	  	    	if  ( fm.nnfee_s_amt.value  == '0' ) {  	  	    	  	   
			  	   	       		fm.nfee_day.value 	= 	fm.r_day.value;
			  	   	    	}   
			  	   	   }  
			   
			      }
		 	  }		   
			   	
		   }				
							
			//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
			//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
			 
			
		    fm.nfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
			fm.nfee_amt.value 			=  fm.nfee_amt_1.value;
		
			// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
		   	if(fm.ifee_s_amt.value != '0' ) {
								
		   		if (v_rifee_s_amt <= 0) {  //���ô뿩�Ḧ �� ������ ���
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //       alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");			   	      
					   	      
					   	           	//�̳��ܾ��� �ִ� ���      	
					   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {		   	    		
					   	    	     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ���� 
					   	    	  
					   	    	      //������ �ִٸ� 
					   	    	     if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
					   	    	     	fm.nfee_day.value = 0;
					   	    	     } else {
					   	    	      
						   	    	  	 if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {
						   	    	  		 if  ( fm.nnfee_s_amt.value  == '0' ) {
						   	    	  	 		fm.nfee_day.value 	= 	fm.r_day.value;
						   	    	  	 	 }	
						   	    	  	 }  	
						   	    	 } 	     	
					   	    	   	    	 	
					   	    	} else {
					   	    	      //������ �ִٸ� 
					   	    	   if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
					   	    	     	fm.nfee_day.value = 0;		   	   
					   	    	   } else {  		
						   	    	   if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {
							   	              fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
							   	       		  fm.nfee_day.value 	= 	fm.r_day.value;
							   	       		  
							   	       		  
							   	       		  	  // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)	
								  	          var s1_str = fm.use_e_dt.value;
									   		  var e1_str = fm.cls_dt.value;
											  var  count1 = 0;
												
											  var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
											  var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
									
											  var diff1_date = e1_date.getTime() - s1_date.getTime();
									
											  count1 = Math.floor(diff1_date/(24*60*60*1000));
										    						 
									  	   	  if ( count1 >= 0 ) {							  	   	      	  	  	    	  	   
									  	   	     fm.nfee_day.value 	= 	count1;
									  	   	  }		
							   	       		  
						   	    	   }
						   	       }	   	
					   	    	
					   	    	} 		   	      	 
			   	    	/*
			   	     		 if (toInt(fm.r_con_mon.value) > 0) {  
							   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //������ - �������� ���� �� (�ǻ�����)
							 } else {  
								   	  	 fm.nfee_mon.value = '0';			   	  	  	 
							 } 			   	   
							   	  	  	   //������ ������	   	  	  	 	  	
							 if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
							   	       	fm.nfee_day.value = 0;
							 } else {
							   	       if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // �����ϰ� ������ ������ ��	
								   	  	   if  ( fm.nnfee_s_amt.value  == '0' ) {   	  	  	    	  	   
									  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
									  	   }
									  	   
									  	   // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)	   
									  	   var s1_str = fm.use_e_dt.value;
										   var e1_str = fm.cls_dt.value;
										   var  count1 = 0;
											
										   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1, s1_str.substring(6,8) );
										   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );
								
										   var diff1_date = e1_date.getTime() - s1_date.getTime();
								
										   count1 = Math.floor(diff1_date/(24*60*60*1000));
											
								  	   	   if ( count1 >= 0 ) { 	  	  	    	  	   
								  	   	     fm.nfee_day.value 	= 	count1;
							  	   	  	   } 						  	   
									  	   
									   }	   
							 } */
				   	       	   	  
			   	       	     fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	       //	   alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	        //   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	     	
			   	     	 var r_tm = 0;       
					   	 r_tm 			    = 	toInt(fm.s_mon.value) - ifee_tm ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
					   	 fm.nfee_mon.value 	= r_tm;
					   	 fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
					  	
			   	     
			   	      }else {
			   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
			   	       }
			   	   }
			    } else {  //���ô뿩�ᰡ �����ִ� ���
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //   	   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	    //       alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	      }else {
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	   }
			    }   
		   	}
		   	
			fm.nfee_amt.value 			=  fm.nfee_amt_1.value;			
		}
				
		if ( fm.cls_st.value == '8' ) {
			//���ԿɼǸ�???
			if(obj == fm.nfee_amt_1){ //�̳��Դ뿩�� �Ⱓ (���ʱݾ׵� ����ǵ���)
				fm.nfee_amt.value 			=  fm.nfee_amt_1.value;	
			}
		}
		
				//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_amt.value = fm.ex_di_amt_1.value
			fm.ex_di_v_amt.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} 
		
		
		if ( fm.ex_di_amt_1.value == 0 ) {
			fm.ex_di_amt.value = 0;
			fm.ex_di_v_amt.value = 0;
			fm.ex_di_v_amt_1.value = 0;
		}
		
					   			
			//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		   fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 
			
		//vat��� (�뿩��)
		var no_v_amt = 0;
		var no_v_amt1 = 0;
			
			
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ; 	
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
	//	var no_v_amt2 	 = no_v_amt;

		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
					
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
						
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
							
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}						
									
		if ( fm.tax_chk3.checked == true) {				    
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));				    				
		}		
		
		if ( fm.tax_chk4.checked == true) {				    
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));				    				
		}		
				
		fm.d_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
		fm.d_amt_1.value 	= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
	
		set_cls_s_amt();
	}	
	
		//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
	
		if(obj == fm.dft_amt_1){ //�ߵ�����
			fm.tax_supply[0].value 	= obj.value;
			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );			
						
		}else if(obj == fm.etc_amt_1){ //ȸ�����ֺ��
			fm.tax_supply[1].value 	= obj.value;			
			fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		
					
		}else if(obj == fm.etc2_amt_1){ //ȸ���δ���
			fm.tax_supply[2].value 	= obj.value;
			fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );	
			
			
		}else if(obj == fm.etc4_amt_1){ //��Ÿ���ع���
			fm.tax_supply[3].value 	= obj.value;
			fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );	
				
		}else if(obj == fm.over_amt_1){ //�ʰ�����δ��
			fm.tax_supply[4].value 	= obj.value;
			fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		
		}		
					   			
			//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		   fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 
	   		
		//vat��� (�뿩��)
		var no_v_amt = 0;
			
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 
	        no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
								
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );	
								
		if ( fm.tax_chk0.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}				
					
		if ( fm.tax_chk1.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		
						
		if ( fm.tax_chk2.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));					   
		}		
							
		if ( fm.tax_chk3.checked == true) {			   
			   fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));
		}	
		
		if ( fm.tax_chk4.checked == true) {			   
			   fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));
		}	
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value)) +  toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  +  toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
				 			
		if (fm.cls_st.value  == '8' ) {	
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));							
		} 
			
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}	
	
		//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		//����
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}	
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}		
	//��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
		//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
							
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		 		 	
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));						
			
		}  			
						
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}	
		
		//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			}
		}else if(obj == fm.dft_int_1){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			
			}			
		}
		
		fm.dfee_amt.value					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		
		set_cls_s_amt();
	}	
	
		
	//����ȸ�����
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
					
		//�հ�, �����Ծ�
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))+ toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
			 				
		if (fm.cls_st.value  == '8' ) {	
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		}  
		
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}
	
	
	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		if(obj == fm.tax_chk0){ // �����
		 	if (obj.checked == true) {
		 			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // ���ֺ��
			 if (obj.checked == true) {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
			 
		} else if(obj == fm.tax_chk2){ // �δ���
			 if (obj.checked == true) {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
			 
		} else if(obj == fm.tax_chk3){ // ��Ÿ���ع���
			 if (obj.checked == true) {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	
		
			} else if(obj == fm.tax_chk4){ // �ʰ�����δ�� 
			 if (obj.checked == true) {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		 
			 
		}
			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
				
	}
		

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='updateClsJung_a.jsp' method='post'>
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='br_id' 		value='<%=br_id%>'>
<input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 		value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">
<input type='hidden' name="cancel_yn" 	value="<%=cls.getCancel_yn()%>"> 
<input type='hidden' name="cls_st" 	value="<%=cls.getCls_st_r()%>"> 
<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >         
          
<!--<input type='hidden' name="cls_s_amt" > 
<input type='hidden' name="cls_v_amt" >  -->
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='cls_dt' value='<%=cls.getCls_dt()%>'> 
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->
<input type='hidden' name='r_mon'  value='<%=cls.getR_mon()%>'>
<input type='hidden' name='r_day' value='<%=cls.getR_day()%>' >
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
<input type='hidden' name='ex_di_v_amt_1' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>       

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  

<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->
<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>

<input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'>
<input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'>
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>����ȣ</td>
                    <td width='20%' align="center"><%=rent_l_cd%></td>
    			    <td class='title' width='15%'>��ȣ</td>
                    <td width='45%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title' width='20%'>������ȣ</td>
                    <td width='20%' align="center"><%=cr_bean.getCar_no()%></td>
    			    <td class='title' width='15%'>����</td>
                    <td width='45%'>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>

   <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ֺ��</span></td>
	</tr>
		<tr>
        <td class=line2></td>
    </tr> 
  	<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
         		  <tr>      
		            <td width='10%' class='title'>���ֺ��</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='15'  value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
		            </td>
		            <td width='10%' class='title'>�δ���</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='15'   value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
		            </td>
		            <td width='10%' class='title'>����</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='15' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
		            </td>
		          </tr>
		      
		        </table>
		      </td>
		    </tr>
		    <tr>
		      <td>&nbsp;</td>
		    </tr>	
		</table>
      </td>	 
    </tr>	     
	<tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
    
	    	 <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span>[���ް�]</td>
			</tr>
				<tr>
			    <td class=line2></td>
			</tr>
			
			<tr>
			    <td>
			        <table width=100% border=0 cellspacing=0 cellpadding=0>
			            <tr> 
				            <td  colspan="2" class='line'> 
				              <table border="0" cellspacing="1" cellpadding="0" width="100%">
				                <tr> 
				                  <td class='title' align='right' colspan="3">�׸�</td>
				                  <td class='title' width='38%' align="center">����</td>
				                  <td class='title' width="40%">���</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="7" width=4%>ȯ<br>
				                    ��<br>
				                    ��<br>
				                    ��</td>
				                  <td class='title' colspan="2">������(A)</td>
				                  <td class='title' > 
				                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td class='title'>&nbsp;</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="3" width=4%>��<br>
				                    ��<br>
				                    ��<br>
				                    ��<br>
				                    ��</td>
				                  <td width="14%" align="center" >����Ⱓ</td>
				                  <td align="center"> 
				                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
				                    ����&nbsp;&nbsp;&nbsp; 
				                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
				                    ��</td>
				                  <td>&nbsp;</td>
				                </tr>
				                <tr>
				                  <td align="center" >����ݾ�</td>
				                  <td align="center"> 
				                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td>=���ô뿩�᡿����Ⱓ</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td class='title'>=���ô뿩��-����ݾ�</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="3">��<br>
				                    ��<br>
				                    ��</td>
				                  <td align='center'>�������� </td>
				                  <td align="center"> 
				                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td>=�����ݡ����Ⱓ</td>
				                </tr>
				                <tr> 
				                  <td align='center'>������ �����Ѿ� </td>
				                  <td align="center"> 
				                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td>=�������ס����̿�Ⱓ</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right'>�ܿ� ������(C)</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    ��</td>
				                  <td class='title'>=������-������ �����Ѿ�</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right' colspan="3">��</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='c_amt' value='' readonly size='15' class='num' >
				                    ��</td>
				                  <td class='title'>=(A+B+C)</td>
				                </tr>
				              </table>
				            </td>
					     </tr>
			
			        </table>
			    </td>
			</tr>
			<tr></tr><tr></tr><tr></tr>
			
			 <input type='hidden' name='ex_ip_amt'  value='0'> 
			 <input type='hidden' name='ex_ip_dt' > 
			 <input type='hidden' name='bank_code' > 
			 <input type='hidden' name='deposit_no' > 
		
		
			<tr>
			    <td class=h></td>
			</tr>

	    
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��ݾ� ����</span>[���ް�]</td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
		       <tr> 
		        <td colspan="2" class='line'> 
		          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr> 
		              <td class="title" colspan="4" rowspan=2>�׸�</td>
		              <td class="title" width='38%' colspan=2> ä��</td>                
		              <td class="title" width='40%' rowspan=2>���</td>
		            </tr>
		            <tr>                 
		              <td class="title"'> ���ʱݾ�</td>
		              <td class="title"'> Ȯ���ݾ�</td>
		              
		            </tr>
		            <tr> 
		              <td class="title" rowspan="20" width="4%">��<br>
		                ��<br>
		                ��<br>
		                ��<br>
		                ��</td>
		              <td class="title" colspan="3">���·�/��Ģ��(D)</td>
		              <td align="center" class="title"> 
		              <input type='text' name='fine_amt'   value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' >
		               ��</td>
		              <td  align="center" class="title"> 
		               <input type='text' name='fine_amt_1'   value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  > 
		               ��</td>
		           
		              <td class="title">&nbsp;</td>
		             </tr>
		             <tr> 
		              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
		              <td width='19%' align="center" class="title"> 
		                <input type='text' name='car_ja_amt'  value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' >
		                ��</td>
		              <td width='19%' align="center" class="title">
		              <input type='text' name='car_ja_amt_1'  value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  > 
		                ��</td>   
		                     
		              <td width='40%' class="title">&nbsp;</td>
		            </tr>
		             <tr>
		              <td class="title" rowspan="6" width="4%"><br>
		                ��<br>
		                ��<br>
		                ��</td>
		              <td align="center" colspan="2" class="title">������</td>
		              <td class='' align="center"> 
		                <input type='text' name='ex_di_amt'  readonly value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td> 
		               
		              <td class='' align="center"> 
		                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td> 
		             
		              <td>&nbsp;</td>
		             
		            </tr>
		         
		            <tr> 
		              <td rowspan="2" align="center" class="title" width="4%">��<br>
		                ��<br>
		                ��</td>
		              <td width='10%' align="center" class="title">�Ⱓ</td>
		              <td class='' colspan=2  align="center"> 
		                <input type='text' size='3' name='nfee_mon'  value='<%=cls.getNfee_mon()%>'  class='num' maxlength='4' >
		                ����&nbsp;&nbsp;&nbsp; 
		                <input type='text' size='3' name='nfee_day'  value='<%=cls.getNfee_day()%>'   class='num' maxlength='4' >
		                ��</td>
		              <td>&nbsp;     
		              </td>
		            </tr>
		            <tr> 
		              <td align="center" class="title">�ݾ�</td>
		              <td align="center"> 
		                <input type='text' size='15' name='nfee_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>  
		              <td align="center"> 
		                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>  
		             
		              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
		            </tr>
		             <tr> 
		              <td class="title" colspan="2">�뿩��̳�</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                ��</td>
		                <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                ��</td>  
		               
		              <td class='title'>&nbsp;=������ + �̳���</td>
		            </tr>
		           	<tr> 
		              <td colspan="2" align="center" class="title">��ü��</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' name='dly_amt_1'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>
		             
		              <td class='title'>&nbsp; </td>
		            </tr>
		            <tr> 
		              <td class="title" colspan="2">�Ұ�(F)</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='d_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                ��</td>
		                <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='d_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                ��</td>  
		             
		               <td class='title'>&nbsp;=�뿩��̳� + ��ü��</td>
		            </tr>
		            <tr> 
		              <td rowspan="6" class="title">��<br>
		                ��<br>
		                ��<br>
		                ��<br>
		                ��<br>
		                ��<br>
		                ��</td>
		              <td align="center" colspan="2" class="title">�뿩���Ѿ�</td>
		              <td class='' colspan=2  align="center"> 
		                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                ��</td>
		              <td>=������+���뿩���Ѿ�</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
		              <td class='' colspan=2 align="center"> 
		                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' >
		                ��</td>
		              <td>=�뿩���Ѿס����Ⱓ</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
		              <td class=''  colspan=2  align="center"> 
		                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
		                ����&nbsp;&nbsp;&nbsp; 
		                <input type='text' name='rcon_day'  size='3' value='<%=cls.getRcon_day()%>' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
		                ��</td>
		              <td>&nbsp;</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
		              <td class=''  colspan=2 align="center"> 
		                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' >
		                ��</td>
		              <td>&nbsp;</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
		                �������</td>
		              <td class='' align="center"> 
		                <input type='text' readonly name='dft_int'  value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
		                %</td>
		              <td class='' align="center"> 
		                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
		                %</td>  
		              <td>����� ��������� ��༭�� Ȯ��</td>
		            </tr>
		            <tr> 
		              <td  class="title" colspan="2">�ߵ����������(G)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' >
		                ��</td>
		               <td align="center" class="title"> 
		                <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:set_cls_amt(this)'>
		                ��</td>
		                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' size='15' class='num' >      
		                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='�ߵ����� �����'>          
		                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>disabled   ></td>
		            </tr>      
		       
		            <tr> 
		              <td class="title" rowspan="5"><br>
		                ��<br>
		                Ÿ</td> 
		              <td class="title" colspan="2">����ȸ�����ֺ��(H)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' >
		                ��</td>
		               <td  align="center" class="title"> 
		                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                ��</td>  
		                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='ȸ�� �������ֺ��'>     
		               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%> disabled  > </td>
		            </tr>
		            <tr> 
		              <td class="title" colspan="2">����ȸ���δ���(I)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' >
		                ��</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                ��</td>  
		                <input type='hidden' name='tax_supply' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' size='15' class='num' > 
		                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='ȸ�� �δ���'>  
		               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%> disabled > </td>
		            </tr>
		            <tr> 
		              <td colspan="2" class="title">������������(J)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' >
		                ��</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                ��</td> 
		            
		              <td class="title">&nbsp;</td>
		            </tr>
		            <tr> 
		              <td class="title" colspan="2">��Ÿ���ع���(K)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' >
		                ��</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc4_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                ��</td>  
		               <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' size='15' class='num' > 
		               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
		               <input type='hidden' name='tax_g' size='20' class='text' value='��Ÿ���ع���'>  
		              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%>  disabled ></td>
		                                             
		            </tr>
		            
		               <tr> 
		              <td class="title" colspan="2">�ʰ������߰��뿩��(L)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' >
		                ��</td>
		              <td align="center" class="title"> 
		                <input type='text' name='over_amt_1'  value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                ��</td>  
		                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_s())%>' size='15' class='num' > 
		               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' size='15' class='num' >  
		               <input type='hidden' name='tax_g' size='20' class='text' value='�ʰ������߰��뿩��'>  		     
		              <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);"  disabled  >��꼭�����Ƿ�</td>
		                                             
		            </tr>
		                   
		            <tr> 
		              <td class="title" colspan="3">�ΰ���(M)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>'  size='15' class='num' onBlur='javascript:set_cls_s_amt()'>
		                ��</td>
		              <td align="center" class="title"> 
		                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>'  size='15' class='num' onBlur='javascript:set_cls_s_amt()'>
		                ��</td> 
		         
		              <td> 
		                <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                  <tr> 
		                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(�뿩�� 
		                      �̳��Աݾ�-B-C)��10% + ��꼭 ���� �ΰ��� </td>
		                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(�뿩��  
		                      �̳��Աݾ�-B-C)��10% + ��꼭 ���� �ΰ��� </td>
		                  </tr>
		                </table>
		              </td>
		            </tr>
		            
		            <tr> 
		              <td class="title_p" colspan="4">��</td>
		              <td class='title_p' align="center"> 
		                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' >
		                ��</td>
		              <td class='title_p' align="center"> 
		                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' >
		                ��</td>  
		                
		              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M)</td>
		            </tr>
		          </table>
		        </td>         
		    </tr>
		   
		    <tr></tr><tr></tr><tr></tr>
		    
		    <tr>
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		       		  <tr>
		                    <td class=title width=12%>�����Աݾ�</td>
		                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num' readonly  > ��</td>
		                    <input type='hidden' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>' size='15' class='num' readonly  >
		                    <td colspan=6>&nbsp;�� �̳��ݾװ� - ȯ�ұݾװ� - �߰��Աݾ�</td>
		              </tr>
		              
		              </table>
		         </td>       
		    <tr>
		    
		    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
    
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		       		  <tr>
		                    <td class=title width=12% >���Կɼǽ�<br>�����Աݾ�</td>
		                    <input type='hidden' name='opt_amt'  value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" >
		                    <input type='hidden' name='sui_d_amt'  value="<%=AddUtil.parseDecimal(cls.getSui_d_amt())%>" >
		                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='15' class='num' readonly  > ��</td>
		                    <td colspan=6>&nbsp;�� �����Աݾ�  + ���ԿɼǱݾ� + ������Ϻ��(�߻��� ���)</td>
		              </tr>
		                       
		              </table>
		         </td>       
   			</tr> 
		    <tr></tr><tr></tr><tr></tr>

	
    	</table>
      </td>	 
    </tr>	  	 	
     
    <tr>    
        <td align="right">
         <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
        <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <% } %>
        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
		
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
		fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));			

	}
			
//-->
</script>
</body>
</html>
