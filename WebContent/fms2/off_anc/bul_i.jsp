<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%

	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int b_id = 0;
	String user_id = "";
	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String reg_dt = "";
	String exp_dt = "";
	String title = "";
	String content = "";

	int 	vist_cnt = 0;
    String auth_rw = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	reg_dt = Util.getDate();
	user_id = ck_acar_id;
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();
	
%>
<html>

<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<SCRIPT SRC="../lib/ckeditor/ckeditor.js"></SCRIPT>

<script language='javascript'>
<!--


function AncReg()
{
  
   	var theForm = document.AncRegForm;
   	
	if(theForm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		
	if (  CKEDITOR.instances.content.getData() == ''  ) {
      	alert('내용을 입력하십시오');	theForm.content.focus();	
		return;	
   }
	
	if(get_length(theForm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}		
	
	if(confirm('등록하시겠습니까?')){
		//document.domain = "amazoncar.co.kr";
		theForm.cmd.value = "i";
		theForm.action='bul_null_ui.jsp';		
		theForm.target="i_no";
		theForm.submit();
	}
	
}

function AncClose()
{

	self.close();
	window.close();
}

function ChangeDT()
{
	var theForm = document.AncRegForm;
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


-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
<form  name="AncRegForm" method="post" >
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="b_id" 	value="<%=b_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
	<input type="hidden" name="cmd" 	value="">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > 사내 게시판 > <span class=style5>사내 게시판 등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="20%">작성자</td>
					<td width="30%">&nbsp;<%=user_nm%></td>
					<td class="title" width="20%">부서</td>
					<td width="30%">&nbsp;<%=dept_nm%></td>
				</tr>
				<tr>
					<td class="title" width="15%">작성일</td>
					<td>&nbsp;<%=reg_dt%></td>
					<td class="title" width="15%">만료일</td>
					<td>&nbsp;<input type='text' name="exp_dt"  size='28' class='text' onBlur="javascript:ChangeDT()"> </td>
				</tr>
				<tr>
					<td class="title" width="15%">제목</td>
					 <td colspan="3">&nbsp;<input type='text' name="title" id="title" size='80'></td>			
				</tr>									
				<tr>
					<td class="title" width="15%">내용</td>
					<td colspan="3">&nbsp;
					<textarea name="content" id="content"> </textarea></td>
					<script>
					CKEDITOR.replace( 'content', {
						toolbar: [
						    { name: 'links', items:['Link']},
							{ name: 'basicstyles', items: [ 'Bold', 'Italic'] },
							{ name: 'insert', items: ['Table','HorizontalRule'] },
							{ name: 'tools', items:['Maximize']}
						],
						height:"300px",
						enterMode: CKEDITOR.ENTER_DIV
					});
					</script>
			
				</tr>
				
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'> <a href="javascript:AncReg()" ><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>
		<a href='javascript:AncClose();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a></td>
	
	</tr>
</table>

</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>