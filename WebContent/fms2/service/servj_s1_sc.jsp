<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");  //�⵵
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");

	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
		s_kd = "8";
	}
	
	String dept_id = login.getDept_id(ck_acar_id);
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun4="+gubun4+"&gubun3="+gubun3+"&off_id="+off_id+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
					
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='off_id' 	value='<%=off_id%>'>     
  <input type='hidden' name='gubun4' >    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/servj_s1_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="servj_s1_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
