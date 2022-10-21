<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
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
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


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
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.client.*, acar.cus0402.*, acar.car_service.*, acar.cont.*, acar.car_register.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="c42_cvBn" class="acar.cus0402.Cycle_vstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	Cus0402_Database c42_db = Cus0402_Database.getInstance();
	CarServDatabase csD 	= CarServDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String dist			= request.getParameter("dist")==null?"":request.getParameter("dist");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�ڵ����������
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������-�������̺� ���� ��ȸ
	Hashtable sh_base = e_db.getBase(car_mng_id, AddUtil.getDate(4));
	
	ServiceBean si = csD.getServiceDist(car_mng_id, serv_id);
	
	if(serv_id.equals("") && !dist.equals("")){
		si = csD.getServiceDist2(car_mng_id, dist);
		serv_id = si.getServ_id(); 
	}
	
	//������ȸ
	Hashtable sv = csD.getService(car_mng_id, serv_id);
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function DistUpd()
	{
		var fm = document.form1;		
		fm.action = "car_dist_reg.jsp";	
		fm.target = "_self";	
		fm.submit();
	}			
	
	function DistDel()
	{
		var fm = document.form1;	
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){			return; }
		if(!confirm('������ �����Ͻðڽ��ϱ�?')){	return; }		
		if(!confirm('�ٽ��ѹ� �ɻ�����Ͽ� �����غ�����. �����Ͻðڽ��ϱ�?')){	return; }		
		
		fm.cmd.value = 'd';	
		fm.action = "car_dist_reg_a.jsp";	
		fm.target = "i_no";	
		fm.submit();
	}			
		
	function view_before()
	{
		var fm = document.form1;	
		fm.action = "nreg_main.jsp";	
		fm.target = "_self";	
		fm.submit();
	}			
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='serv_id'		value='<%=serv_id%>'>		
	<input type='hidden' name='cmd' 		value=''>		
	<input type='hidden' name='from_page'	value='car_dist_reg.jsp'>	

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">����Ÿ�����</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>��ȣ/����</th>
							<td valign=top><%=client.getFirm_nm()%></td>
						</tr>
						<tr>
							<th valign=top>������ȣ</th>
							<td valign=top><font color=#fd5f00><%=cr_bean.getCar_no()%></font></td>
						</tr>
						<tr>
							<th valign=top>����</th>
							<td valign=top><%=cr_bean.getCar_nm()%></td>
						</tr>
						<tr>
							<th valign=top>���翹������Ÿ�</th>
							<td valign=top><%=AddUtil.parseDecimal(String.valueOf(sh_base.get("TODAY_DIST")))%>km</td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">����Ÿ�</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="70">��������</th>
				    		<td><%=si.getServ_dt()%>
							</td>
				    	</tr>	
						<tr>
							<th>����Ÿ�</th>
							<td><%=si.getTot_dist()%>km</td>
						</tr>											
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn">
		<%if(AddUtil.parseInt(String.valueOf(sv.get("TOT_AMT"))) == 0){%>
		<%		if(si.getOff_nm().equals("��ȸ����") || si.getOff_nm().equals("")){%>
		<a href="javascript:DistUpd();"><img src=/smart/images/btn_modify.gif align=absmiddle border=0></a>
		&nbsp;		
		<a href="javascript:DistDel();"><img src=/smart/images/btn_del.gif align=absmiddle border=0></a>
		<%		}%>
		<%}%>		
	</div>	
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
