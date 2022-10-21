<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,java.time.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%

	String cons_no = request.getParameter("cons_no")==null?	"":request.getParameter("cons_no");
	String seq = request.getParameter("seq")==null?	"":request.getParameter("seq");

	Hashtable ht = ln_db.getConsignmentLink(cons_no + seq);

%>

<html lang='ko'>
<head>
<title>�ε��μ���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" type="text/JavaScript">
	function onSave(){
		var fm = document.form1;
		
		var check = window.confirm('�����Ͻðڽ��ϱ�?');
		
		if(!check) return;
		
		fm.submit();
		
	}
</script>
</head>
<style>
body {
	margin-left: 0px;
	margin-top: 0px;
	font-size:0.8em; 
	text-align:center;
	font-family:nanumgothic;
}
.style1 { font-size:25px; font-weight:bold; }
.style2 { font-size:1.1em;	font-weight:bold; }
.style3 { font-size:0.8em; }
.style4 { font-size:0.9em;}
.style5 { text-decoration:underline; text-align:right; padding-right:20px; }
.style6 { font-size:1.1em; }
.style7 { text-decoration:underline; }
		
table {text-align:left; border-collapse:collapse; vertical-align:middle;}
p {padding:1px 0 0 0;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

td{
	line-height:130%;
	letter-spacing: 1px;
	word-spacing: 1px;
	border:1px solid #000000;
	text-align: center;
	height: 10px;
}
td { font-family:����, Gulim, AppleGothic, Seoul, Arial; background-color:#ffffff; color:#303030; font-size:9pt; height:25;}
.td-header {
	background-color:RGB(159,177,5);
	font-weight:bold;
	height: 10px;
}

</style>

<body>
<div class="a4" style="width:800px;">
	<form name='form1' action='deli_taking_a.jsp'>
	<input type='hidden' name='cons_no' value='<%=cons_no%>' />
	<input type='hidden' name='seq' value='<%=seq%>' />
	
	<table style="margin:2% 2% 1% 2%; width: 95%;">
		<tr>
			<td style="width: 50%; text-align:center; font-size:30px; background-color:RGB(171,168,168); font-weight:bold;">
				�� �� �� <br>
				<input type="checkbox" style="zoom:1.5;" name='cons_type' <%if(String.valueOf(ht.get("CONS_TYPE")).equals("1")){ %>checked<%} %> value='1'/><span style="font-size:20px;">�ε��� / </span>
				<input type="checkbox" style="zoom:1.5;" name='cons_type' <%if(String.valueOf(ht.get("CONS_TYPE")).equals("2")){ %>checked<%} %> value='2'/><span style="font-size:20px;">�μ���</span>
			</td>
			<td style="width: 50%; text-align:center; font-size:15px; background-color:RGB(159,177,5); color:white; font-weight:bold; ">Pick amazoncar! We'll pick you up.</td>
		</tr>
	</table>
	
	<table style="margin: 0% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" style="width:10%">����ȣ</td>
			<td style="width:20%">
				<%=ht.get("RENT_L_CD")%>
			</td>
			<td class="td-header" style="width:10%">������</td>
			<td style="width:20%">
				<%=ht.get("DEPT_NM")%>
			</td>
			<td class="td-header" style="width:10%">����</td>
			<td style="width:20%">
				<%=ht.get("CONS_CAU")%>
			</td>
		</tr>
	</table>
	<table style="margin: 3px 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" style="width:10%">������ȣ</td>
			<td style="width:12%">
				<%=ht.get("CAR_NO")%>
			</td>
			<td class="td-header" style="width:10%">�� ��</td>
			<td style="width:30%">
				<%=ht.get("CAR_NM")%>
			</td>
			<td class="td-header" style="width:10%">����Ÿ�</td>
			<td style="width:20%%">
				���<input type="text" style="width: 25%; border: none;" name='start_km' value='<%=ht.get("START_KM")%>' />km/����<input type="text" style="width: 25%; border: none;" name='end_km' value='<%=ht.get("END_KM")%>' />km
			</td>
		</tr>
	</table>
	
	<table style="margin: 3px 2% 0% 2% ;width: 95%;">
		<tr>
			<td rowspan="15" colspan="6"><img src='https://fms1.amazoncar.co.kr/acar/images/deli_taking.jpg' align=absmiddle style="width:500px; height:400px;"></td>
			<td style="background-color:RGB(171,168,168); font-weight: bold;" colspan="2">ǥ�ñ�ȣ</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">�� ��</td>
			<td style="width:15%">B</td>
		</tr>
			<td class="td-header" style="width:10%">�� ó</td>
			<td style="width:15%">S</td>
		<tr>
			<td class="td-header" style="width:10%">�� ��</td>
			<td style="width:15%">U</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">�̻�(����)</td>
			<td style="width:15%">P</td>
		</tr>
		<tr>
			<td style="background-color:RGB(171,168,168); font-weight: bold;" colspan="2">��ġ��ǰ</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">�����</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_a' <%if(String.valueOf(ht.get("CHK_A")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_a' <%if(String.valueOf(ht.get("CHK_A")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">��뼳��</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_b' <%if(String.valueOf(ht.get("CHK_B")).equals("Y")){%>checked<%}%> />Y 
				<input type="checkbox" value='N' name='chk_b' <%if(String.valueOf(ht.get("CHK_B")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">������</td>
			<td style="width:15%">
				<input type="checkbox" value='N' name='chk_c' <%if(String.valueOf(ht.get("CHK_C")).equals("N")){%>checked<%}%> />N 
				<input type="checkbox" value='1' name='chk_c' <%if(String.valueOf(ht.get("CHK_C")).equals("1")){%>checked<%}%> />1 
				<input type="checkbox" value='2' name='chk_c' <%if(String.valueOf(ht.get("CHK_C")).equals("2")){%>checked<%}%> />2
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">����Ű</td>
			<td style="width:15%">
				<input type="checkbox" value='N' name='chk_d' <%if(String.valueOf(ht.get("CHK_D")).equals("N")){%>checked<%}%> />N 
				<input type="checkbox" value='1' name='chk_d' <%if(String.valueOf(ht.get("CHK_D")).equals("1")){%>checked<%}%> />1 
				<input type="checkbox" value='2' name='chk_d' <%if(String.valueOf(ht.get("CHK_D")).equals("2")){%>checked<%}%> />2
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">��Ű</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_e' <%if(String.valueOf(ht.get("CHK_E")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_e' <%if(String.valueOf(ht.get("CHK_E")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">��Ű����</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_f' <%if(String.valueOf(ht.get("CHK_F")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_f' <%if(String.valueOf(ht.get("CHK_F")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">�ﰢ��</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_g' <%if(String.valueOf(ht.get("CHK_G")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_g' <%if(String.valueOf(ht.get("CHK_G")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">����</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_h' <%if(String.valueOf(ht.get("CHK_H")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_h' <%if(String.valueOf(ht.get("CHK_H")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:10%">�ٺ���</td>
			<td style="width:15%">
				<input type="checkbox" value='Y' name='chk_i' <%if(String.valueOf(ht.get("CHK_I")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_i' <%if(String.valueOf(ht.get("CHK_I")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:8%">�� ��</td>
			<td colspan="2" style="width:27%">
				<input type="checkbox" name='chk_r' value='1' <%if(String.valueOf(ht.get("CHK_R")).equals("1")){%>checked<%}%> />Full
				<input type="checkbox" name='chk_r' value='2' <%if(String.valueOf(ht.get("CHK_R")).equals("2")){%>checked<%}%> />3/4
				<input type="checkbox" name='chk_r' value='3' <%if(String.valueOf(ht.get("CHK_R")).equals("3")){%>checked<%}%> />2/4
				<input type="checkbox" name='chk_r' value='4' <%if(String.valueOf(ht.get("CHK_R")).equals("4")){%>checked<%}%> />1/4
				<input type="checkbox" name='chk_r' value='5' <%if(String.valueOf(ht.get("CHK_R")).equals("5")){%>checked<%}%> />E
			</td>
			<td class="td-header" style="width:10%">����ǰ ����</td>
			<td colspan="2" style="width:20%">
				<input type="text" style="width:90%; border: none;" name='valuables' value='<%=ht.get("VALUABLES")%>'/> 
			</td>
			<td class="td-header" style="width:10%">��Ÿ</td>
			<td>
				<input type="text" style="width:90%; border: none;" name='chk_j' value='<%=ht.get("CHK_J")%>' />
			</td>
		</tr>
	</table>
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" style="width:12%">�Ȱ溸����</td>
			<td class="td-header" style="width:12%">�۷κ�ڽ�</td>
			<td class="td-header" style="width:12%">��Ȧ��</td>
			<td class="td-header" style="width:12%">�߾��ֹܼڽ�</td>
			<td class="td-header" style="width:12%">�ʹڽ�</td>
			<td class="td-header" style="width:12%;font-size: 8pt;">���¼��ֹܼڽ�</td>
			<td class="td-header" style="width:12%">���¼��ʹڽ�</td>
			<td class="td-header" style="width:12%">Ʈ��ũ</td>
		</tr>
		<tr>
			<td>
				<input type="checkbox" value='Y' name='chk_s' <%if(String.valueOf(ht.get("CHK_S")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_s' <%if(String.valueOf(ht.get("CHK_S")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_t' <%if(String.valueOf(ht.get("CHK_T")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_t' <%if(String.valueOf(ht.get("CHK_T")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_u' <%if(String.valueOf(ht.get("CHK_U")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_u' <%if(String.valueOf(ht.get("CHK_U")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_v' <%if(String.valueOf(ht.get("CHK_V")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_v' <%if(String.valueOf(ht.get("CHK_V")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_w' <%if(String.valueOf(ht.get("CHK_W")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_w' <%if(String.valueOf(ht.get("CHK_W")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_x' <%if(String.valueOf(ht.get("CHK_X")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_x' <%if(String.valueOf(ht.get("CHK_X")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_y' <%if(String.valueOf(ht.get("CHK_Y")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_y' <%if(String.valueOf(ht.get("CHK_Y")).equals("N")){%>checked<%}%> />N
			</td>
			<td>
				<input type="checkbox" value='Y' name='chk_z' <%if(String.valueOf(ht.get("CHK_Z")).equals("Y")){%>checked<%}%> />Y
				<input type="checkbox" value='N' name='chk_z' <%if(String.valueOf(ht.get("CHK_Z")).equals("N")){%>checked<%}%> />N
			</td>
		</tr>
	</table>
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" style="width:15%">���ž�</td>
			<td class="td-header" style="width:23%">�ܰ� û������</td>
			<td class="td-header" style="width:15%">Ÿ�̾� �����</td>
			<td class="td-header" style="width:23%">Ÿ�̾� �������</td>
			<td class="td-header" style="width:23%">�ǳ� û������</td>
		</tr>
		<tr>
			<td style="width:15%">
				<input type="checkbox" name='chk_k' value='1'  <%if(String.valueOf(ht.get("CHK_K")).equals("1")){%>checked<%}%>/>����
				<input type="checkbox" name='chk_k' value='2'  <%if(String.valueOf(ht.get("CHK_K")).equals("2")){%>checked<%}%>/>����
			</td>
			<td style="width:23%">
				<input type="checkbox" name='chk_l' value='1' <%if(String.valueOf(ht.get("CHK_L")).equals("1")){%>checked<%}%> />����
				<input type="checkbox" name='chk_l' value='2' <%if(String.valueOf(ht.get("CHK_L")).equals("2")){%>checked<%}%> />����
				<input type="checkbox" name='chk_l' value='3' <%if(String.valueOf(ht.get("CHK_L")).equals("3")){%>checked<%}%> />�����
			</td>
			<td style="width:15%">
				<input type="checkbox" name='chk_m' value='1' <%if(String.valueOf(ht.get("CHK_M")).equals("1")){%>checked<%}%> />����<input type="checkbox" name='chk_m' value='2' <%if(String.valueOf(ht.get("CHK_M")).equals("2")){%>checked<%}%> />�����
			</td>
			<td style="width:23%">
				<input type="checkbox" name='chk_n' value='1' <%if(String.valueOf(ht.get("CHK_N")).equals("1")){%>checked<%}%> />����
				<input type="checkbox" name='chk_n' value='2' <%if(String.valueOf(ht.get("CHK_N")).equals("2")){%>checked<%}%> />����
				<input type="checkbox" name='chk_n' value='3' <%if(String.valueOf(ht.get("CHK_N")).equals("3")){%>checked<%}%> />��ȯ
			</td>
			<td style="width:23%">
				<input type="checkbox" name='chk_o' value='1' <%if(String.valueOf(ht.get("CHK_O")).equals("1")){%>checked<%}%> />����
				<input type="checkbox" name='chk_o' value='2' <%if(String.valueOf(ht.get("CHK_O")).equals("2")){%>checked<%}%> />����
				<input type="checkbox" name='chk_o' value='3' <%if(String.valueOf(ht.get("CHK_O")).equals("3")){%>checked<%}%> />û�ҿ�
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:15%">��Ÿ �������<input type='checkbox' name='chk_p' /></td>
			<td colspan="4">
				<input type='text' style='width: 90%; border: none;' name='chk_q' value='<%=ht.get("CHK_Q") %>' />
			</td>
		</tr>
	</table>
	
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" rowspan="2" colspan="2" style="width:45%; padding: 5px;">��� ��ȣǥ�� ������ �ջ� ���� �� ���� ��ǰ�� �̻������� Ȯ���ϰ� ������ ���� �ε���.</td>
			<td class="td-header">�ε�/�μ� ����</td>
			<td style='text-align: left;'>
				<input type="text" style="height:90%; border: none;" name='cons_client_nm' value='<%=ht.get("CONS_CLIENT_NM")%>'> (��)
			</td>
		</tr>
		<tr>
			<td class="td-header">����ó</td>
			<td style='text-align: left;'><input type="text" style="height:90%; border: none;" name='cons_client_tel' value='<%=ht.get("CONS_CLIENT_TEL")%>'></td>
		</tr>
		<tr>
			<td colspan="2">
				<%
					String reg_ymd 		= String.valueOf(ht.get("REG_YMD"));
					String reg_year 		= reg_ymd.substring(0, 4);
					String reg_month	= reg_ymd.substring(4, 6);
					String reg_date 		= reg_ymd.substring(6, 8);
					
					String reg_time 		= String.valueOf(ht.get("REG_TIME"));
					String reg_hour		= reg_time.substring(0, 2);
					String reg_minute 	= reg_time.substring(2, 4);
				%>
				<span><%=reg_year %>�� <%=reg_month%>�� <%=reg_date%>��</span>
				(<input type="text" style="height:90%; width:10%; border: none;" value='<%=reg_hour%>'>�� <input type="text" style="height:90%; width:10%; border: none;" value='<%=reg_minute%>'>��)
				<input type='hidden' name='reg_time' value='<%=ht.get("REG_TIME")%>' />
			</td>
			<td class="td-header">����ڿ��� ����</td>
			<td style='text-align: left;'><input type="text" style="height:90%; border: none;" name='cons_relationship' value='<%=ht.get("CONS_RELATIONSHIP")%>'></td>
		</tr>
	</table>
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" style="width:10%">���ǻ���</td>
			<td style="width:90%; text-align:left">
				�� ��� ��ȣǥ�� ���� �� �ջ�� ������ �� ���� �� Ȯ���Ͽ� �ֽʽÿ�.<br>
				�� ��� ���� �� ���� �� ���� ������� �ջ� ���� �� ���� ��ǰ�� �̻������� Ȯ���ϰ� �˴ϴ�.<br>
				�� �ջ�� ������ �߰�, Ȯ��ǰų� ��ǰ ���� �н��� ��� ����ڿ��� ���󺹱� ����� û���մϴ�.<br>
				&nbsp;&nbsp; (��, �ڱ��������ظ�å������ �����Ͻ� ��쿡�� ��å�� ���� ������ û���մϴ�. -��ǰ�� ����)
			</td>
		</tr>
	</table>
	
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td class="td-header" colspan="5">�����(�̿���)</td>
			<td class="td-header" colspan="5">(��)�Ƹ���ī</td>
		</tr>
		<tr>
			<td class="td-header" colspan="2">��ȣ/����</td>
			<td colspan="3">
				<%=ht.get("FIRM_NM")%>
			</td>
			<td class="td-header" rowspan="2">�����</td>
			<td class="td-header">����</td>
			<td colspan="3">
				<%=ht.get("ACAR_MNG")%>
			</td>
		</tr>
		<tr>
			<td class="td-header" colspan="2">����ڹ�ȣ/�������</td>
			<td colspan="3" style="width:30%">
				<%=AddUtil.ChangeEnt_no( String.valueOf(ht.get("FIRM_SSN")) )%>
			</td>
			<td class="td-header">����ó</td>
			<td colspan="3">
				<%=ht.get("ACAR_TEL")%>
			</td>
		</tr>
		<tr>
			<td class="td-header" style="width:20%" colspan="2">�� ��</td>
			<td colspan="3" style="width:40%;" class="firm_addr">
				<%=ht.get("FIRM_ADDR")%>
			</td>
			<td class="td-header" rowspan="3">���Ź��</td>
			<td class="td-header">��ȣ</td>
			<td colspan="3">
				<%=ht.get("OFF_NM")%>
			</td>
		</tr>
		<tr>
			<td class="td-header" colspan="2">�� ȭ</td>
			<td colspan="3">
				<%=ht.get("FIRM_TEL")%>
			</td>
			<td class="td-header">����</td>
			<td colspan="3">
				<%=ht.get("OFF_DRV")%>
			</td>
		</tr>	
		<tr>
			<td class="td-header" colspan="2">������/H.P</td>
			<td colspan="3">
				<%=ht.get("FIRM_M_TEL")%>
			</td>
			<td class="td-header">����ó</td>
			<td colspan="3">
				<%=ht.get("OFF_DRV_TEL")%>
			</td>
		</tr>	
	</table>
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="width:50%; border-left: 0px;border-top: 0px;border-bottom: 0px;;">
				<img src='https://fms1.amazoncar.co.kr/acar/images/logo_1.png' align=right style="">
			</td>
			<td style="width:50%; border:0px; text-align:left; font-weight:bold; font-size:11px;">
				&nbsp;<span style="font-size:20px">(��)�Ƹ���ī</span><br>
			   	&nbsp;�� �� : ����� �������� �ǻ���� 8 ��ȯ��º��� 8��<br>
			   	&nbsp;TEL : 02)392-4242(��������)<br>
			   	&nbsp;FAX : 02)782-0826(��������)<br>
			   	&nbsp;http://www.amazoncar.co.kr
			</td>
		</tr>
	</table>
	<div>
		<input type='button' value='���� �׽�Ʈ' onclick='javascript: onSave();'/>
	</div>
	</form>
<!-- <p style="page-break-before: always;">
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/left-front.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/front.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/right-front.png' align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/left.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/center.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/right.png' align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/left-back.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/back.png' align=center style="height:355px"></td>
		<td><img src='https://fms1.amazoncar.co.kr/acar/images/right-back.png' align=center style="height:355px"></td>
	</tr>
</table>
</p> -->

<%if(String.valueOf(ht.get("B_TRF_YN")).equals("Y")){ %>
<p style="page-break-before: always;">
	<table style="margin: 3% 2% 0% 2%; width: 95%;">
		<tr>
			<td style="font-size:30px; font-weight:bold; padding:2% 0% 2% 0%;">ä�� �絵 ������ �� ������</td>
		</tr>
	</table>
	<table style="margin: 5% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:18%">����ó(ä����)</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:82%">
				<%=ht.get("INS_COM_NM")%> ����
			</td>
		</tr>
	</table>

	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px; padding: 2% 0% 2% 0%; width:18%" rowspan="2">�߽���(ä����)</td>
			<td style="font-size:15px; padding: 2% 0% 2% 0% 0% 2% 0%;width:12%;">����/��ȣ</td>
			<td style="font-size:16px; padding: 2% 0% 2% 0%; width:70%">
				<%=ht.get("FIRM_NM")%> (<%=ht.get("FIRM_SSN") %>)
			</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%;">�ּ�</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%;">
				(<%=ht.get("FIRM_ZIP")%>) <%=ht.get("FIRM_ADDR")%> 
				<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("2")){ %>
					<%=ht.get("FIRM_NM")%> ��ǥ : 
				<%} %>
				<%=ht.get("CLIENT_NM")%></td>
		</tr>
	</table>
	
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:18%" rowspan="2">ä���� ����</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:12%">����</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">�Ʒ� ��� ���� �����Ⱓ ������ ������(�����)</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%;">�ݾ�</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%;">
				<%=ht.get("INS_REQ_AMT_HAN")%>�� 
				(&#92;<%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_REQ_AMT")))%>)
			</td>
		</tr>
	</table>

	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:18%" rowspan="2">�������</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:12%">������ȣ</td>
			<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%">
				<%=ht.get("AC_CAR_NO")%>
			</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�������</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:50%">
				<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%>
			</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
			<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%">
				<%=ht.get("AC_CAR_NM")%>
			</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�����Ⱓ</td>
			<td style="font-size:13px;padding:2% 0% 2% 0%; width:50%">
				<%=AddUtil.ChangeDate3(String.valueOf(ht.get("INS_USE_ST"))) %> ~ <%=AddUtil.ChangeDate3(String.valueOf(ht.get("INS_USE_ET")))%>
			</td>
		</tr>
	</table>

	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:18%" rowspan="2">�絵�� ����</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:12%">����</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:70%">(��)�Ƹ���ī���� ���� ������ ������ ������(�����) ä�� ������ û�� �� ������ ���� �� �Ǹ�</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ݾ�</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">
				�ϱ� <%=ht.get("INS_REQ_AMT_HAN")%> ���� (&#92;<%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_REQ_AMT"))) %>)
			</td>
		</tr>
	</table>
	
	<table style="margin: 5% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:15px; text-align:left; border:0px; line-height:200%;">
				��� ä���� ����(�Ʒ� �絵��)�� �Ʒ� ����� (��)�Ƹ���ī���� ��� ������(�����)ä���� û�� �� ������ ���� �� �Ǹ��� ���������� Ȯ�������� �絵 �� �³��Ͽ����� �����մϴ�.
			</td>
		</tr>
	</table>

	<table style="margin: 5% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:15px; border:0px;" id="date2"></td>
		</tr>
	</table>
	
	<table style="margin: 2% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%" rowspan="2">�絵��</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%">
				<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("2")){ %>
					<%=ht.get("FIRM_NM")%> ��ǥ : 
				<%} %>
				<%=ht.get("CLIENT_NM")%> &nbsp;&nbsp;&nbsp;(��)
			</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">
				<%if(String.valueOf(ht.get("CLIENT_ST")).equals("2")){%>
					�������
				<%}else{%>
					����ڵ�Ϲ�ȣ
				<%}%>
			</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">
				<%=AddUtil.ChangeEnt_no(String.valueOf(ht.get("FIRM_SSN")))%>
			</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ּ�</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%;" colspan="3" >
				(<%=ht.get("FIRM_ZIP")%>) <%=ht.get("FIRM_ADDR")%>
			</td>
		</tr>
	</table>
	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%" rowspan="2">�����</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%;">
				<div style='position: relative;'>
				�ֽ�ȸ�� �Ƹ���ī 
				<span>&nbsp;&nbsp;&nbsp;(��)</span>
					<img src='https://fms1.amazoncar.co.kr/acar/images/3c7kR522I6Sqs_70.gif' style="position: absolute; top:-20px; left: 220px;">
				</div>
			</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">���ε�Ϲ�ȣ</td>
			<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">115611-0019610</td>
		</tr>
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ּ�</td>
			<td style="font-size:16px;padding:2% 0% 2% 0%;" colspan="3" >(07236) ����� �������� �ǻ���� 8 ��ȯ��º��� 8��</td>
		</tr>
	</table>

	<table style="margin: 1% 2% 0% 2% ;width: 95%;">
		<tr>
			<td style="font-size:16px;padding:2% 0% 2% 0%; text-align:left; border:0px">�� �������� ���� ��� ���Ǹ� �����̰�, �� ��� �δ��� ���� �����Դϴ�.</td>
		</tr>
	</table>
</p>
<%} %>
</div>
</body>
</html>


