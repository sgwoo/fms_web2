<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
			
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&st="+st+"&gubun="+gubun+"&gubun_nm="+gubun_nm+
				   	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//�ڻ곻�� ���� ����
	function view_asset(asset_code){
		var fm = document.form1;
		fm.asset_code.value = asset_code;
		fm.asset_g.value = '1';
		fm.target ='d_content';
		fm.action = 'assetma_frame.jsp';
		fm.submit();
	}
	
	//����Ʈ ���� ��ȯ
	function pop_excel(st){
	var fm = document.form1;
	fm.target = "_blak";
	
	fm.action = "popup_asset_excel_j.jsp?st="+ st;
	fm.submit();
}	
			
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='st'    	value='<%=st%>'>
  <input type='hidden' name='gubun' 	value='<%=gubun%>'>			
  <input type='hidden' name='gubun_nm' 	value='<%=gubun_nm%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='asset_code' value=''>
  <input type='hidden' name='asset_g' value=''>
   
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span></td>
	  <td align='right'><a href="javascript:pop_excel('<%=st%>');"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
	  </td>
	</tr>
	
	<tr>
		<td colspan=2>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="asset_s_sc_j_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
