<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%	
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String user_id = "";
	String auth_rw = "";
	String reg_dt = "";
	String cmd = "";
	
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	String user_nm = u_bean.getUser_nm();


%>
<HTML>
<HEAD>
<TITLE>::: ���� ����, ���� ������ ���丮�� ��ⷻƮ ���ÿ��� �Ƹ���ī :::</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function data_save()
{

	var fm = document.form1;
			
//	if(fm.est_nm.value == '')				{ alert('����/���θ��� �Է��Ͻʽÿ�'); 		fm.est_nm.focus(); 		return;	}

	fm.cmd.value = 'i';
	fm.target="i_no";
	fm.action="biz_tel_mng_a.jsp";
	fm.submit();

}



//-->
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
day = new Date();
miVisit = day.getTime();

function clock() {
	dayTwo = new Date();
	hrNow = dayTwo.getHours();
	mnNow = dayTwo.getMinutes();	
	scNow = dayTwo.getSeconds();
	miNow = dayTwo.getTime();
	

	if (hrNow == 0) {
		hour = 12;
		ap = " AM";
		} else if(hrNow <= 11) {
			ap = " AM";
			hour = hrNow;
		} else if(hrNow == 12) {
			ap = " PM";
			hour = 12;
		} else if (hrNow >= 13) {
			hour = (hrNow - 12);
			ap = " PM";
		}
	if (hrNow >= 13) {
		hour = hrNow - 12;
		}
	if (mnNow <= 9) {
		min = "0" + mnNow;
		}
		else (min = mnNow)
			if (scNow <= 9) {
				secs = "0" + scNow;
			} else {
				secs = scNow;
		}

	time = hour + "�� " + min + "��";
//	alert(document.form1.tel_time);
//	document.form1.tel_time.value = time;
	self.status = time;
	setTimeout('clock()', 1000);
}

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

//addLoadEvent(function() {
//  clock();
//}); 

clock();
// -->
</SCRIPT>
</HEAD>
<body>
<form action="" name="form1" method="POST" >

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �����ý��� > <span class=style5>������ȭ����� ���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="20%" class="title">�ۼ���</td>
					<td width="30%" align="center"><%=user_nm%></td>
					<td width="20%" class="title">�ۼ���</td>
					<td width="30%" align="center"><%=reg_dt%></td>
				</tr>
				<tr>
					<td width="20%" class="title">��㱸��</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_gubun" size='78' class='text' value="�繫�Ƿ� �ɷ� �� ��ȭ"></td>
				</tr>
				<tr>
					<td width="20%" class="title">��㰳�ýð�</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_time" size='78' class='text' value='__�� __��' ></td>
				</tr>
				<tr>
					<td width="20%" class="title">�������</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_car" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">��������</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_gubun" value='1' checked >����
						&nbsp;<input type='radio' name="tel_car_gubun" value='2' >�縮��
						&nbsp;<input type='radio' name="tel_car_gubun" value='3' >���� �� �縮��
						&nbsp;<input type='radio' name="tel_car_gubun" value='4' >��Ÿ
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">�뵵����</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_st" value='1' checked >��Ʈ
						&nbsp;<input type='radio' name="tel_car_st" value='2' >����
						&nbsp;<input type='radio' name="tel_car_st" value='3' >��Ʈ �� ����
						&nbsp;<input type='radio' name="tel_car_st" value='4' >��Ÿ
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">��������</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_car_mng" value='1' checked >�⺻��
						&nbsp;<input type='radio' name="tel_car_mng" value='2' >�Ϲݽ�
						&nbsp;<input type='radio' name="tel_car_mng" value='3' >�⺻�� �� �Ϲݽ�
						&nbsp;<input type='radio' name="tel_car_mng" value='4' >��Ÿ
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">��ü��</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_nm" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">�����</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_mng" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">����ó</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_firm_tel" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">��డ�ɼ�</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_est_yn" value='1' checked >��Ÿ
						&nbsp;<input type='radio' name="tel_est_yn" value='2' >��
						&nbsp;<input type='radio' name="tel_est_yn" value='3' >��
						&nbsp;<input type='radio' name="tel_est_yn" value='4' >��
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">��������</td>
					<td colspan="3" >
						&nbsp;<input type='radio' name="tel_yp_gubun" value='1' checked >��
						&nbsp;<input type='radio' name="tel_yp_gubun" value='2' >�ڵ����������
						&nbsp;<input type='radio' name="tel_yp_gubun" value='3' >����������Ʈ
						&nbsp;<input type='radio' name="tel_yp_gubun" value='4' >������� �Ǵ� ������Ʈ
						&nbsp;<input type='radio' name="tel_yp_gubun" value='5' >��Ÿ
					</td>
				</tr>
				<tr>
					<td width="20%" class="title">��������̸�</td>
					<td colspan="3" >&nbsp;<input type='text' name="tel_yp_nm" size='78' class='text'></td>
				</tr>
				<tr>
					<td class="title">����� �� �޸�</td>
					<td colspan="3" align=center><textarea name="tel_note" cols='76' rows='13' class='default'> </textarea></td>
				</tr>
				<tr>
					<td width="20%" class="title">��࿩��</td>
					<td width="40%">
						&nbsp;<input type='radio' name="tel_esty_yn" value='1' >��Ȯ��
						&nbsp;<input type='radio' name="tel_esty_yn" value='2' >���ü��
						&nbsp;<input type='radio' name="tel_esty_yn" value='3' >����ü��
					</td>
					<td width="20%" class="title">��࿩���Է���</td>
					<td width="20%">&nbsp;<input type='text' name="tel_esty_dt" size='20' class='text' value='<%=AddUtil.getDate()%>'></td>
				</tr>
			</table>
		</td>
	</tr>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="reg_dt" value="<%=reg_dt%>">
<input type="hidden" name="cmd" value="">
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>�� ��ϴ�� : ���뿩 �������� �� �繫�Ƿ� �ɷ� �� ��ȭ�� ���� ���<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���� �޴���ȭ�� �ɷ��� �� �� ����Ʈ ��������� �Է����� �ʽ��ϴ�.<br>
		�� �� ���� �� �Ϻ� �׸� �Է��ص� �˴ϴ�.
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:data_save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>



</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</BODY>
</HTML>