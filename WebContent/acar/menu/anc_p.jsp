<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");

	String end_yn = ""; //����Ϸ�
	String com_st = "" ;  // �߰�
	String bbs_st = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	OffAncDatabase oad = OffAncDatabase.getInstance();

	//�������� �Ѱ� ��ȸ
	a_bean = oad.getAncLastBeanP();

	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//��� ���
function Comment_save(){
		var fm = document.AncDispForm;
		if(fm.bbs_id.value == ''){ 		alert('�Խù� ���̵� �����ϴ�.'); return; }		
		if(fm.acar_id.value == ''){ 	alert('�α��ε� ���̵� �����ϴ�.'); return; }
		if(fm.comment.value == ''){ 	alert('����� ������ �Է��Ͻʽÿ�'); return; }
		fm.action = 'anc_comment_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}

function UpDisp()
{
	var fm = document.AncDispForm;
	
	fm.action = 'https://fms3.amazoncar.co.kr/fms2/off_anc/anc_u.jsp?ck_acar_id=<%=acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.submit();
}

//�˾�â �ݱ�
function AncClose(){
	self.close();
}

//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/bulletin/"+theURL;
		window.open(theURL,winName,features);
		
		file_down_history();
	}
	
	//���ϴٿ��̷�
	function file_down_history(){
		var fm = document.AncDispForm;
		fm.action = 'http://fms1.amazoncar.co.kr/acar/off_anc/file_down_history.jsp?file_nm=<%= a_bean.getAtt_file1() %>&user_id=<%=acar_id%>';
		fm.target = 'i_no';
		fm.submit();		
	}
	


-->
</script>
<script language="JavaScript">
<!-- 
function notice_setCookie( name, value, expiredays )
    {
        var todayDate = new Date();
        todayDate.setDate( todayDate.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
        }


function notice_closeWin() 
{ 
        if ( document.forms[0].Notice.checked ) 
                notice_setCookie( "Notice", "done" , 1); // 1=�Ϸ��� ����â ���� ����
        self.close(); 
}
function na_call(str){  eval(str);}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
<form  name="AncDispForm" method="post">
	<input type="hidden" name="user_id" value="<%=a_bean.getUser_id()%>">
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="acar_id" value="<%=acar_id%>">

	<input type="hidden" name="cmd" value="">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5> ��������</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	
	<tr>
		<td colspan='4' align='right'>
		<%	if(acar_id.equals(a_bean.getUser_id()) || nm_db.getWorkAuthUser("������",acar_id)){%>	
		 <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src="../images/center/button_modify.gif" align=absmiddle border=0></a> 
		<%	}%>
		<a href="javascript:AncClose()" onMouseOver="window.status=''; return true"><img src="../images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;</td>
	</tr>

	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width="100%">
			<tr>
				<td class="title" colspan="2">���� ��ϵ� ī�װ�</td>
				<td align="center" colspan="2"><b>
				<%if(a_bean.getBbs_st().equals("1")){%>�Ϲݰ���
				<%}else if(a_bean.getBbs_st().equals("2")){%>�ֱٴ���
				<%}else if(a_bean.getBbs_st().equals("3")){%>�Ǹ�����
				<%}else if(a_bean.getBbs_st().equals("4")){%>��������
				<%}else if(a_bean.getBbs_st().equals("5")){%>������
				<%}else if(a_bean.getBbs_st().equals("6")){%>���� �� �λ�
				<%}%> 
				</b></td>
			</tr>
			<tr>
				<td class="title" width=15%>�ۼ���</td>
				<td width=25%>&nbsp;&nbsp;<%=a_bean.getUser_nm()%></td>
				<td class="title" width=15%>�μ�</td>
				<td width=45%>&nbsp;&nbsp;<%=a_bean.getDept_nm()%></td>
				
			</tr>
			<tr>
				<td class="title">�ۼ���</td>
				<td>&nbsp;&nbsp;<%=a_bean.getReg_dt()%></td>
				<td class="title">������</td>
				<td>&nbsp;&nbsp;<%=a_bean.getExp_dt()%></td>
			</tr>
			<tr>
				<td align="center" class="title">����</td>
				<td align="center" colspan="3">
				<%if(a_bean.getRead_yn().equals("Y")){%> <img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp; <%}%> <%=a_bean.getTitle()%></td>
			</tr>
			<tr>
				<td class="title">����</td>
				<td colspan="3" style="height:200" valign="top">
					<table border=0 cellspacing=0 cellpadding=0 >
						<tr>
							<td align="center">&nbsp;&nbsp;<textarea name="content" cols='74' rows='20'><%=a_bean.getContent()%></textarea></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr> 
				 <td align='center'class='title'>÷������1</td>
				 <td colspan="3" >&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('<%= a_bean.getAtt_file1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=a_bean.getAtt_file1()%></a></td>
            </tr>
			<tr> 
				 <td align='center'class='title'>÷������2</td>
				 <td colspan="3" >&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('<%= a_bean.getAtt_file2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=a_bean.getAtt_file2()%></a></td>
            </tr>
			<tr> 
				 <td align='center'class='title'>÷������3</td>
				 <td colspan="3" >&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('<%= a_bean.getAtt_file3() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=a_bean.getAtt_file3()%></a></td>
            </tr>
			<tr> 
				 <td align='center'class='title'>÷������4</td>
				 <td colspan="3" >&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('<%= a_bean.getAtt_file4() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=a_bean.getAtt_file4()%></a></td>
            </tr>
			<tr> 
				 <td align='center'class='title'>÷������5</td>
				 <td colspan="3" >&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('<%= a_bean.getAtt_file5() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=a_bean.getAtt_file5()%></a></td>
            </tr>
		</table>

	</td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
    </tr>
</table>
<input type="checkbox" name="Notice"  OnClick="notice_closeWin()">������ ��â�� �ٽ� ��������
</center>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>		
</body>
</html>