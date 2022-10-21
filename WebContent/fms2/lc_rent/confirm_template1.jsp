<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%
	String current_date 	= AddUtil.getDate3();

	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	
	//�Է°�
	String r_var1 = request.getParameter("r_var1")	==null? "":request.getParameter("r_var1");
	String r_var2 = request.getParameter("r_var2")	==null? "":request.getParameter("r_var2");
	String r_var3 = request.getParameter("r_var3")	==null? "":request.getParameter("r_var3");
	String r_var4 = request.getParameter("r_var4")	==null? "":request.getParameter("r_var4");
	String r_var5 = request.getParameter("r_var5")	==null? "":request.getParameter("r_var5");
	String r_var6 = request.getParameter("r_var6")	==null? "":request.getParameter("r_var6");
	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
						
	String rent_l_cd = var2;
	String rent_mng_id = var4;
	String client_id = var5;
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//��������
	CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
	*{
		font-family: serif;
	}
</style>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
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

.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}

input.whitetext		{ text-align:left; font-size : 10pt; background-color:#ffffff; border-color:#ffffff; border-width:0; color:#303030; }
input.whitenum		{ text-align:right; font-size : 10pt; background-color:#ffffff; border-color:#ffffff; border-width:0; color:#303030; }

#wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;}
	
</style>
</head>
<body topmargin=0 leftmargin=0>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="https://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
	<input type="hidden" name="var2" value="<%=var2%>">
	<input type="hidden" name="var4" value="<%=var4%>">
	<input type="hidden" name="var5" value="<%=var5%>">
	
    <div class="paper">
    <div class="content">
    
	<div id="wrap" style="width:100%;">


<div id="print_template_a"><!-- �ڱ���������Ȯ�μ� 		START-->
	<table style="border-collapse:collapse;width:100%;">
		<tr>
			<td style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;height:50px;">
				<span style="padding-top:10px;padding-right:30px;padding-bottom:10px;padding-left:30px;border-width:1px;border-style:solid;border-color:black;font-size:28px;
					font-weight:bold;">�ڱ���������Ȯ�μ�</span>
			</td>
		</tr>
		<tr>
			<td style="height:30px;"></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;">�����</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=client.getFirm_nm()%><%if(!client.getFirm_nm().equals(client.getClient_nm())){%><br><%=client.getClient_nm()%><%}%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">����ȣ</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=rent_l_cd%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;">������ȣ</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=cr_bean.getCar_no()%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">�� ��</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=cr_bean.getCar_nm()%></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4">
				<span style="margin-left:25px;font-size:17px;font-weight:bold;">�� �ڱ��������� ���� �� ��Ÿ ����(���� ��) ����(��༭ �� �ε��μ��� ����)</span><br>
				<span style="margin-left:50px;font-size:14px;">(��� �뿩�ڵ��� �뿩�Ⱓ�� �߻��� �ڱ��������� ��������� ��å��(��������)������ �����ϰ�</span><br>
				<span style="margin-left:50px;font-size:14px;">�����Դ� �� �̻��� ���δ��� ���� �ʱ� �����Դϴ�.)</span>
			</td>
		</tr>
		<tr>
			<td style="height:10px;"></td>
		</tr>
		<tr>
			<td colspan="4"><textarea name="r_var1" cols="30" rows="6" style="border:1px solid black;width:100%;height:260px;"><%=r_var1%></textarea></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4"><span style="margin-left:25px;font-size:17px;font-weight:bold;">�� ��å�ݾ� �� �Ա� �ȳ�</span></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">�� å �� ��</td>
			<td colspan="3" style="border:1px solid black;">
				<span style="margin-left:100px;font-weight:bold;font-size:15px;">�� ��</span>&nbsp;&nbsp;&nbsp;<input type="text" name="r_var2" size='15' value='<%=r_var2%>' class=whitenum>&nbsp;&nbsp;&nbsp;<span style="font-weight:bold;font-size:15px;">�� ��</span>
			</td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">���Ծ�������</td>
			<td colspan="3">&nbsp;<span style="font-size:15px;">�����Ա�(20<input type="text" name="r_var3" size='2' value='<%=r_var3%>' class=whitenum>��&nbsp;<input type="text" name="r_var4" size='2' value='<%=r_var4%>' class=whitenum>��&nbsp;<input type="text" name="r_var5" size='2' value='<%=r_var5%>' class=whitenum>��), �ſ�ī��(�ڵ���ü, �������)</span></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">�� �� �� ��</td>
			<td colspan="3">
				&nbsp;<span style="font-size:15px;">�Աݰ��� : �� �� �� �� 140-004-023871 �߾Ƹ���ī</span><br>
				&nbsp;<span style="font-size:15px;">�ſ�ī�� : �뿩���� �ݳ��� ���� ���� �Ǵ� �ſ�ī���ڵ���ü</span>
			</td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4">
				<span style="margin-left:25px;font-size:18px;">�� ��� ������ ���� ���� �޾����� ���� ���� �ڱ��������� ��å���� ����</span><br>
				<span style="margin-left:50px;font-size:18px;">���� �ȿ� ������ ���� ����մϴ�.</span>
			</td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;">
				<span style="font-size:18px;"><%=current_date%></span>
			</td>
		</tr>
		<tr>
			<td style="height:50px;"></td>
		</tr>
	</table>
	<table style="border-collapse:collapse;width:100%;">
		<tr>
			<td width:30%;><span style="margin-left:45px;font-size:20px;font-weight:bold;">�����</span></td>
			<td width:50%;><span style="margin-left:45px;font-size:13px;"><%=client.getFirm_nm()%><%if(!client.getFirm_nm().equals(client.getClient_nm())){%>&nbsp;<%=client.getClient_nm()%><%}%></span></td>
			<td width:20%;><span style="margin-left:80px;font-size:14px;">(������)</span></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td><span style="margin-left:45px;font-size:20px;font-weight:bold;">������� �븮��</span></td>
			<td><span style="margin-left:45px;font-size:12px;"><input type="text" name="r_var6" size='35' value='<%=r_var6%>' class=whitetext></span></td>
			<td><span style="margin-left:80px;font-size:14px;">(������)</span></td>
		</tr>
	</table>	
</div><!-- �ڱ���������Ȯ�μ� 		END-->
</div>

</form>
</body>
<script>
function save(){	
	var fm = document.form1;
	if(fm.r_var1.value == ''){ alert('�ڱ��������� ���� �� ��Ÿ ���� ������ �Է��Ͻʽÿ�.'); return; }
	if(fm.r_var2.value == ''){ alert('��å�ݾ��� �Է��Ͻʽÿ�.'); return; }
	if(fm.r_var3.value == ''){ alert('���Ծ������ڸ� �Է��Ͻʽÿ�.'); return; }
	fm.action = 'confirm_template1.jsp';	
	fm.target = "_self";
	fm.submit();
}
</script>
</html>