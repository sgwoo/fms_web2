<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.car_register.*,acar.car_mst.*, acar.offls_pre.*, acar.secondhand.*, acar.cont.*, acar.estimate_mng.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
%>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));

	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);

	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);

	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();

	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");

	//������ȣ �̷�
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);

	String white = "white";
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);

	//��������
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(car_mng_id);

	//��������
	Hashtable res = rs_db.getCarInfo(car_mng_id);

	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();

		 //acar_attach_file list --------------------------------

	String content_code = "";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;

	//������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	var popObj = null;

	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/agent/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();
	}


	function CarRegUp(){
		var theForm = document.CarRegForm;
		if(!CheckInputField()){			return;	}
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
//		viewLayer();
		theForm.cmd.value = "u";
		theForm.action = "register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}

	function CarRegUpDisp(){
		var theForm = document.CarRegForm;
		theForm.cmd.value = "udp";
		theForm.action = "./register_frame.jsp";
		theForm.target = "d_content"
		theForm.submit();
	}

	function OpenIns(){
		var theForm = document.CarRegForm;
		var rent_mng_id = theForm.rent_mng_id.value;
		var rent_l_cd = theForm.rent_l_cd.value;
		var car_mng_id = theForm.car_mng_id.value;
		var car_no = theForm.car_no.value;
		var rpt_no = theForm.rpt_no.value;
		var firm_nm = theForm.firm_nm.value;
		var client_nm = theForm.client_nm.value;
		var imm_amt = theForm.imm_amt.value;
		var cmd = theForm.cmd.value;
		var auth_rw = theForm.auth_rw.value;
		var car_name = theForm.car_name.value;
		var SUBWIN="./register_ins_id.jsp?auth_rw=" + auth_rw
					+ "&rent_mng_id=" + rent_mng_id
					+ "&rent_l_cd=" + rent_l_cd
					+ "&car_mng_id=" + car_mng_id
					+ "&cmd=" + cmd
					+ "&car_no=" + car_no
					+ "&rpt_no=" + rpt_no
					+ "&firm_nm=" + firm_nm
					+ "&client_nm=" + client_nm
					+ "&imm_amt=" + imm_amt
					+ "&car_name=" + car_name;
		window.open(SUBWIN, "Ins", "left=100, top=50, width=820, height=570, scrollbars=no");
	}

	function FootWin(arg){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("���ȭ���� ����� �ϴ� �޴��� ����Ͻʽÿ�.");	return;	}
		if(arg == 'HIS'){			theForm.action = "register_his_id.jsp";
		}else if(arg == 'SER'){		theForm.action = "register_service_id.jsp";
		}else if(arg == 'CHA'){		theForm.action = "register_change_id.jsp";
		}else if(arg == 'ACQ'){		theForm.action = "register_acquisition_id.jsp";
		}else if(arg == 'MORT'){	theForm.action = "register_mort_id.jsp";
		}
		theForm.target = "c_foot";
		theForm.submit();
	}

	function ChangeMortDT(){
		var theForm = document.CarRegForm;
		theForm.mort_dt.value = ChangeDate(theForm.mort_dt.value);
	}

	function CheckInputField(){
		var theForm = document.CarRegForm;
		if(theForm.car_no.value==""){		alert("�ڵ���������ȣ�� �Է��Ͻʽÿ�"); theForm.car_no.focus(); return false; }
		if(theForm.car_num.value==""){		alert("�����ȣ�� �Է��Ͻʽÿ�"); theForm.car_num.focus(); return false; }
		if(theForm.init_reg_dt.value==""){	alert("���ʵ������ �Է��Ͻʽÿ�."); theForm.init_reg_dt.focus(); return false; }
		if(theForm.car_nm.value==""){		alert("������ �Է��Ͻʽÿ�."); theForm.car_nm.focus(); return false; }
		if(theForm.car_form.value==""){		alert("������ �Է��Ͻʽÿ�."); theForm.car_form.focus(); return false; }
		if(theForm.car_y_form.value==""){	alert("������ �Է��Ͻʽÿ�."); theForm.car_y_form.focus(); return false; }
		if(theForm.mot_form.value==""){		alert("������������ �Է��Ͻʽÿ�."); theForm.mot_form.focus(); return false; }
		if(theForm.dpm.value==""){  		alert("��ⷮ�� �Է��Ͻʽÿ�."); theForm.dpm.focus(); return false; }
		if(theForm.taking_p.value==""){		alert("���������� �Է��Ͻʽÿ�."); theForm.taking_p.focus(); return false; }
//		if(theForm.tire.value==""){   		alert("Ÿ�̾ �Է��Ͻʽÿ�."); theForm.tire.focus(); return; }
		if(theForm.fuel_kd.value==""){		alert("������ ������ �Է��Ͻʽÿ�."); theForm.fuel_kd.focus(); return false; }
		if(theForm.conti_rat.value==""){	alert("���� �Է��Ͻʽÿ�."); theForm.conti_rat.focus(); return false; }
//		if(theForm.maint_st_dt.value==""){	alert("�˻���ȿ�Ⱓ�� �Է��Ͻʽÿ�."); theForm.maint_st_dt.focus(); return false; }
//		if(theForm.maint_end_dt.value==""){ alert("�˻���ȿ�Ⱓ�� �Է��Ͻʽÿ�."); theForm.maint_end_dt.focus(); return false; }
//		if(theForm.car_end_dt.value==""){ 	alert("���ɸ������� �Է��Ͻʽÿ�."); theForm.car_end_dt.focus(); return false; }
//		if(theForm.test_st_dt.value==""){	alert("������ȿ�Ⱓ�� �Է��Ͻʽÿ�."); theForm.test_st_dt.focus(); return false; }
//		if(theForm.test_end_dt.value==""){	alert("������ȿ�Ⱓ�� �Է��Ͻʽÿ�."); theForm.test_end_dt.focus(); return false; }
		return true;
	}

	function hideLayer(){
//		document.all['lyrMessage'].style.visibility = 'hidden';
	}

	function viewLayer(){
//		document.all['lyrMessage'].style.visibility = 'visible';
	}

	function go_to_list(){
		parent.location='register_s_frame.jsp?st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>';
	}

	function go_to_list_cus0403(){
		parent.location='/agent/cus0403/cus0403_s_frame.jsp';
	}

	//��ĵ�� ����� ����
	function view_scanfile(path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}

	//�����̷�
	function view_sh_res_h(){
		var SUBWIN="/agent/secondhand/reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}

//-->
</script>
</head>
<body leftmargin="15">

<form action="register_null_ui.jsp" name="CarRegForm" method="POST" >
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rpt_no" value="<%=rpt_no%>">
<input type="hidden" name="firm_nm" value="<%=firm_nm%>">
<input type="hidden" name="client_nm" value="<%=client_nm%>">
<input type="hidden" name="imm_amt" value="<%=imm_amt%>">
<input type="hidden" name="car_name" value="<%=mst.getCar_name()%>">
<input type="hidden" name="reg_dt" value="<%=Util.getDate()%>">
<input type="hidden" name="reg_nm" value="<%=c_db.getNameById(user_id, "USER")%>">
<input type="hidden" name="acq_std" value="<%=cr_bean.getAcq_std()%>">
<input type="hidden" name="acq_acq" value="<%=cr_bean.getAcq_acq()%>">
<input type="hidden" name="acq_f_dt" value="<%=cr_bean.getAcq_f_dt()%>">
<input type="hidden" name="acq_ex_dt" value="<%=cr_bean.getAcq_ex_dt()%>">
<input type="hidden" name="acq_re" value="<%=cr_bean.getAcq_re()%>">
<input type="hidden" name="acq_is_p" value="<%=cr_bean.getAcq_is_p()%>">
<input type="hidden" name="acq_is_o" value="<%=cr_bean.getAcq_is_o()%>">
<input type="hidden" name="mort_st" value="<%=cr_bean.getMort_st()%>">
<input type="hidden" name="mort_dt" value="<%=cr_bean.getMort_dt()%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�ڵ��� �󼼳���</span></span></td>
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
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=13%>���ʵ����</td>
                    <td width=37%>&nbsp;
                      <input type="text" name="init_reg_dt" value="<%=cr_bean.getInit_reg_dt()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;
                    	<%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%>
                    </td>
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%>&nbsp;
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                </tr>
                <tr>
                    <td class=title>�ڵ���������ȣ</td>
                    <td>&nbsp;
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp;
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                      
                    </td>
                    <td class=title>�뵵</td>
                    <td>&nbsp;
                      <select name="car_use" disabled>
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>������</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>�ڰ���</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>����</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%>
                                    <%=mst.getCar_nm()%> <%=mst.getCar_name()%>
                                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp;
                      <%=cr_bean.getCar_form()%>
                    </td>
                    <td class=title>�𵨿���</td>
                    <td>&nbsp;
                      <%=cr_bean.getCar_y_form()%>
                    </td>                    
                </tr>
                <tr>
                    <td class=title>�����ȣ</td>
                    <td>&nbsp;
                      <%=cr_bean.getCar_num()%>
                    </td>
                    <td class=title>����������</td>
                    <td>&nbsp;
                      <%=cr_bean.getMot_form()%>
                    </td>
                    <td class=title>GPS��ġ</td>
                    <td>&nbsp;
                      <%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%>
                    </td>
                </tr>                
                <tr>
                    <td class=title>�⺻���</td>
                    <td colspan='5'>&nbsp;
                      <%=res.get("CAR_B")%>
                    </td>
                </tr>
                <tr>
                    <td class=title>���û��</td>
                    <td colspan='5'>&nbsp;
                      <%=res.get("OPT")%>
                    </td>
                </tr>
                <tr>
                    <td class=title>��������ġ</td>
                    <td colspan='3'>&nbsp;
                      <SELECT NAME="park" disabled>
						  <%for(int i = 0 ; i < good_size ; i++){
							  CodeBean good = goods[i];%>
						  <option value='<%= good.getNm_cd()%>' <%if(res.get("PARK").equals(good.getNm_cd()))%> selected<%%>><%= good.getNm()%></option>
						  <%}%>							  
        		        </SELECT>
						<%=res.get("PARK_CONT")%>
						(������ ��� ��������Ÿ)
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp;
                      <%=res.get("COLO")%>
                    </td>

                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=13%>��ⷮ</td>
                    <td width=15%>&nbsp;
                      <%=cr_bean.getDpm()%> cc </td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;
                      <%=cr_bean.getTaking_p()%> �� </td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%=cr_bean.getCar_length()%> mm </td>
                    <td class=title width=10%>�ʺ�</td>
                    <td width=15%>&nbsp; 
                      <%=cr_bean.getCar_width()%> mm </td>                       
                </tr>
                <tr>
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp;
                      <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>
                      (����: <%=cr_bean.getConti_rat()%> km/L) &nbsp; </td>
                    <td class=title>Ÿ�̾�</td>
                    <td>&nbsp;
                      <%=cr_bean.getTire()%>
                    </td>  
        			<td class=title>�ִ����緮</td>
                    <td>&nbsp;
                      <%=cr_bean.getMax_kg()%> kg
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=13%>�˻���ȿ�Ⱓ</td>
                    <td width=21%>&nbsp;
                      <%=cr_bean.getMaint_st_dt()%>
                      ~
                      <%=cr_bean.getMaint_end_dt()%></td>
                    <td class=title width=12%>�Ϲݼ�����</td>
                    <td width=21%>&nbsp;
                      <%=cr_bean.getGuar_gen_y()%> ��
                      <%=cr_bean.getGuar_gen_km()%> km </td>
                    <td class=title width=12%>����������</td>
                    <td width=21%>&nbsp;
                      <%=cr_bean.getGuar_endur_y()%> ��
                      <%=cr_bean.getGuar_endur_km()%> km </td>
                </tr>
                <tr>
                    <td class=title>���ʵ�Ϲ�ȣ</td>
                    <td>&nbsp;
                      <%=cr_bean.getFirst_car_no()%>
                    </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;
                      <%=cr_bean.getCar_end_dt()%>
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td>&nbsp;
                      <%=cr_bean.getTest_st_dt()%>
                      ~
                      <%=cr_bean.getTest_end_dt()%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ű</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td width=13% class=title>��������</td>
                    <td colspan="4" >&nbsp; <input type="radio" name="key_yn" value="Y" <%if(CarKeyBn.getKey_yn().equals("Y"))%>checked<%%>>
                      ��
                      <input type="radio" name="key_yn" value="N" <%if(CarKeyBn.getKey_yn().equals("N"))%>checked<%%>>
                      �� </td>
                </tr>
                <tr id=tr_y1 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")){%>''<%}else{%>none<%}%>">
                    <td width=13% class=title>�Ϲݺ���Ű</td>
                    <td width=20% class=title>ī�Ǻ���Ű</td>
                    <td width=20% class=title>������</td>
                    <td width=20% class=title>����ƮŰ</td>
                    <td class=title>��Ÿ(
                      <input type="text" name="key_kd5_nm" value="<%=CarKeyBn.getKey_kd5_nm()%>" size="15" class=<%=white%>text>
                      )</td>
                </tr>
                <tr id=tr_y2 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")){%>''<%}else{%>none<%}%>">
                    <td align="center"><input type="text" name="key_kd1" value="<%=CarKeyBn.getKey_kd1()%>" size="3" class=<%=white%>num>
                      ��</td>
                    <td align="center"><input type="text" name="key_kd2" value="<%=CarKeyBn.getKey_kd2()%>" size="3" class=<%=white%>num>
                      ��</td>
                    <td align="center"><input type="text" name="key_kd3" value="<%=CarKeyBn.getKey_kd3()%>" size="3" class=<%=white%>num>
                      ��</td>
                    <td align="center"><input type="text" name="key_kd4" value="<%=CarKeyBn.getKey_kd4()%>" size="3" class=<%=white%>num>
                      ��</td>
                    <td align="center"><input type="text" name="key_kd5" value="<%=CarKeyBn.getKey_kd5()%>" size="3" class=<%=white%>num>
                      ��</td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ȣ �̷�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=7%>����</td>
                    <td class=title width=13%>��������</td>
                    <td class=title width=16%>�ڵ���������ȣ</td>
                    <td class=title width=18%>����</td>
                    <td class=title width=30%>�󼼳���</td>
                    <td class=title width=16%>�������ĵ</td>
                </tr>
                <%if(ch_r.length > 0){
				for(int i=0; i<ch_r.length; i++){
			        ch_bean = ch_r[i];

			          	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				attach_vt_size = attach_vt.size();

				if(attach_vt_size > 0){

			        %>
                <tr>
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center">
                      <% if(ch_bean.getCha_cau().equals("1")){%>
                      ��뺻���� ����
                      <%}else if(ch_bean.getCha_cau().equals("2")){%>
                      �뵵����
                      <%}else if(ch_bean.getCha_cau().equals("3")){%>
                      ��Ÿ
                      <%}else if(ch_bean.getCha_cau().equals("4")){%>
                      ����
                      <%}else if(ch_bean.getCha_cau().equals("5")){%>
                      �űԵ��<%}%>
        			  </td>
                    <td bgcolor="#FFFFFF">&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                          <td align="center">
                  		<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
    						<%	}%>
    			<%}%>

		</td>
			<%}%>
                </tr>
          <%	}
	 } else{%>
                <tr>
                    <td colspan=5 align=center>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="center">
	    &nbsp;&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
