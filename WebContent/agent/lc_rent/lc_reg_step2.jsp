<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
	
	//�����ڰݰ������
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	//���� ��ȸ
	function search_client()
	{
		var fm = document.form1;
		window.open("/agent/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
		
		//�����ʱ�ȭ
		fm.site_id.value = '';
		fm.site_nm.value = '';
	}		
	
	//���� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}	
		window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("������ ���� �����Ͻʽÿ�."); return;}
		window.open("/agent/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("������ ���� �����Ͻʽÿ�."); return;}
		if(fm.site_id.value == "")	{ alert("����/������ ���� �����Ͻʽÿ�."); return;}		
		window.open("/agent/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			


	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("������ ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//���뺸����
	function cng_input(){
		var fm = document.form1;		
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{								//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//��ǥ�̻纸��
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 			//����
			tr_client_guar.style.display = 'none';		
		}else{								//����
			tr_client_guar.style.display = '';				
		}
	}
	
	//���������� �����������
	function cng_input4(){
		if(document.form1.client_st.value == '2' && document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//����
		}else{
			tr_client_share_st_test.style.display='none';//����
		}
	}	

	//������ ��ȸ
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("������ ���� �����Ͻʽÿ�."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�������ּ� ��ȸ
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("������ ���� �����Ͻʽÿ�."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�����ܰ�� �Ѿ��
	function save(){
		var fm = document.form1;
		if(fm.client_id.value == '')		{ alert('������ �����Ͻʽÿ�.'); 					return;}
		if(fm.t_addr[0].value == '')		{ alert('�������ּҸ� Ȯ���Ͻʽÿ�.'); 				return;}
		//if(fm.t_addr_sub.value == '')		{ alert('������ ���ּҸ� Ȯ���Ͻʽÿ�.'); 			return;}
		if(fm.tax_agnt.value == '')			{ alert('�������������� Ȯ���Ͻʽÿ�.'); 			return;}
		if(fm.guar_st[0].checked == true){
			if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
			if(fm.gur_ssn[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.t_addr[2].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
			if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
			if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
		}		
		//if(fm.client_st.value == '1' && fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){		
		if(fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){		
			alert('��ǥ�̻� ���������ο��θ� �����Ͻʽÿ�.'); return;			
		}
		if(fm.client_st.value != '1'){		
			fm.client_share_st[1].checked = true;		
		}
		if(fm.client_st.value == '1' && fm.client_guar_st[1].checked == true){		
			if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('��ǥ�̻纸�� ���������� �����Ͻʽÿ�.'); 	return;}
			if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == '')	{ alert('��ǥ�̻纸�� ���� �����ڸ� �����Ͻʽÿ�.'); 	return;}
		}
		
			//20150417 ����,���λ���ڴ� ���������ȣ �ʼ�
			if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){		
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('����,���λ���ڴ� ���������ȣ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('����� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('�����̿��� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('�����̿��� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('�����̿��� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
					return;
				}
			}else if(fm.client_st.value == '1'||fm.client_st.value == '6'){	//����
				if(fm.ssn.value==""){
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('���ι�ȣ�� ���� ���������� ��쿡�� ���������ȣ�� �Է��Ͻʽÿ�.');
						return;
					}
				}
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
				alert('�߰������� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
				alert('�߰������� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
				alert('�߰��������� ���������������� Ȯ�����ּ���. �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�.');
				return;
			}
			
			
			//����&���λ���� �����ڰݰ���
			if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){	
				if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
					alert('���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.test_lic_result.value != '1'){
					alert('�����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
					return;
				}
			}
			//���� �����ڰݰ���
			if(fm.client_st.value == '1'){	
				if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
					alert('���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.test_lic_result.value != '1'){
					alert('�����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
					return;
				}
			}
			//����-���������� ����
			if(fm.client_st.value == '2' && fm.client_share_st[0].checked == true){	
				if(fm.test_lic_emp2.value == '' || fm.test_lic_rel2.value == '' || fm.test_lic_result2.value == ''){
					alert('����-���������� ���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.test_lic_result2.value != '1'){
					alert('����-���������� �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
					return;
				}
			}
			
			
		
		<%for(int i=0; i<=3; i++){%>
			if(fm.email_1[<%=i%>].value != '' && fm.email_2[<%=i%>].value != ''){
				fm.mgr_email[<%=i%>].value = fm.email_1[<%=i%>].value+'@'+fm.email_2[<%=i%>].value;
			}
		<%}%>
		
		if(fm.mgr_nm[3].value == '')	{ alert('������� ������ �Է��Ͻʽÿ�.'); 			return;}
		if(fm.mgr_tel[3].value == '' && fm.mgr_m_tel[3].value == '')	{ alert('������� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
		//if(fm.mgr_email[3].value == '' || fm.mgr_email[3].value == '@')	{ alert('������� �̸����ּҸ� �Է��Ͻʽÿ�.'); 		return;}
		
		if(fm.mgr_nm[0].value == '' || fm.mgr_nm[0].value.length < 2){
			alert('�����̿��� ������ �Է��Ͻʽÿ�.'); 			
			return;
		}
		if(fm.mgr_m_tel[0].value == '' || fm.mgr_m_tel[0].value.length < 10){
			alert('�����̿��� �޴����� �Է��Ͻʽÿ�.'); 			
			return;
		}		
		
		if(confirm('2�ܰ踦 ����Ͻðڽ��ϱ�?')){		
			fm.action='lc_reg_step2_a.jsp';
			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
		
//-->
</script> 
</head>
<body leftmargin="15">
<form action='lc_reg_step2_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan='2'>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <!--
    <tr>
        <td align='right'>&nbsp;<a href="javascript:history.go(-1);"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a></td>
    </tr>
    -->
    <tr>
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[2�ܰ�]</font> ��������</span></td>
        <td align='right'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=base.getRent_dt()%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}%></b></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<b><%String rent_way = base.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%><%if(!base.getAgent_emp_id().equals("")){%>&nbsp;(�����������:<%=c_db.getNameById(base.getAgent_emp_id(),"CAR_OFF_EMP")%>)<%}%></td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td width='50%' align='left'>&nbsp;
                      <input type='text' name="firm_nm" size='50' class='text' readonly>
        			  <input type='hidden' name='client_id' value=''>
        			  <input type='hidden' name='client_st' value=''>
        			  <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>&nbsp;
        			  <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			  </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                      <input type='text' name="client_nm" value='' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>����/����</td>
                    <td height="26" colspan="3" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value=''>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			</td>
                </tr>
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
				<tr>
				  <td class=title>�������ּ�</td>
				  <td colspan=>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' readonly>
					<input type="button" onclick="openDaumPostcode()" value="������ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" readonly>
					&nbsp;���ּ� : <input type="text" name="t_addr_sub" size="30" >
					&nbsp;&nbsp;<span class="b"><a href="javascript:search_post('0')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
				  </td>
				  <td class='title'>������������</td>
                  <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
				</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
            
                <tr id=tr_lic_no1 style="display:''">
                    <td class='title'>����� ���������ȣ</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="">
					</td>
		            <td>&nbsp;(����,���λ����)&nbsp;�� ������� ���������ȣ�� ����</td>
                </tr>
                <tr id=tr_lic_no2 style="display:''">
                    <td class='title' width='13%'>�����̿��� ���������ȣ</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;�̸� : <input type='text' name='mgr_lic_emp' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'</td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='mgr_lic_rel' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(���λ����)&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�</td>
                </tr>  
	                
                <tr id=tr_lic_no3 style="display:''">
                    <td class='title'>�߰������� ���������ȣ</td>
		            <td>&nbsp;<input type='text' name='mgr_lic_no5' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;�̸� : <input type='text' name='mgr_lic_emp5' value=''  size='10' class='text'></td>
		            <td>&nbsp;���� : <input type='text' name='mgr_lic_rel5' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;������� : <select name='mgr_lic_result5'>
        		          		<option value=''>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;�� ��༭�� "�����ڹ���" ���� �����ڸ� �߰������ڷ� ����ϴ� ��쿡�� �߰������� ���������� ����</td>
                </tr>                
    	                 
            
                <!-- �����ڰݰ������ -->
                    
                <tr>
                    <td class='title' rowspan='2' width='13%'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='test_lic_rel' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;������� : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;�� ���ΰ����� ����� ������, ���λ����/���λ���� ������ ��༭�� �����̿����� �����ڰ��� ����</td>
                </tr>      
                
                                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="3%" rowspan="7" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="8%">�ٹ�ó</td>			
                    <td class=title width="8%">�μ�</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="30%" class=title>E-MAIL</td>
                    <td width="5%" class=title>��ȸ</td>
                </tr>
    		    <%for(int i=0; i<=4; i++){%>
                <tr> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%if(i==0) out.println("�����̿���"); else if(i==1) out.println("����������"); else if(i==2) out.println("ȸ�������"); else if(i==3) out.println("�������"); else if(i==4) out.println("�߰�������");%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'>
					<input type='text' size='10' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=i%>].value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.co.kr">yahoo.co.kr</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		    <%	} %>
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
				<tr>
				  <td colspan=2 class=title>�����̿��� �ǰ����� �ּ�</td>
				  <td colspan=7>&nbsp;
					<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode1()" value="������ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="90" value="">
				  </td>
				</tr>

            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_share_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td>
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' onClick="javascript:cng_input4()">
        				�ִ�
        	      <input type='radio' name="client_share_st" value='2' onClick="javascript:cng_input4()">
        				����</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                 
                <tr>
                    <td width='13%' class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp2' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='test_lic_rel2' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;������� : <select name='test_lic_result2'>
        		          		<option value=''>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ����� ������������ �ִ� ��� �����ڰ��� ����</td>
                </tr>  
            </table>  
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_guar_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" checked>
        				�Ժ�
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()">
        				����</td>
                </tr>
                <tr id=tr_client_guar style='display:none'>
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option  value="">����</option>
                          <option value="6">��ǥ��������</option>
                          <option value="1">�ſ�������</option>
                          <option value="2">���������δ�ü</option>
                          <option value="3">�����������δ�ü</option>
                          <option value="5">�����濵��</option>
                          <option value="4">��Ÿ ����ȹ��</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			</td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸���� (��ǥ ��)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:cng_input()">
        				�Ժ�
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:cng_input()" checked>
        				����</td>
                </tr>
                <tr id=tr_guar2 style='display:none'>
                    <td height="26" colspan="4" class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>����</td>
                                <td width="10%" class=title>����</td>
                                <td width="15%" class='title'>�������</td>
                                <td width="28%" class='title'>�ּ�</td>
                                <td width="13%" class='title'>����ó</td>
                                <td width="16%" class='title'>����</td>
                                <td width="5%" class='title'>��ȸ</td>
                            </tr>
                            <%for(int i=0; i<3; i++){%>
                            <tr>
                                <td class=title>���뺸����</td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value=''></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value=''>&nbsp;<input type='text' name="t_addr" size='25' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
		<td align='right'><a href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
	    <td></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>