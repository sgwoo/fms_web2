<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*, acar.cont.*, acar.fee.*, acar.client.*, acar.cls.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	
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
	fm.action='scd_pp_cost_base2_sc.jsp';		
	fm.target='_self';
	fm.submit();	
}

function Search(){
	var fm = document.form1;
	if(fm.t_wd.value == ''){
		alert('�˻�� �Է��ϼ���.'); return;
	}
	fm.action = "scd_pp_cost_case_sc.jsp";
	fm.target = "_self";
	fm.submit();
}

function CostCase(rent_mng_id, rent_l_cd, rent_st){
	var fm = document.form1;
	fm.rent_mng_id.value = rent_mng_id;
	fm.rent_l_cd.value = rent_l_cd;
	fm.rent_st.value = rent_st;
	fm.target = "c_foot";
	fm.action = "scd_pp_cost_case_sc.jsp";
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
  <table border="0" cellspacing="0" cellpadding="0" width=1350>
      <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������(������-������ �յ����)</span></td>
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

    	Vector pps = ae_db.getExtScd(rent_mng_id, rent_l_cd, "1");
    	int pp_size = pps.size();
    	for(int i = 0 ; i < pp_size ; i++){
			ExtScdBean grt = (ExtScdBean)pps.elementAt(i);
			if(grt.getRent_st().equals(rent_st)){
				if(!grt.getExt_pay_dt().equals("")) pay_dt = grt.getExt_pay_dt();
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
    	long total_amt3 = 0;
    	long total_amt4 = 0;
    	
    	//�յ���� ������ 
    	Vector vt = ae_db.getScdPpCostCase2Stat(rent_mng_id, rent_l_cd, rent_st);
    	int vt_size = vt.size();	
    	
    	String start_dt = "";
    	for (int i = 0 ; i < vt_size ; i++){
            Hashtable ht = (Hashtable)vt.elementAt(i);
            if(i==0){
            	start_dt = String.valueOf(ht.get("EST_DT"));
            }
            total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT"))); 
    	}    

    %>

	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan='2' class='title'>����ȣ</td>                    
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
            </table>
	    </td>
    </tr> 	
    <tr> 
        <td class=h></td>
    </tr>  
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
            </table>
	    </td>
    </tr> 	         
    <tr> 
        <td class=h></td>
    </tr>  
    <tr> 
        <td align="right">(�ΰ�������) </td>
    </tr>  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan='3' class='title'>����</td>
                    <td colspan='5' class='title'>���͹ݿ� ��������</td>
                    <td width='10%' rowspan='3' class='title'>����(����)</td>
                    <td width='10%' rowspan='3' class='title'>�ܾ�</td>
                    <td colspan='2' class='title'>���ݰ�꼭(�յ����)</td>
                </tr>
                <tr>
                    <td colspan='2' class='title'>����</td>
                    <td colspan='3' class='title'>����</td>                                   
                    <td rowspan='2' class='title'>�ݾ�</td>
                    <td rowspan='2' class='title'>��������</td>                                   
                </tr>
                <tr>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>�ݾ�</td>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>�ݾ�</td>
                </tr>
                <%		if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));
					            if(!String.valueOf(ht.get("TAX_DT")).equals("")){
									total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));
					            }
					            total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));								
				%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%></td>
                    <td align="center"><%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%>����<%}%></td>
                    <td align="center"><%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%><%}%></td>
                    <td align="right"><%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%><%}%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4-total_amt3)%></td>                    
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TAX_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>                    
                </tr>			    			    
			    <%					
			    			}
			    %>   
                <tr>
                    <td class='title' colspan='2' align="center">�հ�</td>
                    <td class='title' align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td class='title' colspan='2'>&nbsp;</td>
                    <td class='title' align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>                    
                    <td class='title' colspan='4'>&nbsp;</td>
                </tr>				    
			    <%		}%>                                                 
            </table>
	    </td>
    </tr> 	              
  </table>
</form>
</body>
</html>