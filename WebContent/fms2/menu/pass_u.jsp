<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page 	= request.getParameter("from_page")==null? "":request.getParameter("from_page");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

	UserMngDatabase umd = UserMngDatabase.getInstance();
	//String user_id = "";
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
	if(!confirm('?????????????????'))
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
		alert("?????? ?????????? ????????????."); 
		theForm.user_psd_b.focus();
		return false;
	}
	if(theForm.user_psd_a.value=="")
	{
		alert("?????? ?????????? ????????????.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_b.value==theForm.user_psd_a.value)
	{
		alert("??????,?? ?????????? ??????????.");
		theForm.user_psd_a.focus();
		return false;
	}
	// ?????????? ???? 
	if(theForm.dept_id.value != '8888' ) {
		if(theForm.user_psd_a.value.length<8)
		{
			alert("?????????? 8???? ?????????? ??????.");	
			theForm.user_psd_a.focus();
			return false;
		}
	

		//if((chk_eng < 0 && chk_num < 0) || (chk_eng < 0 && chk_spe < 0) || (chk_spe < 0 && chk_num < 0))
		if(chk_eng < 0 || chk_num < 0 || chk_spe < 0)
		{
			//alert("?????????? ????,????,???????? ??\n2???? ?????? ?????????? ??????.");	
			alert("?????????? ????,????,?????????? ?????????? ??????.");
			theForm.user_psd_a.focus();
			return false;
		}
		
	}
	
	return true;
}
//-->
</script>
<script language="javascript">
		// ???????? & ???????? ????
		var minimum = 8;
		var maximun = 12;

		function chkPw(obj, viewObj) {
			var paramVal = obj.value;	

			var msg = chkPwLength(obj);

			if(msg == "") msg = "";

			document.getElementById(viewObj).innerHTML=msg;
		}

		// ???? ???? ????
		function chkPwLength(paramObj) {
			var msg = "";
			var paramCnt = paramObj.value.length;

			if(paramCnt < minimum) {
				msg = "???? ???? ???????? <b>" + minimum + "</b> ??????.";
			} else if(paramCnt > maximun) {
				msg = "???? ???? ???????? <b>" + maximun + "</b> ??????.";
			} else {
				msg = chkPwNumber(paramObj);
			}

			return msg;
		}

		// ???? ?????? ????
		function chkPwNumber(paramObj) {
			var  msg = "";
			
	  
			// ???? ???? ???? ?????? ?????? ???? ?????? ????????.
			if(!paramObj.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)){
			//if(!paramObj.value.match(/([a-zA-Z0-9])|([a-zA-Z0-9])/)) {
				 msg = "?????????? ????, ????, ?????????? ???????? 8~12?????? ????????????.";
				//msg = "?????????? ????, ?????? ???????? 8~12?????? ????????????.";
			} else {
				msg = chkPwContinuity(paramObj);
			}

			return msg;
		}

		
		
		// ???? ?????? ???? ?? ???? ????
		function chkPwContinuity(paramObj) {
			var msg = "";
			var SamePass_0 = 0; //???????? ??????
			var SamePass_1_str = 0; //??????(+) ??????(????)
			var SamePass_2_str = 0; //??????(-) ??????(????)
			var SamePass_1_num = 0; //??????(+) ??????(????)
			var SamePass_2_num = 0; //??????(-) ??????(????)

			var chr_pass_0;
			var chr_pass_1;
			var chr_pass_2;
			
			for(var i=0; i < paramObj.value.length; i++) {
				chr_pass_0 = paramObj.value.charAt(i);
				chr_pass_1 = paramObj.value.charAt(i+1);

				//???????? ??????
				if(chr_pass_0 == chr_pass_1)
				{
					SamePass_0 = SamePass_0 + 1
				}


				chr_pass_2 = paramObj.value.charAt(i+2);
				
				if(chr_pass_0.charCodeAt(0) >= 48 && chr_pass_0.charCodeAt(0) <= 57) {
					//????
					//??????(+) ??????
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_num = SamePass_1_num + 1
					}
					
					//??????(-) ??????
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_num = SamePass_2_num + 1
					}
				} else {
					//????
					//??????(+) ??????
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_str = SamePass_1_str + 1
					}
					
					//??????(-) ??????
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_str = SamePass_2_str + 1
					}
				}
			}
			
			if(SamePass_0 > 1) {
				msg = "???????? ?? ?????? 3?? ???? ???????? ?????????? ???????? ????????.(ex : aaa, bbb, 111)";
			}

			if(SamePass_1_str > 1 || SamePass_2_str > 1 || SamePass_1_num > 1 || SamePass_2_num > 1)
			{
				msg = "?????? ??????(123 ???? 321, abc, cba ??)??\n 3?? ???? ???? ?? ?? ????????.";
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
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="dept_id" value="<%=dept_id%>">
<table border=0 cellspacing=1 cellpadding=0 width=350>
	<tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=350>
            <tr> 
              <td width=140 class=title>????</td>
              <td width=210 align=center><%=user_nm%></td>
            </tr>
            <tr> 
              <td class=title>?????? ????????</td>
              <td align=center><input type="password" name="user_psd_b" value="<%=user_psd%>" size="25" class=text readonly></td>
            </tr>
            <tr> 
              <td class=title>?????? ????????</td>
              <td align=center><input type="password" name="user_psd_a" value="" size="25" class=text onKeyUp="javascript:chkPw(this, 'chkPwView');"></td>
            </tr>
			<tr>
			<td colspan=2><span id="chkPwView"></span></td>
			</tr>
            <tr> 
              <td colspan="2" align=center valign=bottom><table width="330" border="0" cellspacing="1" cellpadding="0">
                  <tr> 
                    <td width="10" align="right" valign="bottom">??&nbsp;</td>
                    <td width="320" valign="bottom"> ?????????? <font color="#FF0000" style="strong">8???????? 
                      ?????? ????, ????????('#'????)</font>??</td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                    <td>???????? ?????????? ????????.</td>
                  </tr>
                </table> </td>
            </tr>
          </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>    
           <td align="center">
             <a href="javascript:PSDUp()"><img src=/acar/images/pop/button_modify.gif border=0></a>
             &nbsp;&nbsp;&nbsp;
	         <a href="javascript:self.close();window.close();"><img src=/acar/images/pop/button_close.gif border=0></a>
           </td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>