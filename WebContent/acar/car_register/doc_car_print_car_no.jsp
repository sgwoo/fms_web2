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

</head>

<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()">

<div id="Layer1" style="position:absolute; margin-top: -590px; margin-left: 600px; z-index:1;">
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

</script>
