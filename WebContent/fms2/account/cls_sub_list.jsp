<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.incom.*"%>
<%@ page import="acar.credit.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String pay_gur = request.getParameter("pay_gur")==null?"N":request.getParameter("pay_gur");  //ä���߽�
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	int incom_amt	 = request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));	
	int seq			 = request.getParameter("seq")==null? 0:AddUtil.parseDigit(request.getParameter("seq"));	//����
	int scd_size	 = request.getParameter("scd_size")==null? 0:AddUtil.parseDigit(request.getParameter("scd_size"));  //ä�ǰ���	
	
	//�������곻��
	Hashtable etc = in_db.getClsEtcSub(rent_mng_id, rent_l_cd );
	
	int ct_pay_amt1 =  Integer.parseInt(String.valueOf(etc.get("FINE_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("CAR_JA_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("DFEE_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("DLY_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("ETC_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("ETC2_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("ETC4_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("OVER_AMT_1")))+Integer.parseInt(String.valueOf(etc.get("NO_V_AMT_1")));
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
		//����ϱ�
	function save(){
		fm = document.form1;
				
		var len=fm.elements.length;
	
		var id = "";
				
		// �Աݾװ� ����� �� - ä���߽��� ��� �������!!!
		if ( fm.pay_gur.value  == 'N') { 
			if ( toInt(parseDigit(fm.incom_amt.value)) < toInt(parseDigit(fm.ct_pay_amt2.value)) ) {
			//	alert( toInt(parseDigit(fm.ct_pay_amt2.value)) );
				alert("�Աݾ׺��� ������� Ŭ �� �����ϴ�. �ݾ��� Ȯ���ϼ���.!!");
				return;
			}
		}
						
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;		

		//���ݾ��� ������	
	//	if (toInt(parseDigit(fm.fine_amt_2.value)) > 0 ) {
		  	id =  id  + "fine:" + toInt(parseDigit(fm.fine_amt_1.value)) + ":" + toInt(parseDigit(fm.fine_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
	//	}		        
		 
	//	if (toInt(parseDigit(fm.car_ja_amt_2.value)) > 0 ) {
		  	id =  id  +  "car_ja:" + + toInt(parseDigit(fm.car_ja_amt_1.value)) + ":" + toInt(parseDigit(fm.car_ja_amt_2.value)) + ":" + "0" + ":"+ "N" + "^";
	//	}
		
	//	if (toInt(parseDigit(fm.dfee_amt_2.value)) > 0 ) {
 			id =  id  + "fee:" + toInt(parseDigit(fm.dfee_amt_1.value)) + ":" + toInt(parseDigit(fm.dfee_amt_2.value)) + ":" + toInt(parseDigit(fm.dfee_amt_2_v.value)) + ":"+ "Y" + "^";
	//	}		  
		   
    //   if (toInt(parseDigit(fm.dly_amt_2.value)) > 0 ) {
          id =  id  + "dly:" + toInt(parseDigit(fm.dly_amt_1.value)) + ":" + toInt(parseDigit(fm.dly_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
    //    }
        
    //    if (toInt(parseDigit(fm.dft_amt_2.value)) > 0 ) {
          if (fm.tax_chk0.checked == true) {
            id =  id  + "dft:" + toInt(parseDigit(fm.dft_amt_1.value)) + ":" + toInt(parseDigit(fm.dft_amt_2.value)) + ":"  + toInt(parseDigit(fm.dft_amt_2_v.value)) + ":"  + "Y" + "^";
          } else {	
            id =  id  + "dft:" + toInt(parseDigit(fm.dft_amt_1.value)) + ":" + toInt(parseDigit(fm.dft_amt_2.value)) + ":" + "0" + ":"  + "N" + "^";
          }
   //     }
        
    //    if (toInt(parseDigit(fm.etc_amt_2.value)) > 0 ) {
          if (fm.tax_chk1.checked == true) {
            id =  id  + "etc:" + toInt(parseDigit(fm.etc_amt_1.value)) + ":" + toInt(parseDigit(fm.etc_amt_2.value)) + ":" + toInt(parseDigit(fm.etc_amt_2_v.value)) + ":" + "Y" + "^";
          } else {	
          	id =  id  + "etc:" + toInt(parseDigit(fm.etc_amt_1.value)) + ":" + toInt(parseDigit(fm.etc_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
          }	
    //    }
        
   //    if (toInt(parseDigit(fm.etc2_amt_2.value)) > 0 ) {
         if (fm.tax_chk2.checked == true) {
            id =  id  + "etc2:" + toInt(parseDigit(fm.etc2_amt_1.value)) + ":" + toInt(parseDigit(fm.etc2_amt_2.value)) + ":" + toInt(parseDigit(fm.etc2_amt_2_v.value)) + ":" + "Y" + "^";
          } else {	
          	id =  id  + "etc2:" + toInt(parseDigit(fm.etc2_amt_1.value)) + ":" + toInt(parseDigit(fm.etc2_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
          }	
    //    }
        
    //    if (toInt(parseDigit(fm.etc4_amt_2.value)) > 0 ) {
          if (fm.tax_chk3.checked == true) {
            id =  id  + "etc4:" + toInt(parseDigit(fm.etc4_amt_1.value)) + ":" + toInt(parseDigit(fm.etc4_amt_2.value)) + ":" + toInt(parseDigit(fm.etc4_amt_2_v.value)) + ":"+ "Y" + "^";
          } else {		        
          	id =  id  + "etc4:" + toInt(parseDigit(fm.etc4_amt_1.value)) + ":" + toInt(parseDigit(fm.etc4_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
          }	
     //   }						


       //	if (toInt(parseDigit(fm.over_amt_2.value)) > 0 ) {
         if (fm.tax_chk4.checked == true) {
 				id =  id  + "over:" + toInt(parseDigit(fm.over_amt_1.value)) + ":" + toInt(parseDigit(fm.over_amt_2.value)) + ":" + toInt(parseDigit(fm.over_amt_2_v.value)) + ":"+ "Y" + "^";
	      } else {		        
          	id =  id  + "over:" + toInt(parseDigit(fm.over_amt_1.value)) + ":" + toInt(parseDigit(fm.over_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
         }	
			
	//	}		  		
     
     		
	    // �ΰ��� �踦 ����
	    id = id + "vat:" + toInt(parseDigit(fm.no_v_amt_1.value)) + ":" + toInt(parseDigit(fm.no_v_amt_2.value)) + ":" + "0" + ":" + "N" + "^";
	    
	     // �����޸� ����	     
	    id = id + "c_pay:0:" + toInt(parseDigit(fm.ct_n_pay_amt2.value)) + ":" + "0" + ":" + "N" + "^";
	    
	  
//	    alert(id);
	    			
		var o_fm = opener.document.form1;
	 
		if (toInt(parseDigit(fm.scd_size.value)) == 1 ){
			o_fm.pay_amt.value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt2.value)));
			o_fm.cls_amt.value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt2.value)));
			o_fm.accid_id.value = id;
		} else {	
			o_fm.pay_amt[<%=seq-1%>].value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt2.value)));
			o_fm.cls_amt[<%=seq-1%>].value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt2.value)));
			o_fm.accid_id[<%=seq-1%>].value = id;
		}				
		
		opener.cal_cls_rest();				
		window.close();
	
	}	
	
	function cal1_rest(){
		var fm = document.form1;
		
		fm.dfee_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dfee_amt_2.value)) * 0.1 );
			
		if(fm.tax_chk0.checked == true ){		
			fm.dft_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dft_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk1.checked == true ){
			fm.etc_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk2.checked == true ){
			fm.etc2_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_2.value)) * 0.1 );
		}
		if(fm.tax_chk3.checked == true ){
			fm.etc4_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc4_amt_2.value)) * 0.1 );
		}
		
		if(fm.tax_chk4.checked == true ){
			fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
		}
		
	//	fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );
		
		fm.no_v_amt_2.value =  parseDecimal( toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value)) );	
		fm.ct_pay_amt2.value =  parseDecimal(  toInt(parseDigit(fm.fine_amt_2.value))+toInt(parseDigit(fm.car_ja_amt_2.value))+ toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value))+ toInt(parseDigit(fm.etc_amt_2.value))+ toInt(parseDigit(fm.etc2_amt_2.value))+ toInt(parseDigit(fm.etc4_amt_2.value)) + toInt(parseDigit(fm.over_amt_2.value)) + toInt(parseDigit(fm.dfee_amt_2_v.value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value)) + toInt(parseDigit(fm.ct_n_pay_amt2.value))  );	
		
	}	
	
	function cal2_rest(){
		var fm = document.form1;
		
		fm.ct_pay_amt1.value =  parseDecimal(  toInt(parseDigit(fm.fine_amt_1.value))+toInt(parseDigit(fm.car_ja_amt_1.value))+ toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))+ toInt(parseDigit(fm.dft_amt_1.value))+ toInt(parseDigit(fm.etc_amt_1.value))+ toInt(parseDigit(fm.etc2_amt_1.value))+ toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) );	
		
	}	
	

	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
							
		if(obj == fm.tax_chk0){ // �����
		 	if (obj.checked == true) {
		 		fm.dft_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.dft_amt_2.value)) * 0.1 );		 				
			} else {
				fm.dft_amt_2_v.value ='0';				
			}	
	
		} else if(obj == fm.tax_chk1){ // ���ֺ��
			 if (obj.checked == true) {
			 	fm.etc_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc_amt_2.value)) * 0.1 );				
			 } else {
			 	fm.etc_amt_2_v.value = '0';			 	
			 }	
			 
		} else if(obj == fm.tax_chk2){ // �δ���
			 if (obj.checked == true) {
				fm.etc2_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc2_amt_2.value)) * 0.1 );			
			 } else {
				fm.etc2_amt_2_v.value = '0';			 		
			 }	
			 
		} else if(obj == fm.tax_chk3){ // ��Ÿ���ع���
			 if (obj.checked == true) {
			 	fm.etc4_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.etc4_amt_2.value)) * 0.1 );				
			 } else {
			 	fm.etc4_amt_2_v.value = '0';			
			 }	
			 
		} else if(obj == fm.tax_chk4){ // �ʰ�����δ��
			 if (obj.checked == true) {
			 	fm.over_amt_2_v.value = parseDecimal( toInt(parseDigit(fm.over_amt_2.value)) * 0.1 );				
			 } else {
			 	fm.over_amt_2_v.value = '0';			
			 }				 	 
		}		
			
		fm.no_v_amt_2.value =  parseDecimal( toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value))  + toInt(parseDigit(fm.over_amt_2_v.value)));	
		fm.ct_pay_amt2.value =  parseDecimal(  toInt(parseDigit(fm.fine_amt_2.value))+toInt(parseDigit(fm.car_ja_amt_2.value))+ toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value))+ toInt(parseDigit(fm.etc_amt_2.value))+ toInt(parseDigit(fm.etc2_amt_2.value))+ toInt(parseDigit(fm.etc4_amt_2.value))+ toInt(parseDigit(fm.over_amt_2.value))+ toInt(parseDigit(fm.dfee_amt_2_v.value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value))  + toInt(parseDigit(fm.ct_n_pay_amt2.value))  );	
						
	}
	
	
	function set_cls_amt4(){
		var fm = document.form1;
		
		fm.no_v_amt_2.value =  parseDecimal( toInt(parseDigit(fm.dfee_amt_2_v.value)) + toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value)));	
		fm.ct_pay_amt2.value =  parseDecimal(  toInt(parseDigit(fm.fine_amt_2.value))+toInt(parseDigit(fm.car_ja_amt_2.value))+ toInt(parseDigit(fm.dfee_amt_2.value)) + toInt(parseDigit(fm.dly_amt_2.value))+ toInt(parseDigit(fm.dft_amt_2.value))+ toInt(parseDigit(fm.etc_amt_2.value))+ toInt(parseDigit(fm.etc2_amt_2.value))+ toInt(parseDigit(fm.etc4_amt_2.value))+ toInt(parseDigit(fm.over_amt_2.value))+ toInt(parseDigit(fm.dfee_amt_2_v.value))+ toInt(parseDigit(fm.dft_amt_2_v.value))+ toInt(parseDigit(fm.etc_amt_2_v.value))+ toInt(parseDigit(fm.etc2_amt_2_v.value))+ toInt(parseDigit(fm.etc4_amt_2_v.value)) + toInt(parseDigit(fm.over_amt_2_v.value)) + toInt(parseDigit(fm.ct_n_pay_amt2.value)) );	
				
	}
		
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='cls_sub_list.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>    
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>    
<input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
<input type="hidden" name="seq" 		value="<%=seq%>">
<input type="hidden" name="pay_gur" 		value="<%=pay_gur%>">
<input type="hidden" name="scd_size" 		value="<%=scd_size%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������곻��&nbsp;</span></td>
			</tr>	
    <tr> 
        <td class=h></td>
    </tr>
 
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=5%>����</td>                            
                    <td class=title width=20% colspan=2>�׸�</td>
                    <td class=title width=11%>�̳��ݾ�<br>(���ް�)</td>
                    <td class=title width=13%>���ݾ�<br>(���ް�)</td>
                    <td class=title width=8%>���⿩��</td>			              
                </tr>
                <tr align="center"> 
                    <td class="title">1</td>
                
                    <td class="title" colspan=2>���·�</td>
                    <td><input type='text' name='fine_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("FINE_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='fine_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td>&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class="title">2</td>
               
                    <td class="title" colspan=2>��å��</td>
                    <td><input type='text' name='car_ja_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("CAR_JA_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='car_ja_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="s_chk2" value="N"></td>
                </tr>
                <tr align="center"> 
                    <td class="title">3</td>
                
                    <td class="title" colspan=2>�뿩��</td>
                    <td><input type='text' name='dfee_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("DFEE_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='dfee_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>                
                   	<td><input type="checkbox" name="s_chk3" value="Y"  checked ></td>
                </tr>
                <tr align="center"> 
                    <td class="title">4</td>
                  
                    <td class="title" colspan=2>��ü����</td>
                    <td><input type='text' name='dly_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("DLY_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='dly_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td>&nbsp;</td>
                </tr>
                <tr align="center"> 
                    <td class="title">5</td>
                 
                    <td class="title" colspan=2>�ߵ����������</td>
                    <td><input type='text' name='dft_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("DFT_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='dft_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="tax_chk0" value="Y" <%if(String.valueOf(etc.get("TAX_CHK0")).equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);"></td>
                </tr>
                <tr align="center"> 
                    <td class="title">6</td>
                   
                    <td class="title" colspan=2>ȸ�����ֺ��</td>
                    <td><input type='text' name='etc_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("ETC_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='etc_amt_2' size='10' class='num' value='' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="tax_chk1" value="Y" <%if(String.valueOf(etc.get("TAX_CHK1")).equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"></td>
                </tr>
                <tr align="center"> 
                    <td class="title">7</td>
               
                    <td class="title" colspan=2>ȸ���δ���</td>
                    <td><input type='text' name='etc2_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("ETC2_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='etc2_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="tax_chk2" value="Y" <%if(String.valueOf(etc.get("TAX_CHK2")).equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"></td>
                </tr> 
                <tr align="center"> 
                    <td class="title">8</td>
                   
                    <td class="title" colspan=2>��Ÿ���ع���</td>
                    <td><input type='text' name='etc4_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("ETC4_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='etc4_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="tax_chk3" value="Y" <%if(String.valueOf(etc.get("TAX_CHK3")).equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"></td>
                </tr> 
                   <tr align="center"> 
                    <td class="title">9</td>
                   
                    <td class="title" colspan=2>�ʰ�����δ��</td>
                    <td><input type='text' name='over_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("OVER_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td><input type='text' name='over_amt_2' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest();'>��</td>
                    <td><input type="checkbox" name="tax_chk4" value="Y"  <%if(String.valueOf(etc.get("TAX_CHK4")).equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);"></td>
                </tr> 
                <tr align="center"> 
                    <td rowspan="7" class="title">10</td>
                    <td rowspan="7" class="title"> ��<br>
                		 ��<br>
                		 ��</td> 
               	    <td class="title">�뿩��</td>	 
               	    <td>&nbsp;</td>	 
                    <td><input type='text' name='dfee_amt_2_v' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	
               </tr>
               <tr>
                    <td class="title">���������</td>	 
               	    <td>&nbsp;</td>	     
                    <td>&nbsp;<input type='text' name='dft_amt_2_v'  size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	    
               </tr>
               <tr>
                    <td class="title">ȸ�����ֺ��</td>	 
               	    <td>&nbsp;</td>	       
                   	<td>&nbsp;<input type='text' name='etc_amt_2_v'  size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	    
              </tr>
              <tr>
                    <td class="title">ȸ���δ���</td>	 
               	    <td>&nbsp;</td>	            
                    <td>&nbsp;<input type='text' name='etc2_amt_2_v' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	    
              </tr>
              <tr>
                    <td class="title">��Ÿ���ع���</td>	 
               	    <td>&nbsp;</td>	                  
                    <td>&nbsp;<input type='text' name='etc4_amt_2_v' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	    
              </tr>
                 <tr>
                    <td class="title">�ʰ�����δ��</td>	 
               	    <td>&nbsp;</td>	                  
                    <td>&nbsp;<input type='text' name='over_amt_2_v' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt4();'> ��</td>  
                    <td>&nbsp;</td>	    
              </tr>
              <tr> 
                    <td class="title">�Ұ�(M)</td>      
                    <td>&nbsp;<input type='text' name='no_v_amt_1' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(etc.get("NO_V_AMT_1")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal2_rest();'>��</td>
                    <td>&nbsp;<input type='text' name='no_v_amt_2' size='10' class='num' readonly  value='' onBlur='javascript:this.value=parseDecimal(this.value); '>��</td>
                    <td>&nbsp;</td>
                </tr> 
                <tr align="center"> 
                    <td class="title">11</td>
                    <td colspan=2 class=title>�����ް�</td>
                    <td ></td>
                    <td ><input type='text' name='ct_n_pay_amt2'   size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal1_rest()'>��</td>
                    <td >&nbsp;</td>
                </tr> 
                
                <tr align="center"> 
                    <td colspan=3 class=title>�հ�</td>
                    <td class=title><input type='text' name='ct_pay_amt1' readonly  size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td class=title><input type='text' name='ct_pay_amt2' readonly size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td class=title>&nbsp;</td>
                </tr> 
                
        
            </table>
     
        </td>
    </tr>
  
    <tr>
        <td>&nbsp;<font color="#FF0000">*</font> FMS �� �׿����� Ȯ���ϼ���.</td>
    </tr>
    
    <tr> 
        <td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> &nbsp;<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
	
		var fm = document.form1;
		
		fm.ct_pay_amt1.value =  parseDecimal(  toInt(parseDigit(fm.fine_amt_1.value))+toInt(parseDigit(fm.car_ja_amt_1.value))+ toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))+ toInt(parseDigit(fm.dft_amt_1.value))+ toInt(parseDigit(fm.etc_amt_1.value))+ toInt(parseDigit(fm.etc2_amt_1.value))+ toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}
	
	//-->
</script>
</body>
</html>