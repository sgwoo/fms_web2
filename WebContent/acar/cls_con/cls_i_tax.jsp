<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");

	//��� ����� ����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	

	//�������ڵ�
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();

	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);

	//�⺻����
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "", "");

	//�뿩������ ����
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(m_id, l_cd, "1"));
	
	//�뿩�������� ��ü����Ʈ
	Vector fee_scd = af_db.getFeeScdDly(m_id);
	int fee_scd_size = fee_scd.size();
	
	//�������뿩�� �� ��ü��
//	Hashtable exdi = as_db.getFeeNoAmt(m_id, l_cd);
		
//	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	
	//������ 	
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
	int t_dly_amt = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
	var v_ifee_ex_amt = 0;  // ���ô뿩�� ����ݾ�
	
	//����ϱ�
	function save(){
		var fm = document.form1;

		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
/*
		if(fm.cls_st.value == '2' && fm.cls_doc_yn.value == 'Y'){
			if(fm.dft_amt.value == '')			{ alert('�ߵ������������ �Է��Ͻʽÿ�'); 	fm.dft_amt.focus(); 	return; }
			else if(fm.fdft_amt1.value == '')	{ alert('�ߵ������������ �Է��Ͻʽÿ�');	fm.fdft_amt1.focus(); 	return; }
		}
		if(!max_length(fm.cls_cau.value, 400))	{ alert('���������� ���� 400��, �ѱ� 200�ڱ��� �Է��� �� �ֽ��ϴ�'); 	fm.cls_cau.focus(); 	return; }
*/			


/*
		//��ุ�� �Ǵ� ���°�� �̼��� ����� ��.
		if(fm.cls_st.value == '1'){// || fm.cls_st.value == '5'
			var nopay_amt = toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value));
			if(nopay_amt > 0){ 	
				if(toInt(parseDigit(fm.ex_di_amt.value)) > 0)	{ 	alert('������ �뿩�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.nfee_amt.value)) > 0)	{ 	alert('�̳��� �뿩�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.dly_amt.value)) > 0)		{ 	alert('�뿩�� ��ü�ᰡ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.car_ja_amt.value)) > 0)	{ 	alert('�ڱ��������ظ�å���� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if(toInt(parseDigit(fm.fine_amt.value)) > 0)	{ 	alert('���·�/��Ģ���� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
			}
		}
*/

		if(fm.cls_st.value == '1' || fm.cls_st.value == '2' || fm.cls_st.value == '4' || fm.cls_st.value == '5'){
			<%if(!nm_db.getWorkAuthUser("ȸ�����",user_id) && !nm_db.getWorkAuthUser("ä�ǰ�����",user_id)){%>
				alert('��ุ��/�ߵ�����/��������/���°� ������ �����ϴ�.');
				return;
			<%}%>			
		}
		
		//���Ҵ� �Ƹ���ī ������������ �� �� �ֽ�. �������� ��� �������� ó���� ���� ó�� -20081210
		if(fm.cls_st.value == '15') {
			 if ( fm.ven_code.value != '000131') {
			     alert("������ ������������ �� �� �ֽ��ϴ�.\n��������, �ߵ��ؾ� ���� ����ó�� �� �����ϼž� �մϴ�.!!!");
			     return;
			 } 
		}
		
		
		if(!confirm('ó���Ͻðڽ��ϱ�?')){ 	return; }
		
//		fm.target='i_no';
		fm.target='CLS_I';
		fm.action='cls_i_tax_a.jsp';
		fm.submit();		
	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '3'){ //�����Һ��� ���ý� ���÷���
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= '';
			tr_opt.style.display 		= 'none';			
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2'){ //�ߵ����� ���ý� ���÷���
			tr_default.style.display	= '';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';	
			fm.cls_doc_yn.value			= 'Y';		
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '1'){ //�������� ���ý� ���÷���
			tr_default.style.display	= '';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';	
			fm.cls_doc_yn.value			= 'Y';		
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= '';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}	

	//���÷��� Ÿ��
	function cls_display2(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2' && fm.cls_doc_yn.options[fm.cls_doc_yn.selectedIndex].value == 'Y'){ //���꼭 ���� 
			tr_default.style.display	= '';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';		
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '1' && fm.cls_doc_yn.options[fm.cls_doc_yn.selectedIndex].value == 'Y'){ //���꼭 ���� 
			tr_default.style.display	= '';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}	

	//���÷��� Ÿ��
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}		
	}	
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
//		fm.action='./cls_nodisplay.jsp';
		fm.action='./cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
		
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
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		 //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
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
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //�̳��Դ뿩�� �Ⱓ
			
								
			//�ܿ����ô뿩�� 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
				
				pay_tm = toInt(fm.con_mon.value)-ifee_tm;
				if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
					fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
					fm.ifee_day.value 	= fm.r_day.value;
				}
			
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
						
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
				
			
			}
			
			  //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
		    if(fm.ifee_s_amt.value != '0') {
	    	 
		    	if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
		    	}   
		    }	
			
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
		   	  	  
			  	   	   fm.nfee_day.value 	= 	fm.r_day.value;
				 }
			   }	
		   }	 	   		   		    
				
			//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
			//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
							 
		    fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
	
			// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
		   	if(fm.ifee_s_amt.value != '0' ) {
		   		
						
		   		if (v_rifee_s_amt < 0) {  //���ô뿩�Ḧ �� ������ ���
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //       alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	       //	   alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	           fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	      }else {
			   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
			   	     //  	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
			   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	      	   
			   	       }
			   	   }
			    } else {  //���ô뿩�ᰡ �����ִ� ���
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //   	   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	    //       alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	           fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	      }else {
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
			   	       	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	   }
			    }   
		   	} 			
		
			var no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
			var no_v_amt2 				= no_v_amt.toString();
			var len 					= no_v_amt2.length;
			no_v_amt2 					= no_v_amt2.substring(0, len-1);
			fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );								
		}
		
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
		
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}				
	//�������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
		set_tax_init();
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./cls_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='p_brch_cd' value='<%=l_cd.substring(0,2)%>'>
<input type='hidden' name='dly_count' value=''>
<input type='hidden' name='dly_value' value=''>
<input type='hidden' name='client_id' value='<%=base.get("CLIENT_ID")%>'>
<input type='hidden' name='site_id' value='<%=base.get("SITE_ID")%>'>
<input type='hidden' name='car_mng_id' value='<%=base.get("CAR_MNG_ID")%>'>
<input type='hidden' name='br_id' value='<%=base.get("BR_ID")%>'>
<input type='hidden' name='car_nm' value='<%=base.get("CAR_NM2")%>'>
<input type='hidden' name='tax_type' value='<%=base.get("TAX_TYPE")%>'>
<input type='hidden' name='ssn' value='<%=base.get("SSN")%>'>
<input type='hidden' name='enp_no' value='<%=base.get("ENP_NO")%>'>
<input type='hidden' name='ven_code' value='<%=base.get("VEN_CODE")%>'>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name='client_st' value='<%=base.get("CLIENT_ST")%>'>

<input type='hidden' name='use_s_dt' value='<%=base.get("USE_S_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base.get("DLY_S_DT")%>'> 

<input type='hidden' name='r_con_mon' value='<%=base.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�������� > ������ > <span class=style1><span class=style5>������Ǻ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='11%' class='title'>����ȣ</td>
                    <td width="13%">&nbsp;<%=l_cd%></td>
                    <td width='10%' class='title'>��ȣ</td>
                    <td>&nbsp;<%=base.get("FIRM_NM")%></td>
                    <td class='title' width="10%">������ȣ</td>
                    <td width="12%">&nbsp;<%=base.get("CAR_NO")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="19%" align=center>
                        <table width=98% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td><%=base.get("CAR_NM")%></td>
                            </tr>
                            <tr>
                                <td style='height:3'></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�뿩���</td>
                    <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>���Ⱓ</td>
                    <td colspan="5">&nbsp;<%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> 
                      ����)</td>
                </tr>
                <tr> 
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>��</td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal((String)base.get("PP_S_AMT"))%>��</td>
                    <td class='title'>���ô뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal((String)base.get("IFEE_S_AMT"))%>��</td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal((String)base.get("GRT_AMT"))%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='11%' class='title'>��������</td>
                    <td width="38%"> 
        			  &nbsp;<select name="cls_st" onChange='javascript:cls_display()'>
        			    <option value="">---����---</option>
                    <!--    <option value="1">��ุ��</option> -->
                        <option value="8">���Կɼ�</option>  
                        <option value="15">����</option>  
                        <option value="9">����</option>  
                   <!--     <option value="2">�ߵ��ؾ�</option> -->
                       <!-- <option value="3">�����Һ���</option> -->
                        <!--<option value="4">��������</option>-->
                        <!--<option value="5">���°�</option>-->
                    <!--    <option value="6">�Ű�</option> -->
                    <!--    <option value="7">���������(����)</option> -->
                    <!--     <option value="10">����������(�縮��)</option>	-->			
                      </select> </td>
                    <td width='10%' class='title'>������</td>
                    <td width="12%">&nbsp;<input type='text' name='cls_dt' value='<%=base.get("CLS_DT")%>' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
                    </td>
                    <td class='title' width="10%">�̿�Ⱓ</td>
                    <td width="19%">&nbsp;<input type='text' name='r_mon' value='<%=base.get("R_MON")%>'  class='text' size="2">
                      ���� 
                      <input type='text' name='r_day' value='<%=base.get("R_DAY")%>'  class='text' size="2">
                      �� </td>
                </tr>
                <tr> 
                    <td class='title'>�������� </td>
                    <td colspan="5">&nbsp;<textarea name="cls_cau" cols="100" class="default" style="IME-MODE: active" rows="3"></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class='title' style='height:36'>������<br>
                      ���Թ��</td>
                    <td> 
        			  &nbsp;<select name="pp_st">
                        <option value='' <% if(base.get("IFEE_S_AMT").equals("0") && base.get("PP_S_AMT").equals("0")){%>selected<%}%>>�ش���׾���</option>
                        <option value='1' <% if(!base.get("IFEE_S_AMT").equals("0")){%>selected<%}%>>3����ġ�뿩�� 
                        ������</option>
                        <option value='2' <% if(!base.get("PP_S_AMT").equals("0")){%>selected<%}%>>�������� 
                        ������</option>
                      </select> 
        			</td>
                    <td class='title'>���꼭<br>
                      �ۼ����� </td>
                    <td> 
        			  &nbsp;<select name="cls_doc_yn" onChange='javascript:cls_display2()'>
                        <option value="N" selected>����</option>
                        <option value="Y">����</option>
                      </select> 
        			</td>
                    <td class='title'>�ܿ�������<br>
                      ������ҿ���</td>
                    <td> 
        			  &nbsp;<select name="cancel_yn" onChange='javascript:cancel_display()'>
                        <option value="N">��������</option>
                        <option value="Y" selected>�������</option>
                      </select>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
    <!-- ���� -->
    <tr id=tr_default style='display:none'> 
        <td colspan="2"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td>1. �����ݾ� ���� </td>
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
                              <td width="35%" class='title' > <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
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
                              <td width="35%" align="center"> <input type='text' size='3' name='ifee_mon' value=''  class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                                ����&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='ifee_day' value=''  class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                                ��</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td cwidth="15%" align="center" width="20%">����ݾ�</td>
                              <td width="35%" align="center"> <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                                ��</td>
                              <td>=���ô뿩�᡿����Ⱓ</td>
                            </tr>
                            <tr> 
                              <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                                ��</td>
                              <td class='title'>=���ô뿩��-����ݾ�</td>
                            </tr>
                            <tr> 
                              <td class='title' rowspan="3">��<br>
                                ��<br>
                                ��</td>
                              <td align='center' width="20%">�������� </td>
                              <td width='35%' align="center"> <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                                ��</td>
                              <td>=�����ݡ����Ⱓ</td>
                            </tr>
                            <tr> 
                              <td align='center' width="20%">������ �����Ѿ� </td>
                              <td width='35%' align="center"> <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                                ��</td>
                              <td>=�������ס����̿�Ⱓ</td>
                            </tr>
                            <tr> 
                              <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                                ��</td>
                              <td class='title'>=������-������ �����Ѿ�</td>
                            </tr>
                            <tr> 
                              <td class='title' align='right' colspan="3">��</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title'>=(A+B+C)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td align=''left> 2. �̳��Աݾ� ����</td>
                    <td align='right'left>[���ް�]</td>
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
                              <td class='title' width='35%' align="center"> <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                            </tr>
                            <tr> 
                              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>��</font></a><font color="#66CCFF">&nbsp;</font></td>
                            </tr>
                            <tr> 
                              <td class="title" rowspan="5" width="5%"><br>
                                ��<br>
                                ��<br>
                                ��</td>
                              <td align="center" colspan="2">������</td>
                              <td class='' width='35%' align="center"> <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT2")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                                ��</td>
                              <td width='35%'>&nbsp; </td>
                            </tr>
                            <tr> 
                              <td rowspan="2" align="center" width="5%">��<br>
                                ��<br>
                                ��</td>
                              <td width='15%' align="center">�Ⱓ</td>
                              <td class='' width='35%' align="center"> <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                                ����&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                                ��</td>
                              <td width='35%'>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td align="center" width="15%">�ݾ�</td>
                              <td width='35%' align="center"> <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                                ��</td>
                              <td width='35%'>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
                            </tr>
                            <tr> 
                              <td colspan="2" align="center">��ü��</td>
                              <td width='35%' align="center"> <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                                ��</td>
                              <td width='35%'>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="title" colspan="2">�뿩�� ��(F)</td>
                              <td class='title' width='35%' align="center"> <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
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
                              <td class='' width='35%' align="center"> <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                                ��</td>
                              <td width='35%'>=������+���뿩���Ѿ�</td>
                            </tr>
                            <tr> 
                              <td align="center" colspan="2">���뿩��(ȯ��)</td>
                              <td class='' width='35%' align="center"> <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                                ��</td>
                              <td width='35%'>=�뿩���Ѿס����Ⱓ</td>
                            </tr>
                            <tr> 
                              <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                              <td class='' width='35%' align="center"> <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                                ����&nbsp;&nbsp;&nbsp; <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                                ��</td>
                              <td width='35%'>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                              <td class='' width='35%' align="center"> <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                                ��</td>
                              <td width='35%'>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td align="center" colspan="2"><font color="#FF0000">*</font>����� 
                                �������</td>
                              <td class='' width='35%' align="center"> <input type='text' name='dft_int' value='<%=base.get("CLS_R_PER")%>' size='4' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                                %</td>
                              <td width='35%'>����� ��������� ��༭�� Ȯ��</td>
                            </tr>
                            <tr> 
                              <td  class="title" colspan="2">�ߵ����������(G)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>                 
                            <tr>
                             <td class="title" rowspan="5" width="5%"><br>
                                ��<br>
                                Ÿ</td> 
                              <td class="title" colspan="2">����ȸ�����ֺ��(H)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="title" colspan="2">����ȸ���δ���(I)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='etc2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>
                             <tr> 
                              <td class="title" colspan="2">������������(J)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='etc3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>
                             <tr> 
                              <td class="title" colspan="2">��Ÿ���ع���(K)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='etc4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>
                            <input type='hidden' name='etc5_amt' >
                          <!--  
                            <tr> 
                              <td class="title" colspan="2">��Ÿ(L)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='etc5_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>&nbsp;</td>
                            </tr>
                            -->
                            <tr> 
                              <td class="title" colspan="2">�ΰ���(L)</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td id=td_cancel_n style="display:''" class='title'>=(�뿩�� 
                                      �̳��Աݾ�-B-C)��10% </td>
                                    <td id=td_cancel_y style='display:none' class='title'>=�뿩�� 
                                      �̳��Աݾס�10% </td>
                                  </tr>
                                </table></td>
                            </tr>
                            <tr> 
                              <td class="title" colspan="4">��</td>
                              <td class='title' width='35%' align="center"> <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                                ��</td>
                              <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td  colspan="2" align=''left> 3. ������ �����Ͻ� �ݾ�</td>
                </tr>
                <tr> 
                    <td colspan="2" class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td class='title' width="30%">�� ��</td>
                                <td class='title' width="35%" align="center"> 
                                <input type='text' name='fdft_amt2' value=''size='15' class='num' maxlength='15'>
                                �� </td>
                                <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" align='left' > &lt;&lt; ���곻�� &gt;&gt;</td>
                </tr>
                <tr> 
                    <td colspan="2" class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                              <td class='title' width="20%"> DC</td>
                              <td  colspan="3"> 
                                <input type='text' name='fdft_dc_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                ��</td>
                            </tr>
                            <tr> 
                              <td class='title' width="20%"> ���ް�</td>
                              <td width="30%"> 
                                <input type='text' name='cls_s_amt' value=''size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                ��</td>
                              <td class='title' width="20%"> �ΰ���</td>
                              <td width="30%"> 
                                <input type='text' name='cls_v_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                ��</td>
                            </tr>
                            <tr> 
                              <td class='title' width="20%">������������޿����� </td>
                              <td width="30%"> 
                                <input type='text' name='cls_est_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                              </td>
                              <td class='title' width="20%"> ���ݰ�꼭������</td>
                              <td width="30%"> 
                                <input type='text' name='ext_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                                <select name='ext_id'>
                                  <option value=''>�����</option>
                                  <%if(user_size > 0){
            						for(int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                                  <option value='<%= user.get("USER_ID") %>' ><%= user.get("USER_NM")%></option>
                                  <%	}
            					}		%>
                                </select>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title' width="20%"> ����ݸ������� </td>
                              <td colspan="3">���� 
                                <input type='checkbox' name='no_dft_yn' value="Y">
                                &nbsp;&nbsp;��������: 
                                <textarea name='no_dft_cau' rows='2' cols='80'></textarea>
                              </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" align='left' > &lt;&lt; ���ݰ�꼭 &gt;&gt;</td>
                </tr>
                <tr> 
                    <td colspan="2" class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                              <td width="5%" rowspan="2" class='title'>����</td>
                              <td colspan="2" class='title'>�������꼭</td>
                              <td colspan="4" class='title'>���ݰ�꼭</td>
                              <td width="5%" rowspan="2" class='title'>����</td>
                            </tr>
                            <tr> 
                              <td width="15%" class='title'>�׸�</td>
                              <td width="15%" class='title'>�ݾ�</td>
                              <td width="20%" class='title'>ǰ��</td>
                              <td width="10%" class='title'>���ް�</td>
                              <td width="10%" class='title'>�ΰ���</td>
                              <td width="20%" class='title'>���</td>
                            </tr>
                            <tr> 
                              <td width="100" height="23" align="center">1</td>
                              <td align="center">�ܿ����ô뿩��</td>
                              <td align='center'><input type='text' size='15' name='tax_rifee_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk0' value='Y'></td>
                            </tr>
                            <tr> 
                              <td width="100" align="center">2</td>
                              <td align="center">�ܿ�������</td>
                              <td align='center'><input type='text' size='15' name='tax_rfee_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk1' value='Y'></td>
                            </tr>
                            <tr> 
                              <td width="100" align="center">3</td>
                              <td align="center">�̳��뿩��</td>
                              <td align='center'><input type='text' size='15' name='tax_nfee_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk2' value='Y'></td>
                            </tr>
                            <tr> 
                              <td align="center">4</td>
                              <td align="center">��ü��</td>
                              <td align='center'><input type='text' size='15' name='tax_dly_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk3' value='Y'></td>
                            </tr>
                            <tr> 
                              <td align="center">5</td>
                              <td align="center">���������</td>
                              <td align='center'><input type='text' size='15' name='tax_dft_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk4' value='Y'></td>
                            </tr>
                            <tr> 
                              <td align="center">6</td>
                              <td align="center">�ڱ��������ظ�å��</td>
                              <td align='center'><input type='text' size='15' name='tax_car_ja_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align="center"><input type='text' name='tax_g' size='20' class='text' value=''></td>
                              <td align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td align='center'><input type='text' name='tax_bigo' size='20' class='text' value=''></td>
                              <td align="center"> <input type='checkbox' name='tax_chk5' value='Y'></td>
                            </tr>
                            <tr>
                              <td class="star" align="center">&nbsp;</td>
                              <td class="star" align="center">&nbsp;</td>
                              <td class="star">&nbsp;</td>
                              <td class="star" align="center">�հ�<input type='text' size='10' name='tax_hap_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td class="star" align='center'><input type='text' name='tax_supply' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td class="star" align='center'><input type='text' name='tax_value' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                              <td class="star" align='center'>
                        			  <select name="tax_reg_gu">
                                  <option value="0" selected>�׸񺰹���</option>
                                  <option value="1">�������</option>
                                </select>                   
                              </td>
                              <td class="star" align="center">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
    		  <!--
              <%if(fee_scd_size>0){//2005-07-18 ���� : �������� ���ó��%>
              <tr> 
                <td colspan="2" align='left' > <<��ü����Ʈ>> </td>
              </tr>
              <tr> 
                <td colspan="2" class='line'> 
                  <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr> 
                      <td class='title' width="100">ȸ��</td>
                      <td class='title' width="110">����</td>
                      <td class='title' width="200">���뿩��</td>
                      <td class='title' width="150">��ü�ϼ�</td>
                      <td class='title' width="150">��ü��</td>
                      <td class='title' width="90">����</td>
                    </tr>
                    <%for(int i = 0 ; i < fee_scd_size ; i++){
    				  FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>
                    <tr> 
                      <td width="100" align="center"> 
                        <%if(a_fee.getTm_st1().equals("0")){%>
                        <%=a_fee.getFee_tm()%> 
                        <%}%>
                      </td>
                      <td width="110" align="center"> 
                        <%if(a_fee.getTm_st1().equals("0")){%>
                        �뿩�� 
                        <%}else{%>
                        �ܾ� 
                        <%}%>
                      </td>
                      <td width="200" align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��&nbsp;</td>
                      <td width="150" align="center"><%=a_fee.getDly_days()%>��</td>
                      <td width="150" align='right'><%=AddUtil.parseDecimal(a_fee.getDly_fee())%>��&nbsp;</td>
                      <td align="center" width="90"> 
                        <input type='checkbox' name='dly_chk' value='<%=a_fee.getRent_st()+a_fee.getFee_tm()+a_fee.getTm_st1()%>'>
                      </td>
                    </tr>
                    <%	t_dly_amt = t_dly_amt + a_fee.getDly_fee();
    				}%>
                  </table>
                </td>
              </tr>
              <%	}	%>
    		  -->
            </table>
        </td>
    </tr>
    <!-- �����Һ��� -->
    <tr id=tr_brch style='display:none'> 
        <td colspan="2"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> &lt;&lt; �����Һ��� &gt;&gt;</td>
              </tr>
              <tr> 
                <td class='line'> 
                  <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr> 
                      <td class='title' width="10%">����������</td>
                      <td width="15%"><%=c_db.getNameById((String)fee_base.get("BRCH_ID"), "BRCH")%>(<%=fee_base.get("BRCH_ID")%>) 
                      </td>
                      <td class='title' width="10%">�̰���������</td>
                      <td width="15%">
                        <select name='new_brch_cd'>
                          <option value=''>����</option>
                          <%if(brch_size > 0)	{
    						for(int i = 0 ; i < brch_size ; i++){
    							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                          <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                          <%	}
    					  }	%>
                        </select>
                      </td>
                      <td class='title' width="10%">�̰�����</td>
                      <td width="40%">
                        <input type='text' name='trf_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
        </td>
    </tr>
    <!-- ���Կɼ� -->
    <tr id=tr_opt style='display:none'> 
        <td colspan="2"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> &lt;&lt; ���Կɼ� &gt;&gt;</td>
              </tr>
              <tr> 
                <td class='line'> 
                  <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr> 
                      <td class='title' width="10%">���Կɼ���</td>
                      <td width="15%"> 
                        <input type='text' name='opt_per' value='<%=fee_base.get("OPT_PER")%>' size='5' class='num' maxlength='4'>
                        %</td>
                      <td class='title' width="10%">���Կɼǰ�</td>
                      <td width="15%">
                        <input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("OPT_AMT")))%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��</td>
                      <td class='title' width="10%">��������</td>
                      <td width="15%">
                        <input type='text' name='opt_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                      </td>
                      <td class='title' width="10%">���������</td>
                      <td width="15%">
                	  <select name='opt_mng'>
    	                <option value=''>�����</option>
        	            <%if(user_size > 0){
    						for(int i = 0 ; i < user_size ; i++){
    							Hashtable user = (Hashtable)users.elementAt(i);	
    					%>
                    	<option value='<%= user.get("USER_ID") %>'><%= user.get("USER_NM")%></option>
    	                <%	}
    						}		%>
            	      </select>				  
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td>
        <%//if(fee_base.get("FEE_CHK").equals("1")){%>
        <!--<font color="#FF0000">��</font>���뿩�� �Ͻÿϳ��Դϴ�. �ߵ����� ������� �����ϴ�. -->
        <%//}%>
        </td>
        <td align="right">
	    <%//if(br_id.equals("S1") || br_id.equals(String.valueOf(fee_base.get("BRCH_ID")))){%>
	    <a href='javascript:<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>save();<%}else{%>alert("������ �����ϴ�");<%}%>' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%//}%>
		&nbsp;<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
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
		
		//�ܿ����ô뿩��
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
			pay_tm = toInt(fm.con_mon.value)-ifee_tm;
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
								
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
			
		}
		
		//�����ݾ� ���� �ʱ� ����
		if(fm.pp_s_amt.value != '0'){
			if(fm.ifee_s_amt.value == '0'){
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			}
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );
		}else{
			fm.pded_s_amt.value 	= "0";
			fm.tpded_s_amt.value 	= "0";
			fm.rfee_s_amt.value 	= "0";
		}
		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );

		  //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    }	
	    	    
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
		
		
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
		   	  	  
			  	   	   fm.nfee_day.value 	= 	fm.r_day.value;
				 }
			   }	
		   }	 	   		   		    
		
		
	  	//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
		//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
						 
	    fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		

		// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
	   	if(fm.ifee_s_amt.value != '0' ) {
	   		
	   		// v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
			// v_ifee_ex_amt = 0;  // ���ô뿩�� ����ݾ�
		
	   		if (v_rifee_s_amt < 0) {  //���ô뿩�Ḧ �� ������ ���
	   	    	fm.ifee_mon.value 	= '0';
		  		fm.ifee_day.value 	= '0';
					
		   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
		   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
		   	      //     alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����
		   	       }else {
		   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
		   	       }
		   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
		   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
		   	     //  alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
		   	           fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
		   	      }else {
		   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
		   	       	//   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
		   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
		   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
		   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
		   	       }
		   	   }
		    } else {  //���ô뿩�ᰡ �����ִ� ���
		        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
		   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
		   	       	//   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
		   	       }else {
		   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
		   	       }
		   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
		   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
		   	       //    alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
		   	           fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
		   	      }else {
		   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
		   	       	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
		   	
		   	       }
		   	   }
		    }   
	   	}  	
	   	
	   	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		
		
		if(fm.r_day.value != '0'){
			fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	
		if(fm.pp_s_amt.value != '0'){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}		
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}				
		if(fm.dft_int.value == '')	    fm.dft_int.value 			= 30;
		if(fm.dft_int.value == null)	  fm.dft_int.value 			= 30;
		if(fm.dft_int.value == 'null')	fm.dft_int.value 			= 30;
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		var no_v_amt =0;
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
		}else{
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value));
		}				
		var no_v_amt2 				= no_v_amt.toString();
		var len 					= no_v_amt2.length;
		no_v_amt2 					= no_v_amt2.substring(0, len-1);
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//���� ������ �ݾ� �ʱ� ����	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );		
		
		set_tax_init();
	}
	
	//���ݰ�꼭
	function set_tax_init(){
		var fm = document.form1;

	    //���ô뿩�� ȯ��
		if(toInt(parseDigit(fm.rifee_s_amt.value)) > 0){
				fm.tax_rifee_amt.value 	= fm.rifee_s_amt.value;
				fm.tax_supply[0].value 	= "-"+fm.rifee_s_amt.value;
				fm.tax_value[0].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) * 0.1 );
				fm.tax_g[0].value       = "���� ���ô뿩�� ȯ��";
				fm.tax_bigo[0].value    = fm.car_no.value+" �ߵ�����";
				fm.tax_chk0.checked   	= true;
		}
		//������ ȯ��
		if(toInt(parseDigit(fm.rfee_s_amt.value)) > 0){
				fm.tax_rfee_amt.value 	= fm.rfee_s_amt.value;
				fm.tax_supply[1].value 	= "-"+fm.rfee_s_amt.value;
				fm.tax_value[1].value 	= "-"+parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) * 0.1 );
				fm.tax_g[1].value       = "���� ������ ȯ��";
				fm.tax_bigo[1].value    = fm.car_no.value+" �ߵ�����";
				fm.tax_chk1.checked   	= true;
		}
		//�̳��뿩��
		if(toInt(parseDigit(fm.nfee_amt.value)) > 0){
		    fm.tax_nfee_amt.value 		= fm.nfee_amt.value;
				fm.tax_supply[2].value 	= fm.nfee_amt.value;
				fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.nfee_amt.value)) * 0.1 );
				fm.tax_g[2].value       = "�뿩��";
				fm.tax_bigo[2].value    = fm.car_no.value+" ����";
	//			fm.tax_chk2.checked   	= true;
		}
		//�̳��뿩�� ��ü��
		if(toInt(parseDigit(fm.dly_amt.value)) > 0){
			  fm.tax_dly_amt.value 	  	= fm.dly_amt.value;
				fm.tax_supply[3].value 	= fm.dly_amt.value;
				fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.dly_amt.value)) * 0.1 );
				fm.tax_g[3].value       = "���� �̳���ü��";
				fm.tax_bigo[3].value    = fm.car_no.value+" ����";
//				fm.tax_chk3.checked   	= true;
		}
		//�ߵ����������
		if(toInt(parseDigit(fm.dft_amt.value)) > 0){
			  fm.tax_dft_amt.value 	  	= fm.dft_amt.value;
				fm.tax_supply[4].value 	= fm.dft_amt.value;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
				fm.tax_g[4].value       = "���� �����";
				fm.tax_bigo[4].value    = fm.car_no.value+" ����";
//				fm.tax_chk4.checked   	= true;
		}
		//�������ظ�å��
		if(toInt(parseDigit(fm.car_ja_amt.value)) > 0){
				fm.tax_car_ja_amt.value = fm.car_ja_amt.value;		
				fm.tax_supply[5].value 	= parseDecimal( toInt(parseDigit(fm.car_ja_amt.value)) / 1.1 );
				fm.tax_value[5].value 	= parseDecimal( toInt(parseDigit(fm.tax_car_ja_amt.value)) - toInt(parseDigit(fm.tax_supply[5].value)) );
				fm.tax_g[5].value       = "���� �������ظ�å��";
				fm.tax_bigo[5].value    = fm.car_no.value+" ����";
//				fm.tax_chk5.checked   	= true;
		}
		fm.tax_supply[6].value = 0;
		fm.tax_value[6].value = 0;		
		for(var i=0 ; i<6 ; i++){
		  fm.tax_supply[6].value    	= parseDecimal( toInt(parseDigit(fm.tax_supply[6].value)) + toInt(parseDigit(fm.tax_supply[i].value)) );
		  fm.tax_value[6].value     	= parseDecimal( toInt(parseDigit(fm.tax_value[6].value)) + toInt(parseDigit(fm.tax_value[i].value)) );
		}
		fm.tax_hap_amt.value    		= parseDecimal( toInt(parseDigit(fm.tax_supply[6].value)) + toInt(parseDigit(fm.tax_value[6].value)) );
	}	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
