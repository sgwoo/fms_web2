<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.forfeit_mng.*, acar.car_register.*, acar.offls_sui.*, acar.client.*,acar.common.*" %>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] car_mng_id = request.getParameterValues("pr");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	

%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>���ι߱޽�û</title>
<script language="JavaScript">
<!--
	function pagesetPrint(){
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=10;
// 		IEPageSetupX.rightMargin=10;
// 		IEPageSetupX.topMargin=25;
// 		IEPageSetupX.bottomMargin=25;		
// 		print();
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
	}
	
function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=10;
	factory1.printing.rightMargin=10;
	factory1.printing.topMargin=25;
	factory1.printing.bottomMargin=25;
	factory1.printing.Print(true, window);
}
//-->
</script>

<style type="text/css">
<!--

input.whitetext		{ text-align:left; font-size : 12pt; font-weight: bold; background-color:#ffffff; border-color:#000000; border-width:0; }
input.fix	 		{ text-align:left; font-size : 12pt; font-weight: bold; background-color:#CCCCCC; border-color:#000000; border-width:0; }


.style16 {
	font-size: 16px;
	font-weight: bold;
}

.style11 {
	font-size: 12px;
}

.style12 {
	font-size: 10pt;
}
-->
</style>
</head>
<body leftmargin="15" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<table width=920 border=0 cellspacing=0 cellpadding=0>   
  <tr>
    <td width="100" height="30" valign="middle"><div class="style16">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :</div></td>
    <td width="820" height="30" valign="middle"><input type="text" name="cust" value="��籸û" class="fix" size="70" ></td>
  </tr>
  <tr>
    <td height="30" valign="middle"><div class="style16">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :</div></td>
    <td height="30" valign="middle"><div class="style16">(��)�Ƹ���ī</div></td>
  </tr>
  <tr >
    <td height="30" valign="middle"><div class="style16">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :</div></td>
    <td height="30" valign="middle"><input type="text" name="cont" value="���ó�������Դϴ�. �����ں���� ������ ���ι߱�(����������)" class="fix" size="70"></td>
  </tr>
  <tr>
    <td height="30" valign="middle"><div class="style16">��뺻���� :</div></td>
    <td height="30" valign="middle"><div class="style16">����� �������� �ǻ���� 8 802(���ǵ���, ��ȯ��º���)</div></td>
  </tr>
  <tr>
    <td height="30" valign="middle">&nbsp;</td>
    <td height="30" valign="middle"><div class="style16">��⵵ ��õ�� ���θ� â���� 1471</div></td>
  </tr>	
  <tr>
    <td height="30" valign="middle">&nbsp;</td>
    <td height="30" valign="middle"><div class="style16">��õ������ ��籸 ������ 71, ��-712(��굿, ���̺���)</div></td>
  </tr>	
</table>
<br>
<table width=920 border=1 cellspacing=0 cellpadding=0>   
  <tr>
    <td>
	  <table width=100% border=0 cellspacing=10 cellpadding=0>   
<%	for(int i=0; i<car_mng_id.length; i++){

			String r_car_mng_id = car_mng_id[i];
			
			if(r_car_mng_id.length() > 6)	r_car_mng_id = r_car_mng_id.substring(0,6);
			
			CarRegBean cr_bean = crd.getCarRegBean(r_car_mng_id);
			sBean = olsD.getSui(r_car_mng_id);
			//���޹޴���
			ClientBean client = al_db.getClient(sBean.getClient_id());
		%>
        <tr>
          <td valign="middle" width="8%"><div class="style12"><%=cr_bean.getCar_no()%></div></td>
          <td valign="middle" width="10%"><div class="style11"><%=cr_bean.getCar_nm()%></div></td>
          <td valign="middle" width="15%"><div class="style12"><%=cr_bean.getCar_num()%></div></td>	
          <td valign="middle" width="25%"><div class="style12"><%=client.getFirm_nm()%></div></td>			  
          <td valign="middle" width="38%"><div class="style12"><%=sBean.getD_addr()%></div></td>			  		  
		  <td valign="middle" width="4%"><div class="style11"><%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%></div></td>
        </tr>
<%	}%>  
      </table>  
	</td>
  </tr>
</table>    
</body>
</html>
