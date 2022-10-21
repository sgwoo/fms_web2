<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.credit.*, acar.user_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

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
	String cls_st = "";
	
	if ( cls.getCls_st().equals("��ุ��") ) {
		cls_st = "1";
	} else	if ( cls.getCls_st().equals("�ߵ��ؾ�") ) {
		cls_st = "2";
	} else	if ( cls.getCls_st().equals("���Կɼ�") ) {
		cls_st = "8";
	} 
	
	//������Ÿ �߰� ����
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
	
	//�����Ƿڻ������
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);

	//ä�ǰ�������
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);	
	
		//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	s_opt_amt = cls.getOpt_amt();
	
	float	 f_s_opt_s_amt = 0;
	int	 s_opt_s_amt = 0;

	f_s_opt_s_amt =   s_opt_amt /  AddUtil.parseFloat("1.1")   ;
	
	s_opt_s_amt =  (int) f_s_opt_s_amt ;
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//�׿��� ���ฮ��Ʈ
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	
	int maeip_amt = 0;	 //���Կɼ��� ��� ��ü�Ա� 
	int m_ext_amt = 0;  //���Կɼ��� ��� ȯ��/������ 

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		if (fm.cls_st.value  == '8' ) {	
	 		if( toInt(parseDigit(fm.opt_ip_amt1.value)) > 0 ){ // ���Կɼ�
			
				var deposit_no = fm.opt_deposit_no1.options[fm.opt_deposit_no1.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no1_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no1_2.value = deposit_split[0];	
		 		}
		 		
		 		if(fm.opt_bank_code1.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
				if(fm.opt_deposit_no1.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }		
	 		} 			
	 		
	 		
	 		if( toInt(parseDigit(fm.opt_ip_amt2.value)) > 0 ){ //���Կɼ�
			
				var deposit_no = fm.opt_deposit_no2.options[fm.opt_deposit_no2.selectedIndex].value;		
				
				if(deposit_no.indexOf(":") == -1){
					fm.opt_deposit_no2_2.value = deposit_no;
				}else{
					var deposit_split = deposit_no.split(":");
					fm.opt_deposit_no2_2.value = deposit_split[0];	
		 		}
		 		
		 		if(fm.opt_bank_code2.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
				if(fm.opt_deposit_no2.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }		
	 		} 					
		}		
					
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		fm.action = "updateClsAsset_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}



	//������Ϻ��(���Կɼ�)
	function set_sui_c_amt(){
	
		var fm = document.form1;
							
		if (fm.cls_st.value  == '8' ) {
	
		 						
		  if(fm.sui_st[0].checked == true){ 		//�����Ļ���	
		  		fm.sui_d1_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.05 );  //��ϼ�
				fm.sui_d2_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.06 * 0.2 );  //ä������ (default:25%)  ->20%�κ��� 20120920
				fm.sui_d3_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.02 );  //��漼 
				fm.sui_d4_amt.value		= '3,000';  //������ 
				fm.sui_d5_amt.value		= '1,000';  //������ 
				fm.sui_d6_amt.value		= '11,000';  //��ȣ�Ǵ�
				fm.sui_d7_amt.value		= '10,000';  //������ȣ�Ǵ�
				fm.sui_d8_amt.value		= '50,000';  //��ϴ����
								
				fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
		
		  } else {
				fm.sui_d1_amt.value		= '0';
				fm.sui_d2_amt.value		= '0';
				fm.sui_d3_amt.value		= '0';
				fm.sui_d4_amt.value		= '0';
				fm.sui_d5_amt.value		= '0';
				fm.sui_d6_amt.value		= '0';
				fm.sui_d7_amt.value		= '0';
				fm.sui_d8_amt.value		= '0';
				 				
				fm.sui_d_amt.value		= '0';
		  }
		} else { 		
			fm.sui_d1_amt.value		= '0';
			fm.sui_d2_amt.value		= '0';
			fm.sui_d3_amt.value		= '0';
			fm.sui_d4_amt.value		= '0';
			fm.sui_d5_amt.value		= '0';
			fm.sui_d6_amt.value		= '0';
			fm.sui_d7_amt.value		= '0';
			fm.sui_d8_amt.value		= '0';
			
			fm.sui_d_amt.value		= '0';
		}	
		
	//	set_cls_s_amt();
	
	}	
	
	//������Ϻ��(���Կɼ�)
	function set_sui_amt(){
	
		var fm = document.form1;
				
		fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
		
	//	set_cls_s_amt();	
	}	
	
	
		
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(obj){
		var fm = document.form1;
		var bank_code = "";
		if(obj == fm.bank_code){ // �߰��Աݾ�
			//����
			bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;	
			fm.bank_code2.value = bank_code.substring(0,3);
			fm.bank_name.value = bank_code.substring(3);
		} else	if(obj == fm.opt_bank_code1){ // ���Կɼ� 1
			bank_code = fm.opt_bank_code1.options[fm.opt_bank_code1.selectedIndex].value;	
			fm.opt_bank_code1_2.value = bank_code.substring(0,3);
			fm.opt_bank_name1.value = bank_code.substring(3);		
			
		} else	if(obj == fm.opt_bank_code2){ // ���Կɼ� 2
			bank_code = fm.opt_bank_code2.options[fm.opt_bank_code2.selectedIndex].value;	
			fm.opt_bank_code2_2.value = bank_code.substring(0,3);
			fm.opt_bank_name2.value = bank_code.substring(3);			
		} 		
	
		drop_deposit(obj);		

		if(bank_code == ''){
			if(obj == fm.bank_code){ // �߰��Աݾ�
				fm.bank_code.options[0] = new Option('����', '');
				return;
			} else 	if(obj == fm.opt_bank_code1){ // ���Կɼ� 1
				fm.opt_bank_code1.options[0] = new Option('����', '');
				return;			
			} else 	if(obj == fm.opt_bank_code2){ // ���Կɼ� 2
				fm.opt_bank_code1.options[0] = new Option('����', '');
				return;			
			}			
		}else{
			fm.target='i_no';
			if(obj == fm.bank_code){ // �߰��Աݾ�
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=1&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code1){ // ���Կɼ� 1
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=2&bank_code='+bank_code.substring(0,3);
			} else 	if(obj == fm.opt_bank_code2){ // ���Կɼ� 2
				fm.action='/fms2/con_fee/get_deposit_nodisplay2.jsp?g=3&bank_code='+bank_code.substring(0,3);
			}
			fm.submit();
		}
	}	
	
	function drop_deposit(obj){
		var fm = document.form1;
		var deposit_len = 0;
		if(obj == fm.bank_code){ // �߰��Աݾ�
			deposit_len = fm.deposit_no.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.deposit_no.options[deposit_len-(i+1)] = null;
			}
		} else	if(obj == fm.opt_bank_code1){ // ���Կɼ� 1
		
			deposit_len = fm.opt_deposit_no1.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.opt_deposit_no1.options[deposit_len-(i+1)] = null;
			}		
		} else	if(obj == fm.opt_bank_code2){ // ���Կɼ� 2
			deposit_len = fm.opt_deposit_no2.length;
			for(var i = 0 ; i < deposit_len ; i++){
				fm.opt_deposit_no2.options[deposit_len-(i+1)] = null;
			}
		} 	
			
	}	
		
	function add_deposit(idx, val, str, g){
	    if ( g == '1') {
			document.form1.deposit_no[idx] = new Option(str, val);		
		} else if ( g == '2') {
			document.form1.opt_deposit_no1[idx] = new Option(str, val);		
		} else if ( g == '3') {
			document.form1.opt_deposit_no2[idx] = new Option(str, val);		
		}
	}
	

//-->
</script>
</head>

<body>
<center>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='br_id' 		value='<%=br_id%>'>
<input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 		value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">
<input type='hidden' name="cls_st" 	value="<%=cls_st%>">
  
<input type='hidden' name='bank_code2' value='<%=clsm.getEx_ip_bank()%>'>
<input type='hidden' name='deposit_no2' value='<%=clsm.getEx_ip_bank_no()%>'>
<input type='hidden' name='bank_name' value=''>
  
  <!-- ���Կɼ� 1 -->
<input type='hidden' name='opt_bank_code1_2' value='<%=cls.getOpt_ip_bank1()%>'>
<input type='hidden' name='opt_deposit_no1_2' value='<%=cls.getOpt_ip_bank_no1()%>'>
<input type='hidden' name='opt_bank_name1' value=''>

<!-- ���Կɼ� 2 -->
<input type='hidden' name='opt_bank_code2_2' value='<%=cls.getOpt_ip_bank2()%>'>
<input type='hidden' name='opt_deposit_no2_2' value='<%=cls.getOpt_ip_bank_no2()%>'>
<input type='hidden' name='opt_bank_name2' value=''>

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
    
      <!-- ���� ���� -->
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�&nbsp;</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 		          	
		          	<input type='hidden' name='mopt_per' value='<%=cls.getOpt_per()%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	
		 	 	     <td class='title' width="13%">���Կɼ���</td>
		             <td width="13%">&nbsp;<input type='text' name='opt_per' value='<%=cls.getOpt_per()%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="13%">���Կɼǰ�</td>
		             <td colspan=2 width="26%">&nbsp;<input type='text' name='opt_amt' size='14' class='num' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT����)</td> 
		             <td class='title' width="13%">��Ϻ��</td>
		             <td colspan=2 width=22% >&nbsp;
		                <select name="sui_st" disabled>
							  <option value="Y" <% if(clsm.getSui_st().equals("Y")){%>selected<%}%>>����</option>
					          <option value="N" <% if(clsm.getSui_st().equals("N")){%>selected<%}%>>������</option>           
              			</select>
		             </td>   
                  </tr>	
                                
		          <tr id=tr_opt1 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>"> 
		 	 	     <td class='title' width="13%" rowspan=3>������Ϻ��</td>
		             <td class='title' width="13%">��ϼ�</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d1_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">ä������</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d2_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">��漼</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d3_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		          </tr>  
		          <tr id=tr_opt2 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>"> 
		 	 	     <td class='title' width="13%">������</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d4_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">������</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d5_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">��ȣ�Ǵ�</td>
		             <td colspan=2 >&nbsp;<input type='text' name='sui_d6_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		          </tr>  
		          <tr id=tr_opt3 style="display:<%if ( clsm.getSui_st().equals("Y") ){%>''<%}else{%>none<%}%>"> 
		 	     	 <td class='title' width="13%">������ȣ�Ǵ�</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d7_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">��ϴ����</td>
		             <td width="13%" >&nbsp;<input type='text' name='sui_d8_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> ��</td> 
		             <td class='title' width="13%">��</td>
		             <td colspan=2  >&nbsp;<input type='text' name='sui_d_amt' readonly  value='<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%>' size='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��&nbsp;&nbsp; *õ������</td> 
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
   
   
 <!-- ���� ���� -->
    <tr id=tr_ip_opt style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
    
    <%  //���Կɼ��ΰ�츸 
	      if ( cls.getCls_st().equals("���Կɼ�") ) {
	    //	 System.out.println("status = " + clsm.getStatus());
	    	 if ( !clsm.getStatus().equals("0") ) {  
	    		 maeip_amt =  clsm.getM_dae_amt();
	    		 m_ext_amt =  clsm.getExt_amt();
	    	 }  else { //���� ������ 
		    	 if (cls.getFdft_amt2() < 0) {  
			 		   maeip_amt = cls.getFdft_amt2()* (-1);
					 
					   if (maeip_amt > cls.getOpt_amt() ) {
						    maeip_amt = cls.getOpt_amt();						  
					   }  				    	
			     }
	    	 
		    	 if (cls.getFdft_amt3() < 0) {  
		    	    m_ext_amt  = (cls.getFdft_amt3() * (-1)) + maeip_amt + cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2() - cls.getOpt_amt() - clsm.getSui_d_amt() ;	
	    	  //   } else {
	    	  //  	m_ext_amt  = maeip_amt +cls.getOpt_ip_amt2()  + cls.getOpt_ip_amt1() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	     } 	    	  
		    
		     }
		    
		   }   
	   %> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
             <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�&nbsp;</span></td>
 	 	<!-- 	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ� �Ա�</span></td> -->
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
   		   <tr>
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		               <tr>
		                    <td class=title width=13%>��ü�Ա�</td>
		                    <td width=13%>&nbsp;<input type='text' name='m_dae_amt'   value='<%=AddUtil.parseDecimal(maeip_amt)%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td colspan=6>&nbsp;</td>						  
		              </tr>
		       		  <tr>
		                    <td class=title width=13%>�Աݾ�</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt1'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt1())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>�Ա���</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt1' value='<%=cls.getOpt_ip_dt1()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>�Ա�����</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code1' onChange='javascript:change_bank(this)'>
		                        <option value=''>����</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank1().equals(a_bank.getCode())){%>selected<%}%>> <%=a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>���¹�ȣ</td>
				            <td>&nbsp;<select name='opt_deposit_no1'>
		                        <option value=''>���¸� �����ϼ���</option>
		        				<%if(!cls.getOpt_ip_bank1().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank1()); /* ���¹�ȣ */
		        						int deposit_size = deposits.size();
		        						for(int i = 0 ; i < deposit_size ; i++){
		        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
		        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(cls.getOpt_ip_bank_no1().equals(String.valueOf(deposit.get("DEPOSIT_NO")))){%>selected<%}%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
		        				<%		}
		        				}%>
		                      </select>
		                    </td>
		                </tr>
		                <tr>
		                    <td class=title width=10%>�Աݾ�</td>
		                    <td width=13%>&nbsp;<input type='text' name='opt_ip_amt2'  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_maeip_amt(this);' ></td>
		                    <td class=title width=10%>�Ա���</td>
						    <td width=10%>&nbsp;<input type='text' name='opt_ip_dt2' value='<%=cls.getOpt_ip_dt2()%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
						    <td class=title width=10%>�Ա�����</td>
						    <td width=10%>&nbsp;<select name='opt_bank_code2' onChange='javascript:change_bank(this)'>
		                        <option value=''>����</option>
		                        <%if(a_bank_size > 0){
		        						for(int i = 0 ; i < a_bank_size ; i++){
		        							CodeBean a_bank = a_banks[i];	%>
		                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>' <%if(cls.getOpt_ip_bank2().equals(a_bank.getCode())){%>selected<%}%>> <%= a_bank.getNm()%> 
		                        </option>
		                        <%	}
		        					}	%>
		                      </select>&nbsp;</td>
		                    <td class=title width=10%>���¹�ȣ</td>
				            <td>&nbsp;<select name='opt_deposit_no2'>
		                        <option value=''>���¸� �����ϼ���</option>
		        				<%if(!cls.getOpt_ip_bank2().equals("")){
		        						Vector deposits = neoe_db.getDepositList(cls.getOpt_ip_bank2()); /* ���¹�ȣ */
		        						int deposit_size = deposits.size();
		        						for(int i = 0 ; i < deposit_size ; i++){
		        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
		        				<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(cls.getOpt_ip_bank_no2().equals(String.valueOf(deposit.get("DEPOSIT_NO")))){%>selected<%}%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
		        				<%		}
		        				}%>
		                      </select>
		                    </td>
		                </tr>
		                
		                <tr>
		                    <td class=title width=10%>�հ�</td>
		                    <td width=13%>&nbsp;<input type='text' name='t_dae_amt' readonly  value='<%=AddUtil.parseDecimal(maeip_amt+cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2())%>' size='14' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
		                    <td colspan=6>&nbsp;���Աݾ�:&nbsp; 
		                     	<input type="text" name="ext_amt"  size='15' class='num' value='<%=AddUtil.parseDecimal(m_ext_amt)%>' >	
		                        <input type="radio" name="ext_st" value="1" <%if(cls.getExt_st().equals("1"))%>checked<%%> >��ȯ��
				                <input type="radio" name="ext_st" value="2" <%if(cls.getExt_st().equals("2"))%>checked<%%> >������	
				     		                	                    
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
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
