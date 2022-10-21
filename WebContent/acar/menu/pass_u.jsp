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
	if(!confirm('�����Ͻðڽ��ϱ�?'))
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
		alert("������ ��й�ȣ�� �Է��Ͻʽÿ�.");
		theForm.user_psd_b.focus();
		return false;
	}
	if(theForm.user_psd_a.value=="")
	{
		alert("������ ��й�ȣ�� �Է��Ͻʽÿ�.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_b.value==theForm.user_psd_a.value)
	{
		alert("������,�� ��й�ȣ�� �����մϴ�.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_a.value.length<8)
	{
		alert("��й�ȣ�� 8�ڸ� �̻��̿��� �մϴ�.");	
		theForm.user_psd_a.focus();
		return false;
	}
	if((chk_eng < 0 && chk_num < 0) || (chk_eng < 0 && chk_spe < 0) || (chk_spe < 0 && chk_num < 0))
	{
		alert("��й�ȣ�� ����,����,Ư������ ��\n2���� �̻��� �����̾�� �մϴ�.");	
		theForm.user_psd_a.focus();
		return false;
	}
	
	return true;
}
//-->
</script>
<script language="javascript">
		// �ּұ��� & �ִ���� ����
		var minimum = 8;
		var maximun = 12;

		function chkPw(obj, viewObj) {
			var paramVal = obj.value;	

			var msg = chkPwLength(obj);

			if(msg == "") msg = "";

			document.getElementById(viewObj).innerHTML=msg;
		}

		// ���� ���� ����
		function chkPwLength(paramObj) {
			var msg = "";
			var paramCnt = paramObj.value.length;

			if(paramCnt < minimum) {
				msg = "�ּ� ��ȣ ���ڼ��� <b>" + minimum + "</b> �Դϴ�.";
			} else if(paramCnt > maximun) {
				msg = "�ִ� ��ȣ ���ڼ��� <b>" + maximun + "</b> �Դϴ�.";
			} else {
				msg = chkPwNumber(paramObj);
			}

			return msg;
		}

		// ��ȣ ���뼺 �˻�
		function chkPwNumber(paramObj) {
			var  msg = "";
			
	  
			// Ư�� ���� ���� �̶�� �ּ��� �ٲ� �ֽñ� �ٶ��ϴ�.
			// if(!paramObj.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/))
			if(!paramObj.value.match(/([a-zA-Z0-9])|([a-zA-Z0-9])/)) {
				// msg = "��й�ȣ�� ����, ����, Ư�������� �������� 6~16�ڸ��� �Է����ּ���.";
				msg = "��й�ȣ�� ����, ������ �������� 8~12�ڸ��� �Է����ּ���.";
			} else {
				msg = chkPwContinuity(paramObj);
			}

			return msg;
		}

		
		
		// ��ȣ ���Ӽ� �˻� �� ���� ����
		function chkPwContinuity(paramObj) {
			var msg = "";
			var SamePass_0 = 0; //���Ϲ��� ī��Ʈ
			var SamePass_1_str = 0; //���Ӽ�(+) ī���(����)
			var SamePass_2_str = 0; //���Ӽ�(-) ī���(����)
			var SamePass_1_num = 0; //���Ӽ�(+) ī���(����)
			var SamePass_2_num = 0; //���Ӽ�(-) ī���(����)

			var chr_pass_0;
			var chr_pass_1;
			var chr_pass_2;
			
			for(var i=0; i < paramObj.value.length; i++) {
				chr_pass_0 = paramObj.value.charAt(i);
				chr_pass_1 = paramObj.value.charAt(i+1);

				//���Ϲ��� ī��Ʈ
				if(chr_pass_0 == chr_pass_1)
				{
					SamePass_0 = SamePass_0 + 1
				}


				chr_pass_2 = paramObj.value.charAt(i+2);
				
				if(chr_pass_0.charCodeAt(0) >= 48 && chr_pass_0.charCodeAt(0) <= 57) {
					//����
					//���Ӽ�(+) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_num = SamePass_1_num + 1
					}
					
					//���Ӽ�(-) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_num = SamePass_2_num + 1
					}
				} else {
					//����
					//���Ӽ�(+) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_str = SamePass_1_str + 1
					}
					
					//���Ӽ�(-) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_str = SamePass_2_str + 1
					}
				}
			}
			
			if(SamePass_0 > 1) {
				msg = "���ϼ��� �� ���ڸ� 3�� �̻� ����ϸ� ��й�ȣ�� �������� ���մϴ�.(ex : aaa, bbb, 111)";
			}

			if(SamePass_1_str > 1 || SamePass_2_str > 1 || SamePass_1_num > 1 || SamePass_2_num > 1)
			{
				msg = "���ӵ� ���ڿ�(123 �Ǵ� 321, abc, cba ��)��\n 3�� �̻� ��� �� �� �����ϴ�.";
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
              <td width=140 class=title>�̸�</td>
              <td width=160 align=center><%=user_nm%></td>
            </tr>
            <tr> 
              <td class=title>������ ��й�ȣ</td>
              <td align=left>&nbsp; <input type="password" name="user_psd_b" value="<%=user_psd%>" size="18" class=text readonly></td>
            </tr>
            <tr> 
              <td class=title>������ ��й�ȣ</td>
              <td align=left>&nbsp; <input type="password" name="user_psd_a" value="" size="18" class=text onKeyUp="javascript:chkPw(this, 'chkPwView');"></td>
            </tr>
			<tr>
			<td colspan=2><span id="chkPwView"></span></td>
			</tr>
            <tr> 
              <td colspan="2" align=center valign=bottom><table width="300" border="0" cellspacing="1" cellpadding="0">
                  <tr> 
                    <td width="51" align="right" valign="bottom">��&nbsp;</td>
                    <td width="246" valign="bottom"> ��й�ȣ�� <font color="#FF0000" style="strong">8�ڸ��̻� 
                      ���ڿ� ����</font>��</td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                    <td>ȥ���Ͽ� �Է��Ͻñ� �ٶ��ϴ�.</td>
                  </tr>
                </table> </td>
            </tr>
          </table>
        </td>
    </tr>
    <tr>
        <td>
        <table border="0" cellspacing="3" width=300>
        <tr><td align="right"><a href="javascript:PSDUp()"><img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="����"></a></td></tr>
        </table>
       </td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

</body>
</html>