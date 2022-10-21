<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
 	InsDatabase ins_db = InsDatabase.getInstance();
	
	
	String rent_l_cd = request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id");
	String car_mng_id = request.getParameter("car_mng_id");
	String ins_st = request.getParameter("ins_st");
	

	Hashtable info = ins_db.getinsUShPrintInfo(rent_mng_id, rent_l_cd, car_mng_id, ins_st);
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);	
@import url(http://fonts.googleapis.com/earlyaccess/nanummyeongjo.css);
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
   /*  font-family: "���� ���", Malgun Gothic, "����", gulim,"����", dotum, arial, helvetica, sans-serif; */
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 2px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 1px solid #444444;
    font-weight:bold;
    font-size:9pt;
    text-align:center;
  }
  input {border:0px;font-size:11pt;font-family: 'Nanum Gothic',sans-serif;}
.title{text-align:center;background-color: #e2e7ff;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}

#wrap{ font-family: 'Nanum Gothic',sans-serif; vertical-align: middle;}
	
</style>
</head>
<body leftmargin="15" topmargin="1" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div style="float:left;width:30%">
				<div style="text-align:left;margin-bottom:15px;margin-top:30px;font-size:26pt;font-weight:bold;">
					AMAZONCAR
				</div>
				<div style="text-align:left;font-size:13pt;margin-bottom:10px;font-weight:bold;">�뵵�����û��</div>
			</div>
			<div style="float:left;width:70%">
				<div style="font-size:10pt;text-align:right;margin-top:60px;font-family:Nanum Myeongjo,serif;font-weight:bold;">
					07236 ����Ư���� �������� �ǻ���� 8(������� 802ȣ)<br> T)02-392-4243 F)02-757-0803<br> Ȩ������) http://www.amazoncar.co.kr
				</div>	 
			</div>
			<div style="clear:both;"></div>
			<br><hr>
			<div style="text-align:left;font-size:11pt;font-weight:normal;">
				<div>�� 07236 ����Ư���� �������� �ǻ���� 8 , 802ȣ</div>
				<div>TEL 02)6263-6372 FAX 02)6944-8451<span style="margin:10px;"></span> ��� ���� 34000233@amazoncar.co.kr</div>
			</div>
			<hr>
			<div style="text-align:left;font-size:11pt;font-weight:normal;">
				<div>&nbsp;������ȣ &nbsp;:&nbsp;&nbsp; <%=info.get("YEAR")%>-<%=info.get("MONTH")%><%=info.get("DAY")%><input type="text" value="" style="width:20px;"></div>
				<div>&nbsp;�߽Ź�ȣ &nbsp;:&nbsp;&nbsp; <%=info.get("YEAR")%>�� <%=info.get("MONTH")%>�� <%=info.get("DAY")%>��</div>
				<div>&nbsp;��<span style="margin:15px;"></span>�� &nbsp;:&nbsp;&nbsp; <input type="text" value="" style="width:200px;"></div>
				<div>&nbsp;��<span style="margin:15px;"></span>�� &nbsp;:&nbsp;&nbsp; <%=info.get("CAR_NO") %> �뵵���� </div>
			</div>			
			<hr>
			<div style="text-align:left;font-size:11pt;font-weight:normal;margin-left:30px;">
				<div>1. �ͻ��� ���� ��â�Ͻ��� ����մϴ�.</div>
				<div>2. <%=info.get("CAR_NO")%>������ �ڵ����� ������ �ڵ����� �뵵�� �����ϰ��� �Ͽ��� <br><span style="margin:10px;"></span>�ɻ� ���� ��Ź�帳�ϴ�.</div>
			</div>
			<br><br><br>
			<div style="text-align:center;">-��<span style="margin:15px;"></span>��-</div>
			<br>
			<div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;">
					<tr style="height:50;">
						<td width="70" class="title">������ȣ</td>				
						<td width="70" class="title">�����ȣ</td>				
						<td width="90" class="title">����</td>				
						<td width="40" class="title">����</td>				
						<td width="35" class="title">����<br>����</td>				
						<td width="90" class="title">���ʵ����</td>				
						<td width="50" class="title">�����</td>				
						<td width="80" class="title">����</td>				
						<td width="65" class="title">�빰</td>				
					</tr>				
					<tr style="height:60;">
						<td><%=info.get("CAR_NO")%></td>				
						<td><%=info.get("CAR_NUM")%></td>				
						<td><%=info.get("CAR_NM")%><br><%=info.get("CAR_NAME")%></td>				
						<td><%=info.get("NM")%></td>				
						<td><%=info.get("TAKING_P")%></td>				
						<td><%=info.get("INIT_REG_DT")%></td>				
						<td><%=info.get("AIRBAG_EA")%></td>				
						<td><%=info.get("AGE_SCP")%></td>				
						<td><%=info.get("VINS_GCP_KD")%></td>							
					</tr>				
					<tr style="height:50;">
						<td class="title">�ڱ��ü<br>���</td>				
						<td class="title">�ڱ��ü<br>�λ�</td>				
						<td class="title">����</td>				
						<td class="title">������</td>				
						<td class="title">������</td>				
						<td class="title">���ŷ�ó</td>				
						<td class="title">�����</td>				
						<td class="title">����ڹ�ȣ</td>				
						<td class="title">�뿩<br>�Ⱓ</td>				
					</tr>				
					<tr style="height:60;">
						<td><%=info.get("VINS_BACDT_KD")%></td>				
						<td><%=info.get("VINS_BACDT_KC2")%></td>				
						<td><%=info.get("VINS_CACDT_CAR_AMT")%></td>				
						<td><%=info.get("VINS_CANOISR_AMT")%></td>				
						<td><%=info.get("COM_EMP_YN")%></td>				
						<td><%=info.get("FIRM_NM")%></td>				
						<td><%=info.get("USER_NM")%></td>				
						<td><%=info.get("ENP_NO")%></td>				
						<td><%=info.get("RENT_START_DT")%><br>~<br><%=info.get("RENT_END_DT")%></td>					
					</tr>				
				</table>
			</div>
			<div style="text-align:left;margin-left:30px;margin-top:100px;font-size:22pt;font-weight:bold;">
				<span style="text-align:left">�ֽ�ȸ��Ƹ���ī&nbsp;&nbsp;��&nbsp;ǥ&nbsp;��&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</span>
				<div id="Layer1" style="position:relative; left:535px; top:-50px; width:79px; height:78px; z-index:1"><img src="/acar/images/stamp.png" width="70" height="71"></div>
			</div>
		</div>
	</div>
	</div>
</form>
</body>
<script>
</script>
</head>
</html>