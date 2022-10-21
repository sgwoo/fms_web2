<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="b_bean" class="acar.off_anc.BulBean" scope="page"/>

<%
	
	OffBulDatabase oad = OffBulDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	int b_id = 0;
	String user_id = "";
	String acar_id = "";
	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String reg_dt = "";
	String exp_dt = "";
	String title = "";
	String content = "";
    String auth_rw = "";
    String cmd = "";

	int count = 0;
	

	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("b_id") != null) b_id = Util.parseInt(request.getParameter("b_id"));
	
	acar_id = login.getCookieValue(request, "acar_id");
	
	b_bean = oad.getBulBean(b_id);

	user_id = b_bean.getUser_id();
	user_nm = b_bean.getUser_nm();
	dept_nm = b_bean.getDept_nm();
	reg_dt = b_bean.getReg_dt();
	exp_dt = b_bean.getExp_dt();
	title = b_bean.getTitle();
	content = b_bean.getContent();

	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title><%=title%></title>
<script language="JavaScript" src="/include/common.js"></script>
<SCRIPT SRC="../lib/ckeditor/ckeditor.js"></SCRIPT>
<script language='javascript'>
<!--
function AncUp()
{
	var theForm = document.AncUpForm;
	if(theForm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
	else if(theForm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}	
	
	if(confirm('수정하시겠습니까?')){
		document.domain = "amazoncar.co.kr";
		theForm.cmd.value = "u";
		theForm.action='bul_null_ui.jsp';		
		theForm.target="i_no";
		theForm.submit();
	}
		
}

function AncDl()
{
	var theForm = document.AncUpForm;
	if(!confirm('삭제하시겠습니까?'))
		return;	
	theForm.cmd.value = "d";
	theForm.action = "bul_null_ui.jsp";	
	theForm.target="i_no";
	theForm.submit();
}

function ChangeDT()
{
	var theForm = document.AncUpForm;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//리스트 가기	
function go_to_list()
{
		var fm = document.AncUpForm;
				
		var auth_rw = fm.auth_rw.value;
	
		location = "bul_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw="+auth_rw;
	
}	


-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
<form  name="AncUpForm" method="post" >
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="b_id" 	value="<%=b_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="cmd" 	value="">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사내 게시판 > <span class=style5><%=b_bean.getTitle()%>-수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'> <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				
				<tr>
					<td class="title">작성자</td>
					<td align="center"><%=user_nm%></td>
					<td class="title">부서</td>
					<td align="center"><%=dept_nm%></td>
				</tr>
				<tr>
					<td class="title" width="100">작성일</td>
					<td align="center" width="300"><%=reg_dt%></td>
					<td class="title" width="100">만료일</td>
					<td align="center" width="300"><input type='text' name="exp_dt" value="<%=exp_dt%>" size='28' class='text' onBlur="javascript:ChangeDT()"></td>
				</tr>
				<tr>
					<td class="title">제목</td>
					<td colspan="3" align="center"><input type='text' name="title" value="<%=title%>" size='110' class='text'></td>
				</tr>									
				<tr>
					<td class="title">내용</td>
					<td colspan="3" align="center"><textarea id="content" name="content" cols='110' rows='20'><%=content%></textarea>
						<script>
					CKEDITOR.replace( 'content', {
						toolbar: [
						    { name: 'links', items:['Link']},
							{ name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
							{ name: 'insert', items: ['Table','HorizontalRule'] },
							{ name: 'tools', items:['Maximize']}
						],
						height:"300px",
						enterMode: CKEDITOR.ENTER_DIV
					});
					</script>	
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	<tr>
		<td colspan='4' align='right'><a href="javascript:AncUp()" ><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a> &nbsp;
			&nbsp;&nbsp;<a href="javascript:AncDl()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align=absmiddle border=0></a>
		</td>
	</tr>
</table>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="../js/datepicker/jquery-ui.min.js"></script><!-- date picker j s 2018.02.06 -->
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>
</body>
</html>