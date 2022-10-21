<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.cls.*, acar.bill_mng.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
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
	
	//�˾�â���� ȣ��� �����Ұ� ó���� ���� ����(2017.12.22)
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String modify_yn = ""; 
	if(from_page.equals("/off_ls_pre_go_debt_pop_a.jsp"))	modify_yn = "N";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	//�������
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	if(car_id.equals(""))	car_id = String.valueOf(cont.get("CAR_MNG_ID"));

	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	
	//�����������
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	CodeBean[] banks = c_db.getBankList("1"); /* �ڵ� ����:��1������ */	
	int bank_size = banks.length;
	CodeBean[] banks2 = c_db.getBankList("2"); /* �ڵ� ����:��2������ */
	int bank_size2 = banks2.length;
	
	//�Һ�����
	ContDebtBean debt = ad_db.getContDebtReg(m_id, l_cd);
	//����������
	CltrBean cltr = ad_db.getBankLend_mapping_cltr(m_id, l_cd);
	//�ߵ���������
	ClsAllotBean cls = as_db.getClsAllot(m_id, l_cd);
	
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
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+""+file_type;		
		}
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();			
	}	
	
	function save(){
		var fm = document.form1;

		if(fm.allot_st.value == '2'){
			if(fm.cpt_cd.value == '' && fm.cpt_cd2.value == ''){	alert('�����縦 �Է��Ͻʽÿ�');	fm.lend_dt.focus(); return;	}		
			if(fm.lend_dt.value == ''){			alert('�������ڸ� �Է��Ͻʽÿ�');		fm.lend_dt.focus(); 		return;	}
			if(fm.lend_prn.value == ''){		alert('��������� �Է��Ͻʽÿ�');		fm.lend_prn.focus(); 		return;	}
//			if(fm.lend_int.value == ''){		alert('���������� �Է��Ͻʽÿ�');		fm.lend_int.focus(); 		return;	}
			if(fm.rtn_tot_amt.value == ''){		alert('��ȯ�ѱݾ��� �Է��Ͻʽÿ�');		fm.rtn_tot_amt.focus(); 	return;	}						
			if(fm.tot_alt_tm.value == ''){		alert('�Һ�Ƚ���� �Է��Ͻʽÿ�');		fm.tot_alt_tm.focus(); 		return;	}						
			if(fm.alt_amt.value == ''){			alert('����ȯ�Ḧ �Է��Ͻʽÿ�');		fm.alt_amt.focus();			return;	}		
		}

		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));

		//�ڵ���ǥ
		if(fm.autodoc_yn.checked == true){
			if(fm.ven_code.value == ""){ alert("�ŷ�ó�� �����Ͻʽÿ�."); return; }
			if(fm.bank_code.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
			if(fm.deposit_no.value == ""){ alert("���¹�ȣ�� �����Ͻʽÿ�."); return; }									
			//�ŷ�ó
			//var ven_code = fm.ven_code.options[fm.ven_code.selectedIndex].value;
			//fm.ven_code2.value = ven_code.substring(0,6);
			//fm.firm_nm.value = ven_code.substring(6);
			//���¹�ȣ
			fm.bank_code2.value = fm.bank_code.value;
			var deposit_no = fm.deposit_no.options[fm.deposit_no.selectedIndex].value;
			var deposit_split = deposit_no.split(":");
			fm.deposit_no2.value = deposit_split[0];
		}		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){					
			fm.action='debt_reg_u_a.jsp';		
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
	
	//�����ٺ���
	function go_to_scd(){
		var fm = document.form1;		
		fm.action='debt_scd_u.jsp';		
		fm.target='d_content';
		fm.submit();	
	}	
	
	//�������
	function go_lend_bank(lend_id){
		var fm = document.form1;		
		fm.action='../bank_mng/bank_reg_frame.jsp?lend_id='+lend_id;		
		fm.target='d_content';
		fm.submit();	
	}		
	//������⽺����
	function go_lend_bank_scd(lend_id, rtn_seq){
		var fm = document.form1;		
		fm.action='../bank_mng/bank_scd_u.jsp?lend_id='+lend_id+'&rtn_seq_r='+rtn_seq;		
		fm.target='d_content';
		fm.submit();	
	}			

	//���ະ���⸮��Ʈ
	function mapping_list(lend_id, rtn_seq){
		var fm = document.form1;	
		var auth_rw = fm.auth_rw.value;		
		window.open('../bank_mng/bank_mapping_frame_s.jsp?gubun=list&auth_rw='+auth_rw+'&lend_id='+lend_id+'&s_rtn='+rtn_seq+'&rtn_st=0', "MAPPING", "left=100, top=30, width=900, height=650, scrollbars=yes, status=yes");
	}
		
	//�ҺαⰣ,����ȯ�� ����
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
//			fm.exp_stp_fee.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) * 2);
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}else if(obj == fm.exp_stp_fee){//���������� �Է�
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
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
	


	//�ߵ�����
	function view_cls(){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var car_id = fm.car_id.value;
		var cls_yn = fm.cls_yn.value;
		var url = "";
		if(cls_yn == 'Y') 	url = "../cls_allot/cls_u.jsp?m_id="+m_id+"&l_cd="+l_cd+"&car_id="+car_id+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		else				url = "../cls_allot/cls_i.jsp?m_id="+m_id+"&l_cd="+l_cd+"&car_id="+car_id+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		window.open(url, "CLS_I", "left=100, top=80, width=840, height=550, status=yes, scrollbars=yes");
	}	
	
	//�ڵ���ǥ----------------------------------------------------------------------------------------------------
	
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		//����
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}		
	//��ȸ�ϱ�
	function ven_search(){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx=", "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}
	
	//��ĵ���
	function scan_reg(){
		window.open("/acar/bank_mng/reg_scan.jsp?lend_id=<%=l_cd%>&alt_st=allot", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
	//��ĵ����
	function scan_del(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		fm.target = "i_no"
		fm.action = "/acar/bank_mng/del_scan_a.jsp";
		fm.submit();
	}	
		
	//�ü��ڱ� ��ȸ
	function search_fund_bank(){
		var fm = document.form1;
		window.open("/fms2/bank_mng/s_fund_bank.jsp?from_page=/fms2/bank_mng/debt_scd_reg_i.jsp&lend_id=&cont_bn="+fm.cpt_cd.value, "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, scrollbars=yes");		
	}	
		

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>

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
<input type='hidden' name='cls_yn' value='<%=debt.getCls_yn()%>'>
<input type='hidden' name='dif_amt' value=''>
<input type='hidden' name='rimitter' value=''>
<input type='hidden' name='cpt_cd_nm' value='<%=c_db.getNameById(debt.getCpt_cd(),"BANK")%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='alt_st' value='allot'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>�繫ȸ�� > �����ڱݰ��� > �Һαݰ��� ><span class=style5>�Һα� ����(�Ǻ�)</span></span></td>
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
        <%if(modify_yn.equals("N")){%>
        	<br><div align="left"><b>���� �˾�â������ ���������� �����մϴ�. ��� �� ������ �繫ȸ�� > �ڱݰ��� > �Һαݻ�ȯ��������ȸ �� ����� �ּ���.</b></div><br>
        <%}else{%>
		    <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>					  
		    <a href='javascript:save();'><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		    <%	}%>		  
	        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
	    <%}%>    
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
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
                    <td width='10%' class='title'> ������ȣ</td>
                    <td width='15%'>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td width='10%' class='title'> ����</td>
                    <td width='15%' align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 9)%></span></td>
                    <td width='10%' class='title'>�Һ��ڰ���</td>
                    <td width='15%'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>��&nbsp;</td>
                    <td width='10%' class='title'>���԰���</td>
                    <td width='15%'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td>&nbsp;<%=cont.get("DLV_DT")%></td>
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
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("COM_NM") != null) out.println(mgr_dlv.get("COM_NM"));%>
                    </td>
                    <td  class='title'>����/������</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>
                      &nbsp;
                      <%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>
                    </td>
                    <td  class='title'>�������</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("NM") != null) out.println(mgr_dlv.get("NM"));%>
                      &nbsp;
                      <%if(mgr_dlv.get("POS") != null) out.println(mgr_dlv.get("POS"));%>
                    </td>
                    <td class='title'>��ȭ��ȣ</td>
                    <td align='left'>&nbsp;
                      <%if(mgr_dlv.get("O_TEL") != null) out.println(mgr_dlv.get("O_TEL"));%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(debt.getLend_id().equals("")){%>  
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڱݰ���</span></td>        
    </tr>  
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�ڱݰ�����ȣ</td>
                    <td >&nbsp; 
                    	<input type="text" name="fund_id" size="10" value='<%=debt.getFund_id()%>' class="text">
                    <%if(modify_yn.equals("N")){}else{%>	 
                    	<a href="javascript:search_fund_bank()">[�ڱݰ�������]</a>
                    <%}%>	
                </tr>
            </table>
        </td>
    </tr>	    
  <%}else{%>
  <input type='hidden' name='fund_id' value='<%=debt.getFund_id()%>'>
  <%}%>
	<%if(!debt.getRtn_seq().equals("")){
		BankLendBean bl = abl_db.getBankLend(debt.getLend_id());
		BankRtnBean br  = new BankRtnBean();
		if(!debt.getRtn_seq().equals("")){
			br = abl_db.getBankRtn(debt.getLend_id(), debt.getRtn_seq());
		}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
        <td align="right">
        <%if(modify_yn.equals("N")){}else{%> 
	    	<a href="javascript:mapping_list('<%=debt.getLend_id()%>', '<%=debt.getRtn_seq()%>')" onMouseOver="window.status=''; return true"><img src=../images/center/button_list_bank.gif align=absmiddle border=0></a>
	    <%}%>	
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>�����</td>
                    <td width='15%'>&nbsp;<%=bl.getCont_dt()%></td>
                    <td width='10%' class='title'>�����ȣ</td>
                    <td width='15%'>&nbsp;<input type='text' name='lend_id' value='<%=debt.getLend_id()%>' size='4' maxlength='4' class='text'></td>
                    <td width='10%' class='title'>��ȯ����</td>
                    <td align='left'>&nbsp;<input type='text' name='rtn_seq' value='<%=debt.getRtn_seq()%>' size='2' maxlength='2' class='text'>&nbsp;		
                            <select name='rtn_st_nm' disabled>
                              <option value="0" <%if(bl.getRtn_st().equals("0")){%>selected<%}%>>��ü</option>
                              <option value="1" <%if(bl.getRtn_st().equals("1")){%>selected<%}%>>����</option>
                              <option value="2" <%if(bl.getRtn_st().equals("2")){%>selected<%}%>>����</option>
                            </select>	
        			</td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=bl.getCont_dt()%></td>
                    <td class='title'>����ݾ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimalLong(br.getRtn_cont_amt())%></td>
                    <td class='title'>����Ⱓ</td>
                    <td align='left'>&nbsp;<%=br.getCont_start_dt()%>~<%=br.getCont_end_dt()%>
                    <%if(modify_yn.equals("N")){}else{%>							
	        			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:go_lend_bank('<%=debt.getLend_id()%>')"><img src=../images/center/button_in_bank.gif align=absmiddle border=0></a>
	        			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:go_lend_bank_scd('<%=debt.getLend_id()%>', '<%=debt.getRtn_seq()%>')"><img src=../images/center/button_in_scha.gif align=absmiddle border=0></a>
	        		<%}%>				
        			</td>
                </tr>		  
            </table>
        </td>
    </tr>	
	<%}%>
	<tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һΰ���</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�Һα���</td>
                    <td width=15%>&nbsp; 
                      <select name='allot_st'>
                        <option value="1" <%if(debt.getAllot_st().equals("1")){%>selected<%}%>>���ݱ���</option>
                        <option value="2" <%if(debt.getAllot_st().equals("2")){%>selected<%}%>>�Һα���</option>
                      </select>
                    </td>
                    <td class=title width=10%>�����籸��</td>
                    <td width=15%>&nbsp; 
                      <select name='cpt_cd_st' onChange='javascript:bn_display()'>
                        <option value=""  <%if(debt.getCpt_cd_st().equals("")){%>selected<%}%>>����</option>
                        <option value="1"  <%if(debt.getCpt_cd_st().equals("1")){%>selected<%}%>>��1������</option>
                        <option value="2"  <%if(debt.getCpt_cd_st().equals("2")){%>selected<%}%>>��2������</option>
                      </select>
                    </td>
                    <td width=10% class='title'>������</td>
                    <td width=15%> 
                      <table width="115" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id="td_bn_1" style="display:<%if(debt.getCpt_cd_st().equals("1") || debt.getCpt_cd_st().equals("")) {%>''<%}else{%>none<%}%>" width="115">&nbsp; 
                            <select name='cpt_cd'>
        	                <option value="" >����</option>					
                              <%	if(bank_size > 0){
        								for(int i = 0 ; i < bank_size ; i++){
        									CodeBean bank = banks[i];		%>
                              <option value='<%= bank.getCode()%>'  <%if(debt.getCpt_cd().equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                          </td>
                          <td id="td_bn_2" style="display:<%if(debt.getCpt_cd_st().equals("2")){%>''<%}else{%>none<%}%>" width="115">&nbsp; 
                            <select name='cpt_cd2'>
                     	   <option value="" >����</option>					
                              <%	if(bank_size2 > 0){
        								for(int i = 0 ; i < bank_size2 ; i++){
        									CodeBean bank2 = banks2[i];		%>
                              <option value='<%= bank2.getCode()%>' <%if(debt.getCpt_cd().equals(bank2.getCode())){%>selected<%}%>><%= bank2.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td width=10% class='title'>�����ȣ </td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='lend_no' value='<%=debt.getLend_no()%>' size='20' maxlength='30' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�������� </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_dt' value='<%=debt.getLend_dt()%>' size='11' maxlength='11' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title'>������� </td>
                    <td>&nbsp; 
                      <input type='text' name='lend_prn' value='<%=Util.parseDecimal(debt.getLend_prn())%>' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int_amt' value='<%=Util.parseDecimal(debt.getLend_int_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
                      ��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='lend_int' value='<%=debt.getLend_int()%>' size='6' maxlength='6' class='num'>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>��ȯ�ѱݾ�</td>
                    <td>&nbsp; 
                      <input type='text' name='rtn_tot_amt' value='<%=Util.parseDecimal(debt.getRtn_tot_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
                      ��</td>
                    <td class='title'>��ȯ�ǹ���</td>
                    <td>&nbsp; 
                      <select name='loan_debtor'>
                        <option value='2' <%if(debt.getLoan_debtor().equals("2")){%>selected<%}%>>���</option>
                        <option value='1' <%if(debt.getLoan_debtor().equals("1")){%>selected<%}%>>��</option>
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
                    <td class='title'>�Һ�Ƚ�� </td>
                    <td>&nbsp; 
                      <input type='text' name='tot_alt_tm' value='<%=debt.getTot_alt_tm()%>' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
                      ȸ</td>
                    <td class='title'>�ҺαⰣ </td>
                    <td colspan="3">&nbsp; 
                      <input type='text' name='alt_start_dt' value='<%=debt.getAlt_start_dt()%>' size='11' maxlength='11' class='text'  onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
                      ~ 
                      <input type='text' name='alt_end_dt' value='<%=debt.getAlt_end_dt()%>' size='11' maxlength='11' class='text'  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����ȯ��</td>
                    <td>&nbsp; 
                      <input type='text' name='alt_amt' value='<%=Util.parseDecimal(debt.getAlt_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>�Һμ����� </td>
                    <td>&nbsp; 
                      <input type='text' name='alt_fee' value='<%=Util.parseDecimal(debt.getAlt_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>������</td>
                    <td>&nbsp; 
                      <input type='text' name='ntrl_fee' value='<%=Util.parseDecimal(debt.getNtrl_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td class='title'>������ </td>
                    <td>&nbsp; 
                      <input type='text' name='stp_fee' value='<%=Util.parseDecimal(debt.getStp_fee())%>' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>��Ÿ���</td>
                    <td colspan='7'>&nbsp;
                      ���� : 
                      <input type="text" name="alt_etc" value='<%=debt.getAlt_etc()%>' maxlength='100' size="40" class=text>&nbsp; 
                      &nbsp; �ѱݾ� :
                      <input type='text' name='alt_etc_amt' value='<%=AddUtil.parseDecimal(debt.getAlt_etc_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��
                      &nbsp; ȸ�� :
                      <input type='text' name='alt_etc_tm' value='<%=debt.getAlt_etc_tm()%>' size='3' maxlength='2' class='num'>
                      ȸ
                      &nbsp;
                      (����ݿ� ���ԵǾ� ������ ���� ���� ��ȯ�� ���)
                      </td>                    
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
                    <td class=title width=10%>�ߵ���ȯ<br>��������</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="<%=debt.getCls_rtn_fee_int()%>" size="5" class=text >
                      %</td>
                    <td class=title wwidth=10%>�ߵ���ȯ<br>Ư�̻���</td>
                    <td colspan='5'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"><%=debt.getCls_rtn_etc()%></textarea></td>                    
                </tr>	
                <tr> 
                    <td class='title'>����������༭</td>
                    <td colspan='7'>&nbsp;
                    <%if(modify_yn.equals("N")){}else{%> 
				  		<%if(debt.getFile_name().equals("")){%>
				    		<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  		<%}else{%>
					    	<%=debt.getFile_name()%><%= debt.getFile_type() %>
							&nbsp;<a href="javascript:ScanOpen('<%= debt.getFile_name() %>', '<%= debt.getFile_type() %>')"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>						
							&nbsp;<a href="javascript:scan_del()"><img src=/acar/images/center/button_in_delete.gif border=0 align=absmiddle></a>
							&nbsp;<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
					  	<%}%>
					<%}%>	  		
                    </td>
                </tr>								
            </table>
        </td>
    </tr>				
	<tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ���ȯ</span></td>
        <td align="right">
        <%if(modify_yn.equals("N")){}else{%> 
		    <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	        <a href="javascript:view_cls();"><img src=../images/center/button_hj.gif align=absmiddle border=0></a>
		    <%	}%>
		<%}%>    		 		
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr> 
                    <td class='title'>�ߵ��Ͻû�ȯ��</td>
                    <td> &nbsp; 
                      <input type='text' name='cls_rtn_dt' value='<%=cls.getCls_rtn_dt()%>' size='11' maxlength='11' class='whitetext' onBlur='javscript:this.value=ChangeDate(this.value);'>
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
                    <td class='title' style='height:38'>��Ÿ������</td>
                    <td colspan='7'>&nbsp; 
                      <input type="text" name="cls_etc_fee" value="<%=cls.getCls_etc_fee()%>" maxlength='10' size="12" class='whitenum'>
                      ��&nbsp;(���縻�Ҵ���� ��)
                    </td>
                </tr>
                <tr> 
                    <td class='title' style='height:38'>�ߵ��Ͻ�<br>
                      ��ȯ����</td>
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
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����缳������</span>
	    <input type='hidden' name='cltr_id' value='<%=cltr.getCltr_id()%>'> 
        &nbsp;&nbsp;<input type="checkbox" name="cltr_st" value="Y" <%if(cltr.getCltr_st().equals("Y")){%>checked<%}%>>
        <span class=style7>�����缳��</span></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����������</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_amt' value='<%=Util.parseDecimal(cltr.getCltr_amt())%>' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��</td>
                    <td width=10% class='title' style='height:36'>��������<br>
                      �ۼ�����</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_docs_dt' value='<%=cltr.getCltr_docs_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td width=10% class='title'>��������</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_set_dt' value='<%=cltr.getCltr_set_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_cltr(this)'> 
                    </td>
                    <td width=10% class='title'>��������</td>
                    <td width=15%>&nbsp; <input type='text' name='cltr_f_amt' value='<%=Util.parseDecimal(cltr.getCltr_f_amt())%>' size='11' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
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
                    <td>&nbsp; <input type='text' name='cltr_per_loan' value='<%=cltr.getCltr_per_loan()%>' maxlength='6' size='6' class='num' onBlur='javascript:set_cltr(this)'>
                      %</td>
                    <td class='title'>���������</td>
                    <td>&nbsp; 
                      <input type='text' name='cltr_user' value='<%=cltr.getCltr_user()%>' size='12' maxlength='15' class='text'> 
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
                    <td>&nbsp; <input type='text' name='reg_tax'  value='<%=Util.parseDecimal(cltr.getReg_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cltr(this);'>
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
                    <td>&nbsp; <input type='text' name='exp_tax'  value='<%=Util.parseDecimal(cltr.getExp_tax())%>' maxlength='9' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_cltr(this);'>
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
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һ� �ڵ���ǥ ����</span>
        &nbsp;&nbsp;<input type="checkbox" name="autodoc_yn" value="Y" <%if(debt.getAutodoc_yn().equals("Y")){%>checked<%}%>>
        <span class=style7>�ڵ���ǥ</span></td>
    </tr>
	<%	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();	
		
		//�ŷ�ó����
		CodeBean[] vens = neoe_db.getCodeAll(c_db.getNameById(debt.getCpt_cd(),"BANK"));
		int ven_size = vens.length;
		
		Hashtable ven = new Hashtable();
		if(!debt.getVen_code().equals("")){
			ven = neoe_db.getVendorCase(debt.getVen_code());
		}
		
		//�׿��� ���ฮ��Ʈ
		CodeBean[] a_banks = neoe_db.getCodeAll();
		int a_bank_size = a_banks.length;
	%>
<input type='hidden' name='bank_code2' value=''>
<input type='hidden' name='deposit_no2' value=''>
<input type='hidden' name='bank_name' value=''>
<!--
<input type='hidden' name='ven_code2' value=''>
<input type='hidden' name='firm_nm' value=''>-->
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�ŷ�ó</td>
                    <td width=40%>&nbsp; 
                      <input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href='javascript:ven_search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif align=absmiddle border=0></a> 
        			  <input type='hidden' name='ven_code' size='10' value='<%=debt.getVen_code()%>' class='text'>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=40%>&nbsp; 
                      <input type="radio" name="acct_code" value="26000" <%if(debt.getAcct_code().equals("26000"))%>checked<%%>>
                      �ܱ����Ա� 
                      <input type="radio" name="acct_code" value="29300" <%if(debt.getAcct_code().equals("26400")||debt.getAcct_code().equals("29300"))%>checked<%%>>
                      ������Ա�
                       <input type="radio" name="acct_code" value="45450" <%if(debt.getAcct_code().equals("45450"))%>checked<%%>>
                      ������ 
                      </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <select name='bank_code' onChange='javascript:change_bank()'>
                        <option value=''>����</option>
                        <%if(a_bank_size > 0){
        						for(int i = 0 ; i < a_bank_size ; i++){
        							CodeBean a_bank = a_banks[i];	%>
                        <option value='<%= a_bank.getCode()%><%//= a_bank.getNm()%>' <%if(debt.getBank_code().equals(a_bank.getCode()))%>selected<%%>> <%= a_bank.getNm()%> 
                        </option>
                        <%	}
        					}	%>
                      </select>
                    </td>
                    <td class=title>���¹�ȣ</td>
                    <td>&nbsp; 
                      <select name='deposit_no'>
                        <option value=''>���¸� �����ϼ���</option>
        				<%if(!debt.getBank_code().equals("")){
        						Vector deposits = neoe_db.getDepositList(debt.getBank_code());
        						int deposit_size = deposits.size();
        						for(int i = 0 ; i < deposit_size ; i++){
        							Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        				<option value='<%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%>' <%if(debt.getDeposit_no().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        				<%		}
        				}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(modify_yn.equals("N")){}else{%>	
		<%if(debt.getRtn_seq().equals("")){%>	
	    <tr> 
	        <td align="right" colspan=2><a href="javascript:go_to_scd()"><img src=../images/center/button_see_sch.gif align=absmiddle border=0></a></td>
	    </tr>		
		<%}%>
	<%}%>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

