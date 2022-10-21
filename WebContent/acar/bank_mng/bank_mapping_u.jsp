<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.cls.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
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
		else if(fm.loan_sch_amt.value == 0){alert('���⿹���ݾ��� �Է��Ͻʽÿ�');fm.loan_sch_amt.focus();	return;	}
		else if(fm.loan_sch_amt.value == 0){alert('���⿹���ݾ��� �Է��Ͻʽÿ�');fm.loan_sch_amt.focus();	return;	}
//		if(fm.lend_dt.value == ''){			alert('�������ڸ� �Է��Ͻʽÿ�');	fm.lend_dt.focus();		return;	}
//		else if(fm.lend_prn.value == 0){	alert('��������� �Է��Ͻʽÿ�');	fm.lend_prn.focus();	return;	}
//		else if(fm.lend_int.value == ''){	alert('���������� �Է��Ͻʽÿ�');	fm.lend_int.focus();	return;	}
//		else if(fm.tot_alt_tm.value == ''){	alert('�Һ�Ƚ���� �Է��Ͻʽÿ�');	fm.tot_alt_tm.focus();	return;	}
//		else if(fm.alt_amt.value == ''){	alert('����ȯ�Ḧ �Է��Ͻʽÿ�');	fm.alt_amt.focus();		return;	}	
		if(confirm('�����Ͻðڽ��ϱ�?')){					
			fm.action='bank_mapping_u_a.jsp';
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

	//�����Աݾ�,�������� ��� �� ����
	function set_mapping(obj){
		var fm = document.form1;	
		if(obj==fm.loan_st_dt){ //�����û����
			fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.loan_sch_amt.value)));		
		}
		else if(obj==fm.lend_dt){ //��������
			fm.lend_prn.value = parseDecimal(fm.loan_sch_amt.value);
			fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));		
		}		
	}		

	//�ҺαⰣ,����ȯ�� ����
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
	
	//������ ���� ����
	function set_cltr(obj){
		var fm = document.form1;	
		if(obj == fm.cltr_set_dt){//�������� �Է�
		  fm.cltr_f_amt.value = fm.cltr_amt.value;
		  fm.cltr_user.value = fm.cpt_cd_nm.value;
			fm.reg_tax.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.002);
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.004);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.reg_tax){//������ϼ� �Է�
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) * 2);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else if(obj == fm.set_stp_fee){//���������� �Է�
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.exp_tax){//���ҵ�ϼ� �Է�
			fm.exp_stp_fee.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) * 2);
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}else if(obj == fm.exp_stp_fee){//���������� �Է�
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}		
	}		
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
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
	
	//�������(���)
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	//�����������(�Һ� ��������-�ϴ�)
	BankLendBean bl = abl_db.getBankLend(lend_id);
	//�Һ�����
	ContDebtBean debt = abl_db.getBankLend_mapping_allot(m_id, l_cd);
	//����������
	CltrBean cltr = abl_db.getBankLend_mapping_cltr(m_id, l_cd);
	//�����������
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");	
	//�ߵ���������
	ClsAllotBean cls = as_db.getClsAllot(m_id, l_cd);
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
%>
<form name='form1' action='bank_mapping_u_a.jsp' target='' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=s_rtn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='lend_int_m' value='<%=lend_int%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
<input type='hidden' name='cpt_cd' value='<%=debt.getCpt_cd()%>'>
<input type='hidden' name='cltr_gubun' value='<%=cltr.getCltr_st()%>'>
<input type='hidden' name='tot_amt_tm' value=''>
<input type='hidden' name='cltr_id' value='<%=cltr.getCltr_id()%>'>
<input type='hidden' name='cpt_cd_nm' value='<%=c_db.getNameById(debt.getCpt_cd(),"BANK")%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > �����ڱݰ��� > ���������� > <span class=style1><span class=style5>���⺰ ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  	<a href='javascript:save();'><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp; 
		<%}%>
        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<%=l_cd%> </td>
                    <td class='title'>��ȣ</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
                    <td class='title'> ����ڵ�Ϲ�ȣ</td>
                    <td align='left'>&nbsp;<%=ssn%></td>
                </tr>
                <tr> 
                    <td width=11% class='title'> ������ȣ</td>
                    <td width=14%>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td width=11% class='title'> ����</td>
                    <td width=14% align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 10)%></span></td>
                    <td width=11% class='title'>�Һ��ڰ���</td>
                    <td width=14%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>��&nbsp;</td>
                    <td width=11% class='title'>���԰���</td>
                    <td width=14%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>���<%if(cont.get("DLV_DT").equals("")){%>����<%}%>����</td>
                    <td>&nbsp;<%=cont.get("DLV_DT")%><%if(cont.get("DLV_DT").equals("")) out.println(cont.get("DLV_CON_DT"));%></td>
                    <td class='title'>���ʵ������</td>
                    <td>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
                    <td class='title'>���Ⱓ</td>
                    <td>&nbsp;<%=cont.get("CON_MON")%>����</td>
                    <td class='title'>�뿩���</td>
                    <td>&nbsp;<%=cont.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>��ళ����</td>
                    <td>&nbsp;<%=cont.get("RENT_START_DT")%></td>
                    <td class='title'>���������</td>
                    <td>&nbsp;<%=cont.get("RENT_END_DT")%></td>
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>��&nbsp;</td>
                    <td class='title'>�Ѵ뿩��</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_FEE_AMT")))%>��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> ������</td>
                    <td align='left'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("GRT_AMT")))%>��&nbsp;</td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("PP_AMT")))%>��&nbsp;</td>
                    <td class='title'>���ô뿩��</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("IFEE_AMT")))%>��&nbsp;</td>
                    <td class='title'>�������Ѿ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_PRE_AMT")))%>��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>�ڵ���ȸ��</td>
                    <td align='left'>&nbsp;<%if(mgr_dlv.get("COM_NM") != null) out.println(mgr_dlv.get("COM_NM"));%></td>
                    <td class='title'>����/������</td>
                    <td align='left'>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%></td>
                    <td class='title'>�������</td>
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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һΰ���</span></td>
    </tr>	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>�Һα���</td>
                    <td width=14%>&nbsp; 
                      <select name='allot_st'>
                        <!--            <option value="1" <%//if(debt.getAllot_st().equals("1")){%>selected<%//}%>>���ݱ���</option>-->
                        <option value="2" <%if(debt.getAllot_st().equals("2")){%>selected<%}%>>�Һα���</option>
                      </select>
                    </td>
                    <td class=title width=11%>�����籸��</td>
                    <td width=14%>&nbsp; 
                      <select name='cpt_cd_st'>
                        <option value="1" <%if(debt.getCpt_cd_st().equals("1")){%>selected<%}%>>��1������</option>
                        <option value="2" <%if(debt.getCpt_cd_st().equals("2")){%>selected<%}%>>��2������</option>
                      </select>
                    </td>
                    <td width=11% class='title'>������</td>
                    <td width=14%>&nbsp; 
                      <input type='text' name='cpt_nm' value='<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%>' size='12' maxlength='15' class='whitetext' >
                    </td>
                    <td width=11% class='title'>��ȯ����</td>
                    <td width=14%>&nbsp; 
                      <%if(rtn_st.equals("0")) {%>
                      ��ü 
                      <%} else if(rtn_st.equals("1")) {%>
                      ���� 
                      <%} else {%>
                      ���� 
                      <% }%>
                      &nbsp; 
                      <%if(!rtn_st.equals("0")){%>
                      <input type='text' name='rtn_seq' value='<%=debt.getRtn_seq()%>' size='2' class='text'>
                      �� 
                      <%}else{%>
                      <input type='hidden' name='rtn_seq' value=''>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�����û��</td>
                    <td>&nbsp; 
                      <input type='text' name='loan_st_dt' value='<%=debt.getLoan_st_dt()%>' size='12' maxlength='12' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_mapping(this);'>
                    </td>
                    <td class='title'>���⿹���ݾ�</td>
                    <td>&nbsp; 
                      <input type='text' name='loan_sch_amt' value='<%=Util.parseDecimal(debt.getLoan_sch_amt())%>' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class='title'>���⿹���ݾ�</td>
                    <td>&nbsp; 
                      <input type='text' name='pay_sch_amt' value='<%=Util.parseDecimal(debt.getPay_sch_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td class='title'>�����Աݾ�</td>
                    <td>&nbsp; 
                      <input type='text' name='dif_amt' value='<%=Util.parseDecimal(debt.getDif_amt())%>' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                </tr>
                <tr> 
                    <td class='title'>�����ȣ </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_no' value='<%=debt.getLend_no()%>' size='14' maxlength='15' class='text' style='IME-MODE: inactive'>
                    </td>
                    <td class='title'>�������� </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_dt' value='<%=debt.getLend_dt()%>' size='12' maxlength='12' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_mapping(this);'>
                    </td>
                    <td class='title'>������� </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_prn' value='<%=Util.parseDecimal(debt.getLend_prn())%>' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_mapping(this);''>
                      ��</td>
                    <td class='title'>�۱�ó</td>
                    <td>&nbsp; 
                      <input type='text' name='rimitter' size='12' maxlength='15' class='text' style='IME-MODE: active' value="<%=debt.getRimitter()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int_amt' value='<%=Util.parseDecimal(debt.getLend_int_amt())%>' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_alt_term(this);'>
                      ��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int' value='<%if(debt.getLend_int().equals("")){ out.println(lend_int); }else{ out.println(debt.getLend_int());}%>' size='10' maxlength='10' class='whitenum'>
                      %</td>
                    <td class='title'>��ȯ�ѱݾ�</td>
                    <td>&nbsp; 
                      <input type='text' name='rtn_tot_amt' value='<%=Util.parseDecimal(debt.getRtn_tot_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
                      ��</td>
                    <td class='title'>�Һ�Ƚ�� </td>
                    <td>&nbsp; 
                      <input type='text' name='tot_alt_tm' value='<%=debt.getTot_alt_tm()%>' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
                      ȸ</td>
                </tr>
                <tr> 
                    <td class='title'>����ȯ��</td>
                    <td>&nbsp; 
                      <input type='text' name='alt_amt' value='<%=Util.parseDecimal(debt.getAlt_amt())%>' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>�ҺαⰣ </td>
                    <td colspan="5">&nbsp; 
                      <input type='text' name='alt_start_dt' value='<%=debt.getAlt_start_dt()%>' size='12' maxlength='12' class='text'  onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
                      ~ 
                      <input type='text' name='alt_end_dt' value='<%=debt.getAlt_end_dt()%>' size='12' maxlength='12' class='text'  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                  </tr>
                  <tr> 
                    <td class='title'>��ȯ������ </td>
                    <td>&nbsp; 
                      <select name='rtn_est_dt'>
                        <%	for(int j=1; j<=31 ; j++){ //1~31�� %>
                        <option value='<%=j%>' <%if(debt.getRtn_est_dt().equals(Integer.toString(j))){%>selected<%}%>><%=j%>�� 
                        </option>
                        <% } %>
                        <option value='99' <%if(debt.getRtn_est_dt().equals("99")){%>selected<%}%>> 
                        ���� </option>
                      </select>
                    </td>
                    <td class='title'>��ȯ�ǹ���</td>
                    <td>&nbsp; 
                      <select name='loan_debtor'>
                        <option value='1' <%if(debt.getLoan_debtor().equals("1")){%>selected<%}%>>��</option>
                        <option value='2' <%if(debt.getLoan_debtor().equals("2")){%>selected<%}%>>���</option>
                      </select>
                    </td>
                    <td class='title'>��ȯ����</td>
                    <td>&nbsp; 
                      <select name='rtn_cdt'>
                        <option value='1' <%if(debt.getRtn_cdt().equals("1")){%>selected<%}%>>�����ݱյ�</option>
                        <option value='2' <%if(debt.getRtn_cdt().equals("2")){%>selected<%}%>>���ݱյ�</option>
                      </select>
                    </td>
                    <td class='title'>��ȯ���</td>
                    <td>&nbsp; 
                      <select name='rtn_way'>
                        <option value='1' <%if(debt.getRtn_way().equals("1")){%>selected<%}%>>�ڵ���ü</option>
                        <option value='2' <%if(debt.getRtn_way().equals("2")){%>selected<%}%>>����</option>
                        <option value='3' <%if(debt.getRtn_way().equals("3")){%>selected<%}%>>��Ÿ</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�Һμ����� </td>
                    <td>&nbsp; 
                      <input type='text' name='alt_fee' value='<%=Util.parseDecimal(debt.getAlt_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>������</td>
                    <td>&nbsp; 
                      <input type='text' name='ntrl_fee' value='<%=Util.parseDecimal(debt.getNtrl_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>������ </td>
                    <td>&nbsp; 
                      <input type='text' name='stp_fee' value='<%=Util.parseDecimal(debt.getStp_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>�Һ�����VAT</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int_vat' value='<%=Util.parseDecimal(debt.getLend_int_vat())%>' maxlength='10' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                </tr>
                <tr> 
                    <td class='title'>ä��Ȯ������</td>
                    <td colspan='7'>&nbsp; 
                      <select name='bond_get_st'>
                        <option value=""  <%if(debt.getBond_get_st().equals("")){%> selected<%}%>>����</option>
                        <option value="1" <%if(debt.getBond_get_st().equals("1")){%>selected<%}%>>��༭ 
                        </option>
                        <option value="2" <%if(debt.getBond_get_st().equals("2")){%>selected<%}%>>��༭+�ΰ�����</option>
                        <option value="3" <%if(debt.getBond_get_st().equals("3")){%>selected<%}%>>��༭+�ΰ�����+������</option>
                        <option value="4" <%if(debt.getBond_get_st().equals("4")){%>selected<%}%>>��༭+�ΰ�����+������+LOAN 
                        ���뺸���������</option>
                        <option value="5" <%if(debt.getBond_get_st().equals("5")){%>selected<%}%>>��༭+�ΰ�����+������+LOAN 
                        ���뺸����������</option>
                        <option value="6" <%if(debt.getBond_get_st().equals("6")){%>selected<%}%>>��༭+���뺸����</option>
                      </select>
                      �߰�����:&nbsp; 
                      <input type="text" name="bond_get_st_sub" value='<%=debt.getBond_get_st_sub()%>' maxlength='40' size="40" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��Ÿ</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="note" value='<%=debt.getNote()%>' maxlength='100' size="100" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�ߵ��Ͻû�ȯ��</td>
                    <td> &nbsp; 
                      <input type='text' name='cls_rtn_dt' value='<%=cls.getCls_rtn_dt()%>' size='12' maxlength='12' class='whitetext' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title'>�ߵ���ȯ��</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>�ߵ���ȯ������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_fee' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>�Ⱓ����</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_int_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title' style='height:38'>�ߵ��Ͻ�<br>��ȯ����</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="cls_rtn_cau" value="<%=cls.getCls_rtn_cau()%>" maxlength='100' size="100" class='whitetext'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����缳������</span>
        &nbsp;&nbsp;<input type="checkbox" name="cltr_st" value="Y" <%if(cltr.getCltr_st().equals("Y")){%>checked<%}%>>
        <span class=style7>�����缳��</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11% style='height:38'>����������</td>
                    <td width=14%>&nbsp; <input type='text' name='cltr_amt' value='<%=Util.parseDecimal(cltr.getCltr_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td width=11% class='title'>��������<br>
                      �ۼ�����</td>
                    <td width=14%>&nbsp; <input type='text' name='cltr_docs_dt' value='<%=cltr.getCltr_docs_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td width=11% class='title'>��������</td>
                    <td width=14%>&nbsp; <input type='text' name='cltr_set_dt' value='<%=cltr.getCltr_set_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_cltr(this);'> 
                    </td>
                    <td width=11% class='title'>��������</td>
                    <td width=14%>&nbsp; <input type='text' name='cltr_f_amt' value='<%=Util.parseDecimal(cltr.getCltr_f_amt())%>' size='11' maxlength='10' class='text' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      �� </td>
                </tr>
                <tr> 
                    <td class='title'>����Ǽ���</td>
                    <td>&nbsp; <select name='mort_lank'>
                        <option value="1" <%if(cltr.getMort_lank().equals("1")){%>selected<%}%>>1</option>
                        <option value="2" <%if(cltr.getMort_lank().equals("2")){%>selected<%}%>>2</option>
                        <option value="3" <%if(cltr.getMort_lank().equals("3")){%>selected<%}%>>3</option>
                      </select>
                      ��</td>
                    <td class='title'>������</td>
                    <td>&nbsp; <input type='text' name='cltr_per_loan' value='<%=cltr.getCltr_per_loan()%>' maxlength='6' size='6' class='num' onBlur='javascript:set_tot_amt(this)'>
                      %</td>
                    <td class='title'>���������</td>
                    <td>&nbsp; <input type='text' name='cltr_user' value='<%=cltr.getCltr_user()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>���ι�ȣ</td>
                    <td>&nbsp; <input name='cltr_num' type='text' class='text' id="cltr_num" value='<%=cltr.getCltr_num()%>' size='14' maxlength='20'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��ϰ�û</td>
                    <td>&nbsp; <input type='text' name='cltr_office' value='<%=cltr.getCltr_office()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>�����</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_man' value='<%=cltr.getCltr_offi_man()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>��ȭ��ȣ</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_tel' value='<%=cltr.getCltr_offi_tel()%>' size='12' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>�ѽ���ȣ</td>
                    <td>&nbsp; <input type='text' name='cltr_offi_fax' value='<%=cltr.getCltr_offi_fax()%>' size='12' maxlength='15' class='text'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>������ϼ�</td>
                    <td>&nbsp; <input type='text' name='reg_tax'  value='<%=Util.parseDecimal(cltr.getReg_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:document.form1.set_stp_fee.value=parseDecimal(toInt(this.value*2)); this.value=parseDecimal(this.value);  set_cltr(this);'>
                      ��&nbsp;</td>
                    <td class='title'>����������</td>
                    <td>&nbsp; <input type='text' name='set_stp_fee' value='<%=Util.parseDecimal(cltr.getSet_stp_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      ��&nbsp;</td>
                    <td class='title'>��������հ�</td>
                    <td colspan='3'>&nbsp; <input type='text' name='ext_tot_amt' value='<%=Util.parseDecimal(cltr.getReg_tax()+cltr.getSet_stp_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>���ҵ����</td>
                    <td>&nbsp; <input type='text' name='cltr_exp_dt' value='<%=cltr.getCltr_exp_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td class='title'>���һ���</td>
                    <td colspan="5">&nbsp; <input type='text' name='cltr_exp_cau' value='<%=cltr.getCltr_exp_cau()%>' maxlength='100' size='80' class='text'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>���ҵ�ϼ�</td>
                    <td>&nbsp; <input type='text' name='exp_tax'  value='<%=Util.parseDecimal(cltr.getExp_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      ��&nbsp;</td>
                    <td class='title'>����������</td>
                    <td>&nbsp; <input type='text' name='exp_stp_fee'  value='<%=Util.parseDecimal(cltr.getExp_stp_fee())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
                      ��&nbsp;</td>
                    <td class='title'>���Һ���հ�</td>
                    <td colspan='3'>&nbsp; <input type='text' name='exp_tot_amt'  value='<%=Util.parseDecimal(cltr.getExp_tax()+cltr.getExp_stp_fee())%>' maxlength='9' size='11' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>	
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һ� ��������</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>�ŷ�ó ����</td>
                    <td width=14%>&nbsp; 
                      <input type="text" name="cl_lim" value="<%if(bl.getCl_lim().equals("1")){%>��<%}else{%>��<%}%>" maxlength='5' size="5" class=whitetext>
                    </td>
                    <td class=title width=11%>������</td>
                    <td width=64%>&nbsp; 
                      <input type="text" name="cl_lim_sub" value="<%=bl.getCl_lim_sub()%>" maxlength='80' size="80" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���� ����</td>
                    <td>&nbsp; 
                      <input type="text" name="ps_lim" value="<%if(bl.getPs_lim().equals("1")){%>��<%}else{%>��<%}%>" maxlength='5' size="5" class=whitetext>
                    </td>
                    <td class=title>����ݾ� ����</td>
                    <td>&nbsp; 
                      <input type="text" name="lend_amt_lim" value="<%if(bl.getLend_amt_lim().equals("1")){%>(��������(Ź�۷�����)/1.1)�� ���� �ݾ׿� �������� ����<%}else if(bl.getLend_amt_lim().equals("0")){%>����<%}%>" maxlength='80' size="70" class=whitetext>
                      <font color="#999999">(����)</font></td>
                </tr>
                <tr> 
                    <td class=title style='height:38'>�����缳��<br>ä���ְ��</td>
                    <td>&nbsp;�������
                      <input type="text" name="max_cltr_rat" value="<%=bl.getMax_cltr_rat()%>" maxlength='3' size="3" class=whitetext>(%)</td>
                    <td class=title>�����û<br>�Ⱓ����</td>
                    <td>&nbsp; 
                      <input type="text" name="lend_lim_st" value="<%=bl.getLend_lim_st()%>" size="12" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="lend_lim_et" value="<%=bl.getLend_lim_et()%>" size="12" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr id=tr_docs  style="display:''"> 
                    <td class=title style='height:38'>ä�Ǿ絵���<br>��༭</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="cre_docs" value="<%=bl.getCre_docs()%>" maxlength='80' size="80" class=whitetext>
                      <font color="#999999">(��:������ �Ժ���)</font></td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
