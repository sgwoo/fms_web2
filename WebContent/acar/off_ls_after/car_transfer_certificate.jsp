<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	// ���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	// �����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	// �ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			
	// amazoncar
	Hashtable br = new Hashtable();		
	br = c_db.getBranch("S1");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script> -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script> -->
<style>
.mid{
	font-size:11px;
	padding-left:30px;
	letter-spacing: 1px;
}
.mid2{
	font-size:11px;
	padding-left:60px;
	letter-spacing: 1px;
}
.mid3{
	font-size:12px;
	padding-left:30px;
	letter-spacing: 1.5px;
}
table{
	table-layout: fixed;
	border-collapse:collapse;
}
.cus_td{
	border-top:1px solid #000;
	border-bottom:1px solid #000;
	background-color:#CCC;
}
.cus_left_td{
	border-top:1px solid #000;
	border-right:1px solid #000;
	border-bottom:1px solid #000;
}
.top_bot_line{
    border-top: 1px solid #000;
    border-bottom: 1px solid #000;
}
.bottom_txt{
	font-size:11px;
	padding-left:5px;
	letter-spacing: 0.5px;
}
.bottom_txt2{
	font-size:11px;
	padding-left:20px;
	letter-spacing: 0.5px;
}
.font_txt09 {
	font-size:9px;
}
.font_txt10 {
	font-size:10px;
}
.font_txt11 {
	font-size:11px;
}
.font_txt12 {
	font-size:12px;
}
.font_txt13 {
	font-size:13px;
}
</style>
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 4mm 0mm 0mm 0mm;
    }
    html {
        /* background-color: #FFF; */
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin���� ����Ʈ ���� ���� */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 8mm; /*���*/
		-webkit-margin-end: 0mm; /*����*/
		-webkit-margin-after: 0mm; /*�ϴ�*/
		-webkit-margin-start: 0mm; /*����*/
    }
</style>
<script language="JavaScript" type="text/JavaScript">
	function ieprint() {
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
	}
</script>
</head>
<body onLoad="javascript:onprint();" style="width: 820px;">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<table style="margin-left: 20px; margin-right: 20px;">
	<tr><td colspan="7" style="height:0.5cm;"></td></tr>
	<tr>
		<td colspan="7" class="font_txt11">�� �ڵ�����ϱ�Ģ [���� ��15ȣ����] <font color="blue">&#60;���� 2017. 10. 26.&#62;</font></td>
	</tr>
	<tr><td colspan="7" style="height:0.3cm;"></td></tr>
	<tr>
		<td colspan="7" style="text-align:center; font-weight:bold;"><font size="5">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</font></td>
	</tr>
	<tr><td colspan="7" style="height:0.4cm;"></td></tr>
	<tr>
		<td class=" font_txt12" colspan="7" style="width:778px; height:30px; text-align:left; vertical-align:top;">			
			<div style="overflow: hidden;">
				<div class="cus_td font_txt12" style="width: 388px; height:30px; float: left; padding-top: 1px;">
					&nbsp;������ȣ
				</div>
				<div class="cus_td font_txt12" style="width: 388px; height:30px; float: left; padding-top: 1px; border-left:1px solid black;">
					&nbsp;��������
				</div>
			</div>
		</td>
		<!-- <td class=" font_txt12" colspan="5" style="height:30px;text-align:left;vertical-align:top;">
			
		</td> -->
	</tr>
	<tr>
		<td colspan="7" style="height:0.05cm;"></td>
	</tr>
	<tr>
		<td colspan="7" style="width:778px;">
			<div class="top_bot_line" style="overflow: hidden; height: 75px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 75px; text-align: center; padding-top: 16px; border-right: 1px solid #000;">��<br>(�絵��)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; vertical-align: middle; line-height: 25px;">&nbsp;����(��Ī)&nbsp;&nbsp;(��)�Ƹ���ī</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ֹ�(����)��Ϲ�ȣ&nbsp;&nbsp;115611-0019610</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;��ȭ��ȣ&nbsp;&nbsp;<%=br.get("TEL")%></div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ּ�&nbsp;&nbsp;<%=br.get("BR_ADDR")%></div>
			</div>
			<div class="top_bot_line" style="overflow: hidden; height: 75px; margin-top: 2px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 75px; text-align: center; padding-top: 16px; border-right: 1px solid #000;">��<br>(�����)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; line-height: 25px;">&nbsp;����(��Ī)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ֹ�(����)��Ϲ�ȣ</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;��ȭ��ȣ</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ּ�</div>
			</div>
			<div class="top_bot_line" style="overflow: hidden; height: 100px; margin-top: 2px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 100px; text-align: center; padding-top: 42px; border-right: 1px solid #000;">�ŷ�����</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; vertical-align: middle; line-height: 25px;">&nbsp;�ڵ�����Ϲ�ȣ&nbsp;&nbsp;<%=cr_bean.getCar_no()%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;���� �� ����&nbsp;&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�����ȣ&nbsp;&nbsp;<%=cr_bean.getCar_num()%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�Ÿ���</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�Ÿűݾ�</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ܱ�������</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;�ڵ����ε���</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;����Ÿ�<div style="float: right; line-height: 20px; margin-right: 30px;">&nbsp;km</div></div>
			</div>
		</td>
	</tr>
	
	<tr><td colspan="7" height="10"></td></tr>
	<tr>
		<td colspan="7">
			<span class="mid">��1��(�����ǥ��) �絵���� "��"�̶� �ϰ�, ������� "��"�̶� �Ѵ�.</span><br>
			<span class="mid">��2��(�������� ��) "��"�� �ܱ� ���ɰ� ��ȯ���� �ڵ����� ������������Ͽ� �ʿ��� ������ "��"���� �ε��Ѵ�.</span><br>
			<span class="mid">��3��(�����ݺδ�) �� �ڵ����� ���� ������������ �ڵ��� �ε����� �������� �Ͽ�, �� �����ϱ����� ���� "��"�� �δ��ϰ�, ��</span><br>
			<span class="mid2">���� ���� �������� ���� "��"�� �δ��Ѵ�. �ٸ�, ���� ���ɿ� ������������ ���ο� ���Ͽ� Ư���� ������ �ִ� ��쿡��</span><br>
			<span class="mid2">�׿� ������.</span><br>
			<span class="mid">��4��(���å��) "��"�� �� �ڵ����� �μ��� ������ �߻��ϴ� ��� ��� ���Ͽ� �ڱ⸦ ���Ͽ� �����ϴ� �ڷμ��� å���� ����.</span><br>
			<span class="mid">��5��(�������� ����å��) �ڵ����ε��� ������ �߻��� ����ó�� �Ǵ� ������� ����� �Һ�, �� �ۿ� �������� ���ڿ� ���ؼ���</span><br>
			<span class="mid2">"��"�� �� å���� ����.</span><br>
			<span class="mid" style="letter-spacing: 0px;">��6��(��� ��ü å��) "��"�� �ŸŸ������� �μ��� �� ������ �Ⱓ�� ��������� ���� ���� ������ �̿� ���� ��� å���� "��"�� ����.</span><br>
			<span class="mid">��7��(�Һν°�Ư��) "��"�� �ڵ����� �Һη� �����Ͽ� �Һα��� �� ���� ���� ���¿��� "��"���� �絵�ϴ� ��쿡�� ������ ��</span><br>
			<span class="mid2">�α��� "��"�� �°��Ͽ� �δ��� �������� ���θ� Ư����׶��� ����� �Ѵ�.</span><br>
			<span class="mid">��8��(�絵����) �� �絵������ 2���� �ۼ��Ͽ� "��"�� "��"�� ���� 1�뾿 ���ϰ� "��"�� �� ������ �����ǰ� ������� ��</span><br>
			<span class="mid2">û�� �� ��(�ܱ������Ϻ��� 15�� �̳�)�� ��ϰ�û�� �����ؾ� �Ѵ�.</span>
		</td>
	</tr>
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	
	<tr>
		<td colspan="5" class="mid" style="vertical-align: top;">Ư�����:</td>
		<td colspan="2">
			<table style="width: 150px;" align="right">
				<tr>
					<td class="font_txt11" style="height:30px; border:1px solid black; text-align:center;">��������</td>
				</tr>
				<tr>
					<td class="font_txt11" style="height:80px; border:1px solid black; text-align:center;">�������������� ����<br>(�޸� ���鿡 ����)</td>
				</tr>
			</table>			
		</td>
	</tr>
	
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	<tr>
		<td colspan="7">
			<span class="mid3" style="word-spacing: 2px; letter-spacing: 2px;">������ �ڵ����ŸŻ������ �߰��� ������ �ʰ� ����ΰ� ���� �ŷ��� �����ڵ����� �絵�ϰ�, �� �����</span><br>
			<span class="mid3">�����ϱ� ���Ͽ� ���ڵ�����ϱ�Ģ�� ��33����2����1ȣ�� ���� �� �絵������ �ۼ��Ͽ� �߱��մϴ�.</span>
		</td>
	</tr>
	<tr>
		<td colspan="7" class="mid3" style="text-align:right;">
			<span style="padding-right:20px">
				��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��
			</span>
		</td>
	</tr>
	<tr><td colspan="7"></td></tr>
	<tr>
		<td colspan="7" class="font_txt12">
			<span style="padding-left:30px;padding-right:30px;">�絵��</span>(��)�Ƹ���ī
			<span style="padding-left:230px;">�����</span>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-bottom:1px solid;">
			<span style="font-size:11px;vertical-align:top;padding-left:310px; color: #737272">(���� �Ǵ� ��)</span>
		</td>
		<td colspan="2" style="border-bottom:1px solid; text-align: right;">
			<span style="font-size:11px;vertical-align:top; color: #737272; padding-right: 10px;">(���� �Ǵ� ��)</span>
		</td>
	</tr>
	<tr><td colspan="7" height="7" style="border-top: 3px solid #000; border-bottom: 3px solid #000;"></td></tr>
	<tr>
		<td class="cus_td" colspan="7" style="text-align:center;">���ǻ���</td>
	</tr>
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	<tr>
		<td colspan="7">
			<span class="bottom_txt">1. �絵�� ���ǻ���: �� �絵������ �ۼ��� �� ������� ���������� ���� ������ ������� �������� ������ ������ �� ���� ���ظ� �� ��</span><br>
			<span class="bottom_txt2">������ �ݵ�� ������� ���������� �����ñ� �ٶ��ϴ�.</span><br>
			<span class="bottom_txt">2. ����� ���ǻ���: �� �絵������ �ۼ��� �� �� ������ ���Ͽ� �ΰ��� �ڵ����� �� ���������� ���ο� �з� �� ����� ���� ��� ���θ�</span><br>
			<span class="bottom_txt2">Ȯ���Ͽ� ������ ���� ���ظ� ���� �ʵ��� �Ͻñ� �ٶ��ϴ�.</span><br>
			<span class="bottom_txt">3. �������: �� ����ڰŷ��� �絵������ �����ŷ� ����ڰ� �ƴ� ��(�ڵ����Ÿž��� ����)�� ����� ������ �ڵ����������ɿ� ���� ó��</span><br>
			<span class="bottom_txt2">�� �ް� �˴ϴ�.</span><br>
			<span class="bottom_txt">4. ������ ���� ���� ����Ÿ��� ������ �ڴ� ���ڵ����������� ��71����2�� �� ��79����5ȣ�� ���� ¡�� �Ǵ� ���ݿ� ó�����ϴ�.</span><br>
			<span class="bottom_txt">5. �ڵ�������, �˻�, ����Ÿ� �̷�, �ڵ����� ���ο��ο� �з����� �� �ڵ�����Ż�̷������� ���䱳��ο��� �����ϴ� ����Ʈ���� ����("</span><br>
			<span class="bottom_txt2">����ī����") �Ǵ� �ڵ����ο��뱹������(www.ecar.go.kr)���� ��ȸ�� �����ϹǷ� Ȯ�� �ٶ��ϴ�. </span><br>
			<span class="bottom_txt">6. �絵���� ������ ��쿡�� ���μ�����Ȯ�μ� �Ǵ� ���ں��μ���Ȯ�μ� �߱�����, �絵���� ������ ��쿡�� �ΰ������� ÷���Ͽ��� ��</span><br>
			<span class="bottom_txt2">�ϴ�.</span>
		</td>
	</tr>
</table>
</body>

</html>