<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, java.net.URLEncoder, java.net.URLDecoder" %>
<%@ page import="acar.util.*, acar.car_office.*, acar.user_mng.*, acar.fee.*" %>
<%@ page import="acar.kakao.*" %>
<%

/* 	
	serarch_type
	1. phone_no

	send_type
	1. insur - 보험
	2. maint - 정비
	3. sos - 긴급출동
	4. accident - 교통사고
	
	type
	1. info
	2. msg_send
	3. consult
	
	firm_nm, user_nm은 URI인코딩해서 전달받을 것
*/

String search_type = request.getParameter("search_type") == null ? "" : request.getParameter("search_type");
String number = request.getParameter("number") == null ? "" : request.getParameter("number");
String gubun = request.getParameter("gubun") == null ? "" : request.getParameter("gubun");

String type = request.getParameter("type") == null ? "" : request.getParameter("type");

String client_id = request.getParameter("client_id") == null ? "" : request.getParameter("client_id");
String firm_nm = request.getParameter("firm_nm") == null ? "" : request.getParameter("firm_nm");
String car_no = request.getParameter("car_no") == null ? "" : request.getParameter("car_no");

String br_id = request.getParameter("br_id") == null ? "" : request.getParameter("br_id");
String user_id = request.getParameter("user_id") == null ? "" : request.getParameter("user_id");
String user_nm = request.getParameter("user_nm") == null ? "" : request.getParameter("user_nm");
String user_m_tel = request.getParameter("user_m_tel") == null ? "" : request.getParameter("user_m_tel");

String send_type = request.getParameter("send_type") == null ? "" : request.getParameter("send_type");

String test_num = request.getParameter("test_num") == null ? "" : request.getParameter("test_num");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS ARS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script language='JavaScript' src='/include/common.js'></script>

<script type="text/javascript">
$(document).ready( function() {
	var search_type = "<%=search_type%>";
	var number = "<%=number%>";
	
	var gubun = "<%=gubun%>";
	
	var type = "<%=type%>";
	
	var client_id = "<%=client_id%>";
	var firm_nm = "<%=firm_nm%>";
	var car_no = "<%=car_no%>";
	
	var br_id = "<%=br_id%>";
	var user_id = "<%=user_id%>";
	var user_nm = "<%=user_nm%>";
	var user_m_tel = "<%=user_m_tel%>";
	
	var send_type = "<%=send_type%>";
	
	var test_num = "<%=test_num%>";
	
	if (type == "info") {
		ajaxGetTemplateList(search_type, number, type);
	}
	
	if (type == "msg_send") {
		ajaxGetTemplateSendMsg(search_type, number, type, gubun, client_id, firm_nm, user_id, user_nm, user_m_tel, send_type, test_num, car_no);
	}
})
</script>

<script type="text/javascript">
function ajaxGetTemplateList(search_type, number, type) {
    var data = {
   		search_type: search_type,
   		number: number
    };
    
    $.ajax({
        cache: false,
        type: "GET",
        url: "./ars_api_ajax.jsp",
        dataType: "json",
        data: {
        	type: type,
        	//data: JSON.stringify(data),
        	search_type: search_type,
        	number: number
        },
        success: function(data) {
            console.log(data);
            
            data.forEach(function(tpl) {
                if (tpl.code == "401" || tpl.code == "402" || tpl.code == "403" || tpl.code == "500") {
                	html = "<p>code : "+tpl.code+"</p>" +
                				"<p>result : "+tpl.result+"</p><br><br>";
                } else {                	
	            	html = "<p>search_type : "+tpl.search_type+"</p>" +
	                			"<p>code : "+tpl.code+"</p>" +
	                			"<p>gubun : "+tpl.gubun+"</p>" +
			                	"<p>client_id : "+tpl.client_id+"</p>" +
			                	"<p>firm_nm : "+tpl.firm_nm+"</p>" +
			                	"<p>car_no : "+tpl.car_no+"</p>" +
			                	"<p>firm_nm_enc : "+tpl.firm_nm_enc+"</p>" +
			                	"<p>br_id : "+tpl.br_id+"</p>" +
			                	"<p>user_id : "+tpl.user_id+"</p>" +
			                	"<p>user_nm : "+tpl.user_nm+"</p>" +
			                	"<p>user_nm_enc : "+tpl.user_nm_enc+"</p>" +
			                	"<p>user_m_tel : "+tpl.user_m_tel+"</p>" +
			                	"<p>user_id_1 : "+tpl.user_id_1+"</p>" +
			                	"<p>user_nm_1 : "+tpl.user_nm_1+"</p>" +
			                	"<p>user_nm_enc_1 : "+tpl.user_nm_enc_1+"</p>" +
			                	"<p>user_m_tel_1 : "+tpl.user_m_tel_1+"</p>" +
			                	"<p>user_id_2 : "+tpl.user_id_2+"</p>" +
			                	"<p>user_nm_2 : "+tpl.user_nm_2+"</p>" +
			                	"<p>user_nm_enc_2 : "+tpl.user_nm_enc_2+"</p>" +
			                	"<p>user_m_tel_2 : "+tpl.user_m_tel_2+"</p><br><br>";
                }
	            $("#view").append(html);
            });            
            
        },
        error: function(e) {
            alert("error : " + e);
            $("#view").append("");
            console.log(e);
        }
    });
}

function ajaxGetTemplateSendMsg(search_type, number, type, gubun, client_id, firm_nm, user_id, user_nm, user_m_tel, send_type, test_num, car_no) {
    var data = {
   		search_type: search_type,
   		number: number,
   		gubun: gubun,
   		client_id: client_id,
   		//firm_nm: encodeURIComponent(firm_nm),
   		firm_nm: firm_nm,
   		user_id: user_id,
   		//user_nm: encodeURIComponent(user_nm),
   		user_nm: user_nm,
   		user_m_tel: user_m_tel,
   		send_type: send_type,
   		test_num: test_num,
   		car_no: car_no
    };
    
    $.ajax({
        cache: false,
        type: "GET",
        url: "./ars_api_ajax.jsp",
        dataType: "json",
        data: {
        	type: type,
        	search_type: search_type,
       		number: number,
       		gubun: gubun,
       		client_id: client_id,
       		firm_nm: encodeURIComponent(firm_nm),
       		//firm_nm: firm_nm,
       		user_id: user_id,
       		user_nm: encodeURIComponent(user_nm),
       		//user_nm: user_nm,
       		user_m_tel: user_m_tel,
       		send_type: send_type,
       		test_num: test_num,
       		car_no: car_no
            //data: JSON.stringify(data)
        },
        success: function(data) {
        	console.log('메세지를 전송했습니다');
        	
        	if (data.code == "200") {
	        	html = "<p>메세지 전송에 성공하였습니다.</p>" +
    						"<p>code : "+data.code+"</p>";
        	} else {
        		html = "<p>메세지 전송에 실패하였습니다.</p>" +
							"<p>code : "+data.code+"</p>";
        	}
        	
			$("#view").append(html);
        },
        error: function(e) {
        	console.log('메세지 전송에 실패했습니다');
        	html = "<p>메세지 전송에 실패하였습니다.</p>";
						
        	$("#view").append(html);
        	console.log(e);
        }
    });
}
</script>
</head>

<body leftmargin="15">
	테스트API 페이지<br><br>
	<div id="view"></div>
</body>
</html>
