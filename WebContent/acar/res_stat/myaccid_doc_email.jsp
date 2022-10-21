<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean"       scope="page"/>
<%
	String l_cd	 =	 request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id	 =	 request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String s_cd	 =	 request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id	 =	 request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String d_car_no = "";
	
	//���糯¥ FETCH
	Calendar cal = Calendar.getInstance(); 
    String curY = String.valueOf(cal.get(Calendar.YEAR));
    String curM = String.valueOf(cal.get(Calendar.MONTH)+1);	//Calendar Class�� Month�� +1.
    String curD = String.valueOf(cal.get(Calendar.DATE));
    if(Integer.parseInt(curM)<10){		curM = "0"+curM;	 }
    if(Integer.parseInt(curD)<10){		curD = "0"+curD;	 }
    
    //�̸��� �߼ۿ� �⺻���� FETCH
    //�ܱ�뿩���� ����
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//�����������
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(rc_bean.getSub_c_id());
%>

<html>
<head><title>�Ƹ���ī - ������ ���Ǽ� �ȳ��� �� ������</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script language='javascript'>
<!--
	function pagesetPrint(){
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
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=12;
// 		IEPageSetupX.rightMargin=12;
// 		IEPageSetupX.topMargin=20;
// 		IEPageSetupX.bottomMargin=20;
// 		print();
	}
	
function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=12;
	factory1.printing.rightMargin=12;
	factory1.printing.topMargin=20;
	factory1.printing.bottomMargin=20;
	factory1.printing.Print(true, window);
}
-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	 -->
<!-- 	<param name="copyright" value="http://isulnara.com"> -->
<!-- </OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >					
<!-- �������� �Ƿ� ���� -->					
<div class="a4">					
  <table width='640' height="" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="����">�ֽ�ȸ�� �Ƹ���ī</font></b>
		</td>
		<tr>
		<td height="25" align="center" style="font-size : 9pt;"><font face="����">��150-874 ����Ư���� �������� �ǻ���� 8, ������� 8�� 802ȣ (���ǵ���) ��ȭ:02)392-4243 �ѽ�:0505-361-9355</font>
		</td>
    </tr>
     <tr> 
      <td colspan="2" height="4" align="center" bgcolor=000000></td>
    </tr>
	<tr> 
      <td colspan="2" height="20" align="center"></td>
    </tr>
  
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="����">
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">�߽�����</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=curY%>�� <%=curM%>�� <%=curD%>��</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=rc_bean2.getCust_nm()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">(��)�Ƹ���ī ��ǥ ������</font></td>
          </tr>
		  <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">(�ѹ����� �̻� �Ⱥ��� ����� ������ 02-6263-6383)</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">���������Ƿ�</font></td>
          </tr>
        
        </table></td>
    </tr>
    <tr> 
      <td height="7" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="2" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" align='center'></td>
    </tr>  
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height="30" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. �ͻ��� ������ ������ ����մϴ�.</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                
                <tr>
                   <td height="30" style="font-size : 10pt;">
                   		<font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 
				   ���� <%if(!cr_bean.getCar_no().equals("")){%><%=cr_bean.getCar_no()%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%> ������ ���ػ��� ���Ͽ� ���� �ͻ翡�� ���������� ������ ��<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ֽ��ϴ�. ������� ��Ģ������ �ͻ簡 �������� ����翡 û���� �ϰ�, �̸� �����Ͽ�<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��翡 �����ϴ°��� ��Ģ�Դϴ�. �׷��� �������� ���ŷο��� ���̰��� ��簡 �ͻ縦<br> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����Ͽ� ���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �����Ḧ û���� ���Դϴ�.  </font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 
				   �׷��� �������� ����û���� �ٰŰ� �����ϴٰ� �Ͽ�, �ε����ϰ� �ͻ翡 ����������<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��û�ϰ� �Ǿ����ϴ�.</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 
				   ������ ä�� �絵 ������ �� �����忡 ���� �Ǵ� �����Ͻð�, ���� �Ǵ� FAX�� �߼��Ͽ�<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ֽñ� �ٶ��ϴ�.<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(�����ֽ� ������ ������ ��������� ���� ��, ��� �ٸ� �������� ������ ����
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ ��� �帳�ϴ�.)</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. 
				   ��Ÿ ���ǻ����� ��� ��ȭ��ȣ�� �����Ͽ� �ֽñ� �ٶ��ϴ�.</font></td>
                </tr>
				<tr>
	                <td height=20></td>
	            </tr>
                <tr>
                    <td height="30" align="right" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;<span class=style7 style="margin-right: 20px;">-��-</span></font></td>
                </tr>
	            <tr>
	                <td height=20></td>
	            </tr>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;<span class=style7></span></font></td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                </table>
            </td>
        </tr>
		
    </td>
</tr>

</table>

<table width='640' height="70" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height=50></td>
	</tr>
    <tr> 
      <td colspan="2"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="����"><b>�ֽ�ȸ�� 
        �Ƹ���ī ��ǥ�̻� ��&nbsp;&nbsp;��&nbsp;&nbsp;��</b></font><IMG src='../../images/cust/3c7kR522I6Sqs_70.gif' style="position: absolute;;margin-top: -15px;"></td>
    </tr>
	<tr>
		<td height=20></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
</table>
</div>

<!-- ä�� �絵 ������ �� ������ -->
<div class="a4">
	<table width=628 border=0 cellspacing=0 cellpadding=0>
		<tr> 
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
						<td colspan="2" height="60" align="center" style="font-size : 18pt;">
							<b><font face="����">ä�� �絵 ������ �� ������</font></b>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=30></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
						<td height="50" width="20%" style="font-size : 10pt;" align="center"><font face="����">����ó(ä����)</font></td>
						<td align="center" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ����</font></td>
					</tr>
				</table>
			</td>	
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">�߽�ó<br>(ä����)</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����/��ȣ</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><%if(!rc_bean2.getFirm_nm().equals("") && !rc_bean2.getEnp_no().equals("")){%>
					   		<font face="����">&nbsp;&nbsp;<%=rc_bean2.getFirm_nm()%>&nbsp;(<%=AddUtil.ChangeEnt_no(rc_bean2.getEnp_no())%>)</font></td><%}%>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�ּ�</font></td>
					   <td height="40" style="font-size : 10pt;"><%if(!rc_bean2.getZip().equals("") && !rc_bean2.getAddr().equals("") && !rc_bean2.getCust_nm().equals("")){%>
					   		<font face="����">&nbsp;&nbsp;(<%=rc_bean2.getZip()%>) <%=rc_bean2.getAddr()%>&nbsp;��ǥ�̻� :&nbsp;<%=rc_bean2.getCust_nm()%></font><%}%>
					   </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">ä����<br>����</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="����">�Ʒ� ��� ���� �����Ⱓ ������ ������(�����)</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�ݾ�</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;(\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">���<br>����</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">������ȣ</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="����"><%=cr_bean.getCar_no()%></font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�������</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="����"><%-- <%=AddUtil.ChangeDate2((String)ht.get("ACCID_DT"))%> --%></font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="����"><%=cr_bean.getCar_nm()%></font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�����Ⱓ</font></td>
					   <!--<td height="40" style="font-size : 10pt;" align="center"><font face="����"><%//=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT"))))%>~<%//=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%></font></td>-->
						<td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="����"><%-- <%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_ST")))%> --%>~<%-- <%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_ET")))%> --%></font></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">�絵��<br>����</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="����">(��)�Ƹ���ī���� ���� ������ ������ ������(�����) ä�� ������ <br>û�� �� ������ ���� �� �Ǹ�</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�ݾ�</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="����">�ϱ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;(\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=30></td>
		</tr>
		<tr>
		   <td height="20" style="font-size : 10pt; line-height:2;"><font face="����">��� ä���� ����(�Ʒ� �絵��)�� �Ʒ� ����� (��)�Ƹ���ī���� ��� ������(�����)ä���� û�� �� ������ ���� �� �Ǹ��� �������̰� Ȯ�������� �絵 �� �³��Ͽ����� �����մϴ�.</font></td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
			<td height="20" align="center" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;<span class=style7><%=curY%>.&nbsp;&nbsp;&nbsp;<%=curM%>.&nbsp;&nbsp;&nbsp;<%=curD%></span></font></td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">�絵��</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����</font></td>
					   <td height="40" style="font-size : 10pt;" align="right"><font face="����"> 
					   <%if(!rc_bean2.getCust_st().equals("����")){%>
					   <%=rc_bean2.getFirm_nm()%> <%if(rc_bean2.getCust_st().equals("����")){ %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>��ǥ�̻�:&nbsp;<%} %>
					   <%}%>
					   <%=rc_bean2.getCust_nm()%>&nbsp;(��)&nbsp;</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="����"><%if(   rc_bean2.getCust_st().equals("����")){%>�������<%}else{%>����ڵ�Ϲ�ȣ<%}%></font></td>
					   <td height="40" width="20%"style="font-size : 10pt;" align="center"><font face="����"><%if(   rc_bean2.getCust_st().equals("����")){%><%=AddUtil.subDataCut((rc_bean2.getSsn()+""),6)%><%}else{%><%=AddUtil.ChangeEnt_no(rc_bean2.getEnp_no())%><%}%></font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�ּ�</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" colspan="3"><%if(!rc_bean2.getZip().equals("")&& !rc_bean2.getAddr().equals("")){%>
					   		<font face="����">(<%=rc_bean2.getZip()%>) <%=rc_bean2.getAddr()%></font><%}%>
					   </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="����">�����</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">����</font></td>
					   <td height="40" style="font-size : 10pt;" align="right"><font face="����">�ֽ�ȸ�� �Ƹ���ī&nbsp;(��)<IMG src='../../images/cust/3c7kR522I6Sqs_70.gif' style="position: absolute;width:40px;height:40px;margin-top: -15px;margin-left: -30px;">&nbsp;</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="����">���ε�Ϲ�ȣ</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="����">115611-0019610</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="����">�ּ�</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" colspan="3"><font face="����">(150-874)����� �������� �ǻ���� 8 ������� 8��</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
		   <td height="20" style="font-size : 10pt; line-height:2;"><font face="����">�� �������� ���Ǻ�����Ǹ� �����̰�, �����δ��� ���� �����Դϴ�.</font></td>
		</tr>		
		<tr>
			<td height=10></td>
		</tr>
	</table>
</div>
<%-- 
 <% 	}
			} %> --%>

</form>
</body>
</html>
