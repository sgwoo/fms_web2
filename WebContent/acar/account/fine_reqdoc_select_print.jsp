<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");//��������ȣ
	String bus_id2		= request.getParameter("bus_id2")	==null?"":request.getParameter("bus_id2");
	
	String vid[] = request.getParameterValues("ch_cd");
	String file_name = "";
	
	int img_width 	= 680;
	int img_height 	= 1009;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<style>
@page a4sheet { size: 21.0cm 29.7cm }
.a4 { page: a4sheet; page-break-after: always }
</style>
</head>
<body>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<%	for(int i=0; i < vid.length; i++){
		file_name = vid[i];%>		
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=1009>
			<img src="https://fms3.amazoncar.co.kr/data/fine/<%=file_name%>" width=<%=img_width%> height=<%=img_height%>>
		</td>
	</tr>
</table>
<%		}%>
</body>
</html>
<script>
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
