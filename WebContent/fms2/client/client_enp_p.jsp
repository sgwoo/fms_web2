<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ page import="acar.client.*, acar.util.*, tax.*, acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getNewClient(client_id);
	
	//����ڵ���� �̷�
	Vector vts1 = ClientMngDb.getClientMngEnpHList(client_id);
	int vt_size1 = vts1.size();
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	Vector attach_vt = c_db.getAcarAttachFileLcScanClientMaxSeqList(client_id);		
	int attach_vt_size = attach_vt.size();		

	String rent_st 	= "";
	String file_st  = "";
	
	String upd_auth  = "";
	
	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",user_id)){
		upd_auth  = "Y";
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//��ĵ���� ����
	function view_scan_client(){
		window.open("/fms2/lc_rent/view_scan_client.jsp?client_id=<%=client_id%>", "VIEW_CLIENT_SCAN", "left=200, top=100, width=820, height=800, scrollbars=yes");		
	}
	
	function modify()
	{
		var fm = document.form1;
		if(fm.firm_nm.value == '')				{	alert('��ȣ�� �Է��Ͻʽÿ�');			return;	}
		if(fm.client_nm.value == '')				{	alert('����ڸ� �Է��Ͻʽÿ�');			return;	}
		
		//���λ����		
		if(fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){
		
			//20140807 ����������������� ���ʿ��� �ֹι�ȣ ������ �ȵ�
			if(<%=AddUtil.getDate(4)%> < 20140807){				
				if(fm.ssn1.value == '')				{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� �Է��Ͻʽÿ�');		return;	}
				if(fm.ssn2.value == '')				{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� �Է��Ͻʽÿ�');		return;	}						
				if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}				
			}else{
				if(fm.ssn1.value == '')				{	alert('��������� �Է��Ͻʽÿ�');			return;	}			
				if( (!isNum(fm.ssn1.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) )	{	alert('��������� Ȯ���Ͻʽÿ�');	return;	}
			}

			if(fm.enp_no1.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}
			if(fm.enp_no2.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}
			if(fm.enp_no3.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}			
			if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('����ڵ�Ϲ�ȣ�� Ȯ���Ͻʽÿ�');	return;	}				
			
			if(fm.bus_cdt.value == '')				{	alert('���¸� �Է��Ͻʽÿ�');			return;	}
			if(fm.bus_itm.value == '')				{	alert('���� �Է��Ͻʽÿ�');			return;	}

		//����,�����	
		}else if(fm.client_st.value == '1' || fm.client_st.value == '6'){
			
			if ( '<%=client.getFirm_type()%>' == '6' || '<%=client.getFirm_type()%>' == '7' || '<%=client.getFirm_type()%>' == '8' || '<%=client.getFirm_type()%>' == '9' || '<%=client.getFirm_type()%>' == '10' || '<%=client.getFirm_type()%>' == '11' ) {	//����,������ġ,�������ڱ��,���ο������,�񿵸�
			
			}else{
			
				if(fm.ssn1.value == '')				{	alert('���ι�ȣ�� �Է��Ͻʽÿ�');			return;	}
				if(fm.ssn2.value == '')				{	alert('���ι�ȣ�� �Է��Ͻʽÿ�');			return;	}						
				if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}
				
			}
			
			if(fm.enp_no1.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}
			if(fm.enp_no2.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}
			if(fm.enp_no3.value == '')				{	alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�');			return;	}			
			if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('����ڵ�Ϲ�ȣ�� Ȯ���Ͻʽÿ�');	return;	}				
	
			if(fm.client_st.value == '1' && fm.t_zip[1].value == '')			{	alert('������������ �Է��Ͻʽÿ�');		return;	}
			if(fm.client_st.value == '1' && fm.t_addr[1].value == '')			{	alert('������������ �Է��Ͻʽÿ�');		return;	}
			
			if(fm.bus_cdt.value == '')				{	alert('���¸� �Է��Ͻʽÿ�');			return;	}
			if(fm.bus_itm.value == '')				{	alert('���� �Է��Ͻʽÿ�');			return;	}
			
		//����
		}else if(fm.client_st.value == '2'){
		
			if(fm.ssn1.value == '')					{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� �Է��Ͻʽÿ�');		return;	}
			if(fm.ssn2.value == '')					{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� �Է��Ͻʽÿ�');		return;	}						
			if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('�ֹε�Ϲ�ȣ(���ι�ȣ)�� Ȯ���Ͻʽÿ�');	return;	}		
			
		}

		if(fm.t_zip[0].value == '')				{	alert('������ּҸ� �Է��Ͻʽÿ�');		return;	}
		if(fm.t_addr[0].value == '')				{	alert('������ּҸ� �Է��Ͻʽÿ�');		return;	}			
		
		if(fm.cng_dt.value == '')				{	alert('�������ڸ� �Է��Ͻʽÿ�');		return;	}		

		//����ڵ���� ������(���x) ���λ������ ��ǥ�� �̸� ����� üũ
		var cl_st = $("#cl_st_after option:selected").val();
		$("#cl_nm_change").val("");
		if(cl_st=='3' || cl_st=='4' || cl_st=='5'){	//���λ������ ���
			var vt_size1 = <%=vt_size1%>;
			if(vt_size1 > 0){	//����ڵ���� ��ϳ����� �̹� �ִ°��
				var cl_nm_before = $("#cl_nm_before").val();
				var cl_nm_after  = $("#cl_nm_after").val();
				if(cl_nm_before != cl_nm_after){
					$("#cl_nm_change").val("Y");
				}
			}
		}
		$("#cl_nm_change2").val("");
		if(cl_st=='1'){	//������ ���
			var vt_size1 = <%=vt_size1%>;
			if(vt_size1 > 0){	//����ڵ���� ��ϳ����� �̹� �ִ°��
				var cl_nm_before = $("#cl_nm_before").val();
				var cl_nm_after  = $("#cl_nm_after").val();
				if(cl_nm_before != cl_nm_after){
					$("#cl_nm_change2").val("Y");
				}
			}
		}
		
		//�Ϲ������� �̷°����θ� ��������
		<%if(upd_auth.equals("")){%>		
		if(fm.cng_st[1].checked == true){
			fm.cng_st[0].checked = true;
		}
		<%}%>
		
		
		if(confirm('�����Ͻðڽ��ϱ�?'))
		{			
			fm.target='i_no';
			fm.submit();
		}
		
		
		
	}


	function value_set(c_nm, c_value){
		var fm = document.form1;
		if(c_nm == 'firm_nm') 	{	fm.firm_nm.value = c_value;					}
		if(c_nm == 'client_nm') {	fm.client_nm.value = c_value;				}
		var h_value = c_value.split("|");		
		if(c_nm == 't_zip0') 	{	fm.t_zip[0].value = h_value[0];		fm.t_addr[0].value = h_value[1];			}
		if(c_nm == 't_zip1') 	{	fm.t_zip[1].value = h_value[0];		fm.t_addr[1].value = h_value[1];			}
		if(c_nm == 'bus_cdt') 	{	fm.bus_cdt.value = c_value;				}
		if(c_nm == 'bus_itm') 	{	fm.bus_itm.value = c_value;				}				
	}
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}		
//-->
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function check_jumin() {
	
    if(document.form1.client_st.value == '2'){
    
    	var chk =0;
    	var yy = document.form1.ssn1.value.substring(0,2);
    	var mm = document.form1.ssn1.value.substring(2,4);
    	var dd = document.form1.ssn1.value.substring(4,6);
    	var sex = document.form1.ssn2.value.substring(0,1);

    	// �ֹε�Ϲ�ȣ�� �ڸ����� �°� �Է��ߴ��� üũ
    	if (document.form1.ssn2.value.split(" ").join("") == "") {
        	alert ('�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.');
        	document.form1.jumin1.focus();
        	return false;
    	}
    	if (document.form1.ssn1.value.length!=6) {
        	alert ('�ֹε�Ϲ�ȣ ���ڸ��� �Է��Ͻʽÿ�');
        	document.form1.jumin1.focus();
        	return false;
    	}
    	if (document.form1.ssn2.value.length != 7 ) {
        	alert ('�ֹε�Ϲ�ȣ ���ڸ��� �Է��Ͻʽÿ�.');
        	document.form1.jumin2.focus();
        	return false;
    	}
    	if (isNaN(document.form1.ssn1.value) || isNaN(document.form1.ssn2.value)) {
        	document.form1.ssn1.value = ""
        	document.form1.ssn2.value = ""
        	alert('�ֹε�Ϲ�ȣ�� ���ڸ� �����մϴ�.');
        	return false;
    	}
    	if ((document.form1.ssn1.value.length!=6)||(mm <1||mm>12||dd<1)){
        	document.form1.ssn1.value = ""
        	alert ('�ֹε�Ϲ�ȣ ���ڸ��� �߸��Ǿ����ϴ�.');
        	document.form1.jumin1.focus();
        	return false;
    	}
    	if ('<%=client.getNationality()%>' != '2' && ((sex != 1 && sex !=2 )||(document.form1.ssn2.value.length != 7 ))){
        	document.form1.ssn2.value = ""
        	alert ('�ֹε�Ϲ�ȣ ���ڸ��� �߸��Ǿ����ϴ�.');
        	document.form1.ssn2.focus();
        	return false;
    	}

    	for (var i = 0; i <=5 ; i++) {
        	chk = chk + ((i%8+2) * parseInt(document.form1.ssn1.value.substring(i,i+1)))
    	}
    	for (var i = 6; i <=11 ; i++) {
        	chk = chk + ((i%8+2) * parseInt(document.form1.ssn2.value.substring(i-6,i-5)))
    	}

    	chk = 11 - (chk %11);
    	chk = chk % 10;

    	if (chk != document.form1.ssn2.value.substring(6,7)) {
    		if ('<%=client.getClient_st()%>' == '2' && '<%=client.getNationality()%>' == '2') {
            	alert ('���� �ʴ� �ֹε�Ϲ�ȣ�Դϴٸ� �ܱ������� ���˿����մϴ�..');
            	return true;    			
    		}else{
            	document.form1.ssn1.value = "";
            	document.form1.ssn2.value = "";
            	alert ('���� �ʴ� �ֹε�Ϲ�ȣ�Դϴ�.');
            	document.form1.ssn1.focus();
            	return false;    			
    		}
    	}

    	return true;
    	
    }else{    
    	isRegNo();    
    }
}

 function isRegNo()
 {
	 
	if ( '<%=client.getFirm_type()%>' == '6' || '<%=client.getFirm_type()%>' == '7' || '<%=client.getFirm_type()%>' == '8' || '<%=client.getFirm_type()%>' == '9' || '<%=client.getFirm_type()%>' == '10' || '<%=client.getFirm_type()%>' == '11' ) {	//����,������ġ,�������ڱ��,���ο������,�񿵸�
		return true;		
	}else{
 	
    	if(document.form1.client_st.value == '1' || document.form1.client_st.value == '6'){
 	
  			var re = /-/g;
  			sRegNo = document.form1.ssn1.value+document.form1.ssn2.value;

  			if (sRegNo.length != 13){
				alert ('���� �ʴ� ���ε�Ϲ�ȣ�Դϴ�.');
   				return false;
  			}

  			var arr_regno  = sRegNo.split("");
  			var arr_wt   = new Array(1,2,1,2,1,2,1,2,1,2,1,2);
  			var iSum_regno  = 0;
  			var iCheck_digit = 0;

  			for (i = 0; i < 12; i++){
    			iSum_regno +=  eval(arr_regno[i]) * eval(arr_wt[i]);
  			}

  			iCheck_digit = 10 - (iSum_regno % 10);

  			iCheck_digit = iCheck_digit % 10;

  			if (iCheck_digit != arr_regno[12]){
  				alert ('���� �ʴ� ���ε�Ϲ�ȣ�Դϴ�.');
    			return false;
  			}
  			
  			return true;
  	
   		}else{
    		check_jumin();
    	}  	
	}
 }
 
 	//������� ����
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=user_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470");
	}	


//-->	
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='/fms2/client/client_enp_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='seq' value='<%=vt_size1+1%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='upd_auth' value='<%=upd_auth%>'>
<input type="hidden" name="cl_nm_change" id="cl_nm_change" value="">
<input type="hidden" name="cl_nm_change2" id="cl_nm_change2" value="">


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>����ڵ���� ����</span></span> : ����ڵ���� ����</td>
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
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' class='title'>����</td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td width='10%' class='title'>�����/<br>�ֹι�ȣ/<br>������ڹ�ȣ</td>					
                    <td width='16%' class='title'>������ּ�</td>
                    <td width='16%' class='title'>����������</td>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>��������</td>
                </tr>
                <%for(int i = 0 ; i < vt_size1 ; i++){
        				Hashtable ht = (Hashtable)vts1.elementAt(i);%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_NM")%></td>
                    <td align="center"><%=ht.get("ENP_NO")%><br><%=ht.get("SSN")%><br><%=ht.get("TAXREGNO")%></td>					
                    <td>&nbsp;<%=ht.get("O_ADDR")%></td>
                    <td>&nbsp;<%=ht.get("HO_ADDR")%></td>
                    <td align="center"><%=ht.get("BUS_CDT")%></td>
                    <td align="center"><%=ht.get("BUS_ITM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%><br><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
	
	<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr>
		<td align='right'></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>		
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='12%'> ���� </td>
                    <td class='title' width='32%'>������</td>
                    <td class='title' width='4%'>�µ�</td>
                    <td class='title' width='52%'>������</td>
                </tr>
                <tr>
                    <td class='title'> ������ </td>
                    <td>&nbsp;
                      <%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");
                      	else if(client.getClient_st().equals("6")) 	out.println("�����");%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                    	<%if(!upd_auth.equals("Y")){%>
                    	�µ�
                    	<input type='hidden' name='client_st' value='<%=client.getClient_st()%>'>
                    	<%}else{%>
                      <select name='client_st' id="cl_st_after">
                        <option value='1' <%if(client.getClient_st().equals("1")) out.println("selected");%>> ���� </option>
                        <option value='2' <%if(client.getClient_st().equals("2")) out.println("selected");%>> ���� </option>
                        <option value='3' <%if(client.getClient_st().equals("3")) out.println("selected");%>> ���λ����(�Ϲݰ���) </option>
                        <option value='4' <%if(client.getClient_st().equals("4")) out.println("selected");%>> ���λ����(���̰���) </option>
                        <option value='5' <%if(client.getClient_st().equals("5")) out.println("selected");%>> ���λ����(�鼼�����)</option>
                        <option value='6' <%if(client.getClient_st().equals("6")) out.println("selected");%>> �����</option>
                      </select>
                      <%}%>
        		    </td>
                </tr>
                <tr>
                    <td class='title'>����ڹ�ȣ</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> (������ڹ�ȣ:<%=client.getTaxregno()%>)</td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' size='3' name='enp_no1' value='<%=client.getEnp_no1()%>' maxlength='3' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%> >
        			  -
        			  <input type='text' size='2' name='enp_no2' value='<%=client.getEnp_no2()%>' maxlength='2' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%>>
        			  -
        			  <input type='text' size='5' name='enp_no3' value='<%=client.getEnp_no3()%>' maxlength='5' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%>>
					  &nbsp;&nbsp;
					  (������ڹ�ȣ : <input type='text' size='4' name='taxregno' maxlength='4' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%> value='<%=client.getTaxregno()%>'>)					  
					  </td>
                </tr>
                <tr>
                    <td class='title'><%if(client.getClient_st().equals("1")){%>���ι�ȣ<%}else if(client.getClient_st().equals("2")){%>�ֹι�ȣ<%}else{%>�������<%}%></td>
                    <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' name='ssn1' maxlength='6' value='<%=client.getSsn1()%>' size='6' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%>>
        			  -
        			  <input type='text' name='ssn2' maxlength='7' value='<%=client.getSsn2()%>' size='7' <%if(!upd_auth.equals("Y")){%>readonly class='whitetext'<%}else{%>class='text'<%}%> <%if(client.getClient_st().equals("2")){%>onBlur="check_jumin()"<%}else{%>onBlur="isRegNo()"<%}%>>
					  &nbsp;&nbsp;
					  <a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                    <td class='title'>���������</td>
                    <td>&nbsp;
                    <%= client.getOpen_year()%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='10' class='text'></td>
                </tr>		
                <tr>
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;
                    <%=client.getFirm_nm()%>
					<%if(from_page.equals("/tax/tax_mng/tax_mng_sc.jsp") && !rent_l_cd.equals("")){
							Hashtable cont = a_db.getContViewCase("", rent_l_cd);%>
					&nbsp;<span class="b"><a href="javascript:view_client('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title="��೻�� ����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					&nbsp;(�������:<a href="javascript:req_fee_start_act('', '<%=client.getFirm_nm()%>�� ���� ��������Դϴ�. Ȯ�� �� ����ó�����ּ���', '<%=cont.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title='��������ڿ��� �˸�'><%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></a>)
					<%}%>
					</td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('firm_nm','<%=client.getFirm_nm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' name='firm_nm' value='<%=client.getFirm_nm()%>' size='55' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>��ǥ��</td>
                    <td>&nbsp;<input type="hidden" id="cl_nm_before" value="<%=client.getClient_nm()%>">
                    <%=client.getClient_nm()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('client_nm','<%=client.getClient_nm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='client_nm'  id="cl_nm_after" value='<%=client.getClient_nm()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>����� �ּ�</td>
                    <td>&nbsp;
                    <%if(!client.getO_addr().equals("")){%>
        				(
        			<%}%>
        			<%=client.getO_zip()%>
        			<%if(!client.getO_addr().equals("")){%>
        				)<br>&nbsp;
        			<%}%>
        			<%=client.getO_addr()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('t_zip0','<%=client.getO_zip()%>|<%=client.getO_addr()%>')"></td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.address;
									
								}
							}).open();
						}
					</script>			
					  <td colspan=>&nbsp;
						<input type="text" name='t_zip' id="t_zip" size="7" maxlength='7' value='<%=client.getO_zip()%>'>
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;&nbsp;
						<input type="text" name='t_addr' id="t_addr" size="70" value='<%=client.getO_addr()%>'>
						<!-- <textarea name='t_addr' id="t_addr" rows='2'  cols="75" ><%=client.getO_addr()%></textarea> -->
					  </td>
					<!--
                    <td>&nbsp;
                      <input type='text' name='t_zip' size='7' class='text' value='<%//=client.getO_zip()%>' readonly onClick="javascript:search_zip('0');">					  
                      <br>
        			&nbsp;
        			  <textarea name='t_addr' rows='2' cols='75' maxlenght='100'></textarea>
        			  </td>
					 -->
                </tr>
                <tr>
                    <td class='title'>����������<br>/������ּ�</td>
                    <td>&nbsp;
                    <%if(!client.getHo_addr().equals("")){%>
        				(
        			<%}%>
        			<%=client.getHo_zip()%>
        			<%if(!client.getHo_addr().equals("")){%>
        			)<br>&nbsp;
        			<%}%>
        			<%=client.getHo_addr()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('t_zip1','<%=client.getHo_zip()%>|<%=client.getHo_addr()%>')"></td>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.address;
									
								}
							}).open();
						}
					</script>			
					  <td colspan=>
						<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>��
						<input type="text" name='t_zip' id="t_zip1" size="7" maxlength='7' value='<%=client.getHo_zip()%>' >
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
						&nbsp;&nbsp;
						<input type="text" name='t_addr' id="t_addr1" size="70" value='<%=client.getHo_addr()%>'>
						<!--<textarea name='t_addr' id="t_addr1" rows='2'  cols="75" ><%=client.getHo_addr()%></textarea>-->
					  </td>

                </tr>				
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;
                    <%=client.getBus_cdt()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('bus_cdt','<%=client.getBus_cdt()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='bus_cdt' value='<%=client.getBus_cdt()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;
                    <%=client.getBus_itm()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('bus_itm','<%=client.getBus_itm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='bus_itm' value='<%=client.getBus_itm()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>��������</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;
                    <input type='text' name="cng_dt" value='<%= AddUtil.getDate()%>' size='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr>
                    <td class='title'>���汸��</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;            
        		  	<input type="radio" name="cng_st" value="Y" checked>�̷°���
                      <input type="radio" name="cng_st" value="N">��������</td>
                </tr>		
				
                <tr>
                    <td class='title'>�׿����ŷ�ó</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;  
					  <%if(client.getVen_code().equals("")){%>
					  <input type="radio" name="ven_cng_st" value="1" checked>�ڵ����
					  <%}else{%>          
        		  	  <input type="radio" name="ven_cng_st" value="2" checked>�ڵ�����
					  <%}%>
					  <%if(upd_auth.equals("Y")){%>
                      <input type="radio" name="ven_cng_st" value="3">�ŷ�ó����
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
		<td align='right'> 
		<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			<a href="javascript:modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>
		<%}%>
			&nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a>			
		</td>
	</tr>
	<%if(from_page.equals("/tax/tax_mng/tax_mng_sc.jsp")){%>		
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=7% style="font-size : 8pt;">�繫�ǹ�ȣ</td>
                    <td width=14%>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
                    <td class=title width=7% style="font-size : 8pt;">�޴�����ȣ</td>
                    <td width=10%>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
                    <td class=title width=7% style="font-size : 8pt;">���ù�ȣ</td>
                    <td width=10%>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
                    <td class=title width=7% style="font-size : 8pt;">��꼭���</td>
                    <td width=8%>&nbsp;<%=client.getCon_agnt_nm()%></td>
                    <td class=title width=7% style="font-size : 8pt;">�繫�ǹ�ȣ</td>
                    <td width=8%>&nbsp;<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%></td>
                    <td class=title width=7% style="font-size : 8pt;">�̵���ȭ</td>
                    <td width=8%>&nbsp;<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%></td>
                </tr>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%//}%>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �ֱ� ��ĵ</span>
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:view_scan_client()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_more.gif border=0 align=absmiddle></a>
		</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='6%'>����</td>
                    <td class="title" width='37%'>����</td>                    
                    <td class="title" width='30%'>���Ϻ���</td>
                    <td class="title" width='27%'>�����</td>
                </tr>
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 										
 					Hashtable ht2 = c_db.getAcarAttachFileEqual("","",AddUtil.parseInt(String.valueOf(ht.get("SEQ"))));	
 					 					
 					if(!String.valueOf(ht2.get("CONTENT_SEQ")).equals("") && String.valueOf(ht2.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(20); 						
 					}
 		%>            
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 		}
    		  	}else{ %>
                <tr>
                    <td colspan="4" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>	
</table>	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
