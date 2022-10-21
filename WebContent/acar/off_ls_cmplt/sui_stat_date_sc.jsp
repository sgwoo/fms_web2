<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.offls_cmplt.*" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(s_yy.equals("")){
		height = height-(20*4);
	}

	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			        "&s_yy="+s_yy+"&s_mm="+s_mm+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"&sh_height="+sh_height+"";
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//�˻�
function show_month(s_yy)
{
	var fm = document.form1;
	fm.s_yy.value = s_yy;
	fm.target = "_parent";		
	fm.action = 'sui_stat_date_frame.jsp';		
	fm.submit();
}	
//-->
</script>
</head>

<body >
<form name='form1' method='post' target='d_content'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 			value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 			value='<%=s_mm%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>   
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					    <%if(s_yy.equals("")){ %>
	                    <iframe src="sui_stat_date_sc_y.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>	
	                    <%}else{ %>
	                    <iframe src="sui_stat_date_sc_m.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
	                    <%} %>						
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%if(s_yy.equals("")){ %>
    <tr>
      <td>�� ���� �Ű����� �ܰ����� ����� ��Ȳ����� > �Ű����� > �Ű������ܰ�������Ȳ�� ���� </td>
    </tr>						
    <tr>
      <td>�� �ܰ����� �����ԱⰣ : �ܰ����� ���� �����Ե� �Ⱓ���� ����Ʈ/���������/�����ܰ� ������� ���ǿ���/������/�������/��뿩�Ⱓ </td>
    </tr>						
    <tr>
      <td>�� �����ԱⰣ �ܰ�����ȿ�� : ǥ������ �ش� �Ű��Ⱓ ��� ���� ������ �ܰ��� ������ Ȱ���Ͽ� ������ �Ⱓ�� �ܰ�����ȿ�� ��� </td>
    </tr>
    <tr>
      <td>�� ���� �ܰ������� : �����ԱⰣ �ܰ��ݿ� �� �ܰ������� </td>
    </tr>
    <%} %>	
</table>
</form>
</body>
</html>