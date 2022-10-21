<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.table_div {
	margin-top: 10px;
	margin-left: 10px;
}
.header_title {
	border: 5px #b0baec;
}
.header_title td {
	text-align: center;
	vertical-align: middle;
	font-family: ����, Gulim, AppleGothic, Seoul, Arial;
	border: 1px solid #b0baec;
	border-right: 0px;
	border-bottom: 0px;
	height: 30px;
}
.header_title td:LAST-CHILD {
	border-right: 1px solid #b0baec;
}
.body_content td {
	text-align: center;
	vertical-align: middle;
	font-family: ����, Gulim, AppleGothic, Seoul, Arial;
	border: 1px solid #b0baec;
	border-right: 0px;
	border-bottom: 0px;
	height: 30px;
}
.body_content td:LAST-CHILD {
	border-right: 1px solid #b0baec;
}
.detail_content {
	text-align: left !important;
	padding-left: 10px;
}

.title_bottom_nth, .title_bottom td {
	border-bottom: 1px solid #b0baec !important;
}

.last_content {
	padding-top: 15px;
}
</style>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ��԰��� > <span class=style5>�系�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ٹ����� ����(���� ���� ����)</span></td>
        <td align=right><img src=/acar/images/center/arrow.gif align=absmiddle>&nbsp;2018�� 06�� 20�� ����</td>
    </tr>
</table>
<div class="table_div">
	<table width=70% border=0 cellspacing=0 cellpadding=0>
		<thead>
	     <tr class="header_title">
	     	<td colspan="2" class="title">����</td>
	     	<td class="title" width=80>����</td>
	     	<td class="title" width=80>���ܱ���</td>
	     	<td class="title">���γ���</td>
	     </tr>
	    </thead>
	    <tbody>
	    	<tr class="body_content">
	    		<td rowspan="4" class="title">����</td>
	    		<td>Y����</td>
	    		<td>��</td>
	    		<td></td>
	    		<td class="detail_content">����, ����, ���� ���� ����</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>T����</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content">ī�� ������ ���� ���� ���� �Ұ�</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>����</td>
	    		<td>��</td>
	    		<td></td>
	    		<td class="detail_content">���� ���� ����</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>���۷�</td>
	    		<td>X</td>
	    		<td>��</td>
	    		<td class="detail_content">����Ͻ� �迡�� ����� �ʴ� ������</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td rowspan="3" class="title">����</td>
	    		<td>�Ż纹����</td>
	    		<td>��</td>
	    		<td></td>
	    		<td class="detail_content">�⺻�͸� ���� ����</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>û����</td>
	    		<td>X</td>
	    		<td>��</td>
	    		<td class="detail_content">�⺻�͸� ���� ���� (������, �����, ������ ��, ������ Ż��, ������ ������ ����Ұ�)</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>�����</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td rowspan="5" class="title title_bottom_nth">�Ź�</td>
	    		<td>���屸��</td>
	    		<td>��</td>
	    		<td></td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>����</td>
	    		<td>X</td>
	    		<td>��</td>
	    		<td class="detail_content">����Ͻ� �迡 ����</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>����Ŀ��</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>�ȭ</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content title_bottom">
	    		<td>����</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr>
	    		<td colspan="5" class="last_content">
	    			�� �ݿ���, ���� �� �ٹ��Ͽ��� �ָ� �����̸� ���� �������� ��� ������ Ư�� ���� �ٶ��ϴ�.<br>
	    			�� ������ ������� ��� �������� ��� ������ ������� �ʽ��ϴ�.  
	    		</td>
	    	</tr>
	    </tbody>
	</table>
</div>
</body>
</html>