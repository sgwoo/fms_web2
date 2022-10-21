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
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.cont.*"%>
<%@ page import="acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	
	
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
	
	String s_cd1 		= request.getParameter("s_cd1")==null?"":request.getParameter("s_cd1");
	String s_cd2 		= request.getParameter("s_cd2")==null?"":request.getParameter("s_cd2");
	String s_cd3 		= request.getParameter("s_cd3")==null?"":request.getParameter("s_cd3");
	String s_cd4 		= request.getParameter("s_cd4")==null?"":request.getParameter("s_cd4");
	String s_cd5 		= request.getParameter("s_cd5")==null?"":request.getParameter("s_cd5");
	
	String s_cd = s_cd1+""+s_cd2+""+s_cd3+""+s_cd4+""+s_cd5;
	
	String item_st 	= request.getParameter("item_st")==null?"":request.getParameter("item_st");
	if(item_st.equals("1")){//����� ��ü���ڱ�����
		s_item = "��ü����";
		//��������
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		car_no = String.valueOf(cont.get("CAR_NO"));
		firm_nm = String.valueOf(cont.get("FIRM_NM"));
	}
	Vector vt = new Vector();
	int vt_size = 0;
	
	if(s_item.equals("������")){
		vt = s_db.getGrtList2("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("���·�")){
		vt = s_db.getFineList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("��å��")){
		vt = s_db.getInsurMList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("��ü����")){
		vt = s_db.getFeeDlyScdList("", "", "1", rent_l_cd);
	}else if(s_item.equals("�뿩��")){
		vt = s_db.getFeeList4("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("���������")){
		vt = s_db.getClsFeeScdList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("�ܱ�뿩��")){
		vt = s_db.getScdRentMngList_New("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("��û��+�ܰ�")){
		vt = s_db.getEndFeeList("", "", "1", rent_l_cd, s_cd);
	}else if(s_item.equals("��/������")){
		vt = s_db.getInsurHList("", "", "1", rent_l_cd, s_cd);
	}
	
	vt_size = vt.size();
	
	Hashtable ht = new Hashtable();
	
	int f_vt_size = vt_size;
	if(f_vt_size>1) f_vt_size = 1;
	for (int i = 0 ; i < f_vt_size ; i++){
		ht = (Hashtable)vt.elementAt(i);
	}
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

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%=AddUtil.subData(firm_nm, 10)%> ä�ǰ���
			</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle"><%=s_item%></div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">	
						<tr>
							<th width="80">������ȣ</th>
							<td><%=car_no%></font></td>
						</tr>						
					<%if(s_item.equals("������")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("EXT_EST_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">����</th>
							<td><%=ht.get("GUBUN")%> <font color=#fd5f00><%if(!String.valueOf(ht.get("EXT_TM")).equals("1")){%>�ܾ�<%}%></font></td>
						</tr>	
						<tr>
							<th>�Աݿ�����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_EST_DT")))%></td>
						</tr>	
						<%if(!String.valueOf(ht.get("RENT_SUC_DT")).equals("")){%>													
						<tr>
							<th>�°�����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%></td>
						</tr>		
						<%}else{%>												
						<tr>
							<th>�뿩������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
						</tr>		
						<%}%>
						<tr>
							<th>�����ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("EXT_EST_AMT")))%>��</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("EXT_PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>��</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>�ܾ�</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>��</th>							
						</tr>	
					<%		}%>																								
						
					<%}else if(s_item.equals("���·�")){%>
						<tr>
							<th width="80">���ݳ���</th>
							<td><%=ht.get("VIO_CONT")%></td>
						</tr>	
						<tr>
							<th>�����Ͻ�</th>
							<td><%=ht.get("VIO_DT")%> </td>
						</tr>	
						<tr>
							<th>�������</th>
							<td><%=ht.get("VIO_PLA")%></td>
						</tr>		
						<tr>
							<th>���ݱݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%>��</td>
						</tr>												
						<tr>
							<th>���α���</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAID_END_DT")))%></td>
						</tr>		
						<tr>
							<th>�볳����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROXY_DT")))%></td>
						</tr>		
						<tr>
							<th>û������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DEM_DT")))%></td>
						</tr>		
						
					<%	}else if(s_item.equals("��å��")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("CUST_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">����</th>
							<td><%=ht.get("SERV_ST")%> 
							<font color=#fd5f00><%if( Util.parseInt(String.valueOf(ht.get("TOT_AMT")))==0 && String.valueOf(ht.get("OFF_NM")).equals("") ){
							Hashtable s_ht = s_db.getInsurMCaseNotNN(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")), String.valueOf(ht.get("SERV_ID")));
							if(!String.valueOf(s_ht.get("OFF_NM")).equals("") && !String.valueOf(s_ht.get("OFF_NM")).equals("null")){
								ht.put("OFF_NM",  String.valueOf(s_ht.get("OFF_NM"))==null?"":String.valueOf(s_ht.get("OFF_NM")));
								ht.put("TOT_AMT", String.valueOf(s_ht.get("TOT_AMT"))==null?"":String.valueOf(s_ht.get("TOT_AMT")));
								ht.put("SERV_DT", String.valueOf(s_ht.get("SERV_DT"))==null?"":String.valueOf(s_ht.get("SERV_DT")));
							}
							%>
							[��û����]
							<%}%></font></td>
						</tr>	
						<tr>
							<th>�����ü</th>
							<td><%=ht.get("OFF_NM")%></td>
						</tr>	
						<tr>
							<th>��������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SERV_DT")))%></td>
						</tr>		
						<tr>
							<th>����ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%>��</td>
						</tr>		
						<tr>
							<th>�Աݿ�����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CUST_PLAN_DT")))%></td>
						</tr>		
						<tr>
							<th>�ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%>��</td>
						</tr>	
						
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("CUST_PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CUST_PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>��</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>�ܾ�</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>��</th>							
						</tr>	
					<%		}%>												
												
					<%	}else if(s_item.equals("��ü����")){
							long total_amt1 	= 0;
							long total_amt2 	= 0;
							for (int i = 0 ; i < vt_size ; i++){
								ht = (Hashtable)vt.elementAt(i);
								total_amt1 += AddUtil.parseLong(String.valueOf(ht.get("DLY_FEE")));%>
						<tr>
							<th width="80"><%=ht.get("FEE_TM")%>ȸ��</th>						
							<td width="120"><%=ht.get("DLY_DAYS")%>�� <%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DLY_FEE")))%>��</td>
						</tr>						
					<%		}%>	
					<%		//��ü���� ���ݸ���Ʈ
							Vector vt2 = s_db.getFeeDlyScd(gubun3, gubun4, "1", rent_l_cd);//(String gubun3, String gubun4, String s_kd, String t_wd)
							int vt_size2 = vt2.size();%>
					<%		for (int i = 0 ; i < vt_size2 ; i++){
								Hashtable ht2 = (Hashtable)vt2.elementAt(i);
								total_amt2 += AddUtil.parseLong(String.valueOf(ht2.get("DLY_FEE")));%>
						<tr>
							<th>����</th>						
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("PAY_DT")))%></td>
							<td align="right">-<%=Util.parseDecimal(String.valueOf(ht2.get("PAY_AMT")))%>��</td>
						</tr>										
					<%		}%>			
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>�հ�</th>
							<td></td>
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>��</th>							
						</tr>										
					<%	}else if(s_item.equals("�뿩��")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">����</th>
							<td colspan=2><%=ht.get("FEE_TM")%>ȸ��</font></td>
						</tr>	
						<tr>
							<th>�Աݿ�����</th>
							<td colspan=2><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
						</tr>	
						<tr>
							<th>�����ݾ�</th>
							<td colspan=2><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!ht.get("RC_DT").equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));%>
						<tr>
							<th>����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RC_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("RC_AMT")))%>��</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>�ܾ�</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>��</th>							
						</tr>	
					<%		}%>								
						
					<%	}else if(s_item.equals("�ܱ�뿩��")){%>
						<tr>
							<th width="80">����</th>
							<td><%=ht.get("RENT_ST")%></td>
						</tr>	
						<tr>
							<th>�������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
						</tr>	
						<tr>
							<th>�Աݿ�����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
						</tr>	
						<tr>
							<th>�����ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%>��</td>
						</tr>						
						
					<%	}else if(s_item.equals("���������")){
							long total_amt1 	= AddUtil.parseLong(String.valueOf(ht.get("AMT")));
							long total_amt2 	= 0;%>
						<tr>
							<th width="80">����</th>
							<td><%=ht.get("CLS_GUBUN")%> <font color=#fd5f00><%if(!String.valueOf(ht.get("TM")).equals("1")){%>�ܾ�<%}%></font></td>
						</tr>	
						<tr>
							<th>��������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
						</tr>	
						<tr>
							<th>�Աݿ�����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
						</tr>	
						<tr>
							<th>�����ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%>��</td>
						</tr>	
					<%		if(vt_size>1){%>											
						<tr>
							<td colspan=3 height=20></td>
						</tr>																		
					<%			for (int i = 0 ; i < vt_size ; i++){
									ht = (Hashtable)vt.elementAt(i);
									if(!String.valueOf(ht.get("PAY_DT")).equals("")){
										total_amt2 += AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT")));%>
						<tr>
							<th>����</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%>
							<td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("EXT_PAY_AMT")))%>��</td>
						</tr>						
					<%				}%>
					<%			}%>
						<tr>
							<td height=10  colspan=3></td>
						</tr>
						<tr>
							<td colspan=3 height=1 bgcolor=#b0b0b0></td>
						</tr>
						<tr>
							<td height=7  colspan=3></td>
						</tr>
						<tr>
							<th>�ܾ�</th>
							<th></th>							
							<td align="right"><font color='#990000' size='3'><b><%=Util.parseDecimal(total_amt1-total_amt2)%></b></font>��</th>							
						</tr>	
					<%		}%>									
						
					<%	}else if(s_item.equals("��û��+�ܰ�")){%>						
						<tr>
							<th width="80">����������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BAS_END_DT")))%></td>
						</tr>	
						<tr>
							<th>��û���뿩��</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%></td>
						</tr>	
						<tr>
							<th>�ܰ��ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%>��</td>
						</tr>			
						<tr>
							<th>�հ�</th>
							<td><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")))+AddUtil.parseLong(String.valueOf(ht.get("O_1"))))%>��</td>
						</tr>			
												
					<%	}else if(s_item.equals("��/������")){%>						
						<tr>
							<th width="80">����</th>
							<td><%=ht.get("REQ_GU")%></td>
						</tr>	
						<tr>
							<th>����ȸ��</th>
							<td><%=ht.get("OT_INS2")%></td>
						</tr>	
						<tr>
							<th>�����</th>
							<td><%=ht.get("ACCID_ST")%></td>
						</tr>							
						<tr>
							<th>�������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
						</tr>	
						<tr>
							<th>û������</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
						</tr>	
						<tr>
							<th>û���ݾ�</th>
							<td><%=Util.parseDecimal(String.valueOf(ht.get("REQ_AMT")))%>��</td>
						</tr>			
					<%	}%>
						
					<%	if(vt_size==0){%>
						<tr>
							<th valign=top>����Ÿ�� �����ϴ�.</th>
						</tr>
					<%	}%>
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

//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>