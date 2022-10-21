<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*,acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	String cng_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//��������� ��ȸ
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//�뿩�ὺ���� ��ȸ�� ����
	FeeScdBean fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, rent_st, rent_seq);
	
	
	
	//�����뿩������ �뿩Ƚ�� �ִ밪
	int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd);
	
	int min_fee_tm = af_db.getMin_fee_tm(m_id, l_cd, rent_st, rent_seq);
	
	//���������ݽ°� ����Ÿ����
	ContEtcBean suc_cont_etc = a_db.getContEtcGrtSuc(m_id, l_cd);
	
	String suc_taecha_no  	= a_db.getMaxTaechaNo(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd())+"";
		
	//��������� ��ȸ
	ContTaechaBean suc_taecha = a_db.getTaecha(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd(), suc_taecha_no);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�뿩������ ����
	function cng_schedule()
	{
		var fm = document.form1;
	
		
		if(fm.fee_tm.value 		== '')				
			{	alert('����ȸ���� �����Ͻʽÿ�.'); 		fm.fee_tm.focus(); 	return; }
		if(fm.req_dt.value == '')
			{	alert('�������ڸ� �Է��Ͻʽÿ�.'); 		fm.req_dt.focus(); 		return; }
		if(fm.tax_out_dt.value == '')
			{	alert('û�����ڸ� �Է��Ͻʽÿ�.'); 		fm.tax_out_dt.focus(); 	return; }
		if(fm.fee_est_dt.value == '')
			{	alert('�Աݿ����ϸ� �Է��Ͻʽÿ�.'); 	fm.fee_est_dt.focus(); 	return; }
		
		if(confirm('�����ٸ� ���� �Ͻðڽ��ϱ�?'))
		{									
			fm.action = './fee_scd_u_tm_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}		
	
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //���뿩�� ���ް�
			if(fm.not_account.checked==false){
				fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			}
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //���뿩�� �ΰ���		
			if(fm.not_account.checked==false){
				fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			}
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //���뿩�� �հ�					
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}	
	
	//�뿩������ ����
	function del_schedule()
	{
		var fm = document.form1;
	
		
		if(confirm('�����ٸ� ���� �Ͻðڽ��ϱ�?'))
		{									
			if(confirm('�����ٸ� ������ ���� �Ͻðڽ��ϱ�?'))
			{									
				if(confirm('�����ٸ� ���� �����˴ϴ�. ���� ���� �Ͻðڽ��ϱ�?'))
				{									
					fm.action = './fee_scd_u_tm_d.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
			}
		}				
	}	
	
	//�뿩������ ����
	function del_schedule_all()
	{
		var fm = document.form1;
	
		
		if(confirm('�����ٸ� �ϰ� ���� �Ͻðڽ��ϱ�?'))
		{									
			if(confirm('�����ٸ� ������ ���� �Ͻðڽ��ϱ�?'))
			{									
				if(confirm('�����ٸ� ���� �����˴ϴ�. ���� ���� �Ͻðڽ��ϱ�?'))
				{									
					fm.action = './fee_scd_u_tm_d_all.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
			}
		}				
	}		
	
	function NoBill_schedule()
	{
		var fm = document.form1;		
				if(confirm('�����ٸ� ��û�� ���·� ó���Ͻðڽ��ϱ�?'))
				{									
					fm.action = './fee_scd_u_tm_nobill.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
	}
	
	
	//�뿩������ �̰�
	function cng_schedule2()
	{
		var fm = document.form1;
	
		
		if(fm.cng_rent_l_cd.value 		== '')				
			{	alert('���� rent_l_cd�� �Է��Ͻʽÿ�.'); 		fm.cng_rent_l_cd.focus(); 	return; }
		if(fm.cng_rent_st.value == '')
			{	alert('���� rent_st�� �Է��Ͻʽÿ�.'); 			fm.cng_rent_st.focus(); 	return; }
		if(fm.cng_rent_st.value == '')
			{	alert('���� tm_st2�� �Է��Ͻʽÿ�.'); 			fm.cng_tm_st2.focus(); 		return; }

		if(fm.cng_choice1.checked == false && fm.cng_choice2.checked == false <%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%> && fm.cng_choice3.checked == false<%}%>)
		{ alert('�̰��� �׸��� �����Ͻʽÿ�.'); return;}
			
		if(confirm('�����ٸ� �̰� �Ͻðڽ��ϱ�?'))
		{									
			fm.action = './fee_scd_u_tm_cng_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}		
	
	//�����Ī���� �뿩������ �̰�
	function cng_schedule4()
	{
		var fm = document.form1;
	
		
		if(fm.cng_rent_l_cd2.value 		== '')	
			{	alert('���� rent_l_cd�� �Է��Ͻʽÿ�.'); 		fm.cng_rent_l_cd2.focus(); 	return; }

		if(fm.cng_choice4.checked == false)
		{ alert('�̰��� �׸��� �����Ͻʽÿ�.'); return;}
			
		if(confirm('�����Ī���� �����ٸ� �̰� �Ͻðڽ��ϱ�?'))
		{									
			if(confirm('������ �����ٸ� �̰� �Ͻðڽ��ϱ�?'))
			{							
				fm.action = './fee_scd_u_tm_cng2_a.jsp';
				fm.target = 'i_no';
				fm.submit();
			}
		}
	}				
	
	//ȸ����ȣ�ø���
	function cng_schedule3()
	{
		var fm = document.form1;
			
		if(confirm('ȸ����ȣ�� �ø��ðڽ��ϱ�?'))
		{									
			fm.action = './fee_scd_u_tm_add_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}				

	
	//û���ݾ� ����
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.use_s_dt.value == ''){	alert('�������� �Է��Ͻʽÿ�.'); return;}
		if(fm.use_e_dt.value == ''){	alert('�������� �Է��Ͻʽÿ�.'); return;}	
		
		fm.st.value = st;
		fm.action='getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
		}				
		fm.submit();
	}
	
	//��������� ȸ������
	function cng_schedule_tae()
	{
		var fm = document.form1;
		
		if(fm.tae_tm_cng[0].checked==false && fm.tae_tm_cng[1].checked==false){ alert('�������������� ȸ�� ���� ����� �����Ͻʽÿ�. '); return;}
		
		if(fm.tae_cng_fee_tm.value == ''){ alert('0ȸ���� �ƴ� ��� ����ȸ���� �Է��Ͻʽÿ�.'); return; }
		
		if(confirm('ȸ���� �����Ͻðڽ��ϱ�?'))
		{									
			fm.action = './fee_scd_u_tm_cng3_a.jsp';
			//fm.target = 'i_no';
			fm.target = '_self';
			fm.submit();
		}		
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='tm_st2' value='<%=tm_st2%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<%if(fee_scd.getTm_st2().equals("2")){//�����������������%>
<input type='hidden' name='o_fee_amt' value='<%=taecha.getRent_fee()%>'> 
<input type='hidden' name='o_fee_s_amt' value=''>
<input type='hidden' name='o_fee_v_amt' value=''>
<%}else if(fee_scd.getTm_st2().equals("4")){//�����뿩��%>
<input type='hidden' name='o_fee_amt' value=''>
<input type='hidden' name='o_fee_s_amt' value=''>
<input type='hidden' name='o_fee_v_amt' value=''>
<%}else{%>
<input type='hidden' name='o_fee_amt' value='<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>'>
<input type='hidden' name='o_fee_s_amt' value='<%=fee.getFee_s_amt()%>'>
<input type='hidden' name='o_fee_v_amt' value='<%=fee.getFee_v_amt()%>'>
<%}%>
<input type='hidden' name='o_tot_fee_amt' value=''>
<input type='hidden' name='o_tot_mon' value=''>

<input type='hidden' name='st' value=''>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>

<input type='hidden' name='tm_cng_cau' value='<%=fee_scd.getCng_cau()%>'>
<input type='hidden' name='from_page' value='/fms2/con_fee/fee_scd_u_tm.jsp'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > �뿩�ὺ���ٰ��� > <span class=style5>�뿩�ὺ���� ��ȸ���� ����</span></span></td>
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
                    <td width='14%' class='title'>����ȣ</td>
                    <td width='28%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='14%' class='title'>��ȣ</td>
                    <td>&nbsp;<%=base.get("FIRM_NM")%></td>
                </tr>
                <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr> 
                    <td class='title'>��뺻����</td>
                    <td colspan="3">&nbsp;<%=base.get("R_SITE")%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr> 
                    <td class='title'><%if(fee_scd.getTm_st2().equals("4")){//�����뿩��%>�����뿩��<%}else{%>���뿩��<%}%></td>
                    <td colspan="3">&nbsp;
					<%if(fee_scd.getTm_st2().equals("2")){//�����������������%>
					<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��
					<%}else if(fee_scd.getTm_st2().equals("4")){//�����뿩��%>
					<input type='text' name='p_fee_amt' value='' size='10' class='whitenum'>��
					<%}else{%>
					<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��
					&nbsp;&nbsp;&nbsp;&nbsp;(���ް�:<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>, �ΰ���:<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>)
					<%}%>
					</td>
                </tr>				
            </table>
	    </td>
	</tr>
	<%if(!String.valueOf(rtn.get("FIRM_NM")).equals("") && !String.valueOf(rtn.get("FIRM_NM")).equals("null")){%>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����û��</span></td>	
	</tr>	  
	<tr>
        <td class=line2></td>
    </tr>				
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>���޹޴���</td>
                    <td width="28%">&nbsp;<%=rtn.get("FIRM_NM")%></td>
                    <td width="14%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(rtn.get("RTN_AMT")))%>��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>	
	<input type='hidden' name='rtn_yn' value='Y'>
	<%}else{%>
	<input type='hidden' name='rtn_yn' value='N'>
	<%}%>
	<tr> 
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ������ <%=fee_tm%>ȸ��</span></td>	
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='14%' class='title'>���뿩��</td>
                    <td>&nbsp;
        		    <input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    �� (���ް� 
                    <input type='text' name='fee_s_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt())%>' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    �� / �ΰ��� <input type='text' name='fee_v_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_v_amt())%>' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    ��, 
                    &nbsp;
                    <input type="checkbox" name="not_account" value="Y">
                	  �ݾ� �ڵ���� ����
                	)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>���Ⱓ</td>
                    <td>&nbsp;
        		    <input type='text' name='use_s_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_s_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    ~ 
                    <input type='text' name='use_e_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_e_dt())%>' size='11' class='text' onBlur="javscript:this.value = ChangeDate4(this, this.value);">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>����
  					  <input type="text" name="u_day" value="" size="5" class=text>�� )
					  
					  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="����ϼ� �� �뿩�� ���ڰ���մϴ�."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="���뿩�� ����ϱ�"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>					  
					</td>
                </tr>
                <tr> 
                    <td class='title'>���࿹������</td>
                    <td>&nbsp;
    		        <input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getReq_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>û������</td>
                    <td>&nbsp;
    		        <input type='text' name='tax_out_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getTax_out_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>�Աݿ�����</td>
                    <td>&nbsp;
    		        <input type='text' name='fee_est_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�Աݿ���</td>
                    <td>&nbsp;
    		        �Ա����� : <%=AddUtil.ChangeDate2(fee_scd.getRc_dt())%>,  �Աݱݾ� : <%=AddUtil.parseDecimal(fee_scd.getRc_amt())%>
					<%if(fee_scd.getRc_amt()>0){%><font color=red>(�뿩�Ḧ ������ ��� �ܾ��� �����Ǵ� ������ Ȯ���ϼ���)</font><%}%>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="14%" class='title'>�������</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="3" class=default style='IME-MODE: active'></textarea>
                    </td>
                </tr>
                <tr>
                    <td width="14%" class='title'>���ڰ�곻��</td>
                    <td>
                        &nbsp;<textarea name="etc" cols="82" rows="3" class=default style='IME-MODE: active'><%=fee_scd.getEtc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(rent_st.equals("1") && idx == 0 && fee_scd.getRc_yn().equals("0")){%>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="14%" class='title'>�ڵ�ó��</td>
                    <td>
                        <input type="checkbox" name="max_tm_auto" value="Y"><font color='red'>������ȸ�� �ڵ����� ����</font>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}%>
	<tr>
	    <td><font color=green>* <!--1ȸ�� ���Ⱓ�� �ִ� [����ϱ�]�� Ŭ���ϸ� ���Ⱓ �� �뿩�� ���� ��� �մϴ�.-->1ȸ�������� �Է½� �ڵ� �����.</font></td>
    </tr>		
	<tr>
	    <td align="center">     
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        	<a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
        	&nbsp;&nbsp;
            <%}%>
        	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>			
        </td>
	</tr>
	<tr>
	    <td><hr></td>
	</tr>	
	<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("����/�°�����",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)){%>
	<!--  �ԱݵȰ� ���� �Ұ� - 20210322 -->
	<tr>
	    <td align="right">      
	    <%if(fee_scd.getRc_amt()<1 ){ %>		
        	<a href="javascript:del_schedule();" title='�뿩�����'><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>        
       <% } %>
        </td>
	</tr>
	<%if(nm_db.getWorkAuthUser("������",user_id) && fee_scd.getBill_yn().equals("Y") && fee_scd.getRc_dt().equals("")){ %>
	<!--  �Ա���Ұ� �ƴ� ��üó���� �ϸ� �̰��� �����ص� ��(20190502)-->
	<tr>
	    <td align="right">      		
        <a href="javascript:NoBill_schedule();" title='�뿩���û��'>[��û�����·� ����]</a>
        </td>
	</tr>
	<%}%>		
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°�,��������,�����϶� �̰�</td>	
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='14%' class='title'>����</td>
                    <td width="6%" class='title'>����</td>					
                    <td width="40%" class='title'>������</td>
                    <td width="40%" class='title'>������</td>
                </tr>
                <tr>
                  <td width='14%' class='title'>rent_l_cd</td>
                  <td align="center"><input type="checkbox" name="cng_choice1" value="Y"></td>				  
                  <td>&nbsp;<%=fee_scd.getRent_l_cd()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_l_cd' value='<%=fee_scd.getRent_l_cd()%>' size='20' class='text'></td>
                </tr>
                <tr>
                  <td class='title'>rent_st</td>
                  <td align="center"><input type="checkbox" name="cng_choice2" value="Y"></td>				  				  
                  <td>&nbsp;<%=fee_scd.getRent_st()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_st' value='<%=fee_scd.getRent_st()%>' size='3' class='text'></td>
                </tr>
				<%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%>
                <tr>
                  <td class='title'>tm_st2</td>
                  <td align="center"><input type="checkbox" name="cng_choice3" value="Y"></td>				  				  
                  <td>&nbsp;<%=fee_scd.getTm_st2()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_tm_st2' value='<%=fee_scd.getTm_st2()%>' size='3' class='text'></td>
                </tr>
				<%}%>
            </table>
	    </td>
    </tr>	
	<tr>
	    <td>* rent_l_cd : ����̰�, ���������� ����� �뿩�� ������ �̰��Դϴ�.</td>	
	</tr>		
	<tr>
	    <td>* rent_st : �ű�,���彺���ٰ��� �뿩�� ������ �̰��Դϴ�. 1�� �ű� �������̰� �׿ܿ��� ���彺�����Դϴ�.</td>	
	</tr>		
	<%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%>
	<tr>
	    <td>* tm_st2 : ȸ�������Դϴ�. 0-�Ϲݴ뿩��, 2-���������뿩��, 3-���ǿ���뿩��. tm_st2�� ������ ��� rent_st�� ���彺���ٷ� �ٲ��ֽʽÿ�.</td>	
	</tr>		
	<%}%>
	<tr>
	    <td align="right">      		
		<a href="javascript:cng_schedule2();" title='�뿩���̰�'><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a>
        </td>
	</tr>
	<tr>
	    <td>fee_tm:<%=fee_tm%>, max_fee_tm:<%=max_fee_tm%>, suc_cont_etc:<%=suc_cont_etc.getRent_l_cd()%>, suc_taecha:<%=suc_taecha.getCar_no()%></td>
	</tr>	
	<%if(fee_tm.equals(String.valueOf(max_fee_tm)) && !suc_cont_etc.getRent_l_cd().equals("") && !suc_taecha.getCar_no().equals("")){//������ȸ��
		Hashtable suc_cont_view = a_db.getContViewCase(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd());
	%>
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����Ī���� �̰�</td>	
	</tr>	
	<tr>
            <td class=line2></td>
        </tr>	
	<tr>
	    <td align='right' class="line">
    	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr> 
                        <td width='14%' class='title'>����</td>
                        <td width="6%" class='title'>����</td>					
                        <td width="30%" class='title'>������</td>
                        <td width="30%" class='title'>������</td>
                        <td width="20%" class='title'>����ȸ��</td>
                    </tr>
                <tr>
                  <td width='14%' class='title'>rent_l_cd</td>
                  <td align="center"><input type="checkbox" name="cng_choice4" value="Y" checked ></td>				  
                  <td>&nbsp;<%=fee_scd.getRent_l_cd()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_l_cd2' value='<%=suc_cont_etc.getRent_l_cd()%>' size='20' class='text'>
                    &nbsp;<%=suc_cont_view.get("CAR_NO")%>
                    <input type='hidden' name='cng_rent_mng_id2' value='<%=suc_cont_etc.getRent_mng_id()%>'>
                  </td>
                  <td>&nbsp;
                    <input type='text' name='cng_fee_tm' value='<%=fee_tm%>' size='2' class='text'>ȸ������                   
                  </td>
                </tr>            
                </table>
	    </td>
        </tr>	
                <%if(!suc_taecha.getEnd_rent_link_sac_id().equals("")){%>
                <tr>
	    			<td>	        
	        			* �����Ī���� ������ �뿩������ / �뿩������ ���̰� 35�� �̻� Ȥ�� ������� ���� 30% �̻� ���̰� �߻��Ͽ����ϴ�.<br>
	        			<font color=red><b>* �����Ī���� ������ �̰��� ������������� �Էµ� "���뿩��"�� �������� ����������� �������� �����Ͻʽÿ�.</b></font><br> 
	        			* ������ : <%=c_db.getNameById(suc_taecha.getEnd_rent_link_sac_id(),"USER")%>	           
	    			</td> 
				<tr>		 
                <%} %> 
	<tr>
	    <td align="right">      		
		<a href="javascript:cng_schedule4();" title='�뿩���̰�'><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a>
        </td>
	</tr>	        
        <%}%>					
	<%}%>	
	
	<tr>
	    <td><hr></td>
	</tr>		
	<tr>
	    <td>      		
		<a href="javascript:cng_schedule3();" title='��ȸ���ø���'>[��ȸ���ø���]</a>
		&nbsp;&nbsp;<font color=red>(û���� ����� ���� ����� �մϴ�.)</font>
        </td>
	</tr>			
	<%if(AddUtil.parseInt(fee_tm)==min_fee_tm && (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("����/�°�����",user_id))){%>
	<tr>
	    <td><hr></td>
	</tr>		
	<tr>
	    <td>      		
		<a href="javascript:del_schedule_all();" title='�����ٻ���'>[<%if(rent_st.equals("1")){%>�ű�<%}else{%>����<%=AddUtil.parseInt(rent_st)-1%>��<%}%> ������ �ϰ� ����]</a>
		&nbsp;&nbsp;<font color=red>(û���� ����� ���� ����� �մϴ�.)</font>
        </td>
	</tr>		
	<%}%>	
	
	<%if(fee_scd.getTm_st2().equals("2") && AddUtil.parseInt(fee_scd.getFee_tm()) >= max_fee_tm){%>	
	<%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("����/�°�����",user_id)){%>
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td>
	    �� �������������� <a href="javascript:cng_schedule_tae();" title='ȸ������'>[ȸ������]</a>
	    <br>     
	    <input type="radio" name="tae_tm_cng" value="1" > 0ȸ���� ����
	    &nbsp;&nbsp;<font color=red>(0ȸ�� ������ ����������������� �ϳ��� ���� ���Դϴ�. )</font><br>
	    <input type="radio" name="tae_tm_cng" value="2" > <input type='text' name='tae_cng_fee_tm' value='1' size='1' class='text'>ȸ���� ���� 
	    &nbsp;&nbsp;<font color=red>(���������� ȸ�� ��ü �и��ϴ�. ��꼭 ȸ������ ���ɼ� �ֽ��ϴ�. )</font><br> 
        </td>
	</tr>
	<%	}%>		
	<%}%>	
	<tr>
	    <td>&nbsp;</td>
	</tr>		
	
		
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.o_tot_fee_amt.value = parseDecimal( <%=fee.getFee_s_amt()+fee.getFee_v_amt()%> * (<%=fee.getCon_mon()%>-<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>));
	fm.o_tot_mon.value 		 = <%=fee.getCon_mon()%>-(<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>);
	
	<%if(fee_scd.getTm_st2().equals("4")){//�����뿩��%>
	fm.o_fee_amt.value 		= parseDecimal( <%=fee.getPp_s_amt()+fee.getPp_v_amt()%>/<%=fee.getCon_mon()%>);
	fm.o_fee_s_amt.value 	= sup_amt(toInt(parseDigit(fm.o_fee_amt.value)));
	fm.o_fee_v_amt.value 	= toInt(parseDigit(fm.o_fee_amt.value)) - toInt(fm.o_fee_s_amt.value);
	fm.p_fee_amt.value 		= fm.o_fee_amt.value;	
	<%}%>
	
//-->
</script>
</body>
</html>
