<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.estimate_mng.*" %>
<%@ page import="acar.kakao.*" %>

<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	// 로그인 정보
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}
    		
    String content_check[] = request.getParameterValues("content_check");
	int content_check_size = content_check.length;

    //영업담당자 리스트
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
.table-style-1 {
    font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    color: #515150;
    font-weight: bold;
}
.table-back-1 {
    background-color: #B0BAEC
}
.font-1 {
    font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    font-weight: bold;
}
.font-2 {
    font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
}
.width-100 {
    width: 100px;
}
.width-0 {
    width: 150px;
}
.width-1 {
    width: 200px;
}
.width-2 {
    width: 250px;
}
.width-3 {
    width: 300px;
    padding: 2px;
    margin-bottom: 3px;
}
.customers_table2 tr > td{
	width: 100px;
}
.message_body {
    width: 300px;
    height: 450px;
    background-color: #A0C0D7;
}
.message_bubble {
    width: 90%;
    height: 90%;
    margin: auto;
    border-radius: 3px;
    background-color: white;
}
.message_bubble_header {
    height: 50px;
    background-color: #FEE800;
    border-radius: 3px 3px 0px 0px;
}
.message_bubble_header_text {
    text-align: center;
    line-height: 50px;
}
.message_bubble_text_area {
    overflow-x: hidden;
    width: 90%;
    height: 80%;
    margin: 5%;
    resize: none;
    border: none;
}
.message_send_button {
    width: 300px;
    height: 30px;
    background-color: #FEE800;
    border: 0.5px solid grey;
    box-sizing: border-box;
}
.remove_client {
	background-color:#6D758C;
	font-size:12px;
	cursor:pointer;
	border-radius:2px;
	color:#fff;
	border:0;
	outline:0;
	padding:5px 8px;
	margin:3px;
}
.remove_client:hover {
	background-color:#525D60;
}
.add_client {
	background-color:#62B139;
	font-size:12px;
	cursor:pointer;
	border-radius:2px;
	color:#fff;
	border:0;
	outline:0;
	padding:5px 15px;
	margin:3px;
}
.add_client:hover {
	background-color:#519C2A;
}
.coment {
	background-color:#2B95F1;
	font-size:12px;
	cursor:pointer;
	border-radius:2px;
	color:#fff;
	border:0;
	outline:0;
	padding:5px 15px;
	margin:3px;
}
.coment:hover {
	background-color:#1E6FB5;
}
</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">

function User(name, phone) {
    this.name = name;
    this.phone = phone;
}

var mMultiUser = [];
var gUserList = [];

var gUserId = '<%= user_id %>';
    
$(document).ready(function(){
	
	$("#message-length").html("0");
	
	//직접입력시 메시지 길이 체크
    $("#alim-textarea-w").bind("keyup", function() {
        $("#message-length").html($("#alim-textarea-w").val().length);
    });
	
	// 발신자 변경
    $("#org-name").bind("change", function() {
        var selOpt = $(this).find(":selected");        
        var name = selOpt.attr("data-name");
    	var phone = selOpt.attr("data-phone");
    	$("#coment_txt").html("★ 담당자 : " + name + " " + phone);
    	$("#coment_div").show();
    });
	
    $("#send-button").bind("click", function() {
    	var count_row = $("#recipient_table > tbody > tr").length;
    	
    	if (count_row == 0) {
    		alert("수신자가 없습니다. 수신자를 추가 해주세요.");
    		return;
    	}
    	if (count_row >= 30) {
    		alert("한번에 발송할 수 있는 최대 건 수는 30건 입니다.");
    		return;
    	}
        if ($("#alim-textarea-w").val() == "") {
            alert("메시지를 입력해주세요.");
            return;
        }
        
        if (!confirm("메세지를 발송 하시겠습니까?")) {
            return;            
        } else {
	        // 태그 삭제 (br은 CR처리)
	        var content = $("#alim-textarea-w").html();
	        var newLine = String.fromCharCode(13, 10);
	        content = content.replace(/<br>/g, newLine);
	        content = content.replace(/<[^>]*>/g, "");
	
	        var userId = "";
	        var callbackNum = "";
	        
	    	userId = $("#org-name option:selected").attr("value");
	    	callbackNum = $("#org-name option:selected").attr("data-phone");
	        
	        var msgType = "1009"; //친구톡
	        content = $("#alim-textarea-w").val();
	        
	        var count = 0;
	        
	        for (var z = 0; z < count_row; z++) {
	        	
	        	var recipentNum = $("#recipient_num_"+z).val();
	        	
	            var sendData = {
	                "template_code" : "0",
	                "content" : encodeURIComponent(content),
	                "callback_num" : callbackNum,
	                "recipient_num" : recipentNum,
	                "msg_type" : msgType,
	                "l_cd" : gUserId,
	                "user_id" : userId
	            }
	            
	            $.ajax({
	                type : "POST",
	                dataType : "json",
	                url : "/acar/kakao/alim_talk_ajax.jsp",
	                cache : false,
	                async : false,
	                data : {
	                    cmd: "send_msg",
	                    data: JSON.stringify(sendData)
	                },
	                success : function(result) {
						if (result != null) {
	                		count++;
						}
	                },
	                error : function(e) {
	                    count = -1;
	                }
	            })
	        }
	        
	        if (count_row == count) {
	    		alert("메시지를 전송했습니다.");
	    	} else if ((count > 0) && (count_row != count)) {
	    		alert("일부 전송되지 않은 메세지가 있습니다. 수신자를 확인해주세요.");
	    	} else if (count == -1) {
	    		alert("메시지 전송에 실패했습니다.");
	    	}
        }
        
    });
    
});

//수신자 추가
$(document).on("click", "#add_client", function() {
	var recipient_num = $("#recipient_num").val();
	var client_nm = $("#client_nm").val();
	var count_row = $("#recipient_table > tbody > tr").length;
	
	var add_html_txt = "<tr id='row_" + count_row + "' class='recipient_rows'>" +
									"<td style='text-align: center; width: 150px !important;'>" +
										"<input type='text' name='recipient_num' id='recipient_num_" + count_row + "' class='recipient_num white width-0' value='" + recipient_num + "'>" +
									"</td>" +
									"<td style='text-align: center; width: 200px !important;'>" +
										client_nm +
									"</td>" +
									"<td style='text-align: center; width: 80px !important;'>" +
										"<input type='button' class='remove_client' value='삭제'>" +
									"</td>" +
								"</tr>";
	
	if (recipient_num == "") {
		alert("연락처를 입력해 주세요.");
		return;
	}
	if (client_nm == "") {
		alert("고객명을 입력해 주세요.");
		return;
	}	
	if (count_row >= 30) {
		alert("한번에 발송할 수 있는 최대 건 수는 30건 입니다.");
		return;
	} else {
		$("#recipient_table > tbody:last").append(add_html_txt);
		$("#total_count").html(count_row+1);
		
		//수신자 입력항목 초기화
		initRecipient();
	}
})

//수신자 제거
$(document).on("click", ".remove_client", function() {
	var row_id = $(this).closest("tr").attr("id");
	
	$("#" + row_id).remove();
	
	var count_row = $("#recipient_table > tbody > tr").length;
	
	for (var i = 0; i < count_row; i++) {
		$(".recipient_rows:eq("+i+")").attr("id", "row_" + i);
		$(".recipient_rows:eq("+i+")").find(".recipient_num").attr("id", "recipient_num_" + i);
	}
	
	$("#total_count").html(count_row);
})

//수신자 추가 input 초기화
function initRecipient() {
	$("#recipient_num").val("");
	$("#client_nm").val("");
}

//수신자 추가 연락처 자동 하이픈
$(document).on("keyup", "#recipient_num", function() {
	//console.log(this.value);
	this.value = autoHypenPhone(this.value);
});

var autoHypenPhone = function(str) {
    str = str.replace(/[^0-9]/g, "");
    var tmp = "";
    if (str.length < 4) {
        return str;
    } else if (str.length < 7) {
        tmp += str.substr(0, 3);
        tmp += "-";
        tmp += str.substr(3);
        return tmp;
    } else if (str.length < 11) {
        tmp += str.substr(0, 3);
        tmp += "-";
        tmp += str.substr(3, 3);
        tmp += "-";
        tmp += str.substr(6);
        return tmp;
    } else {              
        tmp += str.substr(0, 3);
        tmp += "-";
        tmp += str.substr(3, 4);
        tmp += "-";
        tmp += str.substr(7);
        return tmp;
    }

    return str;    
}

//문구표기서식
function comentChange(idx) {
	var name = $("#org-name option:selected").attr("data-name");
	var phone = $("#org-name option:selected").attr("data-phone");
	
	var coment_txt = "";
	
	if (idx == "1") {
		coment_txt = "★ 담당자 : " + name + " " + phone;	
	} else if (idx == "2") {
		coment_txt = "(주)아마존카<br>www.amazoncar.co.kr";
	}
	
	$("#coment_txt").html(coment_txt);	
	$("#coment_div").show();
}
</script>
</head>

<body leftmargin="20">

<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan="10">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="7">
                        	<img src="/acar/images/center/menu_bar_1.gif" width="7" height="33">
                        </td>
                        <td class="bar">
                        	&nbsp;
                        	<img src="/acar/images/center/menu_bar_dot.gif" width="4" height="5" align="absmiddle">&nbsp;
                        	<span class="style1">
                        		스마트 견적관리&nbsp;>&nbsp;<span class="style5">선택 알림톡 발송</span>
                        	</span>
                        </td>
                        <td width="7">
                        	<img src=/acar/images/center/menu_bar_2.gif width="7" height="33">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class="h"></td>
        </tr>
        <tr>
            <td colspan="10">
                <span class="style4">※ 현재 화면에서 발송하는 메세지는 친구톡 입니다.</span>
            </td>
        </tr>
        <tr>
            <td colspan="10">
                <span class="style4">※ 친구톡은 플러스친구 에게만 전송됩니다. 플러스친구가 아니면 문자로 전송됩니다.</span>
            </td>
        </tr>
        <tr>
            <td colspan="10">
                <span class="style4">※ 한번에 발송할 수 있는 최대 건 수는 30건 입니다.</span>
            </td>
        </tr>
        <tr>
        	<td class="h"></td>
        </tr>
    </table>
</div>

<br>

<%-- 알림톡 --%>
<div>

    <div style="float: left; height: 100%; max-height: 600px;">
	    <div class="table-style-1">
	    	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle" style="margin-right: 5px;">알림톡 발송
	    </div>
	    
        <div class="message_body" style="margin-top: 15px;">
            <div style="height: 20px;"></div>
            <div class="message_bubble">
                <div class="message_bubble_header">
                    <div class="message_bubble_header_text font-1">알림톡</div>
                </div>
                <div>
                    <textarea id="alim-textarea-w" rows="5" cols="30" class="message_bubble_text_area font-2"></textarea>
                </div>
            </div>
        </div>
        <button id="send-button" class="message_send_button font-1">보내기</button>
        <div>
            <div style="text-align: right; color: #737373; font-size: 12px; padding: 5px;">현재: <span id="message-length">0</span> byte</div>
        </div>
    </div>

    <div style="float: left; margin-left: 80px; height: 100%; max-height: 600px;">
        <div class="table-style-1">
        	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle" style="margin-right: 5px;">발신자/수신자
        </div>
        <div>
            <div style="margin-top: 15px;">
                <span class="font-2">발신자</span>
                
                <select name="aaa" id="org-name" class="width-1" style="margin-top: 10px;">
                    <option value="A1" disabled selected>발신자</option>
			<%if (user_size > 0) {%>
				<%for (int i = 0; i < user_size; i++) {%>
					<%Hashtable user = (Hashtable)users.elementAt(i);%>
                    <option value="<%=user.get("USER_ID")%>"
						data-name="<%=user.get("USER_NM")%>"
						data-phone="<%=user.get("USER_M_TEL")%>"
						data-grade="<%=user.get("USER_POS")%>"
						data-br-nm="<%=user.get("BR_NM")%>"
						data-br-addr="<%=user.get("BR_ADDR")%>"
						data-br-tel="<%=user.get("BR_TEL")%>"
						<%if (user_id.equals(user.get("USER_ID"))) {%> selected<%} %>>
						<%=user.get("USER_NM")%> <%if (!user.get("USER_M_TEL").equals("")) {%>(<%= user.get("USER_M_TEL") %>)<%}%>
					</option>
				<%}%>
			<%}%>
                </select>
			</div>
			
            <div style="margin-top: 25px;">
                <span class="font-2">수신자 (<span id="total_count"><%=content_check_size%></span>명)</span>
                <br>
                <div style="height: 310px; max-height: 310px; overflow-y: scroll; margin-top: 10px; border: 1px solid #E8E8E8;">
	                <table id="recipient_table" style="padding: 10px 0px;">
	               	<%if (content_check_size > 0) {%>
	                	<%
	                	for (int i = 0; i < content_check_size; i++) {
	                		String est_id = content_check[i];
	                		e_bean = e_db.getEstiSpeCase(est_id);
	                	%>
	                	<tr id="row_<%=i%>" class="recipient_rows">
	                		<td style="text-align: center; width: 150px !important;">
								<input type="text" name="recipient_num" id="recipient_num_<%=i%>" class="recipient_num white width-0" value="<%=AddUtil.phoneFormat(e_bean.getEst_tel())%>" readonly>
	                		</td>
	                		<td style="text-align: center; width: 200px !important;">
	                			<%=e_bean.getEst_nm()%>
	                		</td>
	                		<td style="text-align: center; width: 80px !important;">
	                			<input type="button" class="remove_client" value="삭제">
	                		</td>
	                	</tr>
	                	<%
	                	}
	                	%>
	               	<%} else {%>
	                	<tr>
	                		<td colspan="3" style="text-align: center;">
			                	선택된 수신자가 없습니다.
	                		</td>
	                	</tr>
	                <%}%>
	                </table>
                </div>
            </div>
                        
            <div class="table-style-1" style="margin-top: 30px;">
	        	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle" style="margin-right: 5px;">수신자 추가
	        </div>
            <div>
                <table class="customers_table">
                	<tr>
                		<td>
							연락처 <input type="text" id="recipient_num" class="width-0">
                		</td>
                		<td>
                			고객명 <input type="text" id="client_nm" class="width-0">
                		</td>
                		<td>
                			<input type="button" class="add_client" id="add_client" value="추가">
                		</td>
                	</tr>
                </table>
            </div>
              
            <div class="table-style-1" style="margin-top: 30px;">
	        	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle" style="margin-right: 5px;">알림톡 발신관련 서식 (필요하신 문구는 복사하여 내용에 넣어주세요.)
	        </div>
	        <div style="margin-top: 10px;">
	        	<input type="button" class="coment" value="#담당자" onclick="comentChange('1');">
	        	<input type="button" class="coment" value="#아마존카상호 및 URL" onclick="comentChange('2');">
	        </div>
            <div id="coment_div" style="margin-top: 15px; dispaly: none;">
            	<span id="coment_txt" class="font-2">
				</span>
            </div>
        </div>
    </div>
</div>

</body>
<!-- <script src="https://apis.google.com/js/client.js?onload=load"></script> -->
<script>

</script>
</html>
