<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
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
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	//�ܰ� ��������
	Hashtable sh_comp = new Hashtable();
	//���� Ȯ������
	Hashtable exam = new Hashtable();
	Vector vars = new Vector();
	
	if (from_page.equals("/acar/estimate_mng/./images/line.gif")) {
		from_page = "/acar/estimate_mng/esti_mng_u.jsp";
	}
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
		sh_comp 	= shDb.getShCompare(est_id);
		exam 		= shDb.getEstiExam(est_id);
		vali_date 	= AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
		vars 		= e_db.getABTypeEstIds2(e_bean.getSet_code(), e_bean.getEst_id());
		e_bean1 = e_bean;
	}else{
		e_bean 		= e_db.getEstimateHpCase(est_id);
		sh_comp 	= shDb.getShCompareHp(est_id);
		exam 		= shDb.getEstiExamHp(est_id);
		vars 		= e_db.getABTypeEstIds3(e_bean.getEst_id());
		if(vars.size()==0)	e_bean2 = e_bean;	
		else				e_bean1 = e_bean;
	}
	
	int size = vars.size();
	
	for(int i = 0 ; i < size ; i++){
		Hashtable var = (Hashtable)vars.elementAt(i);
		if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
			if(i==0) e_bean1 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		}else{
			if(i==0) e_bean1 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateHpCase(String.valueOf(var.get("EST_ID")));
		}
	}
	
	exam 			= shDb.getEstiExam(e_bean1.getEst_id());
	
	//�����뿩�ᰡ �ִٸ�
	if(e_bean1.getCtr_s_amt()>0){
		e_bean1.setFee_s_amt(e_bean1.getCtr_s_amt());
		e_bean1.setFee_v_amt(e_bean1.getCtr_v_amt());
		
		if(e_bean1.getIfee_s_amt()>0 && e_bean1.getG_10()>1){
			e_bean1.setIfee_s_amt(e_bean1.getCtr_s_amt()*e_bean1.getG_10());
			e_bean1.setIfee_v_amt(e_bean1.getCtr_v_amt()*e_bean1.getG_10());
		}
	}
	
	//�����뿩�ᰡ �ִٸ�
	if(e_bean2.getCtr_s_amt()>0){
		e_bean2.setFee_s_amt(e_bean2.getCtr_s_amt());
		e_bean2.setFee_v_amt(e_bean2.getCtr_v_amt());
		
		if(e_bean2.getIfee_s_amt()>0 && e_bean2.getG_10()>1){
			e_bean2.setIfee_s_amt(e_bean2.getCtr_s_amt()*e_bean2.getG_10());
			e_bean2.setIfee_v_amt(e_bean2.getCtr_v_amt()*e_bean2.getG_10());
		}
	}
	
	//�����뿩�ᰡ �ִٸ�
	if(e_bean3.getCtr_s_amt()>0){
		e_bean3.setFee_s_amt(e_bean3.getCtr_s_amt());
		e_bean3.setFee_v_amt(e_bean3.getCtr_v_amt());
		
		if(e_bean3.getIfee_s_amt()>0 && e_bean3.getG_10()>1){
			e_bean3.setIfee_s_amt(e_bean3.getCtr_s_amt()*e_bean3.getG_10());
			e_bean3.setIfee_v_amt(e_bean3.getCtr_v_amt()*e_bean3.getG_10());
		}
	}
	
	//�����뿩�ᰡ �ִٸ�
	if(e_bean4.getCtr_s_amt()>0){
		e_bean4.setFee_s_amt(e_bean4.getCtr_s_amt());
		e_bean4.setFee_v_amt(e_bean4.getCtr_v_amt());
		
		if(e_bean4.getIfee_s_amt()>0 && e_bean4.getG_10()>1){
			e_bean4.setIfee_s_amt(e_bean4.getCtr_s_amt()*e_bean4.getG_10());
			e_bean4.setIfee_v_amt(e_bean4.getCtr_v_amt()*e_bean4.getG_10());
		}
	}	
	

	//���� ������� �ִٸ� 
	if(e_bean1.getCtr_cls_per()>0){
		e_bean1.setCls_per(e_bean1.getCtr_cls_per());
	}

	//���� ������� �ִٸ� 
	if(e_bean2.getCtr_cls_per()>0){
		e_bean2.setCls_per(e_bean2.getCtr_cls_per());
	}

	//���� ������� �ִٸ� 
	if(e_bean3.getCtr_cls_per()>0){
		e_bean3.setCls_per(e_bean3.getCtr_cls_per());
	}

	//���� ������� �ִٸ� 
	if(e_bean4.getCtr_cls_per()>0){
		e_bean4.setCls_per(e_bean4.getCtr_cls_per());
	}
	
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
	
	
	String br_id 	= "S1";
	String name 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
		user_bean = umd.getUsersBean(e_bean.getReg_id());
	}else{
		if(!acar_id.equals("")){
			user_bean = umd.getUsersBean(acar_id);
		}
	}
	
	name 		= user_bean.getUser_nm();
	m_tel 		= user_bean.getUser_m_tel();
	br_id   	= user_bean.getBr_id();
	h_tel 		= user_bean.getHot_tel();
	i_fax 		= user_bean.getI_fax();
	email 		= user_bean.getUser_email();
	
	if(e_bean.getCaroff_emp_yn().equals("3")){
		name 		= "";
		m_tel 		= "";
		br_id   	= "";
		h_tel 		= "";	
		i_fax 		= "";	
		email 		= "";	
	}
	
	if(name.equals("�ڱԼ�")) name = "�ּ���";
	if(name.equals("������")) m_tel = "";
	if(name.equals("�輳��")) m_tel = "";
	if(name.equals("�ǿ�ö")) name = "���缮 ����";
	if(name.equals("�����")) name = "�׻���̷�Ʈ";
	if(name.equals("���Ʊ�")){ name = "��������÷�"; m_tel = h_tel;}
	if(name.equals("������2")) name = "�Ƹ����÷���";
// 	if(name.equals("������")) name = "������ī";
	if(name.equals("�̼���")) name = "SI����-����ŻCAR";
	if(name.equals("�̵���")) name = "(��)�˿������۴�";
	if(name.equals("�Ӵ�ȣ")) name = "������Ʈ��";
	if(name.equals("�ȴ���")) name = "��Ż��Ʈ��";
	
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
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="euc-kr">
<title>������</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(���տ������)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(���տ������)");
	}
})
</script>
<style type="text/css">
<!--
table {
 border-collapse: collapse;
 border-spacing: 0;
}

.table_est   {border:1px solid #c4c4c4; margin-bottom:2px;}
.table_est td{border:1px solid #c4c4c4; height:18px;}

.table_est td.bd_left   {border-left:1px solid #dcdddd;}
.table_est td.bd_top    {border-top:1px solid #dcdddd;}
.table_est td.bd_bottom {border-bottom:1px solid #dcdddd;}
.ht td{height:14px;}
.style1 {
	color: #ff00ff;
	font-weight:900;
	font-size: 14pt
}
.style2 {
	color: #706f6f;
	font-weight:900;
}

.style3 {
	color: #333333; 
}
.style4 {color: #000000;}
.style5 {color: #444444; line-height:5px; }
.style6 {color: #000000; font-weight:900;}
.style7 {color: #dc0039; font-weight:900;}
.style8 {color: #1368f5;font-weight:900;}
.style9 {color: #000000; font-size:11px;}
.style10 {font-weight:900;}
.style12 {color: #9cb445;font-weight:900; }
.style13 {
	color: #c4c4c4;
	font-weight:900;
}
.style14 {color: #616161}
.endDt {font-weight: bold; text-decoration: underline; font-size: 13px}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">


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

	//�μ��ϱ�
	function go_print(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.action = "esti_print_eh_all.jsp";
		fm.target = "_blank";
		fm.submit();		
	}	
	//���ϼ����ϱ�
	function go_mail(est_id){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&acar_id=<%=acar_id%>&write_id=<%=e_bean.getReg_id()%>&from_page=<%=from_page%>&opt_chk=<%=opt_chk%>&est_email=<%=e_bean.getEst_email()%>&content_st=hp_eh_all";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=600, scrollbars=no, status=yes");
	}
	
	//�غ񼭷�����
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=720, status=no, scrollbars=no, resizable=no");
	}
	
	//�⺻��纸���ֱ�
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
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
<body topmargin=0 leftmargin=0>
<form action="" name="form1" method="POST" >
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="est_id" value="<%=est_id%>">
<input type="hidden" name="acar_id" value="<%=acar_id%>">
<input type="hidden" name="mobile_yn" value="<%=mobile_yn%>">
<input type="hidden" name="content_st" value="hp_eh_all">
<table width=740 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
	  <%if(e_bean.getVali_type().equals("0") || e_bean.getVali_type().equals("1")){
				vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 9));
			}else if(e_bean.getVali_type().equals("2")){
				vali_date = "��Ȯ�� �����Դϴ�.";
			}
		%>
    <tr>
        <td colspan=3>
            <table width=740 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=528><img src=../main_car_hp/images/title_2.gif></td>
                    <td width=170 align=right>
                        <table width=170  class="table_est">
                            <%if(AddUtil.parseInt(AddUtil.getDate(4)) >= 20170930 && AddUtil.parseInt(AddUtil.getDate(4)) < 20171010){//�俬�ޱⰣ%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>������</span></td>
                                <td width=107 bgcolor=ffffff align=center><span class=style16>2017-09-30</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>��ȿ�Ⱓ</span></td>
                                <td bgcolor=ffffff align=center><span class=style16></span></td>
                            </tr>
                            <%}else{%>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>�ۼ���</span></td>
                                <td width=107 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
							              <%	if(!vali_date.equals("")){%>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>��ȿ�Ⱓ</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
							              <%	}%>
							              <%}%>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
				        <%if(e_bean.getVali_type().equals("1")){%>
                <tr>
                    <td colspan='3' align=right>* ����ĿD/C ����� �뿩��ݵ� ����˴ϴ�.</td>
                    <td width=21>&nbsp;</td>
                </tr>
				        <%}%>
            </table>
        </td>
    </tr>	

    <tr>
        <td height=10 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=698>
            <table width=698 border=0 cellspacing=0 cellpadding=0>
          		<tr> 
            		<td colspan="2"> 
            			<table width=698 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=410> 
			                  		<table width=410 border=0 cellspacing=0 cellpadding=0>
				                      	<tr> 
				                        	<td height=10 colspan=4><span class=style1></span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                	</tr>
					                	<tr> 
					                        <td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td colspan='3'><div align="left"><span class=style2><%=e_bean.getEst_nm()%> <%=e_bean.getMgr_nm()%>&nbsp;�� ����</span></div></td>
					               		</tr>
					                 	<tr> 
					                        <td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                 	</tr>
					                  	<tr> 
					                        <td width=24 height=25 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=160><span class=style2>TEL.<%=e_bean.getEst_tel()%></span></td>
					                        <td width=24 align=center><img src=./images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=202><span class=style2>FAX.<%=e_bean.getEst_fax()%></span></td>
					                 	</tr>
					                	<tr> 
					                        <td colspan=4><img src=./images/line.gif width=409 height=1></td>
					                 	</tr>
				                    </table>
								</td>
                  				<td width=47>&nbsp;</td>
                  				<td width=241 valign=bottom> 
                  					<table width=241 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_comp.gif class="ht">
										<tr> 
				                        <td colspan=4 height=0></td>
				                      </tr>
				                      <tr> 
				                        <td width=75 align=center><span class=style5><%= name %></span></td>
				                        <td width=30 align=right><span class=style5>hp)</span></td>
				                        <td width=136>&nbsp;<span class=style5><%= m_tel %></span></td>
				                      </tr>
				                     	<tr> 
				                        <td></td>
				                        <td align=right><span class=style5>tel)</span></td>
				                        <td>&nbsp;<span class=style5 ><%= h_tel %></span></td>
				                      </tr>
				                     	<tr> 
				                     	<td></td>
				                        <td align=right><span class=style5>fax)</span></td>
				                        <td>&nbsp;<span class=style5><%= i_fax %></span></td>
				                      </tr>
				                    	<tr> 
				                        <td></td>
				                        <td colspan='2'>&nbsp;<span class=style5><%= email %></span></td>
				                      </tr>  
										<tr> 
				                        <td style="height:10px;"></td>
				                      </tr>
				                    </table>
                   				</td>
                			</tr>
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
								/* if(e_bean.getEcar_loc_st().equals("0")){ //����
								}else if(e_bean.getEcar_loc_st().equals("1")){ //��õ,���
								}else if(e_bean.getEcar_loc_st().equals("2")){ //���� 	
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("3")){ //���� 
									//reg_loc_st = 4;	//����
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("4")){ //����,����,����
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("5")){ //�뱸
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("6")){ //�λ�,���,�泲
									reg_loc_st = 3;	//�λ�
								}else if(e_bean.getEcar_loc_st().equals("7")){ //����,�泲,���(��������)
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("8")||e_bean.getEcar_loc_st().equals("9")){ //���,���/�泲
									reg_loc_st = 7;	//�뱸
								}else if(e_bean.getEcar_loc_st().equals("10")){ //����,����(��������)
								} */								
								
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
							<img src=./images/bar_01_car_prt.gif align=right>
							<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))) > 0 ){%>
								<div style="font-size: 10.8px; padding-top: 7px;">
								�� �� ���� ���������� ���Ҽ� 3.5% ���� ������ ���Ҽ� 5% ���� ȯ�� ���������� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_220"))))%>��<%if(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))) > 0 ){%>(ģȯ���� �������� �� <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_221"))))%>��)<%}%> �����Դϴ�.
								</div>
							<%} %>
							<span style="position: absolute; top:0; right:0;font-weight: bold;font-size: 13px;text-decoration: underline;">
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
						<!-- <img src=./images/bar_01_car_prt.gif align=right> -->
							<div style="position: relative;">
								<img src=./images/bar_01_car_prt.gif align=right>
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
	            		<table width=698 class="table_est">
			                <tr> 
			                  	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
			                  	<td width=419>&nbsp;<span class=style4><%=cm_bean.getCar_comp_nm()%></span></td>
			                  	<td width=100 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
			                  	<td>&nbsp;<span class=style8><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%if(cm_bean.getCar_nm().equals(cm_bean.getCar_name())){ car_nm_length = cm_bean.getCar_nm().length();%><%=cm_bean.getCar_nm()%><%}else{ car_nm_length = cm_bean.getCar_nm().length()+cm_bean.getCar_name().length(); %><%=cm_bean.getCar_nm()+" "+cm_bean.getCar_name()%><%}%></a> 
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
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    ��</span></td>
			                  	<td>&nbsp;<span class=style6><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=e_bean.getOpt()%></a></span></td>
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� </span></td>
			                  	<td>&nbsp;<span class=style6><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=e_bean.getCol()%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%><%if(!e_bean.getGarnish_col().equals("")){%>&nbsp;/&nbsp;���Ͻ�: <%=e_bean.getGarnish_col()%><%}%></span></td>
			                  	<td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getCol_amt())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
			                <%if(!e_bean.getConti_rat().equals("")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    �� </span></td>
			                  	<td>
			                  		<span id="contiRatDesc">
			                  			<%=e_bean.getConti_rat()%>
			                  		</span>
			                  	</td>
			                  	<td></td>
			                </tr>
			                <%}%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� 
			                    Ÿ </span></td>
			                    <td bgcolor=#FFFFFF>&nbsp;
<%-- 			                    	<%if( (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")) && !e_bean.getEcar_loc_st().equals("13") ){%> --%>
			                    	<%-- <%if( ej_bean.getJg_g_7().equals("3") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0 ){%>
			                  			�� �� ������ ������ ���� �������� 2022�� ������ Ȯ�� ������ ���뿩�ᰡ ���� �� �� �ֽ��ϴ�.<br>
			                  		<%}%> 2022.02.18. �ش� ���� ��ǥ�� ��û���� �ּ�ó��. --%>
			                  		<%if(e_bean.getDc_amt()>0){%>������D/C (<%=e_bean.getRent_dt().substring(4, 6)%>�� �������)&nbsp;<%=e_bean.getEsti_d_etc()%><%}%>
			                  		<%if(e_bean.getDc_amt()>0 && !e_bean.getEtc().equals("")){%><br>&nbsp;&nbsp;<%}%>
                  					<%if(!e_bean.getEtc().equals("") ){%><%=e_bean.getEtc()%><%}%>
                  					
                  					<%-- <%if(cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
                  						�� ����ȭ������ ��� ���� ����ü ������ ������� �ʰ� �����̳�, ���� ������ �߰� ������ ����� ������ �� �ֽ��ϴ�.
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
			                  	<td align=right><span class=style4><%if(e_bean.getDc_amt()>0){%>-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%> 
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
									&nbsp;&nbsp;3.5%(2020.7~12��)�� �����Ǿ� ����� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>��(���ް�) �λ�˴ϴ�.
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
										&nbsp;&nbsp;3.5%(2020.7~12��)�� �����Ǿ� ����� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_190"))))%>��(���ް�) �λ�˴ϴ�.
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
			                  	<td style="font-size:11px;">
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
				                   		<span class=style4>&nbsp;�� 2021��1��1�� ���� ������ ����Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>��(���ް�) �λ�˴ϴ�.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020121813 && ref_reg_dt <= 2020123123) {%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_213"))) > 0) {%>
				                   		<span class=style4>&nbsp;�� 2021��1��1������ ������ ����Ǹ� �����Һ��� �ѽ��� ���� ���忡�� �ұ��ϰ� �����Һ� ���� �ѵ�(100����) �ʰ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_213"))))%>��(���ް�) �λ�˴ϴ�.</span>
				                   	<%}%>
			                  	<%}%>
			                  	
			                  	<%if (ref_reg_dt >= 2020083113 && ref_reg_dt <= 2020123123) {%>
			                  		<%-- <%if (ej_bean.getJg_w().equals("1") || (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) || etc_jg_code_match == true || !e_bean.getInfo_st().equals("N")) {%> --%>
			                  		<%if (AddUtil.parseInt(String.valueOf(exam.get("BK_206"))) > 0) {%>
										<span class=style4>&nbsp;�� 2021��1��1�� ���� ������ ����Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_206"))))%>��(���ް�) �λ�˴ϴ�.</span>
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
                    	int car_c_amt = e_bean1.getCar_amt()+e_bean1.getOpt_amt()+e_bean1.getCol_amt()-e_bean1.getDc_amt();
                    	double fee_pp_amt = e_bean1.getFee_s_amt()+(e_bean1.getPp_s_amt()/AddUtil.parseDouble(e_bean1.getA_b()));		//���뿩��+������/������
                    	//����������ȿ�� 20191108
                    	double grt_mo_amt = 0;
                    	if(e_bean1.getGtr_amt() >0){
                    		//grt_mo_amt = e_bean1.getGtr_amt()*0.06/12*0.014;
                    		grt_mo_amt = e_bean1.getGtr_amt()*(em_bean.getA_f_2()/100)/12*0.014;
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
                    			fee_add_text1 = "�ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ���<br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt1)+"��(���ް�) �λ�˴ϴ�.(����1 ����)";	//��������(20190527)
                    		}
                    		
                    	}
                    	//���̺긮��
                    	if(AddUtil.parseInt(AddUtil.getDate(4)) <= 20181231){ //20181227
	                    	if(ej_bean.getJg_g_7().equals("1") && ej_bean.getJg_g_8().equals("1") && AddUtil.parseInt(String.valueOf(exam.get("BK_128"))) > 0){
	                    		fee_add_amt2 = (double)e_db.getTruncAmt((int)(AddUtil.parseDouble(String.valueOf(exam.get("BK_128")))/AddUtil.parseDouble(e_bean.getA_b())), "1", "round", "-2");
	                    		if(fee_add_amt2 > 0) {
	                    			fee_add_text2 = "2019��1��1�� ���� ������ ����Ǹ� ���̺긮�� ���ź����� �����ߴܿ� ���� <br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt2)+"��(���ް�) �λ�˴ϴ�.";
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
                    			fee_add_text2 = "2020��1��1�� ���� ������ ����Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� <br>&nbsp; ���뿩�ᰡ "+AddUtil.parseDecimal(fee_add_amt2)+"��(���ް�) �λ�˴ϴ�.";
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
                    <span class=style4>�� ��Ȯ�� �������� �� �ɼǰ����� ���� ����Ͽ� Ȯ�� ����(�� ������ ������ ���� ������)</span>
                    <%	}%>
                    <%}%>
                  
                  
                  <%}%>
                  
                    <%if((e_bean.getCar_id().equals("006171") || e_bean.getCar_id().equals("006172")) && (e_bean.getA_a().equals("21") || e_bean.getA_a().equals("22"))){%>
                    &nbsp;&nbsp;<span class=style4>�� �������� ���������� �����Һ� ���԰��� �Դϴ�.(���� ��� ���������� ������ ����ǥ�� �����ϰ� �����Һ� �鼼��(<%=AddUtil.parseDecimal(e_bean.getO_1()/1.065)%>��)�� ȯ���Ͽ� ����)</span>
                    <%}%>
                    
				  <%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){%>
					<% if(!e_bean.getEcar_loc_st().equals("13")){ %>
               		  		<span class=style4>�� ������ ���� �Ǵ� ����, ���� ������� ������ �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.</span>
						<%} else{%>
              	 	  		<% if(! (cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113")) ){ %>
               		  			<span class=style4>&nbsp;&nbsp;[������ ���� ����]</span>
							<%}%>
						<%}%>
                  <%}%>
				  
                <%if (ref_reg_dt >= 2021070200) {%>
                	<%if( ej_bean.getJg_3() > 0 && AddUtil.parseInt(String.valueOf(exam.get("BK_198"))) > 0 ){ // �⺻�����Һ���(ej_bean.getJg_3())�� 0���� ũ�� �����Һ� ���� ȯ�� �� ���뿩�� �λ�ݾ�(bk_198)�� 0���� Ŭ ��	%>
                		<%if( ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4") ){  // ģȯ���� ���л� ����/������%>
               				<span class=style4>�� 2023�� 1�� 1�� ���� ������ ����Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ �λ�˴ϴ�.</span>
						<%} else {%>
               				<span class=style4>�� 2023�� 1�� 1�� ���� ������ ����Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ <%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(exam.get("BK_198"))))%>��(���ް�) �λ�˴ϴ�.</span>
						<%}%>
					<%}%>
				<%}%>
                                                      
                  </td>
			                  	<td align=right><span class=style7><%=AddUtil.parseDecimal(e_bean.getO_1())%> 
			                    ��</span>&nbsp;</td>
			                </tr>
	              		</table>
	              	</td>
	          	</tr>
          		<tr> 
		            <td height=10 colspan="2">
		                <table width=698 border=0 cellpadding=0 cellspacing=1>
		                	<%if(endDt){%><!-- �ܻ� ���� ���� 2017.11.08 -->
		                	<tr>
		                		<td><span class="endDt">�� ���� �ߴܵ� �����Դϴ�. ���� ����ڸ� ���ؼ� ��� ������ Ȯ���ϰ� �����Ͻñ� �ٶ��ϴ�.</span></td>
		                	</tr>
		                	<%}%>
		                    <tr>
		                        <td colspan='2'>
		                        	<%if(ej_bean.getJg_g_7().equals("3")){ //������
// 		                        		if ( cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440") ) {
		                        		if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { 
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
		                        		} else {
		                        	%>
			                        	<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") || e_bean.getEcar_loc_st().equals("3")
			                        			|| e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5") || e_bean.getEcar_loc_st().equals("6") ){
			                        		// ������ �����ּ����� ����, ��õ, ����, ����, �뱸, �λ��� �� %>
		                        		�� [�����: ����� ������, �谳��: �ֹε�ϵ�� �ּ���, �鰳�λ����: ��ǥ�� �ֹε�ϵ�� �ּ���]
			                        		<% if(e_bean.getEcar_loc_st().equals("0")){ %>
			                        			����
			                        		<%} else if(e_bean.getEcar_loc_st().equals("1")){ %>
			                        			��õ
			                        		<%} else if(e_bean.getEcar_loc_st().equals("3")){ %>
			                        			����
			                        		<%} else if(e_bean.getEcar_loc_st().equals("4")){ %>
			                        			����
			                        		<%} else if(e_bean.getEcar_loc_st().equals("5")){ %>
			                        			�뱸
			                        		<%} else if(e_bean.getEcar_loc_st().equals("6")){ %>
			                        			�λ�
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
		                        		
		                        		<%-- <%if (!(cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440"))) {%>
		                        			<%if( e_bean.getEcar_loc_st().equals("0") || e_bean.getEcar_loc_st().equals("1") || e_bean.getEcar_loc_st().equals("3")
				                        			|| e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5") || e_bean.getEcar_loc_st().equals("6") ){// ������ �����ּ����� ����, ��õ, ����, ����, �뱸, �λ� %>
		                        				<br>�� ����ü�� ������ ���ź����� ���̷� �����ּ����� ���� ���뿩�� ������(�����ּ��� ������ �̿�)
		                        			<%} %>
		                        		<%} %> �ش� ���� ��ǥ�� ��û���� �ּ� ó��. 2022.02.18. --%>
		                        		<%-- <%if (!cm_bean.getJg_code().equals("5866") && !cm_bean.getJg_code().equals("4854") && !cm_bean.getJg_code().equals("6316111") && !cm_bean.getJg_code().equals("4314111")) {%>
		                        			<%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {%>
		                        				�� 3���� �ε�����
		                        			<%} else if (cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")) {%>
		                        				�� 5���߼��� �ε�����
		                        			<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
		                        				�� [�����: ����� ������, �谳��: �ֹε�ϵ�� �ּ���, �鰳�λ����: ��ǥ�� �ֹε�ϵ�� �ּ���]�� �����̿��� ��
		                        				<!-- �� ����ȭ���� ���ź����� 2300���� ���� ���� -->
		                        				<!-- �� ����ȭ���� ���ź����� 2700���� ���� ���� -->
		                        			<%} else {%>
		                        				<!-- �� ������ ���ź����� 1200���� ���� ���� -->
		                        				<%if ((AddUtil.parseInt(AddUtil.getDate(4)) >= 20181114 || AddUtil.parseInt(e_bean.getRent_dt()) >= 20181114) && AddUtil.parseInt(e_bean.getRent_dt()) <= 20200121) {%>
		                        					�� ������ ���ź����� 1200���� ���� ����
		                        				<%} else {%>
			                						<!-- �� ���� ���ź����� ���� ����. ������ ������ ���ý� ������������ �ʰ��ϴ� �ݾ��� �����δ� -->
													<!-- �� ������ ������ ���ý� ������������ �ʰ��ϴ� �ݾ��� �����δ� -->
													<%if(e_bean.getEcar_loc_st().equals("0")){ //���� %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_0_amt() %>���� ���� ����			                							
													<%}else if(e_bean.getEcar_loc_st().equals("1")){ //��õ,��� %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_1_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("2")){ //���� %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_2_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("3")){ //���� %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_3_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("4")){ //����,����,���� %>	
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_4_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("5")){ //�뱸 %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_5_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("6")){ //�λ� %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_6_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("7")){ //����,�泲,���(��������) %>	
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_7_amt() %>���� ���� ����
													<%}else if(e_bean.getEcar_loc_st().equals("8")){ //���(�뱸����) %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_8_amt() %>���� ���� ����	
													<%}else if(e_bean.getEcar_loc_st().equals("9")){ //���,�泲 %>
														�� ������ ���ź����� <%= (ej_bean.getJg_g_15() / 10000) + em_bean.getEcar_9_amt() %>���� ���� ����
													<%}%>
													
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
		                        		<%}%> --%>
                						
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
	      <!-- ���躸����� -->
	          	<tr> 
	            	<td colspan="2">
                       	<div style="position: relative;">
							<img src=./images/bar_02_ins_comp_est_prt.gif align=left>
							<span style="position: absolute; top:4; right:4;">
								<%if (e_bean.getDoc_type().equals("1") || e_bean.getDoc_type().equals("2")) {%>
									<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && e_bean.getCom_emp_yn().equals("Y")) {%>
		                        	      �� �����ڹ��� : ����������
		                        	<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && e_bean.getCom_emp_yn().equals("Y")) {%>
		                        	      �� �����ڹ��� : ����������      
		                        	<%} else {%>    
		                        	     �� �����ڹ��� : �������� ���谡��                        	  
		                        	<%}%>
		                        <%-- <%} else if (e_bean.getDoc_type().equals("2")) {%>
		                        	  �� �����ڹ��� : �������� ���谡�� --%>
		                        <%} else if (e_bean.getDoc_type().equals("3")) {%>
		                        	  �� �����ڹ��� : ����� �� ���谡��
		                        <%}%>
							</span>
						</div>  		
	            	</td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	          	<tr>
	          		<td colspan="2">
						<table width=698  class="table_est">
							<tr>
								<td height=17 align=center bgcolor=f2f2f2><span class=style3>���ι��</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>�빰���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>�ڱ��ü���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>������å��</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>������������</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>�����ڿ���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style3>����⵿</span></td>
							</tr>
						<%	if(!e_bean.getIns_per().equals("2")){%>
							<tr>
								<td height=17 align=center><span class=style4>����(���Υ�,��)</span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean.getIns_dj().equals("3")){%>5���<%}else if(e_bean.getIns_dj().equals("4")){%>2���<%}else if(e_bean.getIns_dj().equals("8")){%>3���<%}else{%>1���<%}%></span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else{%>1���<%}%></span></td>
								<td align=center><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>��</span></td>
								<td align=center><span class=style4>1�δ� �ְ� 2��� </span></td>
								<td align=center><span class=style4><%if(e_bean.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean.getIns_age().equals("3")){%>��24���̻�<%}else{%>��26���̻�<%}%></span></td>
								<td align=center><span class=style4>����</span></td>
							</tr>
						<%	}else{%>
							<tr>
								<td height=17 align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
								<td align=center><span class=style4>����̹ݿ�</span></td>
							</tr>
						<%	}%>
						</table>
					</td>
	       		</tr>
	       		
	       		<%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
                <tr>
                	<td colspan="3" align="right">�� ��������� �Ƹ���ī ���� ������忡�� ����</td>
                </tr>
                <%}%>

			<!-- ���躸����� end-->	
				<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><img src=./images/bar_03_fee_prt.gif></td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	        <!-- ���뿩�� �� �ʱⳳ�Ա� -->
	          	<tr>
	          		<td colspan="2">
	          			<table width=698 class="table_est">
							<tr>
								<td align=center bgcolor=f2f2f2 colspan=2>����</td>
								<td align=center bgcolor=f2f2f2 width=135>����1</td>
								<td align=center bgcolor=f2f2f2 width=135>����2</td>
								<td align=center bgcolor=f2f2f2 width=135>����3</td>
								<td align=center bgcolor=f2f2f2 width=135>����4</td>
							</tr>
							<tr>
								<td align=center bgcolor=f2f2f2 colspan=2>�μ�/�ݳ� ����</td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean1.getEst_id().equals("")){if(e_bean1.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean1.getReturn_select().equals("1")){%>�ݳ���<%}}else{%>�μ�/�ݳ� ������<%}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean2.getEst_id().equals("")){if(e_bean2.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean2.getReturn_select().equals("1")){%>�ݳ���<%}}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean3.getEst_id().equals("")){if(e_bean3.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean3.getReturn_select().equals("1")){%>�ݳ���<%}}%></td>
								<td align=center bgcolor=f2f2f2 width=135><%if(!e_bean4.getEst_id().equals("")){if(e_bean4.getReturn_select().equals("0")){%>�μ�/�ݳ� ������<%}else if(e_bean4.getReturn_select().equals("1")){%>�ݳ���<%}}%></td>
							</tr>
	          				<tr>
	          					<td align=center bgcolor=f2f2f2 colspan=2><span class=style3>�뿩��ǰ��</span></td>	   
	          					<td align=center height=17 bgcolor=ffffff><span class=style3><%if(!e_bean1.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%><%}else{%><%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean2.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean3.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean4.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%}%></span></td>
	          				</tr>
	          				<tr bgcolor=f2f2f2>
	          					<td height=17 align=center colspan=2><span class=style3>�뿩�Ⱓ</span></td>
	          					<td align=<%if(!e_bean1.getEst_id().equals("")){%>right<%}else{%>center<%}%>><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getA_b()%> ����<%}else{%>�̿<%}%></span>&nbsp;</td>  
	          					<td align=right><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%> ����<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%> ����<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%> ����<%}%></span>&nbsp;</td>
	          				</tr>     
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2 width=20>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 width=138 style="border:0px; border-left:1px solid #dcdddd;"><span class=style3>���ް�</span></td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9)%> ��<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9)%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9)%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9)%> ��<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>�ΰ���</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1)%> ��<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1)%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1)%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1)%> ��<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 bgcolor=f2f2f2 style="border:0px;padding-left:29px; border-top:1px solid #dcdddd;"><span class=style3>���뿩��</span></td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean1.getEst_id().equals("")){%><%if (e_bean1.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%> ��<%}%><%}%></span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean2.getEst_id().equals("")){%><%if (e_bean2.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean3.getEst_id().equals("")){%><%if (e_bean3.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%> ��<%}%><%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean4.getEst_id().equals("")){%><%if (e_bean4.getCls_per() > 100) {%>�����Ұ�<%} else {%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%> ��<%}%><%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border-bottom:0px;border-right:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border-left:1px solid #dcdddd;border-bottom:0px;"><span class=style3>������</span></td>
	          					<td class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean1.getEst_id().equals("")){%><%=Math.round(e_bean1.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGtr_amt())%> ��<%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean2.getEst_id().equals("")){%><%=Math.round(e_bean2.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean3.getEst_id().equals("")){%><%=Math.round(e_bean3.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean4.getEst_id().equals("")){%><%=Math.round(e_bean4.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>������(VAT����)</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr>
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 style="border:0px; border-left:1px solid #dcdddd; border-top:1px solid #dcdddd;"><span class=style3>���ô뿩��(VAT����)</span></td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>  
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right class="bd_bottom bd_top"><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td style="border:0px;" bgcolor=f2f2f2>&nbsp;</td>
	          					<td height=17 bgcolor=f2f2f2 style="border:0px; padding-left:10px; border-top:1px solid #dcdddd;"><span class=style3>�ʱⳳ�Ա� �հ�</span></td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGtr_amt()+e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt()+e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt()+e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt()+e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt()+e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt()+e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style7><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt()+e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt()+e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
						</table>
						<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
						<table width=698 class="table_est">
							<tr>	
								<td align=center bgcolor=f2f2f2 width=158>�������� ���Աݾ�</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean1.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td align=center bgcolor=f2f2f2>
									���������
									<%-- <br>
									<span style="font-size: 11px;">�� �ſ��� <%=e_bean1.getGi_grade()%>��ޱ���</span> --%>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%=e_bean1.getA_b()%>����ġ<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean1.getEst_id().equals("")){%>
														<%if (e_bean1.getGi_amt() > 0) {%>
								                          	<%if (!e_bean1.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%>����ġ<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean2.getEst_id().equals("")){%>
														<%if (e_bean2.getGi_amt() > 0) {%>
								                          	<%if (!e_bean2.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%>����ġ<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean3.getEst_id().equals("")){%>
														<%if (e_bean3.getGi_amt() > 0) {%>
								                          	<%if (!e_bean3.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=55><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%>����ġ<%}%></span></td>
											<td align=right style="border:0px;" width=80>
												<span class=style4>
													<%if(!e_bean4.getEst_id().equals("")){%>
														<%if (e_bean4.getGi_amt() > 0) {%>
								                          	<%if (!e_bean4.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%}%>
						
						<table width=698 class="table_est">
							<tr>
								<td align=center bgcolor=f2f2f2 width=158>���Կɼǰ���(VAT����)</td>
								<td class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean1.getEst_id().equals("") && e_bean1.getOpt_chk().equals("1")){%><%=e_bean1.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean1.getEst_id().equals("")){%><%if(e_bean1.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean2.getEst_id().equals("") && e_bean2.getOpt_chk().equals("1")){%><%=e_bean2.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean3.getEst_id().equals("") && e_bean3.getOpt_chk().equals("1")){%><%=e_bean3.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
								</td>
	          					<td align=right class="bd_bottom">
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><span class=style4><%if(!e_bean4.getEst_id().equals("") && e_bean4.getOpt_chk().equals("1")){%><%=e_bean4.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getOpt_chk().equals("1")){%><%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span>&nbsp;</td>  
										</tr>
									</table>
								</td>
						<table>
						
						
						<table width=698 class="table_est">
							<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center width=148><span class=style3>���� ��������Ÿ�</span></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean1.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean2.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
						        <td bgcolor=ffffff align=right width=140><%if(!e_bean3.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right width=140><%if(!e_bean4.getEst_id().equals("")){%><span class=style7><%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3>�ʰ�����뿩��(VAT����)</span></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean1.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean1.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean2.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
						        <td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean3.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean4.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3>���Կɼ� ����<br>�ʰ�����뿩��</span></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean1.getEst_id().equals("")){%><%if(e_bean1.getOpt_chk().equals("1")){%><%if(e_bean1.getA_a().equals("12")||e_bean1.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getOpt_chk().equals("1")){%><%if(e_bean2.getA_a().equals("12")||e_bean2.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
						        <td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getOpt_chk().equals("1")){%><%if(e_bean3.getA_a().equals("12")||e_bean3.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getOpt_chk().equals("1")){%><%if(e_bean4.getA_a().equals("12")||e_bean4.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
		            		</tr>
						</table>
						<table width=698 class="table_est">
	          				<tr>
	          					<td height=17 align=center bgcolor=f2f2f2 width=148><span class=style3>�ߵ����� �����</span></td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean1.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩����</span> <span class=style7><%if(e_bean1.getCls_per()>0){%><%=e_bean1.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean1.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>  
	          					<td width=140 align=right><span class=style9><%if(!e_bean2.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩����</span> <span class=style7><%if(e_bean2.getCls_per()>0){%><%=e_bean2.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean2.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean3.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩����</span> <span class=style7><%if(e_bean3.getCls_per()>0){%><%=e_bean3.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean3.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right><span class=style9><%if(!e_bean4.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩����</span> <span class=style7><%if(e_bean4.getCls_per()>0){%><%=e_bean4.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean4.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          				</tr>  
	          			</table>
	          		</td>
	          	</tr> 
	          	<tr>
	          		<td colspan="2" height="5"></td>
	          	</tr>
	          	<tr>
	          	<!-- ����/�����ڽ� ǥ�� -->    
                <td class=listnum2 valign=top>
                <%if(ref_reg_dt >= 2021090600){ %>
	          	<%if( !(e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057")
	          			|| (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200 )) ) { // �׽���, ����Ÿ, ����Ƽ/�ް�Ʈ�� ����%>
						<!-- ���� -->
						&nbsp;<span class=style3><%if(e_bean.getTint_sn_yn().equals("Y")){%>* ���ĸ� ���� ����<%} else{ %>* ����/���ĸ� ���� ����<%} %></span>
						<!-- �����ڽ� -->
						&nbsp;
						<span class=style3>
							<%if(e_bean.getTint_bn_yn().equals("Y")){%> * �����ڽ� ������ ����
		                	<%} else{ %>
		                		<%if( Integer.parseInt(cm_bean.getJg_code()) > 9000000 ){%>
		                		* �����ڽ� ����
		                		<%} else{ %>
		                		* 2ä�� �����ڽ� ����
				                <%}%>
				            <%} %>
						</span>
                <%} %>
                <%} %>
                </td>
                <!-- ��ȣ�� -->
				<td class=listnum2 valign=top align="right">
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
        		<!--��ǰ-->
        		<%if(e_bean.getTint_s_yn().equals("Y") || e_bean.getTint_n_yn().equals("Y") || e_bean.getTint_eb_yn().equals("Y")){%>      
                        <tr> 
			    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3>��
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
	          	
	          	<tr> 
                    <td colspan="2" style="padding-left:20px;"><span class=style4>�� �� �������� ���Ⱓ ���� �� ȯ���� �帳�ϴ�.<br>
                    <!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [������ 100������ �����ϸ�, ���뿩�� 5,500��(VAT����)�� ���ϵ˴ϴ�. (�⸮ 6.6% ȿ��)]<br> -->
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [������ 100������ �����ϸ�, ���뿩�� 4,620��(VAT����)�� ���ϵ˴ϴ�. (�⸮ 5.5% ȿ��)]<br>
                    &nbsp;&nbsp;&nbsp;&nbsp; �� �������� �ſ� ���� �ݾ׾� �����Ǿ� �Ҹ�Ǵ� ���Դϴ�.<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� ���ݰ�꼭�� ����̿�Ⱓ ���� �ſ� �յ� ���� �Ǵ� ���ν� �Ͻ� ���� �� ���ð���<br><!-- 2018.01.23 �߰� -->
                    &nbsp;&nbsp;&nbsp;&nbsp; �� ���ô뿩��� ������ (<%=e_bean.getG_10()%>)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�.
				    <%-- <%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp; �� �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� ���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.
                    <%}%> --%>
<%--                     <%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%> --%>
                    <%if(AddUtil.parseInt(cm_bean.getS_st()) <= 101 || AddUtil.parseInt(cm_bean.getS_st()) == 409 || AddUtil.parseInt(cm_bean.getS_st()) >= 601 ){%>
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp; �� �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� ���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.
                    <%}%>
                    

					<br>
					�� ��������Ÿ��� ���̸� �뿩����� ���ϵǰ�, ��������Ÿ��� �ø��� �뿩����� �λ�˴ϴ�.
					<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
					<br>
					�� �ſ��޺��� ��������ᰡ �޶����ϴ�.
					<%}%>
                    </span></td>
                </tr>
	         <!-- ���뿩�� �� �ʱⳳ�Ա� end -->  
			    <%if(e_bean.getPp_ment_yn().equals("Y")){%>          
			        <tr> 
					    <td colspan=2>&nbsp;<span class=style3>* �ʱⳳ�Ա��� �������� �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.</span></td>
			        </tr>
		      <%}%>	      
		      <%if(e_bean.getTint_ps_yn().equals("Y")){%> 
	                <tr><td colspan=3 class=listnum2 valign=top>
					<%if(e_bean.getTint_ps_st().equals("Y")){%>        
						&nbsp;<span class=style3>* ���ñ���: ���޽���</span>
                	<%}else if(e_bean.getTint_ps_st().equals("N")){%>
                	<%}else if(e_bean.getTint_ps_st().equals("I")){ %>
                		&nbsp;<span class=style3>* <%=e_bean.getTint_ps_nm()%></span>
                	<%} %>
	                </td></tr>
                <%}%>   
	      <!-- �������� ����-->
	          	
				
		   		<tr> 
		            <td height=10 colspan="2"></td>
		   		</tr>
		      	<tr> 
		            <td colspan="2"><%if(ej_bean.getJg_k().equals("2")){%><img src=./images/bar_04_service_dc_prt.gif><%} else if(ej_bean.getJg_k().equals("0")){%><img src=./images/bar_04_service_ndc_prt.gif><%} else if(ej_bean.getJg_k().equals("3")){%><img src=./images/bar_04_3.gif><%}else{%><img src=./images/bar_04_service_prt.gif><%}%></td>
		    	</tr>
		  		<tr> 
		            <td height=4 colspan="2"></td>
		     	</tr>
		    	<tr> 
		          <td colspan="2" valign=top> 
		          		<table width=698 class="table_est">
		                  	<tr> 
		                     	<td width=115 height=17 align=center bgcolor=f2f2f2><span class=style3>���뼭��</span></td>
		                    	<td width=583 colspan=2>&nbsp; <%if(!e_bean.getInsurant().equals("2")){%>* ������ �߻��� <span class=style6>���ó�� ���� ����</span><%}%> &nbsp;&nbsp;&nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style6> �����������</span>(���ػ���ô� �������)<%}%> </td>
		                    </tr>
		                </table>
		          </td>
		         </tr>
		         <tr></tr>
		         <tr>
		         	<td colspan="2">
		                <table width=698 class="table_est">
		                    <tr>
		                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=17><span class=style6>�⺻��</span> (���񼭺� ������ ��ǰ)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<span class=style6>�Ϲݽ�</span> (���񼭺� ���� ��ǰ)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=349 colspan=2 height=95 style="padding:10px 15px;">&nbsp; <span class=style6>* �Ƹ����ɾ� ����</span><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ���� ���� ���� ��㼭�� ��� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� �̳� ���� ������� ����<%if(e_bean.getCar_comp_id().equals("0056")) {%>(�׽������� ����)<%}%><br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰���)<br> 
		                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� ���� ���� ������ ���� ������� ����<br>
		                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����)</td>
		                   		<td width=349 align=left style="padding-left:15px;">&nbsp; <span class=style6>* ��ü�� ���񼭺�</span><br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - ������ ���� ��޼����� ����<br>
		                   		&nbsp; <span class=style6>* �����������</span><br> 
		                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4�ð� �̻� ������� �԰���</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
		     	<tr> 
		            <td height=10 colspan="2"></td>
		     	</tr>
		     <!-- ��Ÿ �뿩����-->
		    	<tr> 
		            <td colspan="2"><img src=./images/bar_05_etc_prt.gif></td>
		    	</tr>
		  		<tr> 
		            <td height=4 colspan="2"></td>
		   		</tr>
	          	<tr> 
		            <td colspan="2" align=center> 
		            	<table width=671 border=0 cellspacing=0 cellpadding=0>
		            		<tr> 
			                  	<td width=28 height=17 align=right style='vertical-align: baseline'><img src=./images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2>
			                  	�������� ���� ��ǰ�� ����, ���� ���� �Ǵ� ���� ��å(������� �ǹ�����, ��Ⱑ������, �������� ��) ���� ������<br>���������� ���� �� ��� ��� �����ݾ��� ���� �� �� �ֽ��ϴ�.
			                  	</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=./images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td width=28 height=17 align=right><img src=./images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=635 colspan=2 align=left class=listnum2>���, �ڵ����� ����<%if (!e_bean.getCar_comp_id().equals("0056")) {%>, ����˻�<%}%> 
			                    � �Ƹ���ī���� ó��(���� ��� �δ� ����)</td>
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
			                  		�뿩�Ⱓ ����ÿ��� �μ�/�ݳ� �������� ��� �����ݳ�, �����̿�<%if(!e_bean.getCar_comp_id().equals("0056") && (!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237") && !cm_bean.getJg_code().equals("9015435") && !cm_bean.getJg_code().equals("9025435") && !cm_bean.getJg_code().equals("9015436") && !cm_bean.getJg_code().equals("9015437") && !cm_bean.getJg_code().equals("9025439") && !cm_bean.getJg_code().equals("9025440"))) {%>(���ο�� ����)<%}%>, ���Կɼ� ��� �� ���� �����ϰ�,
			                  	</td> --%>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>
			                  		�ݳ����� ��� �����ݳ�, �����̿�(���ο�� ����) �� ���� ����.
			                  	</td>
			                </tr>
			  			</table>
		           	</td>
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
	<!--�ʿ伭��ǥ�� start-->
    <!-- ����-->
	<%if(e_bean.getDoc_type().equals("1")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=2 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width=15>&nbsp;</td>
                    <td width=683  align=left>
                        <table width=668 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td valign=top>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>	
                                <td>
                                    <table width=658 border=0 cellspacing=0 cellpadding=0r>
                                        <tr>
                                            <td width=125 style="font-size:11px;" valign=top>&nbsp; <span class=style4>1.��ǥ�̻� ���� ������:</span></td>
                                            <td style="font-size:11px; letter-spacing:-0.05em;">
                                            	<span class=style4>
                                            	�� ����ڵ���� �纻  &nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;�� ��ǥ�̻� �ź��� �纻 &nbsp;�� �ֿ�����  ������  �纻<br>
                                            	�� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ�, ���� �� ���θ��� ���� �ʿ�
                                            	</span>
                                            </td>
                                        </tr>
                                     </table>
                                 </td>
                             </tr>
                             <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                             <tr>
                             			<td>
                                       <table width=658 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=150 style="font-size:11px;" valign=top>&nbsp; <span class=style4>2.��ǥ�̻� ���� ���� �Ұ���:</span></td>
                                            <td style="font-size:11px; letter-spacing:-0.05em;">
                                            	<span class=style4>
                                            	�� ����ڵ���� �纻 &nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;�� �����ΰ������� 1��&nbsp; �� ��ǥ�̻� �ź��� �纻<br>�� ��ǥ�̻� �ΰ������� 1�� &nbsp;�� �ֿ����� ������ �纻 &nbsp;(�ΰ��������� �ֱ� 3�����̳� �߱޺�)
                                            	</span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� �������� : </span>  &nbsp;&nbsp;&nbsp;<span class=style4>�繫��ǥ(��������ǥ, ���Ͱ�꼭 ��) &nbsp;&nbsp;�� �ʿ�� ���뺸����(��ǥ�̻�)�� �ֹε�ϵ</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>			
	<%}else if(e_bean.getDoc_type().equals("2")){%>
    <!-- ���λ����-->
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (���λ����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=668 align=left>
                        <table width=668 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=65 valign=top>&nbsp;<img src=/acar/main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=580>
                                    <table width=580 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;">
	                                            <span class=style4>
					                                            �� ����ڵ���� �纻  &nbsp;&nbsp;�� ���������� �纻 &nbsp;&nbsp;�� ���� �纻(�ڵ���ü��) &nbsp;&nbsp;�� �ֿ����ڰ� ������ ��� �ֿ����� ������ �纻<br> 
					                                            �� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ� &nbsp;&nbsp; 
	                                            </span>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2 style="font-size:11px;">
	                                &nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> 
	                                <span class=style12>�ſ�ɻ� �������� :&nbsp;&nbsp; </span> 
	                                <span class=style4 style="font-size:11px;">���������ڷ�(�ΰ���ġ������ǥ�������� ��) &nbsp;&nbsp;
	                                <br><span style='margin-left: 100px;'>�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 style="font-size:10.8px; padding-top: 5px;">
                                            �ذ����(�����)�� ������ ���� ������ ����� �븮�ؾ� �� ��쿡�� �����(�����)�� �����ΰ������� �����ϰ�, �����(�����)�� �����ΰ�������(�ֱ� 3�����̳� �߱޵� ��)�� ÷���Ͽ� ����� ü���� �� �ֽ��ϴ�. (�Ƹ���ī �������� �� �븮�� �ź��� �ʿ�)
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>		
    <!-- ����-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=698 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img_prt.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img_prt.gif height=24>
                        <table width=698 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=658 align=left>
                        <table width=658 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=88>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=570>
                                    <table width=570 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;"><span class=style4>�� ���������� �纻  &nbsp;&nbsp;�� ���� �纻(�ڵ���ü��)</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� �������� :</span> &nbsp;&nbsp;&nbsp;<span class=style4>����������, �ҵ������ڷ�(��õ¡�������� ��)<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span></td>
                            </tr> 
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img_prt.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>	
	<%}%>
	<!--�ʿ伭��ǥ�� end-->		
    <tr>
        <td align=center colspan=3>
		  <a href=javascript:go_print('<%= est_id %>');><img src=./images/button_print.gif border=0></a>&nbsp;&nbsp;
		  <a href=javascript:go_mail('<%= est_id %>');><img src="./images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;		  
		</td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
	<tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
</table>

<SCRIPT LANGUAGE="JavaScript">
var EchoID = "amazonecar9";
var EchoGoodNm = "";
var EchoAmount = "";
var EchoUIP = "";
var EchoTarget = "";
var EchoLogSend = "";
var EchoCV = "";
var EchoPN = "";

var EchoLogServer = "adlog.cresendo.net";
var EchoCookieDays = 45;
var Echotoday = new Date();
function FN_ZoneMark(_Ea) { if (_Ea < 10) { return "0" + _Ea; } else { return _Ea; } }
var EchoToDay = Echotoday.getYear() + "" + FN_ZoneMark(Echotoday.getMonth()) + "" + FN_ZoneMark(Echotoday.getDate());
var EchoToDayHours = Echotoday.getHours();
function FN_GetDomain(_Eb) { var _s = _Eb.split("."); if (_s.length == 3) { if (_s[1].length == 2) { return _Eb; } else { return _s[1] + "." + _s[2]; } } else if (_s.length > 3) { if (_s[_s.length-2].length == 2) { return _s[_s.length-3] + "." + _s[_s.length-2] + "." + _s[_s.length-1]; } else { return _s[_s.length-2] + "." + _s[_s.length-1]; } } else { return _Eb; } }
function FN_SetCookie(_Ec,_Ed,_Ee,_Ef,_Eg) { var _dt = new Date(); _ut = _dt.getTime(); _Ee = (!_Ee) ? "/" : _Ee; if( _Ed == null ) { _Eg = 0; } if( _Eg != null ) { _et = _ut + (_Eg * 1000); _dt.setTime(_et); _pt = " expires=" + _dt.toUTCString() + ";"; 	} else { _pt = ""; } if( _Ef != null ) { _pt += " domain=" + _Ef + ";"; } document.cookie = _Ec + "=" + escape(_Ed) + "; path=" + _Ee + ";" + _pt; }
function FN_GetCookie(_Ec) { var _nc = _Ec + "="; var _x = 0; while( _x <= document.cookie.length ) { var _y = _x + _nc.length; if (document.cookie.substring(_x,_y) == _nc) { if ((_ec = document.cookie.indexOf(";",_y)) == -1) { _ec = document.cookie.length; } return unescape(document.cookie.substring(_y,_ec)); } _x = document.cookie.indexOf(" ", _x) + 1; if (_x == 0) { break; } } return ""; }
function FN_StrPos(_Eh,_Ei) { for (var _i=0; _i < _Eh.length; _i++) { if (_Eh.substring(_i, _i+1) == _Ei) { return _i; } } return -1; }
function FN_FullDomain(_Ej) { if (FN_StrPos(_Ej, ":") > 0) { _Ej = _Ej.substring(0, FN_StrPos(_Ej, ":")); } if (FN_StrPos(_Ej, "/") > 0) { _Ej = _Ej.substring(0, FN_StrPos(_Ej, "/")); } _Ej = FN_GetDomain(_Ej); return _Ej; }
function FN_PageUrl(_Ek) { _Ek = _Ek.replace("http://", ""); _Ek = _Ek.replace("https://", ""); if (_Ek.indexOf("/") > 0 ) { _Ek = _Ek.replace(_Ek.substring(0, FN_StrPos(_Ek, "/")), ""); _Ek = _Ek.substring(0, FN_StrPos(_Ek, "?")); return _Ek; } else { return "/"; } }
function FN_getNavigatorInfoStr() { var name = navigator.appName, ver = navigator.appVersion, ver_int = parseInt(navigator.appVersion), ua = navigator.userAgent, infostr; if(name == "Microsoft Internet Explorer") { if(ver.indexOf("MSIE 3.0") != -1) { return "Internet Explorer 3.0x"; } if(ver_int != 4) { return "Internet Explorer " + ver.substring(0, ver.indexOf(" ")); } var real_ver = parseInt(ua.substring(ua.indexOf("MSIE ") + 5)); if(real_ver >= 7) { infostr = "Windows Internet Explorer "; } else {infostr = "Microsoft Internet Explorer "; } if(ua.indexOf("MSIE 5.5") != -1) { return infostr + "5.5"; } else { return infostr + real_ver + ".x"; } return "Internet Explorer"; } else if(name == "Netscape") { if(parseInt(ua.substring(8, 8)) <= 4) { return "Netscape " + ver.substring(0, ver.indexOf(" ")); } else if(ua.lastIndexOf(" ") < ua.lastIndexOf("/")) { return ua.substring(ua.lastIndexOf(" ")); } else { return "Netscape"; } } else { return name; } }
function FN_getOSInfoStr() { var ua = navigator.userAgent; if(ua.indexOf("NT 6.0") != -1) { return "Windows Vista/Server 2008"; }  else if(ua.indexOf("NT 5.2") != -1) { return "Windows Server 2003"; } else if(ua.indexOf("NT 5.1") != -1) { return "Windows XP"; } else if(ua.indexOf("NT 5.0") != -1) { return "Windows 2000"; } else if(ua.indexOf("NT") != -1) { return "Windows NT"; } else if(ua.indexOf("9x 4.90") != -1) { return "Windows Me"; } else if(ua.indexOf("98") != -1) { return "Windows 98"; } else if(ua.indexOf("95") != -1) { return "Windows 95"; } else if(ua.indexOf("Win16") != -1) { return "Windows 3.x"; } else if(ua.indexOf("Windows") != -1) { return "Windows"; } else if(ua.indexOf("Linux") != -1) { return "Linux"; } else if(ua.indexOf("Macintosh") != -1) { return "Macintosh"; } else { return ""; } }
function FN_IPClose() { document.write("<body oncontextmenu='return false' onselectstart='return false' style='overflow:hidden;'><div id='DIVIPCLOSE' style='position:absolute; left:0; top:0; height:1200px; z-index: 90; background-color: #FFFFFF; filter:alpha(opacity=70);display:none;'><table id='tb1' border='0' height='500' cellpadding='0' cellspacing='0' align='center'><tr><td><table width='400' height='300' border='0' cellpadding='0' cellspacing='0' background='http://www.cresendo.net/img/ipClose/pop_back.jpg'><tr><td><table width='300' border='0' align='center' cellpadding='0' cellspacing='0'><tr valign='top'><td height='200' colspan='2'><div align='center' style='font-family:����;font-size:9pt;'><p><strong>�˼��մϴ� !</strong><br><br>���� ������ �˻��� ���� ������ ���ܵ� ��� �Դϴ�.<br><br>���� �ߺ� �˻��� �������� ���� �Ұ����ϰ� <br>������ �����մϴ�.<br>�Ʒ� &quot;<strong>���ã�� �߰��ϱ�</strong>&quot; �� ���� <br>���� �����Ͻñ⸦ �����մϴ�.</p></div></td></tr><tr><td><div align='center'><a href='javascript:FN_bookmarksite()'><img src='http://www.cresendo.net/img/ipClose/pop_bt1.gif' width='138' height='29' border='0'></a></div></td><td><div align='center'><a href='javascript:window.close()'><img src='http://www.cresendo.net/img/ipClose/pop_bt2.gif' border='0' width='70' height='29'></div></td></tr></table></td></tr></table></td></tr></table></div></body>"); var arrayPageSize = this.getPageSize(); document.getElementById('tb1').style.width = arrayPageSize[0] + 'px'; document.getElementById('DIVIPCLOSE').style.height = arrayPageSize[1] + 'px'; FN_DivSH(document.getElementById("DIVIPCLOSE"), "true"); document.getElementById("DIVIPCLOSE").focus(); }
function FN_DivSH(DivName, SHType) { if (SHType == "auto") { if (DivName.style.display == "none") { DivName.style.display = "block"; } else { DivName.style.display = "none"; } } else if (SHType == "true") { DivName.style.display = "block"; } else if (SHType == "false") { DivName.style.display = "none"; } }
function getPageSize() { var xScroll, yScroll; if (window.innerHeight && window.scrollMaxY) { xScroll = window.innerWidth + window.scrollMaxX; yScroll = window.innerHeight + window.scrollMaxY; } else if (document.body.scrollHeight > document.body.offsetHeight){ xScroll = document.body.scrollWidth; yScroll = document.body.scrollHeight; } else { xScroll = document.body.offsetWidth; yScroll = document.body.offsetHeight; } var windowWidth, windowHeight; if (self.innerHeight) { if(document.documentElement.clientWidth){ windowWidth = document.documentElement.clientWidth; } else { windowWidth = self.innerWidth; } windowHeight = self.innerHeight; } else if (document.documentElement && document.documentElement.clientHeight) { windowWidth = document.documentElement.clientWidth; windowHeight = document.documentElement.clientHeight; } else if (document.body) { windowWidth = document.body.clientWidth; windowHeight = document.body.clientHeight; } if(yScroll < windowHeight){ pageHeight = windowHeight; } else { pageHeight = yScroll; } if(xScroll < windowWidth){ pageWidth = xScroll; } else { pageWidth = windowWidth; } return [pageWidth,pageHeight]; }
function FN_bookmarksite() { var title=window.location.title; var url=window.location.href; if (window.sidebar) { window.sidebar.addPanel(title, url, ""); }else if(window.opera && window.print) { var elem = document.createElement('a');  elem.setAttribute('href',url); elem.setAttribute('title',title); elem.setAttribute('rel','sidebar'); elem.click(); } else if(document.all) { window.external.AddFavorite(parent.location.href, parent.location.title); } }

var _EchoPR = location.protocol.indexOf("https");
var _EchoHostName = location.hostname;
var _EchoPathName = location.pathname;
var _EchoSearch = location.search;
var _EchoHash = location.hash
var _EchoUL = document.URL;
var _EchoRF = document.referrer;
var _EchoDoMain = FN_FullDomain(_EchoHostName);

var _EchoAK = FN_GetCookie("ECHO_AKEY");
var _EchoCK = FN_GetCookie("ECHO_CKEY");
var _EchoSK = FN_GetCookie("ECHO_KEY");
var _EchoSS = FN_GetCookie("ECHO_SESSION");
var _EchoOv = FN_GetCookie("ECHO_OVKEY");
var _EchoK = "";
var _EchoDate = FN_GetCookie("ECHO_DATE");
var _EchoInKey = "";
var _EchoCV = "";
var _EchoPN = "";
var _EchoLogSend = "";

if (_EchoUL.indexOf("#") > 0) { _EchoUL = _EchoUL.substring(0, _EchoUL.indexOf("#")); }
if (_EchoUL.charAt(_EchoUL.length-1) == "/" ) { _EchoUL = _EchoUL.substring(0, _EchoUL.length-1); }

var _EchoULEchoKey = _EchoUL.toUpperCase().indexOf("ECHO_KEY=");
var _EchoULOvKey = _EchoUL.toUpperCase().indexOf("OVKEY=");
var _EchoULTemp="", _EchoULSubDomain="", _EchoRFTemp="", _EchoRFSubDomain="";

if (_EchoULEchoKey > 0) { var _ii = _EchoUL.indexOf("&", _EchoULEchoKey+9); if( _ii > 0 ) { _EchoK = _EchoUL.substring(_EchoULEchoKey+9, _ii); } else { _EchoK = _EchoUL.substring(_EchoULEchoKey+9); } if( _EchoK != _EchoSK ) { echo_new_session = true; } FN_SetCookie("ECHO_KEY", _EchoK, "/", _EchoDoMain); }
if (_EchoULOvKey > 0) { var _ii = _EchoUL.toUpperCase().substring(_EchoULOvKey+6, _EchoUL.toUpperCase().indexOf("&", _EchoULOvKey+6)); _EchoOv = _ii; FN_SetCookie("ECHO_OVKEY", _ii, "/", _EchoDoMain); }
if (!_EchoK || _EchoK == "") { _EchoK="unknown"; }
if (!_EchoCK || _EchoCK == "") { _EchoCK="unknown"; }
if (_EchoK != "unknown") { _EchoCK = _EchoK; _EchoDate = EchoToDay; FN_SetCookie("ECHO_CKEY", _EchoK, "/", _EchoDoMain, EchoCookieDays * 24 * 60 * 60); FN_SetCookie("ECHO_DATE", EchoToDay, "/", _EchoDoMain, EchoCookieDays * 24 * 60 * 60); if (!_EchoAK || _EchoAK == "") { _EchoAK = _EchoK; FN_SetCookie("ECHO_AKEY", _EchoK, "/", _EchoDoMain, 1 * 24 * 60 * 60); } }
if (!_EchoSS || _EchoSS == "") { var _DT=new Date(); _EchoSS = ((Math.round(Math.random()*900)%900+100)) + "" + _DT.getTime(); FN_SetCookie("ECHO_SESSION", _EchoSS, "/", _EchoDoMain); }

_EchoUL = _EchoUL.replace("'", "");
_EchoULTemp = _EchoUL.replace("http://", "");
_EchoULTemp = _EchoULTemp.replace("https://", "");
_EchoULSubDomain = FN_FullDomain(_EchoULTemp);

if (!_EchoRF || _EchoRF == "") { _EchoRFSubDomain = ""; } else { _EchoRF = _EchoRF.replace("'", ""); _EchoRFTemp = _EchoRF.replace("http://", ""); _EchoRFTemp = _EchoRFTemp.replace("https://", ""); _EchoRFSubDomain = FN_FullDomain(_EchoRFTemp); }

var _LandYn = "N";
var _BookMark = "N";
var _EchoIPCloseYn = "N";

if (_EchoPR > 0) { if (_EchoULSubDomain != _EchoRFSubDomain) { _LandYn="Y"; if (_EchoRFSubDomain == "") { _BookMark="Y"; _LandYn="N"; } } _EchoInKey = _EchoCK; } else { if (_EchoULSubDomain != _EchoRFSubDomain) { _LandYn="Y"; if (_EchoRFSubDomain == "") {  _BookMark="Y"; _LandYn="N"; } } if (_EchoK=="unknown") { if (_EchoCK=="unknown") { _EchoInKey = _EchoAK; } else { _EchoInKey = _EchoCK; } } else { _EchoInKey = _EchoK; } }
if (_LandYn=="Y" && _BookMark=="N") { if (typeof(IPClose)=="object") {  if (IPClose[0].indexOf(EchoUIP) > 0) { _EchoIPCloseYn="Y"; FN_IPClose(); } } }
if (typeof(EchoTarget)!="string") { EchoTarget=""; }
if (typeof(EchoCV)=="undefined" || typeof(EchoCV)!="string") { _EchoCV=""; } else { _EchoCV=EchoCV; }
if (typeof(EchoPN)=="undefined" || typeof(EchoPN)!="string") { _EchoPN=""; } else { _EchoPN=EchoPN; }
if (typeof(EchoLogSend)=="undefined" || typeof(EchoLogSend)!="string") { _EchoLogSend=""; } else { _EchoLogSend=EchoLogSend; }

if (_EchoLogSend=="Y") {
	if (_EchoInKey!="" || _EchoAK!="") {
		if (_LandYn=="Y" || _EchoCV=="Y" || _BookMark=="Y") {
			var _EchoLogUrl = "//" + EchoLogServer + "/?ac=" + EchoID + "&k=" + escape(_EchoInKey) + "&ak=" + _EchoAK + "&ok=" + escape(_EchoOv)+ "&la=" + _LandYn + "&bm=" + _BookMark + "&gd=" + encodeURIComponent(EchoGoodNm) + "&at=" + EchoAmount + "&ud=" + escape(_EchoULSubDomain) + "&ul=" + escape(_EchoUL) + "&rd=" + escape(_EchoRFSubDomain) + "&rl=" + escape(_EchoRF) + "&pg=" + escape(_EchoUL.replace(_EchoSearch + _EchoHash,"")) + "&cd=" + _EchoDate + "&ic=" + _EchoIPCloseYn + "&br=" + escape(FN_getNavigatorInfoStr()) + "&os=" + escape(FN_getOSInfoStr()) + "&et=" + EchoTarget + "&cv=" + _EchoCV + "&pn=" + _EchoPN + "&ss=" + _EchoSS + "&vr=4.0";
			var _EchoImg = new Image(); _EchoImg.src = _EchoLogUrl;
		}
	}
} else {
	var _EchoLogUrl = "//" + EchoLogServer + "/?ac=" + EchoID + "&k=" + escape(_EchoInKey) + "&ak=" + _EchoAK + "&ok=" + escape(_EchoOv)+ "&la=" + _LandYn + "&bm=" + _BookMark + "&gd=" + encodeURIComponent(EchoGoodNm) + "&at=" + EchoAmount + "&ud=" + escape(_EchoULSubDomain) + "&ul=" + escape(_EchoUL) + "&rd=" + escape(_EchoRFSubDomain) + "&rl=" + escape(_EchoRF) + "&pg=" + escape(_EchoUL.replace(_EchoSearch + _EchoHash,"")) + "&cd=" + _EchoDate + "&ic=" + _EchoIPCloseYn + "&br=" + escape(FN_getNavigatorInfoStr()) + "&os=" + escape(FN_getOSInfoStr()) + "&et=" + EchoTarget + "&cv=" + _EchoCV + "&pn=" + _EchoPN + "&ss=" + _EchoSS + "&vr=4.0";
	var _EchoImg = new Image(); _EchoImg.src = _EchoLogUrl;
}

</script>


</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
    </body>
</html>