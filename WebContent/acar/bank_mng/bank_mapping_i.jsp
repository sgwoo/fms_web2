<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;				
		if(fm.loan_st_dt.value == ''){		alert('�����û�ϸ� �Է��Ͻʽÿ�');	fm.loan_st_dt.focus();	return;	}
		else if(fm.loan_sch_amt.value == 0){alert('���⿹���ݾ��� �Է��Ͻʽÿ�');fm.lend_prn.focus();	return;	}
		else if(fm.loan_sch_amt.value == 0){alert('���⿹���ݾ��� �Է��Ͻʽÿ�');fm.lend_int.focus();	return;	}
//		if(fm.lend_dt.value == ''){			alert('�������ڸ� �Է��Ͻʽÿ�');	fm.lend_dt.focus();		return;	}
//		else if(fm.lend_prn.value == 0){	alert('��������� �Է��Ͻʽÿ�');	fm.lend_prn.focus();	return;	}
//		else if(fm.lend_int.value == ''){	alert('���������� �Է��Ͻʽÿ�');	fm.lend_int.focus();	return;	}
//		else if(fm.tot_alt_tm.value == ''){	alert('�Һ�Ƚ���� �Է��Ͻʽÿ�');	fm.tot_alt_tm.focus();	return;	}
//		else if(fm.alt_amt.value == ''){	alert('����ȯ�Ḧ �Է��Ͻʽÿ�');	fm.alt_amt.focus();		return;	}	

		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='bank_mapping_i_a.jsp';
			fm.target='i_no';
//			fm.target='MAPPING';			
			fm.submit();
		}
	}

	function go_to_list(){
		var fm = document.form1;
		fm.target='MAPPING';
		fm.action='bank_mapping_frame_s.jsp';
		fm.submit();
	}

	//�������,���Һ�� �հ���
	function set_tot_amt(obj){
		fm = document.form1;
		if(fm.reg_tax == obj || fm.set_stp_fee == obj){
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value))+toInt(parseDigit(fm.set_stp_fee.value)));
		}else if(fm.exp_tax == obj || fm.exp_stp_fee == obj){
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value))+toInt(parseDigit(fm.exp_stp_fee.value)));
		}
	}		

	//�����Աݾ�,�������� ��� �� ����
	function set_mapping(obj){
		var fm = document.form1;	
		if(obj==fm.loan_st_dt){ //�����û����
			fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.loan_sch_amt.value)));		
		}
		else if(obj==fm.loan_sch_amt){ //���⿹���ݾ�
			fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.loan_sch_amt.value)));		
			cls_set();
		}		
		else if(obj==fm.lend_dt){ //��������
			fm.lend_prn.value = parseDecimal(fm.loan_sch_amt.value);
			fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));		
		}		
		else if(obj==fm.cltr_set_dt){//��ȯ����
			fm.cltr_f_amt.value = parseDecimal(fm.cltr_amt.value);
		  fm.cltr_user.value = fm.cpt_cd_nm.value;
			fm.reg_tax.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.002);
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.004);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));

		}
	}		

	//��ȯ�ݾ�,�ҺαⰣ,����ȯ�� ����
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//�ҺαⰣ ������ ����
			fm.action='/acar/con_debt/debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
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

	//�����缳���ݾ� ����
	function cls_set(){
		var fm = document.form1;	
		var max_cltr_rat = toInt(fm.max_cltr_rat.value);
		var loan_sch_amt = toInt(parseDigit(fm.loan_sch_amt.value));	
		fm.cltr_amt.value = parseDecimal(loan_sch_amt*max_cltr_rat/100);			
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onload="javascript:document.form1.loan_st_dt.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");

	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	int max_cltr_rat = request.getParameter("max_cltr_rat")==null?0:Util.parseInt(request.getParameter("max_cltr_rat"));
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	int rtn_size = request.getParameter("rtn_size")==null?0:Util.parseInt(request.getParameter("rtn_size"));
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	
	//�����������
	BankLendBean bl = abl_db.getBankLend(lend_id);
	//�����������
	BankMappingBean bm = abl_db.getBankLend_mapping_info(m_id, l_cd);
	//����Ϸ��� ��ȯ��ȣ
	Vector rtn_seqs = abl_db.getRtn_move_st_ok(lend_id);
	int rtn_seqs_size = rtn_seqs.size();
	//�������
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	//�����������
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");	
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
%>
<form name='form1' action='bank_mapping_i_a.jsp' target='' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=s_rtn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int_m' value='<%=lend_int%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
<input type='hidden' name='cpt_cd' value='<%=bl.getCont_bn()%>'>
<input type='hidden' name='tot_amt_tm' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
      <td width="600"> <font color="navy">�繫���� -> </font><font color="navy">������� 
        ���� </font>-> <font color="red">���⺰ ���</font> </td>
      <td align="right" width="200">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href='javascript:save();' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	  <%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='85' class='title'>����ȣ</td>
            <td width='115'>&nbsp;<%=l_cd%> </td>
            <td width='85' class='title'>��ȣ</td>
            <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
            <td width='85' class='title'> ����ڵ�Ϲ�ȣ</td>
            <td align='left'>&nbsp;<%=ssn%></td>
          </tr>
          <tr> 
            <td class='title'> ������ȣ</td>
            <td width='115'>&nbsp;<%=cont.get("CAR_NO")%></td>
            <td width='85' class='title'> ����</td>
            <td width='115' align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 10)%></span></td>
            <td width='85' class='title'>�Һ��ڰ���</td>
            <td width='115'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>��&nbsp;</td>
            <td width='85' class='title'>���԰���</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>�������</td>
            <td width='115'>&nbsp;<%=cont.get("DLV_DT")%></td>
            <td width='85' class='title'>���ʵ������</td>
            <td width='115'>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
            <td class='title' width="85">���Ⱓ</td>
            <td width='115'>&nbsp;<%=cont.get("CON_MON")%>����</td>
            <td width='85' class='title'>�뿩���</td>
            <td>&nbsp;<%=cont.get("RENT_WAY")%></td>
          </tr>
          <tr> 
            <td class='title'>��ళ����</td>
            <td width="115">&nbsp;<%=cont.get("RENT_START_DT")%></td>
            <td class='title' width="85">���������</td>
            <td width="115">&nbsp;<%=cont.get("RENT_END_DT")%></td>
            <td class='title' width="85">���뿩��</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>��&nbsp;</td>
            <td class='title' width="85">�Ѵ뿩��</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_FEE_AMT")))%>��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'> ������</td>
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
      <td colspan="2"><<�Һΰ���>></td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td class=title width="85">�Һα���</td>
            <td width="115">&nbsp; 
              <select name='allot_st'>
                <!--            <option value="1">���ݱ���</option>-->
                <option value="2" selected>�Һα���</option>
              </select>
            </td>
            <td class=title width="85">�����籸��</td>
            <td width="115">&nbsp; 
              <select name='cpt_cd_st'>
                <option value="1" <%if(bl.getCont_bn_st().equals("1")){%>selected<%}%>>��1������</option>
                <option value="2" <%if(bl.getCont_bn_st().equals("2")){%>selected<%}%>>��2������</option>
              </select>
            </td>
            <td width='85' class='title'>������</td>
            <td width='115'>&nbsp; 
              <input type='text' name='cpt_nm' value='<%=c_db.getNameById(bl.getCont_bn(), "BANK")%>' size='12' maxlength='15' class='whitetext' >
            </td>
            <td width='85' class='title'>��ȯ����</td>
            <td>&nbsp; 
              <%if(rtn_st.equals("0")) {%>
              ��ü 
              <%} else if(rtn_st.equals("1")) {%>
              ���� 
              <%} else {%>
              ���� 
              <%} %>
              &nbsp; 
              <%if(!rtn_st.equals("0")){%>
              <select name='rtn_seq'>
                <%for(int i=0; i<rtn_seqs_size; i++){
					Hashtable rtn_seq_ok = (Hashtable)rtn_seqs.elementAt(i);	%>
                <option value="<%=rtn_seq_ok.get("SEQ")%>"><%=rtn_seq_ok.get("SEQ")%>��</option>
                <%}%>
              </select>
              <%}else{%>
              <input type='hidden' name='rtn_seq' value=''>
              <%}%>
            </td>
          </tr>
          <tr> 
            <td class='title'>�����û��</td>
            <td>&nbsp; 
              <input type='text' name='loan_st_dt' value='' size='12' maxlength='12' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_mapping(this);'>
            </td>
            <td width='85' class='title'>���⿹���ݾ�</td>
            <td width='115'>&nbsp; 
              <input type='text' name='loan_sch_amt' value='<%if(lend_amt_lim.equals("1")){%><%=Util.parseDecimal(AddUtil.ten_th_rnd(bm.getSup_v_amt()))%><%}else if(lend_amt_lim.equals("2")){%><%=Util.parseDecimal(AddUtil.ten_th_rnd(bm.getSup_amt_85per()))%><%}else if(lend_amt_lim.equals("5")){%><%=Util.parseDecimal(AddUtil.ten_th_rnd(bm.getSup_amt_70per()))%><%}else if(lend_amt_lim.equals("3")){%><%=Util.parseDecimal(AddUtil.th_rnd(bm.getSup_v_amt()))%><%}else if(lend_amt_lim.equals("4")){%><%=Util.parseDecimal(AddUtil.ml_th_rnd(bm.getSup_v_amt()))%><%}else{%><%=Util.parseDecimal(bm.getSup_amt())%><%}%>' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_mapping(this);'>
              ��</td>
            <td width='85' class='title'>���⿹���ݾ�</td>
            <td>&nbsp; 
              <input type='text' name='pay_sch_amt' value='<%=Util.parseDecimal(bm.getSup_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��</td>
            <td width='85' class='title'>�����Աݾ�</td>
            <td>&nbsp; 
              <input type='text' name='dif_amt' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��</td>
          </tr>
          <tr> 
            <td class='title'>�����ȣ </td>
            <td>&nbsp; 
              <input type='text' name='lend_no' size='12' maxlength='15' class='text' style='IME-MODE: inactive'>
            </td>
            <td width='85' class='title'>�������� </td>
            <td width="115">&nbsp; 
              <input type='text' name='lend_dt' value='' size='12' maxlength='12' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_mapping(this);'>
            </td>
            <td width='85' class='title'>������� </td>
            <td>&nbsp; 
              <input type='text' name='lend_prn' value='' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_mapping(this);''>
              ��</td>
            <td width='85' class='title'>�۱�ó</td>
            <td>&nbsp; 
              <input type='text' name='rimitter' size='12' maxlength='15' class='text' style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td class='title'>��������</td>
            <td width='115'>&nbsp; 
              <input type='text' name='lend_int_amt' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              ��</td>
            <td width='85' class='title'>��������</td>
            <td>&nbsp; 
              <input type='text' name='lend_int' value='<%=lend_int%>' size='10' maxlength='10' class='num'>
              %</td>
            <td class='title' width="85">��ȯ�ѱݾ�</td>
            <td width="115">&nbsp; 
              <input type='text' name='rtn_tot_amt' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              ��</td>
            <td class='title' width="85">�Һ�Ƚ�� </td>
            <td>&nbsp; 
              <input type='text' name='tot_alt_tm' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
              ȸ</td>
          </tr>
          <tr> 
            <td class='title'>����ȯ��</td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_amt' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              ��&nbsp;</td>
            <td class='title' width="85">�ҺαⰣ </td>
            <td colspan="5">&nbsp; 
              <input type='text' name='alt_start_dt' size='12' maxlength='12' class='text'  onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
              ~ 
              <input type='text' name='alt_end_dt' size='12' maxlength='12' class='text'  onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td class='title'>��ȯ������ </td>
            <td width="115">&nbsp; 
              <select name='rtn_est_dt'>
                <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
                <option value='<%=j%>'><%=j%>�� </option>
                <% } %>
                <option value='99'> ���� </option>
              </select>
            </td>
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
            <td class='title'>�Һμ����� </td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">������</td>
            <td>&nbsp; 
              <input type='text' name='ntrl_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">������ </td>
            <td>&nbsp; 
              <input type='text' name='stp_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td width='85' class='title'>�Һ�����VAT</td>
            <td>&nbsp; 
              <input type='text' name='lend_int_vat' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��</td>
          </tr>
          <tr> 
            <td class='title'>ä��Ȯ������</td>
            <td colspan='7'>&nbsp; 
              <select name='bond_get_st'>
                <option value="">����</option>
                <option value="1">��༭ </option>
                <option value="2">��༭+�ΰ�����</option>
                <option value="3">��༭+�ΰ�����+������</option>
                <option value="4">��༭+�ΰ�����+������+LOAN ���뺸���������</option>
                <option value="5">��༭+�ΰ�����+������+LOAN ���뺸����������</option>
                <option value="6">��༭+���뺸����</option>
              </select>
              �߰�����:&nbsp; 
              <input type="text" name="bond_get_st_sub" maxlength='40' value="" size="40" class=text>
            </td>
          </tr>
          <tr> 
            <td class='title'>�ߵ��Ͻû�ȯ��</td>
            <td width="115"> &nbsp; 
              <input type='text' name='cls_rtn_dt' size='12' maxlength='12' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
            <td class='title' width="85">�ߵ���ȯ��</td>
            <td width="115">&nbsp; 
              <input type='text' name='cls_rtn_amt' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
            <td class='title' width="85">�ߵ���ȯ������</td>
            <td colspan="3">&nbsp; 
              <input type='text' name='cls_rtn_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>�ߵ��Ͻ�<br>
              ��ȯ����</td>
            <td colspan='7'>&nbsp; 
              <input type="text" name="cls_rtn_cau" value="" maxlength='100' size="100" class=text>
            </td>
          </tr>
          <tr> 
            <td class='title'>��Ÿ</td>
            <td colspan='7'>&nbsp; 
              <input type="text" name="note" value="" maxlength='100' size="100" class=text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"><<�����缳������>>
        <input type="checkbox" name="cltr_st" value="Y">
        �����缳��</td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td class=title width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='cltr_amt' value='<%//=Util.parseDecimal(Long.parseLong(Integer.toString(bm.getSup_v_amt()))*max_cltr_rat/100)%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��</td>
            <td width='85' class='title'>��������<br>
              �ۼ�����</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_docs_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>��������</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_set_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_mapping(this);'> 
            </td>
            <td width='85' class='title'>��������</td>
            <td>&nbsp; <input type='text' name='cltr_f_amt' size='11' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              �� </td>
          </tr>
          <tr> 
            <td class='title'>����Ǽ���</td>
            <td width='115'>&nbsp; <select name='mort_lank'>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
              </select>
              ��</td>
            <td class='title' width="85">������</td>
            <td width="115">&nbsp; <input type='text' name='cltr_per_loan' value='<%=max_cltr_rat%>' maxlength='6' size='6' class='num' onBlur='javascript:set_tot_amt(this)'>
              %</td>
            <td class='title' width="85">���������</td>
            <td>&nbsp; <input type='text' name='cltr_user' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title'>���ι�ȣ</td>
            <td>&nbsp; <input name='cltr_num' type='text' class='text' id="cltr_num" size='14' maxlength='20'> 
            </td>
          </tr>
          <tr> 
            <td class='title'>��ϰ�û</td>
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
            <td class='title'>������ϼ�</td>
            <td width="115">&nbsp; <input type='text' name='reg_tax' maxlength='9' size='11' class='num' onBlur='javascript:document.form1.set_stp_fee.value=parseDecimal(toInt(this.value*2)); this.value=parseDecimal(this.value); set_tot_amt(this); '>
              ��&nbsp;</td>
            <td class='title' width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='set_stp_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">��������հ�</td>
            <td colspan='3'>&nbsp; <input type='text' name='ext_tot_amt' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>���ҵ����</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_exp_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>���һ���</td>
            <td colspan="5">&nbsp; <input type='text' name='cltr_exp_cau' maxlength='100' size='80' class='text'> 
            </td>
          </tr>
          <tr> 
            <td class='title'>���ҵ�ϼ�</td>
            <td width="115">&nbsp; <input type='text' name='exp_tax' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">����������</td>
            <td width="115">&nbsp; <input type='text' name='exp_stp_fee' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              ��&nbsp;</td>
            <td class='title' width="85">���Һ���հ�</td>
            <td colspan='3'>&nbsp; <input type='text' name='exp_tot_amt' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              ��&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>	
    <tr> 
      <td colspan="2"><<�Һ� ��������>></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td class=title width="85">�ŷ�ó ����</td>
            <td width="115" height="16">&nbsp; 
              <input type="text" name="cl_lim" value="<%if(bl.getCl_lim().equals("1")){%>��<%}else{%>��<%}%>" maxlength='5' size="5" class=whitetext>
            </td>
            <td class=title width="85">������</td>
            <td height="16">&nbsp; 
              <input type="text" name="cl_lim_sub" value="<%=bl.getCl_lim_sub()%>" maxlength='80' size="80" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title>���� ����</td>
            <td>&nbsp; 
              <input type="text" name="ps_lim" value="<%if(bl.getPs_lim().equals("1")){%>��<%}else{%>��<%}%>" maxlength='5' size="5" class=whitetext>
            </td>
            <td class=title width="85" height="16">����ݾ� ����</td>
            <td>&nbsp; 
              <input type="text" name="lend_amt_lim" value="<%if(bl.getLend_amt_lim().equals("1")){%>(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� �������� ����<%}else if(bl.getLend_amt_lim().equals("0")){%>����<%}%>" maxlength='80' size="70" class=whitetext>
              <font color="#999999">(����)</font></td>
          </tr>
          <tr> 
            <td class=title height="16">�����缳��<br>
              ä���ְ��</td>
            <td height="16">&nbsp;�������
              <input type="text" name="max_cltr_rat" value="<%=bl.getMax_cltr_rat()%>" maxlength='3' size="3" class=whitetext>(%)</td>
            <td class=title width="85" height="16">�����û<br>
              �Ⱓ����</td>
            <td height="16">&nbsp; 
              <input type="text" name="lend_lim_st" value="<%=bl.getLend_lim_st()%>" size="12" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
              ~ 
              <input type="text" name="lend_lim_et" value="<%=bl.getLend_lim_et()%>" size="12" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
          </tr>
          <tr id=tr_docs  style="display:''"> 
            <td class=title>ä�Ǿ絵���<br>
              ��༭</td>
            <td colspan="3" height="16">&nbsp; 
              <input type="text" name="cre_docs" value="<%=bl.getCre_docs()%>" maxlength='80' size="80" class=whitetext>
              <font color="#999999">(��:������ �Ժ���)</font></td>
          </tr>
        </table>
      </td>
    </tr>	
  </table>
</form>
<script language='javascript'>
<!--
	cls_set();
-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
