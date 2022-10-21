<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	e_bean = e_db.getEstimateHpCase(est_id);
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean 		= e_db.getEstimateCase(est_id);
	}
	
	String a_a = "";
	String rent_way = "";
	if(!e_bean.getA_a().equals("")){
		a_a 		= e_bean.getA_a().substring(0,1);
		rent_way 	= e_bean.getA_a().substring(1);
	}
	String a_b 		= e_bean.getA_b();
	float o_13 		= 0;
	
	String name = "";
	if(e_bean.getA_a().equals("11")) name = "���� �Ϲݽ�";
	if(e_bean.getA_a().equals("12")) name = "���� �⺻��";
	if(e_bean.getA_a().equals("21")) name = "��ⷻƮ �Ϲݽ�";
	if(e_bean.getA_a().equals("22")) name = "��ⷻƮ �⺻��";
	
	//CAR_NM : ��������
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean.getS_st();
	
	String car_name = cm_bean.getCar_nm()+" "+cm_bean.getCar_name();
	
	
	//�ܰ� ��������
	Hashtable sh_comp = shDb.getShCompareHp(est_id);
	
	if(from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		sh_comp = shDb.getShCompare(est_id);
	}
	
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�׸� ��</title>
<style type="text/css">
<!--
.style1 {color: #507a23}
.style2 {color: #507A23}
.style3 {color: #8a7953}
.style4 {color: #262626}
.style5 {color: #375616}
.style6 {color: #787878;
		font-size:11px;}
.compare-content-box { background-color: #eeeeee; padding: 15px 25px; border-radius: 15px;	}
.compare-content-box .box-div { margin-top: -5px;	}
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

function show_compare(arg){
	if(arg=='2'){
		location.href = "./m_compare.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='3'){
		location.href = "./m_cash_flow.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}else if(arg=='4'){
		location.href = "./m_cost_all.jsp?est_id=<%= est_id %>&from_page=<%= from_page %>";
	}
}

//-->
		
</script>
<!--���� �м��� ����-->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-30468978-3', 'auto');
  ga('send', 'pageview');
</script>
<!--���� �м��� ����-->
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td><img src=/acar/main_car_hp/images/bar_compare_2.gif border=0 usemap=#map></td>
	</tr>
	<map name=Map>
    <area shape=rect coords=585,8,677,36 href=javascript:onprint();>
	</map>
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
		<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:'�������'; font-size:17px; font-weight:bold; color:#2d5403;">�� �׸� ��</span></td>
	</tr>
	<tr>
		<td>
		    <table width=700 border=0 cellspacing=0 cellpadding=0>
		        <tr>
		            <td width=25>&nbsp;</td>
		            <td width=650>
		                <table width=650 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td align=right height=15 valign=bottom>[����:��]</td>
		                    </tr>
		                    <tr>
		                        <td height=2 bgcolor=c3b696></td>
		                    </tr>
		                    <tr>
		                        <td>
            		                <table width=650 border=0 cellpadding=0 cellspacing=1 bgcolor=c3b696>
                    <tr bgcolor=#FFFFFF> 
                      <td colspan=4 rowspan=2 align=center bgcolor=f0e6ca><font color=867349><b>�� 
                        ��</b></font> </td>
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><font color=867349><b><%=e_bean.getA_b()%>���� 
                        �Һα���</b></font> </td>
                      <td width=127 rowspan=2 align=center bgcolor=f0e6ca><font color=867349><b>�Ƹ���ī<br>
                        <%=name%>
                        <br>
                        (<%=e_bean.getA_b()%>����) </b></font> </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td width=91 height=23 align=center bgcolor=f0e6ca>�Ѻ��(<%=e_bean.getA_b()%>����)</td>
                      <td colspan=2 align=center bgcolor=f0e6ca>�� �� �� ��</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td width=22 rowspan=3><span class=style3></span></td>
                      <td height=19 colspan=3 align=center><span class=style3>��������</span></td>
                      <td>&nbsp;<%=sh_comp.get("I67")%></td>
                      <td width=91 align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O67")))%>&nbsp;</span></td>
                      <td width=189 rowspan=3 align=center><span class=style1><%=car_name%></span></td>
                      <td rowspan=<%if(e_bean.getEcar_pur_sub_amt()>0){%>7<%}else{%>5<%}%>>&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>Ź 
                        �� ��</span></td>
                      <td align=center>�������</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O68")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>����������</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O69")))%>&nbsp;</span></td>
                    </tr>
                    <%if(e_bean.getEcar_pur_sub_amt()>0){%>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3><%if(e_bean.getEcar_pur_sub_amt()>0){%>ģȯ���� ���ź�����<%}%></span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(e_bean.getEcar_pur_sub_amt())%>&nbsp;</span></td>
                      <td align=center></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3><%if(e_bean.getEcar_pur_sub_amt()>0){%>����������-���ź�����<%}%></span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O69"))-e_bean.getEcar_pur_sub_amt())%>&nbsp;</span></td>
                      <td align=center></td>
                    </tr>                    
                    <%}%>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>�� 
                        �� �� ��</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O70")))%>&nbsp;</span></td>
                      <td align=center>����Ŀ ������  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>�� 
                        ���� </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=4 align=center><span class=style3>�� 
                        �� �� ��</span></td>
                      <td>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O71")))%>/��&nbsp;</span></td>
                      <td align=center>������ <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO70"))*10000)/100f %>%</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=12 align=center bgcolor=f0e6ca><b><span class=style3>��<br>
                        <br>
                        ��<br>
                        <br>
                        ��<br>
                        <br>
                        ��<br>
                        <br>
                        ��</span></b></td>
                      <td width=22 rowspan=5 align=center><span class=style3>��<br>
                        <br>
                        ��</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>����Ŀ 
                        ������</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I72")))%>&nbsp;</span></td>
                      <td align=center>�������� <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O72"))*1000)/10f %>%</td>
                      <td align=center></td>
                      <td rowspan=4 align=right valign=bottom>
                        <%=sh_comp.get("AK78")%>
                        &nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF>                       
                      <td width=67 colspan=2 height=19 align=center><span class=style3>������漼</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I75")))%>&nbsp;</span></td>
                      <td align=right>&nbsp;<%= Math.round(AddUtil.parseFloat((String)sh_comp.get("O75"))*1000)/10f %>%&nbsp;</td>
                      <td></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>��ä����</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I76")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>��ä���θŵ�(�������,������ <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO77"))*1000)/10f %>%) 
                      </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>�δ���</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I77")))%>&nbsp;</span></td>
                      <td>&nbsp;</td>
                      <td align=center>��ȣ�Ǵ� + ������ + ��ϴ���� ��</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=2 align=center bgcolor=fdf9e9><span class=style3>���Դܰ� 
                        �����</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I79")))%>&nbsp;</span></td>
                      <td colspan=2 align=center><span class=style2>&nbsp;</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE79")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=6 align=center><span class=style3>��<br>
                        <br>
                        ��</span></td>
                      <td height=19 colspan=2 align=center><span class=style3>�� 
                        �� �� </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I80")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O80")))%>/��&nbsp;</span></td>
                      <td align=center>���ξ����� ���պ���(DB���غ���) </td>
                      <td rowspan=5 align=right>���뿩��(VAT����)&nbsp;<br> <%= AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()) %>/��&nbsp;<br>
                        <br><br><br>
                        �� �߰���� ���� ����&nbsp;<br>
                        �� �ش缭�� ����&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>�� 
                        �� �� </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I81")))%>&nbsp;</span></td>
                      <td><span class=style4></span></td>
                      <td align=center>= ���Һα� �� �Һΰ����� </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=2 align=center><span class=style3>�ڵ�����</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I82")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O82")))%>/��&nbsp;</span></td>
                      <td align=center>�̿�Ⱓ ����� �ڵ�����</td>
                    </tr>                    
                    <tr bgcolor=#FFFFFF> 
                      <td height=35 colspan=2 align=center><span class=style3>���ó�� 
                        �� <br>
                        ������,<br>
                        �ڵ����˻��
                        </span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I84")))%></span>&nbsp;</td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O84")))%>/��&nbsp;</span></td>
                      <td align=center>�Ƹ���ī ����ǰ �⺻ ��������<br>
                        (����, ���ػ��ÿ��� �������),<br>
                        �ڵ��� ����/���� �˻��� ���� </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td colspan=2 align=center height=35><span class=style3>������� 
                        ��ü <br>
                        �� �������</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I85")))%>&nbsp;</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("O85")))%>/��&nbsp;</span></td>
                      <td align=center>�Ƹ���ī �ϹݽĻ�ǰ �������� </td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=2 align=center bgcolor=fdf9e9><span class=style3>�����ܰ� 
                        �����</span></td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I86")))%>&nbsp;</span></td>
                      <td colspan=2>&nbsp;</td>
                      <td align=right bgcolor=fdf9e9><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE86")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><b><span class=style3>����/�����Ѻ��(��)</span></b></td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I87")))%>&nbsp;</span></td>
                      <td colspan=2 bgcolor=f0e6ca>&nbsp;</td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE87")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td rowspan=3 bgcolor=f0e6ca><span class=style3></span></td>
                      <td height=19 colspan=3 align=center><span class=style3>�߰��� 
                        �Ű� ����</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I88")))%>&nbsp;</span></td>
                      <td colspan=2 align=center>���������� <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO86"))*1000)/10f %>%�� �Ű�</td>
                      <td rowspan=2 align=right>������ ȯ�Ҿ�&nbsp;</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=19 colspan=3 align=center><span class=style3>�Ű� 
                        �ΰ���</span></td>
                      <td align=right><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I89")))%>&nbsp;</span></td>
                      <td colspan=2 align=center>�Ű��� �Ű������� 10% �ΰ��� �����ؾ� ��</td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=24 colspan=3 align=center bgcolor=f0e6ca><b><span class=style3>�߰����Ű�����(��) 
                        </span></b></td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I90")))%>&nbsp;</span></td>
                      <td colspan=2 align=center bgcolor=f0e6ca>= �߰��� �Ű� ���� - 
                        �Ű� �ΰ���</td>
                      <td align=right bgcolor=f0e6ca><span class=style4><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE90")))%>&nbsp;</span></td>
                    </tr>
                    <tr bgcolor=#FFFFFF> 
                      <td height=39 colspan=4 align=center><b><span class=style3><%=e_bean.getA_b()%>���� 
                        ���� �̿뿡 <br>
                        ���� �����</span></b></td>
                      <td align=right><b><font color=1555be><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I91")))%>&nbsp;</font></b></td>
                      <td colspan=2 align=center>= �� - �� </td>
                      <td align=right><b><font color=1555be><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%>&nbsp;</font></b></td>
                    </tr>
                  </table>
                                </td>
                            </tr>
                            <tr>
		                        <td height=2 bgcolor=c3b696></td>
		                    </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=650 border=0 cellspacing=0 cellpadding=0>
            		                    <tr>
            		                        <td width=415>&nbsp;</td>
            		                        <td width=235 background=/acar/main_car_hp/images/c_compare_bg.gif align=right height=30><b><font color=FFFFFF>�Һα��� ��� :</font>
            		                        <font color=e9fe01><%if(AddUtil.parseInt((String)sh_comp.get("AE93"))>0){%>+<%}%><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE93")))%></font></b>&nbsp;&nbsp;&nbsp;</td>
            		                    </tr>
            		                </table>
                                </td>
                            </tr>
                            <tr>
                                <td align=right><img src=/acar/main_car_hp/images/c_compare_01.gif></td>
                            </tr>
                            <tr>
                                <td align=right>
                                    <table width=636 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=307 valign=top>
                                                <table width=307 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan='2' height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_1.gif></td>
                                                        <td align=right>(�ֹμ� ����)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom><img src=/acar/main_car_hp/images/c_compare_03.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=76 align=center height=21 class=listnum3><font color=262626>2�� ����</font></td>
                                                                                <td width=62 align=center class=listnum3><font color=262626>11.0%</font></td>
                                                                                <td width=74 align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td width=89 align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.11)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>200�� ����</font></td>
                                                                                <td align=center class=listnum3><font color=262626>22.0%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.22)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>200�� �ʰ�</font></td>
                                                                                <td align=center class=listnum3><font color=262626>24.2%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.242)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>      
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* �������� �̿�ÿ��� ���ó���� �����ϳ�, <br>&nbsp;&nbsp;&nbsp;ȸ��ó���� �ſ� �����մϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* �¿���(����,9�ν� ����)�� ��� �������԰� ��ⷻƮ/����<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  ��� ������ ���� �ڵ��� ������ �����ϰ�, ���μ�����<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  �պ�ó�� ���ؿ� ���� �պ�ó�� ����(��� Ȩ������<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  '������¿��� �պ�ó�� ����' ����)
                                                        	</span></td>
                                                    </tr>
                                                </table>
                                            <td width=23>&nbsp;</td>
                                            <td width=309 align=left>
                                                <table width=309 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan='2' height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/c_compare_01_2.gif></td>
                                                        <td align=right>(�ֹμ� ����)</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=center>
                                                            <table width=307 border=0 cellpadding=0 cellspacing=1 bgcolor=d4dcb0>
                                                                <tr>
                                                                    <td bgcolor=FFFFFF align=center>
                                                                        <table width=301 border=0 cellspacing=0 cellpadding=1>
                                                                            <tr>
                                                                                <td colspan=4 height=26 valign=bottom align=center><img src=/acar/main_car_hp/images/c_compare_03_1.gif></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width=88 align=center height=21 class=listnum3><font color=262626>4600���� ����</font></td>
                                                                                <td width=58 align=center class=listnum3><font color=262626>16.5%</font></td>
                                                                                <td width=70 align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td width=85 align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.165)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>8800���� ����</font></td>
                                                                                <td align=center class=listnum3><font color=262626>26.4%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.264)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1��5õ���� ����</font></td>
                                                                                <td align=center class=listnum3><font color=262626>38.5%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.385)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan=4 bgcolor=d6d6d6 height=-1></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align=center height=21 class=listnum3><font color=262626>1��5õ���� �ʰ�</font></td>
                                                                                <td align=center class=listnum3><font color=262626>41.8%</font></td>
                                                                                <td align=right class=listnum3><font color=262626><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("AE91")))%></font>&nbsp;</td>
                                                                                <td align=right class=listnum3><font color=375616><b><%= AddUtil.parseDecimal(Math.round(AddUtil.parseInt((String)sh_comp.get("AE91"))*0.418)) %></b></font>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>      
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' height=45><span class=style6>&nbsp;* �������� �̿�� �պ�ó���� �� �� ��쵵 ������, <br>&nbsp;&nbsp;&nbsp;��ⷻƮ/���� �̿�ÿ��� ���� �պ�ó�� ���� �մϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan='2' align=left height=45><span class=style6>&nbsp;* �¿���(����,9�ν� ����)�� ��� 2016�� �ҵ漼������ ����<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  �ǰ� �ִ� ������¿��� �պ�ó�� ���ؿ� ���� �պ�ó�� ����<br>&nbsp;&nbsp;&nbsp;
                                                        	                                                  (��� Ȩ������ '������¿��� �պ�ó�� ����' ����)
                                                        	</span></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td><img src=/acar/main_car_hp/images/c_compare_02.gif></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <!-- <tr>
                                <td><img src=/acar/main_car_hp/images/c_compare_02_1.gif></td>
                            </tr> -->
                            <tr>    
                                <td>
                                	<div class="compare-content-box">
                                		<table width="100%">
                                			<tr>
                                				<td width="3%"><div class="box-div">1)</div></td>
                                				<td width="*">�뿩�� �պ�ó���� ȸ��ó���� �ſ� �����մϴ�.(�ſ� �ߺεǴ� ���ݰ�꼭 1������ ���ó�� �Ϸ�)</td>
                                			</tr>
                                			<tr>
                                				<td><div class="box-div">2)<br>&nbsp;</div></td>
                                				<td>�������� �̿�� �պ�ó���� �Ұ����ϰų�, ����� ��쿡�� ���� �պ�ó�� �� �� �ֽ��ϴ�.(���λ����, ��ȣ�� ��)</td>
                                			</tr>
                                			<tr>
                                				<td><div class="box-div">3)<br>&nbsp;</div></td>
                                				<td>�Һα����̳� �Ϲ� ĳ��Ż�� ���� �̿�� ������ ���꿡 ������ �ִ� ������ ó�� ������, �Ƹ���ī ��ⷻƮ/���� �̿�� ����� ������ �ʽ��ϴ�.</td>
                                			</tr>
                                		</table>
                                	</div>
                                </td>
                            </tr>
                        </table>
		            </td>
		            <td width=25>&nbsp;</td>
		        </tr>
		    </table>
		</td>
	</tr>
	<tr>	
		<td align=center height=70>
		<a href="javascript:show_compare('2');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image2','','/acar/main_car_hp/images/button_02_01.gif',2)><img src=/acar/main_car_hp/images/button_02.gif name=Image2 border=0></a>&nbsp;
		<a href="javascript:show_compare('3');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image3','','/acar/main_car_hp/images/button_03_01.gif',2)><img src=/acar/main_car_hp/images/button_03.gif name=Image3 border=0></a>&nbsp;
		<a href="javascript:show_compare('4');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/main_car_hp/images/button_04_01.gif',2)><img src=/acar/main_car_hp/images/button_04.gif name=Image4 border=0></a>
		</td>
	</tr>
</table>

<!--Adgather Log Analysis v2.0 start-->
<script LANGUAGE="JavaScript" type="text/javascript">
<!--
     var domainKey = "1378270167211"
     var _localp = ""
     var _refererp = ""
     var _aday = new Date(); 
     var _fname = ""; 
     var _version = String(_aday.getYear())+String(_aday.getMonth()+1)+String(_aday.getDate())+String(_aday.getHours()); 
     document.write ("<"+"script language='JavaScript' type='text/javascript' src='"+document.location.protocol+"//logsys.adgather.net/adtracking.js?ver="+_version+"'>");
     document.write ("</"+"script>");
 //-->
 </script>
<!--Adgather Log Analysis v2.0 end-->


<!-- AceCounter Log Gathering Script V.71.2013012101 -->
<script language='javascript'>
if(typeof EL_GUL == 'undefined'){
var EL_GUL = 'dgc2.acecounter.com';var EL_GPT='8080'; var _AIMG = new Image(); var _bn=navigator.appName; var _PR = location.protocol=="https:"?"https://"+EL_GUL:"http://"+EL_GUL+":"+EL_GPT;if( _bn.indexOf("Netscape") > -1 || _bn=="Mozilla"){ setTimeout("_AIMG.src = _PR+'/?cookie';",1); } else{ _AIMG.src = _PR+'/?cookie'; };
document.writeln("<scr"+"ipt language='javascript' src='/acecounter/acecounter_V70.js'></scr"+"ipt>");
}
</script>
<noscript><img src='http://dgc2.acecounter.com:8080/?uid=AR5F38251710881&je=n&' border=0 width=0 height=0></noscript>
<!-- AceCounter Log Gathering Script End -->


</body>
</html>

<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 10.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>