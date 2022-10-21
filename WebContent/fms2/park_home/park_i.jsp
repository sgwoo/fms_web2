<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%	
	
	int park_seq = request.getParameter("park_seq")==null?1:Util.parseInt(request.getParameter("park_seq"));
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String io_gubun = request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	int car_km = request.getParameter("car_km")==null?0:AddUtil.parseDigit(request.getParameter("car_km")); // ����Ÿ�

	String new_car = request.getParameter("new_car")==null?"":request.getParameter("new_car");
	String last_km = "";
	
	String io_dt = request.getParameter("io_dt")==null?"":request.getParameter("io_dt");
	String io_sau = request.getParameter("io_sau")==null?"":request.getParameter("io_sau");
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String area = request.getParameter("area")==null?"":request.getParameter("area");
	
	int count =0;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String s_kd = "";
	String t_wd = "";
	String sort_gubun = "";
	String asc = "";

	CommonDataBase c_db = CommonDataBase.getInstance();

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_id = u_bean.getBr_id();

	Vector users = c_db.getUserList("", "", "B_M_EMP");
	int user_size = users.size();

	//������ ����
	CodeBean[] drivers = c_db.getCodeAll("0048");
	int drivers_size = drivers.length;

	//������ ����
	CodeBean[] goods = c_db.getCodeAll("0027");
	int goods_size = goods.length;
	
	
	//���˻���
	String e_oil = "";
	String cool_wt = "";
	String ws_wt = "";
	String e_clean = "";
	String out_clean = "";
	String tire_air = "";
	String tire_mamo = "";
	String lamp = "";
	String in_clean = "";
	String wiper = "";
	String panel = "";
	String front_bp = "";
	String back_bp = "";
	String lh_fhd = "";
	String lh_bhd = "";
	String lh_fdoor = "";
	String lh_bdoor = "";
	String rh_fhd = "";
	String rh_bhd = "";
	String rh_fdoor = "";
	String rh_bdoor = "";
	String energy = "";
	String car_sound = "";
	String goods1 = "";
	String goods2 = "";
	String goods3 = "";
	String goods4 = "";
	String goods5 = "";
	String goods6 = "";
	String goods7 = "";
	String goods8 = "";
	String goods9 = "";
	String goods10 = "";
	String goods11 = "";
	String goods12 = "";
	String goods13 = "";
	String e_oil_ny = "";
	String cool_wt_ny = "";
	String ws_wt_ny = "";
	String e_clean_ny = "";
	String out_clean_ny = "";
	String tire_air_ny = "";
	String tire_mamo_ny = "";
	String lamp_ny = "";
	String in_clean_ny = "";
	String wiper_ny = "";
	String panel_ny = "";
	String front_bp_ny = "";
	String back_bp_ny = "";
	String lh_fhd_ny = "";
	String lh_bhd_ny = "";
	String lh_fdoor_ny = "";
	String lh_bdoor_ny = "";
	String rh_fhd_ny = "";
	String rh_bhd_ny = "";
	String rh_fdoor_ny = "";
	String rh_bdoor_ny = "";
	String energy_ny = "";
	String car_sound_ny = "";
	String gita ="";
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
$(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
});

function save(){
	var fm = document.form1;
	
	if(fm.car_no.value == '')						{	alert('������ȣ�� �Է��Ͻʽÿ�');			fm.car_no.focus(); 			return;	}
	if(fm.users_comp.value == '')				{	alert('����ڸ� �����Ͻʽÿ�');				fm.users_comp.focus(); 	return;	}
	if(fm.driver_nm.value == '')				{	alert('�����ڸ� �����Ͻʽÿ�');				fm.driver_nm.focus(); 	return;	}
	if(fm.park_id.value == '')					{	alert(' ������ �������� �����Ͻʽÿ�');	fm.park_id.focus(); 		return;	}	
	if(fm.rent_l_cd.value == '')				{	alert(' ������ �����Ͻʽÿ�');			fm.car_no.focus(); 	return;	}	
	//if(fm.car_key.value == 'X' && fm.car_key_cau.value == '')				{	alert('��Ű�� ���� ������ �ۼ��Ͻʽÿ�');			fm.car_key_cau.focus(); 	return;	}
	if((fm.car_km.value == '' || toInt(fm.car_km.value ) < 1) && fm.car_key_cau.value == '') {	
		alert('����Ÿ��� ���� ������ �ۼ��Ͻʽÿ�');		
		fm.car_key_cau.focus(); 	return;	
	}
	
	//�����������ΰ�� ��ġ 
	if (fm.park_id.value == '1' ) {
	   if ( fm.area.value == '' )  {	alert(' ������ ��ġ�� �����Ͻʽÿ�');				fm.area.focus(); 	return;	}	
	}
	
		

	
	if(toInt(fm.last_km.value) > toInt(fm.car_km.value) ) { //����Ÿ��� ������ �ԷµȰͺ��� ������ ������. ������ �н�..
		alert('�Է��� ����Ÿ��� ������ ����Ÿ� ('+fm.last_km.value+' km) ���� �۽��ϴ�.');
		if(!confirm('��¥!!! ��� �Ͻðڽ��ϱ�?')){	
			return;	
		}
	}
	
	fm.target="i_no";
	fm.action="park_i_a.jsp";
	fm.submit();
	
	fn_layer_popup();
}
function Close()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}
	
		function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search_car();
	}


//�˻��ϱ�
	function search_car(){
		var fm = document.form1;	
	
		if(fm.car_no.value == ''){ alert('������ȣ�� �Է��Ͻʽÿ�.'); fm.car_no.focus(); return; }	
		window.open("about:blank", "SEARCH_CAR", "left=100, top=100, width=700, height=300, scrollbars=yes");		
		fm.target = "SEARCH_CAR";
		fm.action = "search.jsp?s_kd=2&t_wd="+fm.car_no.value;
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

function fn_layer_popup(){  
	var layer = document.getElementById("loader");	
	var layerContent = document.getElementById("loaderContent");	
	layer.style.visibility="visible"; 
	layerContent.style.animation="spin 0.8s linear infinite"; 
}

//-->
</script>
<style>
.loaderLayer {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0px;
  left: 0px;
  visibility: hidden;
  background-color: rgba(112, 113, 102, 0.3);
}
.loader {
  position: absolute;
  top: 45%;
  left: 50%;
  z-index: 1;
  border: 8px solid #f3f3f3;
  border-radius: 50%;
  border-top: 8px solid #3498db;
  width: 30px;
  height: 30px;
  /* -webkit-animation: spin 1s linear infinite; */
  /* animation: spin 0.8s linear infinite; */
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="car_mng_id" value=""> 
<input type="hidden" name="rent_mng_id" value=""> 
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_st" value="">  
<input type="hidden" name="mng_id" value=""> 
<input type="hidden" name="firm_nm" value=""> 
<input type="hidden" name="init_reg_dt" value=""> 
<input type="hidden" name="io_gubun" value="1"> 
<input type='hidden' name="reg_id" value='<%=user_id%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>"> 
<input type="hidden" name="cmd" value="">


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ���������� > �����������Ȳ > <span class=style5>�����԰���</span></span></td>
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
					<td class=title width=10% >����/�����ȣ</td>
					<td width=20%>&nbsp;<input type='text' name="car_no" value='' size='20' class='text' onKeyDown='javascript:enter()' style="ime-mode:active;" >
					<a href="javascript:search_car()"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></td>
					<td class=title width=10%>����</td>
					<td width=20%>&nbsp;<input type="text" name="car_nm" value="" size="25" maxlength='50' class='text'></td>
					<td class=title width=10%>����Ÿ�</td>
					<input type="hidden" name="last_km" value="">
					<td width=20%>&nbsp;<input type='text' name="car_km" size='20' class='num'>(km)</td>
				</tr>
		
				<tr>
					<td class=title width=10%>�����</td>
					<td width='20%'>&nbsp;<select name='users_comp'>
		                <option value="">����ڼ���</option>
						<option value="�˼�����">�˼�����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_NM")%>' <%if(mng_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		                <%		}
							}%>
		              </select></td>            	
					<td class=title width=10%>����������</td>
					<td width=20%>&nbsp;<SELECT NAME="driver_nm" >
										<option value=""selected>�����ڼ���</option>
									<!-- 	<OPTION VALUE="S">����</option>
										<OPTION VALUE="C">��</option>
										<OPTION VALUE="T">Ź�۾�ü</option>
										<OPTION VALUE="M">����������</option>
										<OPTION VALUE="H">�������������</option>
										<OPTION VALUE="D">�β��������</option>
										<OPTION VALUE="BK">�ΰ������</option>
										<OPTION VALUE="G2">�ö���Ŭ��</option>
										<OPTION VALUE="AT">����ũ��</option>
										<OPTION VALUE="HD">����ī��ũ</option>
										<OPTION VALUE="DA">�ٿȹ�</option>
										<OPTION VALUE="NB">�����</option>
										<OPTION VALUE="1K">������ȣ</option>
										<OPTION VALUE="BD">����ī��Ÿ</option>
										<option value="NO">�˼�����</option> -->
										<%for(int i = 0 ; i < drivers_size ; i++){
											CodeBean driver = drivers[i];
											if(driver.getUse_yn().equals("Y")){
											%>
										<option value='<%= driver.getNm_cd()%>'><%= driver.getNm()%></option>
										<%}}%>
									</SELECT>
					</td>
					<td class='title' width=10% >������</td>
					<td width=20%>&nbsp;<SELECT NAME="park_id" id="park_id" >
							
							
										<option value=""selected>�����弱��</option>
										 <OPTION VALUE="1" <%if(br_id.equals("S1")){%>selected<%}%>>����������</option>
										<%-- <OPTION VALUE="8" <%if(br_id.equals("B1")){%>selected<%}%>>�λ�����</option>  --%>
										<OPTION VALUE="8" <%if(br_id.equals("B1")){%>selected<%}%>>�����̵�</option> 
										<OPTION VALUE="7" >�λ�ΰ�</option>
										<OPTION VALUE="4" <%if(br_id.equals("D1")){%>selected<%}%>>��������</option>
										<!-- <OPTION VALUE="9" >��������</option>		 -->								
										<OPTION VALUE="12" <%if(br_id.equals("J1")){%>selected<%}%>>��������</option>
										<OPTION VALUE="13" <%if(br_id.equals("G1")){%>selected<%}%>>�뱸����</option> 
										<OPTION VALUE="20">��������</option> 
										
								<%-- 		<%for(int i = 0 ; i < goods_size ; i++){
											CodeBean good = goods[i];
											if(good.getUse_yn().equals("Y")){
											%>
										<option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
										<%}}%> --%>
										
									</SELECT>
								&nbsp;&nbsp;<SELECT NAME="area" id="area">
										<option value=""selected>����</option>
										<OPTION VALUE="A" >A����</option>
										<OPTION VALUE="B" >B����</option>
										<OPTION VALUE="C" >C����</option>
										<OPTION VALUE="D" >D����</option>
										<OPTION VALUE="E" >E����</option>
										<OPTION VALUE="F" >F����</option>
										<OPTION VALUE="G" >G����</option>
										<OPTION VALUE="H" >H����</option>
									</SELECT>		
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�԰��Ͻ�</td>
					<td colspan="" width=20%>&nbsp;<input type="text" name="io_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(AddUtil.getDate(4)))%>" size="30" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>					
					<td class=title width=10%>�����</td>
					<td  colspan="" width=20%>&nbsp;<input type='text' name="park_mng" size='30' class='text' value='<%=user_nm%>'></td>
<!-- 					<td class=title width=10%>��������</td>
					<td  colspan="" width=20%>&nbsp;<SELECT NAME="new_car" >
										<option value=""selected>����</option>
										<OPTION VALUE="YC" >����</option>
									</SELECT></td> 
					-->
									
					<td class=title width=10%>��Ű����</td>
					<td colspan="" width=20%>&nbsp;
					<input type='radio' name='car_key' value="O" checked >��
					<input type='radio' name='car_key' value="X" >��
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
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="e_oil_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�ð���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="cool_wt">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="cool_wt_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>���ž�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="ws_wt">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="ws_wt_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="e_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="e_clean_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�ܰ�û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="out_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="out_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>Ÿ�̾�����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_air">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="tire_air_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>Ÿ�̾� ����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="tire_mamo">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="tire_mamo_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>��������</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lamp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="lamp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;
						<SELECT NAME="in_clean">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="in_clean_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�������۵�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="wiper">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="wiper_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�����۵�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="car_sound">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
						</SELECT>&nbsp;���� : <input type='text' name="car_soundl_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="panel">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="��ȯ" style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="panel_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�������</td>
					<td width=40%>&nbsp;
						<SELECT NAME="front_bp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="front_bp_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>�ĸ����</td>
					<td width=40%>&nbsp;
						<SELECT NAME="back_bp">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="back_bp_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>LH_�յ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_fdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>LH_�ڵ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="lh_bdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="lh_bdoor_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_fhd_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bhd">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_bhd_ny" size='40' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>RH_�յ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_fdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
						</SELECT>&nbsp;���� : <input type='text' name="rh_fdoor_ny" size='40' class='text' align=left>
					</td>
					<td class=title width=10%>RH_�ڵ���</td>
					<td width=40%>&nbsp;
						<SELECT NAME="rh_bdoor">
							<OPTION VALUE="����">����</option>
							<OPTION VALUE="�ļ�" style="color:#f00">�ļ�</option>
							<OPTION VALUE="��ó" style="color:#f00">��ó</option>
							<OPTION VALUE="����" style="color:#f00">����</option>
							<OPTION VALUE="�̻�" style="color:#f00">�̻�</option>
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
							<OPTION VALUE="E" style="color:#f00">E</option>
						</SELECT>&nbsp;���� : <input type='text' name="energy_ny" size='80' class='text' align=left>
					</td>
				</tr>
				<tr>
					<td class=title width=10%>��    Ÿ</td>
					<td width=90% colspan="3">&nbsp;<TEXTAREA NAME="gita" ROWS="5" COLS="135"></TEXTAREA></td>
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
						<INPUT TYPE="radio" NAME="goods1" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>��뼳��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods2" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods2" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>������</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods3" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods3" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>����Ű</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods4" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods4" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>�ðŶ�����</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods13" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods13" VALUE="����" style="color:#f00">����
					</td>
				</tr>
				<tr>
					<td class=title width=10%>�ﰢ��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods7" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods7" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>����</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods8" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods8" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>SŸ�̾�</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods10" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods10" VALUE="����" style="color:#f00">����
					</td>
					<td class=title width=10%>�����ü��</td>
					<td  width=10% align=center>
						<INPUT TYPE="radio" NAME="goods11" VALUE="����">����
						<INPUT TYPE="radio" NAME="goods11" VALUE="����" style="color:#f00">����
					</td>
					<td class= width=10% colspan='2'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td align='right'>
	  	<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();"><!-- <a href="javascript:save()"></a>  this.style.visibility='hidden'-->
	  	<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  	<div class="loaderLayer" id="loader">
	  		<div class="loader" id="loaderContent"></div>
	  	</div>
	  	</td>
	</tr>
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>