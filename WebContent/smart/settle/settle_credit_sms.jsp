<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}

/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 5px;}
.contents_box1 th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:red; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.settle_acc.*, acar.bill_mng.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 		= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //���Ǽ�
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	

	
	Vector vt = s_db.getStatSettleSubItemList	(rent_mng_id, rent_l_cd, car_mng_id, client_id, "", "", "", "", mode);//String m_id, String l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String mode	
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	
	long pre_amt 	= 0;
	long fine_amt 	= 0;
	long fee_amt 	= 0;
	long fee_amt2 	= 0;
	long serv_amt 	= 0;
	long cls_amt 	= 0;
	long rent_amt 	= 0;
	long accid_amt 	= 0;
	long dly_amt 	= 0;
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//������¹�ȣ
	Vector banks = neoe_db.getFeeDepositList();
	int bank_size = banks.size();
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function msgDisp(){
		var fm = document.form1;	
		
		fm.msg2.value = fm.msg2.value+' '+fm.deposit_no.value;
	
		checklen(2);				
	}
	
	
	//���ð� �ݾ� ���� 
	function setMsgAmt(idx){
		var fm = document.form1;
		
		var size1 = <%=vt_size%>;
		
		var pre_amt = 0;
		var fine_amt = 0;
		var fee_amt = 0;
		var dly_amt = 0;
		var serv_amt = 0;		
		var cls_amt = 0;			
		var rent_amt = 0;			
/*		
		for(var i=0; i<size1; i++){	
			if(fm.ch_cd[i].checked == true){
				if(fm.dly_st[i].value == '������')					pre_amt = pre_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '���·�')					fine_amt = fine_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '�뿩��')					fee_amt = fee_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '��ü����')				dly_amt = dly_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '��å��')					serv_amt = serv_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '���������')				cls_amt = cls_amt + toInt(parseDigit(fm.dly_amt[i].value));		
				if(fm.dly_st[i].value == '�ܱ�뿩��')				rent_amt = rent_amt + toInt(parseDigit(fm.dly_amt[i].value));		
			} 		
		}

		fm.h_fee_amt2.value = fee_amt;				
		fm.h_dly_amt2.value = dly_amt;	
					
		if(fee_amt>0)		fm.msg2.value = '�뿩��'+parseDecimal(fee_amt)+'��';		
		if(dly_amt>0)		fm.msg2.value = fm.msg2.value+'+�뿩�Ῥü����'+parseDecimal(dly_amt)+'��';		
		if(pre_amt>0)		fm.msg2.value = fm.msg2.value+'+������'+parseDecimal(pre_amt)+'��';				
		if(serv_amt>0)		fm.msg2.value = fm.msg2.value+'+��å��'+parseDecimal(serv_amt)+'��';						
		if(fine_amt>0)		fm.msg2.value = fm.msg2.value+'+���·�'+parseDecimal(fine_amt)+'��';				
		if(cls_amt>0)		fm.msg2.value = fm.msg2.value+'+���������'+parseDecimal(cls_amt)+'��';								
		if(rent_amt>0)		fm.msg2.value = fm.msg2.value+'+�ܱ�뿩��'+parseDecimal(rent_amt)+'��';										
		
		fm.msg2.value = fm.msg2.value+'=�ѱݾ�'+parseDecimal(fee_amt+dly_amt+pre_amt+serv_amt+fine_amt+cls_amt+rent_amt)+'��';
		fm.msg2.value = fm.msg2.value+' '+fm.deposit_no.value;
							
		//�Ǿ��� +��� ���ش�.
		if(fm.msg2.value.substr(0,1)=='+')			fm.msg2.value = fm.msg2.value.substr(1);	
*/	
	}	
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;

		if(date_type==2){//����			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()+(24*60*60*1000)*2);						
		}else if(date_type == 4){
			dt = new Date(today.valueOf()+(24*60*60*1000)*3);						
		}
		
		s_dt = String(dt.getFullYear())+"-";		
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		fm.req_dt.value = s_dt;		
	}		
		
	//���� ������
	function SandSms(){
		var fm = document.form1;				
		if(confirm('���ڸ� �����ðڽ��ϱ�?'))				
		{				
			
			fm.action = "settle_credit_sms.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}	
	
	function view_settle_info(rent_mng_id, rent_l_cd, client_id, firm_nm, car_mng_id, car_no, car_nm, bus_id2, s_cd1, s_cd2, s_cd3, s_cd4, s_cd5)
	{
		var fm = document.form1;		
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value 	= rent_l_cd;
		fm.client_id.value 	= client_id;
		fm.firm_nm.value 	= firm_nm;
		fm.car_mng_id.value = car_mng_id;
		fm.car_no.value 	= car_no;
		fm.car_nm.value 	= car_nm;
		fm.bus_id2.value 	= bus_id2;		
		fm.s_cd1.value 		= s_cd1;
		fm.s_cd2.value 		= s_cd2;		
		fm.s_cd3.value 		= s_cd3;
		fm.s_cd4.value 		= s_cd4;
		fm.s_cd5.value 		= s_cd5;		
		fm.action = "settle_credit_info.jsp";
		fm.submit();
	}	
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "settle_credit_main.jsp";		
		if(fm.from_page.value == 'fms_menu.jsp') 	fm.action = '/smart/fms/settle_item_list.jsp';
		if(fm.from_page.value == 'cont_menu.jsp') 	fm.action = '/smart/fms/settle_item_list.jsp';
		fm.submit();
	}		
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='bus_id2' 	value='<%=bus_id2%>'>
	<input type='hidden' name='s_item' 		value='<%=s_item%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='mode' 		value='<%=mode%>'>
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='h_fee_amt2' value=''>
	<input type='hidden' name='h_dly_amt2' value=''>
	<input type='hidden' name='s_cd1' 		value=''>
	<input type='hidden' name='s_cd2' 		value=''>		
	<input type='hidden' name='s_cd3' 		value=''>
	<input type='hidden' name='s_cd4' 		value=''>		
	<input type='hidden' name='s_cd5' 		value=''>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%=firm_nm%> ä�ǰ���
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">��ü��Ȳ</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">							
						<%	for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								total_amt += AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("������"))		pre_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("���·�"))		fine_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��") && !String.valueOf(ht.get("GUBUN2")).equals("��û��+�ܰ�"))		fee_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��") && String.valueOf(ht.get("GUBUN2")).equals("��û��+�ܰ�"))			fee_amt2 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("��å��"))		serv_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("���������"))	cls_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("�ܱ�뿩��"))	rent_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("��/������"))	accid_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								if(String.valueOf(ht.get("GUBUN1")).equals("��ü����"))		dly_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								
								if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��") && String.valueOf(ht.get("GUBUN2")).equals("��û��+�ܰ�"))			total_amt 	= total_amt - AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								%>				  
						<tr>
							<th width="80">
								<!--
							    <input type="checkbox" name="ch_cd" value="<%=i%>" onclick="javascript:setMsgAmt(2);" <%	if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��")||String.valueOf(ht.get("GUBUN1")).equals("��ü����")){%>checked<%}%>>
								<input type='hidden' name='dly_amt' value='<%=ht.get("DLY_AMT")%>'>
								<input type='hidden' name='dly_st' value='<%=ht.get("GUBUN1")%>'>
								<input type='hidden' name='dly_st2' value='<%=ht.get("GUBUN2")%>'>
								-->
								<%=ht.get("GUBUN1")%>
							</th>
							<td>
							<%=ht.get("CAR_NO")%> <font color=#fd5f00><%=ht.get("GUBUN2")%></font>
							<%	if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��")){%>
							<br>
							<%	}%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>&nbsp;
							<a href="javascript:view_settle_info('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CLIENT_ID")%>','<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>','<%=ht.get("BUS_ID2")%>','<%=ht.get("S_CD1")%>','<%=ht.get("S_CD2")%>','<%=ht.get("S_CD3")%>','<%=ht.get("S_CD4")%>','<%=ht.get("S_CD5")%>')" onMouseOver="window.status=''; return true"><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>��</a>
							</td>
						</tr>	
						<%		if(i+1 < vt_size){%>	
						<tr>
							<td colspan=2 height=1 bgcolor=#b0b0b0></td>
						</tr>						
						<%		}%>	
						<%	}%>	
						<%	if(vt_size==0){%>
						<tr>
							<th valign=top>����Ÿ�� �����ϴ�.</th>
						</tr>
						<%	}else{%>	
						<tr>
							<td height=10  colspan=2></td>
						</tr>
						<tr>
							<td colspan=2 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=2></td>
						</tr>
						<tr>
							<th>�հ�</th>
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt)%></b></font> ��&nbsp;</th>							
						</tr>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">���ڹ߼�</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">							
						<tr>
							<td>���¹�ȣ : 
								<select name='deposit_no' onchange="javascript:msgDisp();">
                        			<option value=''>���¸� �����ϼ���</option>
					    			<%	if(bank_size > 0){
											for(int i = 0 ; i < bank_size ; i++){
												Hashtable bank = (Hashtable)banks.elementAt(i);%>
									<option value='[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%></option>
			            			<%		}
										}%>
                      			</select>
							</td>
						</tr>	
						<tr>
							<td height=10></td>
						</tr>						
						<tr>
							<td ><textarea name='msg2' rows='5' cols='30' class='text' onKeyUp="javascript:checklen(2)" style='IME-MODE: active'></textarea>
							&nbsp;<input type="text" name="msglen2" class='text' size="2" maxlength="2" readonly value=0>byte
							</td>
						</tr>	
						<tr>
							<td height=10></td>
						</tr>												
						<tr>
							<td>���� :
								<select name="s_destphone" onchange="javascript:document.form1.destphone.value=this.value;">
									<option value="">����</option>
        							<%if(!client.getM_tel().equals("")){%>
        							<option value="<%=client.getM_tel()%>">[��&nbsp;&nbsp;&nbsp;ǥ&nbsp;&nbsp;&nbsp;��] <%//=client.getM_tel()%> <%=client.getClient_nm()%></option>
        							<%}%>
        							<%if(!client.getCon_agnt_m_tel().equals("")){%>
        							<option value="<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%//=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
        							<%}%>
        							<%if(!site.getAgnt_m_tel().equals("")){%>
        							<option value="<%=site.getAgnt_m_tel()%>">[�������ݰ�꼭] <%//=site.getAgnt_m_tel()%> <%=site.getAgnt_nm()%></option>
        							<%}%>
        							<%for(int i = 0 ; i < mgr_size ; i++){
        								CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        								if(!mgr.getMgr_m_tel().equals("")){%>
        							<option value="<%=mgr.getMgr_m_tel()%>">[<%=mgr.getMgr_st()%>] <%//=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%//=mgr.getMgr_title()%></option>
        							<%}}%>	        				
        			  			</select>
					  			<br>
					  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���Ź�ȣ <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'> )
        			  		</td>
						</tr>	
						<tr>
							<td style='height:10px;'></td>
						</tr>							
						<tr>
							<td>�����Ͻ� :						
								<input type="text" name="req_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
								<input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(2)">����
								<input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(3)">��
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					                                    <select name="req_dt_h">
                        									<%for(int i=0; i<24; i++){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        									<%}%>
                      									</select>
                      									<select name="req_dt_s">
                        									<%for(int i=0; i<59; i+=5){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        									<%}%>
                     									 </select>
        			  		</td>
						</tr>	
						<tr>
							<td style='height:10px;'></td>
						</tr>	
						<tr>
							<td valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<a href="javascript:SandSms()"><img src='/smart/images/btn_reg.gif' align=absmiddle /></a></td>
						</tr>					
												
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 		
	</div>	
    <div id="footer"></div>  
</div>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
	
	fm.msg2.value = '�뿩��<%=Util.parseDecimal(fee_amt)%>+�뿩�Ῥü����<%=Util.parseDecimal(dly_amt)%>=�ѱݾ�<%=Util.parseDecimal(fee_amt+dly_amt)%>��';
	
	if(<%=fee_amt%>> 0 && <%=dly_amt%>==0)		fm.msg2.value = '�뿩��<%=Util.parseDecimal(fee_amt)%>��';
	if(<%=fee_amt%>==0 && <%=dly_amt%>> 0)		fm.msg2.value = '�뿩�Ῥü����<%=Util.parseDecimal(dly_amt)%>��';	
	if(<%=fee_amt%>==0 && <%=dly_amt%>==0)		fm.msg2.value = '';		
	
//	fm.h_fee_amt2.value = <%=fee_amt%>;
//	fm.h_dly_amt2.value = <%=dly_amt%>;

			
	checklen(2);
	
//�޽��� �Է½� string() ���� üũ
function checklen(idx)
{
	var msgtext, msglen;
	var maxlen = 2000;
	
	msgtext = document.form1.msg2.value;
	msglen = document.form1.msglen2.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//���̸� ���Ѵ�.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>maxlen)
		{
			alert("�޽������� ��� ���� �̻��� ���� ���̽��ϴ�.\n �޽��������� �ѱ� "+(maxlen/2)+"��, ����"+(maxlen)+"�ڱ����� ���� �� �ֽ��ϴ�.");
			
			temp = document.form1.msg2.value.substr(0,i);
			document.form1.msg2.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen2.value=l;	
}		
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>