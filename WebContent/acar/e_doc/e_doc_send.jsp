<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// �α��� ����
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

    // ��������� ����Ʈ
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();
    

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - ���ڹ��� �߼�</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.logo_area {
	height: 45px;
}
.logo_img {
	margin-left: 20px;
}
.no-drag {
	-ms-user-select: none;
	-moz-user-select: -moz-none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	user-select:none;
}
.menu_table_top {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;
}
.menu_table_top td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_top .no-drag:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	
	// ���� ��޴� ���� �� ������ ��ȯ
	function changeDocMenu(idx){
		if(idx == 1){				// ���ڹ��� �߼�
			window.location.href = 'e_doc_send.jsp';
		} else if(idx == 2){		// ���ڹ��� ����
			window.location.href = 'e_doc_mng.jsp';
		}
	}
	
	// ���� �߸޴� ���� �� content ���� ��ȯ
	function changeDocSt(idx){
		
		var doc_frame = document.getElementById('doc_mng_frame');
		
		if(idx == 1){				// ��༭
			doc_frame.src = 'cont_doc_send.jsp';
		} else if(idx == 2){		// Ȯ�μ�/��û��
			doc_frame.src = 'confirm_doc_send.jsp';
		}
		
	}
	
	
</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' 			name='user_id' value='<%=user_id%>' />

<!-- ��� ���� -->
<div style='margin-bottom: 20px;'>    
	<table width=100% border=0 cellspacing=0 cellpadding=0 style="height: 100px;">
	    <tr>
	        <td valign="top">
	            <table width=100% border=0 cellspacing=0 cellpadding=0>
	            	<tr>
	            		<td class="logo_area">
	            			<img class="logo_img" src="/acar/images/logo_1.png">
	            		</td>
	            	</tr>
	                <tr>
	                    <td valign="top" style="background-color: #349BD5; border-bottom: 1px solid #FFF;">
	                        <table class="menu_table_top">
	                            <tr>
	                            	<td class='no-drag' onclick='javascript:changeDocMenu(1);'>���ڹ��� �߼�</td>
	                            	<td></td>
	                            	<td></td>
	                            	<td></td>
	                            	<td class='no-drag' onclick='javascript:changeDocMenu(2);'>���ڹ��� ����</td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr id='e_doc_send_tr'>
	                    <td valign="top" style="background-color: #349BD5; border-bottom: 1px solid #FFF;">
	                        <table class="menu_table_top">
	                            <tr>
	                            	<%if(nm_db.getWorkAuthUser("������",user_id)){%>
	                              	<td class="no-drag" onclick='javacript:changeDocSt(1);'>��༭</td>
	                              	<%} else {%>
	                              	<td></td>
	                              	<%}%>
	                              	<td class="no-drag" onclick='javacript:changeDocSt(2);'>Ȯ�μ�/��û��</td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	</table>
</div>

<iframe id='doc_mng_frame' width='99%' height='80%' src='confirm_doc_send.jsp' style='border: none;'>
</iframe>

</form>
</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
