<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
	
	//����Ʈ����
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	UsersBean busid_bean 	= umd.getUsersBean(base.getBus_id());
	
	//�����ڰݰ������
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	//�� ��ȸ
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?car_st=<%=base.getCar_st()%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2_rm.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		if(fm.site_id.value == "")	{ alert("����/������ ���� �����Ͻʽÿ�."); return;}		
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			

	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?car_st=<%=base.getCar_st()%>&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//���뺸����
	function cng_input(){
		var fm = document.form1;		
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{											//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//��ǥ�̻纸��
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 		//����
			tr_client_guar.style.display = 'none';		
		}else{											//����
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
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�ּ� ��ȸ
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//�����ܰ�� �Ѿ��
	function save(){
		var fm = document.form1;
		if(fm.client_id.value == '')		{ alert('���� �����Ͻʽÿ�.'); 					return;}
		
		<%if(!ck_acar_id.equals("000029")){%>
		
		if(fm.guar_st[0].checked == true){
			if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
			if(fm.gur_ssn[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.t_addr[2].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
			if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
		}		
				
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
		

		//����Ʈ�� ������������ ���������ȣ �ʼ�
		if(fm.mgr_lic_no[0].value == '' || fm.mgr_lic_no[0].value.length < 12){
			alert('����Ʈ ������������ ���������ȣ�� �Է��Ͻʽÿ�.'); 			
			return;
		}				
		
		if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
			alert('���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.test_lic_result.value != '1'){
			alert('�����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
			return;
		}		
		//�߰������� ������ �����ʼ�
		if(fm.mgr_lic_no[4].value != ''){	
			if(fm.test_lic_result2.value == ''){
				alert('�߰������� ���������������� ��������� �� ��������� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.test_lic_result2.value != '1'){
				alert('�߰������� �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�. �����ڰ� ��������� Ȯ�����ּ���.');
				return;
			}
		}
		
		
		if(fm.mgr_nm[0].value == '' || fm.mgr_nm[0].value.length < 2){
			alert('�����̿��� ������ �Է��Ͻʽÿ�.'); 			
			return;
		}
		if(fm.mgr_m_tel[0].value == '' || fm.mgr_m_tel[0].value.length < 10){
			alert('�����̿��� �޴����� �Է��Ͻʽÿ�.'); 			
			return;
		}
		
		<%if(busid_bean.getLoan_st().equals("1")){%>
		if(fm.mng_type[0].checked == false && fm.mng_type[1].checked == false){		
			alert('��������� ��������� �����Ͻʽÿ�.'); return;			
		}
		<%}else{%>
	    <%	if(base.getRent_st().equals("3")||base.getRent_st().equals("4")){//����,����%>
	    	if(fm.mng_type[0].checked == false && fm.mng_type[1].checked == false){		
				alert('��������� ��������� �����Ͻʽÿ�.'); return;			
			}
	    <%	}%>
		<%}%>	
		
		<%}%>
		
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
  <input type='hidden' name="old_rent_mng_id" 	value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 	value="<%=old_rent_l_cd%>">

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
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[2�ܰ�]</font> ������</span></td>
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
                    <td width=20%>&nbsp;<%=rent_l_cd%> (<%=rent_mng_id%>)</td>
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
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}else if(car_gu.equals("3")){%>����Ʈ<%}%><%if(base.getReject_car().equals("Y")){%>&nbsp;(�μ��ź�����)<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("4")){%>����Ʈ<%}else if(car_st.equals("5")){%>�����뿩<%}%></b></td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
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
                    <td class='title'>�����ּ�</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="" readonly>
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="" readonly>
						&nbsp;���ּ� : <input type="text" name="t_addr_sub" size="30" >
						&nbsp;&nbsp;<span class="b"><a href="javascript:search_post('0')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					</td>

                    <td class='title'>����������</td>
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
                    <td class='title' width='13%'>����� ���������ȣ</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="">
					</td>
		            <td>&nbsp;(����,���λ����)&nbsp;�� ������� ���������ȣ�� ����</td>
                </tr>
                                  	 
                <!-- �����ڰݰ������ -->
                <tr>
                    <td class='title' rowspan='2'>�������� �����ڰݰ���</td>
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
		            <td colspan='4'>&nbsp;�� ���ΰ��� ����� ������, ���λ����/���λ���� ���� ��༭�� �����̿����� �����ڰ��� ����</td>
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
                    <td width="3%" rowspan="6" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">����</td>			
                    <td class=title width="12%">�������</td>
                    <td class=title width="15%">�ּ�</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="10%" class=title>���������ȣ</td>
                    <td width="15%" class=title>��Ÿ</td>
                    <td width="5%" class=title>��ȸ</td>
                </tr>    		    
    		<%	for(int i=0; i<=4; i++){%>
                <tr> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%if(i==0) out.println("�����̿���"); else if(i==1) out.println("����������"); else if(i==2) out.println("ȸ�������"); else if(i==3) out.println("�������"); else if(i==4) out.println("�߰��̿���");%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_nm'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		<%	} %>   
    		<!-- �����ڰݰ������ -->
                <tr>
                    <td class='title' colspan='2'>�߰������� �����ڰݰ���</td>
		            <td>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>		            
		            <td colspan='2'>&nbsp;������� : <select name='test_lic_result2'>
        		          		<option value='' <%if(base.getTest_lic_result2().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
		            <td colspan='5'>&nbsp;�� �߰������ڰ� �ִ� ��� �����ڰ��� ����</td>
                </tr>  	
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�����̿��� �ּ�</td>                    
                    <td colspan=2>&nbsp;
		                <script>
							function openDaumPostcode3() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('c_u_zip').value = data.zonecode;
										document.getElementById('c_u_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
						<input type="text" name="c_u_zip" id="c_u_zip" size="7" maxlength='7' value="">
						<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
						&nbsp;&nbsp;<input type="text" name="car_use_addr" id="c_u_addr" size="60" value="<%=cont_etc.getCar_use_addr()%>">
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
        	      <input type='radio' name="client_share_st" value='2' <%if(car_st.equals("4")){%>checked<%}%> onClick="javascript:cng_input4()">
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
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ��� ������������ �ִ� ��� �����ڰ��� ����</td>
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
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(car_st.equals("4")){%>checked<%}%>>
        				����</td>
                </tr>
                <tr id=tr_client_guar style='display:none'>
                    <td width='13%' class='title'>��������</td>
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
                    <td width='27%' class='left'>&nbsp;
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
                                <td align="center">
								<script>
									function openDaumPostcode2() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip2').value = data.zonecode;
												document.getElementById('t_addr2').value = data.address;
												
											}
										}).open();
									}
								</script>
									<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=base.getP_zip()%>">
									<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=base.getP_addr()%>">
								</td>
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
    <%if(busid_bean.getLoan_st().equals("1")){%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="mng_type" value='1'>
        				���ʿ����� ����
        			  <input type='radio' name="mng_type" value='2'>
        				�ڵ����� (�����̿����� ������ �ǿ� �������� ����) </td>
                </tr>
            </table>
        </td>
    </tr>    
    <%}else{%>
    <%	if(base.getRent_st().equals("3")||base.getRent_st().equals("4")){//����,����%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td colspan="3" align='left'>&nbsp;                    
                      <input type='radio' name="mng_type" value='3'>
        				���������
        			  <input type='radio' name="mng_type" value='2'>
        				�ڵ����� (�����̿����� ������ �ǿ� �������� ����) </td>
                </tr>
            </table>
        </td>
    </tr>     
    <%	}else{%>
    <input type="hidden" name="mng_type" value="2">
    <%	}%>
    <%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
		<td align='right'><a href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
    <%}%>	
	<tr>
	    <td></td>
	</tr>
	<%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>
    <tr>
        <td align='right'>
    	 <a href="lc_reg_step4_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp;
    	 <a href="lc_b_u_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;
    	 <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
    	  </td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
