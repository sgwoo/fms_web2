<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%	
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String user_id = "";
	String reg_dt = "";
	String est_nm = "";
	String est_agnt = "";
	String auth_rw = "";
	String est_st = "";
	String est_tel = "";
	String cmd = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	String user_nm = u_bean.getUser_nm();


%>
<HTML>
<HEAD>
<TITLE>::: 고객상담요청 등록 :::</TITLE>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function save(){

	
	data_save();
//	two_save();
}

function data_save()
{
	var fm = document.form1;
	fm.cmd.value = "one";
		
	if(fm.est_nm.value == '')				{ alert('성명/법인명을 입력하십시오'); 		fm.est_nm.focus(); 		return;	}
	
	fm.target="i_no";
	fm.action="guest_sd_a.jsp";
	fm.submit();
}

function two_save()
{
	var fm = document.form1;
	fm.cmd.value = "two";
	fm.target="i_no";
	fm.action="guest_sd_a.jsp";
	fm.submit();
	
setTimeout("two_save()",60000);
}
//-->
</SCRIPT>
</HEAD>
<body onLoad="">
<form action="" name="form1" method="POST" >
<input type='hidden' name='cmd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>고객상담요청 등록</span></span></td>
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
					<td width="20%" class="title">작성자</td>
					<td width="30%">&nbsp;&nbsp;&nbsp;<%=user_nm%></td>
					<td width="20%" class="title">작성일</td>
					<td width="30%">&nbsp;&nbsp;<%=reg_dt%></td>
				</tr>
				<tr>
					<td width="20%" class="title">성명/법인명</td>
					<td colspan="3" >&nbsp;<input type='text' name="est_nm" size='30' class='text'><font color="red">※필수입력</font></td>
				</tr>
				<tr>
					<td width="20%" class="title">담당자</td>
					<td colspan="3" >&nbsp;<input type='text' name="est_agnt" size='78' class='text'></td>
				</tr>
				<tr>
					<td width="20%" class="title">연락처</td>
					<td colspan="3" >&nbsp;<input type='text' name="est_tel" size='78' class='text'></td>
				</tr>
				<tr>
					<td class="title">내용</td>
					<td colspan="3" align=center><textarea name="etc" cols='76' rows='13' class='default'> </textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<input type="hidden" name="est_id" value="">

	<input type="hidden" name="user_id" value="<%=user_id%>">
	

	<input type="hidden" name="est_st" value="3">	
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:save();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
				    
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