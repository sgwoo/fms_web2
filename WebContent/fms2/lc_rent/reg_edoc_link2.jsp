<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.alink.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="cr_bean" scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 	= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 	= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 	= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 	= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");

	if(link_table.equals("rm_rent_link_m")) link_table = "rm_rent_link";
	if(link_table.equals("lc_rent_link")) link_table = "lc_rent_link_m";

	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//�������
	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "�������");
	//���°�-����������
	CarMgrBean suc_mgr = new CarMgrBean();
	
	if(link_type.equals("2")){	
		suc_mgr = a_db.getCarMgr(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "�������");	
	}
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
	//������ ��༭�� �ִ��� Ȯ���Ѵ�.
	Vector vt = ln_db.getALinkHisList("lc_rent_link", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size = vt.size();

	Vector vt2 = ln_db.getALinkHisListM("lc_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size2 = vt2.size();
	
	Vector vt3 = ln_db.getALinkHisStatList("lc_rent_link", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size3 = vt3.size();	
		
	Vector vt4 = ln_db.getALinkHisStatListM("lc_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq);
	int vt_size4 = vt4.size();
	
	String wait_yn = "N";	
	
	int wait_cnt = 0;

	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);
	
	String edoc_link_yn 		= e_db.getEstiSikVarCase("1", "", "edoc_link_yn");
	
	//�̿밳���� & ����ȸ�� �� ���� ���� fetch(20191010)	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
	.papy{	background-color: #FAF4C0;	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�̸����ּ� ����
	function isEmail(str) {
		// regular expression? ���� ���� ����
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}
	
	//���Ÿ����ּ� ����
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.mgr_nm.value 	= i_mail_addr_split[0];
			fm.mgr_email.value 	= i_mail_addr_split[1];
			fm.mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.mgr_nm.value 	= '';
			fm.mgr_email.value 	= '';
			fm.mgr_m_tel.value 	= '';
		}
	}	
	
	<%if(link_type.equals("2")){	%>
	//���������� ���Ÿ����ּ� ����
	function suc_mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.suc_s_mail_addr.options[fm.suc_s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.suc_mgr_nm.value 	= i_mail_addr_split[0];
			fm.suc_mgr_email.value 	= i_mail_addr_split[1];
			fm.suc_mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.suc_mgr_nm.value 	= '';
			fm.suc_mgr_email.value 	= '';
			fm.suc_mgr_m_tel.value 	= '';
		}
	}
	<%}%>		
		
	function link_send(){	
		
		var fm = document.form1;
		
		var addr = fm.mgr_email.value;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		<%if(link_table.equals("lc_rent_link_m") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('����༭ �����϶��� ��ǥ�� ���뺸�� ��� ��ǥ�� ���������� �ؾ� �մϴ�. ');	
			return;
		<%}%>	
		
		<%if(link_table.equals("lc_rent_link_m") && client.getClient_st().equals("2") && client.getM_tel().equals("")){%>
			alert('����༭ �����϶��� �޴��� ��ȣ�� �ԷµǾ�� �մϴ�. ���������� �Է��Ͻʽÿ�.');	
			return;
		<%}%>			
		
		<%if(link_table.equals("rm_rent_link")){%>
		<%	if(fee_rm.getCms_type().equals("")){%>
		if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
			alert('2ȸ�� û������� �����Ͻʽÿ�.'); return;
		}
		<%	}%>
		<%}%>
		
		
						
		if(fm.rent_l_cd.value == '') 	{ alert('��༭�� ���õ��� �ʾҽ��ϴ�. ���Ϲ߼��� �ȵ˴ϴ�.'); 	return; }
		
		if(fm.doc_st != null && fm.doc_st.value != '2'){
			
		if(fm.email_chk.checked==false){ 
			if(isEmail(addr)==false)	{ alert("�ùٸ� �̸����ּҸ� �Է����ּ���"); 			return; }
		}
		if(addr=="" || addr=="@")	{ alert("�����ּҸ� �Է����ּ���!"); 				return; }
		if(addr.indexOf("@")<0)		{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		if(addr.indexOf(".")<0)		{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		if(get_length(addr) < 5)	{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		
		//���������� �̸��������ʼ��Է�(20190219)
		<%-- <%if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
		<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
			<%-- <%if(client.getRepre_email().equals("")){%> --%>
				if(fm.repre_email.value==""){					alert("������������ �����ּҸ� �Է����ּ���!");				return;	}
				if(fm.repre_email.value.indexOf("@")<0){ 	alert("������������ �����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 		return; 	}
				if(fm.repre_email.value.indexOf(".")<0){ 	alert("������������ �����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 		return; 	}
				if(get_length(fm.repre_email.value) < 5)	{ 	alert("������������ �����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 		return; 	}
			<%-- <%}%> --%>	
		<%}%>
		
		//�̿밳�������� ����ȸ���� �� ũ�� ���ۺҰ�(20191010)
<%	if(!fees.getFee_pay_tm().equals("")&&!fees.getCon_mon().equals("")){
			if(AddUtil.parseInt(fees.getFee_pay_tm()) > AddUtil.parseInt(fees.getCon_mon())){%>
				alert("����Ƚ���� �̿�Ⱓ(������)���� �� Ů�ϴ�. Ȯ�����ּ���.");		return;
<%		}
		}	%>
		
		// ���ڰ�༭ ���� �� ��ȣ+����ȣ�� 60�ڸ��� ������ ���ڰ�༭ ���� �Ұ�
		<% if((rent_l_cd+client.getFirm_nm()).length() > 60){%>
			alert('����ȣ+��ȣ�� 60�ڸ��� ������ ���ڰ�༭�� ������ �� �����ϴ�.');
			return;
		<%}%>
		}
		
		// �ڵ���ü ��û�� ���� �߼� ����
		var vt_size2 = <%=vt_size2%>;
		if( vt_size2 == 0 ){	// ���� �߼� �� �ڵ���ü ��û�� �߼�.
			fm.cms_mail_send_yn.value = 'Y';			
		} else {		// ���ڰ�༭ ��� �� ��߼� �� �ڵ���ü ��û�� ���� �߼� �׸� üũ�� ��쿡�� �߼�.
			var check = fm.cms_mail_yn.checked;
			if(check){
				fm.cms_mail_send_yn.value = 'Y';	
			}else{
				fm.cms_mail_send_yn.value = 'N';
			}
		}
		
		if(!confirm("���ڰ�༭ ������ �Ұ��ϹǷ� �������� ������ �ʿ��� ��\n\n���>���� �ϼž��մϴ�.\n\n�����Ͻðڽ��ϱ�?")){
			return;
		}
		
	//	fm.action='reg_edoc_link_send.jsp';
		fm.action='reg_edoc_link_send2.jsp'; 
	//	fm.target='_self';
		fm.target='EDOC_LINK2';
		fm.submit();
	}
	
	<%-- function link_resend(link_com, doc_code){		
		var fm = document.form1;

		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>

		<%if(link_table.equals("lc_rent_link") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('����༭ �����϶��� ��ǥ�� ���뺸�� ��� ��ǥ�� ���������� �ؾ� �մϴ�. ');	
			return;
		<%}%>
		
		//���������� �̸��������ʼ��Է�(20190219)
		<%if(cont_etc.getClient_share_st().equals("1")){%>
			<%if(client.getRepre_email().equals("")){%>
				alert("������������ �̸��� ������ �Է��ϼ���. ���������� �Է��Ͻʽÿ�.");	return;
			<%}%>	
		<%}%>
		
		fm.doc_code.value = doc_code;	
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_resend.jsp';					
		fm.target='_self';		
		fm.submit();
	} --%>	

	//���
	function link_delete(link_com, doc_code){		
		
		if(!confirm("������������ ���� ����Ͻ÷��� ���������� ������ ���ּ���.\n\n�̸����ּҸ� �����ؼ� ������ �� �� �ֽ��ϴ�.\n\n����Ͻðڽ��ϱ�?")){
			return;
		}
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		//fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete2.jsp';		
		fm.target='_self';
		fm.submit();
	}	

	//�Ϸ����� 
	<%-- function link_delete_admin(link_com, doc_code){		
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete_admin.jsp';		
		fm.target='_self';
		fm.submit();
	} --%>	
	
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}	
	
	function change_doc_st(val){
		var fm = document.form1;
		if(val == 2){
			document.getElementById('mgr_nm').readOnly = true;
			fm.mgr_nm.style.background = '#e0e0e0';
			document.getElementById('mgr_m_tel').readOnly = true;
			fm.mgr_m_tel.style.background = '#e0e0e0';
		} else{
			fm.s_mail_addr.readOnly = false;
			document.getElementById('mgr_nm').readOnly = false;
			fm.mgr_nm.style.background = '#ffffff';
			document.getElementById('mgr_m_tel').readOnly = false;
			fm.mgr_m_tel.style.background = '#ffffff';
		}
	}
//-->
</script>

</head>

<body>
<!-- <center> -->
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
  <input type='hidden' name="doc_code" 	        value="">  
  <input type='hidden' name="bus_id" 	value="<%=base.getBus_id()%>">  
  <input type='hidden' name="bus_st" 	value="<%=base.getBus_st()%>">  
  <input type='hidden' name="cms_mail_send_yn" 	value="">  
  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���ڹ��� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td style="font-size: 20px; font-weight: bold; padding-bottom: 10px; padding-top: 10px;">
    		������(��������) ���ڰ�༭ ����
    		<input type='button' class='button' value='���ڰ�༭ �̿� ���̵�' onclick="javascript:openPopF('application/pdf','8817658');">
    		<input type='button' class='button' value='���� �̿� ����' onclick="javascript:openPopF('application/pdf','9368137');">
    		<input type='button' class='button' value='���ϼ��źҰ� ���̵�' onclick="javascript:openPopF('application/pdf','8817659');">
    		<input type='button' class='button' value='sForm' onclick="javascript:window.open('https://www.sform.co.kr/index.jsp');">
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>����ȣ</td>
                    <td width='40%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='10%'>��ȣ</td>
                    <td width='40%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>��������</td>
                    <td width='90%'>&nbsp;
                        <%if(link_table.equals("lc_rent_link")||link_table.equals("lc_rent_link_m")){%>
                        ���뿩 ��༭
                            <%if(link_type.equals("2")){%>
                            (���°�)
                            <%}else if(link_type.equals("3")){%>
                            (����)
                            <%}%>
                        <%}else if(link_table.equals("rm_rent_link")){%>
                        ����Ʈ ��༭
                        <%}else if(link_table.equals("cms_link")){%>
                        CMS �����ü ��û��
                        <%}%>                    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <%if(vt_size >0 || vt_size2 >0){%>
   		<%	int list_num = 0; 	int stat_num = 0;		%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڹ��� ���۳���</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>��������</td>
                    <td class="title" width='10%'>������</td>                    
                    <td class="title" width='25%'>�����ڸ���</td>
                    <td class="title" width='15%'>�������޴���</td>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='10%'>����</td>
                    <td class="title" width='15%'>��������</td>
                    <!-- <td class="title" width='20%'>��������</td> -->                                        
                </tr>
                <%if(vt_size > 0){ %>                
                	<% 	for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
 		%>      
                <tr>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1 %></td>
                    <td class='papy' align="center"><%=ht.get("REG_DT")%></td>					
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_NM")%></td>
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_EMAIL")%></td>
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_TEL")%></td>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>-</td>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>
                        <%if(String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") && !String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                        		<%=ht.get("DOC_STAT")%>
                        <%}else{%>
                            <%if(String.valueOf(ht.get("DOC_YN")).equals("Y")){%>����
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("U")){%>����
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("D")){%>����
                            <%}%>
                        <%}%>
                   </td>
                   <%
                   //int rowSpan = 0;
                   //if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){
                	  // rowSpan = vt_size
                   //}
                   %>
                   <%if(i==0){ %>
                   <td class='papy' align="center" rowspan='<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%><%=vt_size*2%><%}else{%><%=vt_size%><%}%>'>���Ǹ���<br>(�����Ұ�)</td>
                   <%} %>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td class='papy' align="center">����������</td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></td>                    
                </tr>
                <%		}%>
                <% 	}%>
            <%	}%>
            
            <%if(vt_size2 > 0){ %>
           		<% 	for (int i = 0 ; i < vt_size2 ; i++){
							Hashtable ht = (Hashtable)vt2.elementAt(i);
							wait_yn = "Y";
							if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") )){
							    	wait_yn = "Y";
							}
							if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_YN")).equals("D") )){
							    	wait_yn = "Y";
							}
							if((i+1)==vt_size2 && ( String.valueOf(ht.get("DOC_YN_NM")).equals("���") )){
							    	wait_yn = "Y";
							}else{
								wait_yn = "N"; //�߰������Ѵ�.
							}							
							if(String.valueOf(ht.get("DOC_YN")).equals("D")){
								wait_yn = "N"; //�߰������Ѵ�.
							}
 				%>
                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1+vt_size %></td>
                    <td align="center"><%=ht.get("REG_DT")%></td>					
                    <td align="center"><%=ht.get("CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_TEL")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%=ht.get("DOC_YN_NM")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%=ht.get("DOC_STAT")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>                                            
                        <%if(!String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                            &nbsp;<a href="javascript:link_delete('2', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[��  ��]</a>
                        <%}else{%>
                            -
                        <%}%>
                    </td>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td align="center">����������</td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></td>                    
                </tr>
                <%		}%>
                <% 	}%>
            <%}%>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڹ��� ���۳��� ���� �̷� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <!-- <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>�����Ͻ�</td>
                    <td class="title" width='30%'>����</td>                    
                    <td class="title" width='45%'>���</td> -->
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>����</td>
                    <td class="title" width='20%'>�����Ͻ�</td>
                    <td class="title" width='20%'>����</td>                    
                    <td class="title" width='35%'>���</td>
                </tr>        
     <% 	for (int i = 0 ; i < vt_size3 ; i++){
				Hashtable ht = (Hashtable)vt3.elementAt(i);  
				
				if((i+1)==vt_size3 && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){
				    //	wait_yn = "Y";
				    //	wait_cnt = 0;
				} 					
									
 		%>                               
                <tr>
                    <td class='papy' align="center"><%= i+1 %></td>
                    <td class='papy' align="center">-</td>
                    <td class='papy' align="center"><%=ht.get("REG_DATE")%></td>					
                    <td class='papy' align="center"><%=ht.get("INDEX_STATUS")%></td>
                    <td class='papy' align="center"><%=ht.get("ETC")%></td>
                </tr>
  <%		}	%>
  
     <% 	for (int i = 0 ; i < vt_size4 ; i++){
				Hashtable ht = (Hashtable)vt4.elementAt(i);  
				
				if((i+1)==vt_size4 && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){
				    	wait_yn = "Y";
				} 														
				if((i+1)==vt_size4 && String.valueOf(ht.get("TMSG_NM")).equals("���뿩��༭ ����")){
				    	wait_yn = "N";
				} 														

 		%>                               
                <tr>
                    <td align="center"><%= i+1+vt_size3 %></td>
                    <td align="center"><%=ht.get("TMSG_NM")%></td>					
                    <td align="center"><%=ht.get("REG_DATE")%></td>					
                    <td align="center"><%=ht.get("DOC_STAT")%></td>
                    <td align="center">
                        <%if(String.valueOf(ht.get("TMSG_KNCD")).equals("AC711") || String.valueOf(ht.get("TMSG_KNCD")).equals("AC713")){%>
                            <a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME")%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><%=ht.get("FILE_NAME")%></a>
                        <%}%>
                    </td>
                </tr>
     <%	}	%>        
                
                
            </table>
        </td>
    </tr>    
    <%}%>
     
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <!--������ �ٷ� ���� ����-->
    <%if(!base.getUse_yn().equals("N") && wait_yn.equals("N") && wait_cnt == 0 && alink_y_count==0){%>
    <%    if(link_type.equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ������ : <%=client.getFirm_nm()%></span></td>
	</tr>       
    <%    }else{%>    	    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
	</tr>   
    <%    }%>	 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <% // �� ������ ����, ���λ�����̰� ���� �ܵ����� ������ ��쿡�� ��������/���� �� ��༭ ���� ����(1: ��������, 2: ����)�Ͽ� ����
	          	// �°� ���� ���� ��� ���� �Ұ�. 20210422
	          if( (client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5"))
	        		 && !link_type.equals("2") ){ %>
	          <tr>
	          	<td class='title'>��༭ ����</td>
	          	<td>&nbsp;
	          		<input type="radio" id="doc_st1" name="doc_st" value="1" onchange="javascript:change_doc_st(this.value);" checked>
	          		<label for="doc_st1">����������</label>
	          		<input type="radio" id="doc_st2" name="doc_st" value="2" onchange="javascript:change_doc_st(this.value);">
	          		<label for="doc_st2">����</label>
	          	</td>
	          </tr>
	          <%} %>
	          <tr>
	            <td class='title'>������</td>
	            <td>&nbsp;
                        <select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
			    <option value="">����</option>
        		    <%if(!client.getCon_agnt_email().equals("")){%>
        		    <option value="<%=client.getCon_agnt_nm()%>||<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
        		    <%}%>
        		    <%if(!site.getAgnt_email().equals("")){%>
        		    <option value="<%=site.getAgnt_nm()%>||<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[�������ݰ�꼭] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
        		    <%}%>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("�������")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        			
        		    <%if(user_id.equals("000029")){ %>
        		    <option value="�׽�Ʈ||dev@amazoncar.co.kr||010-4602-1306">[�ӽ��׽�Ʈ]</option>
        		    <%} %>	
        		</select>	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>�̸�</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' id='mgr_nm' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='mgr_email' value='<%=mgr.getMgr_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>�̵���ȭ</td>
	            <td>&nbsp;
	              <input type='text' size='15' id='mgr_m_tel' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>����</td>
	            <td>&nbsp;
	              <input type="checkbox" name="mgr_cng" value="Y"> ���ڹ��� ������ ������ ������ڿ� ������Ʈ �Ѵ�.</td>
	          </tr>
	          <% if(vt_size2 > 0){%>
	          <tr>
	            <td class='title'>�ڵ���ü<br>��û��</td>
	            <td>&nbsp;
	              <input type="checkbox" name="cms_mail_yn" value="Y"> �ڵ���ü ��û�� ������ �߼��մϴ�.</td>
	          </tr>
	          <% }%>
            </table>
        </td>
    </tr> 
    
<!-- ���������� �߰�(20190613) -->
<%-- <%if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 
	    		<span class=style2>���� ������ : 
	    <%if(!client.getRepre_nm().equals("")){ %><%=client.getRepre_nm()%><%}else{ %><%=client.getClient_nm()%><%} %>
	    </span></td>
	</tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td class='title'>������</td>
	            <td>&nbsp;�������, �������� ������ ���������� ������ �����ɴϴ�. <br>
	            	&nbsp;�ٸ� �̸��Ϸ� �������� �Ʒ��� ���� �Է��ϰų� �������� ���������� ������ �����ϼ���.</td>                
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>�̸�</td>
	            <td width='90%'>&nbsp;
	                <%if(!client.getRepre_nm().equals("")){ %><%=client.getRepre_nm()%><%}else{ %><%=client.getClient_nm()%><%}%></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='repre_email' value='<%=client.getRepre_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'><br>
	                &nbsp;&nbsp;* �̰��� �Է��� �̸����� ���ڰ�༭ ���ۿ��� ���Ǹ�(1ȸ��) �������/�������� ���������� �̸����ּҴ� ������� �ʽ��ϴ�.
	             </td>
	          </tr>
            </table>
        </td>
    </tr>
<%} %>
    
    
    <!-- ���������� �߰� �� --> 
    <%    if(link_type.equals("2")){
    
   		//���°� Ȥ�� ���������϶� ����� ��������
		Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
		//���� ������ ��������
		car_mgrs = a_db.getCarMgrListNew(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "Y");
		mgr_size = car_mgrs.size();	    
    %>
    <tr>
        <td class=h></td>
    </tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ������ : <%=begin.get("FIRM_NM")%></span></td>
	</tr>        
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td class='title'>������</td>
	            <td>&nbsp;
                        <select name="suc_s_mail_addr"  onChange='javascript:suc_mail_addr_set();'>
			    <option value="">����</option>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("�������")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        				
        		</select>	            
	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>�̸�</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' name='suc_mgr_nm' value='<%=suc_mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='suc_mgr_email' value='<%=suc_mgr.getMgr_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>�̵���ȭ</td>
	            <td>&nbsp;
	              <input type='text' size='15' name='suc_mgr_m_tel' value='<%=suc_mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
            </table>
        </td>
    </tr>            
    <%    }%>
    <tr> 
        <td>&nbsp; 
            <%if(!link_type.equals("5")){%>* CMS�����ü ��û���� ���ڰ�༭�� ������ �������Ŀ� �ִ� �ڵ���ü��û�� ����� �Ƹ���ī ���Ϸ� �ڵ��߼۵˴ϴ�. ������ ��Źް� �����Ͻø� �˴ϴ�.<%}%>
        </td>
    </tr>
        <%	if( !( client.getClient_st().equals("1") || client.getClient_st().equals("2") ) && !client.getRepre_nm2().equals("") ){%>
    <tr>
    	<td align="right"></td>
    </tr>    
    <tr>
    	<td>
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ�� ����</span>
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td width='10%' class='title'>��ǥ��</td>
	            <td width='90%'>&nbsp;
	                <select name="client_repre_st">
	                	<option value="1">[��ǥ��] <%= client.getClient_nm()%></option>
	                	<%if(!client.getRepre_nm2().equals("")){%><option value="2">[������ǥ��] <%= client.getRepre_nm2() %></option><%} %>
	                </select>
	            </td>
	          </tr>
            </table>
        </td>
    </tr>
     <%} %>
    <tr>
        <td align="right">
		<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>		
		<%	if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1") 
				&& (client.getRepre_ssn1().equals("") || AddUtil.parseInt(client.getRepre_ssn1()) == 0 || client.getRepre_addr().equals("") || client.getRepre_email().equals("") )){%>
		* ����-���������� �����ε�. ��ǥ�� ������ϳ� �ּ�, �̸����� �����ϴ�. ����� ���ڰ�༭ �����ϼ���.
		<%	}else{%>
		<a href='javascript:link_send()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_send_econt.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<%}%>
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>   
    <%}else{%>
    <tr> 
        <td>* ���� ��� ������ �ֽ��ϴ�. </td>
    </tr>     
    <tr>
        <td align="right">
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>	    
    <tr> 
        <td>&nbsp; </td>
    </tr>   
    <tr>
    	<td><input type="checkbox" name="email_chk" value="Y"> �̸����ּ� ������</td>
    </tr>        
    <tr> 
        <td>&nbsp; </td>
    </tr>    
    <tr>         
        <td>
        	�� ���ڰ�༭�� ����Ʈ��༭ó�� ���������� �߼��մϴ�.&nbsp;&nbsp;&nbsp;
        	(&nbsp;<span class='papy' style="border: 1px solid #B2CCFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> : ���Ǹ��� ���� ���۳���. Ȯ�θ� ����, ������/����/���� �Ұ�)
        </td>
    </tr>
    <tr>
        <td>
        	<font color=red><b>�� ������ ����Ʈ���� �̸����ּҸ� �����Ͽ� �������� �� �ֽ��ϴ�. (���� ��༭ ������ ����Ǿ��� ���� �̿�)</b></font> (2019-06-24 ����)
        </td>
    </tr>
    <tr>
        <td>
        	<b>�� ���Ϲ߼��� <font color=red>��������� ������</font>�Դϴ�. ���� ����� ���������� �̸��� ��߼��Ͽ� �����Ͽ� �ֽʽÿ�.</b>
        </td>
    </tr>    
    <tr> 
        <td>�� �¶��� ���ڰ�༭�� ���� �̸����� ���� �������� ���� �� �����ϸ� �˴ϴ�. (�ֹε�Ϲ�ȣ ���ڸ� �Է� �� �������� ���� ����)</td>
    </tr>
    <tr> 
        <td>�� PDF����/�̸��� ���� > ����Ȯ�� > ���� ��ü���� �������� �� ������ ���� (���� ������Ʈ�� �α����� �ʿ� ����)����̱� ������ ��༭ ���� �� <br> 
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;���>�����ؾ� �մϴ�. ������ ���к��� ���ڰ�༭ ���>������ ������ �ֽñ� �ٶ��ϴ�.(���� �߻� ���ɼ� ����)</td>
    </tr>      
    <tr>
    	<td>
    	�� ���ڰ�༭ �������� �� '[ErrorProcess] code=5, errorMessage=��� ���� ���� tstoolkit' �޽����� ���´ٸ� PC �� ����� �缳ġ�� �ʿ��� ����Դϴ�.<br>
    	&nbsp;&nbsp;&nbsp;�ٸ� PC���� �����Ͻðų� �����ǿ��� SCORE CMP for OpenWeb�� �����ϰ� �缳ġ�� �� �ٽ� ������ �ֽñ� �ٶ��ϴ�.<br>
    	&nbsp;&nbsp;&nbsp;(�������� ������ ���� �� �ش� ����� ��ġ �ȳ� �������� �������� �Ǿ� �ֽ��ϴ�)
    	</td>
    </tr>
    <%if( (client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5"))
    		&& !link_type.equals("2")	){ %>
    <tr>
    	<td>�� ��༭ ���� �� ������ ���� �ܵ����� ����Ǵ� ������ ��ǥ�� �� �ٸ� ���(���������� ��)�� ������ �� �����ϴ�.</td>
    </tr>      
    <tr>
    	<td>�� ������ �޴��� ���� �� ���� ������ ���� ����˴ϴ�.</td>
    </tr>      
    <tr>
    	<td>�� ���ڰ�༭ ���� �߼� �� �ڵ���ü ��û�� ������ �Բ� �߼۵˴ϴ�. ��� �� ��߼� �ÿ��� �ڵ���ü ��û�� �׸��� üũ�� ��쿡�� �߼۵˴ϴ�.</td>
    </tr>      
    <%} %>
    <!-- <tr> 
        <td>�� ���Ǹ��� ���ڰ�༭ �̿빮�� : ���Ǹ��� ��°� ���� 02-2638-7224, HP 010-6652-1000</td>
    </tr> -->        
    <!-- <tr> 
        <td>�� ���� ���Ǹ��� ���ڰ�༭ �̿��ϸ鼭 ���������� ȣ�� �� ������ �߻��ϸ� ���� ��°����忡�� ���Ǹ� �ϸ� ��ȭ��� �� �������� ���� ������ �մϴ�.</td>
    </tr> -->        
    		  
</table>
</form>
<!-- </center> -->
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
