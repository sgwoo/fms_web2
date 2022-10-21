<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.cls.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
		
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//����
	String car_nm = c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
	//System.out.println("car name : " + car_nm);
	
	// ���ε�Ϲ�ȣ �Ǵ� �������
	String ssn = client.getSsn1();
	ssn += "-";
	if(client.getClient_st().equals("1")){
		ssn += client.getSsn2();
	}else {
		if(client.getSsn2().length() > 1){
			ssn += client.getSsn2().substring(0,1);
			ssn += "******";
		}else{
			ssn += "*******";
		}
	}
	
	// ����ڵ�Ϲ�ȣ
	String enp_no = client.getEnp_no1();
	enp_no += "-";
	enp_no += client.getEnp_no2();
	enp_no += "-";
	enp_no += client.getEnp_no3();
	if(enp_no.length()==2){
		enp_no = "";
	}
	
	// ����� �ּ� 2018.01.10
		String address = "";
		if(!client.getO_addr().equals("")){
			address += "(";
		}
		address += client.getO_zip();
		if(!client.getO_addr().equals("")){
			address += ") ";
		}
		address += client.getO_addr();
			
		// ��������
		String car_color = "";
		car_color += car.getColo();
		if(!car.getIn_col().equals("")){
			car_color += "   ";
			car_color += "(�������(��Ʈ): ";
			car_color += car.getIn_col();
			car_color += ")";
		}
		if(!car.getGarnish_col().equals("")){
			car_color += "   ";
			car_color += "(���Ͻ�: ";
			car_color += car.getGarnish_col();
			car_color += ")";
		}
		
		String rent_dt = "";			// �������
		String rent_start_dt = "";	// �̿�Ⱓ ������
		String rent_end_dt = "";	// �̿�Ⱓ ������
		
		// ������ڴ� �뿩����� �������
		rent_dt = base.getRent_dt();
		
		Vector vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 0);
		if(vt.size() < 1){
			vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 1);
		}
		
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i); 
			rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		}
		
		// �̿�Ⱓ �������� �뿩����� �뿩������
		ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(1));
		rent_start_dt = fees.getRent_start_dt();
		
		// ���°��� ��� �̿�Ⱓ �������� ���°賯¥�� ����		2018.01.11
		String rent_suc_dt = af_db.getRentSucDt(rent_mng_id, rent_l_cd);
		if(rent_suc_dt.length() > 1){
			rent_start_dt = rent_suc_dt;
		}
		
		// ��� ������ �ִ� ��� ������ �������� �뿩�����Ϸ� �̿�Ⱓ �������� ����ȴ�.
		ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		rent_end_dt = fees2.getRent_end_dt();
				
		// ���� ������ �ִ� ��� ������ ����Ϸ� �̿�Ⱓ �������� ����ȴ�.	2018.01.11
		Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
		int im_vt_size = im_vt.size();
		String im_rent_end_dt = "";
		if(im_vt_size > 0){
			Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size - 1);
			im_rent_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
			if(Integer.parseInt(im_rent_end_dt) > Integer.parseInt(rent_end_dt)){	// ���� ���� �Ⱓ �������� ��� ���� �����Ϻ��� ū ��츸 �����Ų��.
				rent_end_dt = im_rent_end_dt;
			}
		}
			
		// ���谡�Կ����� ����
		String driving_age = "";
		driving_age = base.getDriving_age();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <style type="text/css">
        .table-style-1 {
            font-family:����, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            color: #515150;
            font-weight: bold;
        }
        .table-back-1 {
            background-color: #B0BAEC
        }
        .table-body-1 {
            text-align: center;
            height: 26px;
        }
        .table-body-2 {
            text-align: left;
            padding-left: 10px;
            font-size: 10pt;
        }
        .font-1 {
            font-family:����, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            font-weight: bold;
        }
        .font-2 {
            font-family:����, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
        }
    </style>

</head>

<body leftmargin="15">

<%-- ��� --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Ȯ�μ� > <span class=style5>Ȯ�μ���¸��</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
    </table>
</div>

<%-- Ȯ�μ� ��� --%>
<div>
    <br>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">Ȯ�μ� ���</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="600" style="margin-top: 8px">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class="title" width=5%>����</td>
            <td class="title" width=35%>Ȯ�μ�</td>
            <td class="title" width=10%>����</td>
            <!-- <td colspan="3" class="title" width=50%>�ֱ�����̷�</td> -->
        </tr>
        <!-- <tr>
            <td class="title" width=15%>�Ͻ�</td>
            <td class="title" width=25%>�����</td>
            <td class="title" width=10%>�̷º���</td>
        </tr> -->
        
        <tr class="table-body-1">
        	<td>1</td>
        	<td>�ڱ���������Ȯ�μ�</td>
        	<td><button class="button" name="print1" id="print1" onclick="confirmTemplate('1')">���</button>&nbsp;
        	    <button class="button" name="mail1" id="mail1" onclick="confirmEmail('1')">����</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>
        
        <tr class="table-body-1">
        	<td>2</td>
        	<td>
        		�ڵ��� �뿩�̿� ����� Ȯ�μ� &nbsp;
        		<!-- �뿩��/������ ǥ�ÿ��� ����(20191105) -->
        		(�뿩��/������<input type="radio" name="view_amt" value="N" checked>��ǥ��<input type="radio" name="view_amt" value="Y">ǥ��)
        	</td>
        	<td><button class="button" name="print2" id="print2" onclick="confirmTemplate('2')">���</button>&nbsp;
        	    <button class="button" name="mail2" id="mail2" onclick="confirmEmail('2')">����</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>

    </table>
</div>

<form name="printForm" method="post">
	<input type="hidden" name="use_yn" id="use_yn" value="<%=base.getUse_yn()%>"><!-- ����(����, ����...) -->
	<input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">	<!-- ȸ��� -->
	<input type="hidden" name="client_nm" value="<%=client.getClient_nm()%>"><!-- ���� -->
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">					<!-- ����ȣ -->
	<input type="hidden" name="car_no" value="<%=cr_bean.getCar_no()%>">	<!-- ������ȣ -->
	<input type="hidden" name="car_nm" value="<%=car_nm%>">						<!-- ���� -->
	<input type="hidden" name="ssn" value="<%=ssn%>">									<!-- ���ε�Ϲ�ȣ �Ǵ� ������� -->
	<input type="hidden" name="enp_no" value="<%=enp_no%>">						<!-- ����ڵ�Ϲ�ȣ -->
	<input type="hidden" name="address" value="<%=address%>">						<!-- �ּ� -->
	<input type="hidden" name="rent_dt" value="<%=rent_dt%>">						<!-- ������� -->
	<input type="hidden" name="car_color" value="<%=car_color%>">					<!-- �������� -->
	<input type="hidden" name="rent_start_dt" value="<%=rent_start_dt%>">		<!-- �̿�Ⱓ ������ -->
	<input type="hidden" name="rent_end_dt" value="<%=rent_end_dt%>">			<!-- �̿�Ⱓ ������ -->
	<input type="hidden" name="driving_age" value="<%=driving_age%>">			<!-- ���谡�Կ����� ���� -->
	<input type="hidden" name="fee_amt" value="<%=fees2.getFee_s_amt()+fees2.getFee_v_amt()%>"><!-- �ű�/n������ �뿩��-->
	<input type="hidden" name="grt_amt" value="<%=fees2.getGrt_amt_s()%>">	<!-- �ű�/n������ ������ -->
</form>

</body>
<script>
	//������ ������ ��� �ڵ��� �뿩�̿� ����� Ȯ�μ� ��Ȱ��ȭ		2018.01.11
	$(document).ready(function(){
		if($("#use_yn").val()=="N"){
			$("#print2").hide();
		}
	});

	function confirmEmail(type){
		var url = "about:blank";
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width=900, height=700, scrollbars=yes");
		
		var view_amt = $("input[name='view_amt']:checked").val();
		var pay_way = '';
		
		var frmData = document.printForm;
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.action = "/fms2/lc_rent/select_mail_input_rent_docs.jsp?type="+type+"&view_amt="+view_amt+'&pay_way='+pay_way;
		frmData.submit();
	}	
	
	function confirmTemplate(type){
		var url = "./lc_c_h_confirm_template.jsp?type="+type+"&view_amt="+view_amt;
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width=900, height=700, scrollbars=yes");
		var view_amt = $("input[name='view_amt']:checked").val();
		
		var frmData = document.printForm;
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.action = "./lc_c_h_confirm_template.jsp?type="+type+"&view_amt="+view_amt;
		frmData.submit();
	}
</script>
</html>