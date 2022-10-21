<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.user_mng.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//�������
	Hashtable cont = t_db.getAllotByCase(m_id, l_cd);
	
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(m_id, l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(m_id, l_cd);
	int ta_vt_size = ta_vt.size();	
	
	
	//����û������
	Vector rtn = new Vector();	
	if(rent_st.equals(""))		rtn = af_db.getFeeRtnList(m_id, l_cd, "1");
	else 				rtn = af_db.getFeeRtnList(m_id, l_cd, rent_st);
	int rtn_size = rtn.size();
	
	
	String cng_yn  	= "";
	long total_amt 	= 0;
	
	String m_id2 = m_id;
	String l_cd2 = l_cd;

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>

<form name='form1' action='' target='' method="post">
<table border="0" cellspacing="0" cellpadding="0" width=645>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�뿩�� û�� ������</span></td>
                    <td class=bar style='text-align:right'>&nbsp;</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='15%' class='title'>����ȣ</td>
                    <td width='24%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td>&nbsp;<%=base.get("FIRM_NM")%>
        		&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>
                <tr>
                     <td class='title'>������ȣ</td>
                     <td>&nbsp;<%=base.get("CAR_NO")%></td>
                     <td class='title'>����</td>
                     <td>&nbsp;<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
                </tr>
                <tr>
                     <td class='title'> �뿩��� </td>
                     <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                     <td class='title'>CMS</td>
                     <td>&nbsp;<%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> <%=cms.getCms_dep_nm()%></td>
                </tr>
                <tr>
                     <td class='title'>���������</td>
                     <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                     <td class='title'>���������</td>
                     <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	

<!--�����뿩------------------------------------------------------------------------------------------------------------------------------------------------>  

<%	if(rent_st.equals("")){%>  	
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� �����뿩</span></td>	
    </tr>
    <tr>
	<td class=line2></td>
    </tr>	
    <%
		for(int i = 0 ; i < ta_vt_size ; i++){
			Hashtable ht = (Hashtable)ta_vt.elementAt(i);
       		taecha = a_db.getTaecha(m_id, l_cd, ht.get("NO")+"");
    %>  
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='15%' class='title'>������ȣ</td>
                    <td width='24%'>&nbsp;<%=taecha.getCar_no()%></td>
                    <td width='15%' class='title'>����</td>
                    <td>&nbsp;<%=c_db.getNameById(taecha.getCar_id(), "FULL_CAR_NM")%></td>
                </tr>
                <tr>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=taecha.getCar_rent_st()%>~<%=taecha.getCar_rent_et()%></td>
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��</td>					  
                </tr>
            </table>
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%} %>
<%		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", String.valueOf(cont.get("FIRM_NM")));
			ht.put("RTN_AMT", String.valueOf(taecha.getRent_fee()));
			rtn.add(ht);
			rtn_size = rtn.size();
		}
		for(int r = 0 ; r < rtn_size ; r++){
			Hashtable r_ht = (Hashtable)rtn.elementAt(r);
			if(rtn_size>1){%>	
    <tr>
	<td>&nbsp;</td>	
    </tr>	  			
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='15%' class='title'>���޹޴���</td>
                    <td width="24%">&nbsp;<%=r_ht.get("FIRM_NM")%></td>
                    <td width="15%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>��</td>
                </tr>
            </table>
        </td>
    </tr>				
<%			}%>	

<%			//�����۾�������-����
			Vector fee_scd1 = ScdMngDb.getFeeScdTaxScd("", "3", "0", "", "", m_id, l_cd, "", "", String.valueOf(r+1));
			int fee_scd_size1 = fee_scd1.size();
			if(fee_scd_size1>0){%>  
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>	  
                <tr>
                    <td width='5%' rowspan="2" class='title'>����</td>				
                    <td width='5%' rowspan="2" class='title'>ȸ��</td>
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="14%" rowspan="2" class='title'>���뿩��</td>
                    <td width="6%" rowspan="2" class='title'>�Ա�<br>����</td>
                    <td width="5%" rowspan="2" class='title'>��ü</td>
                    <td colspan="3" class='title'>������</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>���࿹����</td>
                    <td width="13%" class='title'>��������</td>
                    <td width="13%" class='title'>�Աݿ�����</td>
                </tr>
        <%		for(int i = 0 ; i < fee_scd_size1 ; i++){
					Hashtable ht = (Hashtable)fee_scd1.elementAt(i);
					if(String.valueOf(ht.get("RC_YN")).equals("0")) cng_yn = "Y"; 
					total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=i+1%></td>				
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=ht.get("FEE_TM")%></td>
                    <td width='13%' align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width='13%' align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>>
                    	<%if(String.valueOf(ht.get("RC_YN")).equals("0")){ 		out.println("N");
                     	  }else if(String.valueOf(ht.get("RC_YN")).equals("1")){   	
                     	  	//�ܾ׿���
                     	  	if(af_db.getFeeTmJanAmt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")))>0){
                     	  		out.println("�ܾ�");
                     	  	}else{
                     	  		out.println("Y");
                     	  	}							
                     	  }%>
                    </td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=ht.get("DLY_DAYS")%>��</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
        <%		}%>
		<tr>
		    <td class="title" colspan="4">�հ�</td>
		    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��</td>
		    <td class="title" colspan="5"></td>				  
		</tr>		
            </table>
        </td>
    </tr>
    <tr>
	<td>&nbsp;</td>	
    </tr>	  	

<%			}%>	
<%		}%>	

<!--����(����)�뿩------------------------------------------------------------------------------------------------------------------------------------------------>

<%	}else{%>
<%		ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);%>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>����<%}else{%><%=AddUtil.parseInt(rent_st)-1%>�� ����<%}%>�뿩</span></td>	
    </tr>
    <tr>
	<td class=line2></td>	
    </tr>	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='15%' class='title'>�뿩�Ⱓ</td>
                    <td colspan='3'>&nbsp;<%=ext_fee.getRent_start_dt()%>~<%=ext_fee.getRent_end_dt()%>(<%=ext_fee.getCon_mon()%>����)</td>
                    <td width=15%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��</td>
                </tr>
                <tr>
                    <td class='title'>������</td>
                    <td width="16%">&nbsp;<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��</td>
                    <td class='title'>������</td>
                    <td width=16%>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��</td>
                    <td width="10%" class='title'>���ô뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��&nbsp;<%if(ext_fee.getFee_s_amt() >0){%>(<%=(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())/(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>ȸ)<%}%></td>
                </tr>
            </table>
        </td>
    </tr>	
<%		
		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", String.valueOf(cont.get("FIRM_NM")));
			ht.put("RTN_AMT", String.valueOf(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()));
			rtn.add(ht);
			rtn_size = rtn.size();
		}
		for(int r = 0 ; r < rtn_size ; r++){
			Hashtable r_ht = (Hashtable)rtn.elementAt(r);
			if(rtn_size>1){%>					
    <tr>
	<td>&nbsp;</td>	
    </tr>	  			
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    	    	<tr><td class=line2></td></tr>
                <tr>
                    <td width='15%' class='title'>���޹޴���</td>
                    <td width="24%">&nbsp;<%=r_ht.get("FIRM_NM")%></td>
                    <td width="15%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>��</td>
                </tr>
            </table>
        </td>
    </tr>			
<%			}%>
<%			//�����۾�������-����
			Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", rent_st, "", "", m_id, l_cd, "", "", String.valueOf(r+1));
			int fee_scd_size = fee_scd.size();
			if(fee_scd_size>0){%>  	
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>����</td>
                    <td width='5%' rowspan="2" class='title'>ȸ��</td>					
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="14%" rowspan="2" class='title'>���뿩��</td>
                    <td width="6%" rowspan="2" class='title'>�Ա�<br>����</td>
                    <td width="5%" rowspan="2" class='title'>��ü</td>
                    <td colspan="3" class='title'>������</td>
                </tr>
                <tr>
                  <td width="13%" class='title'>���࿹����</td>
                  <td width="13%" class='title'>��������</td>
                  <td width="13%" class='title'>�Աݿ�����</td>
                </tr>
        <%				total_amt = 0;
						for(int j = 0 ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
        					l_cd2 = String.valueOf(ht.get("RENT_L_CD"));
        					if(String.valueOf(ht.get("RC_YN")).equals("0")) cng_yn = "Y"; 
						total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=j+1%></td>				
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("FEE_TM")%></td>
                    <td width="13%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="13%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
                    	<%if(String.valueOf(ht.get("RC_YN")).equals("0")){ 		out.println("N");
                     	  }else if(String.valueOf(ht.get("RC_YN")).equals("1")){   	
                     	  	//�ܾ׿���
                     	  	if(af_db.getFeeTmJanAmt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")))>0){
                     	  		out.println("�ܾ�");
                     	  	}else{
                     	  		out.println("Y");
                     	  	}							
                     	  }%>                     	  
                    </td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("DLY_DAYS")%>��</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
        <%					}%>
		<tr>
		    <td class="title" colspan="4">�հ�</td>
		    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��</td>
		    <td class="title" colspan="5"></td>				  
		</tr>		
            </table>
	</td>
    </tr>
	  
<%			}%>  

<%		}%>
<%	}%>	
</table>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 20.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

</script>


