<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.insur.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	//�����������
	if(!base.getCar_mng_id().equals("")){		
		ins = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//��������
	}
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
		
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	// 2018.01.29
	String dept_name = c_db.getNameById(user_id, "USER_DE");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�Ǻ�����-�� ���÷���
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ //�Ƹ���ī
			tr_ip.style.display	= 'none';
			tr_ip2.style.display	= 'none';
		}else{ //��
			tr_ip.style.display	= '';
			tr_ip2.style.display	= '';
		}
	}

	
	// ÷�ܾ�����ġ ������ ���Ƴ��� ���¿��� ����� ���� �� ÷�ܾ�����ġ select box ��Ȱ��ȭ ���� ����	2018.01.30
	function before_submit(){
		$("#lkas_yn").prop("disabled", false);
		$("#ldws_yn").prop("disabled", false);
		$("#aeb_yn").prop("disabled", false);
		$("#fcw_yn").prop("disabled", false);
		$("#hook_yn").prop("disabled", false);
		$("#legal_yn").prop("disabled", false);
		$("#ev_yn").prop("disabled", false);
	}

	//����
	function update(idx){
		var fm = document.form1;
		
				if(fm.insur_per.value == ''){alert('�������-�Ǻ����ڸ� �Է��Ͻʽÿ�.');fm.insur_per.focus();return;}
				if(fm.driving_age.value == ''){alert('�������-�����ڿ����� �Է��Ͻʽÿ�.');fm.driving_age.focus();return;}
				
				<%if((base.getCar_st().equals("5") || client.getClient_st().equals("1")) && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%> 
					if(fm.com_emp_yn.value == ''){alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');fm.com_emp_yn.focus();return;}
	    			if(fm.com_emp_yn.value == 'N' && fm.others.value == ''){	alert('* ���ΰ��� ��������������Ư�� �̰��� ������ �������-��� �Է��Ͻʽÿ�.');	return; }
    			<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
					//���λ���� ������������ ���Ѿ���
    			if(fm.com_emp_yn.value == ''){alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');fm.com_emp_yn.focus();return;}
				<%}else{%>
					if(fm.com_emp_yn.value == 'Y'){alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');fm.com_emp_yn.focus();return;}
				<%}%>
				
				if(fm.gcp_kd.value == ''){alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.');fm.gcp_kd.focus();return;}
				if(fm.bacdt_kd.value == ''){alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.');fm.bacdt_kd.focus();return;}
				if(fm.canoisr_yn.value == ''){alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.');fm.canoisr_yn.focus();return;}
				if(fm.cacdt_yn.value == ''){alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.');fm.cacdt_yn.focus();return;}
				if(fm.eme_yn.value == ''){alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.');fm.eme_yn.focus();return;}
				
				if('<%=base.getCar_st()%><%=max_fee.getRent_way()%>' == '33'){//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.
					if(fm.insurant.value == '2' && fm.insur_per.value != '2'){alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');return;}
				}else{
					if(<%=fee_size%>==1 && fm.insurant.value == '2'){alert('�������� ���� �����⺻�ĸ� �����մϴ�.');return;}
				}
				
				if('<%=base.getCar_st()%>' != '2'){
					var car_ja 	= toInt(parseDigit(fm.car_ja.value));
					if(car_ja == 0){alert('�������-������å���� �Է��Ͻʽÿ�.');fm.car_ja.focus();return;}
					<%if(!base.getCar_st().equals("5")){%>
   					<%if(ej_bean.getJg_w().equals("1")){//������%>
							if(fm.car_ja.value != fm.imm_amt.value){
								if(fm.ja_reason.value == ''){alert('�������-������å�� ��������� �Է��Ͻʽÿ�.');fm.ja_reason.focus();return;}
								if(fm.rea_appr_id.value == ''){alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.');fm.rea_appr_id.focus();return;}
							}
						<%}else{%>
							if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
								if(fm.ja_reason.value == ''){ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); fm.ja_reason.focus(); return; }
								if(fm.rea_appr_id.value == ''){ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); fm.rea_appr_id.focus(); return; }
							}
						<%}%>
						if(fm.insur_per.value == '2'){
							if(fm.ip_insur.value == ''){alert('�������-�Ժ�ȸ�� �������� �Է��Ͻʽÿ�.');fm.ip_insur.focus();return;}
							if(fm.ip_agent.value == ''){alert('�������-�Ժ�ȸ�� �븮������ �Է��Ͻʽÿ�.');fm.ip_agent.focus();return;}
							if(fm.ip_dam.value == ''){alert('�������-�Ժ�ȸ�� ����ڸ��� �Է��Ͻʽÿ�.');fm.ip_dam.focus();return;}
							if(fm.ip_tel.value == ''){alert('�������-�Ժ�ȸ�� ����ó�� �Է��Ͻʽÿ�.');fm.ip_tel.focus();return;}
						}
					<%}%>
					<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
						if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';}
						if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
						if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
						if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
						if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
						if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
						if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
						if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}												
						if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
						if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}				
						if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
						if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}				
						if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
						if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
						if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
						if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'�Ǻ����� ';		}
						if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'�Ǻ����� ';		}
						if(fm.com_emp_yn.value!=fm.i_com_emp_yn.value){						fm.ins_chk5.value =	'������ ';		}
					<%}%>
				}
		
		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			if(idx == 10){
				before_submit();
			}
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
	//��������������Ư�� �̰��� ���� ó��
	function Com_emp_sac(){
		var fm = document.form1;
		var ment = '';
		if(fm.com_emp_yn.value=='Y'){
			ment = '����';
		}else if(fm.com_emp_yn.value=='N'){
			ment = '�̰���';
		}else{
			alert('��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.'); return;
		}
		fm.idx.value = 'com_emp_sac';
		<%if(client.getClient_st().equals("1")){ %>
		if(ment=='�̰���'){
			if(fm.others.value == ''){ alert('* ���� ��������������Ư�� �̰��� ������ �������-��� �Է��Ͻʽÿ�.'); return; }
			if(confirm('��������������Ư�� �̰��� ���� ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}		
		}else{
			alert('���Խ����� �ʿ�����ϴ�.');
		}    	
		<%}else{%>
		if(ment=='����'){
			if(fm.others.value == ''){ alert('* ���� ��������������Ư�� ���� ������ �������-��� �Է��Ͻʽÿ�.'); return; }
			if(confirm('���ǽŰ����ڷ� ��������������Ư�� ���� ����ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}	
		}else{
			alert('�̰��Խ����� �ʿ�����ϴ�.');	
		}		
		<%}%>
	}
	//�����̰���ϱ�
	function age_search(){
		window.open("search_age.jsp", "age_search", "left=0, top=0, width=500, height=250, status=yes, scrollbars=yes");	
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
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>

<form action='lc_b_s_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" id="user_id" value="<%=user_id%>">
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_10.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">            
  <input type='hidden' name="ins_chk5"			value="">
  <input type="hidden" name="dept_name" id="dept_name" value="<%=dept_name%>"><!-- �μ��� -->
  <input type="hidden" name="lkas_yn_org" id="lkas_yn_org" value="<%=cont_etc.getLkas_yn()%>"><!-- ������Ż ������ ���� ���� �� -->
  <input type="hidden" name="ldws_yn_org" id="ldws_yn_org" value="<%=cont_etc.getLdws_yn()%>"><!-- ������Ż ����� ���� ���� �� -->
  <input type="hidden" name="aeb_yn_org" id="aeb_yn_org" value="<%=cont_etc.getAeb_yn()%>"><!-- ������� ������ ���� ���� �� -->
  <input type="hidden" name="fcw_yn_org" id="fcw_yn_org" value="<%=cont_etc.getFcw_yn()%>"><!-- ������� ����� ���� ���� �� -->
  <input type="hidden" name="hook_yn_org" id="hook_yn_org" value="<%=cont_etc.getHook_yn()%>"><!-- ���ΰ� ���� ���� �� -->
  <input type="hidden" name="legal_yn_org" id="legal_yn_org" value="<%=cont_etc.getLegal_yn()%>"><!-- �������������(�����) ���� ���� �� -->
  <input type="hidden" name="top_cng_yn_org" id="top_cng_yn_org" value="<%=cont_etc.getTop_cng_yn()%>">
     
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;1. ���� ���Ե� ��������</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >��������</td>
                    <td width="20%">&nbsp;
                        <select name='conr_nm' disabled>
                          <option value="1" <%if(ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td>&nbsp;
                        <select name='con_f_nm' disabled>
                          <option value="1" <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;
                        <select name='i_com_emp_yn' disabled>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select></td>
                </tr>                  
                <tr>
                    <td width="13%" class=title >�����ڿ���</td>
                    <td width="20%">&nbsp;
                    <select name='age_scp' disabled>
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻� 
                            </option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻� 
                            </option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻� 
                            </option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������ 
                            </option>
							<option value=''>=�Ǻ����ڰ�=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22���̻�</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28���̻�</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35���̻�~49������</option>
                          </select></td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="15%">&nbsp;
                    <select name='vins_gcp_kd' disabled>
                            <option value='9' <%if(ins.getVins_gcp_kd().equals("9")){%>selected<%}%>>10���</option>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
                            <option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
			    <option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>							
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                          </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                    <select name='vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>							
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                            <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
                          </select></td>
                </tr>
            </table>
	    </td>		
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. ��༭�� ������ ��������</td>
	</tr>		
	<%}%>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsurant().equals("2") || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsur_per().equals("2") || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select></td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext'>
                          <option value="">����</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>�����</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>��������</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>��Ÿ</option>
                      </select>
        			</td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td>&nbsp;
                        <select name='driving_age'>
                          <option value="">����</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
					  <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>		
					  <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22���̻�</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28���̻�</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35���̻�~49������</option>			  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <%if(base.getCar_st().equals("5")){%>
                    <option value="Y" selected>����</option>
                    <%}else{ %>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                    <%} %>
                  </select>
                  <%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
                      <%//if(cont_etc.getCom_emp_sac_id().equals("")){%>
                      <a href="javascript:Com_emp_sac();"><img src=/acar/images/center/button_in_si.gif border=0 align=absmiddle></a>
                      <%//}else{%>
                      <%if(!cont_etc.getCom_emp_sac_id().equals("")){%>
                      [����]<%=c_db.getNameById(cont_etc.getCom_emp_sac_id(),"USER")%>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCom_emp_sac_dt())%>
                      <%}%>
                      <%//}%>
                  <%}%>
                  </td>                        
                </tr>
                <tr>
                    <td class=title>���ι��</td>
                    <td>&nbsp; ����(���ι��,��)</td>
                    <td class=title>�빰���</td>
                    <td class=''>&nbsp;
                        <select name='gcp_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>						  
                          <option value="9" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>10���</option>						  
                      </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;
                      <select name='canoisr_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>            </td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>              </td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>������å��</td>
                    <td>&nbsp;
        			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��</td>
                    <td class=title>�������</td>
                    <td class=''>&nbsp;
                      <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                    <td class=title >������</td>
                    <td class=''>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">			
			<a href="javascript:User_search('rea_appr_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
                        (�⺻ <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(base.getCar_st().equals("5")){%>100,000<%}else{%><%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%><%}%>' readonly>��) </td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                      <select name="air_ds_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAir_ds_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>
        				�����������
        		&nbsp; 					
        			  <select name="air_as_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAir_as_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        				�����������
        	      &nbsp; 			
                      <select name="blackbox_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        				���ڽ�        				
						<br/>
        			&nbsp; 	
                      <select name="lkas_yn" id="lkas_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			������Ż(������)	
        			&nbsp; 			
                      <select name="ldws_yn" id="ldws_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			������Ż(�����)	
        			&nbsp; 			
                      <select name="aeb_yn" id="aeb_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�������(������)	
        			&nbsp; 			
                      <select name="fcw_yn" id="fcw_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�������(�����)	
        			&nbsp; 			
                      <select name="ev_yn" id="ev_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�����ڵ���	
        			<br/>
        			&nbsp;
					  <select name="hook_yn" id="hook_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���ΰ�(Ʈ���Ϸ���)	
        			&nbsp;
					  <select name="legal_yn" id="legal_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>	
        			�������������(�����)	
        			&nbsp;
					  <select name="top_cng_yn" id="top_cng_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getTop_cng_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			ž��(��������)	
        			&nbsp;
        				<br/>
        				&nbsp;  
        				��Ÿ��ġ : 
                      <input type="text" class="text" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50"> <!-- (���ΰ� �� ��Ÿ��ġ) --> 
                      </td>
                </tr>
                <tr>
                    <td  class=title>��������<br>��&nbsp;��&nbsp;��<br>��������</td>
                    <td colspan="5">&nbsp;
                      		  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
                      		  <input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>
                      		  <%} else {%>
                      		  	<input type="hidden" name="ac_dae_yn" value="Y" >
                      		  	&nbsp;* 
                      	<%} %> 
                      		  ����������(���ػ��� ����)<br>
        			  &nbsp;
               		  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
        			  <input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>> 
        			  <%} else {%>
                      		  	<input type="hidden" name="pro_yn" value="Y" >
                      		  	&nbsp;* 
                      <%} %> 
        			  ������ �߻��� ���ó�� �������� (����� ���� ���� ��) <br>
        			  &nbsp;
        			  <%if(cont_etc.getCyc_yn().equals("Y")){%>
        			  <input type="checkbox" name="cyc_yn" 		value="Y" <%if(cont_etc.getCyc_yn().equals("Y")){%>checked<%}%>> 
                      		  �� 7,000km �Ǵ� ����û�� ��ȸ���� ���� �ǽ� <br>
        			  &nbsp;        			  
        			  <%}%>
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  ��ü�� ���񼭺�(���α�����ǰ �� �Ҹ�ǰ ��ȯ, �������� ��ȯ ��) <br>
        			  &nbsp;
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  �����������(4�ð� �̻� ������� �԰��) <br>
        			  </td>
                </tr>
                <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>�Ժ�ȸ��</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;�����  :
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='text'>
                      				&nbsp;�븮�� : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='text'>
                      				&nbsp;����� :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='text'>
                					&nbsp;����ó :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='text'>
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
              <tr id=tr_ip2 style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>��������</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;���������������
					  <select name='cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>����</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50����</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100����</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150����</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200����</option>
					  </select>
					  / (�ִ�)�ڱ�δ�� 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      ���� 
					  / (�ּ�)�ڱ�δ��  
                      <select name='cacdt_memin_amt'>
                        <option value=""   <%if(cont_etc.getCacdt_memin_amt()==0 ){%>selected<%}%>>����</option>
                        <option value="5"  <%if(cont_etc.getCacdt_memin_amt()==5 ){%>selected<%}%>>5����</option>
                        <option value="10" <%if(cont_etc.getCacdt_memin_amt()==10){%>selected<%}%>>10����</option>
                        <option value="15" <%if(cont_etc.getCacdt_memin_amt()==15){%>selected<%}%>>15����</option>
                        <option value="20" <%if(cont_etc.getCacdt_memin_amt()==20){%>selected<%}%>>20����</option>
                      </select>      
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>						
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='3' cols='90' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('10')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
	<tr>	
</table>
  
</form>
<script type="text/javascript">
$(document).ready(function(){
	<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������������",ck_acar_id)){%>
		$("#lkas_yn").css("background-color","#FFFFFF").prop("disabled", false);	// ������Ż(������) ��������
		$("#ldws_yn").css("background-color","#FFFFFF").prop("disabled", false);	// ������Ż(�����) ��������
		$("#aeb_yn").css("background-color","#FFFFFF").prop("disabled", false);	// �������(������) ��������
		$("#fcw_yn").css("background-color","#FFFFFF").prop("disabled", false);	// �������(�����) ��������
		$("#ev_yn").css("background-color","#FFFFFF").prop("disabled", false);	// �����ڵ��� ��������
		$("#hook_yn").css("background-color","#FFFFFF").prop("disabled", false);	// ���ΰ� ��������
		$("#legal_yn").css("background-color","#FFFFFF").prop("disabled", false);	// �������������(�����) ��������
	<%}%>
});
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
