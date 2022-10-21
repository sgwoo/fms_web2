<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.car_office.*, card.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String pur_pay_dt 	= request.getParameter("pur_pay_dt")==null?"":request.getParameter("pur_pay_dt");
	String num	 	= request.getParameter("num")==null?"":request.getParameter("num");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int table1_h = 350;
	
	//������ �����ѽ� ��ȣ
	UsersBean fax_user_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("������������"));
	
	String fax_num = fax_user_bean.getI_fax();
	
	if(fax_num.equals("")) fax_num = "0505-920-9876";
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(fax_user_bean.getUser_id());
	if(!cs_bean.getUser_id().equals("") && !cs_bean.getTitle().equals("���Ĺ���")){
		fax_num = "02-2644-2226"; //���ǻ������ ������ü, ���� �����忡�� �Ұ���
		if(AddUtil.parseInt(AddUtil.getDate(4)) > 20171231){
			fax_num = "02-6263-6399"; //���������� �ѽ�
			fax_num = "0505-920-9876"; // 20180302 ���������� �ѽ� �������� ���ͳ��ѽ� �̿���.
		}
	}
	
	Hashtable br1 = c_db.getBranch(br_id);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	Hashtable ht 	= a_db.getCommi2(rent_mng_id, rent_l_cd, "2");
	
	
	//ī������
	CardBean c_bean = CardDb.getCard(pur.getCardno1());
	
	Hashtable ht2 	= CardDb.getCardMngListKMS(pur.getCardno1(), "������");
	Hashtable ht3 	= CardDb.getCardMngListKMS(pur.getCardno1(), "�㼱��");
	String jcard_no = String.valueOf(ht2.get("CARDNO"));
	String hcard_no = String.valueOf(ht3.get("CARDNO"));
	String card_no ="";
	if(jcard_no.equals(pur.getCardno1())){
		card_no = jcard_no;
	}else if(hcard_no.equals(pur.getCardno1())){
		card_no = hcard_no;
	}
	
	//ī������2
	CardBean c_bean2 = CardDb.getCard(pur.getCardno2());
	
	Hashtable ht4 	= CardDb.getCardMngListKMS(pur.getCardno2(), "������");
	Hashtable ht5 	= CardDb.getCardMngListKMS(pur.getCardno2(), "�㼱��");
	String jcard_no2 = String.valueOf(ht4.get("CARDNO"));
	String hcard_no2 = String.valueOf(ht5.get("CARDNO"));
	String card_no2 ="";
	if(jcard_no2.equals(pur.getCardno2())){
		card_no2 = jcard_no2;
	}else if(hcard_no2.equals(pur.getCardno2())){
		card_no2 = hcard_no2;
	}
	
	//ī������3
	CardBean c_bean3 = CardDb.getCard(pur.getCardno3());
	
	Hashtable ht6 	= CardDb.getCardMngListKMS(pur.getCardno2(), "������");
	Hashtable ht7 	= CardDb.getCardMngListKMS(pur.getCardno2(), "�㼱��");
	String jcard_no3 = String.valueOf(ht6.get("CARDNO"));
	String hcard_no3 = String.valueOf(ht7.get("CARDNO"));
	String card_no3 ="";
	if(jcard_no3.equals(pur.getCardno3())){
		card_no3 = jcard_no3;
	}else if(hcard_no2.equals(pur.getCardno2())){
		card_no3 = hcard_no3;
	}	
	

	
	//���������
	
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	//�����������ó�� �ѽ����� ���� ���̺�//
	String paid_no =  "�ѹ�"+AddUtil.getDate(4)+"-"+num;
	String doc_id =  FineDocDb.getFineGovNoNext("Ư��");
	String sdoc_id = "�ѹ�"+doc_id.substring(3);
	int count = 0;
	boolean flag = true;
	boolean flag2 = true;
	
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){//�ߺ��� ������ ���
	
	FineDocBn.setDoc_id		(doc_id);
	FineDocBn.setDoc_dt		(AddUtil.getDate());//�߽�����
	FineDocBn.setGov_id		(String.valueOf(ht.get("EMP_ID")));
	FineDocBn.setMng_dept		(String.valueOf(ht.get("AGNT_NM")));//����
	FineDocBn.setReg_id		(user_id);
	FineDocBn.setGov_st		(request.getParameter("lend_cond")==null?"":request.getParameter("lend_cond")); 
	FineDocBn.setMng_nm		(c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM"));//����1
	FineDocBn.setMng_pos		(String.valueOf(ht.get("CAR_OFF_NM"))); //����2
	FineDocBn.setH_mng_id		(nm_db.getWorkAuthUser("�����ѹ�����"));
	FineDocBn.setB_mng_id		(user_id);
	FineDocBn.setTitle		("�ڵ�������� �Ϻ� �ſ�ī����� ��û");//����
	
	flag = FineDocDb.insertFineDoc(FineDocBn);
	
	String car_mng_id = "XXXXXX";
	String rent_s_cd  = request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String firm_nm 	= String.valueOf(pur.getCard_kind1());
	String rpt_no 	= String.valueOf(pur.getRpt_no());
	
	FineDocListBn.setDoc_id			(doc_id);
	FineDocListBn.setCar_mng_id		(car_mng_id);
	FineDocListBn.setSeq_no			(AddUtil.parseInt(num));
	FineDocListBn.setPaid_no		(paid_no);
	FineDocListBn.setRent_mng_id		(rent_mng_id);
	FineDocListBn.setRent_l_cd		(rent_l_cd);
	FineDocListBn.setRent_s_cd		(rent_s_cd);
	FineDocListBn.setFirm_nm		(firm_nm);		//ī����
	FineDocListBn.setAmt1			(pur.getTrf_amt1());     //��������
	FineDocListBn.setVar2			(pur.getCardno1());		//ī���ȣ
	FineDocListBn.setRep_cont		(rpt_no);		//�����ȣ
	FineDocListBn.setVar1			(c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG"));//����
	FineDocListBn.setReg_id			(user_id);
	
	flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
	
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<style type="text/css" media="print">    
body {
	-webkit-print-color-adjust: exact; 
	-ms-print-color-adjust: exact; 
	color-adjust: exact;
	/* margin���� ����Ʈ ���� ���� */
    /* IE */
    margin: 0mm 0mm 0mm 0mm;
    
    /* CHROME */
    -webkit-margin-before: 5mm; /*���*/
	-webkit-margin-end: 0mm; /*����*/
	-webkit-margin-after: 5mm; /*�ϴ�*/
	-webkit-margin-start: 0mm; /*����*/
}
</style>
<script language='javascript'>
<!--
function pagesetPrint(){
	IEPageSetupX.header='';
	IEPageSetupX.footer='';
	IEPageSetupX.leftMargin=12;
	IEPageSetupX.rightMargin=12;
	IEPageSetupX.topMargin=10;
	IEPageSetupX.bottomMargin=10;	
	print();	
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
	
function ieprint() {
	factory.printing.header = ""; //��������� �μ�
	factory.printing.footer = ""; //�������ϴ� �μ�
	factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin = 12.0; //��������   
	factory.printing.rightMargin = 10.0; //��������
	factory.printing.topMargin = 10.0; //��ܿ���    
	factory.printing.bottomMargin = 10.0; //�ϴܿ���
	factory.printing.Print(true, window); //arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}	
//-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<!--
<OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT>
-->
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			
<input type='hidden' name='andor' value='<%=andor%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>  
<input type='hidden' name='gubun3' value='<%=gubun3%>'>    
<input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" value="<%=rent_l_cd%>">
<input type='hidden' name="num" value="<%=num%>">  
<table width='708' border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td colspan="2" height="50" align="center"></td>
    </tr>
    <tr> 
        <td  height="40" colspan="2" align="center" style="font-size : 15pt;"><b><Strong><font face="����">Pick amazoncar! We'll pick you up.</font></Strong></b></td>
    </tr>
    <tr bgcolor="#000000"> 
		<td colspan="2" align='center' height="10" class='line'>
			<table width="100%" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;">
				<tr bgcolor="#FFFFFF"> 
					<td >
						<table width="100%" border="0" cellspacing="0" cellpadding="5">
							<tr> 
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="����"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
								<td height="20" style="font-size : 10pt;" ><font face="����">Tel:02)392-4243</font></td>
								<td height="20" style="font-size : 10pt;" ><font face="����">Fax:02)757-0803</font></td>
							</tr>
							<tr> 
								<td height="20" style="font-size : 10pt;"><font face="����">�ѹ����� �Ⱥ���</font></td>
								<td height="20" style="font-size : 10pt;"><font face="����">�ѹ���  ������</font></td>
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="����">tax200@amazoncar.co.kr</font></td>
							</tr>
						</table>
					</td>
				</tr>				
			</table>
		</td>
    </tr>
    <tr>
	    <td colspan="2" style='background-color:000000; height:2'></td>
	</tr>
    <tr> 
		<td colspan="2" height="30" align="center"></td>
    </tr>
    <tr> 
		<td height="100" colspan="2" align='center'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="10%" height="25" style="font-size : 12pt;"><font face="����">������ȣ</font></td>
					<td width="3%" height="25" style="font-size : 12pt;"><font face="����">:</font></td>
					<td height="25" width="87%" style="font-size : 12pt;"><font face="����"><%=sdoc_id%>-<%=num%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="����">�߽�����</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����"><%=AddUtil.getDate()%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%>&nbsp;<%=ht.get("CAR_OFF_NM")%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����"><%if(ht.get("EMP_ID").equals("030849") || ht.get("EMP_ID").equals("030879")){%><%=ht.get("AGNT_NM")%><%}else{%>����ڴ�<%}%> (Tel : <%=ht.get("CAR_OFF_TEL")%>, Fax : <%=ht.get("CAR_OFF_FAX")%>)</font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="����">�ڵ�������� �Ϻ� �ſ�ī����� ��û</font></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr bgcolor="#999999"> 
		<td colspan=2 align='center' height="2" bgcolor="#333333"><hr width='100%' height='5' color='black'></hr></td>
    </tr>
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width="628" height="20" style="font-size : 12pt;"><p><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. �� ������ ������ ������ ����մϴ�.</font></p>
                    </td>
                </tr>
                <tr>
                   <td height="20" style="font-size : 12pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. �Ʒ��� ���� �ڵ������ �Ϻθ� ��� ���ī��� ���� �ٶ��ϴ�.</font></td>
                </tr>
				<tr>
                    <td height=></td>
                </tr>
                <tr>
                   <td align="center" height="25" style="font-size : 12pt;"><font face="����">(&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;)</font></td>
                </tr>
				<tr>
                    <td height=5></td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
                <tr>
					<td class='line'>
						<table width="100%" height="<%if(!c_bean.getCard_edate().equals("")){%>250<%}else{%>100<%}%>" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;">
                            <tr>
                                <td width="" height="" colspan="2" align='center' style="font-size : 12pt;"><font face="����">��&nbsp;��</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="����">��&nbsp;��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����">��&nbsp;��</font></td>
                            </tr>
                            <tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">�����ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
                            <tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<%if(!c_bean.getCard_edate().equals("")){%>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�<br>ī��<br>����</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getCard_kind1()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�ī��<br>������</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����">(��)�Ƹ���ī</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
                          </tr>
						  <tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī���ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=pur.getCardno1()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%if(card_no.equals(pur.getCardno1())){%>����ī��<%}%><%if(!jcard_no.equals("null")){%>( ������ )<%}else if(!hcard_no.equals("null")){%>( �㼱�� )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">��ȿ�Ⱓ<br>(��/��)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=AddUtil.ChangeDate7(c_bean.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī��<br>�����ݾ�</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt1())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����">�Ͻú�</font></td>
                            </tr>
                            <%}else{ %>	
                            <%	if(pur.getTrf_st1().equals("4")){%>
                            <tr>
                                <td width="10%" height="" style="font-size : 12pt; text-align: center;"><font face="����">����</font></td>
								<td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����"><%=pur.getCard_kind1()%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt1())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
                            <%	}%>    
                            <%}%>
						</table>
					</td>
                </tr>
 				<%if(!c_bean2.getCard_edate().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="250" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">�����ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�<br>ī��<br>����</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getCard_kind2()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�ī��<br>������</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����">(��)�Ƹ���ī</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī���ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=pur.getCardno2()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%if(card_no2.equals(pur.getCardno2())){%>����ī��<%}%><%if(!jcard_no2.equals("null")){%>( ������ )<%}else if(!hcard_no2.equals("null")){%>( �㼱�� )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">��ȿ�Ⱓ<br>(��/��)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=AddUtil.ChangeDate7(c_bean2.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī��<br>�����ݾ�</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt2())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����">�Ͻú�</font></td>
                            </tr>
						</table>
					</td>
                </tr>
				
				<%}%>
				
				<%if(!c_bean3.getCard_edate().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="250" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">�����ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="����">����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�<br>ī��<br>����</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=pur.getCard_kind3()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">�ſ�ī��<br>������</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����">(��)�Ƹ���ī</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī���ȣ</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=pur.getCardno3()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%if(card_no3.equals(pur.getCardno3())){%>����ī��<%}%><%if(!jcard_no3.equals("null")){%>( ������ )<%}else if(!hcard_no3.equals("null")){%>( �㼱�� )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">��ȿ�Ⱓ<br>(��/��)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=AddUtil.ChangeDate7(c_bean3.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">ī��<br>�����ݾ�</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt3())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����">�Ͻú�</font></td>
                            </tr>
						</table>
					</td>
                </tr>
				
				<%}%>

				<%if(c_bean2.getCard_edate().equals("") && !pur.getCard_kind2().equals("")&&pur.getTrf_st2().equals("1")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
                                <td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st2().equals("1")){%>����<%}else if(pur.getTrf_st2().equals("5")){%>����Ʈ<%}%></font></td>
								<td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st2().equals("1")){%>����<%}else if(pur.getTrf_st2().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>���<%}else{%>����<%}%>�����ī��<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt2())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st2().equals("1")){%>������ü<%}else if(pur.getTrf_st2().equals("2")){%>����ī��<%}else if(pur.getTrf_st2().equals("3")){%>�ĺ�ī��<%}else if(pur.getTrf_st2().equals("4")){%>����<%}else if(pur.getTrf_st2().equals("5")){%><%}else if(pur.getTrf_st2().equals("6")){%>���ź�����<%}else if(pur.getTrf_st2().equals("7")){%>ī���Һ�<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>		
				
				<%if(c_bean3.getCard_edate().equals("") && !pur.getCard_kind3().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st3().equals("1")){%>����<%}else if(pur.getTrf_st3().equals("5")){%>����Ʈ<%}%></font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st3().equals("1")){%>����<%}else if(pur.getTrf_st3().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>���<%}else{%>����<%}%>�����ī��<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt3())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st3().equals("1")){%>������ü<%}else if(pur.getTrf_st3().equals("2")){%>����ī��<%}else if(pur.getTrf_st3().equals("3")){%>�ĺ�ī��<%}else if(pur.getTrf_st3().equals("4")){%>����<%}else if(pur.getTrf_st3().equals("5")){%><%}else if(pur.getTrf_st3().equals("6")){%>���ź�����<%}else if(pur.getTrf_st3().equals("7")){%>ī���Һ�<%}%></font></td>
							</tr>
							
						</table>
					</td>
                </tr>
				<%}%>		
				
				<%if(!pur.getCard_kind4().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st4().equals("1")){%>����<%}else if(pur.getTrf_st4().equals("5")){%>����Ʈ<%}%></font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st4().equals("1")){%>����<%}else if(pur.getTrf_st4().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>���<%}else{%>����<%}%>�����ī��<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt4())%></b> ��</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st4().equals("1")){%>������ü<%}else if(pur.getTrf_st4().equals("2")){%>����ī��<%}else if(pur.getTrf_st4().equals("3")){%>�ĺ�ī��<%}else if(pur.getTrf_st4().equals("4")){%>����<%}else if(pur.getTrf_st4().equals("5")){%><%}else if(pur.getTrf_st4().equals("6")){%>���ź�����<%}else if(pur.getTrf_st4().equals("7")){%>ī���Һ�<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>	
				<%if(!pur.getCard_kind5().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;">����</font></td>
                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="����">�ӽÿ��ຸ���</font></td>
                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><b><%=AddUtil.parseDecimal(pur.getTrf_amt5())%></b> ��</font></td>
                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"><%if(pur.getTrf_st5().equals("1")){%>������ü<%}else if(pur.getTrf_st5().equals("2")){%>����ī��<%}else if(pur.getTrf_st5().equals("3")){%>�ĺ�ī��<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>					
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="25%" height="" style="font-size : 12pt; text-align: center;"><font face="����">��������</font></td>
								<td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="����"><%=AddUtil.getDate()%></font></td>
								<td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"></font></td>
							</tr>
							<tr>
                                <td width="25%" rowspan="2" style="font-size : 12pt; text-align: center;"><font face="����">�����</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="����"><%=user_bean.getUser_nm()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="����"><%=user_bean.getHot_tel()%></font></td>
                            </tr>
						</table>
					</td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
				<%if(!ht.get("CAR_OFF_NM").equals("����������")){%>
				<tr>
                    <td height=5></td>
                </tr>
                <tr>
                   	<td height="25" style="font-size : 14pt;">
                   		<font face="����">
                   			�� ī������� ���Ǻ��� �Ϸᰡ ������ <b>[�������� FAX.<%=fax_num%>]</b><br/>
                   			&nbsp;&nbsp;&nbsp;�� 11:30�б��� �� �����ֽñ� �ٶ��ϴ�.<br/>
                   			&nbsp;&nbsp;&nbsp;<b>(�� ��Ͼ����� ���Ͽ� �ð��� �� �����ֽñ� �ٶ��ϴ�.)</b>
                   		</font>
                   	</td>
                </tr>
				<%}%>
                <!-- <tr>
                   <td height="25" style="font-size : 10pt;"><font face="����">�� ��������(����)�� �������� �����ֽðų� �������(����)�� �Ʒ� ���·� �Ա��Ͽ� �ֽñ� �ٶ��ϴ�. <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>(���� : �������� 140-004-023863)</font></td>
                </tr> -->
                <tr>
                	<td height="25" style="font-size : 10pt;">
                		<font face="����" style="letter-spacing: -1.2px;">
                			�� �������� ������ �ݵ�� ���� �Ʒ� �ּҷ� ����߼����ֽð�, �ε��� �������(��3,000)�� �Ʒ� ���¼۱� �� ���<br>
                   			 �븮�� ������ �Ա� �� ���� ���� �ٶ��ϴ�.(T.02-6263-6370)<br>                   			
                   		</font>
                   		<br>
                   		<font face="����">
							�ּ� : ���� �������� �ǻ����8 ������� 8�� �Ƹ���ī �ѹ��� ����ھ�<br>
							���� : �������� 140-004-023863							
						</font>
					</td>
                </tr>
				<!-- <tr>
                    <td height=5></td>
                </tr> -->
				<!--
				<tr>
                   <td height="25" style="font-size : 11pt;"><font face="����">�� ���� �����ÿ� �������� <b>FAX. 02-757-0803, 02-782-0826</b> ���� �����ֽñ� �ٶ��ϴ�. </font></td>
                </tr>
				-->
			</table>
        </td>
    </tr>
</table>
<table width='708' height="" border="0" cellpadding="0" cellspacing="0">

<%if(pur.getCard_kind2().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
<%if(pur.getCard_kind3().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
<%if(pur.getCard_kind4().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
	<!-- <tr> 
		<td width="708" colspan="2"><font face="����">&nbsp;</font></td>
	</tr> -->
	<tr align="center"> 
		<td height="" colspan="2" style="font-size : 19pt;"><font face="����"><b>�ֽ�ȸ��&nbsp;�Ƹ���ī&nbsp;&nbsp;&nbsp;&nbsp;��ǥ�̻�&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</b><img src=/acar/images/stamp_sq.jpg align="middle" width="100" height="100"></font></td>
	</tr>
</table>
</form>
</body>
</html>
