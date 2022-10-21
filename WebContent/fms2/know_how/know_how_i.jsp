<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.know_how.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	Know_how_Database kh_db = Know_how_Database.getInstance();	

	int know_how_id = 0;
	String user_id = "";
	String reg_dt = "";
	String title = "";
	String content = "";
    String auth_rw = "";
    String cmd = "";
	String know_how_st = "";

	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	String user_nm = u_bean.getUser_nm();
	
	know_how_id = kh_db.getKnowHowCount();
	
%>
<html>
<head>
<title>FMS</title>
<link href="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet"> 
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.css" rel="stylesheet">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script> 
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.js"></script>
<script src="/include/common.js"></script>

<script>
function save()
{
	var fm = document.form;
	//alert("check");

	if(fm.title.value == '')		{	alert('������ �Է��Ͻʽÿ�');	fm.title.focus();	return;	}
	//else if(fm.content.value == '')	{	alert('������ �Է��Ͻʽÿ�');	fm.content.focus();	return;	}
	 if(get_length(fm.content.value) > 4000){		
		alert("4000�� ������ �Է��� �� �ֽ��ϴ�.");		return;		} 
	
	/* if (  CKEDITOR.instances.content.getData() == ''  ) {
      	alert('������ �Է��Ͻʽÿ�');	fm.content.focus();	
		return;	
   } */
     
  	fm.cmd.value = "i";

	if(confirm('����Ͻðڽ��ϱ�?')){
	
		fm.action='know_how_a.jsp';		
		fm.target="i_no";
		fm.submit();
	}
	
}

function Know_how_Close()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}

function ChangeDT()
{
	var theForm = document.form;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}

//��������
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
//����Ʈ ����	

function go_to_list()
{
	var fm = document.form;
	fm.action = "./know_how_frame.jsp";
	fm.target = 'd_content';
	fm.submit();
}

</script>
<script>
$(document).ready(function() {
	$('#summernote').summernote({
  	height:400,
  	callbacks: { // �ݹ��� ���
                 // �̹����� ���ε��� ��� �̺�Ʈ�� �߻�
  		onImageUpload: function(files, editor, welEditable) {
    	sendFile(files, this);
		}
  	}
  });
});
 
function sendFile(files, editor) {
	for (var i = 0; i < files.length; i++) {
		var file = files[i];
      	var tokens = file.name.split('.');
       
      	tokens.pop();
     	var content_seq = '<%=know_how_id%>'; 
     	var file_name = files[i].name;
  		var file_size = files[i].size;
     	var file_type = files[i].type;
      
        // ���� ������ ���� ������
		data = new FormData();
   		data.append("uploadFile", file);
   		data.append("content_code", "KNOW_HOW");
    	data.append("content_seq", content_seq);
    	data.append("file_name", file_name);
   		data.append("file_size", file_size);
   		data.append("file_type", file_type); 
   
	   $.ajax({ // ajax�� ���� ���� ���ε� ó��
	       data : data,
	       type : "POST",
	       url : "https://fms3.amazoncar.co.kr/fms2/attach/summernote_imageUpload.jsp",
	       cache : false,
	       contentType : false,
	       processData : false,
	       success : function(data) { // ó���� ������ ���
	                // �����Ϳ� �̹��� ���
	       	$(editor).summernote('editor.insertImage', data.url);
	       }
	   }); 
  	}
}

// Ư������ ����	2018.01.09		'�� "�� �����ϱ�� ���� 2018.02.06
var regex = /['"]/gi;
var title;
var content;

$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});	// ����
$("#content").bind("keyup",function(){content = $("#content").val();if(regex.test(content)){$("#content").val(content.replace(regex,""));}});	// ������
</script>
<style>
.borSt {
	 border: 1px solid #b0baec;
    }
button[data-original-title="Video"]{ display: none; }
</style>
</head>
<body onLoad="javascript:self.focus()" >
<form  name="form" method="post" >
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="know_how_id" value="<%=know_how_id%>"> 
<%-- <input type="hidden" name="know_how_st" value="<%=know_how_st%>"> --%>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="content_seq" value="KNOW_HOW">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
		<table width=100% border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7	height=33>	</td>
				<td class=bar>&nbsp;&nbsp;&nbsp;
				<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;
				<span class=style1>Master> �Ƹ���ī ����IN > <span class=style5>�������</span></span></td>
				<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7	height=33></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
	<td>
	<table width="100%">
	<tr>
		<td align="right">
		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true">
		<img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"> </a></td>
	</tr>
	</table>
	</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="10%" class="title borSt" >ī�װ�</td>
					<td class="borSt">
						&nbsp;&nbsp;<INPUT type="radio" name="know_how_st" value="1" checked >����Q&amp;A&nbsp;&nbsp; 
						<INPUT type="radio" name="know_how_st" value="2" >��������&nbsp;&nbsp;
					</td>
					<td width="10%" class="title borSt" >��������</td>
					<td  class="borSt">&nbsp;
					<select name="p_view">
								<option value="">����</option>
								<option value="Y">���¾�ü</option>
								<option value="A">������Ʈ</option>
								<option value="J">���¾�ü/������Ʈ</option>
					</select>&nbsp;(�����¾�ü/������Ʈ��  ��ȸ�����ϵ��� ������ �� �ֽ��ϴ�.)					
					</td>
				</tr>
				<tr>
					<td width="10%" class="title borSt">�ۼ���</td>
					<td width="40%" class="borSt">&nbsp;&nbsp;&nbsp;<%=user_nm%></td>
					<td width="10%" class="title borSt">�ۼ���</td>
					<td width="40%" class="borSt">&nbsp;&nbsp;<%=reg_dt%></td>
	
				</tr>
				<tr>
					<td align="center" class="title borSt">����</td>
					<td colspan="3" align="" class="borSt">&nbsp;&nbsp;<input type='text' name="title" size='140' class='text'></td>
				</tr>
				<tr>
					<td class="title borSt">����</td>
					<td colspan="3"><textarea name="content" id="summernote" ></textarea></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:save();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_save.gif" align=absmiddle border=0></a>&nbsp;&nbsp;
				    <a href="javascript:Know_how_Close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div>
	<table id="file-upload-form" style="display: block;"></table>
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0"  frameborder="0" noresize> </iframe>
</body>
</html>
