<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//�������
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	//�����������
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");	
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	CodeBean[] banks = c_db.getBankList("1"); /* �ڵ� ����:��1������ */	
	int bank_size = banks.length;
	CodeBean[] banks2 = c_db.getBankList("2"); /* �ڵ� ����:��2������ */
	int bank_size2 = banks2.length;
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;

		if(fm.allot_st.value == '2'){
			if(fm.cpt_cd.value == '' && fm.cpt_cd2.value == ''){	alert('�����縦 �Է��Ͻʽÿ�');	fm.lend_dt.focus(); return;	}
			if(fm.lend_dt.value == ''){			alert('�������ڸ� �Է��Ͻʽÿ�');		fm.lend_dt.focus(); 		return;	}
			if(fm.lend_prn.value == ''){		alert('��������� �Է��Ͻʽÿ�');		fm.lend_prn.focus(); 		return;	}
			if(fm.lend_int.value == ''){		alert('���������� �Է��Ͻʽÿ�');		fm.lend_int.focus(); 		return;	}
			if(fm.rtn_tot_amt.value == ''){		alert('��ȯ�ѱݾ��� �Է��Ͻʽÿ�');		fm.rtn_tot_amt.focus(); 	return;	}						
			if(fm.tot_alt_tm.value == ''){		alert('�Һ�Ƚ���� �Է��Ͻʽÿ�');		fm.tot_alt_tm.focus(); 		return;	}						
			if(fm.alt_amt.value == ''){			alert('����ȯ�Ḧ �Է��Ͻʽÿ�');		fm.alt_amt.focus();			return;	}		
		}

		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));						

		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='debt_reg_i_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}
	}

	function go_to_list(){
		var fm = document.form1;		
		fm.action='debt_scd_frame_s.jsp';		
		fm.target='d_content';
		fm.submit();	
	}

	//�������,���Һ�� �հ���
	function set_tot_amt(obj){
		fm = document.form1;
		var fm = document.form1;	
		if(obj == fm.cltr_set_dt){//�������� �Է�
		  fm.cltr_f_amt.value = fm.cltr_amt.value;
			fm.reg_tax.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.002);
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.004);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.reg_tax){//������ϼ� �Է�
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) * 2);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else if(obj == fm.set_stp_fee){//���������� �Է�
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.exp_tax){//���ҵ�ϼ� �Է�
//			fm.exp_stp_fee.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) * 2);
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}else if(obj == fm.exp_stp_fee){//���������� �Է�
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}		
	}		
		
	//��ȯ�Ѿ�,�ҺαⰣ,����ȯ�� ����
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//�ҺαⰣ ������ ����
			fm.action='debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
			fm.target='i_no';
			fm.submit();		
		}
		else if(obj == fm.lend_int_amt){
			fm.rtn_tot_amt.value = parseDecimal(toInt(parseDigit(fm.lend_prn.value)) + toInt(parseDigit(fm.lend_int_amt.value)));	
		}
		else if(obj == fm.rtn_tot_amt || obj == fm.tot_alt_tm){
			fm.alt_amt.value = parseDecimal(toInt(parseDigit(fm.rtn_tot_amt.value)) / toInt(parseDigit(fm.tot_alt_tm.value)));	
		}
	}		
			
	//���÷��� Ÿ��
	function bond_sub_display(){
		var fm = document.form1;
		if(fm.bond_get_st.options[fm.bond_get_st.selectedIndex].value == '7'){ //ä��Ȯ������ ���ý� ��Ÿ�Է� ���÷���
			td_bond_sub.style.display	= '';
		}else{
			td_bond_sub.style.display	= 'none';
		}
	}	

	//���÷��� Ÿ��
	function bn_display(){
		var fm = document.form1;
		if(fm.cpt_cd_st.options[fm.cpt_cd_st.selectedIndex].value == '1'){ //�����籸�� ���ý� ������ ���÷���
			td_bn_1.style.display	= '';
			td_bn_2.style.display	= 'none';
		}else{
			td_bn_1.style.display	= 'none';
			td_bn_2.style.display	= '';
		}
	}	
	

	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='debt_reg_i_a.jsp' target='' method="post">
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
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='pay_sch_amt' value='<%=cont.get("CAR_F_AMT")%>'>
<input type='hidden' name='dif_amt' value=''>
<input type='hidden' name='rimitter' value=''>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > �����ڱݰ��� > �Һαݰ��� > <span class=style1><span class=style5>�Һα� ���(�Ǻ�)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
      <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right" colspan=2>
	    <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>					  
	    <a href='javascript:save();'><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
	    <%	}%>		  
        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>  
     
    
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='85' class='title'>����ȣ</td>
            <td width='115'>&nbsp;<%=l_cd%> </td>
            <td width='85' class='title'>��ȣ</td>
            <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
            <td width='85' class='title'> ����ڵ�Ϲ�ȣ</td>
            <td align='left'>&nbsp;<%=ssn%></td>
          </tr>
          <tr> 
            <td width='85' class='title'> ������ȣ</td>
            <td width='115'>&nbsp;<%=cont.get("CAR_NO")%></td>
            <td width='85' class='title'> ����</td>
            <td width='115' align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 9)%></span></td>
            <td width='85' class='title'>�Һ��ڰ���</td>
            <td width='115'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>��&nbsp;</td>
            <td width='85' class='title'>���԰���</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>��&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'>�������</td>
            <td width='115'>&nbsp;<%=cont.get("DLV_DT")%></td>
            <td width='85' class='title'>���ʵ������</td>
            <td width='115'>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
            <td class='title' width="85">���Ⱓ</td>
            <td width='115'>&nbsp;<%=cont.get("CON_MON")%>����</td>
            <td width='85' class='title'>�뿩���</td>
            <td>&nbsp;<%=cont.get("RENT_WAY")%></td>
          </tr>
          <tr> 
            <td class='title' width="85">��ళ����</td>
            <td width="115">&nbsp;<%=cont.get("RENT_START_DT")%></td>
            <td class='title' width="85">���������</td>
            <td width="115">&nbsp;<%=cont.get("RENT_END_DT")%></td>
            <td class='title' width="85">���뿩��</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>��&nbsp;</td>
            <td class='title' width="85">�Ѵ뿩��</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_FEE_AMT")))%>��&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'> ������</td>
            <td width='115' align='left'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("GRT_AMT")))%>��&nbsp;</td>
            <td width='85' class='title'>������</td>
            <td width='115'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("PP_AMT")))%>��&nbsp;</td>
            <td width='85' class='title'>���ô뿩��</td>
            <td width='95'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("IFEE_AMT")))%>��&nbsp;</td>
            <td class='title' width="85">�������Ѿ�</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_PRE_AMT")))%>��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>�ڵ���ȸ��</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("COM_NM") != null) out.println(mgr_dlv.get("COM_NM"));%></td>
            <td  class='title' width="85">����/������</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%></td>
            <td  class='title'>�������</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("NM") != null) out.println(mgr_dlv.get("NM"));%>&nbsp;<%if(mgr_dlv.get("POS") != null) out.println(mgr_dlv.get("POS"));%></td>
            <td class='title'>��ȭ��ȣ</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("O_TEL") != null) out.println(mgr_dlv.get("O_TEL"));%></td>
          </tr>		  
        </table>
      </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    
    <tr> 
      <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һΰ���</span></td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class=title width="85">�Һα���</td>
            <td width="115">&nbsp; 
              <select name='allot_st'>
                <option value="1">���ݱ���</option>
                <option value="2" selected>�Һα���</option>
              </select>
            </td>
            <td class=title width="85">�����籸��</td>
            <td width="115">&nbsp; 
              <select name='cpt_cd_st' onChange='javascript:bn_display()'>
                <option value="">����</option>
                <option value="1">��1������</option>
                <option value="2">��2������</option>
              </select>
            </td>
            <td width='85' class='title'>������</td>
            <td width='115'>
              <table width="115" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td id="td_bn_1" style="display:''" width="115">&nbsp; 
                    <select name='cpt_cd'>
	                <option value="">����</option>					
                      <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									CodeBean bank = banks[i];		%>
                      <option value='<%= bank.getCode()%>'><%= bank.getNm()%></option>
                      <%		}
							}		%>
                    </select>
                  </td>
                  <td id="td_bn_2" style='display:none' width="115">&nbsp; 
                    <select name='cpt_cd2'>
	                <option value="" selected>����</option>										
                      <%	if(bank_size2 > 0){
								for(int i = 0 ; i < bank_size2 ; i++){
									CodeBean bank2 = banks2[i];		%>
                      <option value='<%= bank2.getCode()%>'><%= bank2.getNm()%></option>
                      <%		}
							}		%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
            <td width='85' class='title'>�����ȣ </td>
            <td>&nbsp; 
              <input type='text' name='lend_no' size='20' maxlength='30' class='text'>
            </td>
          </tr>
          <tr> 
            <td width='85' class='title'>�������� </td>
            <td width="115">&nbsp; 
              <input type='text' name='lend_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
            <td width='85' class='title'>������� </td>
            <td width='115'>&nbsp; 
              <input type='text' name='lend_prn' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              ��</td>
            <td width='85' class='title'>��������</td>
            <td width='115'>&nbsp; 
              <input type='text' name='lend_int_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              ��</td>
            <td width='85' class='title'>��������</td>
            <td>&nbsp; 
              <input type='text' name='lend_int' size='6' maxlength='6' class='num'>
              %</td>
          </tr>
          <tr> 
            <td class='title' width="85">��ȯ�ѱݾ�</td>
            <td width="115">&nbsp; 
              <input type='text' name='rtn_tot_amt' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              ��</td>
            <td class='title' width="85">��ȯ�ǹ���</td>
            <td width="115">&nbsp; 
              <select name='loan_debtor'>
                <option value='1'>��</option>
                <option value='2' selected>���</option>
              </select>
            </td>
            <td class='title' width="85">��ȯ����</td>
            <td width="115">&nbsp; 
              <select name='rtn_cdt'>
                <option value='1'>�����ݱյ�</option>
                <option value='2'>���ݱյ�</option>
              </select>
            </td>
            <td class='title' width="85">��ȯ���</td>
            <td>&nbsp; 
              <select name='rtn_way'>
                <option value='1'>�ڵ���ü</option>
                <option value='2'>����</option>
                <option value='3'>��Ÿ</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">��ȯ������ </td>
            <td width="115">&nbsp; 
              <select name='rtn_est_dt'>
                <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
                <option value='<%=j%>'><%=j%>�� </option>
                <% } %>
                <option value='99'> ���� </option>
              </select>
            </td>
            <td class='title' width="85">�Һ�Ƚ�� </td>
            <td width="115">&nbsp; 
              <input type='text' name='tot_alt_tm' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
              ȸ</td>
            <td class='title' width="85">�ҺαⰣ </td>
            <td colspan="3">&nbsp; 
              <input type='text' name='alt_start_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
              ~ 
              <input type='text' name='alt_end_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">����ȯ��</td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">�Һμ����� </td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">������</td>
            <td>&nbsp; 
              <input type='text' name='ntrl_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">������ </td>
            <td>&nbsp; 
              <input type='text' name='stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="85">ä��Ȯ������</td>
            <td colspan='7'>
              <table width="580" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="320">&nbsp; 
                    <select name='bond_get_st'  onChange='javascript:bond_sub_display()'>
                      <option value="">����</option>
                      <option value="1">��༭ </option>
                      <option value="2">��༭+�ΰ�����</option>
                      <option value="3">��༭+�ΰ�����+������</option>
                      <option value="4">��༭+�ΰ�����+������+LOAN ���뺸���������</option>
                      <option value="5">��༭+�ΰ�����+������+LOAN ���뺸����������</option>
                      <option value="6">��༭+���뺸����</option>
                      <option value="7">��Ÿ</option>
                    </select>
                  </td>
                  <td id="td_bond_sub" style='display:none' width="260">&nbsp; 
                    <input type="text" name="bond_get_st_sub" maxlength='40' value="" size="40" class=text>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">��Ÿ</td>
            <td colspan='7'>&nbsp; 
              <input type="text" name="note" value="" maxlength='80' size="80" class=text>
            </td>
          </tr>
                <tr> 
                    <td class=title width=10%>�ߵ���ȯ<br>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="" size="5" class=text >
                      %</td>
                    <td class=title wwidth=10%>�ߵ���ȯ<br>Ư�̻���</td>
                    <td colspan='5'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"></textarea></td>                    
                </tr>	
		  
        </table>
      </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
      <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����缳������</span>&nbsp;&nbsp;<input type="checkbox" name="cltr_st" value="Y">&nbsp;�����缳��</td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class=title width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='cltr_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              ��</td>
            <td width='85' class='title'>��������<br>
              �ۼ�����</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_docs_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>��������</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_set_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_tot_amt(this)'> 
            </td>
            <td width='85' class='title'>��������</td>
            <td>&nbsp; <input type='text' name='cltr_f_amt' size='10' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              �� </td>
          </tr>
          <tr> 
            <td width='85' class='title'>����Ǽ���</td>
            <td width='115'>&nbsp; <select name='mort_lank'>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
              </select>
              ��</td>
            <td class='title' width="85">������</td>
            <td width="115">&nbsp; <input type='text' name='cltr_per_loan' maxlength='6' size='6' class='num' onBlur='javascript:set_tot_amt(this)'>
              %</td>
            <td class='title' width="85">���������</td>
            <td>&nbsp; <input type='text' name='cltr_user' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title'>���ι�ȣ</td>
            <td>&nbsp; <input name='cltr_num' type='text' class='text' id="cltr_num" size='14' maxlength='20'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">��ϰ�û</td>
            <td width="115">&nbsp; <input type='text' name='cltr_office' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">�����</td>
            <td width="115">&nbsp; <input type='text' name='cltr_offi_man' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">��ȭ��ȣ</td>
            <td width="115">&nbsp; <input type='text' name='cltr_offi_tel' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">�ѽ���ȣ</td>
            <td>&nbsp; <input type='text' name='cltr_offi_fax' size='12' maxlength='15' class='text'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">������ϼ�</td>
            <td width="115">&nbsp; <input type='text' name='reg_tax' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='set_stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">��������հ�</td>
            <td colspan='3'>&nbsp; <input type='text' name='ext_tot_amt' maxlength='9' size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'>���ҵ����</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_exp_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>���һ���</td>
            <td colspan="5">&nbsp; <input type='text' name='cltr_exp_cau' maxlength='100' size='80' class='text'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">���ҵ�ϼ�</td>
            <td width="115">&nbsp; <input type='text' name='exp_tax' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='exp_stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">���Һ���հ�</td>
            <td colspan='3'>&nbsp; <input type='text' name='exp_tot_amt' maxlength='9' size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>	

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
