<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String print_yn 	= request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//�����뿩����
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�ش�뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
	//���ຸ������
	//ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	ContGiInsBean ext_gin = new ContGiInsBean();
	//for(int f=1; f<=gin_size ; f++){
		ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);	
	//}				
	
	//�������Կɼ�
	int fee_opt_amt = 0;
	if(rent_st.equals("2")){
		fee_opt_amt = f_fee.getOpt_s_amt()+f_fee.getOpt_v_amt();
	}else if(AddUtil.parseInt(rent_st) >2){
		ContFeeBean a_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
		fee_opt_amt = a_fee.getOpt_s_amt()+a_fee.getOpt_v_amt();
	}
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	
	//�����
	UsersBean bus_user_bean 	= umd.getUsersBean(base.getBus_id());
	
	if(!rent_st.equals("1"))	bus_user_bean 	= umd.getUsersBean(fee.getExt_agnt());
	
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>���� ����</title>
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

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;}
.doc_a table td.nor {padding:5px 10px 2px 10px;}
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
<body  onLoad="javascript:onprint();">
<div id="Layer1" style="position:absolute; left:230px; top:1703px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></div>
<div id="Layer3" style="position:absolute; left:633px; top:1718px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/rect.png"></div>
<div id="Layer4" style="position:absolute; left:478px; top:2020px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/rect.png"></div>
<div id="Layer5" style="position:absolute; left:633px; top:1777px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/tri.png"></div>
<div id="Layer6" style="position:absolute; left:630px; top:2018px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/tri.png"></div>
<div align="center">
<form action="" name="form1" method="POST" >
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="print_yn" value="<%=print_yn%>">
<input type="hidden" name="content_st" value="newcar_doc">

<table width="680">
	<tr>
		<td colspan="2"><div align="center"><span class=style1>�� �� ��  �� �� �� ��  �� �� ��</span></div></td>
	</tr>
	<tr>
		<td width=48%>&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
		<td width=52% class="cnum right">
			<table>
				<tr>
					<th width=45% class="center">������ȣ</th>
					<td class="center"><%=cr_bean.getCar_no()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=3></td>
	</tr>
  	<tr>
 		<td colspan="2" class="doc">
			<table>
		      	<tr>
			 		<th width="13%">����ȣ</th>
			   		<td width="19%">&nbsp;<%=rent_l_cd%></td>
			    	<th width="13%">������</th>
			     	<td width="19%">&nbsp;<%=c_db.getNameById(bus_user_bean.getBr_id(),"BRCH")%></td>
			     	<th width="13%">���������</th>
			   		<td width="23%">&nbsp;<%=bus_user_bean.getUser_nm()%>&nbsp;<%=bus_user_bean.getUser_m_tel()%></td>
		   		</tr>
				<tr>
			    	<td class="center title" style="height:24px;">�뿩��ǰ ����</td>
			    	<td colspan="4"><input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && fee.getRent_way().equals("1"))%>checked<%%>>��ⷻƮ �Ϲݽ� 
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && !fee.getRent_way().equals("1"))%>checked<%%>>��ⷻƮ �⺻�� 
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && fee.getRent_way().equals("1"))%>checked<%%>>����plus �Ϲݽ�  
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && !fee.getRent_way().equals("1"))%>checked<%%>>����plus �⺻��</td>
			     	<td><input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("1"))%>checked<%%>>���� 
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("0"))%>checked<%%>>�縮��
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!rent_st.equals("1"))%>checked<%%>>����</td>
				</tr>
    		</table>
		</td>
	</tr>
	<tr>
   		<td height=3></td>
	</tr>
	<tr>
    	<td colspan="2"><span class=style2>1. ������</span></td>
	</tr>
	<tr>
    	<td colspan="2" class="doc">
      		<table>
		        <tr>
		        	<th width="14%">������</th>
		        	<td colspan="6"><input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("1"))%>checked<%%>>���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!client.getClient_st().equals("1")&&!client.getClient_st().equals("2"))%>checked<%%>>���λ���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("2"))%>checked<%%>>����</td>
		        </tr>
		        
		        <tr>
		        	<th>�� ȣ</th>
		        	<td colspan="2">&nbsp;<%=client.getFirm_nm()%></td>
		        	<th>����ڹ�ȣ</th>
		        	<td colspan="3">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
		        </tr>
		        <tr>
		        	<th>����(��ǥ��)</th>
		        	<td width="24%">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
		        	<th width="17%">�������/���ι�ȣ</th>
		        	<td width="16%">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%if(AddUtil.parseInt(AddUtil.getDate(4)) > 20140806){%><%=client.getSsn1()%><%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%><%}%></td>
		        	<th width="4%" rowspan="2">��<br>��<br>��</th>
		        	<th width="10%" class="center">��ȭ��ȣ</th>
		        	<td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
		        </tr>
		        <tr>
		        	<th>�� ��(����)</th>
		        	<td colspan="3">&nbsp;<%=client.getO_addr()%></td>
		        	<th class="center">�ѽ���ȣ</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <tr>
		        	<th>���������ּ�</th>
		        	<td colspan="3">&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
		        	<th rowspan="2">��<br>ǥ<br>��</th>
		        	<th class="center">�޴�����ȣ</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
		        </tr>
		        <tr>
		        	<th>��뺻�����ּ�</th>
		        	<td colspan="3">&nbsp;<%=site.getAddr()%>&nbsp;<%=site.getR_site()%></td>
		        	<th class="center">������ȭ</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
		        </tr>
	    	</table>	
			<table>
		        <tr>
		        	<th width="12%">�� ��</th>
		        	<th width="10%">�ٹ��μ�</th>
		        	<th width="14%">�� ��</th>
		        	<th width="9%">�� ��</th>
		        	<th width="17%">��ȭ��ȣ</th>
		        	<th width="13%">�޴�����ȣ</th>
		        	<th width="26%">E-MAIL</th>
		        </tr>
		        <%
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);        		
        				
        				if(mgr.getMgr_st().equals("�����̿���") || mgr.getMgr_st().equals("����������") || mgr.getMgr_st().equals("ȸ�������")){
        		%>
		        <tr>
		        	<th class="center"><%=mgr.getMgr_st()%></th>
		        	<td class="center"><%=mgr.getMgr_dept()%></td>
		        	<td class="center"><%=mgr.getMgr_nm()%></td>
		        	<td class="center"><%=mgr.getMgr_title()%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
		        	<td class="center"><%=mgr.getMgr_email()%></td>
		        </tr>
		        <%		}
		        	}%>
  			</table>
		</td>
	</tr>
	<tr>
	  	<td height=3></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>2. �뿩�̿� �⺻����</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="center">
				<tr>
					<th rowspan="2" width="5%">��<br>��<br>��<br>��</th>
					<th width=20%>����</th>
					<th width=47%>���û��</th>
					<th width="8%">����</th>
					<th width="15%">��������<br><span class="fs">-������ �Һ��ڰ���-</span></th>
					<th width=5%">���</th>
				</tr>
				<tr>
					<td>&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
					<td>&nbsp;<%=car.getOpt()%></td>
					<td style="height:50px;">&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(����:<%=car.getIn_col()%>)  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(���Ͻ�:<%=car.getGarnish_col()%>)  
						<%}%>
					</td>
					<td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>��					    
					    <%if(!base.getCar_gu().equals("1") || !rent_st.equals("1")){ //����,�縮��%>
					    <br>
					    <%		if(fee_opt_amt>0){%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_opt_amt)%>��)
					    <%		}else{%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_etc.getSh_amt())%>��)
					    <%		}%>
					    <%}else{%>
					    <%	if(car.getTax_dc_s_amt() > 0){%>
					    	<br>&nbsp;(���Ҽ� ������)
					    <%	}%>
					    <%}%>
					</td>
					<td>1��</td>
				</tr>
				<tr>
					<th>�̿�<br>�Ⱓ</th>
					<td colspan="5"><input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12"))%>checked<%%>>12���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("24"))%>checked<%%>>24���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("36"))%>checked<%%>>36���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("48"))%>checked<%%>>48���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%><%}else{%>checked<%}%>>��Ÿ( <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%>&nbsp;&nbsp;&nbsp;<%}else{%><%=fee.getCon_mon()%><%}%>)����<br>
					    <%if(fee.getRent_start_dt().equals("")){%>
					    20 &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�Ϻ��� ~ 20 &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�ϱ���
					    <%}else{%>
					    <%=AddUtil.getDate3(fee.getRent_start_dt())%>���� ~ <%=AddUtil.getDate3(fee.getRent_end_dt())%>����
					    <%}%>
					</td>
				</tr>
			</table>
			<table class="center">
				<tr>
					<th rowspan="6" width="5%">�������</th>
					<th width="20%">�����ڹ���</th>
					<th width="13%">�����ڿ���</th>
					<th colspan="3">���谡�Աݾ� (�����ѵ�)</th>
				</tr>
				<tr>
					<td rowspan="4" class="left"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>������� ������<br>&nbsp;<span class="fs">(���� ������ �������� Ư�� ����)</span><br>
					<input type="checkbox" name="checkbox" value="checkbox" <%if(!cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>�����<br> &nbsp;&nbsp;&nbsp;&nbsp; ������� ������/����<br> &nbsp;&nbsp;&nbsp;&nbsp; ����� �������� ����</td>
					<td rowspan="4" class="left">
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("0")){%> checked <%}%>>��26�� �̻�<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("3")){%> checked <%}%>>��24�� �̻�<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(������ ����)<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("1")){%> checked <%}%>>��21�� �̻�</td>
					<td width="11%">�� �� �� ��</td>
					<td width="25%">����(���ι�� ��,��)</td>
					<td rowspan="5" width="26%">* �ڱ��������� ��å��(��� �Ǵ�)<br> 
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000){%> checked <%}%>> 30���� / 
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%> checked <%}%>> ��Ÿ(<%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;<%}%>)����<br>
					<span class="fs">(������ ��� �������ظ�å������ �ǰ� ����-������ ���պ��� ���� ����� ����� ����)</span></td>
				</tr>
				<tr>
					<td>�� �� �� ��</td>
					<td><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("1")){%> checked <%}%>>5õ����-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("2")){%> checked <%}%>>1���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("4")){%> checked <%}%>>2���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!base.getGcp_kd().equals("2")&&!base.getGcp_kd().equals("4")){%> checked <%}%>>��Ÿ
						(<%if(base.getGcp_kd().equals("1")){%>5õ��<%}else if(base.getGcp_kd().equals("8")){%>3��<%}else if(base.getGcp_kd().equals("3")){%>5��<%}%>)��
						</td>
				</tr>
				<tr>
					<td>�ڱ��ü���</td>
					<td><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("1")){%> checked <%}%>>5õ����-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("2")){%> checked <%}%>>1���</td>
				</tr>		
				<tr> 
					<td>������������</td>
					<td>
						 <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> checked <%}%>>����(�Ǻ����� 1�δ� �ְ� 2���)
						 <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("N")){%> checked <%}%>>�̰���
					</td>
				</tr>	
				<tr>
					<td colspan="4" class="left">* ���⼭ �����̶� �θ�, �����, ������� �θ�, �ڳ�, �����, ������ ���մϴ�.(�������ڸŴ� ���Ե��� �ʽ��ϴ�)</td>
				</tr>
			<table class="center">
				<tr>
					<td width="15%" rowspan="2">�������� ����<br>��������<br>(üũ�� ��ĭ�� ���񽺰� �����˴ϴ�)</td>
					<td class="left lineh"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>������ ����<span class="fs"> (���ػ��� ����)</span>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>>��ü�� ���񼭺� (���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����)
					<br><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>������ �߻��� ���ó�� ���� ���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*������ ���� ��޼��� ����<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(����� ���� ���� ��)  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>>����������� (4�ð��̻� ������� �԰��)</td>
				</tr>
				<tr>
					<td class="left">&nbsp;* �������� �������� ���������ϸ� ���������̳� ȭ�������� �¿� �� RV�� ���������մϴ�.<br>
					&nbsp;* ���߻��� �������� �������� �������� �������� �ʽ��ϴ�.<br>&nbsp;&nbsp; - ���� ���� ���������� �ʿ��� ��쿡�� (��)�Ƹ���ī�� Ȯ�� �� ����ġ ������ �־�� (��)�Ƹ���ī����<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ������ ���ҵ˴ϴ�.</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
	  	<td height=3></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>3. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="right">
				<tr>
					<th width=10%>����</th>
					<th width=15%>������</th>
					<th width=15%>������</th>
					<th width=15%>���ô뿩��</th>
					<th width=15%>���뿩��</th>
					<th width=15%>���뿩��<br>������ Ƚ��</th>
					<th width=15%>���뿩��<br>������ ��¥</th>
				</tr>
				<tr>
					<th>���ް�</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>��</td>
					<td rowspan="3" class="center"><%=fee.getFee_pay_tm()%>&nbsp;ȸ</td>
					<td rowspan="3" class="center">�ſ� 
					    <%if(fee.getFee_est_day().equals("99")){%> &nbsp;���� 
					    <%}else if(fee.getFee_est_day().equals("98")){%> &nbsp;�뿩������ 
					    <%}else{%>
					    &nbsp;&nbsp;<%=fee.getFee_est_day()%>&nbsp;��
					    <%}%>					
					</td>
				</tr>
				<tr>
					<th>�ΰ���</th>
					<td class="center">-</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>��</td>
				</tr>
				<tr>
					<th>�� ��</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
				</tr>
				<tr>
					<th>���</th>
					<td colspan="3" class="center">�ʱ� ���Ա� �հ�: &nbsp;&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getPp_v_amt()+fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
					<td colspan="3" class="right">�� ������ ȸ�� �������� ��� �������Դϴ�.&nbsp;<%//=fee.getFee_cdt()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss"><p>&nbsp;&nbsp;&nbsp;* 1. �������� ���Ⱓ ������ ���Բ� ȯ���� �帳�ϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. �������� �̿�Ⱓ���� �ſ� ���� �ݾ׾� �����Ǹ�, ��� ������ ȯ�ҵǴ� ���� �ƴմϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. ���ô뿩��� ������( )����ġ �뿩�Ḧ �����ϴ� ���Դϴ�.<br>
			<%//if(base.getCar_gu().equals("1") && fee.getRent_st().equals("1")){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. �ʱ� ���Ա� (������, ������, ���ô뿩��)�� ������� 2���������� (��)�Ƹ���ī�� �ԱݵǾ�� �մϴ�.
			<%//}%>
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table class="center">
				<tr>
					<th rowspan="3" width=5%>����<br>���</th>
					<th rowspan="2" width=10%>�ڵ���ü<br>��û</th>
					<td colspan="4" class="left pd"><span class="style2">�� ���� CMS �����ü ��û�� �ۼ�</span></td>
				</tr>
				<tr>
					<td>�ڵ���ü ���</td>
					<td colspan="3" class="left pd">���뿩��, ��ü����, ���������, ��å��, ���·�</td>
				</tr>
				<tr>
					<th>���� �Ա�<br>(���༱��)</th>
					<td colspan="4" class="left pd">���� 140-004-023871 &nbsp;&nbsp;&nbsp;KEB�ϳ� 188-910025-57904 &nbsp;&nbsp; ��� 221-181337-01-012 &nbsp;&nbsp;���� 140-003-993274 (�λ�)<br>
						���� 385-01-0026-124&nbsp;&nbsp;�츮 103-293206-13-001&nbsp;&nbsp; ���� 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 140-004-023856 (����)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2" class="right fss">( ����ȣ : <%=rent_l_cd%>, Page 1/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>
	<tr>
		<td height=5 class="a4"></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>4. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1 right">
			<table>	
				<tr>
					<th width=14%><input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_fee() >0 ){%> checked <%}%>>��&nbsp;&nbsp;&nbsp;&nbsp; ��<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_fee() == 0){%> checked <%}%>>���Ը���</th>
					<td class="pd">�������� ���Ⱓ ���� �Ӵ����� �Ǻ����ڷ� �ϴ� ����(����)������������(
						<%if(ext_gin.getGi_st().equals("1")){%>
						<%=AddUtil.parseDecimal(AddUtil.ten_thous(ext_gin.getGi_amt()))%>����, <%=fee.getCon_mon()%>����
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  ����, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
					  <%}%>
						 )�� ��ġ�Ѵ�.<br>
						�� ��, �����뿩����� ��ü, �ߵ����� �����, ��å�� ��� ���� �� ��࿡�� �߻��� �� �ִ� ��� ä�ǿ� ���ؼ�<br>
						�Ӵ����� �������� ��ġ�� ����(����)���������������� �Ǹ��� ����� �� �ִ�.</td>
				</tr>	
			</table>
			<!-- ��������� ����(2019�� 11�� 13��) �ٽ� �츱 �� ����. -->
			<%-- <table class="doc_s right" style="margin:0px; padding:0px;">
				<tr>
					<th width=45%>���������</th>
					<td><%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
				</tr>
			</table> --%>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>5. Ư �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table>
				<tr>
					<th width=10%>����</th>
					<th colspan="4">�� ��</th>
				</tr>
				<tr>
					<th>�뿩��<br>��ü��</th>
					<td colspan="4" class="pd">(1) �뿩�� ��ü�� <span class="style2 point">�⸮ 24%�� ��ü����</span>�� �ΰ��ȴ�.<br>
									(2) 30�� �̻� �뿩�� ��ü�� �Ӵ����� ����� ���� �� �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �Ѵ�. �Ӵ�����<br>
			   &nbsp;&nbsp;&nbsp;&nbsp; ���� �ݳ� �䱸���� �ұ��ϰ� �������� ������ �ݳ����� ���� ��쿡�� �Ӵ����� ���Ƿ� ������ ȸ���� �� �ִ�.<br>
									(3) �������� ������ �� �ʱⳳ�Ա��� ������ �� ��࿡ ���� �Ӵ��ο��� �����Ͽ��� �� �뿩���� ������ ������ �� ����.<br>
									(4) ��ü�� ���� ��������� �������� �Ʒ� �ߵ����� ������ ������� �����Ͽ��� �Ѵ�.
					</td>
				</tr>
				<tr>
					<th>�ߵ�������</th>
					<td colspan="4" class="pd">(1) ����� �ߵ������ÿ��� <span class="style2 point">�ܿ��Ⱓ �뿩���� (&nbsp;<%=fee.getCls_r_per()%>&nbsp;)%�� �����</span>�� ����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * �⺻��������� <b>30%</b>�̸�, ������ ���� ��������� �ٸ��� ����˴ϴ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ܿ��Ⱓ �뿩�� = (�뿩�� �Ѿס�����̿�Ⱓ) X �ܿ��̿�Ⱓ<br>
						&nbsp;&nbsp;&nbsp; �� �뿩�� �Ѿ� = ������ + ���ô뿩�� + (���뿩�� X �Ѱ��Ⱓ���� ���뿩�� ������ Ƚ��)<br>
									(2) ������� ���� : ������ �� ���ô뿩��, �ܿ� ���������� �����ϰ�, ������ ��쿡�� �������� �����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ߵ� ���� �� <b>7</b>���̳��� �������� ������� �������� ���� ��쿡�� �Ӵ����� ���� 4. ������������ ������ �� �ִ�.<br>
									(3) ������, ���ô뿩��, �ܿ����������� �����ϴ� ���� : ���Ģ��, ���·� �谡�з����, �Ҽۺ�� �� �����������<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ������ȸ��(�ڱ�����)�� ���Ͽ� �Ӵ����� �δ��� �Ǻ�� ���å�� �뿬ü���� ���ߵ���������� ��ü�뿩��
					</td>
				</tr>
				<tr>
					<th>���°��</th>
					<td colspan="4" class="pd">����� �°���� ���� �������� ã�ƾ� �ϸ�, ���°踦 ������ �� ���δ� (��)�Ƹ���ī�� ���������� �Ǵ��Ͽ� �����Ѵ�. ���°������� ������ ����ǥ�� ���� �Һ��ڰ����� 0.8%�� �Ѵ�. (�߰����ŸŻ󿡰� �Ǵ� ��ุ�� 3�����̳� ���°� �Ұ�)</td>
				</tr>
				<tr>
					<th>�Ѵ޹̸�<br>�뿩���</th>
					<td colspan="4" class="pd">�뿩����� �������� �����ϸ�, 1���� �̸� �̿�Ⱓ�� ���� �뿩����� "�̿��ϼ� X (���뿩���30)"���� �Ѵ�.</td>
				</tr>
				<tr>
					<th rowspan="2">���Ⱓ<br>�������<br>�߰���<br>���Կɼ�</th>
					<td colspan="4" class="pd">���Ⱓ ����� �������� �� �뿩�̿� ������ �Ʒ��� ���Կɼǰ��ݿ� ������ �� �ִ� [�߰��� ���� ���ñ�(�߰��� ���Կɼ�)]�� ������. ��, �Ϲ����� ������ �� ���� LPG ������ ��쿡�� ������ ������ ���� ���������ڳ� ����ε� ������ �ڰ��� �ִ� �� �Ǵ� 
					�������� �����ϰ� �ִ� ���� ����� ���� ������ ������ �����մϴ�.</td>
				</tr>
				<tr>
					<th width=10%>���Կɼ�<br>����</th>
					<td width=27% class="center"><%if(fee.getOpt_s_amt() > 0){%><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>�� (�ΰ��� ����)<%}else{%>���ԿɼǾ���<%}%></td>
					<th width=14%>���Կɼ�<br>������ ����</th>
					<td width=35% class="pd">�ڹ��ΰ�:���� �Ǵ� �� ������ ������<br>
						�ڰ��ΰ�:���� �Ǵ� ������ �θ�/�ڳ�/�����</td>
				</tr>
				<tr>
					<th>�����ǹݳ�</th>
					<td colspan="4" class="pd">�������� ��� ����ÿ� �������� ���� �����ϰ� ���� �ε� ���� ���·� ������ �ݳ��Ͽ��� �Ѵ�.</td>
				</tr>
				<tr>
					<th class="ht">�� Ÿ</th>
					<td colspan="4">&nbsp;<%=fee_etc.getCon_etc()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss" height=20>�� �� ��༭�� ������� ���� ������ "�ڵ��� �뿩 ǥ�ؾ��"�� ���մϴ�. (2011.9.23 �����ŷ�����ȸ ����, �Ƹ���ī Ȩ������ ����)</td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
		<%if(cont_etc.getClient_share_st().equals("1")){%>
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
     	        <!-- ������������ ��� --> 	
     	 	<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left" rowspan="4">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, �������)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���</span><br><br>
		      			<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (��)</div>
		      			<%}else{%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp; (��)</div>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		        	<td height="16" rowspan="3" class="fs">&nbsp;�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� �� &quot;�ڵ��� �뿩�̿� ���&quot; �� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%" class="pd">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">�������</td>
		          	<td class="pd">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">����</td>
		          	<td class="right pd"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>		
		<%}else{%>
		<!-- ���뺸������ ��� -->
			<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���</span><br><br>
		      			<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (��)</div>
		      			<%}else{%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp; (��)</div>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		          	<td height="16" rowspan="3" class="fs">&nbsp;�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� �� &quot;�ڵ��� �뿩�̿� ���&quot; �� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%" class="pd">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">�������</td>
		          	<td class="pd">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">����</td>
		          	<td class="right pd"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>		
		<%}%>
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2" class="doc_a">
			<table>
				<tr>
					<td class="nor"><span class=style2>�� �������� �������̿� ���Ǽ�, �ſ������� ������Ȱ�� �� ��ȸ ���Ǽ� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>(��)�Ƹ���ī ����</span></span></td>
				</tr>
				<tr>
					<td class="con fs">(1) ����������ȣ�� ��15���� ������ ���� �Ʒ��� ���� ������ ���������� �������̿��ϴµ� �����մϴ�.<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ��������̿���� : �ڵ��� �뿩�̿� ����� ü�� �� ����, �������(�뿩�����, ���ݰ�꼭 �߼�, �뿩���߽ɵ�) ������׸� : ����, �ּ�,<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  �������, ���������ȣ, ����ó, �̸���, �ڵ���ü ���¹�ȣ, ����, �ҵ� �� ������� �麸�� �� �̿�Ⱓ : ��Ģ������ �������� �������̿�<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  ������ �޼��� �Ŀ��� ��ü���� �ı��մϴ�. �ٸ�, ����� ������ɿ� ���Ͽ� ������ �ʿ䰡 �ִ� ��쿡�� �����Ⱓ ���� �� �ı��մϴ�.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  �갳������(�����ĺ���������) �������̿� ���Ǹ� �ź��� �Ǹ��� ������, ���ǰźν� �ڵ��� �뿩�̿� ��࿡ ���� �ǹ����� �� ���� ����<br>
						&nbsp;&nbsp;&nbsp;&nbsp;   ������ �Ұ��Ͽ� �ε��� ��� ü���� ������ �� �ֽ��ϴ�.
						 <div class="agree style2">&nbsp;&nbsp;&nbsp;&nbsp;<span class="style7">�� �����ĺ�����(�ֹε�Ϲ�ȣ, ���������ȣ, �ܱ��ε�Ϲ�ȣ) �������̿� ���ǿ���:</span> &nbsp;<input type="checkbox" name="checkbox" value="checkbox" checked> ������&nbsp; <input type="checkbox" name="checkbox" value="checkbox"> ���Ǿ���</div>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  * ����������ȣ�� ��24���� ������ ���� �����ĺ����� �������̿�� ���� ���ǰ� �ʿ��ϸ�, �ֹε�Ϲ�ȣ�� �ΰ���ġ������ �ǰ� ����<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ��꼭 ���� �������� �������� ������ ��쿡�� �������̿� �մϴ�.<br>
						(2) �� ���� �����Ͽ� �ͻ簡 �������κ��� ����� ������ �ſ������� �ſ������� �̿� �� ��ȣ�� ���� ���� ��32�� ��1���� ������ ����<br>
						&nbsp;&nbsp;&nbsp;&nbsp; Ÿ�ο��� ������Ȱ��� ������ ���Ǹ� ���� �ϴ� �����Դϴ�. �̿� ������ �ͻ簡 ������ �ſ������� �ſ����� ���߱��, �ſ���������,<br>
						&nbsp;&nbsp;&nbsp;&nbsp; �ſ����� �������̿��� ��� �����Ͽ� ������ �ſ��� �Ǵ��ϱ� ���� �ڷ�μ� Ȱ���ϰų� ����������� ��å�ڷ�� Ȱ��, ��Ÿ ���ɿ���<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ���� ���� ������ �̿��ϴµ� �����մϴ�.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * ������Ȱ���� �ſ������� ���� : �ĺ�����, ����ó����, �Ӽ�����, �ڵ����뿩�̿�����, �뿩�ݺ������� ��<br>
						(3) �ſ������� �̿� �� ��ȣ�� ���� ���� ��32�� ��2���� ������ ���� �ͻ簡 ����� ü�� �� �������� �Ǵ��� ���Ͽ� �ſ뵵 �Ǵ�����, ����<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ���� �� �ſ��� �� ������ �ſ������� �ŷ��Ⱓ ���� �ſ���ȸȸ��κ��� ��ȸ�ϴµ� �����մϴ�. �� ���Ǵ� �� ����� �����̳� �߰�<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ����� ü�Ῡ�θ� �Ǵ��ϱ� ���� ��쿡�� ��ȿ�մϴ�.
					</td>
				</tr>
				<tr>
					<td class="nor">
						<table class="zero">
							<tr>
								<td><span class=style6><%=AddUtil.getDate3(fee.getRent_dt())%></td>
								<td>
								<div class="style2 style5">�뿩�̿���
								<span class=style4><%if(client.getClient_st().equals("2")){%> &nbsp;&nbsp;&nbsp;&nbsp;<%=client.getClient_nm()%>					
								<%}else{%> &nbsp;&nbsp;&nbsp;&nbsp;<%=client.getFirm_nm()%>&nbsp;<%=client.getClient_nm()%>
								<%}%>
								</span>
								<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
								&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;
								    <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>
								    ���뺸���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    &nbsp;&nbsp;&nbsp;��
								    <%}%>
								<%}else{%>
								�� &nbsp;&nbsp;
								    <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>
								    <%}else{%>���뺸����
								     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    ��
								    <%}%>																
								<%}%>
								</span></span></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=10></td>
	</tr>
	<tr>	        
		<td colspan="2" class="right fss">( ����ȣ : <%=rent_l_cd%>, Page 2/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	
</table>
</form>
</div>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	

<script>
function onprint(){

factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 8.0; //�ϴܿ���
<%if(print_yn.equals("Y")){ //�μ�ȭ�鿡�� ���δ� %>
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
<%}%>
alert('�μ�̸����⿡�� 2��, ������ġ�� �´��� Ȯ��! �ȸ´´ٸ� �ͽ��÷η� â���� ���� > ȣȯ�����⼳���� amazoncar.co.kr �߰����� �� ����Ʈ!');
}
</script>
