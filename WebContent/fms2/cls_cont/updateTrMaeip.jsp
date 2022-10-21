<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.credit.*, acar.user_mng.*"%>
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
	String cls_st = cls.getCls_st();
	
	ClsEtcAddBean clsa 	= ac_db.getClsEtcAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEtcDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
     	
   int t_fee_s_amt = 0;            
	int t_s_cal_amt = 0;
	int t_r_fee_s_amt = 0;
	int t_r_fee_v_amt = 0;
	int t_r_fee_amt = 0;  		

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
					
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		//fm.target = "i_no";
		fm.submit();
	}



   //�ݾ� ����
   
   	function cal_rest(){
		var fm = document.form1;
	
		     
	   var t_s_cal_amt = 0;
		var t_r_fee_s_amt = 0;
		var t_r_fee_v_amt = 0;
		var t_r_fee_amt = 0;
		
		var scd_size 	= toInt(fm.vt_size8.value);	
				
		for(var i = 0 ; i < scd_size ; i ++){
			
			t_s_cal_amt 	= t_s_cal_amt + toInt(parseDigit(fm.s_cal_amt[i].value));		
			t_r_fee_s_amt = t_r_fee_s_amt + toInt(parseDigit(fm.s_r_fee_s_amt[i].value));			
			t_r_fee_v_amt = t_r_fee_v_amt + toInt(parseDigit(fm.s_r_fee_v_amt[i].value));	
						
									
			fm.s_r_fee_amt[i].value	=   parseDecimal(toInt(parseDigit(fm.s_r_fee_s_amt[i].value))+  toInt(parseDigit(fm.s_r_fee_v_amt[i].value))) ;
					
			t_r_fee_amt 	= t_r_fee_amt + toInt(parseDigit(fm.s_r_fee_amt[i].value));							
				
		}

		fm.t_s_cal_amt.value = parseDecimal(t_s_cal_amt);
		fm.t_r_fee_s_amt.value = parseDecimal(t_r_fee_s_amt);
		fm.t_r_fee_v_amt.value = parseDecimal(t_r_fee_v_amt);
		fm.t_r_fee_amt.value = parseDecimal(t_r_fee_amt);
	
	 }

//-->
</script> 
</head>

<body>
<center>
<form name='form1' action='updateTrMaeip_a.jsp' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="vt_size8" 	value="<%=vt_size8%>">
    
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
	  
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ� ���꼭&nbsp;</span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr>
		        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  rowspan="2"  width='3%'>ȸ��</td>
              <td class="title"  rowspan="2" width='8%'>�����ҳ�¥</td>                
              <td class="title"  rowspan="2" width='9%'>���뿩��<br>(���ް�)</td>
              <td class="title"  rowspan="2" width='10%'>�ڵ�����</td>                
              <td class="title"  rowspan="2" width='10%'>�����+<br>������</td>
              <td class="title"  rowspan="2" width='10%'>�ڵ�����,�����<br> ���ܿ��<br>(���ް�)</td>                
              <td class="title"  width='30%' colspan=3>�ڵ�����,����� ���ܿ���� ���簡ġ</td>             
              <td class="title"  width='20%' colspan=2>���簡ġ ���� �����ڷ�<br>(������: �� <%=clsa.getA_f()%>%)</td>             
            </tr>          
            
            <tr> 
              <td class="title"  width='10%' >���ް�</td>
              <td class="title"  width='10%'>�ΰ���</td>
              <td class="title"  width='10%'>�հ�</td>
              <td class="title"  width='10%'>���簡ġ��</td>
              <td class="title"  width='10%'>�����ϴ��<br>����ϼ�</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) </td>
              <td align="center"> (4) = (1) - (2) - (3) </td>
              <td align="center"> (5) = (4) * (8) </td>
              <td align="center"> (6) = (5) * 0.1</td>
              <td align="center"> (7) = (5) + (6)</td>
              <td align="center"> (8) </td>
              <td align="center"> (9) </td>                          
             </tr>              
                           
<%	
		
						
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT")));
					t_s_cal_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_CAL_AMT")));
					t_r_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_S_AMT")));
					t_r_fee_v_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_V_AMT")));
					t_r_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_AMT")));
					
%>       
	 		   <tr>
                    <td>&nbsp;<input type='text' name='s_fee_tm'   value='<%=ht8.get("S_FEE_TM")%>' size='4' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_est_dt'  readonly value='<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("S_R_FEE_EST_DT")))%>' size='12' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_tax_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_TAX_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_is_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_IS_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_s_amt'  value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_v_amt'  value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_V_AMT")))%>' size='12' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'> </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_amt'  value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_rc_rate'  readonly value='<%=AddUtil.parseFloat(String.valueOf(ht8.get("S_RC_RATE")))%>' size='10' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_days'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_DAYS")))%>' size='8' class='num' > </td>
                                    
               </tr>
<% } %>
        
                
               <tr>
                    <td colspan="2" class=title>�հ�</td>
                    <td class=title><input type='text' name='t_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_fee_s_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_s_cal_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_s_cal_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_v_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_v_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>                   
                  
               </tr>	
                               
             </table>
            </td>
            
         </tr>         
    	 <tr>
    	 <td>&nbsp;��  ������ ����� �ش� ȸ�� ������!!</td>
    	 </tr>
    
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
</body>
</html>
