<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*, acar.cont.*, acar.fee.*, acar.client.*, acar.cls.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	auth_rw = rs_db.getXmlAuthRw(user_id, "09", "04", "11");

	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String r_gubun2 = request.getParameter("r_gubun2")==null?"":request.getParameter("r_gubun2");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function go_to_list(){
	var fm = document.form1;	
	fm.action='scd_pp_cost_base_sc.jsp';
	<%if(!go_url.equals("")){%>
	fm.action='<%=go_url%>';
	<%}%>
	fm.target='_self';
	fm.submit();	
}
function cal_amt(){
	var fm = document.form1;
	var tm = toInt(fm.count.value);	
	var t_est_amt = 0;
	var t_rc_amt = 0;
	for(var i = 1 ; i <= tm ; i ++){
		if(fm.rc_dt[i].value == ''){
			//fm.rc_amt[i].value = 0;	
			fm.sum_amt[i].value = 0;
			fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rest_amt[i-1].value)) - toInt(parseDigit(fm.est_amt[i].value)));
		}else{
			//if(fm.tm[i].value != '99'){
			//	fm.rc_amt[i].value = fm.est_amt[i].value;	
			//}				
			fm.sum_amt[i].value = parseDecimal(toInt(parseDigit(fm.sum_amt[i-1].value)) + toInt(parseDigit(fm.rc_amt[i].value)));
			fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rest_amt[i-1].value)) - toInt(parseDigit(fm.rc_amt[i].value)));				
		}
		t_est_amt += toInt(parseDigit(fm.est_amt[i].value));
		t_rc_amt += toInt(parseDigit(fm.rc_amt[i].value));
	}
	fm.t_est_amt.value = parseDecimal(t_est_amt);
	fm.t_rc_amt.value = parseDecimal(t_rc_amt);	
}
function save(){
	var fm = document.form1;	
	fm.action='scd_pp_cost_case_sc_a.jsp';
	fm.target='_self';
	fm.submit();	
}
//-->
</script>
</head>
<body>
<form name='form1' action='scd_pp_cost_case_sc.jsp' method='post' target='c_foot'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
  <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>  
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='r_gubun2' value='<%=r_gubun2%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=1350>
      <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������(�����뿩��)</span></td>
	  </tr>
    <tr>
        <td align=right colspan="2"><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>	
	  
    <%
    
    	//cont_view
    	Hashtable base = a_db.getContViewCase(rent_mng_id, rent_l_cd);
    	
    	//�뿩�⺻����
    	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
    	
    	//������
    	ClientBean client = al_db.getNewClient(String.valueOf(base.get("CLIENT_ID")));
    	
    	String tax_dt = ScdMngDb.getScdTaxDt("3", rent_l_cd, "", "", rent_st);
    	String pay_dt = "";
		
    	if(r_gubun2.equals("1")){
	    	Vector pps = ae_db.getExtScd(rent_mng_id, rent_l_cd, "1");
    		int pp_size = pps.size();
    		for(int i = 0 ; i < pp_size ; i++){
				ExtScdBean grt = (ExtScdBean)pps.elementAt(i);
				if(grt.getRent_st().equals(rent_st)){
					if(!grt.getExt_pay_dt().equals("")) pay_dt = grt.getExt_pay_dt();
				}
    		}
    	}
    	if(r_gubun2.equals("2")){
	    	Vector pps = ae_db.getExtScd(rent_mng_id, rent_l_cd, "2");
    		int pp_size = pps.size();
    		for(int i = 0 ; i < pp_size ; i++){
				ExtScdBean grt = (ExtScdBean)pps.elementAt(i);
				if(grt.getRent_st().equals(rent_st)){
					if(!grt.getExt_pay_dt().equals("")) pay_dt = grt.getExt_pay_dt();
				}
    		}
    	}    	
    	
    	if(fee.getPp_chk().equals("0")){
    		if(fee.getFee_est_day().equals("99")){ 
    			tax_dt="�ſ�����"; 
    		}else{
    			tax_dt="�ſ�"+fee.getFee_est_day()+"��";    		
    		}
    	}
    	
    	//��������
    	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
    	
    	long total_amt1	= 0;
    	long total_amt2 = 0;
    	
    	Vector vt = ae_db.getScdPpCostCaseStat(rent_mng_id, rent_l_cd, rent_st, r_gubun2);
    	int vt_size = vt.size();	
    	
    	String start_dt = "";
    	for (int i = 0 ; i < vt_size ; i++){
            Hashtable ht = (Hashtable)vt.elementAt(i);
            if(String.valueOf(ht.get("TM")).equals("0")){
            	start_dt = String.valueOf(ht.get("EST_DT"));
            }
    	}    

    %>

	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan='2' class='title'>����ȣ<br>(<%=base.get("RENT_MNG_ID")%>)</td>                    
                    <td colspan='3' class='title'>�����</td>
                    <td width='10%' rowspan='2' class='title'>������ȣ</td>
                    <td colspan='3' class='title'>���Ⱓ</td>
                    <td colspan='2' class='title'>���ݰ�꼭</td>
                </tr>
                <tr>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width='5%' class='title'>����</td>
                    <td width='10%' class='title'>�����/�������</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>��ళ����</td>
                    <td width='10%' class='title'>���౸��</td>
                    <td width='10%' class='title'>��������</td>
                </tr>
                <tr>
                    <td align="center"><%=base.get("RENT_L_CD")%></td>
                    <td align="center"><%=base.get("FIRM_NM")%></td>
                    <td align="center"><%=client.getClient_nm()%></td>
                    <td align="center"><%if(client.getClient_st().equals("2")){%><%=client.getSsn1()%><%}else{%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>                    
                    <td align="center"><%=base.get("CAR_NO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                    <td align="center"><%=fee.getCon_mon()%>����</td>
                    <td align="center"><%if(fee.getPp_chk().equals("0")){%>�ſ��յ����<%}else{%>�ϰ�����<%}%></td>
                    <td align="center"><%if(fee.getPp_chk().equals("0")){%><%=tax_dt%><%}else{%><%=AddUtil.ChangeDate2(tax_dt)%><%}%></td>
                </tr>
                <%if(r_gubun2.equals("3")){%>
                <tr>
                    <td width='15%' class='title'>����</td>
                    <td colspan='4'>&nbsp;�뿩�� �ϰ����Ժ�</td>                
                    <td class='title'>����</td>
                    <td colspan='4'>&nbsp;<%=cls.getCls_st()%>&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
                </tr>              
                <%} %>
            </table>
	    </td>
    </tr> 	
    <tr> 
        <td class=h></td>
    </tr> 
    <%if(r_gubun2.equals("1") || r_gubun2.equals("2")){%> 
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td colspan='7' class='title'>�����뿩��</td>
                    <td colspan='2' class='title'>��������</td>
                </tr>
                <tr>
                    <td colspan='5' class='title'>�Աݳ���</td>
                    <td colspan='2' class='title'>���͹ݿ��Ⱓ</td>
                    <td width='10%' rowspan='2' class='title'>����</td>
                    <td width='20%' rowspan='2' class='title'>��������</td>
                </tr>
                <tr>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>���ް�</td>
                    <td width='10%' class='title'>�ΰ���</td>
                    <td width='10%' class='title'>�հ�</td>
                    <td width='10%' class='title'>�Ա�����</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>��������</td>                    
                </tr>
                <%if(r_gubun2.equals("1")){%>
                <tr>
                    <td align="center">������</td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getPp_s_amt())%></td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getPp_v_amt())%></td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%></td>                    
                    <td align="center"><%=AddUtil.ChangeDate2(pay_dt)%></td>
                    <td align="center"><%if(vt_size>0){%><%=AddUtil.ChangeDate2(start_dt)%><%}else{%><%=AddUtil.ChangeDate2(fee.getRent_start_dt())%><%}%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                    <td align="center"><%=cls.getCls_st()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
                </tr>      
                <%}else if(r_gubun2.equals("2")){%>
                <tr>
                    <td align="center">���ô뿩��(<%=fee.getPere_r_mth()%>����)</td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%></td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getIfee_v_amt())%></td>
                    <td align="center"><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%></td>                    
                    <td align="center"><%=AddUtil.ChangeDate2(pay_dt)%></td>
                    <td align="center"><%if(vt_size>0){%><%=AddUtil.ChangeDate2(start_dt)%><%}else{%><%=AddUtil.ChangeDate2(fee.getRent_start_dt())%><%}%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                    <td align="center"><%=cls.getCls_st()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
                </tr>                      
                <%}%>          
            </table>
	    </td>
    </tr> 
    <%}%>         
    <tr> 
        <td class=h></td>
    </tr>  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan='3' class='title'>����</td>
                    <td colspan='5' class='title'>���͹ݿ� ��������</td>
                    <td width='10%' rowspan='3' class='title'>����(����)</td>
                    <td width='10%' rowspan='3' class='title'>�ܾ�(���ް�)</td>
                    <td colspan='2' class='title'>���ݰ�꼭(�յ����)</td>
                </tr>
                <tr>
                    <td colspan='2' class='title'>����</td>
                    <td colspan='3' class='title'>����</td>                                   
                    <td rowspan='2' class='title'>���ް�</td>
                    <td rowspan='2' class='title'>��������</td>                                   
                </tr>
                <tr>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>���ް�</td>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>���ް�</td>
                </tr>
                
                <%		int count = 0;
                		if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            if(!String.valueOf(ht.get("TM")).equals("99")){
					            	total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));
					            }
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));
								
								if(String.valueOf(ht.get("TM")).equals("0") || i==0){%>
                <tr>
                    <td align="center"><%=ht.get("TM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="right"></td>
                    <td align="right"></td>
                    <td align="right"><input type='text' name='rest_amt' size='10' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REST_AMT")))%>' <%if(!ck_acar_id.equals("000029")){%>class='whitenum'  readonly<%}else{%>class='num' onBlur='javascript:cal_amt()'<%}%>></td>
                    <td align="center"></td>
                    <td align="center"></td>
                		<!-- ��ũ��Ʈ������ ���� ��� -->
			    		<input type='hidden' name='v_tm' value='<%=ht.get("TM")%>'>
			    		<input type='hidden' name='est_amt' value='<%=ht.get("EST_AMT")%>'>
			    		<input type='hidden' name='rc_dt' value='<%=ht.get("RC_DT")%>'>
			    		<input type='hidden' name='rc_amt' value='<%=ht.get("RC_AMT")%>'>
			    		<input type='hidden' name='sum_amt' value='<%=ht.get("SUM_AMT")%>'>
                </tr>			    									
				<% 				}else{
									if(String.valueOf(ht.get("USE_YN")).equals("Y")){		
										count++;
			    %>
                <tr>
                    <td align="center"><%=ht.get("TM")%><input type='hidden' name='v_tm' value='<%=ht.get("TM")%>'></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right"><%if(String.valueOf(ht.get("TM")).equals("99")){%>-<input type='hidden' name='est_amt' value='<%=ht.get("EST_AMT")%>'><%}else{%><input type='text' name='est_amt' size='10' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%>' <%if(!ck_acar_id.equals("000029")){%>class='whitenum'  readonly<%}else{%>class='num' onBlur='javascript:cal_amt()'<%}%>><%}%></td>
                    <td align="center"><%if(String.valueOf(ht.get("TM")).equals("99")){%><%=ht.get("GUBUN")%><%}else{%><%if(!String.valueOf(ht.get("RC_DT")).equals("")){%>����<%}%><%}%></td>
                    <td align="center"><input type='text' name='rc_dt' size='12' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RC_DT")))%>' class='whitetext'  readonly></td>
                    <td align="right"><input type='text' name='rc_amt' size='10' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("RC_AMT")))%>' <%if(!ck_acar_id.equals("000029")){%>class='whitenum'  readonly<%}else{%>class='num' onBlur='javascript:cal_amt()'<%}%>></td>
                    <td align="right"><input type='text' name='sum_amt' size='10' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SUM_AMT")))%>' <%if(!ck_acar_id.equals("000029")){%>class='whitenum'  readonly<%}else{%>class='num'<%}%>></td>
                    <td align="right"><input type='text' name='rest_amt' size='10' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REST_AMT")))%>' <%if(!ck_acar_id.equals("000029")){%>class='whitenum'  readonly<%}else{%>class='num'<%}%>></td>
                    <%	if(fee.getPp_chk().equals("0")){ //�ſ��յ���ེ����
                    		String tm_tax_dt = ScdMngDb.getScdTaxDt("1", rent_l_cd, rent_st, "2", String.valueOf(ht.get("TM")));
                    %>
                    <td align="right"><%if(!String.valueOf(ht.get("RC_DT")).equals("") && !tm_tax_dt.equals("")){%><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%><%}%></td>
                    <td align="center"><%if(!String.valueOf(ht.get("RC_DT")).equals("")){%><%=AddUtil.ChangeDate2(tm_tax_dt)%><%}%></td>
                    <%	}else{
                    		String tm_tax_dt = "";
                    		int tm_tax_amt = 0;
                    		if(String.valueOf(ht.get("GUBUN")).equals("ȯ��(����)") && !r_gubun2.equals("3")){
                    			Hashtable tm_tax = ae_db.getScdPpCostCaseClsTax(rent_mng_id, rent_l_cd, rent_st, r_gubun2);
                    			tm_tax_dt = String.valueOf(tm_tax.get("TAX_DT"));
                    			tm_tax_amt = AddUtil.parseInt(String.valueOf(tm_tax.get("TAX_SUPPLY")));
                    		}
                    %>
                    <td align="right"><%if(!tm_tax_dt.equals("")){%><%=AddUtil.parseDecimal(tm_tax_amt)%><%}%></td>
                    <td align="center"><%if(!tm_tax_dt.equals("")){%><%=AddUtil.ChangeDate2(tm_tax_dt)%><%}%></td>
                    <%	} %>
                </tr>			    
			    <%					}else{ //��������%>
                <tr>
                    <td align="center"><%=ht.get("TM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right">��������</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>                                       
                </tr>						    
			    <%					}
			    				}
			    %>   
			    <%			}%>

                <tr>
                    <td class='title' colspan='2' align="center">�հ�</td>
                    <td align="right"><input type='text' name='t_est_amt' size='10' value='<%=AddUtil.parseDecimalLong(total_amt1)%>' class='whitenum' readonly></td>
                    <td class='title' colspan='2'>&nbsp;</td>
                    <td align="right"><input type='text' name='t_rc_amt' size='10' value='<%=AddUtil.parseDecimalLong(total_amt2)%>' class='whitenum' readonly></td>                    
                    <td class='title' colspan='4'>&nbsp;</td>
                </tr>				    
			    <%		}%>                                                 
            </table>
	    </td>
    </tr> 	     
	<tr>
		<td align='right'>
			<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>			
			<a href="javascript:save()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
			<%}%>
		</td>
	</tr>            
  </table>
  <input type='hidden' name='count' value='<%=count%>'>
</form>
</body>
</html>