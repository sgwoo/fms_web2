<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*, java.text.SimpleDateFormat"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/agent/cookies.jsp" %>

<%	
	
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");

	String new_car = request.getParameter("new_car")==null?"":request.getParameter("new_car");	
	
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp");
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel");
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng");
	String wash_dt = request.getParameter("wash_dt")==null?"":request.getParameter("wash_dt");
	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay");
		
	int count =0;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
//	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
//	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
//	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ

	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");

	String req_dt = request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc");
	String gubun_st = request.getParameter("gubun_st")==null?"0":request.getParameter("gubun_st");
	
	String s_kd = "";
	String t_wd = "";
	String sort_gubun ="";
	String asc ="";
	
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
	
	Date today = new Date();	        
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat time = new SimpleDateFormat("HH:mm");

	String year = date.format(today);
	String ms = time.format(today);
	
	String h = ms.split(":")[0];
	String m = ms.split(":")[1];
	
	//���������� �ڵ�
	CodeBean[] own_types = c_db.getCodeAll("0049");
	int own_types_size = own_types.length;
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
/* $(document).ready(function(){
	
	parkAreaSetting();
	$('#park_id').bind('change', function(){
		parkAreaSetting();
	});
	
}); */

function save(){	
	var fm = document.form1;
	var regNum = /^[0-9]*$/;
	if (fm.car_no.value == '') { 
		alert('������ȣ�� �Է��Ͻʽÿ�');	 
		fm.car_no.focus(); 
		return; 
	} else if(fm.park_id.value == '') {	
		alert('������ �������� �����Ͻʽÿ�');
		fm.park_id.focus(); 	
		return;	
	} else if(fm.rent_l_cd.value == '') {
		alert('������ ��ȸ�Ͽ� �����Ͻʽÿ�');
		fm.car_no.focus(); 	
		return;	
	/* } else if (fm.wash_dt.value == '') {
		alert('�����Ͻø� �Է��ϼ���.');
		fm.wash_dt.focus();
		return; */
	/* } else if (fm.wash_pay.value == '') {
		alert('��������� �Է��ϼ���.');
		fm.wash_pay.focus();
		return; */
	/* } else if (!regNum.test(fm.wash_pay.value)) {
		alert("��������� ���ڷθ� �Է��ϼ���.");
		fm.wash_pay.focus();
		return;  */
	} else if(fm.own_type.value == '') {
		alert('���������ڸ� �����Ͻʽÿ�');
		fm.own_type.focus(); 	
		return;	
	} else if(fm.scd_time_yn.value == '') {
		alert('���������ð��� �����Ͻʽÿ�');
		return;		
	} else if(fm.scd_time_yn.value == 'Y') {
		if(fm.scd_time.value == ''){
		alert('�����ð��� �Է��Ͻʽÿ�');
			fm.scd_time.focus(); 	
			return;			
		}
		
	}
	
	alert('���� �����Ƿ��� �� �����ϴ�.!!!');
	
//	if(!confirm('��� �Ͻðڽ��ϱ�?')){
//		return;
//	}

//	fm.target="i_no";
//	fm.action="park_w_i_a.jsp";	
//	fm.submit();	
		
}


function Close() {
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

	if(fm.car_no.value == ''){ 
		alert('������ȣ�� �Է��Ͻʽÿ�.'); 
		fm.car_no.focus(); 
		return; 
	}	
	window.open("about:blank", "SEARCH_CAR", "left=100, top=100, width=700, height=300, scrollbars=yes");		
	fm.target = "SEARCH_CAR";
	fm.action = "search_w.jsp?s_kd=2&t_wd="+fm.car_no.value;
	fm.submit();
}


function fn_layer_popup(){  
	var layer = document.getElementById("loader");	
	var layerContent = document.getElementById("loaderContent");	
	layer.style.visibility="visible"; 
	layerContent.style.animation="spin 0.8s linear infinite"; 
}

function selectScdTimeYn(scd_time_yn){  
	var fm = document.form1;	
	if(scd_time_yn == 'Y'){
//		fm.scd_time.disabled ='';
		fm.scd_time.setAttribute('type','text');
	}else{
		fm.scd_time.setAttribute('type','hidden');
	//	fm.scd_time.disabled ='true';
	}
	
	
}

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

.input_box {width: 100px;}
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
<input type="hidden" name="mng_id" value="<%=mng_id%>"> 
<input type="hidden" name="users_comp" value="<%=users_comp%>"> 
<input type="hidden" name="user_m_tel" value="<%=user_m_tel%>"> 
<input type="hidden" name="firm_nm" value=""> 
<input type="hidden" name="io_gubun" value="1"> 
<input type='hidden' name="reg_id" value='<%=user_id%>'>
<input type="hidden" name="serv_dt" value="<%=AddUtil.ChangeString(AddUtil.getDate())%>"> 
<input type="hidden" name="cmd" value="">
<input type="hidden" name="park_seq" value="<%=park_seq%>">
<input type="hidden" name="gubun_st" value="<%=gubun_st%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<% if (park_seq == 0) {%>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ���������� > �����弼����Ȳ > <span class=style5>�����������</span></span></td>
					<% } else { %>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ���������� > �����弼����Ȳ > <span class=style5>������������</span></span></td>
					<% }%>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr  style="height: 20px;"> 
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
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
								<input type='text' name="car_no" value='<%=car_no%>' size='20' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
								<a href="javascript:search_car()"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
						<% } else { %>
								<%=car_no%>
								<input type='hidden' name="car_no" value='<%=car_no%>'>
						<% } %>						
					</td>
					<td class=title width=10%>����</td>
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
							<input type="text" name="car_nm" value="<%=car_nm%>" size="30" maxlength='50' class='text'>
						<% } else { %>
								<%=car_nm%>
								<input type="hidden" name="car_nm" value="<%=car_nm%>">
						<% } %>
					</td>
				
		            <td class='title' width=10% >������ġ</td>
					<td width=20% style="padding-left: 5px;">
						<select name="park_id" id="park_id" >
						<% if (park_seq == 0) { %>
								<option value="" selected>����������</option>
								<option value="1" <%if(br_id.equals("S1")){%>selected<%}%>>����������</option>
								<%-- <option value="17" <%if(br_id.equals("B1")){%>selected<%}%>>�����̵�</option>
								<option value="7" >�λ�ΰ�</option>
								<option value="4" <%if(br_id.equals("D1")){%>selected<%}%>>��������</option>
								<option value="12" <%if(br_id.equals("J1")){%>selected<%}%>>��������</option>
								<option value="13" <%if(br_id.equals("G1")){%>selected<%}%>>�뱸����</option> --%>
						<% } else { %>							
								<option value="" selected>����������</option>
								<option value="1" <%if(park_id.equals("1")){%>selected<%}%>>����������</option>
								<%-- <option value="17" <%if(park_id.equals("17")){%>selected<%}%>>�����̵�</option>
								<option value="7" <%if(park_id.equals("7")){%>selected<%}%>>�λ�ΰ�</option>
								<option value="4" <%if(park_id.equals("4")){%>selected<%}%>>��������</option>										
								<option value="12" <%if(park_id.equals("12")){%>selected<%}%>>��������</option>
								<option value="13" <%if(park_id.equals("13")){%>selected<%}%>>�뱸����</option> --%>							
						<% } %>
						</select>
					
					</td>
				</tr>		
				<tr>					
					<td class=title width=10%>�۾���û�Ͻ�</td>
					<td width=20% style="padding-left: 5px;">
						<% if (park_seq == 0) { %>
							<input type="text" name="start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(AddUtil.getDate(4)))%>" size="10" maxlength='10' class='text input_box' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
						<% } else { %>
							<input type="text" name="start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(req_dt))%>" size="10" maxlength='10' class='text input_box' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
						<% } %>
						<select name="start_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                        <select name="start_m" >
                        <%for(int i=0; i<60; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(m.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
					</td>
					<td class=title width=10%>�۾���û</td>
					<td width=20% colspan="3" style="padding-left:5px;">
						<input type="checkbox" name="wash_pay" value="0" checked>���� (10,000��)&nbsp;			
						 <input type="checkbox" name="inclean_pay" value="0" >�ǳ�ũ���� �� �������� (20,000��)		
					</td>
				</tr>
				<tr>					
					<td class=title width=10%>* ����������</td>
					<td style="padding-left:5px;">
						<select name="own_type">
							<option value=''>����</option>
                        	<%for(int i = 0 ; i < own_types_size ; i++){
								CodeBean own_type = own_types[i];
								if(own_type.getUse_yn().equals("Y")){
								%>
							<option value='<%=own_type.getNm()%>'><%= own_type.getNm()%></option>
							<%}}%>
                        </select>
					</td>
					<td class=title width=10%>* ���������ð�</td>
					<td width=20% colspan="3" style="padding-left:5px;">
						<input type="radio" name="scd_time_yn" value="N" onclick="selectScdTimeYn(this.value);" />����
						<input style="margin-left: 25px;" type="radio" name="scd_time_yn" value="Y" onclick="selectScdTimeYn(this.value);" />������ð� �Է�
						<input style="margin-left: 5px;" type="hidden" class="text" name="scd_time" placeholder="ex) ����7�� �����">
					</td>
				</tr>
				<tr>
					<td class=title width=10%>����</td>
					<td width=20% colspan="5" style="padding-left: 5px;">
						<input type="text" class="text" name="wash_etc" value="<%=wash_etc%>" style="width: 500px;" placeholder=" ">						
					</td>
				</tr>
			</table>
		</td>
    </tr>
		<tr>
    	<td class=""></td>
    </tr>
    
    <!-- 	
	<tr>
	  <td align='right'>
	  	<% if (park_seq == 0) {%>
	  		<img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="save();">
		<% } else { %>
			<img src="/acar/images/center/button_modify.gif" border="0" align="absmiddle" onMouseOver="this.style.cursor='pointer'" onclick="modify();">
		<% }%>
	  		<a href='javascript:close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
	  		
	  	</td>
	</tr>
-->
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>