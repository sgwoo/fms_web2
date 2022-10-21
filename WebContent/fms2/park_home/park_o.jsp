<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*,acar.user_mng.*,acar.parking.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String cnt = request.getParameter("cnt")==null?"":request.getParameter("cnt");

	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd = request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");

	String deli_dt = request.getParameter("deli_dt")==null?"":request.getParameter("deli_dt");

	String pr[]  = request.getParameterValues("pr");


	int vid_size = pr.length;

	String car_st="";  //2:������, 1,3:������, 4:����
	String park	="";
	String c_id	="";
	String c_no = "";
	String c_nm = "";
	String s_cd	="";
	String d_dt ="";
	String init_reg_dt ="";

	for(int i=0; i < vid_size; i++){
		String[] value = pr[i].toString().split("\\^");
		car_st		= value[0];
		park		= value[1];
		c_id		= value[2];
		c_no		= value[3];
		c_nm		= value[4];
		s_cd		= value[5];
		d_dt		= value[6];
		init_reg_dt		= value[7];
	}

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_id = u_bean.getBr_id();

	Vector vt = pk_db.CarBasicInfo(c_id);
	int vt_size = vt.size();

	String mng_id	= request.getParameter("mng_id")==null?"":request.getParameter("mng_id");

	//����ý��ۿ��� �Ƿ��� ���� ��������
	if ( mng_id.equals("") ) {

	    if ( car_st.equals("2") ) {
	    		mng_id = pk_db.GetRentContMngId(s_cd);  //������
	    } else {
	    		mng_id =  pk_db.CarBasicMngId(c_id); //������
	    }
	}

	int i = 0;
	int j = 0;

	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "B_M_EMP");
	int user_size = users.size();

	//������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	//������ ����
	CodeBean[] drivers = c_db.getCodeAll("0048");
	int drivers_size = drivers.length;
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
<!--
$(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
	
	var fm = document.form1;
	fm.init_reg_dt.value = '<%= init_reg_dt%>';
});

function save(){
	var fm = document.form1;

	if(fm.car_no.value == '')				{	alert('������ȣ�� �Է��Ͻʽÿ�');	fm.car_no.focus(); 		return;	}
	else if(fm.car_nm.value == '')			{	alert('������ �Է��Ͻʽÿ�');		fm.car_nm.focus(); 		return;	}
	else if(fm.users_comp.value == '')		{	alert('����ڸ� �����Ͻʽÿ�');		fm.users_comp.focus(); 	return;	}
	else if(fm.driver_nm.value == '')		{	alert('�����ڸ� �����Ͻʽÿ�');		fm.driver_nm.focus(); 	return;	}
	else if(fm.park_id.value == '')			{	alert('�����带 �����Ͻʽÿ�');		fm.park_id.focus(); 	return;	}
	else if((fm.driver_nm.value == 'M'||fm.driver_nm.value == 'AT')&&fm.park.value == '')			{	alert('�����ġ�� �����Ͻʽÿ�');		fm.park.focus(); 	return;	}
	
	if((fm.car_km.value == '' || Number(fm.car_km.value ) < 1) && fm.car_key_cau.value == '') {	
		alert('����Ÿ��� ���� ������ �ۼ��Ͻʽÿ�');		
		fm.car_key_cau.focus(); 	return;	
	}
	
	fm.target="i_no";
	fm.action = 'park_o_a.jsp';
	fm.submit();
}

//������������ ������ ���� ����ȭ
function parkAreaSetting(){
	var area_type1 = "";
	var area_type2 = "";
	area_type1 += '<option value=""selected>����</option>		<OPTION VALUE="A" >A����</option>' +
				  '<OPTION VALUE="B" >B����</option>			<OPTION VALUE="C" >C����</option>' +
				  '<OPTION VALUE="D" >D����</option>			<OPTION VALUE="E" >E����</option>' +
				  '<OPTION VALUE="F" >F����</option>			<OPTION VALUE="G" >G����</option>' +
				  '<OPTION VALUE="H" >H����</option>';
    area_type2 += '<option value=""selected>����</option>		<OPTION VALUE="3A" >3��A����</option>' +
  				  '<OPTION VALUE="3B" >3��B����</option>		<OPTION VALUE="3C" >3��C����</option>' +
	  			  '<OPTION VALUE="4A" >4��A����</option>		<OPTION VALUE="4B" >4��B����</option>' +
				  '<OPTION VALUE="4C" >4��C����</option>		<OPTION VALUE="5A" >5��A����</option>' +
				  '<OPTION VALUE="5B" >5��B����</option>		<OPTION VALUE="5C" >5��C����</option>' +
				  '<OPTION VALUE="F" >F����</option>			<OPTION VALUE="G" >G����</option>' +		
				  '<OPTION VALUE="H" >H����</option>';
				  
	if($("#park_id").val()=="1"){	$("#area").html(area_type2);	}
	else{							$("#area").html(area_type1);	}
	
}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<input type='hidden' name='car_mng_id' value='<%=c_id%>'>
<input type='hidden' name='rent_s_cd' value='<%=s_cd%>'>
<input type='hidden' name='d_dt' value='<%=AddUtil.substring(d_dt,0,8)%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>">
<input type="hidden" name="io_gubun" value="2">
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type="hidden" name="init_reg_dt" value='<%=init_reg_dt%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �ڵ������� > �������� > <span class=style5>��� ���</span></span></td>
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
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">

				<tr>
					<td class=title width=10% >������ȣ</td>
					<td width='20%'>&nbsp;<input type='text' name="car_no" value='<%=c_no%>' size='30' class='text' style="ime-mode:active;" ></td>
					<td class=title width=10%>����</td>
					<td  colspan="" width=20%>&nbsp;<input type="text" name="car_nm" value="<%=c_nm%>" size="30" maxlength='50' class='text'></td>
					<td class=title width=10%>����Ÿ�</td>
					<td width=20%>&nbsp;<input type='text' name="car_km" size='20' value="" class='num'>(km)</td>

				</tr>
				<tr>
					<td class=title width=10%>����Ͻ�</td>
					<td colspan="" width=20%>&nbsp;<input type="text" name="io_dt" value="<%=AddUtil.getTimeYMDHMS()%>" size="30" maxlength='10' class='text'></td>
					<td class=title width=10%>�����</td>
					<td  colspan="" width=20%>&nbsp;<input type='text' name="park_mng" size='30' class='text' value='<%=user_nm%>'></td>
					<td class='title' width=10% >������</td>
					<td width=20%>&nbsp;
						<SELECT NAME="park_id" id="park_id">
							<%for(int k = 0 ; k < good_size ; k++){
								CodeBean good = goods[k];
								if(park.equals(good.getNm())){
								%>
							<option value='<%= good.getNm_cd()%>' selected><%= good.getNm()%></option>
							<%}}%>
										
						</SELECT>
						&nbsp;&nbsp;<SELECT NAME="area" id="area">
							<option value=""selected>����</option>
							<OPTION VALUE="A" >A</option>
							<OPTION VALUE="B" >B</option>
							<OPTION VALUE="C" >C</option>
							<OPTION VALUE="D" >D</option>
							<OPTION VALUE="E" >E</option>
							<OPTION VALUE="F" >F</option>
							<OPTION VALUE="G" >G</option>
							<OPTION VALUE="H" >H</option>
							<OPTION VALUE="I" >I</option>
							<OPTION VALUE="J" >J</option>
							<OPTION VALUE="K" >K</option>
							<OPTION VALUE="L" >L</option>
							<OPTION VALUE="M" >M</option>
							<OPTION VALUE="N" >N</option>
						</SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�����</td>
					<td width='20%'>&nbsp;<select name='users_comp'>
							<option value="">����ڼ���</option>
							<option value="�˼�����">�˼�����</option>
							<%	if(user_size > 0){
									for(int k = 0 ; k < user_size ; k++){
										Hashtable user = (Hashtable)users.elementAt(k); %>
							<option value='<%=user.get("USER_NM")%>' <%if(mng_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						</select>
					</td>
					<td class=title width=10%>����������</td>
					<td width=20%>&nbsp;<SELECT NAME="driver_nm" >
				 			<option value="">����ڼ���</option>
						<!--	<OPTION VALUE="S" selected>����</option>
							<OPTION VALUE="C">��</option>
							<OPTION VALUE="T">Ź�۾�ü</option>
							<OPTION VALUE="M">����������</option>
							<OPTION VALUE="H">�������������</option>
							<OPTION VALUE="D">�β��������</option>
							<OPTION VALUE="G1">����</option>
							<OPTION VALUE="BK">�ΰ������</option>
							<OPTION VALUE="G2">�ö���Ŭ��</option>
							<OPTION VALUE="AT">����ũ��</option>
							<OPTION VALUE="HD">����ī��ũ</option>
							<OPTION VALUE="DA">�ٿȹ�</option>
							<OPTION VALUE="1K">������ȣ</option>
							<OPTION VALUE="BD">�����ڵ���</option>
							<OPTION VALUE="TW">Ÿ�̾���Ÿ��</option>
							<OPTION VALUE="NO">�˼�����</option> -->
							<%for(int k = 0 ; k < drivers_size ; k++){
											CodeBean driver = drivers[k];
											if(driver.getUse_yn().equals("Y")){
												if(driver.getNm_cd().equals("S")){
											%>
											<option value='<%= driver.getNm_cd()%>' selected><%= driver.getNm()%></option>
											<%		
												}else{
											%>
											<option value='<%= driver.getNm_cd()%>'><%= driver.getNm()%></option>
											<%
												}
											%>
										<%}}%>
						</SELECT>
					</td>
					<td class=title width=10%>�����ġ</td>
					<td class= width=30% colspan="">&nbsp;
						<SELECT NAME="park" >
							<option value="0">���μ�</option>							
							
							<%for(int k = 0 ; k < good_size ; k++){
								CodeBean good = goods[k];
								if (!good.getNm_cd().equals("6")) {
							%>
							<option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>
							<%
								}
								}
							%>
							<option value="000502">����۷κ�(��)-��ȭ</option>
							<option value="013011">����۷κ�(��)-�д�</option>
			                <option value="020385">�������̼�ī(��)</option>
							<option value="022846">�Ե���Ż((��)����Ƽ��Ż)</option>				
        		        </SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>����</td>
					<td  colspan="5" width=20%>&nbsp;<input type='text' name="car_key_cau" size='70' class='text' value=''></td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
    	<td class=""></td>
    </tr>
	<tr>
    	<td class=line>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class=title colspan="4">���˻���</td>
				</tr>
				<tr>
					<td class=title width=10%>��������</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_oil">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="e_oil_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�ð���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="cool_wt">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="cool_wt_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>���ž�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="ws_wt">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="ws_wt_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="e_clean_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�ܰ�û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="out_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="out_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>Ÿ�̾�����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_air">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="tire_air_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>Ÿ�̾� ����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_mamo">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="tire_mamo_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>��������</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lamp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="lamp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="in_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="in_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�������۵�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="wiper">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="wiper_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�����۵�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="car_sound">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="car_soundl_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="panel">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="��ȯ">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="panel_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�������</td>
					<td width=40%>&nbsp;
						<SELECT NAME="front_bp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="front_bp_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�ĸ����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="back_bp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="back_bp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_�յ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_�ڵ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_�յ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_�ڵ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�">�ļ�</option>
							<OPTION VALUE="��ó">��ó</option>
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�̻�">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>��    ��</td>
					<td colspan="3" width=40%>&nbsp;
						<SELECT NAME="energy">
							<OPTION VALUE="FULL">FULL</option>
							<OPTION VALUE="3/4">3/4</option>
							<OPTION VALUE="2/4">2/4</option>
							<OPTION VALUE="1/4">1/4</option>
							<OPTION VALUE="E">E</option>
						</SELECT>&nbsp;���� : <input type='text' name="energy_ny" size='80' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>��    Ÿ</td>
					<td width=90% colspan="3">&nbsp;<TEXTAREA NAME="gita" ROWS="3" COLS="135"></TEXTAREA></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td class=""></td>
    </tr>
    <tr>
    	<td class=line2></td>
    </tr>
	<tr>
    	<td class=line>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
  					<td class=title colspan="10">��ġ��ǰ</td>
				</tr>
				<tr>
					<td class=title width=10%>�����</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods1" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods1" VALUE="����">����
					</td>
					<td class=title width=10%>��뼳��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods2" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods2" VALUE="����">����
					</td>
					<td class=title width=10%>������</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods3" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods3" VALUE="����">����
					</td>
					<td class=title width=10%>����Ű</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods4" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods4" VALUE="����">����
					</td>
					<td class=title width=10%>�ðŶ�����</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods13" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods13" VALUE="����">����
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�ﰢ��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods7" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods7" VALUE="����">����
					</td>
					<td class=title width=10%>����</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods8" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods8" VALUE="����">����
					</td>
					<td class=title width=10%>SŸ�̾�</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods10" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods10" VALUE="����">����
					</td>
					<td class=title width=10%>�����ü��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods11" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods11" VALUE="����">����
					</td>
					<td class= width=10% colspan='2'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td align='right'>
	  	<img src="/acar/images/center/button_reg.gif" onclick="save();" border="0" align="absmiddle"><!-- <a href="javascript:save()"></a> -->
	  	<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  	</td>
	</tr>

  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
