<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�̹������� ����
	
	String vid[] = request.getParameterValues("img_url");
	int vid_size = vid.length;
	
	
	
	String img_url = "";
	
	double img_width 	= 2100*0.378;
	double img_height 	= 2970*0.378;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" viewastext codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,3,435,20">-->
</object>

<%	for(int i=0;i < vid_size;i++){
		img_url 	= vid[i];
		if(!img_url.equals("")){%>
<img src=<%=img_url%> width=<%=img_width%> height=<%=img_height%>>
<%		}
	}%>

</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //��������� �μ�
factory.printing.footer 		= ""; //�������ϴ� �μ�
factory.printing.portrait 		= true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin 	= 0; //��������   
factory.printing.rightMargin 	= 0; //��������
factory.printing.topMargin 		= 0; //��ܿ���    
factory.printing.bottomMargin 	= 0; //�ϴܿ���
factory.printing.Print(false, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>