<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.cls.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%
	String type 			= request.getParameter("type")			==null? "":request.getParameter("type");
	String firm_nm 			= request.getParameter("firm_nm")		==null? "":request.getParameter("firm_nm");
	String client_nm 		= request.getParameter("client_nm")		==null? "":request.getParameter("client_nm");
	String rent_l_cd 		= request.getParameter("rent_l_cd")		==null? "":request.getParameter("rent_l_cd");
	String car_no 			= request.getParameter("car_no")		==null? "":request.getParameter("car_no");
	String car_nm 			= request.getParameter("car_nm")		==null? "":request.getParameter("car_nm");	// ����
	String current_date 	= AddUtil.getDate3();
	String ssn 				= request.getParameter("ssn")			==null? "":request.getParameter("ssn");	// ���ε�Ϲ�ȣ �Ǵ� �������
	String enp_no 			= request.getParameter("enp_no")		==null? "":request.getParameter("enp_no");	// ����ڵ�Ϲ�ȣ
	String address 			= request.getParameter("address")		==null? "":request.getParameter("address");	// ����� �ּ� 2018.01.10
	String rent_dt 			= request.getParameter("rent_dt")		==null? "":request.getParameter("rent_dt");	// �������
	String car_color 		= request.getParameter("car_color")		==null? "":request.getParameter("car_color");	// ��������
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null? "":request.getParameter("rent_start_dt");// �̿�Ⱓ ������
	String rent_end_dt 		= request.getParameter("rent_end_dt")	==null? "":request.getParameter("rent_end_dt");// �̿�Ⱓ ������
	String driving_age 		= request.getParameter("driving_age")	==null? "":request.getParameter("driving_age");// ���谡�Կ����� ����
	String view_amt 		= request.getParameter("view_amt")		==null? "":request.getParameter("view_amt");// �뿩��/������ǥ�ÿ��� 20191105
	int fee_amt 			= request.getParameter("fee_amt")		==null?0:Util.parseInt(request.getParameter("fee_amt"));// �뿩�� 20191105
	int grt_amt 			= request.getParameter("grt_amt")		==null?0:Util.parseInt(request.getParameter("grt_amt"));// ������ 20191105
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	
	String mail_yn = "";
	
	if(type.equals("") && !var3.equals("") && !var2.equals("")){
		
		CommonDataBase c_db 	= CommonDataBase.getInstance();
		AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
		CarRegDatabase crd 		= CarRegDatabase.getInstance();
		InsDatabase ai_db 		= InsDatabase.getInstance();
		
		mail_yn = "Y";
		type = var3;
		rent_l_cd = var2;	
		String client_id = var5;
		String rent_mng_id = var4;
		
		//���⺻����
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
		//������
		ClientBean client = al_db.getNewClient(client_id);
		
		//�����⺻����
		ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
		//�ڵ����⺻����
		CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
		//�����������
		if(!base.getCar_mng_id().equals("")){
			cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		}
		
		//�뿩�᰹����ȸ(���忩��)
		int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);	
		
		firm_nm = client.getFirm_nm();
		client_nm = client.getClient_nm();
		
		car_no = cr_bean.getCar_no();
		
		//����
		car_nm = c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
		
		ssn = client.getSsn1();
		ssn += "-";
		if(client.getClient_st().equals("1")){
			ssn += client.getSsn2();
		}else {
			if(client.getSsn2().length() > 1){
				ssn += client.getSsn2().substring(0,1);
				ssn += "******";
			}else{
				ssn += "*******";
			}
		}
		
		enp_no = client.getEnp_no1();
		enp_no += "-";
		enp_no += client.getEnp_no2();
		enp_no += "-";
		enp_no += client.getEnp_no3();
		if(enp_no.length()==2){
			enp_no = "";
		}
		
		address = "";
		if(!client.getO_addr().equals("")){
			address += "(";
		}
		address += client.getO_zip();
		if(!client.getO_addr().equals("")){
			address += ") ";
		}
		address += client.getO_addr();
			
		// ��������
		car_color = "";
		car_color += car.getColo();
		if(!car.getIn_col().equals("")){
			car_color += "   ";
			car_color += "(�������(��Ʈ): ";
			car_color += car.getIn_col();
			car_color += ")";
		}
		if(!car.getGarnish_col().equals("")){
			car_color += "   ";
			car_color += "(���Ͻ�: ";
			car_color += car.getGarnish_col();
			car_color += ")";
		}
		
		// ������ڴ� �뿩����� �������
		rent_dt = base.getRent_dt();
		
		Vector vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 0);
		if(vt.size() < 1){
			vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 1);
		}
		
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i); 
			rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		}
		
		// �̿�Ⱓ �������� �뿩����� �뿩������
		ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(1));
		rent_start_dt = fees.getRent_start_dt();
		
		// ���°��� ��� �̿�Ⱓ �������� ���°賯¥�� ����		2018.01.11
		String rent_suc_dt = af_db.getRentSucDt(rent_mng_id, rent_l_cd);
		if(rent_suc_dt.length() > 1){
			rent_start_dt = rent_suc_dt;
		}
		
		// ��� ������ �ִ� ��� ������ �������� �뿩�����Ϸ� �̿�Ⱓ �������� ����ȴ�.
		ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		rent_end_dt = fees2.getRent_end_dt();
				
		// ���� ������ �ִ� ��� ������ ����Ϸ� �̿�Ⱓ �������� ����ȴ�.	2018.01.11
		Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
		int im_vt_size = im_vt.size();
		String im_rent_end_dt = "";
		if(im_vt_size > 0){
			Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size - 1);
			im_rent_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
			if(Integer.parseInt(im_rent_end_dt) > Integer.parseInt(rent_end_dt)){	// ���� ���� �Ⱓ �������� ��� ���� �����Ϻ��� ū ��츸 �����Ų��.
				rent_end_dt = im_rent_end_dt;
			}
		}
		
		//��������� �������ڰ� ��������
		
		//��������
		ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
		if(!cls.getCls_dt().equals("")){
			rent_end_dt = cls.getCls_dt();
		}
			
		// ���谡�Կ����� ����
		driving_age = base.getDriving_age();
	 	Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
		
		fee_amt = fees2.getFee_s_amt()+fees2.getFee_v_amt();
		grt_amt = fees2.getGrt_amt_s();				
	}
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
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
#wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;}
	
</style>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">
    
	<div id="wrap" style="width:100%;">
<input type="hidden" id="type" value="<%=type%>">

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
			<td style="border:1px solid black;width:30%;text-align:center;"><%=firm_nm%><%if(!firm_nm.equals(client_nm)){%><br><%=client_nm%><%}%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">����ȣ</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=rent_l_cd%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;">������ȣ</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=car_no%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">�� ��</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=car_nm%></td>
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
			<td colspan="4"><input style="border:1px solid black;width:100%;height:260px;" readonly></td>
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
				<span style="margin-left:100px;font-weight:bold;font-size:15px;">�� ��</span><span style="margin-left:200px;font-weight:bold;font-size:15px;">�� ��</span>
			</td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">�� �� �� �� �� ��</td>
			<td colspan="3">&nbsp;<span style="font-size:15px;">�����Ա�(20&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��), �ſ�ī��(�ڵ���ü, �������)</span></td>
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
		<tr>
			<td colspan="2"><span style="margin-left:45px;font-size:20px;font-weight:bold;">�����</span></td>
			<td colspan="2"><span style="margin-left:80px;font-size:14px;">(������)</span></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="2"><span style="margin-left:45px;font-size:20px;font-weight:bold;">������� �븮��</span></td>
			<td colspan="2"><span style="margin-left:80px;font-size:14px;">(������)</span></td>
		</tr>
	</table>
</div><!-- �ڱ���������Ȯ�μ� 		END-->

<div id="print_template_b"><!-- �ڵ��� �뿩�̿� ����� Ȯ�μ�		START-->
	<table style="border-collapse:collapse;width:100%;">
		<tr><td style="height:50px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;">�� �ڵ��� �뿩�̿� ����� Ȯ�μ� ��</td>
		</tr>
		<tr><td style="height:30px;"></td></tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">�� �� ����</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>��</span><span style="margin-left:60px;">ȣ</span></td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=firm_nm%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">���ε�Ϲ�ȣ<br>�Ǵ� �������</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=ssn%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">���� (��ǥ��)</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=client_nm%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">����ڹ�ȣ</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=enp_no%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>��</span><span style="margin-left:60px;">��</span></td>
			<td colspan="3" style="font-size:14px;">&nbsp;<%=address%></td>
		</tr>
		<tr>
			<td colspan="4" style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">�� ��� ��ǿ� ���� Ȯ��</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">�������</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">�뿩������</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_nm%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">�̿�Ⱓ</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_start_dt)%> ~ <%=AddUtil.ChangeDate2(rent_end_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">������ȣ</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_no%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">���谡�Կ�����<br>����</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;">
			<%	if(driving_age.equals("0")){%>26���̻�<%}
				else if(driving_age.equals("3")){%>24���̻�<%}
				else if(driving_age.equals("1")){%>21���̻�<%}
				else if(driving_age.equals("5")){%>30���̻�<%}
				else if(driving_age.equals("6")){%>35���̻�<%}
				else if(driving_age.equals("7")){%>43���̻�<%}
				else if(driving_age.equals("8")){%>48���̻�<%}
				else if(driving_age.equals("9")){%>22���̻�<%}
				else if(driving_age.equals("10")){%>28���̻�<%}
				else if(driving_age.equals("11")){%>35���̻�~49������<%}
				else if(driving_age.equals("2")){%>��������<%}
			%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">��������</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_color%></td>
		</tr>
		<%if(view_amt.equals("Y")){%>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">������</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(grt_amt)%> ��</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">�뿩��</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee_amt)%> ��</td>
		</tr>
		<%} %>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="font-size:14px;">���� ���� �ֽ�ȸ�� �Ƹ���ī �ڵ����뿩�̿��� ������ Ȯ���մϴ�.</td>
		</tr>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;"><span style="font-size:14px;"><%=current_date%></span></td>
		</tr>
		<tr><td style="height:40px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;"><img src="/acar/main_car_hp/images/ceo_no_stamp.gif"
				><img src="/acar/main_car_hp/images/ceo_stamp.jpg" height="63" width="63"></td>
		</tr>
	</table>
</div><!-- �ڵ��� �뿩�̿� ����� Ȯ�μ�		END-->
</div>
</body>
<script>
	$(document).ready(function(){
		var type = $("#type").val();
		console.log(type);
		if(type == "1"){
			$("#print_template_b").remove();
		}else if(type == "2"){
			$("#print_template_a").remove();
		}
	});
	
	function onprint(){	// 2018.02.13 �߰�
	/* 	factory.printing.header = ""; //��������� �μ�
		factory.printing.footer = ""; //�������ϴ� �μ�
		factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin = 5.0; //��������   
		factory.printing.rightMargin = 5.0; //��������
		factory.printing.topMargin = 0.0; //��ܿ���    
		factory.printing.bottomMargin = 0.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ�������� */
	}
	
	 <%if(!mail_yn.equals("Y")){%>
	 window.print();
	 <%}%>
</script>
</html>