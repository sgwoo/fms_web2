<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.cont.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	
	String mail_yn = "";
	
	if(rent_l_cd.equals("") && !var2.equals("")){
		mail_yn = "Y";
		rent_l_cd = var2;		
		rent_mng_id = var4;
		rent_st = var6;		
	}	
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "���� ���", Malgun Gothic, "����", gulim,"����", dotum, arial, helvetica, sans-serif;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 2px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 1px solid #444444;
    font-weight:bold;
    font-size:9pt;
  }
.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}
#wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;}
	
</style>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">
    
	<div id="wrap" style="width:100%;">
		<div>
			<img  style="position:relative;top:20;left:0;" src="/acar/images/logo_1.png" border="0" width="130" >
			<div style="text-align:center;margin-bottom:5px;font-size:17pt;">
				�ڵ��� ���� ���� Ư�� ������
			</div>
		</div>
		<div style="text-align:center;font-size:10pt;margin-bottom:10px;font-weight:normal;">( ���� �Ǻ������� ��쿡�� �ۼ� )</div>
		<div style="text-align:right;font-size:9pt;margin-bottom:10px;">�ڵ��� �뿩�̿� ��༭ �Ϸù�ȣ:__________________________</div>
			<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
				<tr>
					<td class='title' style="border-right:2px solid #444444;border-bottom:2px solid #444444;">��<span style="margin:15px;"></span>��</td>
					<td colspan="4" class='title' style="border-bottom:2px solid #444444;">��&nbsp;��&nbsp;��&nbsp;��</td>
					<td class='title' style="border-bottom:2px solid #444444;">��<span style="margin:15px;"></span>��</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">�Ǻ�����(������)</td>
					<td colspan="4" align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
					<td align='center' style="font-size:9pt;">���λ���ڴ� ��ǥ�ڰ� �Ǻ�����</td>
				</tr>
				 <tr>
					<td class='title' style="border-right:2px solid #444444;">��������</td>
					<td colspan="4" align='center' style="font-size:12pt;">(��)�Ƹ���ī</td>
					<td align='center' >
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;">
					</td>
				</tr> 
				<tr>
					<td rowspan="2" class='title' style="border-right:2px solid #444444;">�����ڹ���</td>
					<td colspan="2" align='center'>���ΰ�</td>
					<td colspan="2">
						&nbsp;�� ���� ������ ��������Ư��<br>
						<input type="checkbox" name="">����
						<span style="margin:10px;"></span>
						<input type="checkbox" name="">�̰���
					</td>
					<td rowspan="5"  style="font-size:9pt;padding-bottom:40px;padding-left:10px;">
					��&nbsp;�ڵ��� �뿩�̿� ����<br>
						<span style="margin:6px;"></span>�����ڹ���<br>
						1. ���� ������ �������� Ư��<br>
						<span style="margin:6px;"></span>���Խ� ���� �������� ��������<br>
						2. ���� ������ �������� Ư��<br>
						<span style="margin:6px;"></span>�̰����� ���ΰ��� ���� �� <br>
						<span style="margin:6px;"></span>���λ���� ���� ���:<br>
						<span style="margin:6px;"></span>[�����]<br>
						<span style="margin:6px;"></span>[������� ������/����]<br>
						<span style="margin:6px;"></span>[����� �������� ����]<br>				
					</td>
				</tr>
				 <tr>
					<td colspan="2" align='center'>����/<br>���λ����<br>��</td>
					<td colspan="2">
						<input type="checkbox" name="">����Ǻ����� 1�� ����<br>
						<input type="checkbox" name="">�κο����� ����<br>
						<input type="checkbox" name="">��Ÿ(���� ����:<span style="margin-left:170px;"></span>)
					</td>
				</tr> 
			 	<tr>
					<td class='title' style="border-right:2px solid #444444;">�����ڿ���</td>
					<td colspan="4" >
						<input type="checkbox" name=""> �� 26���̻�
						<span style="margin:6px;"></span>
						<input type="checkbox" name=""> �� 35���̻�
						<span style="margin:6px;"></span>
						<input type="checkbox" name=""> ��Ÿ ��(<span style="margin:15px;"></span>)���̻�
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">�빰����</td>
					<td colspan="4" >
						<input type="checkbox" name=""> 1���
						<span style="margin:23px;"></span>
						<input type="checkbox" name=""> 2���
						<span style="margin:24px;"></span>
						<input type="checkbox" name=""> ��Ÿ (<span style="margin:15px;"></span>)��
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">�ڱ���������</td>
					<td colspan="4">
						<input type="checkbox" name=""> ������������ݾ� 200����  <span style="margin:19px;"></span><input type="checkbox" name=""> ��Ÿ<br>
						<span style="margin:12px;"></span>�ڱ�δ���� ���ؾ��� 20%<br>
						<span style="margin:12px;"></span>(�ּ�20����~�ִ� 50����)
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">�Ⱓ�����</td>
					<td align='center' colspan="4">
						<div style="float:left;width:90%;text-align: right;"><%=AddUtil.parseDecimal(fee.getIns_total_amt())%></div>
						<div style="float:left;width:10%;">��</div></td>
					<td align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
				</tr> 
				<tr>
					<td width="100" class='title' rowspan="6" style="border-right:2px solid #444444;">������뿩��</td>
					<td width="20" align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td width="50" align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td width="140" align='center' class='title'>��������� ���뿩��</td>
					<td width="160" align='center'>
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getInv_s_amt())%></div> 
						<div style="float:left;width:25%">��</div>
					</td>
					<td align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
				</tr>
				 <tr>
				 	<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td align='center' class='title'>�������</td>
					<td align='center'>
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getIns_s_amt())%></div>
						<div style="float:left;width:25%">��</div>
					</td>
					<td align='center' style="font-size:9pt;">�Ⱓ������12</td>
				</tr>
				
				<tr>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td colspan="2" align='center' class='title'>��������� ���뿩��(���ް�)</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_s_amt())%></div> 
						<div style="float:left;width:25%">��</div>
					</td>
					<td rowspan="3" align='center' style="font-size:9pt;">
						�ڵ��� �뿩�̿�<br>��༭ ������װ� ����
					</td>
				</tr>
				<tr>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td colspan="2" align='center' class='title'>�ΰ���</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_v_amt())%></div>
						<div style="float:left;width:25%">��</div>
					
					</td>
				</tr>
				 <tr>
					<td colspan="3" align='center' class='title' >�հ�</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%></div>
						<div style="float:left;width:25%">��</div> 
					</td>
				</tr> 
				 <tr>
					<td colspan="4" style="height:70;text-align:left;" class='title' >
						<span style="padding:30px;">��1. ���谻�Žÿ��� ��������� ���뿩�ᵵ �����˴ϴ�.</span><br> 
						<span style="padding:30px;">��2. �ߵ����� ����� ����� �뿩�� ������ [���������]</span><br> 
						<span style="padding:55px;text-align:left">���뿩��(���ް�)�Դϴ�.</span> 
					</td>
					<td align='center'>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
					</td>
				</tr>
				<tr>
					<td class='title' style="height:40;border-right:2px solid #444444;" >���� ���� ��<br>û�� ���� ����</td>
					<td colspan="5" style="padding-left:10px;padding-right:10px;"><span>�ڱ����� ���� ����ݿ� ���ؼ��� (��)�Ƹ���ī�� �����ڷ� �����ϰ�. (��)�Ƹ���ī�� ����û�������� �����Ѵ�.</span></td>
				</tr>
				
			 <tr style="height:50;">
					<td class='title' style="border-right:2px solid #444444;">Ư�� ����</td>
					<td colspan="5" align='center'>
						<input type="text" style="border:0px;text-align:center;width:90%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:90%;font-size:9pt;font-weight:bold;"><br>
				  </td>
			</tr> 
		</table>
		<br>
		<div align="center" >
			<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
				<tr>
					<td colspan="2" align="center"><span style="font-size:13pt;font-weight: normal;">�� &nbsp;&nbsp;��&nbsp;&nbsp;��  : 20 &nbsp;&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp; &nbsp;&nbsp; �� &nbsp;&nbsp;&nbsp;&nbsp; ��</span></td>
				</tr>
				<tr style="border-bottom-style:hidden;height:70;">
					<td width="50%" style="padding-left:10px;padding-top:10px;">
					<span style="font-size:11pt;">�뿩������(�Ӵ���)</span><br>
					<span style="font-size:9pt;"> &nbsp;&nbsp;����� �������� �ǻ���� 8,</span><br>
					<span style="font-size:9pt;"> &nbsp;&nbsp;802ȣ(���ǵ���, �������)</span>
					</td>
					<td width="50%" style="padding-left:20px;padding-bottom: 10px;">
						<span style="font-size:11pt;">�뿩������(������)</span><br>
						<span style="font-size:9pt;"> &nbsp;&nbsp;�� Ư�� ������ Ȯ���ϰ� ������.</span>
					</td>
				</tr>
				<tr style="border-bottom-style: hidden;">
					<td ></td>
					<td ></td>
				</tr>
				<tr style="border-bottom-style: hidden;">
					<td style="font-size:13pt;padding-left:10px">(��)�Ƹ���ī</td>
					<td ></td>
				</tr>
				<tr>
					<td style="border-bottom-style: hidden;">
						<div style="width:20%;text-align:right;font-size:10pt;margin-top: 5px;font-weight: normal;float:left">��ǥ�̻�</div>
						<div style="width:70%;text-align:center;font-size:15pt;float:left">��<span style="margin-left:35px;"></span>��<span style="margin-left:35px;"></span>��
						</div>
					</td>
					<td align="center" style="border-bottom-style:hidden;font-weight: normal;">
						<span>__________________________________________________��</span>
					</td>
				</tr>
				<tr style="height: 15px;">
					<td></td>
					<td></td>
				</tr>
			</table>
			<div style="text-align:right;font-size:10pt;font-weight: normal;">
				<span>��� �������� : 2018�� 3��</span>
			</div>
			<div id="Layer1" style="position:absolute; left:285px; top:980px; width:109px; height:108px; z-index:1"><img src="/acar/images/stamp.png" width="80" height="81"></div>
			
		</div>
		<%
			
		%>
	</div>
	</div>
	</div>
</form>
</body>
<script>
function onprint(){
	//factory.printing.header 	= ""; //��������� �μ�
	//factory.printing.footer 	= ""; //�������ϴ� �μ�
/* 	factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 12.0; //��������   
	factory.printing.rightMargin 	= 12.0; //��������
	factory.printing.topMargin 	= 30.0; //��ܿ���    
	factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������	
 */}
<%if(!mail_yn.equals("Y")){%>
 window.print();
<%}%>
</script>
</head>
</html>