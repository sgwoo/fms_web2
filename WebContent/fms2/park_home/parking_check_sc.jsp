<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.parking.*, acar.res_search.*"%> 
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%	
	CommonDataBase c_db = CommonDataBase.getInstance();
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int serv_seq = request.getParameter("serv_seq")==null?0:Util.parseInt(request.getParameter("serv_seq"));
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String park_id	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	int car_km 			= request.getParameter("car_km")==null?0:Util.parseInt(request.getParameter("car_km"));
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String io_gubun = request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String st	= request.getParameter("st")==null?"":request.getParameter("st");
	String s_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
	int count = 0;
	
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	//�����׸�
	String e_oil	= request.getParameter("e_oil")==null?"":request.getParameter("e_oil");
	String cool_wt	= request.getParameter("cool_wt")==null?"":request.getParameter("cool_wt");
	String ws_wt	= request.getParameter("ws_wt")==null?"":request.getParameter("ws_wt");
	String e_clean	= request.getParameter("e_clean")==null?"":request.getParameter("e_clean");
	String out_clean	= request.getParameter("out_clean")==null?"":request.getParameter("out_clean");
	String tire_air		= request.getParameter("tire_air")==null?"":request.getParameter("tire_air");
	String tire_mamo	= request.getParameter("tire_mamo")==null?"":request.getParameter("tire_mamo");
	String lamp		= request.getParameter("lamp")==null?"":request.getParameter("lamp");
	String in_clean	= request.getParameter("in_clean")==null?"":request.getParameter("in_clean");
	String wiper	= request.getParameter("wiper")==null?"":request.getParameter("wiper");
	String car_sound	= request.getParameter("car_sound")==null?"":request.getParameter("car_sound");
	String panel	= request.getParameter("panel")==null?"":request.getParameter("panel");
	String front_bp	= request.getParameter("front_bp")==null?"":request.getParameter("front_bp");
	String back_bp	= request.getParameter("back_bp")==null?"":request.getParameter("back_bp");
	String lh_fhd	= request.getParameter("lh_fhd")==null?"":request.getParameter("lh_fhd");
	String lh_bhd	= request.getParameter("lh_bhd")==null?"":request.getParameter("lh_bhd");
	String lh_fdoor	= request.getParameter("lh_fdoor")==null?"":request.getParameter("lh_fdoor");
	String lh_bdoor	= request.getParameter("lh_bdoor")==null?"":request.getParameter("lh_bdoor");
	String rh_fhd	= request.getParameter("rh_fhd")==null?"":request.getParameter("rh_fhd");
	String rh_bhd	= request.getParameter("rh_bhd")==null?"":request.getParameter("rh_bhd");
	String rh_fdoor	= request.getParameter("rh_fdoor")==null?"":request.getParameter("rh_fdoor");
	String rh_bdoor	= request.getParameter("rh_bdoor")==null?"":request.getParameter("rh_bdoor");
	String energy	= request.getParameter("energy")==null?"":request.getParameter("energy");
	String goods1	= request.getParameter("goods1")==null?"":request.getParameter("goods1");
	String goods2	= request.getParameter("goods2")==null?"":request.getParameter("goods2");
	String goods3	= request.getParameter("goods3")==null?"":request.getParameter("goods3");
	String goods4	= request.getParameter("goods4")==null?"":request.getParameter("goods4");
	String goods5	= request.getParameter("goods5")==null?"":request.getParameter("goods5");
	String goods6	= request.getParameter("goods6")==null?"":request.getParameter("goods6");
	String goods7	= request.getParameter("goods7")==null?"":request.getParameter("goods7");
	String goods8	= request.getParameter("goods8")==null?"":request.getParameter("goods8");
	String goods9	= request.getParameter("goods9")==null?"":request.getParameter("goods9");
	String goods10	= request.getParameter("goods10")==null?"":request.getParameter("goods10");
	String goods11	= request.getParameter("goods11")==null?"":request.getParameter("goods11");
	String goods12	= request.getParameter("goods12")==null?"":request.getParameter("goods12");
	String goods13	= request.getParameter("goods13")==null?"":request.getParameter("goods13");
	String e_oil_ny	= request.getParameter("e_oil_ny")==null?"":request.getParameter("e_oil_ny");
	String cool_wt_ny	= request.getParameter("cool_wt_ny")==null?"":request.getParameter("cool_wt_ny");
	String ws_wt_ny	= request.getParameter("ws_wt_ny")==null?"":request.getParameter("ws_wt_ny");
	String e_clean_ny	= request.getParameter("e_clean_ny")==null?"":request.getParameter("e_clean_ny");
	String out_clean_ny	= request.getParameter("out_clean_ny")==null?"":request.getParameter("out_clean_ny");
	String tire_air_ny		= request.getParameter("tire_air_ny")==null?"":request.getParameter("tire_air_ny");
	String tire_mamo_ny	= request.getParameter("tire_mamo_ny")==null?"":request.getParameter("tire_mamo_ny");
	String lamp_ny		= request.getParameter("lamp_ny")==null?"":request.getParameter("lamp_ny");
	String in_clean_ny	= request.getParameter("in_clean_ny")==null?"":request.getParameter("in_clean_ny");
	String wiper_ny	= request.getParameter("wiper_ny")==null?"":request.getParameter("wiper_ny");
	String car_sound_ny	= request.getParameter("car_sound_ny")==null?"":request.getParameter("car_sound_ny");
	String panel_ny	= request.getParameter("panel_ny")==null?"":request.getParameter("panel_ny");
	String front_bp_ny	= request.getParameter("front_bp_ny")==null?"":request.getParameter("front_bp_ny");
	String back_bp_ny	= request.getParameter("back_bp_ny")==null?"":request.getParameter("back_bp_ny");
	String lh_fhd_ny	= request.getParameter("lh_fhd_ny")==null?"":request.getParameter("lh_fhd_ny");
	String lh_bhd_ny	= request.getParameter("lh_bhd_ny")==null?"":request.getParameter("lh_bhd_ny");
	String lh_fdoor_ny	= request.getParameter("lh_fdoor_ny")==null?"":request.getParameter("lh_fdoor_ny");
	String lh_bdoor_ny	= request.getParameter("lh_bdoor_ny")==null?"":request.getParameter("lh_bdoor_ny");
	String rh_fhd_ny	= request.getParameter("rh_fhd_ny")==null?"":request.getParameter("rh_fhd_ny");
	String rh_bhd_ny	= request.getParameter("rh_bhd_ny")==null?"":request.getParameter("rh_bhd_ny");
	String rh_fdoor_ny	= request.getParameter("rh_fdoor_ny")==null?"":request.getParameter("rh_fdoor_ny");
	String rh_bdoor_ny	= request.getParameter("rh_bdoor_ny")==null?"":request.getParameter("rh_bdoor_ny");
	String energy_ny	= request.getParameter("energy_ny")==null?"":request.getParameter("energy_ny");
	String gita	= request.getParameter("gita")==null?"":request.getParameter("gita");
	String area	= request.getParameter("area")==null?"":request.getParameter("area");
	String car_key	= request.getParameter("car_key")==null?"":request.getParameter("car_key");
	String car_key_cau	= request.getParameter("car_key_cau")==null?"":request.getParameter("car_key_cau");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function ParkReg(){
	var fm = document.form1;

	if(fm.car_km.value == '' )					{	alert('����Ÿ��� �߸� �Ǿ����ϴ�. �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(fm.car_km.value == 0 )					{	alert('����Ÿ��� �߸� �Ǿ����ϴ�. �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(!confirm('��� �Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value= 'i';
	fm.target="i_no";
	fm.action="./parking_check_a.jsp";		
	fm.submit();
}

function Parkmodify(dt, seq){
	var fm = document.form1;

	if(fm.serv_seq.value == seq )					{	alert('������ �׸��� �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(fm.car_km.value == '' )					{	alert('����Ÿ��� �߸� �Ǿ����ϴ�. �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(fm.car_km.value == 0 )					{	alert('����Ÿ��� �߸� �Ǿ����ϴ�. �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(fm.car_key.value == 'X' && fm.car_key_cau.value == '')			{	alert('��Ű�� ���� ������ �ۼ��Ͻʽÿ�');		fm.car_key_cau.focus(); 		return;	}
	if(!confirm('���� �Ͻðڽ��ϱ�?')){	return;	}
	fm.serv_seq.value= seq;
	fm.serv_dt.value= dt;
	fm.cmd.value= 'mf';
	fm.target="i_no";
	fm.action="./parking_check_a.jsp";		
	fm.submit();
}


function parking_del(seq){
	var fm = document.form1;
	if(fm.serv_seq.value == '' && fm.car_km.value == '')					{	alert('������ �׸��� �ٽ� Ȯ���� �ּ���.');		fm.car_km.focus(); 		return;	}
	if(!confirm('���� �Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value = "d";	
	fm.serv_seq.value = seq;
	fm.target="i_no";
	fm.action="parking_check_a.jsp";		
	fm.submit();
}

function park_close()
{
	var fm = document.form1;
	fm.submit();
	parent.close() 
	self.close();
	window.close();
}

	//�뺸�ϱ�	
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470");
	}		
	

//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>

<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="park_id" value="<%=park_id%>">
<input type="hidden" name="serv_seq" >
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>"> 
<input type="hidden" name="car_no" 	value="<%=car_no%>">
<input type="hidden" name="io_gubun" value="<%=io_gubun%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="serv_dt" >
<input type="hidden" name="park_seq" >
<table border="0" cellspacing="0" cellpadding="0" width=100%>
 
  
<%
//System.out.println("park_seq: "+park_seq);
if(park_seq > 0 ){%> 
 
<% 
		Vector vt = pk_db.getParking_car(car_mng_id, io_gubun, park_seq );
		int vt_size = vt.size();
		
			for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	%>
  	<tr>
    	<td class=line2></td>
    </tr>
   <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
		
				<tr>
					<td class=title width=10% >��������</td>
					<td width='15%'>&nbsp;<%=ht.get("CAR_ST_NM")%></td>
					<td class=title width=10% >������ȣ</td>
					<td width='15%'>&nbsp;<%=ht.get("CAR_NO")%></td>
					<td class=title width=10%>����</td>
					<td  colspan="" width=30%>&nbsp;<%=ht.get("CAR_NM")%></td>
				</tr>
				<tr>
					<td class=title width=10%>����Ÿ�</td>
					<td  colspan="" width=15%>&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("CAR_KM")))%>(km)</td>
					<td class=title width=10%>�����</td>
					<td width='15%'>&nbsp;<%=ht.get("USERS_COMP")%>
					<a href="javascript:req_fee_start_act('�˸�', '', '<%=c_db.getNameById(String.valueOf(ht.get("USERS_COMP")),"USER_ID")%>')" onMouseOver="window.status=''; return true" title='<%=ht.get("USERS_COMP")%>���� �޸�/�޼���/���ڷ� �˸���'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
					</td>            	
					<td class=title width=10%>����������</td>
					<td width=30%>&nbsp;<%=ht.get("DRIVER_NM")%></td>
				</tr>
				<tr>
					<td class=title width=10%><%if(String.valueOf(ht.get("IO_GUBUN")).equals("1")){%>�԰�<%}else{%>���<%}%>�Ͻ�</td>
					<td colspan="" width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("IO_DT")))%></td>
					<td class=title width=10%>�����</td>
					<td  colspan="" width=15%>&nbsp;<%=ht.get("PARK_MNG")%></td>
					<td class=title width=10%>����Ͻ�</td>
					<td colspan="" width=30%>&nbsp;<%=ht.get("REG_DT")%></td>
				</tr>
				<tr>
					<td class=title width=10%>��Ű����</td>
					<td colspan="" width=20%>&nbsp;
					<input type='radio' name='car_key' value="O" onClick="this.form.car_key_cau.disabled=true" <%if(ht.get("CAR_KEY").equals("O")){%>checked <%}%>>��
					<input type='radio' name='car_key' value="X" onClick="this.form.car_key_cau.disabled=false" <%if(ht.get("CAR_KEY").equals("X")){%>checked onfocus="car_key_cau"<%}%>>��
					</td>
					<td class=title width=10%>��Ű���»���</td>
					<td  colspan="3" width=20%>&nbsp;<input type='text' name="car_key_cau" size='70' class='text' value='<%=ht.get("CAR_KEY_CAU")%>' disabled></td>
				</tr>
			</table>
		</td>
    </tr>
<%}%>	
	<tr>
    	<td class=h></td>
    </tr>	
<%}%>	
    <tr>
    	<td class=line2></td>
    </tr>
<%
//System.out.println("car_km: "+car_km);
%>	
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class=title>����: <input type='text' name="area"  size='2' value='<%=area%>' class='text' align=left></td>
					<td class=title colspan="3">���˻���</td>
				</tr>
				<tr>
					<td class=title width=10%>��������</td>
					<td width=40%>&nbsp;<SELECT NAME="e_oil">
					<OPTION VALUE="����" <%if(e_oil.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(e_oil.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(e_oil.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(e_oil.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="e_oil_ny" size='25' class='text' align=left value='<%=e_oil_ny%>' ></td>
					<td class=title width=10%>�ð���</td>
					<td width=40%>&nbsp;<SELECT NAME="cool_wt">
					<OPTION VALUE="����" <%if(cool_wt.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(cool_wt.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(cool_wt.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(cool_wt.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="cool_wt_ny" size='25' class='text' align=left value='<%=cool_wt_ny%>'></td>
				</tr>
				<tr>
					<td class=title width=10%>���ž�</td>
					<td width=40%>&nbsp;<SELECT NAME="ws_wt">
					<OPTION VALUE="����" <%if(ws_wt.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(ws_wt.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(ws_wt.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(ws_wt.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="ws_wt_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;<SELECT NAME="e_clean">
					<OPTION VALUE="����" <%if(e_clean.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(e_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(e_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(e_clean.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>		
					</SELECT>&nbsp;���� : <input type='text' name="e_clean_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>�ܰ�û�ᵵ</td>
					<td width=40%>&nbsp;<SELECT NAME="out_clean">
					<OPTION VALUE="����" <%if(out_clean.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(out_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(out_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(out_clean.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="out_clean_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>Tire�����</td>
					<td width=40%>&nbsp;<SELECT NAME="tire_air">
					<OPTION VALUE="����" <%if(tire_air.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(tire_air.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(tire_air.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(tire_air.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="tire_air_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>Tire����</td>
					<td width=40%>&nbsp;<SELECT NAME="tire_mamo">
					<OPTION VALUE="����" <%if(tire_mamo.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(tire_mamo.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(tire_mamo.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(tire_mamo.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="tire_mamo_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>��������</td>
					<td width=40%>&nbsp;<SELECT NAME="lamp">
					<OPTION VALUE="����" <%if(lamp.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(lamp.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(lamp.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(lamp.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="lamp_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>����û�ᵵ</td>
					<td width=40%>&nbsp;<SELECT NAME="in_clean">
					<OPTION VALUE="����" <%if(in_clean.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(in_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(in_clean.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(in_clean.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="in_clean_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>�������۵�</td>
					<td width=40%>&nbsp;<SELECT NAME="wiper">
					<OPTION VALUE="����" <%if(wiper.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(wiper.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(wiper.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(wiper.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="wiper_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>�����۵�</td>
					<td width=40%>&nbsp;<SELECT NAME="car_sound">
					<OPTION VALUE="����" <%if(car_sound.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(car_sound.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(car_sound.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(car_sound.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="car_sound_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>�����</td>
					<td width=40%>&nbsp;<SELECT NAME="panel">
					<OPTION VALUE="����" <%if(panel.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="����" <%if(panel.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="����" <%if(panel.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="��ȯ" <%if(panel.equals("��ȯ"))%> selected<%%> style="color:#f00">��ȯ</option>
					</SELECT>&nbsp;���� : <input type='text' name="panel_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>�������</td>
					<td width=40%>&nbsp;<SELECT NAME="front_bp">
					<OPTION VALUE="����" <%if(front_bp.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(front_bp.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(front_bp.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(front_bp.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(front_bp.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="front_bp_ny" size='25' class='text' align=left></td>
					<td class=title width=10%>�ĸ����</td>
					<td width=40%>&nbsp;<SELECT NAME="back_bp">
					<OPTION VALUE="����" <%if(back_bp.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(back_bp.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(back_bp.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(back_bp.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(back_bp.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="back_bp_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;<SELECT NAME="lh_fhd">
					<OPTION VALUE="����" <%if(lh_fhd.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(lh_fhd.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(lh_fhd.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(lh_fhd.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(lh_fhd.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="lh_fhd_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>LH_���Ӵ�</td>
					<td width=40%>&nbsp;<SELECT NAME="lh_bhd">
					<OPTION VALUE="����" <%if(lh_bhd.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(lh_bhd.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(lh_bhd.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(lh_bhd.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(lh_bhd.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="lh_bhd_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>LH_�յ���</td>
					<td width=40%>&nbsp;<SELECT NAME="lh_fdoor">
					<OPTION VALUE="����" <%if(lh_fdoor.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(lh_fdoor.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(lh_fdoor.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(lh_fdoor.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(lh_fdoor.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="lh_fdoor_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>LH_�ڵ���</td>
					<td width=40%>&nbsp;<SELECT NAME="lh_bdoor">
					<OPTION VALUE="����" <%if(lh_bdoor.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(lh_bdoor.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(lh_bdoor.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(lh_bdoor.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(lh_bdoor.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="lh_bdoor_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;<SELECT NAME="rh_fhd">
					<OPTION VALUE="����" <%if(rh_fhd.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(rh_fhd.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(rh_fhd.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(rh_fhd.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(rh_fhd.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>

					</SELECT>&nbsp;���� : <input type='text' name="rh_fhd_ny" size='25' class='text' align=left ></td>
					<td class=title width=10%>RH_���Ӵ�</td>
					<td width=40%>&nbsp;<SELECT NAME="rh_bhd">
					<OPTION VALUE="����" <%if(rh_bhd.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(rh_bhd.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(rh_bhd.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(rh_bhd.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(rh_bhd.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="rh_bhd_ny" size='25' class='text' align=left ></td>
				</tr>
				<tr>
					<td class=title width=10%>RH_�յ���</td>
					<td width=40%>&nbsp;<SELECT NAME="rh_fdoor">
					<OPTION VALUE="����" <%if(rh_fdoor.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(rh_fdoor.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(rh_fdoor.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(rh_fdoor.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(rh_fdoor.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="rh_fdoor_ny" size='25' class='text' align=left></td>
					<td class=title width=10%>RH_�ڵ���</td>
					<td width=40%>&nbsp;<SELECT NAME="rh_bdoor">
					<OPTION VALUE="����" <%if(rh_bdoor.equals("����"))%> selected<%%>>����</option>
					<OPTION VALUE="�ļ�" <%if(rh_bdoor.equals("�ļ�"))%> selected<%%> style="color:#f00">�ļ�</option>
					<OPTION VALUE="��ó" <%if(rh_bdoor.equals("��ó"))%> selected<%%> style="color:#f00">��ó</option>
					<OPTION VALUE="����" <%if(rh_bdoor.equals("����"))%> selected<%%> style="color:#f00">����</option>
					<OPTION VALUE="�̻�" <%if(rh_bdoor.equals("�̻�"))%> selected<%%> style="color:#f00">�̻�</option>
					</SELECT>&nbsp;���� : <input type='text' name="rh_bdoor_ny" size='25' class='text' align=left></td>
				</tr>
				<tr>
					<td class=title width=10%>��    ��</td>
					<td width=40%>&nbsp;<SELECT NAME="energy">
					<OPTION VALUE="FULL" <%if(energy.equals("FULL"))%> selected<%%>>FULL</option>
					<OPTION VALUE="3/4" <%if(energy.equals("3/4"))%> selected<%%>>3/4</option>
					<OPTION VALUE="2/4" <%if(energy.equals("2/4"))%> selected<%%>>2/4</option>
					<OPTION VALUE="1/4" <%if(energy.equals("1/4"))%> selected<%%>>1/4</option>
					<OPTION VALUE="E" <%if(energy.equals("E"))%> selected<%%>  style="color:#f00">E</option>
					</SELECT>&nbsp;���� : <input type='text' name="energy_ny" size='25' class='text' align=left></td>
					<td class=title width=10%>����Ÿ�</td>
					<td width=40%>&nbsp;<input type='text' name="car_km" size='25' class='num' align=right value='<%=Util.parseDecimal(car_km)%>' >km</td>
				</tr>
				<tr>
					<td class=title width=10%>��    Ÿ</td>
					<td width=90% colspan="3">&nbsp;<TEXTAREA NAME="gita" ROWS="3" COLS="135"><%=gita%></TEXTAREA></td>
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
  					<td class=title colspan="10">��ġ��ǰ</td>
				</tr>
				<tr>
					<td class=title width=10%>�����</td>
					<td  width=10% align=center><SELECT NAME="goods1">
						<OPTION VALUE="����" <%if(goods1.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods1.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>��뼳��</td>
					<td  width=10% align=center><SELECT NAME="goods2">
						<OPTION VALUE="����" <%if(goods2.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods2.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>������</td>
					<td  width=10% align=center><SELECT NAME="goods3">
						<OPTION VALUE="����" <%if(goods3.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods3.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>����Ű</td>
					<td  width=10% align=center><SELECT NAME="goods4">
						<OPTION VALUE="����" <%if(goods4.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods4.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>�ðŶ�����</td>
					<td  width=10% align=center><SELECT NAME="goods13">
						<OPTION VALUE="����" <%if(goods13.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods13.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
				</tr>
				<tr>
					<td class=title width=10%>�ﰢ��</td>
					<td  width=10% align=center><SELECT NAME="goods7">
						<OPTION VALUE="����" <%if(goods7.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods7.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>����</td>
					<td  width=10% align=center><SELECT NAME="goods8">
						<OPTION VALUE="����" <%if(goods8.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods8.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>SŸ�̾�</td>
					<td  width=10% align=center><SELECT NAME="goods10">
						<OPTION VALUE="����" <%if(goods10.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods10.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class=title width=10%>�����ü��</td>
					<td  width=10% align=center><SELECT NAME="goods11">
						<OPTION VALUE="����" <%if(goods11.equals("����"))%> selected<%%>>����
						<OPTION VALUE="����" <%if(goods11.equals("����"))%> selected<%%> style="color:#f00">����
						</SELECT></td>
					<td class= width=10% colspan='2'></td>
				</tr>
			</table>
		</td>
	</tr>
	    <tr>
    	<td class=h></td>
    </tr>
	<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<%if(!st.equals("1")){%>
	<tr>
		<td align='right'>
		<a href="javascript:ParkReg();" onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
		<a href="javascript:Parkmodify(<%=serv_dt%>, <%=serv_seq%>);" onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		<a href='javascript:parking_del(<%=serv_seq%>);' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>
		<a href='javascript:park_close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
		
	  	</td>
	</tr>
	<%}%>
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>