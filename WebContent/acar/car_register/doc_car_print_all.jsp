<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.master_car.*, acar.car_register.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	
	//String ch_cd 	= request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	
	//ch_cd=AddUtil.substring(ch_cd, ch_cd.length() -1);
	
	String vid[] = request.getParameterValues("ch_cd");
	
	String c_id = "";
	
	int vt_size = vid.length;

	for(int i=0;i < vt_size;i++){

	c_id = vid[i];
	
	c_id = c_id.substring(0,6);
	
	//��������
	Hashtable  h_bean = mc_db.getCarReqMaintInfo(c_id);
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title> �ڵ��� �˻� ��û��</title>
<style>
@page a4sheet { size: 21.0cm 29.7cm }
.a4 { page: a4sheet; page-break-after: always; margin:0; }
</style>
<STYLE>
<!--
* {line-height:120%; font-size:10pt; font-family:����;}

.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:13pt; line-height:180%; font-weight:bold;}
.f3{font-size:8.5pt;}
.f4{font-size:11pt;}

.t1 table{border-top:1px solid #000000; border-bottom:1px solid #000000;}
.t1 table td{border-right:1px solid #000000;}
.t1 table td.n1{border-right:0px;}
.t1 table td.n1 table{border:0px;}
.t1 table td.n1 table td{border-right:0px;}

.t2 table{border-top:2px solid #000000; border-bottom:1px solid #000000;}
.t2 table td{border-left:1px solid #000000; border-bottom:1px solid #000000;}
.t2 table td.n1{border-left:0px;}

.t3 table {border:0px;}
.t3 table td {border:0px;}
.t3 table td.n1 {border-right:0px;}

.t4 {border:0px;}

@media print {
	html, body {
		width: 210mm;
		height: 297mm;  
		margin:0;
		padding:0;      
	}
-->
</STYLE>	
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// ��Ű ��������
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>

<!-- <SCRIPT>
	function Installed(){
		try{	return (new ActiveXObject('IEPageSetupX.IEPageSetup'));	}
		catch (e){	return false;	}
	}

	function PrintTest(){
		if (!Installed()){
			alert("��Ʈ���� ��ġ���� �ʾҽ��ϴ�. ���������� �μ���� ���� �� �ֽ��ϴ�.")
			return false;
		}else{
			alert("���������� ��ġ�Ǿ����ϴ�.");
			alert("�⺻����Ʈ : "+IEPageSetupX.GetDefaultPrinter());
		}	
	}
</SCRIPT> -->
<!-- <SCRIPT language="JavaScript" for="IEPageSetupX" event="OnError(ErrCode, ErrMsg)">
	alert('���� �ڵ�: ' + ErrCode + "\n���� �޽���: " + ErrMsg);
</SCRIPT> -->
</head>
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="./IEPageSetupX.cab#version=1,4,0,3" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
	<div style="position:absolute;top:276;left:320;width:300;height:68;border:solid 1 #99B3A0;background:#D8D7C4;overflow:hidden;z-index:1;visibility:visible;"><FONT style='font-family: "����", "Verdana"; font-size: 9pt; font-style: normal;'>
	<BR>  �μ� �������� ��Ʈ���� ��ġ���� �ʾҽ��ϴ�.   <BR>  <a href="https://www.amazoncar.co.kr/home/IEPageSetupX.exe"><font color=red>�̰�</font></a>�� Ŭ���Ͽ� �������� ��ġ�Ͻñ� �ٶ��ϴ�.  </FONT>	</div>
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()">
<div class="a4">
<table width="750" border="0" cellspacing="2" cellpadding="0" >
	<tr>
		<td>	
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=10 class="f3">[���� ��47ȣ����] <���� 2017. 2. 14.></td>
				</tr>
				<tr>
					<td align=center><span class=f1>�ڵ��� �˻� ��û��</span></td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
			        <td class="t1">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr bgcolor="#eeeeee">
				                <td width=34% height=45 valign=top>&nbsp;������ȣ</td>
					           	<td width=33% valign=top>&nbsp;������</td>
					           	<td width=33% valign=top class=n1>&nbsp;ó���Ⱓ ���</td>
					     	</tr>	
					     </table>
					 </td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">��û��</span></td>
								<td width="200" height=30>&nbsp;&nbsp;����(��Ī)</td>
								<td width="400" class="n1">&nbsp;&nbsp;(��) �Ƹ���ī</td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;������϶Ǵ� ����� ��Ϲ�ȣ</td>
								<td class="n1">&nbsp;&nbsp;115611-******* (128-81-47957)</td>
				            </tr>
							<tr>
								<td height=30>&nbsp;&nbsp;�� ��</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("BR_ADDR")%></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;��ȭ��ȣ</td>
							    <td class="n1">&nbsp;&nbsp;02-392-4242</td>
						    </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">�ڵ���</span></td>
								<td width="200" height=30>&nbsp;&nbsp;����</td>
								<td width="400" class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NM")%></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;����</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_FORM")%></td>
				            </tr>
							<tr>
								<td height=30>&nbsp;&nbsp;��Ϲ�ȣ</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NO")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center class="n1"><span class="f4">�˻籸��</span></td>
								<td width="250" height=50>&nbsp;&nbsp;[ &nbsp; ] Ʃ�װ˻�&nbsp;&nbsp;[ �� ] �ӽð˻�</td>
								<td width="350" class=n1>&nbsp;&nbsp;[ &nbsp; ] �����˻�<br><div class="f3">&nbsp;&nbsp;(���� ó�� ����: [ ]ħ��  [ ]���  [ ]�������н� [ ] ��Ÿ)</div></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td>���ڵ����������� ��43����1��, ���� �� �����Ģ ��78��, ��79�� �� ��79����2�� ���� ���� ���� ��û�մϴ�.</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
				<!--	<td align=right><%=AddUtil.getDate(1)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;</td> -->
					<td align=right>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û�� &nbsp;&nbsp;&nbsp;(��)�Ƹ���ī</td>
				</tr>
					<td align=right><span class="f3">(���� �Ǵ� ��)</span> &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td><span class=f2>&nbsp;�ڵ����˻������</span> ����</td>
				</tr>
				<tr>
					<td height=3 bgcolor="#000000"></td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
			        <td class="t2">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr>
								<td colspan="2" class="n1" width=100>
									<p style="text-align: center;" class="n1" class="f3">÷�μ���<br></p>
								</td>
								<td width=100>
									<p style="text-align: center;" class="f3">������<br></p>
								</td>
							</tr>
							<tr>
								<td class="n1"  width=100>
									<p style="text-align: center;"  class="f3">Ʃ�װ˻�<br></p>
								</td>
								<td>
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. Ʃ�׽��μ�</p>
									<p class="f3">&nbsp;3. Ʃ�� ������ �ֿ��������ǥ</p>
									<p class="f3">&nbsp;4. Ʃ�� �������� �ڵ����ܰ���(�ܰ��� ������ �ִ� ��쿡�� �����մϴ�)</p>
									<p class="f3">&nbsp;5. Ʃ���Ϸ��� ��������ġ�� ���赵</p>
									<p class="f3"></p>
								</td>
								<td rowspan="3" scope="">
									<p class="f3"><br>&nbsp;�˻�����ڰ� ���� �ݾ�</p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">�ӽð˻�<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. �ڵ������ˤ�������˻� �Ǵ� ���󺹱���ɼ�</p>
									<p class="f3"></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">�����˻�<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. �ڵ���������ڰ� �߱��� ���� ��89ȣ��2������ ���ˤ��������(���� ó���� ������  <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ ���� ���ˤ���������� ���մϴ�)</p>
									<p class="f3">&nbsp;3. �ڵ��������� �����Ģ�� ��79����2��3ȣ�� ���� ����</p>
									<p class="f3">&nbsp;4. �ڵ����˻�����ڰ� ������ �䱸�ϴ� ���� �� ���� ����</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. ����ȸ�簡 �߱��� ���� ó���� ���� Ȯ�μ�(�������, ������ �� ���� �Ǵ� �ļ���<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;�� ������ ��ġ�� ��Ī�� ����� ���� ���մϴ�)</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. �پ���θ�Ʈ ���� ���</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. �ջ�� ���� �Ǵ� ��ġ�� ���� ���� �� ����</p>
									<p class="f3"></p>
								</td>
							</tr>
					     </table>
					 </td>
				</tr>
				<tr>
					<td colspan="3" align="right" class="f3"><br>210����297��[�Ϲݿ��� 60g/��]</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div id="Layer1" style="position:absolute; margin-top: -590px; margin-left: 600px; z-index:1;"><img src="/acar/images/square_stamp_S.png" width="100" height="100"></div>
</div>

<!-- �ڵ�������� �߰�(20191004) -->
<jsp:include page="doc_car_print_car_reg.jsp" flush="true">
	<jsp:param name="c_id" value="<%=c_id%>"/>
</jsp:include>


</body>
<%}%>
</html>
<script>

//onprint();

function onprint(){
// 	var vid_size = '1';
// 									//~IE10									  //IE8~IE11		
// 	if( navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("Trident") > 0){
// 		IEPageSetupX.header='';				//��������� �μ�
// 		IEPageSetupX.footer='';				//�������ϴ� �μ�
// 		//IEPageSetupX.Orientation = 1;		//1-�����μ�, 2-�����μ�
// 		IEPageSetupX.leftMargin=10.0;		//��������
// 		IEPageSetupX.rightMargin=10.0;		//��������
// 		IEPageSetupX.topMargin=0;		//��ܿ���
// 		IEPageSetupX.bottomMargin=0;		//�ϴܿ���
// 		IEPageSetupX.PaperSize = 'A4';		//�μ��������
// 		IEPageSetupX.PrintBackground = 1;	//���� �� �̹��� �μ� ���� ����
// 		if(vid_size == 1)			IEPageSetupX.Print();
// 		else 						IEPageSetupX.Print(true);	//�μ� ��ȭ����ǥ�ÿ���(true-ǥ�� , ����/false- ǥ�þ���(�ٷ� �μ�))
// 		//IEPageSetupX.Print(true);			//�μ� ��ȭ����ǥ�ÿ���(true-ǥ�� , ����/false- ǥ�þ���(�ٷ� �μ�))
		
// 		//IEPageSetupX.Print();			//�μ� ��ȭ����ǥ�ÿ���(true-ǥ�� , ����/false- ǥ�þ���(�ٷ� �μ�))
	
// 		/* factory.printing.header 	= ""; //��������� �μ�
// 		factory.printing.footer 	= ""; //�������ϴ� �μ�
// 		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
// 		factory.printing.leftMargin 	= 10.0; //��������   
// 		factory.printing.rightMargin 	= 10.0; //��������
// 		factory.printing.topMargin 		= 10.0; //��ܿ���    
// 		factory.printing.bottomMargin 	= 10.0; //�ϴܿ��� */
// 	}else{	
// 		window.print();
// 	}

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
	factory1.printing.topMargin=20;
	factory1.printing.bottomMargin=20;
	factory1.printing.Print(true, window);
}

// function onprint_box(){
// 	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
// }

</script>
