<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

function reg(){
		var fm = document.form1;
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='cost_m_reg_a.jsp';	
			fm.target='i_no';	
			fm.submit();
		}			
				
	}
	
	
	function view(){
	
	var SUBWIN="./cost_etc2020.html";	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=530, height=400, scrollbars=no");
				
	}	
			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	if(user_id.equals("")){
		user_id=login.getCookieValue(request, "acar_id");
	}
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� �Ѽ�
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	int i_year = AddUtil.parseInt(st_year);
	
%>
<form name='form1'  method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='st_year' value='<%=st_year%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%> 
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			 <tr>
					<td>* ��Ÿ���: �����н�+������+����������+(ȸ�������뿩�� - �����󰢻���) 
					</td>
					<td align=right> <a href='javascript:view()'>����</a>
				
					 <a href='javascript:reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> 
				
				    </td>	
			 </tr>
		 	 <tr>
					<td  colspan=2>
						 <iframe src="cost_m_sc_in.jsp?sh_height=<%=sh_height%>&height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_year=<%=st_year%>" name="ii_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
			 </tr>
			</table>
		</td>
	</tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</form>
</body>
</html>

