<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>


<%!
  public String[] mobileTags = { "cellphone",
                                  "iemobile",
                                  "midp",
                                  "mini",
                                  "mmp",
                                  "mobile",
                                  "nokia",
                                  "pda",
                                  "phone",
                                  "pocket",
                                  "ppc",
                                  "psp",
                                  "symbian",
                                  "up.browser",
                                  "up.link",
                                  "wap",
                                  "android",
                                  "iPhone",                                                           
                                  "windows ce" };
  
  public Boolean isMobile( String browserInfo )
  {
    for ( int n=0; n<mobileTags.length; n++ )
    {
      if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) )
      {
        return true;
      }
    }
    return false;
  }
%>

<%
	Enumeration e;	
	e = request.getHeaderNames();

  	String bInfo = request.getHeader( "user-agent" );
    
%>

<%
	LoginBean login 			= LoginBean.getInstance();
	OffAncDatabase oad 			= OffAncDatabase.getInstance();	
	UserMngDatabase umd 		= UserMngDatabase.getInstance();
	SecurityUtil securityUtil 	= new SecurityUtil();
	
	String login_yn = "";
	String user_nm = "";
	String end_dt = "";
	String cur_dt = "";
	String attend_login_dt = "";
	String loan_st = "";

	String s_width 	= request.getParameter("s_width")==null?	"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?	"":request.getParameter("s_height");
	String name 	= request.getParameter("name")==null?		"":request.getParameter("name");
	String passwd 	= request.getParameter("passwd")==null?		"":request.getParameter("passwd");
	String open_type= request.getParameter("open_type")==null?	"1":request.getParameter("open_type");
	String new_menu= request.getParameter("new_menu")==null?	"":request.getParameter("new_menu");
	
	String user_id 	= "";
	String dept_id = "";
	String en_pass="";
	
	
	if(login.isLogin(request)){
	
		if((name.length() > 0) && (passwd.length() > 0)){
		  
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
			
				  user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");
			    		    
			   
			    //��ȣ 8�ڸ��̸��ΰ��... - ��������� �ش� ( ���¾�ü �ƴ�.
			    if  ( passwd.length() < 8  && !dept_id.equals("8888") && !dept_id.equals("1000") ) {
			      login_yn="r_pass";			   			   	    
			    } else { 			
						login_yn="r_ok";												
					
						//���÷��� ������ ��Ű����
						login.setDisplayCookie(s_width, s_height, response);
						
						//�α���ó��----------------------------------------------------------------------------------
						String login_time = Util.getLoginTime();//�α��νð�
						String login_ip = request.getRemoteAddr();//�α���IP						
						int count = 0;
					
						if(!user_id.equals("")){
							String attend_dt1 = "";
							String attend_dt2 = "";
							attend_dt1 = aa_db.getAttendDate(user_id);
							//ip_log ���
							count = oad.insertLoginLog(login_ip, user_id, login_time);
							int chk_count = oad.attendChk(user_id);//7������ �α���
							//��ٰ���
							if(chk_count ==0){
								count = oad.attend(login_ip, user_id, login_time);
								System.out.println("[�α��� FMS] DT:"+login_time+", ID:"+user_id+"("+user_nm+")");
							}
							//��ٽð� üũ
							attend_dt2 = aa_db.getAttendDate(user_id);
							if(attend_dt1.equals("") && !attend_dt2.equals("")){
								attend_login_dt = attend_dt2;							
								//��üŹ�� ������ ��󿩺�
								UsersBean user_bean = umd.getUsersBean(user_id);
								loan_st = user_bean.getLoan_st();
							}						
						}
				
			    }	//��ȣ8�ڸ�
				
			//�α���ó��----------------------------------------------------------------------------------
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		
		}else{
			login_yn="no";
		}
	}else{
		
		if( (name.length() > 0) && (passwd.length() > 0)){
		
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
				login_yn="ok";
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		
		}else{
			login_yn="no";
		}
	}
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>::: FMS �α���:::</title>
</head>
<script language="JavaScript" src="/include/info_fms2.js"></script>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script> 
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type='text/javascript'>
//<![CDATA[
// ����� ���� JavaScript Ű�� ������ �ּ���.
Kakao.init("4419b2a3a6bac750d7b19ffd37d7b995");
function loginWithKakao() {
	// �α��� â�� ���ϴ�.
	Kakao.Auth.login({ //loginForm, login
		success: function(authObj) {
			Kakao.API.request({	
				url: '/v2/user/me',		
				success: function(res) {
					alert(JSON.stringify(res)); //<---- kakao.api.request ���� �ҷ��� ����� json���·� ���
					alert(res.id);
				},
				fail: function(err) {
					alert("���������� ���� ������ �ٽ� ��û��Ź�帳�ϴ�.");
				}				
			})
		},
		fail: function(err) {
		  alert("�����ڿ��� �������ּ���.");
		}
	});
};    
</script>
<script type="text/javascript"> 
$(document).bind("mobileinit", function(){
	$.mobile.ajaxLinksEnabled=false;
	$.mobile.ajaxFormsEnabled=false;
	$.mobile.ajaxEnabled=false;

});
</script>


<SCRIPT LANGUAGE="JavaScript">
<!--

	var url =window.location.href;
//�ݿ��ÿ��� �� �ּ��� Ǯ�����(���߽ÿ��� �ּ�)
	if (document.location.protocol == 'http:') {
		if (url.indexOf("localhost") > -1 || url.indexOf("127.0.0.1") > -1) {
 		console.log("localhost");
		} else {
			url =url.replace('http:', 'https:');
   		document.location.href =url;
		}
	}           
	  
	var serverId = "109";
	
	window.status = serverId + " ���� �Դϴ�."
	
	if( parent.top_menu ){
		parent.location.href = '/fms2/index.jsp';
	}
	
	var s_width = screen.width;
	var s_height = screen.height;

	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') submitgo();
	}
	
	function submitgo(){
   		var theForm = document.flogin;
	   	if(theForm.name.value==""){
   			alert("ID�� �Է��Ͻʽÿ�.");
   			theForm.name.focus();
	   		return;
   		}
   		
   		//���ȼ��� ����� �������� ��ȸ�ϵ��� ���� - 20180920
		if(theForm.name.value=="speedmate" || theForm.name.value=="speedmateers" ||  theForm.name.value=="mastercar" ||  theForm.name.value=="krma" ){
   			//alert("���� URL�� ����Ǿ����ϴ�. ���ǹٶ��ϴ�. !!!!");
   			$('#dialog').dialog({
                position:"center", //"center", "left", "right", "top", "bottom"
                modal:true, //��޴�ȭ����
                resizable:false, //ũ�� ���� ���ϰ�
                buttons:{
                    "Ȯ��":function(){
                        $(this).dialog("close");
                    }
                }
   			});
   			theForm.name.focus();   
   			return;	   		
   		}
   		
	   	if(theForm.passwd.value==""){
   			alert("�н����带 �Է��Ͻʽÿ�.");
   			theForm.passwd.focus();
	   		return;
   		}

	   	theForm.s_width.value = s_width;		
			theForm.s_height.value = s_height;
		
			if(theForm.name.value == "2002010"){
				theForm.s_height.value = s_height-40;
			}
		
			theForm.submit();
	}
	
	
	function updPass(){
			var SUBWIN="/acar/menu/pass_u.jsp?info=<%=user_id%>";	
			window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}	
	

	
//-->
</SCRIPT>
<STYLE>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
@font-face {
  font-family: 'Nanum Square';
  font-style: normal;
  font-weight: 400;
  src: url(/fms2/menu/font/NanumSquareR.eot);
  src: local('Nanum Square Regular'),
       local('NanumSquareR'),
       url(/fms2/menu/font/NanumSquareR.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareR.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareR.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareR.ttf) format('truetype');
}
*{
	font-family:'Nanum Barun Gothic';
}
body{
	background-color:#ebeced;
}
.top-header{
	background-color:#349BD4;
	width:100%;
	color:#fff;
	text-align:center;
	font-size:40px;
	padding:15px;
	margin-bottom:50px;
}
.top-header img{
	margin-bottom:-15px;
	margin-right:10px;
}
.top-header h2{
	font-size:40px;
	font-family:'Nanum Square';
	margin:0px;
}

.login-area{
	/* padding:50px; */
	width:500px;
	height:500px;
	margin:0 auto;
	/* border:1px solid #b7bac0; 
	background-color:#fff; */ 
	text-align:center;
}
.text{
	width:300px !important;
	height:30px !important;
}
label{
	color:#6c7382;
	line-height:22px;
	font-size:13px;
	font-weight:bold;
}
.label_css{
	color:#000;
	line-height:22px;
	font-size:13px;
	font-weight:bold;
	cursor: text;
}
.input_btn{
	width:300px;
	height:50px;
	background-color:#349BD4;
	color:#fff;
	border:0px;
	outline:0px;
	padding:10px;
	font-size:16px;
	border-radius:5px;
}
.login-form-control{

	ling-height:30px;
	/* width:300px; */ 
	margin:0 auto;
	margin-top:30px;
	text-align:left;
	height: 80px;
}
.form-control{
	margin:10px 0px;
}
.float-style-left{
	float: left;
}
.float-style-right{
	float: right;
}
.ui-dialog{
	width: 500px !important;
}
#dialog{
	padding-top: 30px !important;
	display: none; 
}
.ui-widget-content {
    border: 0px !important;
}
.ui-dialog-titlebar{
	border: 0px !important;
    background: #349BD4 !important;
    color: #000 !important;
    font-weight: bold !important;
}
.ui-dialog-buttonpane{
	border: 0px !important;
    background: #FFF !important;
    color: #000 !important;
}
.ui-button-text-only{
	border: 1px solid #349BD4 !important;
	background: #349BD4 !important;
	color: #FFF !important;
	line-height:22px !important;
	font-size:13px !important;
	font-weight:bold !important;
    width: 100px !important;
    height: 40px !important;
}

/* button */
.agent_button{
	/* background-color: #286090; */ 
	background-color: #349BD4; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 100px;
}
.off_button{
	background-color: #449d44; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 100px;
}
.sos_button{
	background-color: #449d44; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 100px;
}
.insur_button{
	background-color: #349BD4; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 100px;
}
.user_button{
	background-color: #349BD4; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 100px;
}
.user_button_1{
	background-color: #349BD4; 
	color: #FFF; 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 30px;
}
.user_button_1_1{
	/* background-color: #349BD4; 
	color: #FFF; */ 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	width: 200px;
    height: 30px;
}
.user_button_2{
	background-color: #349BD4; 
	color: #FFF;
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	cursor: pointer;
	width: 200px;
    height: 30px;
}
.user_button_2_1{
	/* background-color: #349BD4; 
	color: #FFF; */ 
	text-align: center; 
	border-radius: 5px; 
	padding: 10px; 
	margin: 10px;
	width: 200px;
    height: 30px;
}
.ui-loader-default{
	display: none !important;
}

</STYLE>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>	
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_pass")){%>
	onLoad="javascript:updPass();"	
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%	}else{%>	
<%	}%>>
<form name="flogin" method="post">
	<input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+name+"|"+user_id) %>" />
	<input type='hidden' name="s_width" value="">
	<input type='hidden' name="s_height" value="">
	<input type='hidden' name="login_yn" value="<%=login_yn%>">
	<input type='hidden' name="open_type" value="">
     
	<div class="top-header">
		<!-- <h2><img src="/fms2/images/login_img.png"/>FMS �α���</h2> -->
		<!-- <h2>�Ƹ���ī ��Ʈ�ʽý���(FMS)�� ���Ű��� ȯ���մϴ� !!</h2> -->
	</div>
	
	<div style="text-align: center !important; padding-top: 20px;">
		<h2>�Ƹ���ī ��Ʈ�ʽý���(FMS)�� ���Ű��� ȯ���մϴ� !!</h2>
	</div>
	
	<div class="login-area">
		<div class="login-form-control">
			<%-- <div class="form-control">
				<label>���̵�</label><br/>
				<input type="text" name="name" value="<%=name%>" class="text" onKeydown="EnterDown()" tabindex=1><br/>
			</div>
			<div class="form-control">
				<label>��й�ȣ</label><br/>
				<input type="password" name="passwd" value="<%=passwd%>" class="text" onKeydown="EnterDown()" tabindex=2><br/>
			</div>
			<div class="form-control">
				<button type="button" class="input_btn" onclick="javascript:submitgo();">�α���</button>
			</div>
			<div class="form-control" style="text-align: center;">
				<a onclick="loginWithKakao();" style="cursor: pointer;">					
					<img class="login-social-image" src="/images/kakao_login_btn.png"/>
				</a>
			</div> --%>
			<div class="form-control float-style-left">
				<div class="agent_button" onclick="location.href='https://fms5.amazoncar.co.kr/agent/index.jsp'">
					<div style="padding-top: 20px;">
						<span style="font-size: 1.25em;">������Ʈ</span><br><br><span style="font-size: 0.9em;">�α���</span>
					</div>
				</div>
			</div>
			<div class="form-control float-style-right">
				<div class="off_button" onclick="location.href='https://fms5.amazoncar.co.kr/off_web2/index.jsp'">
					<div style="padding-top: 20px;">
						<span style="font-size: 1.25em;">���¾�ü</span><br><br><span style="font-size: 0.9em;">�α���</span>
					</div>
				</div>
			</div>			
		</div>
		
		<div class="login-form-control">
			<div class="form-control float-style-left">
				<div class="sos_button" onclick="location.href='https://fms.amazoncar.co.kr/off_web/index.jsp'">
					<div style="padding-top: 20px;">
						<span style="font-size: 1.25em;">����⵿</span><br><br><span style="font-size: 0.9em;">�α���</span>
					</div>
				</div>
			</div>
			<div class="form-control float-style-right">
				<div class="insur_button" onclick="location.href='https://fms.amazoncar.co.kr/off_web/index.jsp'">
					<div style="padding-top: 20px;">
						<span style="font-size: 1.25em;">�������</span><br><br><span style="font-size: 0.9em;">�α���</span>
					</div>
				</div>
			</div>
		</div>
		
		<!-- <div class="login-form-control">
			<div class="form-control float-style-left">
				<div class="user_button_1" onclick="location.href='/fms2/index2.jsp'">
					<div style="padding-top: 5px;">
						<span style="font-size: 1.25em;">���� FMS �α���</span>
					</div>
				</div>
			</div>
			<div class="form-control float-style-right">
				<div class="user_button_1_1">
					<div style="width: 500px; text-align: left; margin-top: -10px;">
						<span style="font-size: 0.95em; color: red; font-weight: bold;">
							5�� 31��(��)������ �ѽ��� ��뿹��
						</span>
						<br>
						<span style="font-size: 0.95em;">
							��� FMS�̿��ں�(����)���� �Ʒ��� <span style="font-weight: bold;">���ű� ī�忬�� ��ϡ��� ����</span>�Ͻþ�,
						</span>
						<br>
						<span style="font-size: 0.95em;">
							���� ������ ī��� �����Ǵ� FMS �ý��� �α����� �̿��Ͻñ� �ٶ��ϴ�.
						</span>
					</div>
				</div>
			</div>
		</div> -->
		
		<div class="login-form-control">
			<div class="form-control float-style-left">
				<div class="user_button_2" onclick="location.href='/fms2/login_step1.jsp'">
					<div style="padding-top: 5px;">
						<span style="font-size: 1.25em;">FMS �α���</span>
					</div>
				</div>
			</div>
			<div class="form-control float-style-right">
				<div class="user_button_2_1">
					<div style="padding-top: 5px;">
						<span style="font-size: 1.25em;"></span>
					</div>
				</div>
			</div>
		</div>		
		
	</div>
	
	<div class="ment" style="text-align: center !important;">
		<h3>
			<b>
				�� �Ƹ���ī FMS�� <font color=blue> Chrome </font> �Ǵ� <font color=blue> Edge </font> ����� �����մϴ�.<br><br>		
			</b>
		</h3>
	</div> 
	
	<!-- <div class="login-form-control">
		<div class="form-control" style="width: 200px;">
			<div class="user_button" onclick="location.href='/fms2/login_step1.jsp'">
				������
			</div>
		</div>
	</div> -->
    <p>
	<!-- <div class="ment" style="text-align: center !important;">
		<h3>
			<b>
				<font color=red>ID ���� �� �ܺ�����</font>�� ���ذ� �߻��� ���<br><br>
				�̿� ���� �ҹ�����, ��ŷ�õ� ���� �߰ߵ� �ÿ��� IP��ô�� ���Ͽ�<br><br>
				������ ��ġ�� �� �ֽ��ϴ�.
			</b>
		</h3>
	</div> -->

<!-- <table width=478 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td width=25 rowspan=4><img src=/fms2/images/login_1.gif width=25 height=312></td>
        <td width=428><img src=/fms2/images/login_img.gif width=428 height=149></td>
        <td width=25 rowspan=4><img src=/fms2/images/login_2.gif width=25 height=312></td>
    </tr>
    <tr>
        <td>
            <table width=428 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td colspan=4 height=10></td>
                </tr>
                <tr>
                    <td width=110 align=right><img src=/fms2/images/login_id.gif width=40 height=11></td>
                    <td width=11 rowspan=2>&nbsp;</td>
                    <td width=163 rowspan=2>
                        <table width=163 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>
                                <input type="text" name="name" value="<%=name%>" size=19 class=text onKeydown="EnterDown()" tabindex=1> </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td>
                                <input type="password" name="passwd" value="<%=passwd%>" size=20 class=text onKeydown="EnterDown()" tabindex=2>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=144 rowspan=2><a href="javascript:submitgo()"><img src=/fms2/images/login_button.gif width=66 height=43 border=0></a>     
                    </td>
                </tr>
                <tr>
                    <td align=right><img src=/fms2/images/login_pw.gif width=40 height=11></td>
                </tr>
    	        <tr>
                    <td height=14 colspan=4></td>
                </tr>
                <tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <div id="fmsloginFlashLoc" style="width: 426px; height: 67px;" >
                <script id="fmslogin_elementid" src="/fms2/js/fmsloginFlashControl.js"></script> 
            </div>
        </td>
    </tr>
    <tr>
        <td><img src=/fms2/images/login_4.gif width=428 height=23></td>
    </tr>
</table>
 -->

</form>

<div id="dialog">
    <label class="label_css">���� URL�� ���� �Ǿ����ϴ�.<br>
    https://fms.amazoncar.co.kr/off_web/index.jsp<br>    
    ���� ���� ��Ź�帳�ϴ�.
    </label>
</div>

<br>
<br>

<script language="javascript">
<% if ( isMobile( bInfo ) ) { %>
	document.flogin.open_type.value = "2";
<% } else { %>
	document.flogin.open_type.value = "1";
<% } %>

<%	if(login_yn.equals("no_id")){ 	%>
	alert('��ϵ� ����ڰ� �ƴմϴ�. ID, PASSWORD�� Ȯ���Ͻʽÿ�.');
<%	}	%>
<%	if(login_yn.equals("db_error")){ %>
	alert('����Ÿ���̽� �����Դϴ�.');
<%	}	%>
</script>
</body>
</html>
