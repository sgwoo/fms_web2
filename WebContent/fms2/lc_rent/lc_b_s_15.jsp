<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.car_office.*, card.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
			
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);	
	
	//�����ڸ���Ʈ
	Vector cop_res_vt = cop_db.getCarOffPreSeqResList(String.valueOf(cop_bean.getSeq()));
	int cop_res_vt_size = cop_res_vt.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
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
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}

	//�����Ҵ���� ��ȸ
	function search_emp(st){
		var fm = document.form1;
		var one_self = "N";
		var pur_bus_st = "";
		if(fm.one_self[0].checked == true) 	one_self 	= "Y";
		if(fm.pur_bus_st[0].checked == true) 	pur_bus_st 	= "1";
		if(fm.pur_bus_st[1].checked == true) 	pur_bus_st 	= "2";
		if(fm.pur_bus_st[2].checked == true) 	pur_bus_st 	= "4";
		window.open("search_emp.jsp?bus_id=<%=base.getBus_id()%>&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");
	}
	//�����Ҵ���� �Է����
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){fm.emp_nm[0].value = '';fm.emp_id[0].value = '';fm.car_off_nm[0].value = '';fm.car_off_id[0].value = '';fm.car_off_st[0].value = '';fm.cust_st.value = '';fm.comm_rt.value = '';fm.comm_r_rt.value = '';fm.ch_remark.value = '';fm.ch_sac_id.value = '';fm.emp_bank.value = '';fm.emp_bank_cd.value = '';fm.emp_acc_no.value = '';fm.emp_acc_nm.value = '';
		}else{fm.emp_nm[1].value = '';fm.emp_id[1].value = '';fm.car_off_nm[1].value = '';fm.car_off_st[1].value = '';fm.car_off_id[1].value = '';}
	}
	//��� �����Ҵ���ڸ� ���� �����Ҵ���� ��ó��
	function set_emp_sam(){
		var fm = document.form1;
		if(fm.emp_chk.checked == true){
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;
		}else{
			cancel_emp('DLV');
		}
	}

	//����
	function update(idx) {
		var fm = document.form1;

		if(fm.emp_id[0].value != ''){
		
			if(fm.car_gu.value == '1' && <%=base.getRent_dt()%> >= 20121220){
				if(fm.pur_bus_st[0].checked == false && fm.pur_bus_st[1].checked == false && fm.pur_bus_st[2].checked == false){
					alert('������ ��� ���������� �����Ͻʽÿ�.'); fm.pur_bus_st[0].focus(); 	return;
				}
			}		
			
			//if(fm.comm_r_rt.value == '')		{ alert('������翵�����-�������� ������������� �Է��Ͻʽÿ�.'); 	fm.comm_r_rt.focus(); 		return; }
			//if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //�ִ������������ ������������� �� Ŭ���� ����.
			//	alert('������翵�����-�������� �ִ������������ ������������� �� Ŭ�� �� �����ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.comm_rt.focus(); return;
			//}		
			
		}

		if('<%=base.getCar_gu()%>' == '1'){//����
			if(fm.one_self[0].checked == false && fm.one_self[1].checked == false){
				alert('������ ��� ������� �����Ͻʽÿ�.'); fm.one_self[0].focus(); 	return;
			}

			<%if(!base.getCar_st().equals("5")){%>
			//��Ÿ(��ü)
			if(fm.dir_pur_yn[0].checked == false){
				var con_amt 		= toInt(parseDigit(fm.con_amt.value));
				//if(fm.one_self[1].checked == true && con_amt > 0){
					//if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
					//	alert('������������ ��� ������ҿ� ������ݸ� ������ ���¸� �Է��Ͻʽÿ�.'); return;
					//}
				//}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '�����Ǹ�����'){
					alert('���� �����Ǹ������ε� Ư���� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == 'Y'){
					alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
				if(fm.dir_pur_commi_yn.value == 'N'){
					alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
			//Ư�����		
			}else{
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){ alert('������Ҹ� �Է��Ͻʽÿ�.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){ alert('Ư����� ���õǾ����� ������Ұ� �����Ǹ����� �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){ alert('Ư����� ���õǾ����� ������Ұ� �����Ǹ����� �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '�����Ǹ�����'){
					alert('���� Ư���ε� �����Ǹ����� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == '2'){
					alert('����������� �ְ� ��ü���븮������ε� Ư���Դϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
			}
				<%if(cm_bean.getCar_comp_id().equals("0001") || cm_bean.getCar_comp_id().equals("0003")){%>
					if(fm.dir_pur_yn[0].checked == true && fm.pur_bus_st[0].checked == true && fm.one_self[1].checked == true ){
						alert('�ڵ��� Ư����� : ��ü�����ε� ����������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); return;
					}
				<%}%>
				if(fm.emp_id[1].value != ''){
					if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
						
					}else{	
						if(fm.trf_st0.value == '')			{ alert('�������-������ ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st0.focus(); 		return; }
						if(fm.trf_st0.value == '1'){
							if(fm.con_bank.value == '') 	{ alert('�������-������ ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.con_bank.focus(); 		return; }
							if(fm.con_acc_no.value == '') 	{ alert('�������-������ ���¹�ȣ�� �Է��Ͻʽÿ�.'); 	fm.con_acc_no.focus(); 		return; }
							if(fm.con_acc_nm.value == '') 	{ alert('�������-������ ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.con_acc_nm.focus(); 		return; }							
						}	
						if(fm.con_est_dt.value == '') 	{ alert('�������-������ ���޿������� �Է��Ͻʽÿ�.'); 	fm.con_est_dt.focus(); 		return; }
					}	
					
					<%if(!base.getCar_gu().equals("2")){%>  
					if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
						
					}else{	
						if(fm.trf_st5.value == '')			{ alert('�ӽÿ��ຸ��� ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st5.focus(); 		return; }
						if(fm.trf_st5.value == '1'){
							if(fm.card_kind5.value == '') 	{ alert('�ӽÿ��ຸ��� ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.card_kind5.focus(); 		return; }
							if(fm.cardno5.value == '') 		{ alert('�ӽÿ��ຸ��� ���¹�ȣ�� �Է��Ͻʽÿ�.'); 		fm.cardno5.focus(); 	return; }
							if(fm.trf_cont5.value == '') 	{ alert('�ӽÿ��ຸ��� ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.trf_cont5.focus(); 		return; }
						}	
						if(fm.trf_est_dt5.value == '') 	{ alert('�ӽÿ��ຸ��� ���޿������� �Է��Ͻʽÿ�.'); 	fm.trf_est_dt5.focus(); 	return; }
					}	
					<%}%>	
				}
		  <%}%>
		}
		
		<%if(base.getCar_gu().equals("1")){%>
		
		//��������
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();
		//������������޿���
		var dlv_con_commi_yn_chk = $("input[name=dlv_con_commi_yn]").is(":checked");
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		//�Էµ� ���������ݾ�
		var dlv_con_commi_val = $("#dlv_con_commi").val();
		
		/* if (pur_bus_st_chk) {
			if (pur_bus_st_val == "2" || pur_bus_st_val == "4") {
				if (dlv_con_commi_yn_val == "N" && Number(dlv_con_commi_val) > 0) {
					alert("���������ݾ��� �ԷµǾ� ��������� ���޿��θ� �������� ���� �� �� �����ϴ�.\n��������������޿�û �޴����� �ݾ��� Ȯ�����ּ���.");
					return;
				}
			}
		} */
		<%}%>

		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}
	}


	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	
	// �����ػ� �ӽÿ��ຸ��� 2018.04.19
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
	
	//���������
	function cng_input(){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> >= 20190610){
			if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true){  // && fm.dir_pur_yn[0].checked == true
				
				if(fm.dir_pur_commi_yn.value == ''){
					if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
						fm.dir_pur_commi_yn.value = 'N';
					}else{
						fm.dir_pur_commi_yn.value = 'Y';
					}
					//��Ÿ(��ü)
					if(fm.dir_pur_yn[0].checked == false){
						fm.dir_pur_commi_yn.value = '2';
					}
				}
			}else{										
				
				fm.dir_pur_commi_yn.value = '';
			}
		}			
	}			
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>

<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_15.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="client_id"	value="<%=base.getClient_id()%>">
  <input type='hidden' name="car_st"	value="<%=base.getCar_st()%>">
  <input type='hidden' name="car_gu"	value="<%=base.getCar_gu()%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������<%}else if(base.getCar_gu().equals("2")){%>�߰�������<%}%>-�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(!base.getCar_gu().equals("0") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 		
        <td class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="3%" rowspan="6" class='title'>��<br>
     			  	��</td>
					<td class='title'>��������</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="pur_bus_st" value='1' <%if(pur.getPur_bus_st().equals("1")){%>checked<%}%>>
                  		��ü����</label>
                  		<label><input type='radio' name="pur_bus_st" value='2' <%if(pur.getPur_bus_st().equals("2")){%>checked<%}%>>
                  		�����������</label>
                   		<label><input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  		������Ʈ</label>
					</td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
	              	<td class='title'>���������<br>���޿���</td>
	              	<td colspan='5'>&nbsp;
	              		<%-- <label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() == 0){%>checked<%}%> onClick="javascript:cng_input()"> --%>
	              		<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
	              		����</label>����
	              		<%-- <label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() > 0){%>checked<%}%> onClick="javascript:cng_input()"> --%>
	              		<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
	              		����</label>
	              		<input type="hidden" id="dlv_con_commi" value="<%=emp1.getDlv_con_commi()%>">
	              		<table>
	              		   	<tr>
	              		       	<td>&nbsp;
									<select name='dir_pur_commi_yn'>
	                          			<option  value="">����</option>
	                          			<option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>Ư�����(�����̰�����)</option>
	                          			<option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>Ư�����(�����̰��Ұ���)</option>
	                          			<option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>��ü���븮�����</option>
	                        		</select>
	              		       	</td>
	              		   	</tr>
              			</table>
					</td>
				</tr>
				<tr>
                    <td width="10%" class='title'>�������</td>
                    <td width="25%" >&nbsp;
                      <input type='text' name='emp_nm' size='10' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
                      <span class="b"><a href="javascript:search_emp('BUS')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        		      <span class="b"><a href="javascript:cancel_emp('BUS')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
        		    </td>
                    <td width="10%" class='title'>��ȣ/�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�ҵ汸��</td>
                    <td >&nbsp;
                      <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3"<%}else{%>size="4"<%}%> class='whitenum' readonly>
        			  % 
        			</td>
                    <td class='title'>�����������</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3"<%}else{%>size="4"<%}%> class='whitenum' readonly>
        		      % 
        			  <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='whitenum' readonly>
        			  ��			  
        			</td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                    </td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">			
			<a href="javascript:User_search('ch_sac_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			
        	    </td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//�ű��ΰ�� �̻������ ����
																if(bank.getUse_yn().equals("N")){	 continue; }%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������-�����<%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="<%if(base.getCar_gu().equals("1")){%>5<%}else if(base.getCar_gu().equals("2")){%>5<%}%>" class='title'>��<br>
                      ��</td>			  
                <td class='title'>�����</td>
                <td>&nbsp;
				  <label><input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				��ü���</label>
        		  <label><input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				����������</label>
    			</td>
    		<td class='title'>Ư�������</td>
                <td>&nbsp;
                    <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
        				Ư��
        	    <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%> onClick="javascript:cng_input()">
        				��Ÿ(��ü)        		  
    			</td>	
    		<td class='title'>����û��</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                		  &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				����û�Ѵ�
        		  
    			</td>	
              </tr>		
                <tr>
                    <td width="10%" class='title'>�����</td>
                    <td width="25%" >&nbsp;
                      <input type='text' name='emp_nm' size='10' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                      <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
                      <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>��</font></td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){
    		  		String dlv_auth = "";
    		  		if(!nm_db.getWorkAuthUser("������ڵ��",user_id) && !nm_db.getWorkAuthUser("��ǰ�غ��Ȳ��Ͼ���",user_id)){
    		  			dlv_auth = "white";
    		  		}
    		  %>    		  
              <tr>
                <td class='title'>�����ȣ</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
                    <%if(!cop_bean.getRent_l_cd().equals("")){%>
                	<br>&nbsp;<font color=red>
                	(������� <%=cop_bean.getCom_con_no()%>
                	
                	<%	if(cop_res_vt_size>0){
                			for (int i = 0 ; i < 1 ; i++) {
								Hashtable cop_res_ht = (Hashtable)cop_res_vt.elementAt(i);
					%>
					<%=cop_res_ht.get("FIRM_NM")%><%=cop_res_ht.get("CUST_Q")%>
					<%		}
						}
					%>
					
                	)
                	</font>
                	<%}%>
    		    </td>
                <td class='title'>�������</td>
                <td>&nbsp;
                  <input type='text' name='dlv_est_dt' value='<%=pur.getDlv_est_dt()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			  &nbsp;
              	  <input type='text' size='2' name='dlv_est_h' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> value='<%=pur.getDlv_est_h()%>'>
             	   �� 
    			</td>
                <td class='title'>�������</td>
                <td>&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
              </tr>              
    		  <%}else if(base.getCar_gu().equals("2")){%>
              <tr>
                <td class='title'>�Ÿ�����</td>
                <td >&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>�Ÿűݾ�</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='trf_amt1' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>
              <tr>
                <td class='title'>��������ȣ</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>�����ȣ</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			</td>
              </tr>
    		  <%}%>
    		  <%	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && pur.getCon_bank().indexOf("����") == 0){
                		if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002") || emp2.getCar_comp_id().equals("0003")){
                			if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){
                				pur.setTrf_st0("3");
                			}else{
                   				pur.setTrf_st0("1");
                   			}	
                		}	
                	}
    		  if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
          		//20220916 �����ѽŴ�븮���� �켱 ī�� ����Ʈ ó��
         			if(emp2.getCar_off_id().equals("00588")){
          				pur.setTrf_st5("3");
         			}else{
           				pur.setTrf_st5("1");
           			}	
          	}
                %>		
    		  <tr>
                <td class='title'>����</td>
                <td colspan="5">&nbsp;
                	�ݾ� : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='con_bank'class='default'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        								  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(����������:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
        			
    			</td>															
              </tr>
              
              	  		  
    		  <%if(!base.getCar_gu().equals("2")){%>   
    		  <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
                  �ݾ� : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='card_kind5' class='default'>
                        <option value=''>����</option>                        
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCard_kind5().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
    			</td>				
              </tr>     		                              
    		  <%}%>                     
            </table>
        </td>
    </tr>
	<tr>
	    <td>* ������ҿ� ������ݸ� ������ ���¸� �Է��Ͻʽÿ�. ���θ��� ���´� ����� �� �����ϴ�.</td>
	<tr>		
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('15')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<%if(base.getCar_gu().equals("1")){%>
	// ������ �ε� �� ��������� ���޿��� �ʱ�ȭ		2017. 12. 06
	// �ʱ� �˾����� DB���� ���� �������� ������ ���� 2017. 12. 18
	document.addEventListener("DOMContentLoaded", function(){
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();					// ��������
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		
		$("#dlv_con_commi_yn_tr").hide();																	// ��������� ���޿��� -> �ʵ� �����
		if(pur_bus_st_chk){
			if(pur_bus_st_val == "1"){
			}else if(pur_bus_st_val == "2" || pur_bus_st_val == "4"){							// �������� -> �����������, ������Ʈ
				$("#dlv_con_commi_yn_tr").show();														// ��������� ���޿��� -> �ʵ� �����ֱ�
			}
		}else {		// �������� ������ �ȵ��ִ� ��� ��������� ���޿��θ� �����ش� 2017.12.18
			$("#dlv_con_commi_yn_tr").show();
		}
	});
	
	// ���������		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// ����� ����������
	$("input[name=pur_bus_st]").change(function(){ 
		if($(this).val() == "1"){							// �������� ��ü���� ���� ��
			$("#dlv_con_commi_yn_tr").hide();		// ��������� ���޿��� ����
			one_self_no.prop("disabled", false);		// ����� ���������� Ȱ��ȭ
		}else{														// �������� �����������, ������Ʈ ���� ��
			$("#dlv_con_commi_yn_tr").show();	// ��������� ���޿��� ���̱�
		}
	});
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// ����� ��ü��� ����
			one_self_no.prop("disabled", true);														// ����� ���������� ��Ȱ��ȭ
		}else{																										// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			one_self_no.prop("disabled", false);														// ����� ���������� Ȱ��ȭ
			//one_self_no.prop("checked", true);														// ����� ���������� ����		2017.12.13 ��� ����
		}
	});
<%}%>	
	
</script>
</body>
</html>
