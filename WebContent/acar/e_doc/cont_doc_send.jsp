<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// �α��� ����
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

    // ��������� ����Ʈ
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();
    
    String document_st 		= request.getParameter("document_st")		== null ? "1" 	: request.getParameter("document_st");			// ���� ����. ��з�.
    String document_type 	= request.getParameter("document_type")	== null ? "" 	: request.getParameter("document_type");		// ��༭ ����
  
    String rent_mng_id		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
   	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
   	String rent_st 				= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
   	String status 				= request.getParameter("status")				== null ? "" : request.getParameter("status");
   	String client_id 			= request.getParameter("client_id")			== null ? "" : request.getParameter("client_id");
   	String car_st 				= request.getParameter("car_st")				== null ? "" : request.getParameter("car_st");
   	
   	String send_type			= request.getParameter("send_type")			== null ? "" : request.getParameter("send_type");
   	
  	//���⺻����
  	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
  	//����Ÿ����
  	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
  	//������
  	ClientBean client = al_db.getNewClient(client_id);
  	//��������
  	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
  	//��������
  	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
  	int mgr_size = car_mgrs.size();
  	//�������
  	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "�������");
 	//���°�-����������
  	CarMgrBean suc_mgr = new CarMgrBean();
 	
  	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
  	
  	//�̿밳���� & ����ȸ�� �� ���� ���� fetch(20191010)	
  	//�뿩�᰹����ȸ(���忩��)
  	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
  	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
  	
  	int overCount = 0;
    if(document_st.equals("1")){	// ��༭
	 	if(document_type.equals("2")){	// �°� ���
	 		suc_mgr = a_db.getCarMgr(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "�������");
	 	}
    
    	// ���� �߼� �� ���� ��ȸ
    	overCount = ln_db.getEDocMngOverCount(rent_l_cd, rent_mng_id, rent_st);
    }
    

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - ���ڹ��� �߼�</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.logo_area {
	height: 45px;
}
.logo_img {
	margin-left: 20px;
}
.no-drag {
	-ms-user-select: none;
	-moz-user-select: -moz-none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	user-select:none;
}
.menu_table_top {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;
}
.menu_table_top td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_top .no-drag:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	
	// ���� ���� ���� �� ó��
	function changeDocSelect(sel){
		
		// �˻� ��ư ����
		var searchArea = document.getElementsByClassName('doc-search-area');
		searchArea[0].style.display = 'inline-block';
		
		// ������ �� ����
		var fm = document.form1;
		var doc_name = sel.options[sel.selectedIndex].text
		fm.doc_name.value = doc_name;
		
		// ����Ʈ��༭ ���� �� �߼� ���п� ���� �׸� ����.
		var send_parks = document.getElementsByClassName('send_park');
		if(doc_name == '����Ʈ��༭'){
			for(var i=0; i<send_parks.length; i++){
				send_parks[i].style.display = 'inline-block';
			}
		} else {
			for(var i=0; i<send_parks.length; i++){
				send_parks[i].style.display = 'none';
			}
		}
		
	}
	
	// �˻� �˾�
	function openSearchPopup(){
		var document_st = document.getElementById('document_st').value;
		var document_type = '';
		<%if(document_st.equals("") && document_type.equals("")){%>
			document_type = document.getElementsByClassName('document_type')[document_st-1].value;
		<%} else {%>
			document_type = document.getElementsByClassName('document_type')[0].value;
		<%}%>
		
		if(document_type == '') {
			alert('������ �����ϼ���.');
			return;
		}
		
		window.open('e_doc_search.jsp?document_st='+document_st+'&document_type='+document_type, 'SEARCH', 'left=10, top=10, width=1000, height=800, scrollbars=yes, status=yes, resizable=yes')
	}
	
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
	
	//���� ���� �ּ� ����
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
	
	// ���� ������ ���� ���� �ּ� ����
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
	
	// ���� ���� ����
	function sendEDoc(){
		var fm = document.form1;
		
		var document_st = '<%=document_st%>';
		var document_type = '<%=document_type%>';
		
		// ������ �� ����
		var sel = document.querySelector('.document_type');
		fm.doc_name.value = sel.options[sel.selectedIndex].text;
		
		var send_type = fm.send_type.value;
		if(send_type == ''){
			alert('�߼� ������ ������ �ּ���.');
			return;
		}
		
		/* var sign_type = fm.sign_type.value;
		if(sign_type == ''){
			alert('���� ������ ������ �ּ���.');
			return;
		} */
		
		if(document_st == 1){	// ��༭
			
			if(document_type != 4){	// ����Ʈ ��༭ ��. �ű�, �°�, ���� ��༭
				<% if( client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1") ){%>
					alert('����༭ ������ ���� ��ǥ�� ���뺸�� ��� ��ǥ�� ���������� �ؾ� �մϴ�. ');	
					return;
				<% }%>
				
				<% if( client.getClient_st().equals("2") && client.getM_tel().equals("") ){%>
					alert('����༭ ������ ���� �޴��� ��ȣ�� �ԷµǾ�� �մϴ�. ���������� �Է��Ͻʽÿ�.');	
					return;
				<% }%>
			} else {
				<%	if(fee_rm.getCms_type().equals("")){%>
				if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
					alert('2ȸ�� û�� ����� �����Ͻʽÿ�.'); return;
				}
				<%	}%>
			}
		
			if(fm.rent_l_cd.value == ''){
				alert('��� ���� ���õ��� �ʾҽ��ϴ�.');
				return;
			}
			
			if(send_type == 'mail'){		// �߼� ���� ������ ���
				var mgr_email = fm.mgr_email.value;
			
				if( !isEmail(mgr_email) ){
					alert('�ùٸ� ���� �ּҸ� �Է��� �ּ���.');
					fm.mgr_email.focus();
					return;
				}
				if( mgr_email == "" || mgr_email == "@" ){ 
					alert("���� �ּҸ� �Է��� �ּ���.");
					fm.mgr_email.focus();
					return; 
				}
				if( mgr_email.indexOf("@") < 0 || mgr_email.indexOf(".") < 0 || get_length(mgr_email) < 5 ){ 
					alert("���� �ּҰ� ��Ȯ���� �ʽ��ϴ�.");
					fm.mgr_email.focus();
					return; 
				}
				
				//���������� ���������� �̸��� ���� �ʼ� �Է�
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
					var repre_email = fm.repre_email.value;
					
					if( repre_email == "" ){		
						alert("���� �������� �����ּҸ� �Է��� �ּ���.");
						fm.repre_email.focus();
						return;	
					}
					if( repre_email.indexOf("@") < 0 || repre_email.indexOf(".") < 0 || get_length(repre_email) < 5 ){ 	
						alert("���� �������� �����ּҰ� ��Ȯ���� �ʽ��ϴ�.");
						fm.repre_email.focus();
						return; 	
					}
				<%}%>
				
				// �°� ���
				if(document_type == 2){
					var suc_mgr_email = fm.suc_mgr_email.value;
					
					if( suc_mgr_email == ""){
						alert("���� �������� ���� �ּҸ� �Է��� �ּ���.");
						fm.suc_mgr_email.focus();
						return;	
					}
					if( suc_mgr_email.indexOf("@") < 0 || suc_mgr_email.indexOf(".") < 0 || get_length(suc_mgr_email) < 5 ){ 	
						alert("���� �������� �����ּҰ� ��Ȯ���� �ʽ��ϴ�.");
						fm.suc_mgr_email.focus();
						return; 	
					}
				}
				
			} else{		// �߼� ����: �˸��� / ����
				var mgr_m_tel = fm.mgr_m_tel.value;
				if( mgr_m_tel == '' ){
					alert('�޴��� ��ȣ�� �Է��� �ּ���.');
					fm.mgr_m_tel.focus();
					return;
				}
				
				// ���������� �ִ� ���
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
						var repre_email = fm.repre_m_tel.value;
						
						if( repre_m_tel == '' ){		
							alert("���� �������� �޴��� ��ȣ�� �Է��� �ּ���.");
							fm.repre_m_tel.focus();
							return;	
						}
				<%}%>
			
				// �°� ���
				if(document_type == 2){
					var suc_mgr_m_tel = fm.suc_mgr_m_tel.value;
					
					if( suc_mgr_m_tel == '' ){
						alert("���� �������� �޴��� ��ȣ�� �Է��� �ּ���.");
						fm.suc_mgr_m_tel.focus();
						return;	
					}
				}
			}
			
			//�̿밳�������� ����ȸ���� �� ũ�� ���ۺҰ�(20191010)
			<%	if(!fees.getFee_pay_tm().equals("")&&!fees.getCon_mon().equals("")){
						if(AddUtil.parseInt(fees.getFee_pay_tm()) > AddUtil.parseInt(fees.getCon_mon())){
			%>
							alert("����Ƚ���� �̿�Ⱓ(������)���� �� Ů�ϴ�. Ȯ�����ּ���.");
							return;
			<%		}
					}	
			%>
			
			// ���ڰ�༭ ���� �� ��ȣ+����ȣ�� 60�ڸ��� ������ ���ڰ�༭ ���� �Ұ�
			<% if((rent_l_cd+client.getFirm_nm()).length() > 60){%>
				alert('����ȣ+��ȣ�� 60�ڸ��� ������ ���ڰ�༭�� ������ �� �����ϴ�.');
				return;
			<%}%>
			
			// ���� �߼� �� ���� üũ
			var overCount = '<%=overCount%>';
			
// 			if(overCount > 0){	// ���� �߼� ���� ������ �߰� �߼����� ���ϵ���.
// 				alert('�̹� �߼۵� ��༭�� �ֽ��ϴ�.\n��߼��� ���Ͻ� ��� ���ڹ������� �޴����� �ش� �߼� ���� ��� �� �����Ͻñ� �ٶ��ϴ�.');
// 				document.getElementById('btnSendDoc').style.display = 'none';
// 				return;
// 			}
		}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}
		
		
		fm.action = 'e_doc_send_a.jsp';
		fm.submit();
	}
	
	
</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' 			name='user_id' value='<%=user_id%>' />
<input type='hidden' id='document_st' 	name='document_st' value='<%=document_st%>' />
<input type='hidden' id='rent_l_cd' 		name='rent_l_cd' value='<%=rent_l_cd%>' />
<input type='hidden' id='rent_mng_id' 	name='rent_mng_id' value='<%=rent_mng_id%>' />
<input type='hidden' id='rent_st' 			name='rent_st' value='<%=rent_st%>' />
<input type='hidden' id='client_id' 		name='client_id' value='<%=client_id%>' />
<input type='hidden' id='client_st' 		name='client_st' value='<%=client.getClient_st()%>' />
<input type='hidden' id='doc_name' 		name='doc_name' value='' />
<input type='hidden' 							name="bus_id"	value="<%=base.getBus_id()%>">  
<input type='hidden'							name="bus_st"	value="<%=base.getBus_st()%>">

<div style='margin: 0 15px; display: inline-block; '>
	<div class='e-doc-area'>
		<h2>��༭</h2>
		<div>
			<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
			<span class='style2' style='margin-right: 10px;'>���� ����:</span>
			<select style='font-size: 14px;' class='document_type' name='document_type' onchange='javascript: changeDocSelect(this);'>
				<option value=''>����</option>
				<option value='1' <%if(document_st.equals("1") && document_type.equals("1")){ %>selected<%} %>>����༭</option>
				<option value='2' <%if(document_st.equals("1") && document_type.equals("2")){ %>selected<%} %>>���°��༭</option>
				<option value='3' <%if(document_st.equals("1") && document_type.equals("3")){ %>selected<%} %>>�����༭</option>
				<option value='4' <%if(document_st.equals("1") && document_type.equals("4")){ %>selected<%} %>>����Ʈ��༭</option>
			</select>
		</div>
	</div>
</div>

<!-- �˻� ���� -->
<div class='doc-search-area' style='display: <%if(document_st.equals("")){%>none;<%} else{%>inline-block;<%}%>'>
	<input type='button' class='button' value='�˻�' onclick='javascript: openSearchPopup();'/>
</div>

<!-- �߼� ���� ���� ���� -->
<div class='send-type-area' style='margin: 10px 15px;'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>�߼� ����:</span>
	
	<input type='radio' id='send_mail' name='send_type' value='mail' <%if(send_type.equals("mail")){ %>checked<%} %>>
	<label for='send_mail'>����(PC)</label>
	
	<input type='radio' id='send_kakao' name='send_type' value='talk' <%if(client.getClient_st().equals("1")){ // ������ ���ϸ� �߼� ����.%>disabled<%} %> <%if(send_type.equals("talk")){ %>checked<%} %>>
	<label for='send_kakao'>�˸���(Mobile)</label>
	
	<input type='radio' id='send_park' class='send_park' name='send_type' value='park' style='display: <%if( !( document_st.equals("1") && document_type.equals("4") ) ){%>none;<%} else {%> inline-block;<%}%>'  <%if(send_type.equals("park")){ %>checked<%} %>>
	<label for='send_park' class='send_park' style='display: <%if( !( document_st.equals("1") && document_type.equals("4") ) ){%>none;<%} else {%> inline-block;<%}%>'>����</label>
</div>

<!-- ���� ���� ���� ����_2022.04.22 ������ ���� �� �� -->
<%-- <div class='sign-type-area' style='margin: 10px 15px; display:<%if(document_st.equals("") && document_type.equals("")){%>none;<%}%>'>
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	<span class='style2' style='margin-right: 10px;'>���� ����:</span>
	
	<input type='radio' id='not_signed' name='sign_type' value='0'
		<%if(document_st.equals("1")){	// ��༭ %>
			disabled
		<%} %>
	>
	<label for='not_signed'>���� ����</label>
	
	<input type='radio' id='certificate' name='sign_type' value='1'
		<%if(document_st.equals("1") && document_type.equals("3")){	// ���� ��༭ %>
			disabled
		<%} %>
	>
	<label for='certificate'>������</label>
	
	<input type='radio' id='signed_self' name='sign_type' value='2'
		<%if(document_st.equals("1") && document_type.equals("4")){	// ����Ʈ ��༭ %>
			disabled
		<%} %>
	>
	<label for='signed_self'>���ʼ���</label>
</div> --%>

<!-- ����/�˸��� �߼� ���� ���� -->
<div class='send-content-eara' style='margin: 20px 15px; display: <%if(document_st.equals("") || document_type.equals("")){%>none;<%}%>'>
	<div style="padding-bottom: 15px;">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px"><span class='style2'>���� ����</span>
    </div>
    <div style='margin-left: 15px;'>
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
    	<span class='style2' style='font-weight:bold; font-size: 14px;'>��ȣ(����ȣ): <%=client.getFirm_nm()%>(<%=rent_l_cd %>)</span>
    </div>
    <div style='margin-left: 15px; display: flex;'>
	    <!-- ��༭(�ű�, �°�, ����) -->
	    <%if( document_st.equals("1") ){ %>
		    <%if(!document_type.equals("4")){ %>
			<div id='rent_content' style='width: 30%;'>
				<%if(!base.getUse_yn().equals("N")){ %>
				<div id='cont_content_new'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>
			      			<%if(document_type.equals("2")){ // ���°�%>
					      		���� ������: <%=client.getFirm_nm()%>
				      		<%} else{%>
				      			����
				      		<%} %>
				      	</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>������</td>
					    		<td>&nbsp;
					    			<select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
					    				<option value=''>����</option>
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
					        		    <%}
					        			}%>	
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̸�</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_email' value='<%=mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̵���ȭ</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' size='15' maxlength='15' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>����</td>
					            <td>&nbsp;
									<input type="checkbox" name="mgr_cng" value="Y"> ���ڹ��� ������ ������ ������ڿ� ������Ʈ �Ѵ�.
								</td>
							</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){ %>
				<div id='cont_content_share' style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>
				      		���� ������: 
				      		<%if(!client.getRepre_nm().equals("")){ %>
				      			<%=client.getRepre_nm()%>
				      		<%}else{ %>
				      			<%=client.getClient_nm()%>
				      		<%} %>
				      	</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>������</td>
					    		<td>
					    			&nbsp;�������, �������� ������ ���������� ������ �����ɴϴ�.<br>
					    			&nbsp;�ٸ� �̸��Ϸ� �������� �Ʒ��� ���� �Է��ϰų� �������� ���������� ������ �����ϼ���.
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̸�</td>
					    		<td>&nbsp;
					    			<span>
					    			<%if(!client.getRepre_nm().equals("")){ %>
					    				<%=client.getRepre_nm()%>
					    			<%}else{ %>
					    				<%=client.getClient_nm()%>
					    			<%}%>
					    			</span>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='repre_email' value='<%=client.getRepre_email()%>' size='30' maxlength='20' class='text' style='IME-MODE: inactive'/>
					    			&nbsp;&nbsp;* �̰��� �Է��� �̸����� ���ڰ�༭ ���ۿ��� ���Ǹ�(1ȸ��) �������/�������� ���������� �̸����ּҴ� ������� �ʽ��ϴ�.
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̵���ȭ</td>
					    		<td>&nbsp;
					    			<input type='text' name='repre_m_tel' value='' size='15' maxlength='15' />
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<%if(document_type.equals("2")){	// �°� ��� 
					//���°� Ȥ�� ���������϶� ����� ��������
					Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
				
					//���� ������ ��������
					car_mgrs = a_db.getCarMgrListNew(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "Y");
					mgr_size = car_mgrs.size();	
				%>
				<div id='cont_content_sg' style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>���� ������: <%=begin.get("FIRM_NM")%></span>
				      	<input type='hidden' name='suc_client_st' value='<%=begin.get("CLIENT_ST") %>' />
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>������</td>
					    		<td>&nbsp;
					    			<select name="suc_s_mail_addr"  onchange='javascript:suc_mail_addr_set();'>
					    				<option value=''>����</option>
					    				<%for(int i = 0 ; i < mgr_size ; i++){
						        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
						        			if(!mgr_bean.getMgr_email().equals("")){%>
						        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("�������")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
						        		    <%}
					        			}%>	
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̸�</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_nm' value='<%=suc_mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_email' value='<%=suc_mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̵���ȭ</td>
					    		<td>&nbsp;
					    			<input type='text' name='suc_mgr_m_tel' value='<%=suc_mgr.getMgr_m_tel()%>' size='15' maxlength='15' />
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
				<% if( !( client.getClient_st().equals("1") || client.getClient_st().equals("2") ) && !client.getRepre_nm2().equals("") ){ %>
				<div style='margin-top: 15px;'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>��ǥ�� ����</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>��ǥ��</td>
					    		<td>&nbsp;
					    			<select name='client_repre_st'>
					    				<option value='1'>[��ǥ��] <%= client.getClient_nm()%></option>
					    				<%if(!client.getRepre_nm2().equals("")){%><option value="2">[������ǥ��] <%= client.getRepre_nm2() %></option><%} %>
					    			</select>
					    		</td>
					    	</tr>
					    </table>
				    </div>
				</div>
				<%} %>
			</div>
			<%} else { // ��༭(����Ʈ)%>
			<div id='month_rent_content' style='width: 30%;'>
				<%if(!base.getUse_yn().equals("N")){ %>
				<div id='cont_content_month'>
				    <div class="style2" style='margin-bottom: 5px;'>
				      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
				      	<span style='font-size: 14px;'>����</span>
				    </div>
				    <div style='background-color: #b0baec;'>
					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
					    	<tr>
					    		<td class='title' style='width: 15%;'>���۱���</td>
					    		<td>&nbsp;�����</td>
					    	</tr>
					    	<tr>
					    		<td class='title' style='width: 15%;'>2ȸ��û�����</td>
					    		<td>&nbsp;
					    		<%if(fee_rm.getCms_type().equals("card")){%>
				      				�ſ�ī��
				      				<input type='hidden' name='cms_type' 		value='card'>
			      				<%}else if(fee_rm.getCms_type().equals("cms")){%>
				      				CMS
				      				<input type='hidden' name='cms_type' 		value='cms'>
			      				<%}else{%>
				              		<input type='radio' name="cms_type" value='card' checked>
				     				�ſ�ī��
				      			  	<input type='radio' name="cms_type" value='cms'>
				      			  	CMS 
			      			  	<%}%>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title' style='width: 15%;'>������</td>
					    		<td>&nbsp;
					    			<select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
					    				<option value=''>����</option>
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
					        		    <%}
					        			}%>
					    			</select>
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̸�</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' size='15' maxlength='20' class='text' style='IME-MODE: active' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>EMAIL</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_email' value='<%=mgr.getMgr_email()%>' size='30' maxlength='30' class='text' style='IME-MODE: inactive' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>�̵���ȭ</td>
					    		<td>&nbsp;
					    			<input type='text' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' size='15' maxlength='15' class='text' />
					    		</td>
					    	</tr>
					    	<tr>
					    		<td class='title'>����</td>
					            <td>&nbsp;
									<input type="checkbox" name="mgr_cng" value="Y"> ���ڹ��� ������ ������ ������ڿ� ������Ʈ �Ѵ�.
								</td>
							</tr>
					    </table>
				    </div>
				</div>
				<%} %>
			</div>
			<%} %>
		<%} %>
		<div style='margin-left: 30px; display: flex; flex-direction: column; margin-top: 30px;'>
			<input type='button' class='button' style='font-size: 16px; padding: 10px; margin: 10px 0px;' value='����' id='btnSendDoc' onclick='javascript:sendEDoc();' />
		</div>
	</div>
</div>

</form>
</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
