<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.insur.*,acar.user_mng.*"%>

<%
	InsDatabase c_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String current_date 	= AddUtil.getDate3();

	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	
	
	//�Է°�
	String r_var1 = request.getParameter("r_var1")	==null? "":request.getParameter("r_var1");
	String r_var2 = request.getParameter("r_var2")	==null? "":request.getParameter("r_var2");
	String r_var3 = request.getParameter("r_var3")	==null? "":request.getParameter("r_var3");
	String r_var4 = request.getParameter("r_var4")	==null? "":request.getParameter("r_var4");
	String r_var5 = request.getParameter("r_var5")	==null? "":request.getParameter("r_var5");
	String r_var6 = request.getParameter("r_var6")	==null? "":request.getParameter("r_var6");
	String r_var7 = request.getParameter("r_var7")	==null? "":request.getParameter("r_var7");
	String r_var8 = request.getParameter("r_var8")	==null? "":request.getParameter("r_var8");
	String r_var9 = request.getParameter("r_var9")	==null? "":request.getParameter("r_var9");
	String r_var10 = request.getParameter("r_var10")	==null? "":request.getParameter("r_var10");
	String r_var11 = request.getParameter("r_var11")	==null? "":request.getParameter("r_var11");
	String r_var12 = request.getParameter("r_var12")	==null? "":request.getParameter("r_var12");
	String r_var13 = request.getParameter("r_var13")	==null? "":request.getParameter("r_var13");
	
	String client_id = var5;
	String user_id = var1;
	String car_mng_id = var3;
	String com_emp_yn= "";

	Vector client_vt = c_db.getIjwList2(client_id, car_mng_id, com_emp_yn, "" );		
	int client_vt_size = client_vt.size();	
	
	//�߽��� ����� ���� ��ȸ
	UsersBean user_bean 	= umd.getUsersBean(user_id);		
	
	String car_no ="";
	String car_nm ="";
	String firm_nm = ""; 
	String enp_no = "";
	
	for(int k=0;k<client_vt_size;k++){
		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		if(k==0) {
			car_no = (String)ht.get("CAR_NO");
			car_nm = (String)ht.get("CAR_NM");
			firm_nm = (String)ht.get("FIRM_NM");
			enp_no = (String)ht.get("ENP_NO");
		} else {
			car_no += ", " + (String)ht.get("CAR_NO");
			car_nm += ", " + (String)ht.get("CAR_NM");
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"https://www.w3.org/TR/html4/loose.dtd">
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

input.whitetext		{ text-align:left; font-size : 10pt; background-color:#ffffff; border-color:#ffffff; border-width:0; color:#303030; }
input.whitenum		{ text-align:right; font-size : 10pt; background-color:#ffffff; border-color:#ffffff; border-width:0; color:#303030; }

-->
</style>

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="https://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
<body>
<div align="center">
<form action="" name="form1" method="POST" >
	<input type="hidden" name="var1" value="<%=var1%>">
	<input type="hidden" name="var5" value="<%=var5%>">
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
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">�����<br>(��ȣ/����)</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=firm_nm%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">����ڵ��<br>��ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=AddUtil.ChangeEnp(enp_no)%></td>
		</tr>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">������ȣ</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;" ><%=car_no%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">����</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=car_nm%></td>
		</tr>
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
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px "><input type="radio" name="r_var1" value="Y" <%if(r_var1.equals("Y")){ %>checked<%}%>><br>����</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px ">�����<br>��ȣ</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "><input type="text" name="r_var2" size='20' value='<%=r_var2%>' class=whitetext></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px ">����&����</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:40px;">���������ڵ������� ������ &nbsp;�� 20<input type="text" name="r_var3" size='2' value='<%=r_var3%>' class=whitenum>��&nbsp;<input type="text" name="r_var4" size='2' value='<%=r_var4%>' class=whitenum>��&nbsp;<input type="text" name="r_var5" size='2' value='<%=r_var5%>' class=whitenum>�� ��</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">��� ����� ������ ��� �ڵ��������� ���������ڵ����������� ���� ��û�մϴ�.</td>
	</tr>
	<tr>
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px; "><input type="radio" name="r_var1" value="N" <%if(r_var1.equals("N")){ %>checked<%}%>><br>�̰���</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px; ">�����<br>��ȣ</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "><input type="text" name="r_var6" size='20' value='<%=r_var6%>' class=whitetext></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px; ">����&����</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; font-size:14px; ">&nbsp; ������  �� 20<input type="text" name="r_var7" size='2' value='<%=r_var7%>' class=whitenum>��&nbsp;<input type="text" name="r_var8" size='2' value='<%=r_var8%>' class=whitenum>��&nbsp;<input type="text" name="r_var9" size='2' value='<%=r_var9%>' class=whitenum>�� �� ���� <br>
		&nbsp; ������ �� 20<input type="text" name="r_var10" size='2' value='<%=r_var10%>' class=whitenum>��&nbsp;<input type="text" name="r_var11" size='2' value='<%=r_var11%>' class=whitenum>��&nbsp;<input type="text" name="r_var12" size='2' value='<%=r_var12%>' class=whitenum>�� �� ����</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">��� ����� ������ ��� �Ⱓ�� ���������ڵ������� �̰����� ��û�մϴ�.</td>
	</tr>
</table>
<div style="width:560px; margin-top:60px">
	<span style="text-align: center; font-size: 19px;"><%=current_date%></span>
</div>
<div style="width:306px; margin-top:50px; text-align: right; display:inline-block; ">
	<span style="font-size: 17px;">�����(��û��)</span>
</div>
<div style="width:284px; margin-top:70px; text-align: right; display:inline-block; margin-right: 30px; ">
    <input type="text" name="r_var13" size='30' value='<%=r_var13%>' class=whitetext>
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

<script>
function save(){	
	var fm = document.form1;
	if(fm.r_var1[0].checked == false && fm.r_var1[1].checked == false){ alert('���������ڵ������� ���Կ��θ� �����Ͻʽÿ�.'); return; }
	fm.action = 'confirm_template5.jsp';	
	fm.target = "_self";
	fm.submit();
}
</script>
