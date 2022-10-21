<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String vid[] = request.getParameterValues("ch3_cd");
	String rent_l_cd = "";
	String rent_mng_id ="";
	String doc_id ="";
	String vid_num="";
	
	int vt_size = vid.length;
		
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<STYLE>
<!--
body {text-align:center;}
table { border-collapse:collapse; }
table td{ border:1px solid #000000;}

-->
</STYLE>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=20;	
		print();
	
	}
	
function onprint(){
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

function IE_Print() {
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 12.0; //��������   
factory.printing.topMargin = 12.0; //��ܿ���    
factory.printing.rightMargin = 20.0; //��������
factory.printing.bottomMargin = 10.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
//-->
</script>

</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<%
int count = 0;
for(int i=0;i < vt_size;i++){								
	vid_num = vid[i];								
	rent_l_cd = vid_num.substring(0,13);
	rent_mng_id = vid_num.substring(13,19);
	doc_id = vid_num.substring(19);								
	Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
	count ++;
%>
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='br_id' 		value='<%=br_id%>'>  
<%
} 
%>

<!-- ����� ���� ��� ��û�� -->  
<div class="a4">
<table>
	<tr>
		<td colspan="5" height="20" valign="middle" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
			<span STYLE='font-size:11.0pt;font-family:"����";line-height:130%;'>[���� ��4ȣ ����] &lt;���� 2010.1.11&gt;</span>
		</td>
	</tr>
	<tr>
		<td style="border:none;">
			<table cellspacing="0" cellpadding="0"  width="650" style="border:1px solid #000000;">				
				<tr>
					<td rowspan="2" colspan="4" height="69" align="center" valign="middle" style='border:1px solid #000000; padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:16.0pt;font-family:"����";font-weight:"bold";line-height:160%;'>����� ���ҵ�� ��û��</span>
					</td>
					<td width="110" height="25" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>ó���Ⱓ</span>
					</td>
				</tr>
				<tr>
					<td height="44" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:11.0pt;font-family:"����";line-height:100%;'>���(�װ���<br>�� ��� 7��)</span>
					</td>
				</tr>
				<TR>
					<TD colspan="2" height="49" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�� �ڵ���&nbsp;&nbsp;&nbsp;&nbsp; �� �Ǽ����</SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�� �װ���&nbsp;&nbsp;&nbsp;&nbsp; �� ��������</SPAN>
					</TD>
					<TD width="110" height="49" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>��Ϲ�ȣ<br>(��ϱ�ȣ)</SPAN>
					</TD>
					<TD  height="49" width="205" valign="middle" style='border-left:solid #000000 1px;border-right:none;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<%
						for(int i=0;i < 1;i++){								
							vid_num = vid[i];								
							rent_l_cd = vid_num.substring(0,13);
							rent_mng_id = vid_num.substring(13,19);
							doc_id = vid_num.substring(19);								
							Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
						%>
						<SPAN STYLE='font-size:15.0pt;font-family:"����";line-height:160%;'><%=ht.get("CAR_NO")%> �� <%=count-1%>��</SPAN>						
					</TD>						
					<TD  height="49"  valign="middle" style='border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:2.8pt 5.7pt 2.8pt 5.7pt'>&nbsp;
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" width="85" height="60" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�������</SPAN>
					</TD>
					<TD width="140"  valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";'>�ּ�</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:140%;'>
							<% if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("������������")){%>
								<!--	135-864	-->����Ư���� ������ ������ 652 (�Ｚ�� 9-1,������������)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�������")){%>
								<!--	135-894	-->����Ư���� ������ �Ż絿 611 �߻���� 1�� ������� �б�������
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("��������")){%>
								<!--	150-748	-->����Ư���� �������� ��ȸ���70�� 18 (���ǵ���, �Ѿ���� 1��)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("NH��������")){%>
								<!--	121-807	-->����Ư���� ������ ���굿 106-5 ���̺�Ÿ�� 4��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ѱ���Ƽ����")){%>
								<!--	137-881	-->����Ư���� ���ʱ� ���ʴ�� 324 (���ʵ� 1675-1,��������)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�����������")){%>
								<!--	138-908	-->����Ư���� ���ı� �ø��ȷ� 119 ������ξ��û� 3�� ��3A 11ȣ
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�λ�����")){%>
								<!--	137-070	-->����Ư���� ���ʱ� ���ʵ� 1357-35  
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("��������")){%>
								<!--	110-752	-->����Ư���� ���α� û��õ�� 41 ��ǳ���� 2��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ϳ���������")){%>
								<!--	110-855	-->����Ư���� ���α�  ���� 293 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("OK��������")){%>
								<!--	100-743	-->����Ư���� �߱� ������� 39 ���Ѽ�����ȸ�Ǽ� 10��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ﱹ��ȣ��������")){%>
								<!--	611-839	-->�λ걤���� ������ �߾Ӵ�� 1076 (���굿 703-1)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ѱ���Ƽ����")){%>
								<!--	150-034	-->����Ư���� �������� ��������4�� 147-1, ȫ�ͺ���1��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ϳ�����")){%>
								<!--	135-884	-->����Ư���� ������ ������ 713 (���뺥ó�� 1��)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("pepper��������")||c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("������������")){%>
								<!--	463-824	-->��⵵ ������ �д籸  �д�� 55, 13F(������)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�뱸����")){%>
								<!--	100-070	-->����Ư���� �߱� ������2�� 6���� ���ܺ��� 2��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�츮����")){%>
								<!--	150-882	-->����Ư���� �������� ���ǵ��� 30-3
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("��������")){%>
								<!--	137-070	-->����Ư���� ���ʱ� ���ʵ� 1337-20 �븢����Ÿ�� 2�� 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�������")){%>
								<!--	150-740	-->����Ư���� �������� ���ǵ��� ����� 30 �߼ұ���߾�ȸ���� 1��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("��ȯ����")){%>
								<!--	150-879	-->����Ư���� �������� ���ǵ��� 26-5 ������� 3��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("HK��������")){%>
								<!--	135-010	-->����Ư���� ������ ������ 199-2 2��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("������������")){%>
								<!--	467-808	-->��⵵ ��õ��  �߸�õ�� 50 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("SBI4��������")){%>
								<!--	135-090	-->����Ư���� ������ �Ｚ�� 143-30 SBIŸ�� 5�� 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("�ѱ���Ƽ����")){%>
								<!--	150-034	-->����Ư���� �������� �������� 4�� 147-1 ȫ�ͺ��� 1��
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("SC��������")){%>
								<!--	150-716	-->����Ư���� ��������  ���������� 56 ������Ǻ��� (���ǵ���)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("��������")){%>
								<!--	150-890	-->����Ư���� ��������  �ǻ����1�� 34 �ο����� 3��
								<%}%>
							<%-- <%}%> --%>
						</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";letter-spacing:-1.2pt;line-height:160%;'>���� �Ǵ� ��Ī</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'><%=c_db.getNameById((String)ht.get("GOV_ID"), "BANK")%></SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="2"  height="44"  valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";letter-spacing:0.5pt;line-height:160%;'>&nbsp; �� ä�Ǿ� &nbsp;&nbsp;�� ä���ְ��</SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp; �� �㺸����</SPAN>
					</TD>
					<TD colspan="3" height="44" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:15.0pt;font-family:"����";line-height:160%;'><%-- <%=Util.parseDecimal(ht.get("AMT6"))%> --%>���� ÷�� Ȯ��</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" height="55" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";letter-spacing:-2.0pt;line-height:160%;'>ä����</SPAN>
					</TD>
					<TD height="30" valign="middle" align="center"  style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�ּ�</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>����� �������� �ǻ���� 8, 802ȣ</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";letter-spacing:-1.2pt;line-height:160%;'>���� �Ǵ� ��Ī</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>(��)�Ƹ���ī</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" height="61" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�����<br>������</SPAN>
					</TD>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�ּ�</SPAN>
					</TD>
					<TD colspan="4" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>����� �������� �ǻ���� 8, 802ȣ</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="31" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";letter-spacing:-1.1pt;line-height:160%;'>���� �Ǵ� ��Ī</SPAN>
					</TD>
					<TD colspan="3" height="31" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>(��)�Ƹ���ī</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="2" height="30" valign="middle"align="center"  style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>���� ����</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="5" height="188" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;���ڵ��� �� Ư������ ������� ��5�� �� ���� �� ����� ��6���� ���� ���� ���� <br>&nbsp;&nbsp;&nbsp; ����� ���ҵ���� ��û�մϴ�. </SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%; text-align:right;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� 
						</SPAN><br><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û��:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN>
						<SPAN STYLE='font-family:"����";'>(���� �Ǵ� ��)</SPAN><br><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" colspan="4" height="140" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"����";font-weight:"bold";line-height:160%;'>�� ���񼭷�</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;line-height:160%;'>1. ���ҵ���� ������ �����ϴ� ���� �� ��������� �ΰ�����(�ڵ��������<br>&nbsp;&nbsp;&nbsp; �� ��� ������ڰ� �����̰� ����� ����ΰ��踦 ��ϰ�û�� ������Ȯ�� <br>&nbsp;&nbsp;&nbsp; �Ҽ� �������� �����մϴ�)</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>2. ��3���� �³����� �׿� ������ �� �ִ� �ǰṮ �(������� ���ҵ�Ͽ� <br>&nbsp;&nbsp;&nbsp; ���ذ��踦 ���� ��3�ڰ� �ִ� ��쿡�� �����մϴ�)</SPAN>
					</TD>
					<TD height="27" valign="middle" align="center" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>������</SPAN>
					</TD>
				</TR>
				<TR>
					<TD  height="112" valign="middle" align="center" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:130%;'>�����<br>��10��<br>����</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="5" height="119" valign="middle" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:none;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>3.���λ�Ҽ۹����� ���� �����ְ������� ���� �����ǰ��� ���� ��쿡�� �� � �Ǵ�<br>&nbsp;&nbsp;&nbsp; ����Ź������ ���� ��Ź�� �� ���� ��Ź��, ä������ �� ä�����࿡ ���� ������(�����<br>
						&nbsp;&nbsp;&nbsp; ���� �ּҰ� �и����� �ʾ� ����Ǽ����ڰ� �ܵ����� ����Ǹ��ҵ���� ��û�� ��쿡��<br>&nbsp;&nbsp;&nbsp; �����մϴ�)</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;font-family:"����";letter-spacing:0.6pt;line-height:160%;'>4. ���������� �����ϴ� ����(ä���ڰ� ä���ڸ� �����Ͽ� ��Ͻ�û�ϴ� ��쿡��<br>&nbsp;&nbsp;&nbsp; �����մϴ�)</SPAN>
					</TD>
				</TR>			
			</TABLE>
		</td>
	</tr>
	<TR>
		<TD colspan="5" height="29" align="right" valign="middle" style='border:none;padding:1.0pt 5.7pt 1.0pt 5.7pt'>
			<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>210mm��297mm[�Ϲݿ��� 60g/��(��Ȱ��ǰ)]</SPAN>
		</TD>
	</TR>
</table>
</div>
<%}%>

<!-- ��������  -->
<div class="a4">
<table width="650">
	<tr>
		<td valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
			<span STYLE='font-size:26.0pt;font-family:"����";font-weight:"bold";line-height:180%;'>�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</span>
		</td>
	</tr>
	<tr>
		<td height=1 bgcolor="#000000;"></td>
	</tr>
	<tr>
		<td style='border:none; padding:2.8pt 5.7pt 2.8pt 5.7pt;'> <br><br><br>
			<span style='font-size:13.0pt;font-family:"����";line-height:250%;'> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				���� �ڵ��� ������� ������࿡ ���Ͽ� &nbsp;&nbsp;&nbsp;&nbsp; 
			<%
			for(int i=0;i < 1;i++){								
				vid_num = vid[i];								
				rent_l_cd = vid_num.substring(0,13);
				rent_mng_id = vid_num.substring(13,19);
				doc_id = vid_num.substring(19);								
				Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
			%>
			<br>&nbsp;<b><%=c_db.getNameById((String)ht.get("GOV_ID"), "BANK")%></b> 
			<%}%>
			&nbsp; ��(��) �Ʒ� ����� ���� ó�� ��ϵ� ������ ���Ͽ� <br>��������� �����ϰ� ����� ���Ͽ��� �� �ݹ� ä�Ǻ����� ���Ͽ� �̸� �����Ѵ�.</span>
			  <!-- ���� �߰� ���� -->   
			<!-- <div STYLE='font-size:13.0pt;font-family:"����";line-height:250%;'>(��� ������ �ϴ� ����� ùȣ�� �ش�. �� �� ���� ��������� ���� ÷�� Ȯ�� )</div> -->    
			<br><br><br>
		</td>
	</tr>	
	<tr>
		<td style="border:none;">
			<TABLE cellspacing="0" cellpadding="0"  width="650">
			<colgroup>
				<col width="5%">
				<col width="20%">
				<col width="11%">
				<col width="25%">
				<col width="18%">
				<col width="10%">
				<col width="11%">
			</colgroup>
			<tr>
				<td align="center" colspan="7"><SPAN STYLE='font-size:13.0pt;font-family:"����";line-height:250%;'><b>������� ���� ���� ���� ���</b></SPAN></td>
			</tr>
			<TR bgcolor="#CCCCCC" >
				<TD height="39" align="center" valign="middle" >
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>No.</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>�� ��</SPAN>
				</TD>
				<TD height="39" align="center" valign="middle" >
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>������ȣ</SPAN>
				</TD>				
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>���ι�ȣ</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>ä�ǰ���</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>�����ȣ</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>��뺻����</SPAN>
				</TD>
			</TR>
			<% 
				for(int i=0;i < vt_size; i++){						
					vid_num = vid[i];								
					rent_l_cd = vid_num.substring(0,13);
					rent_mng_id = vid_num.substring(13,19);
					doc_id = vid_num.substring(19);								
					Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
					String carFullNum = (String)ht.get("CAR_NUM");
					String carNum = "";					
					if(carFullNum != null && carFullNum != ""){
						carNum = carFullNum.substring(11);
					} 
					
			%>
			<TR>
				<TD height="39" align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'><%=i+1%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'><%=ht.get("CAR_NM")%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'><%=ht.get("CAR_NO")%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
				</TD>
				<TD valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>
						<div align="left" style="float: left;">&nbsp;\</div> 
						<div align="right"><%=Util.parseDecimal(ht.get("AMT6"))%>&nbsp;</div>						
					</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'><%=carNum%><%-- <%=ht.get("CAR_NUM")%> --%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'></SPAN>
				</TD>
			</TR>
			<%}%>
		  </TABLE>
		</td>
	</tr>
	<TR>
		<TD colspan="5" height="29" align="center" style='border:none;'><br><br><br>
			<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>201 &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<br><br><br>
			��������� : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</SPAN>
		</TD>
	</TR>
</table>
</div>

<!-- ������ -->
<div class="a4">
<table width="650">
	<TR>
		<TD valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="3">
			<SPAN STYLE='font-size:28.0pt;font-family:"����";font-weight:"bold";line-height:180%;'>�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</SPAN>
		</TD>
	</TR>
	<tr>
		<td height=1 bgcolor="#000000;" colspan="3"></td>
	</tr>
	<tr>
		<td height=60 style='border:none;'></td>
	</tr>
	<tr>
		<td width="80" align="center" rowspan="3" valign="top" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt;'><SPAN STYLE='font-size:13.0pt;font-family:"����";line-height:160%;'>������<br>(�븮��)</span></td>
		<td width="120" align="right" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>�ֹε�Ϲ�ȣ :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td colspan="3" style='border:none; padding:2.8pt 5.7pt 2.8pt 5.7pt;'> <br><br><SPAN STYLE='font-size:14.0pt;font-family:"����";line-height:240%;'>����ο��� �Ʒ� ��Ͽ� ����� �ڵ����� ������� ���� ��Ͻ�û�� ���Ͽ� 
		��ü�� ������ �����մϴ�.</span></td>
	</tr>
	<TR>
		<TD  colspan="3" height="29" align="center" style='border:none;'><br><br>
			<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:140%;'>201&nbsp;&nbsp;&nbsp;&nbsp; �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</SPAN><br><br><br><br>
		</TD>
	</TR>
	<tr>
		<td width="100" align="center" rowspan="2" valign="top" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt;'><SPAN STYLE='font-size:13.0pt;font-family:"����";line-height:160%;'>ä���� ��<br>���������</span></td>
		<td width="120" align="right" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� : </span></td>
		<td width="420"  style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>��&nbsp;&nbsp;&nbsp;��(��ȣ) :</span></td>
		<td width="420" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td style="border:none;" colspan="3"><br><br><br><br>
			<TABLE cellspacing="0" cellpadding="0"  width="650">
				<TR bgcolor="#CCCCCC" >
					<TD height="39" align="center" valign="middle" >
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�ڵ�����Ϲ�ȣ</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�ڵ�����</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>����</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�����ȣ</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>�������ȣ</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>��뺻����</SPAN>
					</TD>
				</TR>
				<TR>						
					<TD height="39" align="center" valign="middle" colspan="6">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>���� ÷�� Ȯ��</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
		  </TABLE>
		</td>
	</tr>
</table>
</div>

<!-- ���� -->
<div class="a4">
<table width="650">
	<TR>
		<TD valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="4">
			<SPAN STYLE='font-size:20.0pt;font-family:"����";font-weight:"bold";line-height:180%;'>&lt; �� &nbsp;&nbsp;�� &gt;</SPAN>
			<br><br>
		</TD>
	</TR>
	<tr>
		<td valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="4">
			<span STYLE='font-size:16.0pt;font-family:"����";font-weight:"bold";line-height:180%;'>* ���� ���� ���� : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		</td>	
	</tr>
	<tr bgcolor="#CCCCCC" >
		<td height="32" align="center" valign="middle" >
			<span STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>����</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>������ȣ</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>����</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"����";line-height:160%;'>ä�ǰ���</span>
		</td>						
	</tr>
	<% 
		int countNum = 0;
		for(int i=0;i < vt_size;i++){								
			vid_num = vid[i];								
			rent_l_cd = vid_num.substring(0,13);
			rent_mng_id = vid_num.substring(13,19);
			doc_id = vid_num.substring(19);								
			Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
			countNum++;
	%>
	<tr>
		<td height="32" align="center" valign="middle" >
			<span style='font-size:12.0pt;font-family:"����";line-height:160%;'><%=countNum%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"����";line-height:160%;'><%=ht.get("CAR_NO")%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"����";line-height:160%;'><%=ht.get("CAR_NM")%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"����";line-height:160%;'>
				<div align="left" style="float: left;">&nbsp;\</div>
				<div align="right"><%=Util.parseDecimal(ht.get("AMT6"))%>&nbsp;</div>
			</span>
		</td>						
	</tr>
	<%}%>
</table>
</div>
</form>
</body>
</html>
