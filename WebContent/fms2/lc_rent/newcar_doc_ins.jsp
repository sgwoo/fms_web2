<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.insur.*,acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%
	InsDatabase c_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();


	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String id1 = request.getParameter("id1")==null?"":request.getParameter("id1");
	String id2 = request.getParameter("id2")==null?"":request.getParameter("id2");
	
	if(client_id.equals("") && !id1.equals("")) 	client_id = id1;
	if(user_id.equals("") && !id2.equals("")) 	user_id = id2;

	
	Vector client_vt = c_db.getIjwList(client_id, rent_l_cd);		
	int client_vt_size = client_vt.size();	
	
	
	//�߽��� ����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);		
	
	String car_no ="";
	String car_nm ="";
	
	for(int k=0;k<client_vt_size;k++){
		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		if(k==0) {
			car_no = (String)ht.get("CAR_NO");
			car_nm = (String)ht.get("CAR_NM");
		} else {
			car_no += ", " + (String)ht.get("CAR_NO");
			car_nm += ", " + (String)ht.get("CAR_NM");
		}
	}
	

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>������ ���� �ڵ��� ���� ���� ��û��</title>
<script language="JavaScript">
<!--	

//-->
</script>
</head>
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'����',gulim,'����',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em; 
	text-align:center;
	}
.style1 {
	font-size:2.0em;
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

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;padding:20px 0;}
.doc_a table td.nor {padding:10px 10px 2px 10px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}
.cnum table {width:44%; border:1px solid #000000; font-size:0.85em;}
.cnum table td{border:1px solid #000000; height:12px; padding:3px;}
.cnum table th{background-color:#e8e8e8;}

table.doc_s {width:200px; padding:0px;}
table.doc_s td{padding:0px; height:15px;}
table.doc_s th{padding:0px;}
.left {text-align:left;}
.center {text-align:center;}
.right {text-align:right;}
.fs {font-size:0.9em; font-weight:normal;}
.fss {font-size:0.85em;}
.lineh {line-height:12px;}
.name {padding-top:8px; padding-bottom:5px; line-height:18px;}
.ht{height:60px;}
.point{background-color:#e1e1e1; padding-top:3px; font-weight:bold;}
.agree{padding:4px 0 4px 0; }

table.zero { border:0px; font-size:1.15em;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

-->
</style>

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body>
<div align="center">
<form action="" name="form1" method="POST" >
<!--
<script>var pfHeaderImgUrl = '';var pfHeaderTagline = '';var pfdisableClickToDel = 0;var pfHideImages = 0;var pfImageDisplayStyle = 'right';var pfDisablePDF = 0;var pfDisableEmail = 0;var pfDisablePrint = 1;var pfCustomCSS = '';var pfBtVersion='1';(function(){var js, pf;pf = document.createElement('script');pf.type = 'text/javascript';if('https:' == document.location.protocol){js='https://pf-cdn.printfriendly.com/ssl/main.js'}else{js='http://cdn.printfriendly.com/printfriendly.js'}pf.src=js;document.getElementsByTagName('head')[0].appendChild(pf)})();</script><a href="http://www.printfriendly.com" style="color:#6D9F00;text-decoration:none;" class="printfriendly" onclick="window.print();return false;" title="Printer Friendly and PDF"><img style="border:none;-webkit-box-shadow:none;box-shadow:none;" src="http://cdn.printfriendly.com/button-print-blu20.png" alt="Print Friendly and PDF"/></a>
-->
<table width="560" style="font-size:15px;">
	<tr>
   		<td height="60"></td>
	</tr>
	<tr>
		<td colspan="2"><div align="center"><span class=style1 style="text-decoration: underline; text-underline-position:under;">���������ڵ������� ����/�̰��� ��û��</span></div></td>
	</tr>
	<tr>
		<td height="10px"></td>
	</tr>
	<tr>
		<td colspan="2"><div align="center"><span class=style1 style="font-size: 1.5em;">(���λ���� ����)</span></div></td>
	</tr>
	<tr>
   		<td height=34></td>
	</tr>
	<tr>
		<td width=48% style="font-size:16px;">�� ��û��/����ڵ���</td>
	</tr>
</table>
<table width="560" style="font-size:15px;">
	<% if(client_vt_size > 0) { %>
		<%
			for(int k=0;k<1;k++){
			 			Hashtable ht = (Hashtable)client_vt.elementAt(k);
	 	%>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">�����<br>(��ȣ/����)</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=ht.get("FIRM_NM")%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">����ڵ��<br>��ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO")))%></td>
		</tr>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">������ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;" ><%=car_no%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">����</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=car_nm%></td>
		</tr>
		<% }%>
	<% } else { %>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">�����<br>(��ȣ/����)</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">����ڵ��<br>��ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
		</tr>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center; ">������ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">����</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
		</tr>
	<% } %>
	
	<tr>
		<td height=37></td>
	</tr>
	<tr>
		<td colspan="4" style="font-size:16px;">�� ���������ڵ������� �ֿ䳻��</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">���Դ��<br>���� ��<br>�����ڹ���</td>
		<td  colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
		<span>��  ���μ��� ��27����2 �� ���μ�������� ��50����2 ��4�׿� �ǰ�<br>
			    ������¿����� ���������ڵ������迡 �����Ͽ��� ������¿���<br>
			    ���ú���� �պ�ó���� �����մϴ�.<br>
			     �� ���Դ������ (���μ��� ��27����2) : ������¿���<br>
	 		  &nbsp;- �����Һ񼼹� ��1�� ��2�� ��3ȣ�� ���� �¿��ڵ���<br>
			<span>&nbsp;(����, 9�ν� �̻� ����, ȭ������ ���� �� ���� �������� ������ ������� �պ�ó�� ����)</span><br>
			�� ���������ڵ��� ���� ���Խ� ������ ����<br> 
	  		&nbsp;&nbsp;�� ���� ���� �Ҽ��� �ӿ� �Ǵ� ����<br>
	  		&nbsp;&nbsp;�� ��࿡ ���� �ش� ������ ������ ���Ͽ� �����ϴ� ���<br>
	  		&nbsp;&nbsp;�� �ش� ������ ������ ä���� ���� ������ ������ ������</span>
					
 		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">�̰���</td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			�� ���������ڵ������迡 �������� �ƴ��� ��� <br>
 			&nbsp;- �̰��ԱⰣ ���� ���� �ձݺ�����<br>
			�� �̰��Խ� ������ ���� : ������ �� �������� ���谡��<br>
 			&nbsp;<span style="font-size:13px">- �׿� �����ڴ� �ݵ�� ���(�Ƹ���ī)�� ���������� ��쿡�� ��������</span><br>
			
		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center;"><span style="font-size: 13px;">�ϺαⰣ��<br>������<br>���<br>�������ݾ�<br>���</span></span></td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			�� �ش� ������� ��ü�Ⱓ(������ �¿����� ��� �ش� ������� �߿� �����ѱⰣ�� ���Ѵ�) �� �ϺαⰣ�� ���������ڵ������迡 ������ ��� ���μ���
  			 ��27����2 ��2�׿� ���� �������ݾ��� ������ ���Ŀ� ���� ������ �ݾ����� �Ѵ�.<br>
 			= ������¿��� ���ú�� �� ���������� �� (�ش� ��������� ������ ���������ڵ������迡 ������ �ϼ� �� �ش� ��������� ���������ڵ������迡 �ǹ������� �����Ͽ��� �� �ϼ�)<br>
			<span style="font-size:13px;">�� ���μ���(��27����2), ���μ��������(��50����2)���� �����Ͻñ� �ٶ��ϴ�.</span> 
		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">���ǻ���</td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			�� �ڵ������躸�����<br>
			&nbsp;- ���������ڵ������迡 ������ ���� �ڵ����� ���(�Ƹ���ī)�� ������ ��༭
			  ���� ����� ������� �����(������)�� ���� ��(��� ���������ڵ������� ���Խ�
			  ������ ���� ���� ��)�� �����ؼ� �߻��� ��� ���ؼ��� �ڵ������غ��躸���� 
			  �Ұ��մϴ�. (�ڱ��������� �������� ����ڰ� ���� �δ�)
		</td>
	</tr>
</table>
<table width="560" style="font-size:15px;">
	<tr>
   		<td colspan="5" height="30"></td>
	</tr>
	<tr>
		<td colspan="5"></td>
	</tr>
	<tr>
		<td width=48% colspan="5" style="font-size:16px;">�� ���������ڵ������� ����(���� �Ǵ� �̰��� &#10003;)</td>
	</tr>
	<tr>
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px ">��<br>����</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px ">�����<br>��ȣ</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px ">����&����</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:40px;">���������ڵ������� ������ &nbsp;�� 20&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�� ��</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">��� ����� ������ ��� �ڵ��������� ���������ڵ����������� ���� ��û�մϴ�.</td>
	</tr>
	<tr>
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px; ">��<br>�̰���</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px; ">�����<br>��ȣ</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px; ">����&����</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; font-size:14px; ">&nbsp; ������  �� 20&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;�� �� ���� ������ �� 20&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;�� �� ����</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">��� ����� ������ ��� �Ⱓ�� ���������ڵ������� �̰����� ��û�մϴ�.</td>
	</tr>
</table>
<div style="width:560px; margin-top:60px">
	<span style="text-align: center; font-size: 17px;">20 &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��</span>
</div>
<div style="width:376px; margin-top:70px; text-align: right; display:inline-block; ">
	<span style="font-size: 17px;">�����(��û��)</span>
</div>
<div style="width:214px; margin-top:70px; text-align: right; display:inline-block; margin-right: 30px; ">
	<span style="font-size: 17px;">(��)</span>
</div>
<div style="width:560px; margin-top:130px; text-align: left;">
	<span style=" font-size: 20px;"><b>�ֽ�ȸ�� �Ƹ���ī ����</b></span>
</div>

<div style="width:560px; margin-top:30px; text-align: left;">
	<span style=" font-size: 12px;">���λ���� ���������ڵ������� ���Խ�û��(2021.11.23)</span>
</div>
	
</form>
</div>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	

<script>
/* function onprint(){

//factory.printing.header = ""; //��������� �μ�
//factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 8.0; //�ϴܿ���

factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
//alert('�μ�̸����⿡�� 2��, ������ġ�� �´��� Ȯ��! �ȸ´´ٸ� �ͽ��÷η� â���� ���� > ȣȯ�����⼳���� amazoncar.co.kr �߰����� �� ����Ʈ!');
} */
</script>
