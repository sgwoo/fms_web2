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
.contents_box {width:100%; table-layout:fixed; font-size:14px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font-size:14px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font-size:16px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.fee.*, acar.credit.*, acar.insur.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase" scope="page"/>
<jsp:useBean id="ac_db" class="acar.credit.AccuDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //���Ǽ�
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�ڵ����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	

	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//����ȸ����
	String reco_dt =  ac_db.getClsRecoDt(rent_mng_id, rent_l_cd);
	
	//�뿩����
	ContFeeBean fee = new ContFeeBean();
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	String fee_rent_start_dt[] 	= new String [fee_size];
	String fee_rent_end_dt[] 	= new String [fee_size];
	String fee_rent_dt[] 		= new String [fee_size];
	String fee_ext_agnt[] 		= new String [fee_size];
	String fee_rent_way[] 		= new String [fee_size];
	String fee_prv_dlv_yn[]		= new String [fee_size];
	
	for(int i=0; i<fee_size; i++){
		ContFeeBean fee_bean = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(i+1));
		
		fee_rent_start_dt[i] 	= fee_bean.getRent_start_dt();
		fee_rent_end_dt[i] 		= fee_bean.getRent_end_dt();
		fee_rent_dt[i]	 		= fee_bean.getRent_dt();
		fee_ext_agnt[i] 		= fee_bean.getExt_agnt();
		fee_rent_way[i] 		= fee_bean.getRent_way();
		fee_prv_dlv_yn[i]		= fee_bean.getPrv_dlv_yn();
		
		if(i+1 == fee_size) fee = fee_bean;
	}
	
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
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


<script language='javascript'>
<!--
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}					
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">									
				<%if(car_no.equals("�̵��")){%><%//=rent_l_cd%><%=car_nm%><%}else{%><%=car_no%><%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+�޴�'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='Ȩ'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�ֿ�����</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>�� �� �� ��</th>
							<td><%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
						</tr>
						<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
				    	</tr>
				    	<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>�����ε���</th>
				    		<td><%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
				    	</tr>
						-->
						<%if(1!=1){%>
						<%if(fee_prv_dlv_yn[0].equals("Y")){%>
						<%		if(!taecha.getCar_rent_st().equals("") && !taecha.getCar_rent_et().equals("null")){%>
				    	<tr>
				    		<th>���� �뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
				    	</tr>
						<%		}%>						
						<%		if(!taecha.getCar_rent_et().equals("") && !taecha.getCar_rent_et().equals("null")){%>
				    	<tr>
				    		<th>���� �뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
				    	</tr>
						<%		}%>
						<%}%>
						<%}%>
				    	<tr>
				    		<th>�뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_start_dt[0])%></td>
				    	</tr>
						<%if(fee_size==1){%>
				    	<tr>
				    		<th>�뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[0])%></td>
				    	</tr>
						<%}else{%>
				    	<tr>
				    		<th>�뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[fee_size-1])%></td>
				    	</tr>
						<%}%>
						<%if(1!=1){%>
						<%for(int i=1; i<fee_size; i++){%>
				    	<tr>
				    		<th><%=i+1%>������ �������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_dt[i])%></td>
				    	</tr>
				    	<tr>
				    		<th><%=i+1%>������ �뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_start_dt[i])%></td>
				    	</tr>
				    	<tr>
				    		<th><%=i+1%>������ �뿩������</th>
				    		<td><%=AddUtil.ChangeDate2(fee_rent_end_dt[i])%></td>
				    	</tr>						
						<%}%>
						<%}%>
				    	<tr>
				    		<th>�����ݳ���</th>
				    		<td><%=AddUtil.ChangeDate2(reco_dt)%></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<!--���°�����-->
		
		<!--���°�����-->
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">��������</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>�� �� �� ��</th>
							<td><%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
						</tr>
						<!--
						<tr>
							<th>�� �� �� ��</th>
							<td><%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
						</tr>
						-->
						<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>�� �� �� ��</th>
				    		<td><font color=#fd5f00><%String rent_way = fee_rent_way[0];%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></font></td>
				    	</tr>
				    	<tr>
				    		<th>���ʿ�����</th>
				    		<td><%=c_db.getNameById(base.getBus_id(),"USER")%></td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>���������</th>
				    		<td><%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
				    	</tr>
						-->
				    	<tr>
				    		<th>���������</th>
				    		<td><%=c_db.getNameById(base.getMng_id(),"USER")%><%if(base.getMng_id().equals("")){%><%=c_db.getNameById(base.getBus_id2(),"USER")%><%}%></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">�뿩��</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=95px>�� �� �� ��</th>
							<td><%=AddUtil.ChangeDate2(fee.getRent_start_dt())%> ~ <%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
						</tr>
						<%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
						<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%String dec_gr = cont_etc.getDec_gr();%><%if(dec_gr.equals("3")){%>�ż�����<%}else if(dec_gr.equals("0")){%>�Ϲݰ�<%}else if(dec_gr.equals("1")){%>�췮���<%}else if(dec_gr.equals("2")){%>�ʿ췮���<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>�� �� �� ��</th>
				    		<td>��ǥ <%String client_guar_st = cont_etc.getClient_guar_st();%><%if(client_guar_st.equals("1")){%>�Ժ�<%}else if(client_guar_st.equals("2")){%>����<%}%>
							<%if(!cont_etc.getGuar_st().equals("")){%>
					    		/ ��ǥ�� <%String guar_st = cont_etc.getGuar_st();%><%if(guar_st.equals("1")){%>�Ժ�<%}else if(guar_st.equals("2")){%>����<%}%>
							<%}%>
							</td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</th>
				    		<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
				    	</tr>
						-->
				    	<tr>
				    		<th>�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</th>
				    		<td><%if(fee.getGrt_amt_s()>0){%>������ <%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��<%}%>
								<%if(fee.getGrt_amt_s()>0 && fee.getPp_s_amt()>0){%><br><%}%>
								<%if(fee.getPp_s_amt()>0){%>������ <%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>��<%}%>
								<%if(fee.getGrt_amt_s()+fee.getPp_s_amt()>0 && fee.getIfee_s_amt()>0){%><br><%}%>
								<%if(fee.getIfee_s_amt()>0){%>���ô뿩�� <%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��<%}%>
							</td>
				    	</tr>
						<!--
				    	<tr>
				    		<th>���ô뿩��</th>
				    		<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
				    	</tr>
						-->
				    	<tr>
				    		<th>�� �� �� ��</th>
				    		<td><font color=#fd5f00><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</font></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%if(im_vt_size>0){%>
			<div id="carrow"><img src=/smart/images/arrow.gif /></div>
			<div id="ctitle">���ǿ���</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
       		  		<%	for(int i = im_vt_size-1 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>					
						<tr>
							<th width=125px>ȸ��</th>
							<td><%=im_ht.get("ADD_TM")%>ȸ��</td>
						</tr>
						<tr>
				    		<th>�뿩�Ⱓ</th>
				    		<td><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
				    	</tr>
        		 	<%	} %>						
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<%}%>
			<div id="carrow"><img src=/smart/images/arrow.gif /></div>
			<div id="ctitle">��Ÿ</div>	
			<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=125px>�ߵ����������</th>
							<td><%=fee.getCls_r_per()%>%</td>
						</tr>
				    	<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>��</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">����</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=110px>�� �� ȸ ��</th>
							<td><%=ins.getIns_com_nm()%></td>
						</tr>
						<tr>
							<th>���� �����</th>
							<td><%=ins.getConr_nm()%></td>
						</tr>
						<tr>
							<th>�� �� �� ��</th>
							<td><%=ins.getCon_f_nm()%></td>
						</tr>
						<tr>
				    		<th>�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</th>
				    		<td><%=ins.getConr_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>�����ڿ���</th>
				    		<td><%String age_scp = ins.getAge_scp();%><%if(age_scp.equals("2")){%>26���̻�<%}else if(age_scp.equals("4")){%>24���̻�<%}else if(age_scp.equals("1")){%>21���̻�<%}else if(age_scp.equals("5")){%>30���̻�<%}else if(age_scp.equals("6")){%>35���̻�<%}else if(age_scp.equals("7")){%>43���̻�<%}else if(age_scp.equals("8")){%>48���̻�<%}else if(age_scp.equals("3")){%>��������<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%if(ins.getVins_cacdt_cm_amt()>0){%><%=ins.getIns_com_nm()%><%}else{%>�Ƹ���ī<%}%></td>
				    	</tr>	
						<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;å&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
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
</body>
</html>