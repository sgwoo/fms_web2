<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.user_mng.*,java.time.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%

	UserMngDatabase umd = UserMngDatabase.getInstance();

// 	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
// 	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
// 	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
// 	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
// 	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
// 	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
// 	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
// 	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
// 	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
// 	int count =0;
	
// 	Vector vt = ln_db.getAlinkDeliReceiptList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);	
// 	int vt_size = vt.size();
	String cons_no = request.getParameter("cons_no")==null?	"":request.getParameter("cons_no");
	String seq = request.getParameter("seq")==null?	"":request.getParameter("seq");
	
	Hashtable ht_cons = cs_db.getConsignment_Links(cons_no, AddUtil.parseInt(seq));
	
// 	System.out.println(ht_cons.toString());
	
// 	System.out.println(">>>>>>>>>>>>>>>>>>>>>");
	
	String rent_l_cd = String.valueOf(ht_cons.get("RENT_L_CD")); // ����ȣ
	String dept_nm = String.valueOf(ht_cons.get("DEPT_NM")); // ������
	String cons_cau = String.valueOf(ht_cons.get("CONS_CAU")); // ����
	String car_no = String.valueOf(ht_cons.get("CAR_NO")); // ������ȣ
	String car_nm = String.valueOf(ht_cons.get("CAR_NM")); // ����
	String acar_mng = String.valueOf(ht_cons.get("ACAR_MNG")); // �Ƹ���ī �����
	String acar_tel = String.valueOf(ht_cons.get("ACAR_TEL")); // �Ƹ���ī ����� ����ó
	String off_nm = String.valueOf(ht_cons.get("OFF_NM")); // Ź�۾�ü��
	String firm_nm = String.valueOf(ht_cons.get("FIRM_NM")); // �̿��� ��ȣ
	String firm_ssn = String.valueOf(ht_cons.get("FIRM_SSN")); // �̿��� ����ڹ�ȣ(�������)
	String firm_addr = String.valueOf(ht_cons.get("FIRM_ADDR")); // �̿��� �ּ�
	String firm_tel = String.valueOf(ht_cons.get("FIRM_TEL")); // �̿��� ��ȭ
	String firm_m_tel = String.valueOf(ht_cons.get("FIRM_M_TEL")); // �̿��� H.P
	
	String cons_no_seq = cons_no.concat(seq);
	
	Hashtable ht_cons2 = cs_db.getConsignment_Links2(cons_no_seq);
	
	String off_drv = String.valueOf(ht_cons2.get("OFF_DRV"));
	String off_drv_tel = String.valueOf(ht_cons2.get("OFF_DRV_TEL"));
	
	String b_trf_yn = String.valueOf(ht_cons2.get("B_TRF_YN")); // ����
	String client_st = String.valueOf(ht_cons2.get("CLIENT_ST")); // �� ����
	String ins_com_nm = String.valueOf(ht_cons2.get("INS_COM_NM")); // ä���ڸ�
	String firm_zip = String.valueOf(ht_cons2.get("FIRM_ZIP")); // �����ȣ
	String ins_req_amt = String.valueOf(ht_cons2.get("INS_REQ_AMT")); // �ݾ�
	String ins_req_amt_han = String.valueOf(ht_cons2.get("INS_REQ_AMT_HAN")); // �ݾ� �ѱ�
	String accid_dt = String.valueOf(ht_cons2.get("ACCID_DT")); // �������
	String ins_use_st = String.valueOf(ht_cons2.get("INS_USE_ST")); // ������
	String ins_use_et = String.valueOf(ht_cons2.get("INS_USE_ET")); // ������
	String ac_car_no = String.valueOf(ht_cons2.get("AC_CAR_NO")); // ���������ȣ
	String ac_car_nm = String.valueOf(ht_cons2.get("AC_CAR_NM")); // ���������
	String client_nm = String.valueOf(ht_cons2.get("CLIENT_NM")); // ����
	
	
// 	System.out.println(ht_cons2.toString());
	
// 	System.out.println(Long.toString(System.currentTimeMillis()));
	
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>

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
.style1 {
	font-size:25px;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
.style3{
	font-size:0.8em;}
.style4{
	font-size:0.9em;}
.style5{
	text-decoration:underline;
	text-align:right;
	padding-right:20px;
	}
.style6{
	font-size:1.1em;}

.style7{
	text-decoration:underline;
	}
		
checkbox{padding:0px;}

table {text-align:left; border-collapse:collapse; vertical-align:middle;}
.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc table td {border:1px solid #000000; height:13px;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc1 table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc1 table td {border:1px solid #000000; height:13px; padding:3px;}
.doc1 table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
p {padding:1px 0 0 0;}
.doc1 table td.pd{padding:3px;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
.doc1 table th.ht{height:60px;}

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;padding:20px 0; }
.doc_a table td.nor {padding:5px 5px 5px 5px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}

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
.td-header {
	background-color:RGB(159,177,5);
	font-weight:bold;
	height: 10px;
}
</style>

<body onload="onloadData()">
<div class="a4" style="width:800px;">
<table style="margin:2% 2% 1% 2%; width: 95%;">
	<tr>
		<td style="width: 50%; text-align:center; font-size:30px; background-color:RGB(171,168,168); font-weight:bold;">�� �� �� <br><input type="checkbox" style="zoom:1.5;"/><span style="font-size:20px;">�ε��� / </span><input type="checkbox" style="zoom:1.5;"/><span style="font-size:20px;">�μ���</span></td>
		<td style="width: 50%; text-align:center; font-size:15px; background-color:RGB(159,177,5); color:white; font-weight:bold; ">Pick amazoncar! We'll pick you up.</td>
	</tr>
</table>

<table style="margin: 0% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">����ȣ</td>
		<td style="width:20%"><%=rent_l_cd%></td>
		<td class="td-header" style="width:10%">������</td>
		<td style="width:20%"><%=dept_nm%></td>
		<td class="td-header" style="width:10%">����</td>
		<td style="width:20%"><%=cons_cau%></td>
	</tr>
</table>
<table style="margin: 3px 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">������ȣ</td>
		<td style="width:12%"><%=car_no%></td>
		<td class="td-header" style="width:10%">�� ��</td>
		<td style="width:30%"><%=car_nm%></td>
		<td class="td-header" style="width:10%">����Ÿ�</td>
		<td style="width:20%%">���<input type="text" style="width: 25%;"></input>km/����<input type="text" style="width: 25%;"></input>km</td>
	</tr>
</table>

<table style="margin: 3px 2% 0% 2% ;width: 95%;">
	<tr>
		<td rowspan="15" colspan="6"><img src=/acar/images/deli_taking.jpg align=absmiddle style="width:500px; height:400px;"></td>
		<td style="" colspan="2">ǥ�ñ�ȣ</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�� ��</td>
		<td style="width:15%">B</td>
	</tr>
		<td class="td-header" style="width:10%">�� ó</td>
		<td style="width:15%">B</td>
	<tr>
		<td class="td-header" style="width:10%">�� ��</td>
		<td style="width:15%">B</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�̻�(����)</td>
		<td style="width:15%">B</td>
	</tr>
	<tr>
		<td style="" colspan="2">��ġ��ǰ</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�����</td>
		<td style="width:15%"><input type="checkbox">Y <input type="checkbox">N</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">��뼳��</td>
		<td style="width:15%"><input type="checkbox">Y <input type="checkbox">N</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">������</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">����Ű</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">��Ű</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">��Ű����</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�ﰢ��</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">����</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�ٺ���</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">�� ��</td>
		<td colspan="2" style="width:25%"><input type="checkbox">Full<input type="checkbox">3/4<input type="checkbox">2/4<input type="checkbox">1/4<input type="checkbox">E</td>
		<td class="td-header" style="width:10%">����ǰ ����</td>
		<td colspan="2" style="width:20%"><input type="text" style="width:90%"></td>
		<td class="td-header" style="width:10%">��Ÿ</td>
		<td style=""></td>
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
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
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
		<td style="width:15%"><input type="checkbox"/>����<input type="checkbox"/>����</td>
		<td style="width:23%"><input type="checkbox"/>����<input type="checkbox"/>����<input type="checkbox"/>�����</td>
		<td style="width:15%"><input type="checkbox"/>����<input type="checkbox"/>�����</td>
		<td style="width:23%"><input type="checkbox"/>����<input type="checkbox"/>����<input type="checkbox"/>��ȯ</td>
		<td style="width:23%"><input type="checkbox"/>����<input type="checkbox"/>����<input type="checkbox"/>û�ҿ�</td>
	</tr>
	<tr>
		<td class="td-header" style="width:15%">��Ÿ �������</td>
		<td colspan="4"></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" rowspan="2" colspan="2" style="width:45%;">��� ��ȣǥ�� ������ �ջ� ���� �� ���� ��ǰ�� �̻������� Ȯ���ϰ� ������ ���� �ε���.</td>
		<td class="td-header">�ε�/�μ� ����</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
	<tr>
		<td class="td-header">����ó</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
	<tr>
		<td colspan="2"><span id="date"></span>(<input type="text" style="height:90%; width:10%;">�� <input type="text" style="height:90%; width:10%;"">��)</td>
		<td class="td-header">����ڿ��� ����</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">���ǻ���</td>
		<td style="width:90%; text-align:left">�� ��� ��ȣǥ�� ���� �� �ջ�� ������ �� ���� �� Ȯ���Ͽ� �ֽʽÿ�.<br>
											        �� ��� ���� �� ���� �� ���� ������� �ջ� ���� �� ���� ��ǰ�� �̻������� Ȯ���ϰ� �˴ϴ�.<br>
											        �� �ջ�� ������ �߰�, Ȯ��ǰų� ��ǰ ���� �н��� ��� ����ڿ��� ���󺹱� ����� û���մϴ�.<br>
											   &nbsp;&nbsp; (��, �ڱ��������ظ�å������ �����Ͻ� ��쿡�� ��å�� ���� ������ û���մϴ�. -��ǰ�� ����)</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" colspan="5">�����(�̿���)</td>
		<td class="td-header" colspan="5">(��)�Ƹ���ī</td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">��ȣ/����</td>
		<td colspan="3"><%=firm_nm%></td>
		<td class="td-header" rowspan="2">�����</td>
		<td class="td-header">����</td>
		<td colspan="3"><%=acar_mng%></td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">����ڹ�ȣ/�������</td>
		<td colspan="3" style="width:30%"><%=AddUtil.ChangeEnt_no(firm_ssn)%></td>
		<td class="td-header">����ó</td>
		<td colspan="3"><%=acar_tel%></td>
	</tr>
	<tr>
		<td class="td-header" style="width:20%" colspan="2">�� ��</td>
		<td colspan="3" style="width:40%;" class="firm_addr"><%=firm_addr%></td>
		<td class="td-header" rowspan="3">���Ź��</td>
		<td class="td-header">��ȣ</td>
		<td colspan="3"><%=off_nm%></td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">�� ȭ</td>
		<td colspan="3"><%=firm_tel%></td>
		<td class="td-header">����</td>
		<td colspan="3"><%=off_drv%></td>
	</tr>	
	<tr>
		<td class="td-header" colspan="2">������/H.P</td>
		<td colspan="3"><%=firm_m_tel%></td>
		<td class="td-header">����ó</td>
		<td colspan="3"><%=off_drv_tel%></td>
	</tr>	
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="width:50%; border-left: 0px;border-top: 0px;border-bottom: 0px;;"><img src=/acar/images/logo_1.png align=right style=""></td>
		<td style="width:50%; border:0px; text-align:left; font-weight:bold; font-size:11px;">&nbsp;<span style="font-size:20px">(��)�Ƹ���ī</span><br>
														   &nbsp;�� �� : ����� �������� �ǻ���� 8 ��ȯ��º��� 8��<br>
														   &nbsp;TEL : 02)392-4242(��������)<br>
														   &nbsp;FAX : 02)782-0826(��������)<br>
														   &nbsp;http://www.amazoncar.co.kr
		</td>
	</tr>
</table>
<p style="page-break-before: always;">
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td><img src=/acar/images/left-front.png align=center style="height:355px"></td>
		<td><img src=/acar/images/front.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right-front.png align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src=/acar/images/left.png align=center style="height:355px"></td>
		<td><img src=/acar/images/center.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right.png align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src=/acar/images/left-back.png align=center style="height:355px"></td>
		<td><img src=/acar/images/back.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right-back.png align=center style="height:355px"></td>
	</tr>
</table>
<%if(b_trf_yn.equals("Y")){ %>
<p style="page-break-before: always;">
<table style="margin: 3% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:30px;font-weight:bold;padding:2% 0% 2% 0%;">ä�� �絵 ������ �� ������</td>
	</tr>
</table>
<table style="margin: 5% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%">����ó(ä����)</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:80%"><%=ins_com_nm%> ����</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">�߽���(ä����)</td>
		<td style="font-size:15px;padding:2% 0% 2% 0% 0% 2% 0%;width:10%;">����/��ȣ</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%"><%=firm_nm%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ּ�</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">(<%=firm_zip%>) <%=firm_addr%> 
																	<%if(!client_st.equals("2")){ %>
																	<%=firm_nm%> ��ǥ : 
																	 <%} %>
																	<%=client_nm%></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">ä���� ����</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">�Ʒ� ��� ���� �����Ⱓ ������ ������(�����)</td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ݾ�</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%"><%=ins_req_amt_han%>�� (&#92;<%=AddUtil.parseDecimal(ins_req_amt)%>)</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">�������</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">������ȣ</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%"><%=ac_car_no%></td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�������</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:50%"><%=AddUtil.ChangeDate2(accid_dt)%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%"><%=ac_car_nm%></td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�����Ⱓ</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:50%"><%=AddUtil.ChangeDate3(ins_use_st) %> ~ <%=AddUtil.ChangeDate3(ins_use_et)%></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">�絵�� ����</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:70%">(��)�Ƹ���ī���� ���� ������ ������ ������(�����) ä�� ������ û�� �� ������ ���� �� �Ǹ�</td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ݾ�</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">�ϱ� <%=ins_req_amt_han%> ���� (&#92;<%=AddUtil.parseDecimal(ins_req_amt) %>)</td>
	</tr>
</table>

<table style="margin: 5% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:15px; text-align:left; border:0px; line-height:200%;">��� ä���� ����(�Ʒ� �絵��)�� �Ʒ� ����� (��)�Ƹ���ī���� ��� ������(�����)ä���� û�� �� ������ ���� �� �Ǹ��� ���������� Ȯ�������� �絵 �� �³��Ͽ����� �����մϴ�.</td>
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
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%"><%if(!client_st.equals("2")){ %>
																	<%=firm_nm%> ��ǥ : 
																	 <%} %>
																	 <%=client_nm%> &nbsp;&nbsp;&nbsp;(��)</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%"><%if(client_st.equals("2")){%>�������<%}else{%>����ڵ�Ϲ�ȣ<%}%></td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%"><%=AddUtil.ChangeEnt_no(firm_ssn)%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">�ּ�</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%;" colspan="3" >(<%=firm_zip%>) <%=firm_addr%></td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%" rowspan="2">�����</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">����</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%;">�ֽ�ȸ�� �Ƹ���ī <span style="z-index: 2;position: absolute;">&nbsp;&nbsp;&nbsp;(��)</span><img src='/acar/images/3c7kR522I6Sqs_70.gif' style="position: absolute;margin-left: 15px;margin-top: -18px;z-index:1;"></td>
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
<%} %>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
	function onloadData() {
		
		var today = new Date();
		
		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var date = today.getDate();
		var day = today.getDay();
		
		var yyyymmdd = year + "�� " + month + "�� " + date + "��";

		$("#date").text(yyyymmdd+" ");
		$("#date2").text(yyyymmdd);
		
		
	}
	

</script>
</body>
</html>


