<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(m_id.equals(""))	m_id = as_db.getRent_mng_id(l_cd);

	//�⺻����
	Hashtable base = as_db.getSettleBaseRm(m_id, l_cd, "", "");
	
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
//	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
		//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
		//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(m_id, l_cd, "1");
	
        //
   	String per = f_fee_rm.getAmt_per();
			
	//���뿩���� ������
	Hashtable day_pers = c_db.getEstiRmDayPers(per);

	int add_amt_d = 0;  //1�޹̸� ����� ��� ����� ( ȯ�ұݾ�: �뿩�� - �����)
	int r_day_per = 0;
	
	int day_per[] = new int[30];

	//�������� ī��Ʈ
	int day_cnt = 0;

	//�̿�Ⱓ
	int tot_months = AddUtil.parseInt((String)base.get("R_MON"));  
	int tot_days = AddUtil.parseInt((String)base.get("R_DAY"));  							
								
	for (int j = 0 ; j < 30 ; j++){
		day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
		
		if(j+1 == 30){
			if(day_per[j]>100) 	day_per[j] = 0;
		}else{
			if(day_per[j]>99) 	day_per[j] = 0;
		}
			
		if(day_per[j]>0) 	day_cnt++;	

		if(tot_months == 0){
			//������
			if(j+1 == tot_days)	r_day_per = 	day_per[j];	
		}		
	}			
			
	//�ǻ��Ⱓ 1�����̸�
								
	if(tot_months == 0  ){		
	           if ( day_cnt >  tot_days ) {	
			add_amt_d = (new Double(AddUtil.parseInt((String)base.get("FEE_S_AMT"))	)).intValue() * r_day_per / 100;
		}	

	}else if(tot_months > 0){				

	}
						
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle1.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE1", "left=100, top=10, width=700, height=630, scrollbars=yes, status=yes");		
	}	
		
	
	//Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, scrollbars=yes, status=yes");		
	}	
	
	
		//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
											
		set_init();
	  	   		
	}	
		
	//���÷��� Ÿ��
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[0].checked = true;
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}
	}	
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
			
		fm.action='./lc_cls_rm_c_nodisplay.jsp';		
					
		fm.target='i_no';
		fm.submit();
	}	
	
		
	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //�̿�Ⱓ �� 	
			set_init();
		}
		
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
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
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
	    
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
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
				
		set_cls_amt();
	}	
		
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
										
		obj.value=parseDecimal(obj.value);
	
			
		//����Ʈ ���� �߰�	
		//1�޹̸� ������ ���. ��¥�� ������꿡 ����.
	   	//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_mon.value  == '0' )  {
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //�̳��� �ִٸ�  (�����ε� ���ܷ� �ĳ���)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }           	
			 //����Ʈ�� ������ 
			   if (  toInt(parseDigit(fm.ex_s_amt.value)) < 0 ){
			   	    fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 	        
			   } 			 
		}	
							
		//������ �� ���Աݰ��� vat 				
		fm.ex_di_v_amt.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );			
	//	alert(	fm.ex_di_v_amt.value );
				
			//���� �ΰ��� ����Ͽ� ���Ѵ�.	 		
		var no_v_amt = 0;
	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
				
		fm.d_amt.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}
				
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
				
		
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}			
		}
		
		 //����Ʈ ���� �߰�		
	          //1�޹̸� ������ ���. ��¥�� ������꿡 ����.
	   	//�ѻ���ϼ� �ʱ� ����	- ����Ʈ�ΰ�� 1���� �̸��� ��� ���� ���� - 1���� ���� ���� �ߵ����� ����� �߻�		
		if(fm.r_mon.value  == '0' )  {
			fm.dft_amt.value 	= '0';
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {
			 	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.add_amt_d.value)) ) ; 	         
			 }           	
		}		
		
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}
					
	//�������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value))+ toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		
	}
	
	
		//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - �ܻ����� ����
	function set_vat_amt(obj){
		var fm = document.form1;
	
	//	fm.dft_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
				
		if(obj == fm.dft_tax){ // �����
			fm.dft_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
					
		 	if (obj.checked == true) {
		 			fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.dft_v_amt.value)));	
		 			fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))+ toInt(parseDigit(fm.dft_v_amt.value)));	
				 	fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.dft_v_amt.value)));			
						
			} else {
					fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))- toInt(parseDigit(fm.dft_v_amt.value)));	
					fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))- toInt(parseDigit(fm.dft_v_amt.value)));	
					fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.dft_v_amt.value)));			
					
			}	
			
			
		} else if(obj == fm.etc4_tax){ // ��Ÿ���ع��� - ȸ���� �Ǵ��Ͽ� ��å�ݵ��� �߰��� ��
			if (  toInt(parseDigit(fm.etc4_amt.value))  < 1   &&  obj.checked == true ) {
			     alert ("�ݾ��� �����ϴ�. Ȯ���ϼ���!!!");
			     obj.checked = false;
			}    
			
			
			fm.etc4_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
			
		 	if (obj.checked == true) {
		 			fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));	
		 			fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));	
				 	fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));			
						
			} else {
					fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))- toInt(parseDigit(fm.etc4_v_amt.value)));	
					fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))- toInt(parseDigit(fm.etc4_v_amt.value)));	
					fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.etc4_v_amt.value)));			
					
			}		
		}	
				
	}	
	
		//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
					
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 			
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 			
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' >
<input type='hidden' name="rent_mng_id" 		value="<%=m_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=l_cd%>">
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base.get("FEE_S_AMT")%>'>
<input type='hidden' name='use_s_dt' value='<%=base.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base.get("USE_E_DT")%>'> 

<input type='hidden' name='dft_v_amt' value=''> <!--��������� vat - ��꼭 ����� --> 
<input type='hidden' name='etc4_v_amt' value=''> <!--��Ÿ���ع��� vat - ��꼭 ����� --> 
<input type='hidden' name='r_con_mon' value='<%=base.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->
<input type='hidden' name='ex_ip_amt' value='0'>

<input type='hidden' name='add_amt_d' value='<%=add_amt_d%>' >  <!--���̿�Ⱓ�� ���� ����ݾ� (1���� �̸� ����� ���) -->
 <input type='hidden' name='day_cnt' value='<%=day_cnt%>' >  <!--���̿�Ⱓ�� ����  �̿��ϼ� ����ǥ �� ���ϱ� -->
 
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'  >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ׾ƴ� -->
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->
<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'> 

<input type='hidden' name='s_mon' value='<%=base.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base.get("S_DAY")%>'> 

<input type='hidden' name='hs_mon' value='<%=base.get("HS_MON")%>'>  <!-- �ܾ������� �̳����� -->
<input type='hidden' name='hs_day' value='<%=base.get("HS_DAY")%>'> <!-- �ܾ������� �̳����� -->

<input type='hidden' name='dly_c_dt' value=''> <!-- ���Կɼ� 2������ ��ü���� ��꿡 ��� : �뿩��� ������� ���ڴ� ����ñ��� -->

<input type='hidden' name='lfee_mon' value='<%=base.get("LFEE_MON")%>'> <!--�����ϱ��� ������Ⱓ -->

<input type='hidden' name='rc_s_amt' value='<%=base.get("RC_S_AMT")%>'> <!--���� �ݾ� --> 
<input type='hidden' name='rc_v_amt' value='<%=base.get("RC_V_AMT")%>'> <!-- ���� �ݾ� --> 

<input type='hidden' name='rr_s_amt' value='<%=base.get("RR_S_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_v_amt' value='<%=base.get("RR_V_AMT")%>'> <!-- ���� �ݾ� -->
<input type='hidden' name='rr_amt' value='<%=base.get("RR_AMT")%>'> <!-- ���� �ݾ� -->

  <table border="0" cellspacing="0" cellpadding="0" width=630>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; ����Ʈ ���� ���꼭 &gt;</font></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='11%' class='title'>����ȣ</td>
            <td width="15%"><%=l_cd%></td>
            <td width='10%' class='title'>��ȣ</td>
            <td><%=base.get("FIRM_NM")%></td>
            <td class='title' width="10%">������ȣ</td>
            <td width="14%"><%=base.get("CAR_NO")%></td>
            <td class='title' width="10%">����</td>
            <td width="15%"><%=base.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="11%">�뿩���</td>
            <td width="15%"><%=base.get("RENT_WAY")%></td>
            <td class='title' width="10%">���Ⱓ</td>
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="11%">���뿩��</td>
            <td width="15%"><%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>��</td>
            <td class='title' width="10%">������</td>
            <td width="15%"><%=AddUtil.parseDecimal((String)base.get("PP_S_AMT"))%>��</td>
            <td class='title' width="10%">���ô뿩��</td>
            <td width="14%"><%=AddUtil.parseDecimal((String)base.get("IFEE_S_AMT"))%>��</td>
            <td class='title' width="10%">������</td>
            <td><%=AddUtil.parseDecimal((String)base.get("GRT_AMT"))%>��</td>
          </tr>
          <tr> 
            <td class='title' width="11%"><font color="#FF0000">*</font>���걸��</td>
            <td width="15%"> 
              <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---����---</option>
                <option value="14">����Ʈ����</option>             
       <!--         <option value="2">�ߵ��ؾ�</option> -->   
          
              </select> </td>
                    
            </td>
            <td class='title' width="11%"><font color="#FF0000">*</font>���������</td>
            <td width="15%"> 
              <input type='text' name='cls_dt' value='<%=base.get("CLS_DT")%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
            </td>
            <td class='title' width="10%">�̿�Ⱓ</td>
            <td colspan="3"> 
              <input type='text' name='r_mon' value='<%=base.get("R_MON")%>' readonly  class='text' size="2">
              ���� 
              <input type='text' name='r_day' value='<%=base.get("R_DAY")%>'  class='text' size="2" onBlur='javascript:set_cls_amt1(this);'>
              �� </td>         
          </tr>
          <tr> 
            <td class='title' colspan="2"><font color="#FF0000">*</font>�ܿ������� 
              ������ҿ���</td>
            <td colspan="2"> 
              <input type="radio" name="cancel_yn" value="Y" checked  onclick="javascript:cancel_display();">
              ������� 
              <input type="radio" name="cancel_yn" value="N" onclick="javascript:cancel_display();">
              ��������</td>
             <td colspan="4"><font color="#999999">�� ������ҽ� ���̳ʽ� ���ݰ�꼭 ����</font></td>  
          </tr>
        </table>
      </td>
    </tr>
 				
    <!-- ���� -->
    <tr>
    <td style='height:10'></td>
    </tr> 
    <tr> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        
          <tr> 
            <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span></td>
            <td align="right">[���ް�]</td>
          </tr>
          <tr> 
            <td  colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">�׸�</td>
                  <td class='title' width='35%' align="center">����</td>
                  <td class='title' width="35%">���</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">ȯ<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class='title' colspan="2">������(A)</td>
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td cwidth="15%" align="center" width="20%">����Ⱓ</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    ��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td cwidth="15%" align="center" width="20%">����ݾ�</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td align=center>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td class='title'>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td align=center>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td align=center>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    ��</td>
                  <td class='title'>=������-������ �����Ѿ�</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style='height:10'></td>
        </tr> 
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��Աݾ� ����</span></td>
            <td align='right'>[���ް�]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">�׸�</td>
                  <td class="title" width='35%'> ����</td>
                  <td class="title" width='35%'>���</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="18" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class="title" colspan="3">���·�/��Ģ��(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' readonly  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                 </tr>
                 <tr> 
                  <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                 <tr>
                  <td class="title" rowspan="5" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>&nbsp; </td>
                </tr>
            
                <tr> 
                  <td rowspan="2" align="center" width="5%">��<br>
                    ��<br>
                    ��</td>
                  <td width='15%' align="center">�Ⱓ</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' readonly class='num' maxlength='4' >
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="15%">�ݾ�</td>
                  <td width='35%' align="center"> 
                    <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%' align=center>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">��ü��</td>
                  <td width='35%' align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">�뿩�� ��(F)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="6" class="title">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">�뿩���Ѿ�</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%' align=center>=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%' align=center>=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>����� 
                    �������</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='dft_int' value='<%=base.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                    %</td>
                  <td width='35%' align=center>����� ��������� ��༭�� Ȯ��</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(G)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;<input type='checkbox' name='dft_tax' value='Y' onClick="javascript:set_vat_amt(this);">��꼭����</td>
                </tr>      
           
                <tr> 
                  <td class="title" rowspan="5" width="5%"><br>
                    ��<br>
                    Ÿ</td> 
                  <td class="title" colspan="2">����ȸ�����ֺ��(H)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">����ȸ���δ���(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">������������(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">��Ÿ���ع���(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;<input type='checkbox' name='etc4_tax' value='Y' onClick="javascript:set_vat_amt(this);">��꼭����</td>
                </tr>
                <input type='hidden' name='etc5_amt'>
                <!--
                <tr> 
                  <td class="title" colspan="2">��Ÿ(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc5_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr> -->
                <tr> 
                  <td class="title" colspan="2">�ΰ���(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=(�뿩�� 
                          �̳��Աݾ�-B-C)��10%  </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(�뿩�� 
                         �̳��Աݾ�-B-C)��10% </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">��</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style='height:10'></td>
        </tr> 
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �����Ͻ� �ݾ�</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">�����Աݾ�</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='' size='15' class='num' maxlength='15'>
                    ��</td>
                  <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                </tr>
              </table>
            </td>
          </tr>
          

    <tr>
            <td style='height:10'></td>
    </tr> 
    
          <%	//���ຸ������
				ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ����</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(gins.getGi_st().equals("1")){%>����<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>����<%}%>
                  </td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                    ��</td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    
    <tr> 
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݰ���</span>&nbsp;&nbsp;&nbsp; �������� 140-004-023871 (��)�Ƹ���ī  </td>
    </tr>
    
    <tr> 
      <td>&nbsp; </td>
      <td align="right"> 
      <a href="javascript:view_cng_etc('<%=m_id%>','<%=l_cd%>');" class="btn" title='Ư�̻���'><img src=../images/center/button_tish.gif align=absmiddle border=0></a>
     &nbsp;<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
     
      </td>
    </tr>
  </table>  
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
		
			
		//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}		
								
		//�������� ��ุ���Ϻ��� ū ��� �������� setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
			fm.cancel_yn.value = 'N';
			fm.cancel_yn[1].checked = true;
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		}
				
		//�ܿ�������?
		if(fm.pp_s_amt.value != '0'){
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );//+ toInt(parseDigit(fm.ifee_s_amt.value)) 
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
		
		// �����ݾ��� ����� ���
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { 
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 		
	   	
		//�����ݾ�	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
		    
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}		
						
		//����Ʈ ȯ��ݾ� - 2�����̸��ΰ�� ���뿩��� ���
		if( toInt(fm.r_mon.value)   < 2 )  {
		     	   fm.mfee_amt.value = fm.nfee_s_amt.value;
	   } else {
	        	     fm.nfee_s_amt.value = fm.mfee_amt.value;  //2�����̻��� ���� 5% dc�� ���ش뿩��	          
	   }	        			
			
	   //���ô뿩�ᰡ ���� ��� 		 -- nnfee_s_amt : �̳��ݾ�(�ܾ׾ƴ�). di_amt :�ܾ׹̳��ݾ�  	  -- �뿩���ð� �� ���     	
	   if(fm.ifee_s_amt.value == '0' ) {
		   	 // ������������� �������� �� ū ��� 
	     if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		//    	 alert("b");
		   	 		    	var s1_str = fm.use_e_dt.value;
							var e1_str = fm.cls_dt.value;
							var  count1 = 0;
								
									   
							var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
							var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
					
							var diff1_date = e1_date.getTime() - s1_date.getTime();
					
							count1 = Math.floor(diff1_date/(24*60*60*1000));									
								
					  	   	if ( count1 >= 0 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)					  	   	
					  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
					  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	   }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	   	  fm.nfee_mon.value = '0';
						  }
		   	 		     
		   	 		  } 
		   	 	
		   	} //�������� ����.  		  
		
		} //���ô뿩�ᰡ ���� ���	 	   		   		
		  	
						       			
		//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
		//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
		//�����ٻ����ȵ� ����ϼ� �� ���
		//�뿩�ᰡ 100������ ��� ���� ó�� - 2011-01-24.				
	
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
			  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   		fm.nfee_day.value = '0';
			  } 
			  fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
			  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		}
	
		if (fm.ifee_s_amt.value == '0' ) {	
		  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		      if  ( fm.nfee_amt.value  != '0' ) {
			     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
		 	    	   fm.nfee_amt.value = fm.nnfee_s_amt.value;
			 	 }	
			  }	 
		   }		  
		}  			
					
	       	  //����Ʈ ���� �߰�		
	   	//1�޹̸� ������ ���. ��¥�� ������꿡 ����.
	   	//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_mon.value  == '0' )  {
		    if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //�̳��� �ִٸ�  (�����ε� ���ܷ� �ĳ���)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }      
			     							   
				       //�����뿩�� - ���������� ������ 
			   if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
			            
					   if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
					   	  	  fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 					   	  	  
					   	   	 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		 
					   	   	 fm.nfee_mon.value = '0';
							 fm.nfee_day.value = '0';
							 fm.nfee_amt.value = '0';			            
				      }   	 
			  } 
		   	
		//	   alert(  parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) );
			 
		} else {   //�ܿ��뿩�� �ϼ��� �ٽ� ��� ( ȯ���� ���)  rcon_mon, rcon_day:�ܿ��뿩�Ⱓ  r_mon, r_day :�̿�Ⱓ 
		 		 //����Ʈ�� ������   - ������ ���� �Աݰ��� �ִٸ�  
			    // �Ϻ��� �ȵȰ��� ���� ������ �ϴ� ó�� - �������� ���� ���
			       			        
				          if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
				        		      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
								      fm.nfee_mon.value = '0';
								      fm.nfee_day.value = '0';
								      fm.nfee_amt.value = '0';			         
				          }
			
		}	
			
	 //        alert( fm.nfee_amt.value );
	 	
	   	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
			
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		
		//�ܿ��Ⱓ �뿩�� �Ѿ� 
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				 
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}		
			
		
		if(fm.dft_int.value == '' || fm.dft_int.value == '0' )	fm.dft_int.value 			= 10;					
		
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		//����Ʈ-   �ѻ���ϼ� �ʱ� ����	- ����Ʈ�ΰ�� 1���� �̸��� ��� ���� ���� - 1���� ���� ���� �ߵ����� ����� �߻�	
		if(fm.r_mon.value  == '0' )  {
		     if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
				 	fm.dft_amt.value 			= '0';
		      }
		}      
		
		var no_v_amt = 0;		
	
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
	//	alert(	 ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)    );	
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );	
	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//���� ������ �ݾ� �ʱ� ����	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
			
	}	
	
	var msg = " ���Ұ�� ==> �뿩�ὺ���� Ȯ�� ��!!";
	var cnt = 0;
	
	function stat(){
		if(cnt==0){
			window.status = msg;
			cnt++;
		}else{
			window.status = '';		
			cnt--;			
		}
		setTimeout("stat()",500);	
	}
	document.onload = stat();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
