<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	if(m_id.equals(""))	m_id = as_db.getRent_mng_id(l_cd);

	//�⺻����
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "", "");
	
	int pp_s_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
//	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
		//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
 		
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;	
		
		//�ܿ��뿩�Ⱓ ���ϱ� (function ���ó�� ) 	
	String r_ymd[] = new String[3]; 
	String rcon_mon = "";
	String rcon_day  = "";
		
	//20200625����  - r_ymd ����
	String rr_ymd =  String.valueOf(base.get("R2_YMD"));
	
    StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");
				
	while(token1.hasMoreTokens()) {
			
			r_ymd[0] = token1.nextToken().trim();	//��
			r_ymd[1] = token1.nextToken().trim();	//�� 
			r_ymd[2] = token1.nextToken().trim();	//�� 
	}	
		
	//�������� ���Ⱓ ������ ���	 
	if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
	   rcon_mon =  "";
 	   rcon_day =  "";
	} else {
	   rcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
	   rcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
   }     
   
	//��������
	Hashtable sh_ht = shDb.getShBase((String)base.get("CAR_MNG_ID"));
	int  today_dist = 0;
	
	today_dist = AddUtil.parseInt(String.valueOf(sh_ht.get("TODAY_DIST")));
	
	//(String)sh_ht.get("TODAY_DIST"))
			
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
		
		alert("!!!!����Ÿ� �ʰ�����뿩��(M)�� Ŭ���Ͽ� ����Ÿ������ �ݵ�� �����ϰ� �ݾ�Ȯ���ϼ���!!!!");
					
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
													
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
		
			//�������� ��ุ���� 2������ ��� ���Կɼ� ��� �Ұ�
			if ( count > 61 ) {  
			  	alert("�������� ��ุ���� 2���� ������ ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");
			  	set_day();  
			  	return;				
			}
			
			if(fm.opt_chk.value != '1' ){ //���Կɼ� ���ý� ���÷���		
			  	alert("����� ���Կɼ� ������ �����ϴ�. �̰��� ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");
			  	set_day();  
			  	return;				
			}			
		}
										
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
			tr_opt.style.display 		= '';  //���Կɼ�	
			tr_sale.style.display		= '';	//�����Ű�
		}else{
			tr_opt.style.display 		= 'none';	//���Կɼ�
			tr_sale.style.display		= 'none';	//�����Ű�	
		 	set_day();  
		}
			
		set_init();
	  
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
	   	fm.fdft_amt3.value='0';  //�����Ű�
	  	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
								
			//�����Ϻ��� �������ڰ� ���� ��� �����Ϸ� �ٽ� ����
			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 			
				set_day_sui(fm.rent_end_dt.value);											
			}
			
			set_cls_s_amt();
		}	
		
	
		set_day();
	
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
		
		alert("!!!!����Ÿ� �ʰ�����뿩��(M)�� Ŭ���Ͽ� ����Ÿ������ �ݵ�� �����ϰ� �ݾ�Ȯ���ϼ���!!!!");
	//	alert("!!!!����Ÿ� �ʰ�����δ�ݰ��� ����� �ݿ����� ������, ��Ȯ�� �ݾ��� Ȯ���Ϸ���  ������������ ������������ �Ͽ� ó���ϼ���!!!!");
		
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
		
		if(fm.cls_st.value == '8'){ //���Կɼ� ���ý� ���÷���
								
			if(fm.opt_chk.value != '1' ){ //���Կɼ� ���ý� ���÷���		
			  	alert("����� ���Կɼ� ������ �����ϴ�. �̰��� ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");
			  	tr_opt.style.display 		= 'none';	//���Կɼ�
			  	fm.action='./lc_cls_c_nodisplay.jsp';
				fm.cls_st.value="";				
			} else {
							
				//�������� ��ุ���� 2������ ��� ���Կɼ� ��� �Ұ�
				if ( count > 61 ) { 
					alert("�������� ��ุ���� 2���� ������ ��� ���Կɼ��� ����Ҽ� �����ϴ�.!!!!"); 	
					tr_opt.style.display 		= 'none';	//���Կɼ�
					fm.action='./lc_cls_c_nodisplay.jsp';
					fm.cls_st.value="";	
					fm.dly_c_dt.value="";		
							  			
				} else {
					if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 		
					    fm.dly_c_dt.value = fm.cls_dt.value;
				  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
				    } else { 
				   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
				    }
				}	
			}
			
		}else {
		
		   	fm.action='./lc_cls_c_nodisplay.jsp';		
		}	
				
		fm.target='i_no';
		fm.submit();
	}	
	
			//����� �������ڷ� �ٽ� ���
	function set_day_sui(cls_dt){
		var fm = document.form1;	
				
		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.cls_dt.value+'&cls_gubun=Y&cls_dt='+cls_dt;		
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
				fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //�ܿ��뿩�Ⱓ���� ��� - 20190827
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
						
			//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
			//	fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
				
		if(fm.pp_s_amt.value != '0') {
		   	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //������
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
		
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
										
		obj.value=parseDecimal(obj.value);
			
		
		//������ �� ���Աݰ��� vat 	
		fm.ex_di_v_amt.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
		
			//���� �ΰ��� ����Ͽ� ���Ѵ�.	 		
		var no_v_amt = 0;
	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) +   ( toInt(parseDigit(fm.over_amt.value)) * 0.1) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );	
		
		if ( fm.dft_tax.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ (toInt(parseDigit(fm.dft_amt.value))*0.1)    );	
		}		
									
		if ( fm.etc4_tax.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ (toInt(parseDigit(fm.etc4_amt.value))*0.1)    );	
				 
		}	
		set_cls_s_amt();
	}
				
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			}			
		}
		
		set_cls_s_amt();
	}
					
		
		//���ݰ�꼭 check ���� �ΰ��� - �������Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - �ܻ����� ����
	function set_vat_amt(obj){
		var fm = document.form1;
						
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
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.dft_amt){ //�ߵ�����		
			if ( fm.dft_tax.checked == true) {
	 				fm.dft_v_amt.value  	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.dft_v_amt.value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt){ //ȸ�����ֺ��
			
		}else if(obj == fm.etc2_amt){ //ȸ���δ���
		
		
		}else if(obj == fm.etc4_amt){ //��Ÿ���ع���
				
			if ( fm.etc4_tax.checked == true) {
				 	fm.etc4_v_amt.value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.etc4_v_amt.value  	= '0';
			}
			
		}else if(obj == fm.over_amt_1){ //�ʰ�����δ��
				
		}	
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 		
		var no_v_amt = 0;
	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt.value)) * 0.1) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
													
		var no_v_amt2 	 = no_v_amt;
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );	
		
		if ( fm.dft_tax.checked == true) {
				     fm.no_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.dft_v_amt.value)));	
		}		
									
		if ( fm.etc4_tax.checked == true) {
				    fm.no_v_amt.value 	=  parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));	
		}					
		
		set_cls_s_amt();	
				
	}	
		
		//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
			
		fm.dfee_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 			
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 		 	
	 	if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			
		}
				
	}
		
	//�ʰ�����Ÿ� �󼼺���	
	function view_over_agree(){
		var fm = document.form1;
		
		if ( fm.cls_st.value =='') {
			  alert ("���걸���� �����ϼ���!!!");
			   return;
		} else {
			var SUBWIN="/fms2/lc_rent/view_over_agree.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=fee_size%>&tot_dist="+fm.tot_dist.value+"&cls_st="+fm.cls_st.value+"&cls_dt="+fm.cls_dt.value;
			window.open(SUBWIN, "ViewOverAgree", "left=50, top=50, width=850, height=700, scrollbars=yes, status=yes");
		}	
	}	
		
	function set_msg(){
		var fm = document.form1;
		
		fm.over_amt.value = "";
		fm.dist_msg.value = '!!! �ʰ�����뿩�Ḧ Ȯ���ϼ��� !!!';
		
		set_init();
	}	
//-->
</script>
</head>
<body>
<form name='form1' method='post' >
<input type='hidden' name="rent_mng_id" 		value="<%=m_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">  
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'> <!--�������� �Ѱ�ణ -->
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>

<input type='hidden' name='ifee_amt' value='<%=base.get("IFEE_AMT")%>'>
<input type='hidden' name='use_s_dt' value='<%=base.get("USE_S_DT")%>'> <!-- ��������� ����ū ������ -->
<input type='hidden' name='use_e_dt' value='<%=base.get("USE_E_DT")%>'><!-- ��������� ����ū ������ -->  

<input type='hidden' name='dly_s_dt' value='<%=base.get("DLY_S_DT")%>'>   <!-- ��ü�� ���� ������¥ -->

<input type='hidden' name='dft_v_amt' value=''> <!--��������� vat - ��꼭 ����� --> 
<input type='hidden' name='etc4_v_amt' value=''> <!--��Ÿ���ع��� vat - ��꼭 ����� --> 
<input type='hidden' name='r_con_mon' value='<%=base.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->
<input type='hidden' name='ex_ip_amt' value='0'>
<input type='hidden' name='opt_chk' value='<%=ext_fee.getOpt_chk()%>'>

<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'  >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ׾ƴ� -->
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->
<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'> 

<input type='hidden' name='s_mon' value='<%=base.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base.get("S_DAY")%>'> 

<input type='hidden' name='dly_c_dt' value=''> <!-- ���Կɼ� 2������ ��ü���� ��꿡 ��� : �뿩��� ������� ���ڴ� ����ñ��� -->

<input type='hidden' name='lfee_mon' value='<%=base.get("LFEE_MON")%>'> <!--�����ϱ��� ������Ⱓ -->
 
<input type='hidden' name='hs_mon' value='<%=base.get("HS_MON")%>'>  <!-- �ܾ������� �̳����� -->
<input type='hidden' name='hs_day' value='<%=base.get("HS_DAY")%>'>  <!-- �ܾ������� �̳����� -->

<input type='hidden' name='rc_s_amt' value='<%=base.get("RC_S_AMT")%>'> <!--���� �ݾ� --> 
<input type='hidden' name='rc_v_amt' value='<%=base.get("RC_V_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_s_amt' value='<%=base.get("RR_S_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_v_amt' value='<%=base.get("RR_V_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_amt' value='<%=base.get("RR_AMT")%>'> <!-- ���� �ݾ� --> 

<input type='hidden' name='tot_dist_cnt' > <!-- �ʰ����� �˾� --> 

  <table border="0" cellspacing="0" cellpadding="0" width=630>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; ���뿩 ���� ���꼭 &gt;</font></td>
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
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> ����)</td>
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
                <option value="1">��ุ��</option>             
                <option value="2">�ߵ��ؾ�</option>   
                <option value="8">���Կɼ�</option>           
              </select> </td>
                    
            </td>
            <td class='title' width="11%"><font color="#FF0000">*</font>���������</td>
            <td width="15%"> 
              <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>'' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
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
    
    <%for(int i=0; i<fee_size; i++){
			ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i+1));
			if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
    	  }
     }
     %> 
				
    <!-- ���� -->
   
   <tr id=tr_opt style='display:none'> 
 	  <td colspan="2"> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
    	  <tr>
			    <td style='height:10'></td>
		  </tr> 
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�</span></td>
 	 	  </tr>
 	 	
 	 	  <tr>
 	 	  	 <td class='line' >  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 		          	
		          	<input type='hidden' name='mopt_per' value='<%=s_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type="hidden" name="sui_st" value="N" >
		          	<input type="hidden" name="sui_d_amt" value="0" >
		 	 	     <td class='title'>���Կɼ���</td>
		             <td>&nbsp;<input type='text' name='opt_per' value='<%=s_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title'>���Կɼǰ�</td>
		             <td colspan=4>&nbsp;<input type='text' name='opt_amt'size='11' class='num' value="<%=AddUtil.parseDecimal(s_opt_amt)%>" onBlur='javascript:this.value=parseDecimal(this.value);'> (VAT����)</td> 
		          </tr>	
		          
		       </table>
		      </td>        
         </tr>   
     	</table>
      </td>	 
    </tr>	  	 	    
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
                    </td>
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
                    </td>
                  <td align=center>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    </td>
                  <td class='title'>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    </td>
                  <td align=center>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    </td>
                  <td align=center>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    </td>
                  <td class='title'>=������-������ �����Ѿ�</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt'  readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
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
                  <td class="title" rowspan="19" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class="title" colspan="3">���·�/��Ģ��(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' readonly  onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                 </tr>
                 <tr> 
                  <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                 <tr>
                  <td class="title" rowspan="4" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    </td>
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
                    </td>
                  <td width='35%' align=center>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">�Ұ�(F)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' size='15' name='dfee_amt'  readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
                  <td class='title' width='35%'>&nbsp;</td>
                      <input type='hidden' name='d_amt' size='15' class='whitenum' >
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
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_s_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    </td>
                  <td width='35%' align=center>=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    </td>
                  <td width='35%' align=center>=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=rcon_mon%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' name='rcon_day' size='3' value='<%=rcon_day%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    ��</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    </td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>����� 
                    �������</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='dft_int' value='<%=base.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                    %</td>
                  <td width='35%' align=center>����� ��������� ��༭�� Ȯ��</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(G)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'>
                    </td>
                  <td class='title' width='35%'>&nbsp;<input type='hidden' name='dft_tax' value='N' ></td>
                </tr>      
           
                <tr> 
                  <td class="title" rowspan="6" width="5%"><br>
                    ��<br>
                    Ÿ</td> 
                  <td class="title" colspan="2" >��ü��(H)</td>
                  <td width='35%' align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    </td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr>
                  <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                    </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">����ȸ���δ���(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                    </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">������������(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                    </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">��Ÿ���ع���(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                    </td>
                  <td class='title' width='35%'>&nbsp;<input type='hidden' name='etc4_tax' value='N' ></td>
                </tr>
                <input type='hidden' name='etc5_amt'>
          
                <tr> 
                  <td class="title" colspan="2">�ʰ�����뿩��(M)
                  </td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='over_amt' value=''  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                    </td>
                  <td class='title' width='35%'>&nbsp;* ��������Ÿ� <input type='text' name='tot_dist' value='<%= AddUtil.parseDecimal(today_dist) %>' size='6' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_msg();'>km
                   <a href="javascript:view_over_agree()" onMouseOver="window.status=''; return true" hover><img src="/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>
                        <!--  -->   
                  </td>
                </tr> 
         
                <tr> 
                  <td class="title" colspan="3">�ΰ���(N)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='no_v_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
                  <td class='title' width='35%'> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=(F+M-B-C)��10%  </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(F+M-B-C)��10% </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">��</td>
                  <td class='title' align="center"> 
                    <input type='text' name='fdft_amt1' value='' size='15' class='num'  readonly onBlur='javascript:this.value=parseDecimal(this.value); '>
                    </td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L+M+N)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style='height:10'></td>
        </tr> 
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� �����Ͻ� �ݾ�</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">�������Աݾ�</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='' size='15' class='num' maxlength='15'>
                    </td>
                  <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                </tr>
              </table>
            </td>
          </tr>
          
            <tr></tr><tr></tr><tr></tr>
        <tr id=tr_sale style='display:none'> 
            <td class=line  colspan="2">
                <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=30%>���Կɼǽ� �������Աݾ�</td>
                    <td width=35% class='title' align=center>&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  > </td>
                    <td width=35% class='title' align=center>&nbsp;�� �������Աݾ�  + ���Կɼǰ� + ������Ϻ��(�߻��� ���)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
    <tr>
            <td style='height:10'></td>
    </tr> 
    
          <%	//���ຸ������
			//	ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);
         		 ContGiInsBean gins = a_db.getContGiInsNew(m_id, l_cd, Integer.toString(fee_size));
				
				%>
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
                    </td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;<span class=style2><input type='text' name='dist_msg' value='!!! �ʰ�����뿩�Ḧ Ȯ���ϼ��� !!!' size='30' class='whitetext' ></span></td>
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
			
		if(fm.r_day.value != '0'){
	 		
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������
					
			} else { //�뿩�������� ���ڰ� �ִ���.. �ܿ��뿩�Ⱓ��� ����2010-07-06  - 30�ϱ������� ��� 
				 			
			 	  if (	toInt(fm.r_day.value) + toInt(fm.rcon_day.value) == 31 ) {
			 		//  if ( toInt(fm.rent_start_dt.value) <= 20170420 ) {	//20170420���� �����+1�� ���� 31���� ���� �� ����.		 		
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
			 		//  }	
				  } else  if (toInt(fm.r_day.value) + toInt(fm.rcon_day.value) < 30 ) {
					
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  }		
			
			}		
		}
		
		//0 ���� ���� ���	
		if(toInt(fm.r_day.value)  <0){
			fm.r_day.value = '0';			
		}	 
 			 				
 		if(toInt(fm.nfee_day.value)  <0){
			fm.nfee_day.value = '0';			
		}		    
								
		//�������� ��ุ���Ϻ��� ū ��� �������� setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
			fm.cancel_yn.value = 'N';
			fm.cancel_yn[1].checked = true;
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		}
								
			//���Կɼ��� ��� �������� setting
		if ( fm.cls_st.value == '8') { //���Կɼ� 		
			fm.cancel_yn.value = 'N';
			fm.cancel_yn[1].checked = true;
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
			tr_sale.style.display 			= '';  //�����Ű��� �������Աݾ�
		}	
		
				
		//���ô뿩�ᰡ �ִ� ��� - ����Ⱓ 
		if(toInt(fm.ifee_s_amt.value)  != 0){
	//	if(fm.ifee_s_amt.value != '0'){
		
		//	ifee_tm = parseDecimal((toInt(parseDigit(fm.ifee_s_amt.value))+ 1) / toInt(parseDigit(fm.nfee_s_amt.value)));
			ifee_tm = Math.round(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm);			
				
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			} else {
			   	 fm.ifee_mon.value = "0";  //�ʱ�ȭ
		   		 fm.ifee_day.value  = "0";			
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
					
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )  ));														  //�ܾ�
								
			if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //����
							
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������  - ���ô뿩�� ��ü �� ������
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 		    		
	    		v_rifee_s_amt = 0;		    		
		   	} 
		   		   		     	
		   	if ( v_rifee_s_amt == 0) { //�������� 
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	    		v_rifee_s_amt = 0;	  
	    	}	  		
					
		}
	
		//���ô뿩�ᰡ �������� �뿩�Ḧ ���� ������ ��� ó�� - 20100924 �߰�
		if(toInt(fm.ifee_s_amt.value)  != 0){
	//	if(fm.ifee_s_amt.value != '0'){
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� ���� ���
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
		 }
	    
		//�ܿ�������?
		if(toInt(fm.pp_s_amt.value)  != 0){		
	//	if(fm.pp_s_amt.value != '0'){			
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //������	    		
		    	   fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value 	= 0;
				   fm.rfee_s_amt.value 	= 0;
		    } else { 			
					fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.lfee_mon.value) );
					fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //�ܿ��뿩�Ⱓ���� ��� - 20190827
					fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
		    }						
			
		  //fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
		  //fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
		
		}
		
		
		// �����ݾ��� ����� ���
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { 
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 		
		
	
		
		//���Կɼ��� ���
		//������, ���ô뿩�ᰡ ���� �ִ� ��� -  ���� �� �ߵ����Կɼ� - �ܾ��� 0���� ����, ����� �����Ѵ� ���� �ܾ� �߻�����  ���� ���� 
		if ( fm.cls_st.value == '8') { //���Կɼ� 		
	    	 if  ( toInt(fm.fee_size.value) < 2 ) { //������ �ƴϸ� 	 - ������ 0ó��	
	    		   fm.ifee_mon.value = '';  //�ʱ�ȭ
			   	   fm.ifee_day.value  = '';			
				   fm.ifee_ex_amt.value = 0;
		    	   fm.rifee_s_amt.value = 0; 
		    	 
		    	   v_rifee_s_amt = 0;	  
	    		   fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value = 0;
				   fm.rfee_s_amt.value 	= 0;
				
	    	 }
		
	    	 if ( v_rifee_s_amt > 0 ) {
	    	     alert("���ô뿩�� �ܾ��� �ֽ��ϴ�. ����� �����ϼ��� !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  				  		      		  
	  		 } else {		   	
	    	 	fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 		    		
	    		v_rifee_s_amt = 0;
	    	 }
		
	   
	  		 if (toInt(parseDigit(fm.rfee_s_amt.value)) > 0 ) {
	  		     alert("������ �ܾ��� �ֽ��ϴ�. ����� �����ϼ��� !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  			 		  		      		  
	  		 } else {		   	
	  			fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
	    	}			    
	   	}
		
		//�����ݾ�	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
		    
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}		
	
	  //���ô뿩�ᰡ ���� ��� 		 -- nnfee_s_amt : �̳��ݾ�(�ܾ׾ƴ�). di_amt :�ܾ׹̳��ݾ�  	  -- �뿩���ð� �� ���   
	  	if(toInt(fm.ifee_s_amt.value)  == 0){
	 //   if(fm.ifee_s_amt.value == '0' ) {
		   	 // ������������� �������� �� ū ��� 		  	 		   	 
		    if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		        //��������ü�� ���ٸ� 
	   	 		          var s1_str;
	   	 	             if  ( toInt(fm.use_e_dt.value)  < 1 ) {
	   	 	           	  s1_str = fm.rent_end_dt.value;
	   	 	             } else {
	   	 	 		        s1_str = fm.use_e_dt.value;
		   	 		    	}
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
		   	 		     //������ ����������� �ȵ� - �Ѵ޹̸��� ��� 
		   	 		   	  if ( toInt(fm.s_mon.value) == 0 &&  fm.nnfee_s_amt.value  == '0' ) {
						   		fm.nfee_day.value 	= 	fm.r_day.value;
						  }
		   	 		  } 
		   	 	
		   	}  else {//�������� ����. 
			   	 if  (  toInt(parseDigit(fm.di_amt.value))  > 0  ) { //�̳��� �ִٸ� (1���� �̸� �̸� �̳��� ���ؼ� )
			   	//	 alert("c");
			   	     if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {
			   		  	if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) > 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
							fm.nfee_day.value = toInt(fm.hs_day.value); 
						 }
			   	    }
		
		        } 
	      } //�������� �� ũ�� 
		} //���ô뿩�ᰡ ���� ���	 	   	
		
		
		//������ȸ���ΰ��(�ϼ� ����� �Ѱ��)�� �����쿡 �����ִ� �ݾ����� ó�� ..			
		/*
		if (fm.ifee_s_amt.value == '0' ) {	
		   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   	 	if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //���Ⱓ�� ������ ����� ������ 
				        if  ( fm.nfee_amt.value  != '0' ) {
					          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
				 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;
				 	       		if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	       		}	
					 	       }	
					     }	 
			    	}		    	
	    	}	    	
	   }
		*/
	
	 /*
	  	if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //�ܾ��� �ִٸ� 
	   	   	    	   if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
	   	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //�������� ���̸鼭 �ϴ��� �̳��뿩�ᵵ �ߺ����� ������ ��� - 20170324
	   	   	    				
	   	   	    				 	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //�����ݾ�  - �����ݾ�    		
					      	 	   fm.nfee_amt.value = fm.nnfee_s_amt.value;    
					      	 	   fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
									if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	      	}
						 	 }     		
						}
						
						 if ( toInt(parseDigit(fm.hs_mon.value)) >0  &&  toInt(parseDigit(fm.hs_day.value)) > 0 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
					 			 fm.nfee_mon.value 	= 	 toInt(fm.hs_mon.value);  //�ܾ��� �ִ� �̳����� ������.
					   	    	  
					   	    	 if  ( fm.nnfee_s_amt.value  != '0' ) {
					   	    		 	  fm.nfee_day.value 	= 	 toInt(fm.hs_day.value);  //�ܾ��� �ִ� �̳����� ������.	
					   	    	 }						 
						 } 	       	
	   	   	    	}	   	   	
	   }  	   	
	 */
	 
	 //�̳��ܾ��� �ְ� , 1�����̻� �̳��� �� ���� ���  	 	
	 if (  toInt(parseDigit(fm.di_amt.value)) > 0 && toInt(parseDigit(fm.s_mon.value)) > 1 ) {		 
		 if (  toInt(parseDigit(fm.rr_s_amt.value)) - toInt(parseDigit(fm.rc_s_amt.value))   >   toInt(parseDigit(fm.nfee_s_amt.value))  ) {	 			 
		  	       fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ���� 		   	    	 				   	    	 						              
		   }
	 }  		
	 
	 //�̳��ܾ��� �ְ� , �� �̳��� �߻��� ��� 
	  if (  toInt(parseDigit(fm.di_amt.value)) > 0  ) {					  
	    if ( toInt(fm.s_mon.value) - 1  >= 0 ) {
	         fm.nfee_mon.value 	= 	 toInt(fm.s_mon.value) - 1;  //�ܾ��� �ִ� �̳����� ������.		     
	    } 		
	 }
	 
	 if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0  &&  toInt(parseDigit(fm.nfee_amt.value)) == 0 ) {  //�ܾ��� �ְ� �̳��� ���ٸ�   	    	 
	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //�������� ���̸鼭 �ϴ��� �̳��뿩�ᵵ �ߺ����� ������ ��� - 20170324  	   	    				
	   	    				fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //�����ݾ�  - �����ݾ�    		
		      	 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;    
		      	 	  //  fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
		      	 	 //   fm.ex_di_v_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_v_amt.value))  -    toInt(parseDigit(fm.rc_v_amt.value)) );  //�����ݾ�  - �����ݾ�    
						if (fm.nfee_amt.value == '0' ) {
			 	       			fm.nfee_day.value = 0;
			 	      	}
			 	 }  
			  	
	   	    	}	   	   	
    }  	   	
	
	 	//20200117 - ���߰��Ǵ�  ��� 	 	
	   	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //�ܾ��� �ִٸ� 	   	 
	    	  if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1  ) {  //�������� ���̸鼭 �ϴ��� �̳��뿩�ᵵ �ߺ����� ������ ��� - 20170324
	    	            fm.ex_di_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.s_mon.value)+toInt(fm.s_day.value)/30) );	
			      	    fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );	
				  }	    	   
			  }
	   	}
	 	
	 
	    
	 //�뿩�ᰡ 100������ ��� ���� ó�� - 2011-01-24.	- �������θ� ó��
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		   if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		   } 
			fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
			fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	   }
	   	  
	    
		//if(toInt(parseDigit(fm.fee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
	//		alert("���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�. Ȯ���Ͻñ� �ٶ��ϴ�.");
		//}
	
		
		//������ȸ���ΰ��(�ϼ� ����� �Ѱ��)�� �����쿡 �����ִ� �ݾ����� ó�� ..
		//���Կɼ��� ���� Ʋ��.
		if ( fm.cls_st.value == '8') { //���Կɼ�  - 2�����̳������� (���꿡����)
			if(toInt(fm.ifee_s_amt.value)  == 0){    
		//	if (fm.ifee_s_amt.value == '0' ) {	
				  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
				     if  ( fm.nfee_amt.value  != '0' ) {
					     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
					 		fm.nfee_amt.value = fm.nnfee_s_amt.value;
					 		
					 	 }	
					 }	 
				  }	
							
			}  
		} else {
			if(toInt(fm.ifee_s_amt.value)  == 0){
		 //	if (fm.ifee_s_amt.value == '0' ) {	
			   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   	 	if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //���Ⱓ�� ������ ����� ������ 
					        if  ( fm.nfee_amt.value  != '0' ) {
						          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
					 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;				 	    
					 	       		if (fm.nfee_amt.value == '0' ) {
					 	       			fm.nfee_day.value = 0;
					 	       		}	
						 	       }	
						     }	 
				    	}		    	
		    	}	    	
	      } 	
	  } 
						
		 // ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )	 
	  if(toInt(fm.ifee_s_amt.value)  != 0){	 
	 // if(fm.ifee_s_amt.value != '0' ) {
	 
		   	if (v_rifee_s_amt <= 0 ) {  //���ô뿩�Ḧ �� ������ ���  -���ô뿩�� ���� ���� ���� 
		   	      	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
			  		
			  	   if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 			  		  	     
				        if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	          //   alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	
			   	       	   
				  		 } else {  //�̳��� ���� ���  		
				  		  	  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
				  		      
				  		         var s1_str = fm.rent_end_dt.value;
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
							  	   					  	   
							  	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 			  		 
				  		      }			  		
				  		}	
			  	  } else {  //���ô뿩�� ������ ������ ���� �ȵ�.   			  	  
			  	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���   +  ����и�ŭ �뿩�� ��� 
		   		//	       alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");			   	    
				   	     	 var r_tm = 0;     
				   	     	 if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {						 
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����  , �ܾ��� �߻��Ǿ��⿡ 1�� ���� 
						   	 } else {
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
						   	 }
				   					   				   	
						   	 fm.nfee_mon.value 	= r_tm;
						   	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
				  	
						  	 // �����ϰ� �������� ���� ��� - ���ڰ��� ��� �߻� 20110524						  	 
							 if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
							     if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 		fm.nfee_amt.value = fm.nnfee_s_amt.value;						 		
								 	 }	
								 }	 
							 }			   	         
			   	      }else {
			   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");			   	      
			   	           if ( toInt(fm.r_mon.value) > 0 ||  toInt(fm.r_day.value) > 0 ) { 
				   	       	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
					   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
					   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
				   	   		}
				   	   }
			  	  
			  	  }
			  	  
			  }  else {  //���ô뿩�ᰡ ���� ��� (�ߵ������Ǵ� ��� )		
				  	     
				  	     if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
				  	     	  if ( toInt(fm.use_e_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value)) ) {  // ���ô뿩�� �������� 
				  	     	 
					  	     	   if  ( fm.nfee_amt.value  != '0' ) {
							          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 	       		fm.nfee_amt.value =    fm.nnfee_s_amt.value;
						 	       		if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	       		}	
							 	      }	
							       }	
						        			  	     	 
				  	     	 }  else { 	   
				  	            
				  	            fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
				  	         }  
				  	     } 
				  	     
				  	     if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { 
				   	 		    // alert("d1");		   	 		
				   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
				   	 		     	
								  if ( toInt(fm.nfee_mon.value) < 0 ) {
								  	   fm.nfee_mon.value = '0';
								  }
						  }			
								 	 
			 } 
	 	}   
	   		   		
	  	 //�����뿩��� 30�ϱ��� ���???  -
		 //��� //�ѻ���ϼ� �ʱ� ����		//�ܿ��뿩�� �ϼ��� �ٽ� ��� ( 
		// ȯ���� ���)  rcon_mon, rcon_day:�ܿ��뿩�Ⱓ  r_mon, r_day :�̿�Ⱓ 
		//���������� �����쿡 �Աݾ��� �ִ��� Ȯ��??
			
		  //ȯ���ΰ�� ��� -  ���������� ������ 
		 if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
		 
		          //���� �����ΰ�� ���� ���Ǵ� ��쵵 ����.
		        if ( toInt(fm.rent_end_dt.value)  != toInt(replaceString("-","",fm.cls_dt.value)) ) {
		                     
				      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );
				      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	
				      fm.nfee_mon.value = '0';
				      fm.nfee_day.value = '0';				      
				      fm.nfee_amt.value = '0';	
			    }	      		         
		 }
							
	   	//�Ұ� -�뿩�����
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) ); //�뿩���(F)	
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
			
		if(fm.dft_int.value == '')	fm.dft_int.value 			= 30;				
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
		
		//������ �ִ� ��� �뿩�� ȯ�� 
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			//�������� 
			if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
				alert("!!!!!!!���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�.!!!!!!\n\n�̳��� �ִ� ��� �ݵ�� �뿩�� ������ Ȯ�� �� �̳��ݾ��� ����Ͽ� ���� �����ϼ���!!!");
				alert("!!!!!!!���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�.!!!!!!\n\n�̳��� �ִ� ��� �ݵ�� �뿩�� ������ Ȯ�� �� �̳��ݾ��� ����Ͽ� ���� �����ϼ���!!!");
			}
		}
		
				
		var c_fee_v_amt =  0;
	
	    c_fee_v_amt = (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) ;
	    	    
	   
	 /// �ΰ��� ���߱� - 20190904 - �ܾ��� �ƴ� �̳��ݾ��� ���ٸ� (��ȸ���� ���)
		if ( toInt(parseDigit(fm.nfee_amt.value))  == toInt(parseDigit(fm.nnfee_s_amt.value))  ) {
    	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		   
	 	}	
		
			//���Կɼ��� ���� Ʋ��.
		if ( fm.cls_st.value == '8') { //���Կɼ� 			    
			     //����� 0
				fm.dft_amt.value 			= '0';			
	   }
	
		   
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 	 	
		var no_v_amt =0;  //�ΰ����� ������ ���
							 
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt +  (toInt(parseDigit(fm.over_amt.value))*0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
						
	//	no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
	//	alert(	 ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)    );	
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );	
	
		
		if ( fm.dft_tax.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ (toInt(parseDigit(fm.dft_amt.value))*0.1)    );	
		}		
									
		if ( fm.etc4_tax.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ (toInt(parseDigit(fm.etc4_amt.value))*0.1)    );	
				 
		}				
				
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
				
		//������ ������ �ݾ� �ʱ� ����	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			
		}
		
			
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			//�������� 
			if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
				alert("!!!!!!!���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�.!!!!!!\n\n�̳��� �ִ� ��� �ݵ�� �뿩�� ������ Ȯ�� �� �̳��ݾ��� ����Ͽ� ���� �����ϼ���!!!");
			}
		}
	
	  
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