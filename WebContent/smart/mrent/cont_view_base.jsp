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
<%@ page import="acar.cont.*, acar.car_register.*, acar.fee.*, acar.credit.*, acar.insur.*, acar.res_search.* "%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //���Ǽ�
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//�ܱ���⺻����
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(rent_s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(rent_s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(rent_s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(rent_s_cd, "4");
	
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(rent_s_cd);
	
	//�ڵ����������
	if(!rc_bean.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(rc_bean.getCar_mng_id());
	}
	
	if(!rc_bean.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(rc_bean.getCar_mng_id());
		ins = ai_db.getIns(rc_bean.getCar_mng_id(), ins_st);
	}
	
	//������
	Vector exts = rs_db.getRentContExtList(rent_s_cd);
	int ext_size = exts.size();
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
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>
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
		<!--������-->
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">������</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<%if(!rc_bean2.getCust_st().equals("")){%>
						<tr>
							<th width=100px>�� ��</th>
							<td><%=rc_bean2.getCust_st()%></td>
						</tr>
					<%}%>
					<%if(!rc_bean2.getCust_nm().equals("")){%>
						<tr>
							<th >����</th>
							<td><%=rc_bean2.getCust_nm()%></td>
						</tr>
					<%}%>
					<%if(!rc_bean2.getSsn().equals("")){%>
						<tr>
				    		<th>�������</th>
				    		<td><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
				    	</tr>
					<%}%>
					<%if(!rc_bean2.getFirm_nm().equals("")){%>
				    	<tr>
				    		<th>��ȣ</th>
				    		<td><%=rc_bean2.getFirm_nm()%></td>
				    	</tr>
					<%}%>
					<%if(!rc_bean2.getEnp_no().equals("")){%>
						<tr>
				    		<th width=120px>����ڵ�Ϲ�ȣ</th>
				    		<td><%=rc_bean2.getEnp_no()%></td>
				    	</tr>
					<%}%>
					<%if(!rc_bean2.getAddr().equals("")){%>
						<tr>
				    		<th>�ּ�</th>
				    		<td>(<%=rc_bean2.getZip()%>)&nbsp;<%=rc_bean2.getAddr()%></td>
				    	</tr>
					<%}%>
					<%if(!rm_bean4.getTel().equals("")){%>
						<tr>
				    		<th>��ȭ��ȣ</th>
				    		<td><%=rm_bean4.getTel()%></td>
				    	</tr>
					<%}%>
					<%if(!rm_bean4.getEtc().equals("")){%>
						<tr>
				    		<th>�޴���</th>
				    		<td><%=rm_bean4.getEtc()%></td>
				    	</tr>
					<%}%>
					<%if(!rm_bean4.getLic_no().equals("")){%>
						<tr>
				    		<th>���������ȣ</th>
				    		<td><%=rm_bean4.getLic_no()%></td>
				    	</tr>
					<%}%>
					<%if(!rm_bean4.getLic_st().equals("")){%>
						<tr>
				    		<th>��������</th>
				    		<td>
							<%if(rm_bean4.getLic_st().equals("1")){%>2������<%}%>
							<%if(rm_bean4.getLic_st().equals("2")){%>1������<%}%>
							<%if(rm_bean4.getLic_st().equals("3")){%>1������<%}%>
							</td>
				    	</tr>
					<%}%>
					<%if(!rm_bean2.getMgr_nm().equals("")){%>
						<tr>
				    		<th>��󿬶�ó</th>
				    		<td>���� : <%=rm_bean2.getMgr_nm()%> ����ó : <%=rm_bean2.getTel()%> ���� : <%=rm_bean2.getEtc()%></td>
				    	</tr>
					<%}%>
					<%if(!rm_bean1.getMgr_nm().equals("")){%>
						<tr>
				    		<th>�߰�������</th>
				    		<td>����: <%=rm_bean1.getMgr_nm()%> ������� : <%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%> ���������ȣ : <%=rm_bean1.getLic_no()%> 
							�������� : <%if(rm_bean1.getLic_st().equals("1")){%>2������<%}%>
							<%if(rm_bean1.getLic_st().equals("2")){%>1������<%}%>
							<%if(rm_bean1.getLic_st().equals("3")){%>1������<%}%>
							��ȭ��ȣ : <%=rm_bean1.getTel()%>
							</td>
				    	</tr>
					<%}%>
					<!--
						<tr>
				    		<th>�������뵵</th>
				    		<td></td>
				    	</tr>
					-->
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<!--�������-->
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�������</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>�� �� �� ��</th>
							<td><%if(rc_bean.getRent_st().equals("12")){%>����Ʈ<%}%></td>
						</tr>
						<tr>
							<th width=100px>�� �� �� ȣ</th>
							<td><%=rc_bean.getRent_s_cd()%></td>
						</tr>
						<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
				    	</tr>
				    	<tr>
				    		<th>�� �� �� ��</th>
				    		<td><%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt())%> ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt())%></td>
				    	</tr>
						<%
							if(ext_size > 0){
								for(int i = 0 ; i < ext_size ; i++){
									Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
						<tr> 
							<th width=100px>���� [<%=i+1%>]</th>
							<td colspan="">
								������� : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
								| �뿩�Ⱓ : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp;                    	
								(<%=ext.get("RENT_MONTHS")%>����<%=ext.get("RENT_DAYS")%>��)                   	
							</td>
						</tr>
						  <%		
								}
							}%> 
						<tr>
							<th width=100px>���� ������</th>
							<td><%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
						</tr>
						<tr>
							<th width=100px>���� �����</th>
							<td><%=c_db.getNameById(rc_bean.getMng_id(),"USER")%></td>
						</tr>
					<%if(!rc_bean.getEtc().equals("")){%>	
						<tr> 
							<th width=100px>Ư �� �� ��</th>
							<td colspan=""><%=rc_bean.getEtc()%></td>
						</tr>
					<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<!--����/����-->
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">����/����</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>���������Ͻ�</th>
							<td><%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>
								<%=rc_bean.getDeli_plan_dt_h()%>��
								<%=rc_bean.getDeli_plan_dt_s()%>��
							</td>
						</tr>
						<tr>
							<th width=100px>�����Ͻ�</th>
							<td><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>
								<%=rc_bean.getDeli_plan_dt_h()%>��
								<%=rc_bean.getDeli_plan_dt_s()%>��
							</td>
						</tr>
						<tr>
				    		<th>���������</th>
				    		<td><%=c_db.getNameById(rc_bean.getDeli_mng_id(),"USER")%></td>
				    	</tr>
				    	<tr>
				    		<th>������ġ</th>
				    		<td><%=rc_bean.getDeli_loc()%></td>
				    	</tr> 
						<tr>
							<th width=100px>���������Ͻ�</th>
							<td><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>
								<%=rc_bean.getRet_plan_dt_h()%>��
								<%=rc_bean.getRet_plan_dt_s()%>��
							</td>
						</tr>
						<tr>
							<th width=100px>�����Ͻ�</th>
							<td><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>
								<%=rc_bean.getRet_dt_h()%>��
								<%=rc_bean.getRet_dt_s()%>��
							</td>
						</tr>
						<tr> 
							<th width=100px>������ġ</th>
							<td colspan=""></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<!--����-->
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
							<th>�� �� �� ��</th>
							<td><%=ins.getCon_f_nm()%></td>
						</tr>
						<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%=ins.getConr_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>������ ����</th>
				    		<td><%String age_scp = ins.getAge_scp();%><%if(age_scp.equals("2")){%>26���̻�<%}else if(age_scp.equals("4")){%>24���̻�<%}else if(age_scp.equals("1")){%>21���̻�<%}else if(age_scp.equals("5")){%>30���̻�<%}else if(age_scp.equals("6")){%>35���̻�<%}else if(age_scp.equals("7")){%>43���̻�<%}else if(age_scp.equals("8")){%>48���̻�<%}else if(age_scp.equals("3")){%>��������<%}%></td>
				    	</tr>
				    	<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%if(ins.getVins_cacdt_cm_amt()>0){%><%=ins.getIns_com_nm()%><%}else{%>�Ƹ���ī<%}%></td>
				    	</tr>	
						<tr>
				    		<th>��&nbsp;&nbsp;&nbsp;å&nbsp;&nbsp;&nbsp;��</th>
				    		<td><%=AddUtil.parseDecimal(rf_bean.getCar_ja())%>��</td>
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