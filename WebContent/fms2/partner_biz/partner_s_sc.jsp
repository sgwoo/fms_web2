<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
		
	//ID ���
	function BranchAdd()
	{
	var SUBWIN="partner_fin.jsp";	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=300, scrollbars=yes");
	}

	
	
function BranchUpdate(fin_seq)
{
	
	var SUBWIN="partner_fin_u.jsp?fin_seq="+fin_seq;	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=850, height=300, scrollbars=yes");
}		


//����Ʈ ���� ��ȯ
function pop_excel(kd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_fin_man_excel.jsp?s_kd="+ kd;
	fm.submit();
}	


function SendMail(kd)
	{
	var SUBWIN="mail_fin.jsp?s_kd="+ kd;	
	window.open(SUBWIN, "BranchOfficeList", "left=100, top=100, width=650, height=500, scrollbars=yes");
}
	
//���ø��� ������ 
	function SendMail2(kd){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
	
		if(cnt < 2){
		   	alert("�ּ� �θ��̻� �����ϼ���.");
		   return;
		}
			
		window.open('about:blank', "SendMail", "left=0, top=0, width=650, height=550, scrollbars=yes, status=yes, resizable=yes");
		alert("�����Ͻ� ����ڿ��Ը� �����ϴ�.");
		if(!confirm('������ �߼� �Ͻðڽ��ϱ�?')){	return; }
		fm.target = "SendMail";
		fm.action = "mail_fin_b.jsp?s_kd="+ kd+"&cnt="+cnt;
	   fm.submit();	
	 	
	}
	
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' action='' method='post'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="use_yn" value="<%=use_yn%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td align='right' width='100%'>&nbsp;&nbsp;
<% if  (user_id.equals("000063") ) {  %>
	<a href="javascript:SendMail('X')">�Ƹ����ɾ�</a>

<% } %>
	
	<a href="javascript:BranchAdd()"><img src="/acar/images/center/button_reg_hluc.gif" align=absmiddle border=0></a>
	&nbsp;&nbsp;
	<a href="javascript:SendMail2('<%=s_kd%>')"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a>
	&nbsp;&nbsp;
	<input type="button" name="excel" value="Excel" onClick="javascript:pop_excel('<%=s_kd%>' );" size="14">	
	</td>
	
  </tr>	
  <tr>
    <td><iframe src="partner_s_in.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&use_yn=<%=use_yn%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
                    </td>
  </tr>
  <tr>
	<td></td>
  </tr>
  <tr>
	<td>�� üũ���� ������ ��ü ����ڿ��� ������ �����ϸ�, ���������� �������� �Ѹ��� �����Ͽ� ���� �� �ֽ��ϴ�. </td>
  </tr>
</table>
</form>  

</body>
</html>
