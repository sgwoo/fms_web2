<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id = "";
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_email = "";
	String user_pos = "";
	String user_aut2 = "";
	String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("info") !=null) user_id = request.getParameter("info");
	String cool 	= request.getParameter("cool")==null?	"":request.getParameter("cool");
	
	if(!user_id.equals(""))
	{
		user_bean = umd.getUsersBean(user_id);
				
		br_id = user_bean.getBr_id();
		br_nm = user_bean.getBr_nm();
		user_nm = user_bean.getUser_nm();
		id = user_bean.getId();
		user_psd = user_bean.getUser_psd();
		user_cd = user_bean.getUser_cd();
		user_ssn = user_bean.getUser_ssn();
		user_ssn1 = user_bean.getUser_ssn1();
		user_ssn2 = user_bean.getUser_ssn2();
		dept_id = user_bean.getDept_id();
		dept_nm = user_bean.getDept_nm();
		user_h_tel = user_bean.getUser_h_tel();
		user_m_tel = user_bean.getUser_m_tel();
		user_email = user_bean.getUser_email();
		user_pos = user_bean.getUser_pos();
		user_aut2 = user_bean.getUser_aut();
	}
	
		DeptBean dept_r [] = umd.getDeptAll();
		BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--


function PSDUp()
{
	var theForm = document.UserForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}

	theForm.cmd.value= "u";
	theForm.target="i_no";
	theForm.submit();
}
function CheckField()
{
	var theForm = document.UserForm;
	
	var paramObj = theForm.user_psd_a.value;
	
	var chk_eng = paramObj.search(/[a-zA-Z]/ig);
	var chk_num = paramObj.search(/[0-9]/g);
	var chk_spe = paramObj.search(/[~!@\#$%<>^&*\()\-=+_\']/ig);
	
	if(theForm.user_psd_b.value=="")
	{
		alert("변경전 비밀번호를 입력하십시요.");
		theForm.user_psd_b.focus();
		return false;
	}
	if(theForm.user_psd_a.value=="")
	{
		alert("변경후 비밀번호를 입력하십시요.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_b.value==theForm.user_psd_a.value)
	{
		alert("변경전,후 비밀번호가 동일합니다.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_a.value.length<8)
	{
		alert("비밀번호는 8자리 이상이여야 합니다.");	
		theForm.user_psd_a.focus();
		return false;
	}
	if((chk_eng < 0 && chk_num < 0) || (chk_eng < 0 && chk_spe < 0) || (chk_spe < 0 && chk_num < 0))
	{
		alert("비밀번호는 영문,숫자,특수문자 중\n2가지 이상의 조합이어야 합니다.");	
		theForm.user_psd_a.focus();
		return false;
	}
	
	return true;
}
//-->
</script>
<script language="javascript">
		// 최소길이 & 최대길이 제한
		var minimum = 8;
		var maximun = 12;

		function chkPw(obj, viewObj) {
			var paramVal = obj.value;	

			var msg = chkPwLength(obj);

			if(msg == "") msg = "";

			document.getElementById(viewObj).innerHTML=msg;
		}

		// 글자 갯수 제한
		function chkPwLength(paramObj) {
			var msg = "";
			var paramCnt = paramObj.value.length;

			if(paramCnt < minimum) {
				msg = "최소 암호 글자수는 <b>" + minimum + "</b> 입니다.";
			} else if(paramCnt > maximun) {
				msg = "최대 암호 글자수는 <b>" + maximun + "</b> 입니다.";
			} else {
				msg = chkPwNumber(paramObj);
			}

			return msg;
		}

		// 암호 유용성 검사
		function chkPwNumber(paramObj) {
			var  msg = "";
			
	  
			// 특수 문자 포함 이라면 주석을 바꿔 주시기 바랍니다.
			// if(!paramObj.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/))
			if(!paramObj.value.match(/([a-zA-Z0-9])|([a-zA-Z0-9])/)) {
				// msg = "비밀번호는 영어, 숫자, 특수문자의 조합으로 6~16자리로 입력해주세요.";
				msg = "비밀번호는 영어, 숫자의 조합으로 8~12자리로 입력해주세요.";
			} else {
				msg = chkPwContinuity(paramObj);
			}

			return msg;
		}

		
		
		// 암호 연속성 검사 및 동일 문자
		function chkPwContinuity(paramObj) {
			var msg = "";
			var SamePass_0 = 0; //동일문자 카운트
			var SamePass_1_str = 0; //연속성(+) 카운드(문자)
			var SamePass_2_str = 0; //연속성(-) 카운드(문자)
			var SamePass_1_num = 0; //연속성(+) 카운드(숫자)
			var SamePass_2_num = 0; //연속성(-) 카운드(숫자)

			var chr_pass_0;
			var chr_pass_1;
			var chr_pass_2;
			
			for(var i=0; i < paramObj.value.length; i++) {
				chr_pass_0 = paramObj.value.charAt(i);
				chr_pass_1 = paramObj.value.charAt(i+1);

				//동일문자 카운트
				if(chr_pass_0 == chr_pass_1)
				{
					SamePass_0 = SamePass_0 + 1
				}


				chr_pass_2 = paramObj.value.charAt(i+2);
				
				if(chr_pass_0.charCodeAt(0) >= 48 && chr_pass_0.charCodeAt(0) <= 57) {
					//숫자
					//연속성(+) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_num = SamePass_1_num + 1
					}
					
					//연속성(-) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_num = SamePass_2_num + 1
					}
				} else {
					//문자
					//연속성(+) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_str = SamePass_1_str + 1
					}
					
					//연속성(-) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_str = SamePass_2_str + 1
					}
				}
			}
			
			if(SamePass_0 > 1) {
				msg = "동일숫자 및 문자를 3번 이상 사용하면 비밀번호가 안전하지 못합니다.(ex : aaa, bbb, 111)";
			}

			if(SamePass_1_str > 1 || SamePass_2_str > 1 || SamePass_1_num > 1 || SamePass_2_num > 1)
			{
				msg = "연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.";
			}

			return msg;
		}	</script>
</head>
<body  onLoad="self.focus()">
<center>
<form action="./pass_null_ui.jsp" name="UserForm" method="POST" >
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="cool" value="<%=cool%>">
<table border=0 cellspacing=1 cellpadding=0 width=300>
	<tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=300>
            <tr> 
              <td width=140 class=title>이름</td>
              <td width=160 align=center><%=user_nm%></td>
            </tr>
            <tr> 
              <td class=title>변경전 비밀번호</td>
              <td align=left>&nbsp; <input type="password" name="user_psd_b" value="<%=user_psd%>" size="18" class=text readonly></td>
            </tr>
            <tr> 
              <td class=title>변경후 비밀번호</td>
              <td align=left>&nbsp; <input type="password" name="user_psd_a" value="" size="18" class=text onKeyUp="javascript:chkPw(this, 'chkPwView');"></td>
            </tr>
			<tr>
			<td colspan=2><span id="chkPwView"></span></td>
			</tr>
            <tr> 
              <td colspan="2" align=center valign=bottom><table width="300" border="0" cellspacing="1" cellpadding="0">
                  <tr> 
                    <td width="51" align="right" valign="bottom">※&nbsp;</td>
                    <td width="246" valign="bottom"> 비밀번호는 <font color="#FF0000" style="strong">8자리이상 
                      문자와 숫자</font>를</td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                    <td>혼용하여 입력하시기 바랍니다.</td>
                  </tr>
                </table> </td>
            </tr>
          </table>
        </td>
    </tr>
    <tr>
        <td>
        <table border="0" cellspacing="3" width=300>
        <tr><td align="right"><a href="javascript:PSDUp()"><img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="수정"></a></td></tr>
        </table>
       </td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>