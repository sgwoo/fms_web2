<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ea_bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");//0606J0366
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String mobile_yn	= request.getParameter("mobile_yn")	==null?"0":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")	==null?"0":request.getParameter("mail_yn");
	
	
	//���� ���� ���
	int car_nm_length=0;
	//��ȿ�Ⱓ
	String vali_date = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//�ܰ� ��������
	Hashtable sh_comp = new Hashtable();
	//���� Ȯ������
	Hashtable exam = new Hashtable();
	
	if (from_page.equals("/acar/estimate_mng/./images/line.gif")) {
		from_page = "/acar/estimate_mng/esti_mng_u.jsp";
	}
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
		sh_comp 	= shDb.getShCompare(est_id);
		exam 			= shDb.getEstiExam(est_id);
		vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
	}else{
		e_bean 		= e_db.getEstimateHpCase(est_id);
		sh_comp 	= shDb.getShCompareHp(est_id);
		exam 			= shDb.getEstiExamHp(est_id);
	}
	
	//Ȩ�������������� �⺻���� ��� ���Կɼ� �ο��� ����.
	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) e_bean.setOpt_chk("1");
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 	opt_chk 	= e_bean.getOpt_chk();
	
	
	String a_a = "";
	String rent_way = "";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	String a_b 		= e_bean.getA_b();
	float o_13 		= 0;
	
	//������������ ��ȸ
	String em_b_dt = e_db.getVar_b_dt("em", e_bean.getRent_dt());
	
	//���뺯��
	EstiCommVarBean em_bean = e_db.getEstiCommVarCase(a_a,  "", em_b_dt);
	
	//CAR_NM : ��������
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	// �ܻ� ������ ��� 1.�뿩���� �ϴܿ� ���� �߰� �۾�		2017-11-07
	boolean endDt = false;
	if(e_bean.getCar_id().length() > 0 && e_bean.getCar_seq().length() > 0){
		if(e_db.getEndDtEstimate(e_bean.getCar_id(), e_bean.getCar_seq()).equals("N")){
			endDt = true;
		}
	}
	
	//��������
	ea_bean = e_db.getEstiCarVarCase(a_e, a_a, "");
	
	//�����ڵ庯��
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	if(a_b.equals("12")) 		o_13 = ea_bean.getO_13_1();
	else if(a_b.equals("18")) 	o_13 = ea_bean.getO_13_2();
	else if(a_b.equals("24")) 	o_13 = ea_bean.getO_13_3();
	else if(a_b.equals("30")) 	o_13 = ea_bean.getO_13_4();
	else if(a_b.equals("36")) 	o_13 = ea_bean.getO_13_5();
	else if(a_b.equals("42")) 	o_13 = ea_bean.getO_13_6();
	else if(a_b.equals("48")) 	o_13 = ea_bean.getO_13_7();
	
	
	String name = "";
	String tel = "";
	
	String week_st = c_db.getWeek_st(AddUtil.getDate());  //1:�Ͽ��� , 7:�����
	int hol_cnt = c_db.getHoliday_st(AddUtil.getDate());  //����
	
	
//	�ٹ��ð���:08:30~20:30 ȸ����ȭ��ȣ ���� ������ȭ��ȣ:���ﺻ���ΰ��. ������ ������ȣ ���� 
   	int t_time = Integer.parseInt(AddUtil.getTime().substring(11,13) + AddUtil.getTime().substring(14,16)) ;
   	
   	String watch_id = c_db.getWatch_id(AddUtil.getDate() );  // ���� ���ͳ� ����
		
	String br_id = "S1";
	
	//default :���ﺻ�� ��ȭ��ȣ
	String check = "C";
	
	if (week_st.equals("1")  || week_st.equals("7") || hol_cnt > 0 ) {
		check = "P";
	} else  {
		if ( t_time >= 801 && t_time <= 2001 ){
			check = "C";
		} else {
		    check = "P";
		}
	}
	
	
	if ( check.equals("C")){
		name = "";
		tel =  "02-757-0802";
	} else {
		
		name = "";
		tel =  "02-392-4242";
		
	}
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!acar_id.equals("")){
		user_bean 	= umd.getUsersBean(acar_id);
		name 	= user_bean.getUser_nm();
		tel 	= user_bean.getUser_m_tel();
		br_id   = user_bean.getBr_id();
	}
	
	String temp_reg_dt = e_bean.getReg_dt();
    String result_reg_dt = "";
    if (temp_reg_dt.equals("") || temp_reg_dt == null) {
        SimpleDateFormat dt_format = new SimpleDateFormat("yyyyMMddHHmm");
        String temp_today = String.valueOf(dt_format.format(new Date()));
        result_reg_dt = temp_today.substring(0, temp_today.length()-2);
    } else {
        result_reg_dt = temp_reg_dt.substring(0, temp_reg_dt.length()-2);
    }
    int ref_reg_dt = AddUtil.parseInt(result_reg_dt);
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<title>������</title>
<style type="text/css">
<!--
.style1 {
	color: #dc0039;
	font-weight: bold;
	font-size: 22px;
}
.style2 {
	color: #706f6f;
	font-weight: bold;
}
.style3 {
	color: #333333;
}
.style4 {color: #000000;}
.style5 {color: #444444;}
.style7 {color: #1c75ba; font-weight: bold;}
.style8 {color: #354a6d}
.style9 {color: #5f52a0}
.style12 {color: #9cb445; font-weight: bold; }
.style13 {
	color: #c4c4c4;
	font-weight: bold;
}
.style14 {color: #dc0039;font-weight: bold; }
.endDt {font-weight: bold; text-decoration: underline; font-size: 13px}
.esti-title{
	font-size: 16px;
	font-weight: 900;
	padding-bottom: 2px;
	border-bottom: 1px solid #abcd32;
}
.esti-num{
	font-size: 18px;
	color: #abcd32;
	margin-right: 5px;
	border-bottom: 3px solid #abcd32;
}
.esti-title-sub{
	font-size: 12px;
}
.page-separate{
	page-break-after: always
}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point == -1){
		$('#contiRatDesc').text( contiRatDesc + "(���տ������)");
	}else{
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(���տ������)");
	}
	
})
</script>
<script language="JavaScript" type="text/JavaScript">

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
	//���񱳺���
	function go_compare(est_id){
		var SUBWIN="./m_compare.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=717, height=600, scrollbars=yes, status=yes");
	}

	//�μ��ϱ�
	function go_print(est_id){		
		var fm = document.form1;
		fm.est_id.value = est_id;
// 		fm.action = "esti_print.jsp";
// 		fm.target = "_blank";
// 		fm.submit();		
		window.onbeforeprint = function(){
			document.getElementById('esti_button_tr').style.display = 'none';
		}
		
		window.onafterprint = function(){
			document.getElementById('esti_button_tr').style.display = 'table-row';
		}
		
		window.print();
	}	
	//���ϼ����ϱ�
	function go_mail(est_id){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=acar_id%>&write_id=<%=e_bean.getReg_id()%>&from_page=<%=from_page%>&opt_chk=<%=opt_chk%>&est_email=<%=e_bean.getEst_email()%>&content_st=hp";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=300, scrollbars=no, status=yes");
	}
	
	//�غ񼭷�����
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=770, status=no, scrollbars=no, resizable=no");
	}
	
	//�⺻��纸���ֱ�
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=760, height=480, scrollbars=yes, status=yes, resizable=no");
	}	
	
	// �׸� ��ȣ ����
	function setEstiNum(){
		var esti_num = document.getElementsByClassName('esti-num');
		var esti_count = 0;
		for(var i=0; i<esti_num.length; i++){
			esti_count++;
			esti_num[i].innerHTML = '0'+esti_count;
		}
	}
//-->
		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
</head>
<body topmargin=0 leftmargin=0  onload='javascript:setEstiNum();'>
<form action="" name="form1" method="POST" >
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="est_id" value="<%=est_id%>">
<input type="hidden" name="acar_id" value="<%=acar_id%>">
<input type="hidden" name="mobile_yn" value="<%=mobile_yn%>">
<input type="hidden" name="content_st" value="hp">
<table width=680 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3><img src=./images/title.gif width=680 height=39></td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellspacing=0 cellpadding=0>
            				<tr>
            		      <td colspan="3" height=17><div align="right"><span class=style2>
            		      	<%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20170930 && AddUtil.parseInt(AddUtil.getDate(4)) < 20171010){%>
            		      	2017-09-30
            		      	<%}else{%>
            			      <%=AddUtil.getDate()%>
            			      <%}%>
            			      </span>&nbsp;</div>
            			    </td>
            				</tr>
			                <tr> 
			                  	<td width=282> 
			                  		<table width=282 border=0 cellspacing=0 cellpadding=0>
			                      		<tr> 
			                        		<td height=35 colspan=2 valign=top>&nbsp;<span class=style1>[ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> 
			                          	] </span></td>
			                      		</tr>
			                      		<tr> 
			                        		<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                      	<tr> 
				                        	<td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td width=258><div align="left"><span class=style2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ����</span></div></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td><span class=style2>TEL.</span></td>
				                        </tr>
				                        <tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
				                        <tr>
				                        	<td height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
				                        	<td><span class=style2>FAX.</span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=2><img src=./images/est_line.gif></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                  	<td width=18>&nbsp;</td>
			                  	<td width=356 valign=bottom> 
			                  		<table width=356 border=0 cellpadding=0 cellspacing=0 background=./images/est_tel_bg.gif>
				                      	<tr> 
				                        	<td colspan=3 height=14></td>
				                      	</tr>
				                      	<tr> 
				                        	<td width=54 height=18></td>
				                        	<td width=155 class=listnum2><span class=style5>���ǵ������� <%if(br_id.equals("S1")){%><%= tel %><%= name %><%}else{%>02-757-0802<%}%></span></td>
				                      		<td width=147 class=listnum2><span class=style5>��ȭ������ <%if(br_id.equals("S5")){%><%= tel %><%= name %><%}else{%>02-2038-8661<%}%></span></td>
				                      	</tr> 
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;&nbsp;&nbsp;<%if(br_id.equals("S2")){%><%= tel %><%= name %><%}else{%>02-537-5877<%}%></span></td>
				                        	<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("S6")){%><%= tel %><%= name %><%}else{%>02-2038-2492<%}%></span></td>
				                      		
				                      	</tr> 
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>�� õ �� �� &nbsp;<%if(br_id.equals("I1")){%><%= tel %><%= name %><%}else{%>032-554-8820<%}%></span></td>
				                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("K3")){%><%= tel %><%= name %><%}else{%>031-546-8858<%}%></span></td>
				                      	</tr>  
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>042-824-1770<%}%></span></td>
				                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("G1")){%><%= tel %><%= name %><%}else{%>053-582-2998<%}%></span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=18></td>
				                        	<td class=listnum2><span class=style5>�� �� �� �� &nbsp;<%if(br_id.equals("B1")){%><%= tel %><%= name %><%}else{%>051-851-0606<%}%></span></td>
				                      		<td class=listnum2><span class=style5>�� �� �� �� <%if(br_id.equals("J1")){%><%= tel %><%= name %><%}else{%>062-385-0133<%}%></span></td>
				                      	</tr>                           	
				                      	<tr> 
				                        	<td colspan=2 height=12></td>
				                      	</tr>  
			                    	</table>
			                    </td>
			                </tr>
			                <tr> 
			                  	<td colspan="3" height="10"></td>
			                </tr>
			                <!-- <tr> 
			                  	<td colspan="3" height="17">&nbsp;�� �ͻ翡�� �����Ͻ� ���뿩�� ���Ͽ� �Ʒ��� ���� ������ �����Ͽ��� 
			                    �����Ͻð� ���� �亯 ��Ź�帳�ϴ�.</td>
			                </tr> -->
             	 		</table>
             	 	</td>
          		</tr>
          		<tr> 
            		<td height=10 colspan="2"></td>
          		</tr>
		    	<tr> 
		            <td colspan="2">
		            	<%if(e_bean.getEco_e_tag().equals("1")){ //�������ｺƼĿ�߱� ���� ���Ǻ���(20190208)%>
		            	<%	//�ǵ������ ����
		            		int reg_loc_st = 0;	//default:����
		            		if(ej_bean.getJg_g_7().equals("3")){//������
								if(e_bean.getEcar_loc_st().equals("0")){ //����
								}else if(e_bean.getEcar_loc_st().equals("1")){ //��õ,���
								}else if(e_bean.getEcar_loc_st().equals("2")){ //���� 	
								}else if(e_bean.getEcar_loc_st().equals("3")){ //���� 
									reg_loc_st = 4;	//����
								}else if(e_bean.getEcar_loc_st().equals("4")){ //����,����,����	
								}else if(e_bean.getEcar_loc_st().equals("5")){ //�뱸
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("6")){ //�λ�,���,�泲
									reg_loc_st = 3;	//�λ�
								}else if(e_bean.getEcar_loc_st().equals("8")||e_bean.getEcar_loc_st().equals("9")){ //���,���/�泲
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("10")){ //����,����(��������)
								}
		            		
								reg_loc_st = 0;	//20191031����
		            		
							}else if(ej_bean.getJg_g_7().equals("4")){//������ 
								if(e_bean.getHcar_loc_st().equals("0")){ //����,���
								}else if(e_bean.getHcar_loc_st().equals("1")){ //��õ 
									reg_loc_st = 5;	//��õ
								}else if(e_bean.getHcar_loc_st().equals("2")){ //����
								}else if(e_bean.getHcar_loc_st().equals("3")){ //���� 
									if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //��Ʈ
									}else if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){ //����
										reg_loc_st = 4;	//����
									}
								}else if(e_bean.getHcar_loc_st().equals("4")){ //����,����,����
									reg_loc_st = 6;	//����
								}else if(e_bean.getHcar_loc_st().equals("5")){ //�뱸,���
								}else if(e_bean.getHcar_loc_st().equals("6")){ //�λ�,���,�泲
									reg_loc_st = 2;	//�λ�
						  		}else if(e_bean.getHcar_loc_st().equals("7")){ //����,�泲,���(��������)
						  		}	
							
								reg_loc_st = 5;	//20200410 ��õ
							}	
		            	%>
		            	<div style="position: relative;">
<!-- 							<img src=./images/bar_01.gif width=638 height=22> -->
							<div class='esti-title'><span class='esti-num'></span> �뿩����</div>
							<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
								<div style="font-size: 10.8px; padding-top: 7px;">
								�� �� ���� ���������� ���Ҽ� 3.5% ���� ������ ���Ҽ� 5% ���� ȯ�� ���������� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>��<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(ģȯ���� �������� �� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>��)<%}%> �����Դϴ�.
								</div>
							<%} %>
							<span style="position: absolute; top:0; right:0;">
								<%if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){	//������,������%>
									<%if(reg_loc_st==0){ //�ǵ������ ���� %>
										<!-- �� �������ｺƼĿ(�����ͳ� �̿� �����±�) �߱� -->
									<%}else{ %>
										<!-- �� �������ｺƼĿ(�����ͳ� �̿� �����±�) �߱޺Ұ� -->
									<%} %>
								<%}else if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")){ //������,������ �̿� ģȯ���� %>
									<%if(reg_loc_st==0){ //�ǵ������ ���� %>
										�� �������ｺƼĿ(�����ͳ� �̿� �����±�) �߱�
									<%}else{ %>
										�� �������ｺƼĿ(�����ͳ� �̿� �����±�) �߱޺Ұ�
									<%} %>
								<%} %>
							</span>
						</div>
						<%}else{%>
						<!-- <img src=./images/bar_01.gif width=638 height=22> -->
							<div style="position: relative;">
								<div class='esti-title'><span class='esti-num'></span> �뿩����</div>
								<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
									<div style="font-size: 10.8px; padding-top: 7px;">
									�� �� ���� ���������� ���Ҽ� 3.5% ���� ������ ���Ҽ� 5% ���� ȯ�� ���������� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>��<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(ģȯ���� �������� �� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>��)<%}%> �����Դϴ�.
									</div>
								<%} %>
								<span style="position: absolute; top:0; right:0;">
									<%-- <%if(ej_bean.getJg_2().equals("1")){	//������,������%>		
										[���������� �����Һ� �������� ����]
									<%}%> --%>
									<%if(cm_bean.getDuty_free_opt().equals("0")){ %>
										[���������� �����Һ� �������� ����]
									<%}else if(cm_bean.getDuty_free_opt().equals("1")){ %>
										[���������� �����Һ� �鼼���� ����]
									<%} %>
								</span>
							</div>
						<%}%>
		            </td>
		    	</tr>
		     	<tr> 
		            <td height=4 colspan="2"></td>
		    	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
			                  	<td width=419 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4><%=cm_bean.getCar_comp_nm()%></span></td>
			                  	<td width=100 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7
			                  		><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"
			                  		><%if(cm_bean.getCar_nm().equals(cm_bean.getCar_name())){ car_nm_length = cm_bean.getCar_nm().length();%>
			                  		<%=cm_bean.getCar_nm()%><%}else{ car_nm_length = cm_bean.getCar_nm().length()+cm_bean.getCar_name().length(); %>
			                  		<%=cm_bean.getCar_nm()+" "+cm_bean.getCar_name()%><%}%></a>
			                  		<%if(car_nm_length>=32){%><br><%}%>
			                  		<%
				                  			//���� �⵵���� �� �⵵ �����Ͱ� ������ �Ⱥ�����
			            					String car_y_form = "";
			                  				if(cm_bean.getCar_y_form_yn().equals("Y")){//20190610 ��������������ǥ�⿩��
				            					if(AddUtil.getDate2(1) <= AddUtil.parseInt(cm_bean.getCar_y_form())){
				            			   			car_y_form = "[" + cm_bean.getCar_y_form() + "����]";
				            					}
			                  				}
			                  		%>
			                  		<%=car_y_form%>
			                  		</span> 
			                  	</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style7><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=e_bean.getOpt()%></a></span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <%if(!e_bean.getConti_rat().equals("")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� </span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;&nbsp;<span id="contiRatDesc"><%=e_bean.getConti_rat()%></span></td>
			                    <td bgcolor=#FFFFFF></td>
			                </tr>
			                <%}%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� Ÿ</span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;
			                    	<%-- <%if( ej_bean.getJg_g_7().equals("3") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0 ){%>
			                  			�� �� ������ ����� ���� �������� 2022�� ������ Ȯ�� ����� ���뿩�ᰡ ���� �� �� �ֽ��ϴ�.<br>
			                  		<%}%> 2022.02.18. �ش� ���� ��ǥ�� ��û���� �ּ�ó��. --%>
			                  		<%if(e_bean.getDc_amt()>0){%>������D/C (<%=e_bean.getRent_dt().substring(4, 6)%>�� �������)&nbsp;<%=e_bean.getEsti_d_etc()%><%}%>
			                  		<%if(e_bean.getDc_amt()>0 && !e_bean.getEtc().equals("")){%><br>&nbsp;&nbsp;<%}%>
                  					<%if(!e_bean.getEtc().equals("") ){%><%=e_bean.getEtc()%><%}%>
                  					
                  					<%-- <%if (ref_reg_dt <= 2022070500) {%>
	                  					<%if(cm_bean.getJg_code().equals("5048111")){ // �ֿ� �䷹��%>
					                  		�� ������� ����ǥ ���� ���� �� �������� ���� �����Դϴ�. ��Ȯ�� ���������� ���� ����Ͽ� Ȯ���� �����Դϴ�. ���� �������ݰ� Ȯ�� ���������� ���̰� �� ��� [�������� ���� �� �뿩������] (vat����, �ʿ�������������)�� ���뿩�ᰡ �λ�˴ϴ�.
					                  	<%}%>
				                  	<%}%> --%>
				                  	
				                  	<%if (ref_reg_dt >= 2022100400 && ref_reg_dt <= 2022103024) {%>
					                  	<%if(cm_bean.getJg_code().equals("5055111") || cm_bean.getJg_code().equals("5055112") || cm_bean.getJg_code().equals("5055113") ){ // �Ｚ XM3 %>
					                  		�� ������� ����ǥ ���� ���� �� �������� ���� �����Դϴ�. ��Ȯ�� ���������� ���� ����Ͽ� Ȯ���� �����Դϴ�. ���� �������ݰ� Ȯ�� ���������� ���̰� �� ��� [�������� ���� �� �뿩������] (vat����, �ʿ�������������)�� ���뿩�ᰡ �λ�˴ϴ�.
					                  	<%}%>
				                  	<%}%>
				                  	
				                  	<%if (ref_reg_dt >= 2022080100 && ref_reg_dt < 2022082200) {%>
					                  	<%if(cm_bean.getJg_code().equals("3016111")){ // ���̿���6%>
					                  		�� �� ������ ����� ���� �������� ��Ȯ�� �������� �� �ɼǰ����� ���� ����Ͽ� Ȯ���� �����Դϴ�.
				   							(�� �������δ� ����� Ȯ������ ������, ������� ��������θ� Ȱ��ٶ��ϴ�)
					                  	<%}%>
				                  	<%}%>
                  					<%-- <%if(cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
                  						�� ����ȭ������ ��� ���� ����ü ������ ������� �ʰ� �����̳�, ���� ������ �߰� ���� ����� ������ �� �ֽ��ϴ�.
                  					<%}%> --%>
                  					<%-- <%if(cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {%>
                  						�� 8�� �ε�����
                  					<%}%>
                  					<%if(cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")) {%>
                  						�� 9�� �ʼ��� �ε�����
                  					<%}%> --%>
                  					<%-- <%if( cm_bean.getJg_code().equals("5315112") ) {%>
				                  		�� 11�� �߼��� �ε�����
				                  	<%}%> --%>
				                  	<%-- <%if( cm_bean.getJg_code().equals("6015111") || cm_bean.getJg_code().equals("6015112") || cm_bean.getJg_code().equals("6015113") || cm_bean.getJg_code().equals("6015114") ) {%>
	                  					2021��4/4�б� �ű���� �������� �������� �����ǰų� ����� ���ɼ��� �ſ� �����ϴ�.
				                  	<%}%> --%>
			                  	</td>
                  				<td align=right bgcolor=#FFFFFF><span class=style3><%if(e_bean.getDc_amt()>0){%>-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%> 
                    				��<%}%></span>&nbsp;</td>
			                </tr>
			                <!-- ���Ҽ� ���� -->
			                
						<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
			                <%if (ej_bean.getJg_3()*100 == 0 || cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("2361") || cm_bean.getJg_code().equals("2362") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("2031111") || cm_bean.getJg_code().equals("2031112") || cm_bean.getJg_code().equals("5033111")) {%>
			                <tr style="display: none;"> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ���� </span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;�����Һ� �� ������ ����</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			     	        <%} else if ((ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) && e_bean.getTax_dc_amt() > 0 ) {//ģȯ����%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ���� </span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;�����Һ� �� ������ ����</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <%} else if (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) {%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ���� </span></td>
			                  	<td bgcolor=#FFFFFF>
			                  	<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_190"))) > 0) {%>
									&nbsp;&nbsp;�����Һ� �ѽ��� ���� 70% ����(2020.3~6��) �Ⱓ�� �ʰ��Ͽ�, �����Һ�����<br>
									&nbsp;&nbsp;3.5%(2020.7~12��)�� �����Ǿ� ���� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>��(���ް�) �λ�˴ϴ�.
									<%} else {%>
										&nbsp;&nbsp;�����Һ� �ѽ��� ����Ⱓ(2020.3~6��)�� �ʰ��Ͽ� ��� �� ��� �뿩��� �λ�˴ϴ�.
									<%}%>
			                  	<%}%>
								</td>
			                  	<td align=right bgcolor=#FFFFFF>
			                  		<%if (e_bean.getTax_dc_amt() == 0) {%>
			                  		<span class=style4>���Ҽ� ����ȿ��&nbsp;<br>������ �ݿ�</span>&nbsp;
			                  		<%} else {%>
			                  		<span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>��</span>&nbsp;
			                  		<%}%>
			                  	</td>
			                </tr>                
			                <%} else {%>                
				                <%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20200301) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20200630)) {%>
				                <tr > 
				                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ���� </span></td>
				                  	<td bgcolor=#FFFFFF>
										<!-- &nbsp;&nbsp;�����Һ� �ѽ��� ����Ⱓ(2020.3~6��)�� �ʰ��Ͽ� ��� �� ��� �뿩��� �λ�˴ϴ�. -->
										<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_190"))) > 0) {%>
										&nbsp;&nbsp;�����Һ� �ѽ��� ���� 70% ����(2020.3~6��) �Ⱓ�� �ʰ��Ͽ�, �����Һ�����<br>
										&nbsp;&nbsp;3.5%(2020.7~12��)�� �����Ǿ� ���� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>��(���ް�) �λ�˴ϴ�.
										<%} else {%>
											&nbsp;&nbsp;�����Һ� �ѽ��� ����Ⱓ(2020.3~6��)�� �ʰ��Ͽ� ��� �� ��� �뿩��� �λ�˴ϴ�.
										<%}%>
									</td>
				                  	<td align=right bgcolor=#FFFFFF>
				                  		<%if (e_bean.getTax_dc_amt() == 0) {%>
				                  		<span class=style4>���Ҽ� ����ȿ��&nbsp;<br>������ �ݿ�</span>&nbsp;
				                  		<%} else {%>
				                  		<span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>��</span>&nbsp;
				                  		<%}%>
				                  	</td>
				                </tr>
				                <%}%>
			                <%}%>
		                <%} else {%>
		                	<!-- �������� �ƴϸ鼭 ���һ� ���� �ѵ�(����������, �ΰ�����)�� 0���� ũ�� �����Һ� �� ������ ����. ��Ʈ ����. -->
		                	<%if (!ej_bean.getJg_w().equals("1") && !cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031112") && e_bean.getTax_dc_amt() > 0) {%>
		                		<tr> 
				                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ����</span></td>
				                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;�����Һ� �� ������ ����</td>
				                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
				                    ��</span>&nbsp;</td>
				                </tr>
		                	<%} else{ %>
		                	<!-- �� �� ���� ������ �����Һ�(�����Һ� �����ѵ� �ʰ��ݾ�)�� 0���� ũ�� ���� ������ �����Һ� -->
			                	<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_216"))) > 0) {%>
			                		<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20210101)) {// && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20220705)%>
				                		<tr>
						                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�����Һ�</span></td>
						                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;���� ������ �����Һ� (�����Һ� �����ѵ� �ʰ��ݾ�)<br>&nbsp;&nbsp;�� ��� ������ �����Һ� 3.5% ���� �ݾ�(�ִ� �����ѵ� ������)</td>
						                  	<%if (e_bean.getTax_dc_amt() > 0) {%>
						                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
						                    ��</span>&nbsp;</td>
						                  	<%}%>
						                  	<%if (e_bean.getTax_dc_amt() < 0) {%>
						                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(-1*e_bean.getTax_dc_amt())%> 
						                    ��</span>&nbsp;</td>
						                  	<%}%>
						                </tr>
				                	<%}%>
			                	<%}%>
		                	<%} %>
		                	<%-- <%if (AddUtil.parseInt(String.valueOf(exam.get("BK_216"))) > 0) {%>
                				<%if ((AddUtil.parseInt(e_bean.getRent_dt()) >= 20210101) && (AddUtil.parseInt(e_bean.getRent_dt()) <= 20220105)) {%>
                					<tr> 
					                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�����Һ�</span></td>
					                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;���� ������ �����Һ� (�����Һ� �����ѵ� �ʰ��ݾ�)<br>&nbsp;&nbsp;�� ��� ������ �����Һ� 3.5% ���� �ݾ�(�ִ� �����ѵ� ������)</td>
					                  	<%if (e_bean.getTax_dc_amt() > 0) {%>
					                  		<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
					                    	��</span>&nbsp;</td>
					                  	<%}%>
					                  	<%if (e_bean.getTax_dc_amt() < 0) {%>
					                  		<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(-1*e_bean.getTax_dc_amt())%> 
					                    	��</span>&nbsp;</td>
					                  	<%}%>
					                </tr>
			                	<%}%>
			                <%} else {%>
		                		<%if (!cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031112") && e_bean.getTax_dc_amt() > 0) {%>
			                		<tr> 
					                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���Ҽ� ���� </span></td>
					                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;�����Һ� �� ������ ����</td>
					                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> 
					                    ��</span>&nbsp;</td>
					                </tr>
			                	<%}%>
			                <%}%> --%>
		                <%}%>
			                
			                <tr> 
			                  	<td height=20 align=center bgcolor=f2f2f2><span class=style3>��������</span></td>
			                  	<td bgcolor=#FFFFFF style="font-size:11px;">
			                  	<%
			                  	int info_end_dt = 2021010514;
			                  	if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
			                  		info_end_dt = 2021011514;
			                  	}
			                  	
								//������ �̰ų� ���̺긮��,�÷������̺긮�� �̰ų� Ư������ ����ǥ��
			                  	Boolean etc_jg_code_match = false;
			                  	String[] etc_jg_code = {
		                  			"2179", 
		                  			"4115", "4116", "4117", "4149", "4150", "4160", 
		                  			"4264", "4265", 
		                  			"5155", "5156", "5171", "5172", "5173", 
		                  			"5229", "5230", "5271", "5272", "5273", "5274", 
		                  			"5351", "5352",
		                  			"6134", "6135", "6136", "6137", "6161", "6162", "6163", 
		                  			"6255", "6256", "6271", "6272",
		                  			
		                  			"2013714", 
		                  			"4012621", "4012622", "4012623", "4016311", "4016312", "4016313", 
		                  			"4024121", "4024122", 
		                  			"5018411", "5018412", "6018111", "6018112", "6018113", 
		                  			"5026111", "5026112", "6022411", "6022412", "6022413", "6022414", 
		                  			"3053511", "3053512",
		                  			"6016111", "6016112", "6016113", "6016114", "6018116", "6018117", "6018118", 
		                  			"6024411", "6024412", "6022416", "6022417"
		                  		};
			                  	for (int j = 0; j < etc_jg_code.length; j++) {
			                		if (etc_jg_code[j].equals(cm_bean.getJg_code())) {
			                			etc_jg_code_match = true;
			                		}
			                	}
			                  	%>
			                  	
			                  	<%if (ref_reg_dt >= 2020083113 && ref_reg_dt <= 2020121812) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_198"))) > 0) {%>
				                   		<span class=style4>&nbsp;�� 2021��1��1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>��(���ް�) �λ�˴ϴ�.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020121813 && ref_reg_dt <= 2020123123) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_213"))) > 0) {%>
				                   		<span class=style4>&nbsp;�� 2021��1��1������ ������ ���Ǹ� �����Һ��� �ѽ��� ���� ���忡�� �ұ��ϰ� �����Һ� ���� �ѵ�(100����) �ʰ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_213"))))%>��(���ް�) �λ�˴ϴ�.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020083113 && ref_reg_dt <= 2020123123) {%>
			                  		<%-- <%if (ej_bean.getJg_w().equals("1") || (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) || etc_jg_code_match == true || !e_bean.getInfo_st().equals("N")) {%> --%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_206"))) > 0) {%>
										<span class=style4>&nbsp;�� 2021��1��1�� ���� ������ ���Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_206"))))%>��(���ް�) �λ�˴ϴ�.</span>
					                <%}%>
					                <%-- <%}%> --%>
			                  	<%}%>
			                    
                  <%
                  int reference_date = 20200101;
                  //�������� ������ ������ �ٸ��� ����
                  if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
                	  reference_date = 20200108;
                  }
                  
                  if((AddUtil.parseInt(AddUtil.getDate(4)) >= 20181114 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20181114) && AddUtil.parseInt(e_bean.getRent_dt()) <= reference_date){
                  %>	
                  
                  <%	//20181114 2019�� �����Һ� ȯ�� �� ���ź����� ���� �ȳ�
						//20190923 ����
                    	double fee_add_amt1 = 0;	//�����Һ� ȯ���� ���� ���뿩�� �λ�ݾ�
                    	double fee_add_amt2 = 0;	//���ź����� �����ߴܿ� ���� ���뿩�� �λ�ݾ�
                    	String fee_add_text1 = "";
                    	String fee_add_text2 = "";
                    	int car_c_amt = e_bean.getCar_amt()+e_bean.getOpt_amt()+e_bean.getCol_amt()-e_bean.getDc_amt();
                    	double fee_pp_amt = e_bean.getFee_s_amt()+(e_bean.getPp_s_amt()/AddUtil.parseDouble(e_bean.getA_b()));		//���뿩��+������/������
                    	//����������ȿ�� 20191108
                    	double grt_mo_amt = 0;
                    	if (e_bean.getGtr_amt() > 0) {
                    		//grt_mo_amt = e_bean.getGtr_amt()*0.06/12*0.014;
                    		grt_mo_amt = e_bean.getGtr_amt()*(em_bean.getA_f_2()/100)/12*0.014;
                    	}	 
                    	//20191108 0.015->0.014 ����
                    	//�⺻�����Һ񼼰� �ִ�.
                    	if(ej_bean.getJg_3()*100 >0){
                    		//������ 20190923	
                    		if(ej_bean.getJg_g_7().equals("3")){
                    			//���Ҽ���������
                    			double car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("O_3")))/1.1;
                    			//�������� ��������������鼼��
                    			if(ej_bean.getJg_w().equals("1")){
                    				car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("K_SU_4")))/1.1;
                    			}
                    			if(car_c_amt2<=60000000){
                    				fee_add_amt1 = 0;
                    			}else if(car_c_amt2>85714286){
                       				fee_add_amt1 = fee_pp_amt*0.014;
                       			}else{
                       				fee_add_amt1 = (car_c_amt2-60000000)/25714286*0.014*fee_pp_amt;                       				
                       			}
							//���� 20190923
                    		}else if(ej_bean.getJg_g_7().equals("4")){
                    			fee_add_amt1 = 0;
							//���̺긮��,�÷������̺긮��
                    		}else if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){
                    			if(car_c_amt<=23001000){
                    				fee_add_amt1 = 0;
                    			}else if(car_c_amt>=32858571){
                       				fee_add_amt1 = fee_pp_amt*0.014;
                       			}else{
                       				fee_add_amt1 = ((car_c_amt/1.0455*0.065)-1430000)/car_c_amt*0.75*fee_pp_amt;                       			
                       			}
                       		//�׿�	
                       		}else{
                       			fee_add_amt1 = fee_pp_amt*0.014;
                       		}
                    		if(fee_add_amt1 > 0){
                    			fee_add_amt1 = fee_add_amt1+grt_mo_amt;
                    			fee_add_amt1 = (double)e_db.getTruncAmt((int)fee_add_amt1, "1", "round", "-2");
                    		}
                    		//�����Һ� ȯ�� ����
                    		//0���� ������ ǥ�����
                    		if(fee_add_amt1 < 0) fee_add_amt1 = 0;
                    		
                    		if (fee_add_amt1 > 0) {
                    			fee_add_text1 = "�ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ���<br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt1)+"��(���ް�) �λ�˴ϴ�.";	//��������(20190527)
                    		}
                    		
                    	}
                    	//���̺긮��
                    	if(AddUtil.parseInt(AddUtil.getDate(4)) <= 20181231){ //20181227
	                    	if(ej_bean.getJg_g_7().equals("1") && ej_bean.getJg_g_8().equals("1") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0){
	                    		fee_add_amt2 = (double)e_db.getTruncAmt((int)(AddUtil.parseDouble(String.valueOf(exam.get("BK_128")))/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    		if(fee_add_amt2 > 0) {
	                    			fee_add_text2 = "2019��1��1�� ���� ������ ���Ǹ� ���̺긮�� ���ź����� �����ߴܿ� ���� <br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt2)+"��(���ް�) �λ�˴ϴ�.";
	                    		}
	                    	}
                    	}
                    	//20191007 2020����� ���̺긮�� ��漼 ���� ���� ��� ���� �߰�
                    	fee_add_amt2 = 0;
                    	//���̺긮��,�÷������̺긮��
                    	if(AddUtil.parseInt(AddUtil.getDate(4)) <= 20191231 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20191231){ 
	                    	if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){
	                    		if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //��Ʈ
	                    			double car_c_amt2 = AddUtil.parseDouble(String.valueOf(exam.get("S_D")));	                    		
	                    			if(car_c_amt2<=22500000){
	                    				fee_add_amt2 = 0;
	                    			}else if(car_c_amt2>=35000000){
	                    				fee_add_amt2 = (double)e_db.getTruncAmt((int)(500000/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    			}else{
	                    				fee_add_amt2 = (double)e_db.getTruncAmt((int)((car_c_amt2-22500000)*0.04/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    			}
	                    		}else{ //����
	                    			fee_add_amt2 = (double)e_db.getTruncAmt((int)(500000/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    		}
	                    	}
                    		if(fee_add_amt2 > 0) {
                    			fee_add_text2 = "2020��1��1�� ���� ������ ���Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� <br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt2)+"��(���ް�) �λ�˴ϴ�.";
                    		}
                    	}
                  %>
                  
                  <%	if(!fee_add_text1.equals("")){%>&nbsp; <%=fee_add_text1%><%}%>
                  <%	if(!fee_add_text1.equals("") && !fee_add_text2.equals("")){%><br>&nbsp; <%}%>
                  <%	if(fee_add_text1.equals("") && !fee_add_text2.equals("")){%>&nbsp; <%}%>
                  <%	if(!fee_add_text2.equals("")){%><%=fee_add_text2%><%}%>
                  
                  <%}else if(AddUtil.parseInt(e_bean.getRent_dt()) >= 20190101){%>	

                    <%if(ej_bean.getJg_g_7().equals("2") && e_bean.getEcar_pur_sub_amt()>0 ){%>
                    <!-- ģȯ�����ϰ��-->&nbsp;&nbsp;ģȯ���� ���ź����� <%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>���� ���뿩�� ���� �ݿ���
                    <%}%>
                  
                  <%}else{%>
                  	
                    <%//20170105 �ӽ� �ҽ� ����
                    	
                  	  if((ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("4")) && e_bean.getEcar_pur_sub_amt()>0 ){
                    %>
                    <!-- ģȯ�����ϰ��-->&nbsp;&nbsp;ģȯ���� ���ź����� <%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>���� ���뿩�� ���� �ݿ���
                    <%}%>
                  
                  
                    <%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20161108 && AddUtil.parseInt(AddUtil.getDate(4)) < 20161117){%>
                    <%	if(AddUtil.parseInt(cm_bean.getJg_code()) >=  4135 && AddUtil.parseInt(cm_bean.getJg_code()) < 4139){%>
                    <span class=style4>�� ��Ȯ�� �������� �� �ɼǰ����� ���� ����Ͽ� Ȯ�� ����(�� ������ ����� ���� ������)</span>
                    <%	}%>
                    <%}%>
                  <%}%>
			                  	
                    <%if((e_bean.getCar_id().equals("006171") || e_bean.getCar_id().equals("006172")) && (e_bean.getA_a().equals("21") || e_bean.getA_a().equals("22"))){%>
                    &nbsp;&nbsp;<span class=style4>�� �������� ���������� �����Һ� ���԰��� �Դϴ�.(���� ��� ���������� ������ ����ǥ�� �����ϰ� �����Һ� �鼼��(<%=AddUtil.parseDecimal(e_bean.getO_1()/1.065)%>��)�� ȯ���Ͽ� ����)</span>
                    <%}%>
                    
	                  <!-- ��� MQ4 -->                  
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200219 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200219) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200317 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200317)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("5271") || cm_bean.getJg_code().equals("5273") || cm_bean.getJg_code().equals("6271")){%>
			              	<span class=style4>�� ������� �Ⱓ �� ������ �� �������� ��� ����� Ȯ���� �� �������� �ʰ� �ݾ��� 30���� �̳��̸� ���뿩�� �λ��� �����ϴ�.</span>
			              <%}%>
	                  <%}%>
	                  
	                  <!-- ��� MQ4 ���̺긮�� -->                  
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200219 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200219) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200310 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200310)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("5272") || cm_bean.getJg_code().equals("5274") || cm_bean.getJg_code().equals("6272")){%>
			              	<span class=style4>�� ������� �Ⱓ �� ������ �� �������� ��� ����� Ȯ���� �� �������� �ʰ� �ݾ��� 30���� �̳��̸� ���뿩�� �λ��� �����ϴ�.</span>
			              <%}%>
	                  <%}%>    
	                  
	                  <!-- �ƹݶ� CN7 -->
	                  <%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20200325 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20200325) && (AddUtil.parseInt(AddUtil.getDate(4)) <= 20200406 || AddUtil.parseInt(e_bean.getRent_dt()) <= 20200406)) {%>
	                  	  <%if(cm_bean.getJg_code().equals("2176") || cm_bean.getJg_code().equals("2177")){%>
			              	<span class=style4>�� ������� �Ⱓ �� ������ �� �������� ��� ����� Ȯ���� �� �������� �ʰ� �ݾ��� 20���� �̳��̸� ���뿩�� �λ��� �����ϴ�.</span>
			              <%}%>
	                  <%}%>           
                    
                    <!-- 20200701 �ѽ��� �ȳ��� -->
                  	<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && !cm_bean.getJg_code().equals("3871") && !cm_bean.getJg_code().equals("3313111")) {%>
	                  	<%if (ref_reg_dt >= 2020070100 && ref_reg_dt <= 2020070813) {%>
	               	  		<span class=style4>�� 7��1���ڷ� �����Һ����� ����(���� ���� �� ���� ����)�ʿ� ���� ���� ������ ����˴ϴ�. ���� 7��1�� �ڷ� ����Ǵ� ���������� ���������� �ݿ����̶�, �� �������� ���� ���������� ������ ���������� �� �ֽ��ϴ�. �������� ���� �ݿ����� ���������� ����Ǵ� ��� ���뿩�ᵵ ����Ǵ� �� �� ���� �ٶ��ϴ�. (�ñ��� ���� ������ ������� �������� ���� �ٶ��ϴ�.)</span>
	               	  	<%}%>
                  	<%} else {%>
	                  	<%if (ref_reg_dt >= 2020070100 && ref_reg_dt <= 2020070113) {%>
	               	  		<span class=style4>�� 7��1���ڷ� �����Һ����� ����(���� ���� �� ���� ����)�ʿ� ���� ���� ������ ����˴ϴ�. ���� ����(7��1��) �ڷ� ����Ǵ� ���������� ���������� �ݿ����̶�, �� �������� ���� ���������� ������ ���������� �� �ֽ��ϴ�. �������� ���� �ݿ����� ���������� �������� ��� ���뿩�ᵵ ���ϵǴ� �� �� ���� �ٶ��ϴ�. (�ñ��� ���� ������ ������� �������� ���� �ٶ��ϴ�.)</span>
	               	  	<%}%>
                  	<%}%>
                    
					<%if (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) {%>
                  	<% if(ej_bean.getJg_g_15() > 0 && e_bean.getEcar_loc_st().equals("13")){ // ������ ���ּ��� ������ ���� ���� ���� �� + �������� 0���� ŭ%>
                  		<span class=style4>&nbsp;&nbsp;[������ ���� ����]</span>
                  	<%} else if (e_bean.getCar_comp_id().equals("0056")) { // �׽��� ����%>
                  		<%if (ej_bean.getJg_g_15() > 0) { // �������� �ִ� ���%>
                  			<span class=style4>�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�. ���� �������� ���� �Ǵ� ����� �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.</span>
                  		<%} else{ // �������� ���� ���%>
                  			<span class=style4>�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�.</span>
                  		<%}%>
                  	<%} else if (ej_bean.getJg_g_15() > 0) { // ģȯ���� ���л� ����/������ + �������� �ִ� ���%>
                  		<span class=style4>�� ������ ���� �Ǵ� ����, ���� ������� ������ �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.</span>
                  	<%} %>
                    <!-- �׽��� -->               
               	  <%-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>
               	  	<% if(e_bean.getEcar_loc_st().equals("13")){ %>
                  		<span class=style4>�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�.<br>[������ ���� ����]</span>
	               	 <%} else {%>
                  		<span class=style4>�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�. ���� �������� ���� �Ǵ� ����� �뿩�ᰡ ����ǰų�  ��������� �Ұ��� �� �� �ֽ��ϴ�.</span>
					<%}%>
                  <%} else if (cm_bean.getJg_code().equals("5866")) {%>
                  	<span class=style4>�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�.</span>
               	  <%} else {%>
              	 	  	<% if(!e_bean.getEcar_loc_st().equals("13")){ %>
               		  		<span class=style4>�� ������ ���� �Ǵ� ����, ���� ������� ������ �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.</span>
						<%} else{%>
              	 	  		<% if(! (cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113")) ){ %>
               		  			<span class=style4>&nbsp;&nbsp;[������ ���� ����]</span>
							<%}%>
						<%}%>
               	  <%}%> --%>
           	  	<%}%>
					
                <%if (ref_reg_dt >= 2021070200) {%>
                	<%if( ej_bean.getJg_3() > 0 && AddUtil.parseInt(String.valueOf(exam.get("BK_198"))) > 0 ){ // �⺻�����Һ���(ej_bean.getJg_3())�� 0���� ũ�� �����Һ� ���� ȯ�� �� ���뿩�� �λ�ݾ�(bk_198)�� 0���� Ŭ ��	%>
                		<%if( ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4") ){  // ģȯ���� ���л� ����/������%>
               				<span class=style4>�� 2023�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ �λ�˴ϴ�.</span>
						<%} else {%>
               				<span class=style4>�� 2023�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>��(���ް�) �λ�˴ϴ�.</span>
						<%}%>
					<%}%>
				<%}%>
                    
			                  	</td>
			                	<td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
              			</table>
              		</td>
          		</tr>
          		
          		<tr> 
		            <td height=10 colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1>
		                	<%if(endDt){%><!-- �ܻ� ���� ���� 2017.11.08 -->
		                	<tr>
		                		<td><span class="endDt">�� ���� �ߴܵ� �����Դϴ�. ���� ����ڸ� ���ؼ� ��� ������ Ȯ���ϰ� �����Ͻñ� �ٶ��ϴ�.</span></td>
		                	</tr>
		                	<%}%>
		                    <tr>
		                        <td colspan='2'>
		                        	<%if(ej_bean.getJg_g_7().equals("3")){ //������
		                        		if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { 	// ����ȭ����
		                        	%>
		                        		<%if(e_bean.getLoc_st().equals("1")){%>�� ���� �ε� ���� : ����
										<%} else if(e_bean.getLoc_st().equals("2")){%>�� ���� �ε� ���� : ��õ/���
										<%} else if(e_bean.getLoc_st().equals("3")){%>�� ���� �ε� ���� : ����
										<%} else if(e_bean.getLoc_st().equals("4")){%>�� ���� �ε� ���� : ����/����/�泲/���
										<%} else if(e_bean.getLoc_st().equals("5")){%>�� ���� �ε� ���� : ����/����/����
										<%} else if(e_bean.getLoc_st().equals("6")){%>�� ���� �ε� ���� : �뱸/���
										<%} else if(e_bean.getLoc_st().equals("7")){%>�� ���� �ε� ���� : �λ�/���/�泲
										<%} %>	
		                        	<%	
		                        		} else {		// ����¿���
		                        	%>
			                        	<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") ){
			                        		// ������ ���ּ����� ����, ��õ�� �� %>
		                        		�� [�����: ����� ������, �谳��: �ֹε�ϵ�� �ּ���, �鰳�λ����: ��ǥ�� �ֹε�ϵ�� �ּ���]
			                        		<% if(e_bean.getEcar_loc_st().equals("0")){ %>
			                        			����
			                        		<%} else if(e_bean.getEcar_loc_st().equals("1")){ %>
			                        			��õ
			                        		<%} %> ���� ����
		                        		<%} else{%>
		                        			<%if(e_bean.getLoc_st().equals("1")){%>�� ���� �ε� ���� : ����
											<%} else if(e_bean.getLoc_st().equals("2")){%>�� ���� �ε� ���� : ��õ/���
											<%} else if(e_bean.getLoc_st().equals("3")){%>�� ���� �ε� ���� : ����
											<%} else if(e_bean.getLoc_st().equals("4")){%>�� ���� �ε� ���� : ����/����/�泲/���
											<%} else if(e_bean.getLoc_st().equals("5")){%>�� ���� �ε� ���� : ����/����/����
											<%} else if(e_bean.getLoc_st().equals("6")){%>�� ���� �ε� ���� : �뱸/���
											<%} else if(e_bean.getLoc_st().equals("7")){%>�� ���� �ε� ���� : �λ�/���/�泲
											<%} %>
		                        		<%} 
		                        		}%>
                						
                					<%}else if(ej_bean.getJg_g_7().equals("4")){//������ (20190208)%>
                						<%-- <%if(e_bean.getHcar_loc_st().equals("0")){ //����,��� %>
                							�� ���� ���ź����� ���� ����.
                						<%}else if(e_bean.getHcar_loc_st().equals("1")){ //��õ %>
                							�� ��õ ���ź����� ���� ����.
                						<%}else if(e_bean.getHcar_loc_st().equals("2")){ //���� %>	
                							�� ���� ���ź����� ���� ����.
               							<%}else if(e_bean.getHcar_loc_st().equals("3")){ //���� %>
               								<%if(e_bean.getA_a().equals("21")||e_bean.getA_a().equals("22")){ //��Ʈ%>
               								�� ���� ���ź����� ���� ����.
               								<%}else if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){ //����%>
                							�� ���� ���ź����� ���� ����.
                							<%} %>
                						<%}else if(e_bean.getHcar_loc_st().equals("4")){ //����,����,���� %>
                							�� ���� ���ź����� ���� ����.	
                						<%}else if(e_bean.getHcar_loc_st().equals("5")){ //�뱸,��� %>
                							�� ���� ���ź����� ���� ����.	
               							<%}else if(e_bean.getHcar_loc_st().equals("6")){ //�λ�,���,�泲 %>
                							�� �λ� ���ź����� ���� ����.	
                					  	<%}else if(e_bean.getHcar_loc_st().equals("7")){ //����,�泲,���(��������) %>
                							�� ���� ���ź����� ���� ����.
                					  	<%}%>	 --%>
                					  	<%if(e_bean.getLoc_st().equals("1")){%>�� ���� �ε� ���� : ����
										<%}else if(e_bean.getLoc_st().equals("2")){%>�� ���� �ε� ���� : ��õ/���
										<%}else if(e_bean.getLoc_st().equals("3")){%>�� ���� �ε� ���� : ����
										<%}else if(e_bean.getLoc_st().equals("4")){%>�� ���� �ε� ���� : ����/����/�泲/���<!-- ��û -->
										<%}else if(e_bean.getLoc_st().equals("5")){%>�� ���� �ε� ���� : ����/����/����<!-- ���� -->
										<%}else if(e_bean.getLoc_st().equals("6")){%>�� ���� �ε� ���� : �뱸/���
										<%}else if(e_bean.getLoc_st().equals("7")){%>�� ���� �ε� ���� : �λ�/���/�泲
										<%}%>
                					<%}else{%><!-- 2018�� ����ü ���ź����� ������ ���� �۾��Ϸῡ ���� �ҽ�����(2018.02.07) -->
    									<%if (!cm_bean.getJg_code().equals("5866") && !cm_bean.getJg_code().equals("4854") && !cm_bean.getJg_code().equals("6316111") && !cm_bean.getJg_code().equals("4314111")) {%>
	    									<%if(e_bean.getLoc_st().equals("1")){%>�� ���� �ε� ���� : ����
	    									<%}else if(e_bean.getLoc_st().equals("2")){%>�� ���� �ε� ���� : ��õ/���
	    									<%}else if(e_bean.getLoc_st().equals("3")){%>�� ���� �ε� ���� : ����
	    									<%}else if(e_bean.getLoc_st().equals("4")){%>�� ���� �ε� ���� : ����/����/�泲/���<!-- ��û -->
	    									<%}else if(e_bean.getLoc_st().equals("5")){%>�� ���� �ε� ���� : ����/����/����<!-- ���� -->
	    									<%}else if(e_bean.getLoc_st().equals("6")){%>�� ���� �ε� ���� : �뱸/���
	    									<%}else if(e_bean.getLoc_st().equals("7")){%>�� ���� �ε� ���� : �λ�/���/�泲
	    									<%}%>
    									<%}%>
    								<%}%>
								</td>    
		                        <td align="right">
					<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//��׹���ǻ��,����%>
					�� LPG/�ֹ��� �����
					<%}else{%>			
					<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		�� ��������
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	�� LPG������
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	�� ���ָ�����
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	�� ���̺긮��
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	�� �÷����� ���̺긮��
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	�� ������
					<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	�� ������
					<%	}else{%>
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>		�� ��������
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>	�� LPG������
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>	�� ���ָ�����
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>	�� ���̺긮��
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>	�� �÷����� ���̺긮��
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>	�� ������
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>	�� ������
							<%}%>
					<%	}%>
					<%}%>			
					</td>
				    </tr>
				</table>
			    </td>	    	
          		</tr> 
          		<tr>
          			<td height=5></td>
          		</tr>
          		<tr> 
		            <td colspan="2">
<!-- 		            	<img src=./images/bar_2022_04.jpg width=638 height=22> -->
		            	<div class='esti-title'>
							<span class='esti-num'></span>
							��������Ÿ� 
							<sapn class='esti-title-sub'>(��������Ÿ� ���� ����� ȯ�޴뿩�� ����)</sapn>
						</div>
		            </td>
				</tr>
				
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75><span class=style3>��������Ÿ�</span></td>
		            			<td bgcolor=ffffff rowspan=3 align=center width=110><span class=style14><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km���� / 1��</span></td>
		            			<td align=center bgcolor=f2f2f2 height=17 rowspan=3 width=75>
		            				<span class=style3>��������Ÿ���<br>���� ����</span>
		            			</td>
		            			<td bgcolor=f2f2f2 height=17> 
		            			  &nbsp;&nbsp; <b>(�������Ͽ����) ȯ�޴뿩��</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            			  <%if(e_bean.getRtn_run_amt_yn().equals("1")){ // ȯ�޴뿩�� ������%>
		            			  	������
		            			  <%} else{%>
		            			  	<%=e_bean.getRtn_run_amt()%>��/1km	(�ΰ�������)
		            			  <%} %>
		            			</td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17>
		            			  &nbsp;&nbsp; <b>(�����ʰ������) �ʰ�����뿩��</b>&nbsp;&nbsp;&nbsp;&nbsp;<%=e_bean.getOver_run_amt()%>��/1km	(�ΰ�������)
		            			</td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=ffffff height=17> &nbsp;&nbsp;
		            				<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){//�⺻��%>
		            				���Կɼ� ���ÿ��� (�������Ͽ����) ȯ�޴뿩�ᰡ ���޵��� �ʰ�, (�����ʰ������) �ʰ�����뿩�ᰡ �����˴ϴ�. (�⺻��)
		            				<%}%>
		            			</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>     
				<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20141223){%>
                                <tr> 
				    <td colspan=2 height=22>&nbsp;<span class=style3>* ��������Ÿ��� ���̸� �뿩����� ���ϵǰ�, ��������Ÿ��� �ø��� �뿩����� �λ�˴ϴ�.</span></td>
                                </tr>
				<%}%>    		
          		<tr>
          			<td height=5></td>
          		</tr>         		
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=208>			                  	
							  	<%if(!e_bean.getIns_per().equals("2")){%>
							  	        <%if(e_bean.getEst_nm().indexOf("602") == -1 && e_bean.getEst_nm().indexOf("482") == -1 && e_bean.getEst_nm().indexOf("362") == -1 && e_bean.getEst_nm().indexOf("242") == -1 && e_bean.getEst_nm().indexOf("122") == -1){%>
<!-- 							  		<img src=/acar/main_car_hp/images/bar_02.gif width=208 height=22> -->
							  		<div class='esti-title'>
										<span class='esti-num'></span>
										�뿩��� 
										<sapn class='esti-title-sub'>(����� ����)</sapn>
									</div>
									<%}else{%>
<!-- 									<img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
									<div class='esti-title'>
										<span class='esti-num'></span>
										�뿩��� 
										<sapn class='esti-title-sub'>(����� ������)</sapn>
									</div>
									<%}%>
							  	<%}else{%>
<!-- 							  	<img src=/acar/main_car_hp/images/bar_02_1.gif width=208 height=22> -->
							  	<div class='esti-title'>
									<span class='esti-num'></span>
									�뿩��� 
									<sapn class='esti-title-sub'>(����� ������)</sapn>
								</div>
							  	<%}%>				  
							  	</td>
			                  	<td width=30>&nbsp;</td>
			                  	<td width=400>
<!-- 			                  	<img src=./images/bar_03.gif width=400 height=22> -->
			                  	<div class='esti-title'>
									<span class='esti-num'></span>
									���躸�����
								</div>
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td height=1 colspan=3></td>
			                </tr>
                			<tr> 
                  				<td> 
                  					<table width=208 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
				                        	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>�뿩�Ⱓ</span></td>
				                        	<td width=113 align=right bgcolor=#FFFFFF><span class=style4><%=e_bean.getA_b()%>����</span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� �� </span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style4><%if (e_bean.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getDriver_add_amt()*0.9)%> ��<%}%></span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� �� </span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style4><%if (e_bean.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_v_amt()+e_bean.getDriver_add_amt()*0.1)%> ��<%}%></span>&nbsp;&nbsp;</td>
				                      	</tr>
				                      	<tr> 
				                        	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���뿩��</span></td>
				                        	<td align=right bgcolor=#FFFFFF><span class=style14><%if (e_bean.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()+e_bean.getDriver_add_amt())%> ��<%}%></span>&nbsp;&nbsp;</td>
			                      		</tr>
                    				</table>
                    			</td>
			                  	<td>&nbsp;</td>
			                 	<td> 
								  <%if(e_bean.getEst_nm().indexOf("602") == -1 && e_bean.getEst_nm().indexOf("482") == -1 && e_bean.getEst_nm().indexOf("362") == -1 && e_bean.getEst_nm().indexOf("242") == -1 && e_bean.getEst_nm().indexOf("122") == -1){%>
								  	<table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
					                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
					                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>����(���� 
					                          ��,��) </span></td>
					                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
					                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>1�δ� 
					                          �ְ� 2��� </span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>1���</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>��26���̻�</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>1���</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>����⵿</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4><%if(ej_bean.getJg_w().equals("1")){%>50����<%}else{%>30����<%}%></span></td>
					                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
					                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
				                      	</tr>
				                    </table>
								<%}else{%>
								  	<table width=400 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				                      	<tr> 
					                        <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
					                        <td width=106 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
					                        <td width=92 align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
					                        <td width=105 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
					                        <td align=center bgcolor=f2f2f2><span class=style3>����⵿</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
				                      	</tr>
				                      	<tr> 
					                        <td height=17 align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
					                        <td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
					                        <td align=center bgcolor=f2f2f2>&nbsp;</td>
					                        <td align=center bgcolor=#FFFFFF>&nbsp;</td>
				                      	</tr>
				                    </table>
								<%}%>
				  				</td>
                			</tr>
                			<tr>
	          	<!-- ����/���ڽ� ǥ�� -->    
                <td class=listnum2 valign=top  colspan="2">
                <%if(ref_reg_dt >= 2021090600){ %>
	          	<%if( !(e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057") 
	          			|| (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200 )) ) { // �׽���, ����Ÿ, ����Ƽ/�ް�Ʈ�� ����%>
						<!-- ���� -->
						&nbsp;<span class=style3><%if(e_bean.getTint_sn_yn().equals("Y")){%>* ���ĸ� ���� ����<%} else{ %>* ����/���ĸ� ���� ����<%} %></span>
						<!-- ���ڽ� -->
						&nbsp;
						<span class=style3>
						<%if(e_bean.getTint_bn_yn().equals("Y")){%>* ���ڽ� ������ ����
						<%} else{ %>
							<%if( Integer.parseInt(cm_bean.getJg_code()) > 9000000 ){%>* ���ڽ� ����
							<%} else{ %>* 2ä�� ���ڽ� ����<%}%>
						<%} %>
						</span>
                <%} %>
                <%} %>
                </td>
                </tr>
			   <!-- ��ȣ�� -->
			   <tr>
			   	<td colspan=3 class=listnum2 valign=top>
			   	<%if(ref_reg_dt >= 2021090600){ %>
                <%-- <%if( ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4") || Integer.parseInt(cm_bean.getJg_code()) > 8000000
                		|| !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){%> --%>        
                <%if( ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || Integer.parseInt(cm_bean.getJg_code()) > 8000000
                		|| !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){%>        
						<%if(ej_bean.getJg_b().equals("5")){ // ���� ���л� ������%>
						&nbsp;<span class=style3>* ������ �����ȣ��</span>
						<%} else if(ej_bean.getJg_b().equals("6")){ // ���� ���л� ������%>
						&nbsp;<span class=style3>* ���������� �����ȣ��</span>
						<%-- <%} else if( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ){ // ����/ȭ����%> --%>
						<%} else if( Integer.parseInt(cm_bean.getJg_code()) > 9018110 && Integer.parseInt(cm_bean.getJg_code()) < 9018999 ){ %>
						&nbsp;<span class=style3>* ����Ʈ�� �Ϲ�(����)��ȣ��</span>
						<%} else if( !(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) ){ // �� �� ������ȣ�� �Ϻη� ��û�� ��� %>
						&nbsp;<span class=style3>* ����Ʈ�� �Ϲ�(����)��ȣ��</span>
						<%} %>
                <%}%>
                <%}%>
                </td>
			   </tr>
                			
                			<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
			                <tr>
			                	<td colspan="3" align="right">�� �������� �Ƹ���ī ���� ������忡�� ����&nbsp;</td>
			                </tr>
			                <%}%>

                			
		        		<!--��ǰ-->
		        		<%if(e_bean.getTint_s_yn().equals("Y") || e_bean.getTint_n_yn().equals("Y") || e_bean.getTint_eb_yn().equals("Y")){%>        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>* 
								�� �뿩��� 
	                                <%if( e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>���� ������<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>��ġ�� ������̼���<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>�̵��� �����Ⱑ<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") && !e_bean.getTint_eb_yn().equals("Y")){%>���� ����, ��ġ�� ������̼���<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") && !e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>���� ����, �̵��� �����Ⱑ<%}%>
	                                <%if(!e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>��ġ�� ������̼�, �̵��� �����Ⱑ<%}%>
	                                <%if( e_bean.getTint_s_yn().equals("Y") &&  e_bean.getTint_n_yn().equals("Y") &&  e_bean.getTint_eb_yn().equals("Y")){%>���� ����, ��ġ�� ������̼�, �̵��� �����Ⱑ<%}%>
                               	���Ե� �ݾ��Դϴ�.
                                </strong></span>
                            </td>
                        </tr>                        
                        <%}%>                			
						<%-- <%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>
		                <tr> 
							<td height=20 colspan=3 class=listnum2>&nbsp;* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong>
							</td>
		                </tr>
						<%}%> --%>
<%-- 						<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%> --%>
						<%if(AddUtil.parseInt(cm_bean.getS_st()) <= 101 || AddUtil.parseInt(cm_bean.getS_st()) == 409 || AddUtil.parseInt(cm_bean.getS_st()) >= 601 ){%>
		                <tr> 
							<td height=20 colspan=3 class=listnum2>&nbsp;* �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� <strong>���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.</strong>
							</td>
		                </tr>
						<%}%>						
						<%if(e_bean.getTint_ps_yn().equals("Y")){%> 
		                <tr>
			                <td colspan=3 class=listnum2 valign=top>
							<%if(e_bean.getTint_ps_st().equals("Y")){%>        
								&nbsp;<span class=style3>* ���ñ���: ��޽���</span>
		                	<%}else if(e_bean.getTint_ps_st().equals("N")){%>
		                	<%}else if(e_bean.getTint_ps_st().equals("I")){ %>
		                		&nbsp;<span class=style3>* <%=e_bean.getTint_ps_nm()%></span>
		                	<%} %>
			                </td>
		                </tr>
		                <%}%>		
              			</table>
              		</td>
          		</tr>
          		<tr> 
					<td height=10 colspan="2"></td>
				</tr>
				
	          	<tr> 
	             	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2">
<!-- 	            		<img src=./images/bar_2022_05.jpg width=638 height=22> -->
	            		<div class='esti-title'>
							<span class='esti-num'></span>
							�ʱⳳ�Ա�
						</div>
	            	</td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=75 height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� ��</span></td>
			                  	<td width=93 align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
			                    ��</span>&nbsp;</td>
			                  	<td width=82 align=center bgcolor=f2f2f2><span class=style4>������ 
			                    <%=Math.round(e_bean.getRg_8())%>% </span></td>
			                  	<td width=383 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>�������� 
						  	���Ⱓ ���� �� ȯ���� �帳�ϴ�.&nbsp;[������ 100������ �����ϸ�, <br>&nbsp;&nbsp;���뿩�� 5,500��(VAT����)�� ���ϵ˴ϴ�.&nbsp;(�⸮ 6.6% ȿ��)]</span></td>
<!-- 						  	���Ⱓ ���� �� ȯ���� �帳�ϴ�.&nbsp;[������ 100������ �����ϸ�, <br>&nbsp;&nbsp;���뿩�� 4,620��(VAT����)�� ���ϵ˴ϴ�.&nbsp;(�⸮ 5.5% ȿ��)]</span></td> -->
							</tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� ��</span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> ��</span>&nbsp;</td>
			                  	<td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>�������� �ſ� ���� �ݾ׾� 
			                    �����Ǿ� �Ҹ�Ǵ� ���Դϴ�. </span><br>&nbsp;&nbsp;<span class=style4 style="letter-spacing:-1.5px;">�� ���ݰ�꼭�� ����̿�Ⱓ ���� �ſ� �յ� ���� �Ǵ� ���ν� �Ͻ� ���� �� ���ð���</span></td><!-- 2018.01.22 -->
			                </tr>
			                <%if(e_bean.getG_10() > 0){ %>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���ô뿩��</span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> ��</span>&nbsp;</td>
			                  	<td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>���ô뿩��� ������ (<%=e_bean.getG_10()%>)����ġ 
			                    �뿩�Ḧ �����ϴ� ���Դϴ�. </span></td>
			                </tr>
			                <%} %>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� </span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style14><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>
			                    ��</span>&nbsp;</td>
			                  	<td colspan=2  bgcolor=f2f2f2> &nbsp;&nbsp;&nbsp; <span class=style4>���� �뿩����� ���� �ʱⳳ�Ա� ����ȿ���� �ݿ��� �ݾ��Դϴ�.</span></td>
			                </tr>
              			</table>
              		</td>
	          	</tr>
			  	<%if(e_bean.getIfee_s_amt()>0){%>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=206 height=17 align=center bgcolor=f2f2f2><span class=style3>���뿩�� 
			                    �ܿ�����ȸ��</span></td>
			                  	<td width=82 align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>ȸ</span></td>
			                  	<td width=346 bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style4>���ô뿩�Ḧ 
			                    ������ ��츸 ����Ǵ� �����Դϴ�. </span></td>
			                </tr>
              			</table>
              		</td>
          		</tr>
		  		<%}%>
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* �ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.</span></td>
      </tr>		  		
			<!--�����ܰ���-->
			<%if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){//fms����%>
			<%	if(opt_chk.equals("1")){%>
                <tr> 
                    <td height=10 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
<!--                     <img src=images/bar_2022_06.jpg width=638 height=22> -->
                    <div class='esti-title'>
							<span class='esti-num'></span>
							���� �ܰ���
						</div>
                    </td>
                </tr>
                <tr> 
                    <td height=4 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>�����ܰ���</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%=e_bean.getRo_13()%>%</span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>�����ܰ��� = ���Կɼ���</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>���Կɼǰ���</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>��</span>&nbsp;&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>�� ���Կɼǰ��ݿ� �̿������� ������ �� �ִ� �Ǹ��� �帳�ϴ�.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
			<%	}%>			
			<%}else{//�ֿ���������%>
			<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
                <tr> 
                    <td height=10 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2">
<!--                     	<img src=images/bar_2022_06.jpg width=638 height=22> -->
                    	<div class='esti-title'>
							<span class='esti-num'></span>
							���� �ܰ���
						</div>
                    </td>
                </tr>
                <tr> 
                    <td height=4 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>�����ܰ���</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%=e_bean.getRo_13()%>%</span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>�����ܰ��� = ���Կɼ���</span></td>
                            </tr>
                            <tr> 
                                <td height=17 align=center bgcolor=f2f2f2><span class=style3>���Կɼǰ���</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>��</span>&nbsp;&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4>VAT����</span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;&nbsp;<span class=style4>�� ���Կɼǰ��ݿ� �̿������� ������ �� �ִ� �Ǹ��� �帳�ϴ�.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
			<%	}%>			
			<%}%>
<!--�����ܰ���-->
          		<tr> 
					<td height=10 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2">
		            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
					<img src=/acar/main_car_hp/images/bar_2022_08.jpg>
		            <%}else{%>
		            <img src=./images/bar_2022_07_yj.jpg width=638 height=22>
		            <%	}%> --%>
		            <div class='esti-title'>
						<span class='esti-num'></span>
						�ߵ����������
					</div>
		            </td>
				</tr>
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=17><span class=style3>�ߵ����������</span></td>
		            			<td colspan=2 bgcolor=ffffff> &nbsp;&nbsp;�ߵ������ÿ��� �ܿ����Ⱓ �� �뿩���� <span class=style14><%if(e_bean.getCls_per()>0){%><%=e_bean.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%>30<%}%>%</span> �� ������� ����</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>
          		<tr> 
            		<td height=10 colspan="2"></td>
	          	</tr>
	          	<!--�������� ���� ��������-->
	          	<tr> 
	            	<td colspan="2">
	            	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=./images/bar_07_1_2.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=./images/bar_07_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=./images/bar_07_3.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- ���� �Ϸ�Ʈ�� �������񽺴� �Ϲ� ������� �¿� �� RV �������� ���� 2019.12.12 -->
	            	        <img src=./images/bar_07_4.png width=638 height=22>
	            	        <%}else{%>
	            	        <img src=./images/bar_2022_07.jpg width=638 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=./images/bar_06_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=./images/bar_06_3.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- ���� �Ϸ�Ʈ�� �������񽺴� �Ϲ� ������� �¿� �� RV �������� ���� 2019.12.12 -->
	            	        <img src=./images/bar_06_4.png width=638 height=22>
	            	        <%}else{%>
	            	        <img src=./images/bar_06_1.gif width=638 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%> --%>
	            	    <div class='esti-title'>
								<span class='esti-num'></span>
								�������� ���� ��������
								<sapn class='esti-title-sub'>(���뼭�񽺿� üũ�� ��ĭ�� ���񽺰� �����˴ϴ�)</sapn> 
								<sapn style='font-size: 10px; letter-spacing: -1px;'>
									<%if(ej_bean.getJg_k().equals("0")){%>
			            	        �� �������� ������
			            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
			            	        �� �������񽺴� �¿� �� RV�� ����
			            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
			            	        �� �������񽺴� �Ϲ� ��������������� ����
			            	        <%}else if(ej_bean.getJg_k().equals("4")){%><!-- ���� �Ϸ�Ʈ�� �������񽺴� �Ϲ� ������� �¿� �� RV �������� ���� 2019.12.12 -->
			            	        �� �������񽺴� �Ϲ� ������� �¿� �� RV�� ����
			            	        <%}%>
								</sapn>
							</div>
	            	</td>
	          	</tr>
          		<tr> 
		          <td colspan="2" valign=top> 
		          		<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                  	<tr> 
		                     	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���뼭��</span></td>
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* ������ �߻��� <span class=style3><b>���ó�� ���� ����</b></span><%}%> &nbsp;&nbsp;&nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style3> <b>����������</b></span>(���ػ��ô� �������)<%}%> </td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>�⺻��</b> (���񼭺� ������ ��ǰ)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>�Ϲݽ�</b> (���񼭺� ���� ��ǰ)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=95>&nbsp; <span class=style3><b>* �Ƹ����ɾ� ����</b></span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ���� ���� ���� ��㼭�� ��� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� �̳� ���� ������� ����<%if(e_bean.getCar_comp_id().equals("0056")) {%>(�׽������� ����)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰��)<br> 
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� ���� ���� ������ ���� ������� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* ��ü�� ���񼭺�</b></span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ������ ���� ��޼��� ����<br>
		                   		&nbsp;<span class=style3><b> * �����������</b></span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4�ð� �̻� ������� �԰��</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
				
				<tr> 
		            <td height=10 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2">
		            <%-- <%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
		            <img src=/acar/main_car_hp/images/bar_2022_09.jpg width=638 height=22>
		            <%}else{%>
		            <img src=./images/bar_08.gif width=638 height=22>
		            <%	}%> --%>
		            <div class='esti-title'>
						<span class='esti-num'></span>
						��Ÿ�뿩����
					</div>
		            </td>
				</tr>
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2" align=center> 
		            	<table width=621 border=0 cellspacing=0 cellpadding=0>
		            		<tr> 
			                  	<td width=28 height=17 align=right style='vertical-align: baseline'><img src=./images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>
			                  	�������� ���� ��ǰ�� ����, ���� ���� �Ǵ� ���� ��å(������� �ǹ�����, ��Ⱑ������, �������� ��) ������<br>���������� �����ǰų� ���� ������å�� ����� ��� ��� �����ݾ��� ���� �� �� �ֽ��ϴ�.
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td width=20 height=17 align=right><img src=./images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>���, �ڵ����� ����<%if (!e_bean.getCar_comp_id().equals("0056")) {%>, ����˻�<%}%> 
			                    � �Ƹ���ī���� ó��(�� ��� �δ� ����) </td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>Ȩ���������� �뿩���� ������������ �������� [FMS(Fleet Management System)]</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>			                  	
			                  	<td colspan=2 align=left class=listnum2>
			                  		<span class=style4>�뿩�Ⱓ ����ÿ��� �ݳ�, �����̿�<%if( !(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) ) {%> (���ο�� ����)<%}%>, ���Կɼ� ��� �� ���� ����</span>
			                  	</td>
			                  	<%-- <td colspan=2 align=left class=listnum2>
			                  		�뿩�Ⱓ ����ÿ��� �ݳ�, �����̿�
			                  		<%if(!e_bean.getCar_comp_id().equals("0056") && (!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237") && !cm_bean.getJg_code().equals("9015435") && !cm_bean.getJg_code().equals("9025435") && !cm_bean.getJg_code().equals("9015436") && !cm_bean.getJg_code().equals("9015437") && !cm_bean.getJg_code().equals("9025439") && !cm_bean.getJg_code().equals("9025440") )) {%>
			                  		(���ο�� ����)
			                  		<%}%>
			                  		<%if(opt_chk.equals("1")){%>, ���Կɼ� ���<%}%> �� ���� ����
			                  	</td> --%>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("21")){%>
			                <tr> 
			                  	<td height=17 align=right><img src=./images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>���Ⱓ ���� 
			                    �Ʒ��ݾ��� ����(����)�������� ��������(�ſ�����ü ����) </td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td colspan=4 height=3></td>
			                </tr>
			                <%if (e_bean.getGi_fee() > 0) {%>
							<tr>
								<td colspan=4 align=right style="font-weight: bold;">�� �ſ��� <%=e_bean.getGi_grade()%>��ޱ���</td>
							</tr>
							<%}%>
			                <tr> 
			                  	<td height=24>&nbsp;</td>
			                  	<td>&nbsp;</td>
			                  	<td width=17><img src=./images/arrow_1.gif width=10 height=6>&nbsp;</td>
			                  	<td width=569 align=left> 
			                  		<table width=569 border=0 cellpadding=0 cellspacing=0 background=./images/img_bg.gif>
				                      	<tr> 
				                        	<td colspan=3><img src=./images/img_up.gif width=569 height=5></td>
				                      	</tr>
				                     	<tr> 
				                        	<td width=15 height=15>&nbsp;</td>
				                        	<td width=270><img src=./images/dot.gif width=5 height=5 align=absmiddle> 
				                          	<span class=style12>�������� ���Աݾ�</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_amt())%>��
				                          	</span></td>
				                        	<td width=284><img src=./images/dot.gif width=5 height=5 align=absmiddle> 
					                          	<span class=style12>���������(<%=e_bean.getA_b()%>����ġ)</span>
					                          	<span class=style13>|</span> 
					                          	<span class=style4>
				                          		<%if (e_bean.getGi_amt() > 0) {%>
						                          	<%if (!e_bean.getGi_grade().equals("")) {%>
						                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;��
						                          	<%} else {%>
					                          			<span style="padding-left: 60px;">��</span>
						                          	<%}%>
					                          	<%} else {%>
					                          		<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>&nbsp;��
					                          	<%}%>
					                          	</span>
				                          	</td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=3><img src=./images/img_dw.gif width=569 height=5></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                </tr>
			                <%if (e_bean.getGi_amt() > 0) {%>
							<tr>
								<td colspan=4 align=right>�� �ſ��޺��� ��������ᰡ �޶����ϴ�.</td>
							</tr>
							<%}%>
			                <%}%> --%>
		              	</table>
					</td>
				</tr>
				<tr> 
		            <td height=5 colspan="2">&nbsp;</td>
				</tr>
				<tr> 
		            <td align=right><img src=./images/ceo.gif>&nbsp;</td>
		            <td align=right>&nbsp;</td>
				</tr>
				<tr> 
		            <td height=10 colspan="2"></td>
				</tr>
			</table>
		</td>
        <td width=21>&nbsp;</td>
	</tr>
    <tr id='esti_button_tr'>
        <td align=center colspan=3>
		      <a href=javascript:go_print('<%= est_id %>');><img src=./images/button_print.gif border=0></a>&nbsp;&nbsp;
		      <a href=javascript:go_mail('<%= est_id %>');><img src="./images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;
  		    <%	if(ej_bean.getJg_w().equals("1")||ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){//������,ģȯ����%>
  		    <%	}else{%>
  		    <%		if(AddUtil.parseInt((String)sh_comp.get("AE93")) < 0 || AddUtil.parseInt((String)sh_comp.get("AE93")) > 0){%>
		  	  <a href=javascript:go_compare('<%= est_id %>');><img src=./images/button_compare.gif border=0></a>&nbsp;&nbsp;
		  	  <%		}%>
		  	  <%	}%>
		      <a href="javascript:go_paper();"><img src=./images/button_paper.gif border=0></a>
		    </td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
	<tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
</table>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
    </body>
</html>