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
<title>Cash flow ��</title>
<style type="text/css">
<!--
.style6 {color: #9b8c69}
.style7 {color: #515151}
.style9 {color: #343434}
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
		<td><img src=/acar/main_car_hp/images/bar_compare_1.gif border=0 usemap=#map></td>
	</tr>
	<map name=Map>
    <area shape=rect coords=585,8,677,36 href=javascript:onprint();>
	</map>
	<tr>
	    <td height=15></td>
	</tr>

	<tr>
		<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:'�������'; font-size:17px; font-weight:bold; color:#2d5403;">�� Cash Flow ��</span></td>
	</tr>

	<tr>
        <td align=right height=18 class=listnum2 valign=bottom><font color=828282>[<%=car_name%> ���� (����:��)]</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td align=center>
            <table width=665 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>                    
	<tr>
	    <td align=center>
	        <table width=665 border=0 cellpadding=0 cellspacing=1 bgcolor=c3b696>
                <tr align=center bgcolor=#FFFFFF>
                    <td width=46 rowspan=2 bgcolor=f0e6ca><font color=6c5d3b>���<br>������</font></td>
                    <td height=35 colspan=6 bgcolor=f0e6ca><font color=6c5d3b><%=e_bean.getA_b()%>���� �Һα���</font></td>
                    <td colspan=2 bgcolor=f0e6ca><font color=6c5d3b>�Ƹ���ī <br>
		              <%=name%>
					  (<%=e_bean.getA_b()%>����)</font></td>
                </tr>
                <tr bgcolor=#FFFFFF>
                    <td width=74 height=40 align=center bgcolor=ffffff><font color=6c5d3b>�ʱ���/<br>�Һα�</font></td>
                    <td width=79 align=center bgcolor=ffffff><font color=6c5d3b>�����/<br>�߰��� �Ű�</font></td>
                    
          <td width=68 align=center bgcolor=ffffff><font color=6c5d3b>�ڵ�����</font></td>
                    <td width=68 align=center bgcolor=ffffff><font color=6c5d3b>���ó��<br>������<br>�ڵ����˻��</font></td>
                    <td width=72 align=center bgcolor=ffffff><font color=6c5d3b>�������</font></td>
                    <td width=81 align=center bgcolor=fdf9e9><font color=6c5d3b>������� ����</font></td>
                    <td width=83 align=center bgcolor=fdf9e9><font color=6c5d3b>������� ����</font></td>
                    <td width=84 align=center bgcolor=fdf9e9><font color=6c5d3b>�Һα��� ���</font></td>
                </tr>
				<%
				long amt1=0, amt2=0, amt3=0, amt4=0, mon_tot_amt=0, sum_amt=0, ama_sum_amt=0, last_amt=0, tot_amt1=0, tot_amt2=0, tot_amt3=0, tot_amt4=0, tot_amt5=0, tot_last_amt=0;
				
				double d_amt4 =0;
				double d_mon_tot_amt =0;
				double d_sum_amt =0;
				double d_last_amt =0;
				double d_tot_amt4 =0;
				double d_tot_amt5 =0;
				double d_tot_last_amt =0;
				
				for(int i=0; i<AddUtil.parseInt(e_bean.getA_b())+1; i++){
					
					//�ʱ���/�Һα�
					if(i==0)					amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("I79")));	//���Դܰ� �����
					else							amt1 = AddUtil.parseLong(String.valueOf(sh_comp.get("O71")));	//���Һα�
					
					tot_amt1 += amt1;
					
					//�����/�߰����Ű�
					if(i==0||i==12||i==24||i==36||i==48){
						amt2 = AddUtil.parseLong(String.valueOf(sh_comp.get("O80")));
					}else{
						amt2 = 0;
					}
					if(i==AddUtil.parseInt(e_bean.getA_b()))	amt2 = -AddUtil.parseLong(String.valueOf(sh_comp.get("I90")));
					
					
					tot_amt2 += amt2;
					
					//�ڵ�����/ȯ�氳���δ��
					if(i>0 && i%6==0)																	amt3 = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O82")))/2.0);
					else if(i==3||i==9||i==15||i==21||i==27||i==33) 	amt3 = AddUtil.parseLong(String.valueOf(sh_comp.get("I83")));
					else																							amt3 = 0;
					
					tot_amt3 += amt3;
					
					//���ó��/������
					if(i>0)							amt4   = Math.round(AddUtil.parseLong(String.valueOf(sh_comp.get("O84")))/12.0)+AddUtil.parseLong(String.valueOf(sh_comp.get("O85")));
					if(i>0)							d_amt4 = AddUtil.parseDouble(String.valueOf(sh_comp.get("O84")))/12+AddUtil.parseDouble(String.valueOf(sh_comp.get("O85")));
					
					tot_amt4 += amt4;
					d_tot_amt4 += d_amt4;
					
					//��������հ�
					mon_tot_amt =	amt1+amt2+amt3+amt4;
					d_mon_tot_amt = amt1+amt2+amt3+d_amt4;
					
					tot_amt5 += mon_tot_amt; 
					d_tot_amt5 += d_mon_tot_amt; 
					
					//������봩��
					sum_amt += mon_tot_amt;
					d_sum_amt += d_mon_tot_amt;
					
					//�Ƹ���ī ��봩��
					if(i==0)																			ama_sum_amt += AddUtil.parseLong(String.valueOf(sh_comp.get("AE79")));
					else if(i==AddUtil.parseInt(e_bean.getA_b()))	ama_sum_amt += (e_bean.getFee_s_amt()+e_bean.getFee_v_amt() - e_bean.getGtr_amt()); 
					else																					ama_sum_amt += e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
					
					//�Һα��Դ��
					last_amt = ama_sum_amt - sum_amt;
					d_last_amt = ama_sum_amt - d_sum_amt;
					
					tot_last_amt += last_amt;
					d_tot_last_amt += d_last_amt;
					
				 %>
                <tr bgcolor=#FFFFFF>
                    <td height=18 align=center class=listnum2 bgcolor=fdf9e9><span class=style6><b><%= i %></b></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt1) %></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt2) %></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt3) %></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(amt4) %></span></td>
                    <td align=right><span class=style7><%= AddUtil.parseDecimal(mon_tot_amt) %></span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimal((long)d_sum_amt) %></span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimal(ama_sum_amt) %></span></td>
                    <td align=right><span class=style9><%= AddUtil.parseDecimal((long)d_last_amt) %></span></td>
                </tr>
				<% } %>				
                <tr bgcolor=#FFFFFF>
                    <td height=30 align=center bgcolor=f0e6ca><font color=6c5d3b>�� ��</font></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt1) %></b></span></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt2) %></b></span></td>
                    <td align=right><span class=style7><b><%= AddUtil.parseDecimal(tot_amt3) %></b></span></td>
                    <td align=right><span class=style7><b><%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_comp.get("I84")))%></b></span></td>
                    <td align=right bgcolor=fdf9e9><span class=style7><b><%= AddUtil.parseDecimal((long)d_tot_amt5) %></b></span></td>
                    
          <td align=right bgcolor=fdf9e9><span class=style9>&nbsp;</span></td>
                    
          <td align=right bgcolor=fdf9e9><span class=style9>&nbsp;</span></td>
                    <td align=right>&nbsp;</td>
                </tr>
                <tr bgcolor=#FFFFFF>
                    <td height=30 align=center bgcolor=f0e6ca><font color=6c5d3b><%=AddUtil.parseInt(e_bean.getA_b())/12%>�����</font></td>
                    <td align=right>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td align=right>&nbsp;</td>
                    <td><span class=style9></span></td>
                    <td><span class=style9></span></td>
					<%	if(tot_last_amt==0) tot_last_amt=1;
						if(e_bean.getA_b().equals("")) e_bean.setA_b("1");
						if(tot_last_amt==1) System.out.println("[m_case_flow]"+est_id);
					%>
                    <td align=right><font color=e60011><b><%= AddUtil.parseDecimal((long)d_tot_last_amt/(AddUtil.parseLong(e_bean.getA_b())+1)) %></b>&nbsp;</font></td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
        <td align=center>
            <table width=665 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=3 bgcolor=c3b696></td>
                </tr>
            </table>
        </td>
    </tr>            
	<tr>
	    <td height=10></td>
	</tr>
	<tr>
	    <td height=30 align=center>
	    	<table width=647 border=0 cellspacing=0 cellpadding=0>
	    		<tr>
	    			<td height=3></td>
	    		</tr>
	    		<tr>
	    			<td height=13 align=left>&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-size:14px; text-align:left; font-weight:bold; color:#2d5403;"><img src=/acar/main_car_hp/images/cashflow_dot.gif align=absmiddle> Cash Flow ���̿� ���� <%=AddUtil.parseInt(e_bean.getA_b())/12%>�Ⱓ �������� ȿ��</span> (�⸮ <span style="font-size:14px; font-weight:bold;"><%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO70"))*10000)/100f %>%</span> ����)</td>
	    		</tr>
	    	</table>
	    </td>
	</tr>
	<tr>
	    <td align=center>
	        <table width=635 border=0 cellspacing=0 cellpadding=0>
	            <tr>
	                <td><img src=/acar/main_car_hp/images/cashflow_up.gif></td>
	            </tr>
	            <tr>
	                <td bgcolor=f0f0f0>
	                    <table width=635 border=0 cellspacing=0 cellpadding=0 background=/acar/main_car_hp/images/cashflow_bg.gif>
	                        <tr>
	                            <td width=26 height=30></td>
	                            <td width=240><font color=585858><b><%= AddUtil.parseDecimal((long)d_tot_last_amt/(AddUtil.parseLong(e_bean.getA_b())+1)*-1) %> �� <%= Math.round(AddUtil.parseFloat((String)sh_comp.get("AO70"))*10000)/100f %>% �� <%=AddUtil.parseInt(e_bean.getA_b())/12%>(��) =</b></font></td>
	                            <td width=369 align=left>
	                                <table width=100 cellpadding=0 cellspacing=1 bgcolor=f13cbc>
	                                    <tr>
	                                        <td bgcolor=FFFFFF height=23 align=right><b><font color=585858><font color=f13cbc><%= AddUtil.parseDecimal(Math.round( (long)d_tot_last_amt/(AddUtil.parseLong(e_bean.getA_b())+1)*-1 * AddUtil.parseFloat((String)sh_comp.get("AO70")) * AddUtil.parseInt(e_bean.getA_b())/12 )) %> </font>��</font></b>&nbsp;</td>
	                                    </tr>
	                                </table>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
	                <td><img src=/acar/main_car_hp/images/cashflow_dw.gif></td>
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
</body>

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