<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*,  acar.estimate_mng.*"  %>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String brch 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String loan_st 	= request.getParameter("loan_st")	==null?"":request.getParameter("loan_st");
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");	
	String max_amt 	= request.getParameter("max_amt")	==null?"":request.getParameter("max_amt");
	
	Vector vt1 = st_db.getStatSettleEffIn(loan_st, save_dt, max_amt , "1");
	int vt1_size = vt1.size();
	
	Vector vt2 = st_db.getStatSettleEffIn(loan_st, save_dt, max_amt, "2");
	int vt2_size = vt2.size();	
	
	Vector vt3 = st_db.getStatSettleEffIn(loan_st, save_dt, max_amt, "3");
	int vt3_size = vt3.size();	
	
	//���� ����
	EstiDatabase e_db = EstiDatabase.getInstance();
		
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList("dly1_bus15");   //1�� ������ ����ġ 
	int size = ea_r.length;
	String var_sik = "";
	
    for(int i=0; i<size; i++){
			bean = ea_r[i];
			var_sik = bean.getVar_sik();
    }	
    //�����ο��� 
    float  f_pcnt =  Math.round(vt1_size * AddUtil.parseFloat(var_sik));
    int pcnt= (int) f_pcnt;
   
  //  out.println(f_pcnt);
  //  out.println(pcnt);
    
    float avg_r_cmp_per 	= 0.0f;
	float avg_r_fee_per 	= 0.0f;
	
	float eff1_per 	= 0.0f;
	float eff2_per 	= 0.0f;
	
	float sum_eff1_per 	= 0.0f;
	float sum_eff2_per 	= 0.0f;
	
	float r_cmp_per 	= 0.0f;
	float r_eff_per 	= 0.0f;
	
	
	int total_amt1 = 0;
	int total_amt2 = 0;
	int total_amt3 = 0;
	

	//ä��ķ����  ������ /* sort: 1: ��ü�� , 2:���밨��ġ ,3: ����ݾ�) */

	for (int i = 0 ; i < pcnt ; i++){
			Hashtable ht11 = (Hashtable)vt1.elementAt(i);		
			
		//	eff1_per = AddUtil.parseFloatCipher(String.valueOf(ht11.get("R_CMP_PER")),3);    //�������ο����� ��ü�� ����ġ 
			eff1_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht11.get("R_CMP_PER")),3));    //�������ο����� ��ü�� ����ġ 		
	 }		
	
		
	for (int i = 0 ; i < pcnt ; i++){
		Hashtable ht22 = (Hashtable)vt2.elementAt(i);		
		
		eff2_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht22.get("R_EFF_PER")),4));	//�������ο����� ������ ����ġ
   }	
//	out.println(eff2_per);
	    
    
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form action="" name="form1" method="POST">

<table border=0 cellspacing=0 cellpadding=0 width="810">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > ä��ķ���� > <span class=style5>ä��ķ���� <%=loan_st%>�� ������ ����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
       
   	<tr>
		<td class=line>  
		  <table border=0 cellspacing=0 cellpadding=0 width="810">
		   <tr>
		     <td class=line>       
		          <table width="260" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td width="50" class=title>�����</td>
		                    <td width="50" class=title>��Ʈ��</td>
							<td width="80" class=title>��ü������ġ</td>
							<td width="80" class=title>����ݾ�</td>
						</tr>
						   <%for (int i = 0 ; i < vt1_size ; i++){
		    					Hashtable ht1 = (Hashtable)vt1.elementAt(i);
		    					
		    					r_cmp_per 	=  AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht1.get("R_CMP_PER")),3));		    					
		    				
		    					avg_r_cmp_per += r_cmp_per;	
		    					    					    					
		    					if (  r_cmp_per <= eff1_per ) {		    					    
		    						 sum_eff1_per += ( eff1_per  - r_cmp_per) ;
		    						 
						        }
		    				//	System.out.println("sum_eff1_per "+sum_eff1_per );	
		    				   total_amt1 += AddUtil.parseLong(String.valueOf(ht1.get("AMT_IN2")));
								
		    				%>
		    			    		    			
						<tr>
							<td align='center'><%=ht1.get("USER_NM")%></td>
		                    <td align='center'><%=ht1.get("PARTNER_NM")%></td>
		                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht1.get("R_CMP_PER")),3)%></td>
		                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht1.get("AMT_IN2")))%></td>
						</tr>
						 <% } %>
						 <tr>
						 	<td align='center' colspan=2>����</td>		                 
						    <td align='right'><%=AddUtil.parseFloatCipher2(eff1_per, 3)%></td>
						     <td align='center'></td>
						 <tr>	
						 <tr>
						 	<td align='center' colspan=2>�հ�</td>		                 
						    <td align='right'><%=AddUtil.parseFloatCipher2(sum_eff1_per, 3)%></td>
						     <td align='right'><%=Util.parseDecimal(total_amt1)%></td>
						 <tr>						
				   </table>
			    </td>
				<td class=line>       
					<table width="420" border="0" cellspacing="1" cellpadding="0">
						<tr>				
							<td width="50" class=title>�����</td>
		                    <td width="50" class=title>��Ʈ��</td>
							<td width="80" class=title>��հ���ġ</td>
							<td width="80" class=title>���ϰ���ġ</td>
							<td width="80" class=title>���밨��ġ</td>	
							<td width="80" class=title>����ݾ�</td>			
						</tr>
						   <%for (int i = 0 ; i < vt2_size ; i++){
		    					Hashtable ht2 = (Hashtable)vt2.elementAt(i); 
		    					
		    					r_eff_per 	=  AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht2.get("R_EFF_PER")),4));		   
		    					
		    					avg_r_fee_per += r_eff_per;	
		    					
		    				//	System.out.println("R_EFF_PER "+AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht2.get("R_EFF_PER")),3)) );	
		    					
		    					if ( eff2_per <= r_eff_per ) {
		    						 sum_eff2_per +=  ( r_eff_per - eff2_per );
						        }
		    				//	System.out.println("sum_eff2_per "+sum_eff2_per );
		    				  total_amt2 += AddUtil.parseLong(String.valueOf(ht2.get("AMT_IN1")));
		    					%>
		    			    		    			
						<tr>
						 	 <td align='center'><%=ht2.get("USER_NM")%></td>
		                     <td align='center'><%=ht2.get("PARTNER_NM")%></td>
						     <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht2.get("EFF_PER1")),4)%></td>
		                     <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht2.get("EFF_PER2")),4)%></td>       
		                     <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht2.get("R_EFF_PER")),4)%></td>  
		                     <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht2.get("AMT_IN1")))%></td>              
						</tr>
						 <% } %>
						  <tr>
						 	<td align='center' colspan=4></td>		               
						    <td align='right'><%=AddUtil.parseFloatCipher2(eff2_per,4) %></td>
						     <td align='center'></td>
						 <tr>	
						  <tr>
						 	<td align='center' colspan=4></td>		               
						    <td align='right'><%=AddUtil.parseFloatCipher2(sum_eff2_per,4) %></td>
						     <td align='right'><%=Util.parseDecimal(total_amt2)%></td>
						 <tr>							
					</table>
			  </td>		
		      <td class=line>       
					<table width="130" border="0" cellspacing="1" cellpadding="0">
						<tr>
						    <td width="50" class=title>������</td>
							<td width="80" class=title>����ݾ�</td>
							
						</tr>
						  <%for (int i = 0 ; i < vt3_size ; i++){
		    					Hashtable ht3 = (Hashtable)vt3.elementAt(i); 
		    					
		    					total_amt3 += AddUtil.parseLong(String.valueOf(ht3.get("AMT_IN")));
		    					%>
		    			    		    			
						<tr>				  
		                    <td align='center'><%=ht3.get("PARTNER_NM")%></td>
		                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht3.get("AMT_IN")))%></td>
						</tr>
						 <% } %>
						   <tr>
						 	<td align='center'></td>
		                    <td align='center'></td>						 
						 <tr>	
						  <tr>
						 	<td align='center'></td>
		                    <td align='right'><%=Util.parseDecimal(total_amt3)%></td>						 
						 <tr>	
					</table>
		     </td>
		 </tr>
		</table>
	  </td>	  
	</tr>
	
    <tr>    	
        <td align="right"><a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a></td>
    </tr>	
    <tr>    	
        <td>* ��հ���ġ : ������ ������ ķ���� �Ⱓ������ ��ü����ġ ���</td>
    </tr>    	
    <tr>    	
        <td>* ���ϰ���ġ : ���� ��ü����ġ</td>
    </tr>	
    <tr>    	
        <td>* ���밨��ġ : ��հ���ġ 80% + ���ϰ���ġ 20% </td>
    </tr>
   <!-- 	
      <tr>    	
        <td>* ķ�������� : +/ - ���� ���밨��ġ�� ����� �ʰ��ϴ� ��� ���+ �ʰ��� 5%  ���� </td>
    </tr>
  
  
     <tr>    	
        <td>* ��Ʈ�������� : ���밨��ġ ����� 40% ���� ū ���</td>
    </tr>	
 
     <tr>    	
        <td>* ��Ʈ�������� : ���ο��� 40%</td>
    </tr> 	
   -->
     <tr>    	
        <td>* ��Ʈ������ݾ� : �����������ѱݾ��� ��ü������ġ�� 50% , ��ü��50% �����Ͽ� ��� (�ּұݾ� 50,000)</td>
    </tr>	
     

</table>
</form>
</body>
</html>
