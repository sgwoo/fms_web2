<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
		
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	String gubun 	= request.getParameter("gubun")==null?"jg_code":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String car_ck 	= request.getParameter("car_ck")==null?"":request.getParameter("car_ck");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");

	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");	
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String chk1 	= request.getParameter("chk1")==null?"":request.getParameter("chk1");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link><script language="JavaScript">
<!--
function AccidAdd()
{
	var theForm = document.AccidRegMoveForm;
	theForm.target="d_content";
	theForm.submit();
}

//����Ʈ ���� ��ȯ
function pop_excel(ref_dt1, ref_dt2, gubun_nm, gubun, gubun3, gubun4, sort, chk1, car_ck){
	var fm = document.form1;
	fm.target = "_blank";
		
	fm.action = "car_cost_excel.jsp?chk1="+chk1+"&ref_dt1="+ref_dt1 + "&ref_dt2=" + ref_dt2 + "&gubun_nm="+gubun_nm+"&gubun="+gubun+"&gubun3="+gubun3+"&gubun4="+gubun4+"&sort="+sort+"&car_ck="+car_ck;
	fm.submit();
}

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" target='d_content'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr>
	    <td align='right' width=100%'>&nbsp;&nbsp;	
		<a href="javascript:pop_excel('<%=ref_dt1%>', '<%=ref_dt2%>', '<%=gubun_nm%>', '<%=gubun%>', '<%=gubun3%>', '<%=gubun4%>', '<%=sort%>', '<%=chk1%>' ,'<%=car_ck%>' );"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>	
	    </td>
    </tr>
    
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./car_cost_s_sc_in.jsp?chk1=<%=chk1%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>&gubun=<%=gubun%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&sort=<%=sort%>&car_ck=<%=car_ck%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&height=<%=height%>" name="MaintList" width="100%" height="<%=height+20%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>
 <font size=2>�� ����Ÿ��� ���ʵ���ϱ���, ���(�ΰ��� ������)�� �뿩������ ���� , �Ⱓ�˻��� �뿩������ ���� </font> 
 <br>
 <font size=2>�� 1���� ���ý� - ���: ������(��κ� �����԰�����)�� ������ ���� 1�������� �� ��쿡 �߻��� ���� ���(������� ����, ������� �Էµ� ��� DATA), �̿밳��: 1���� ���� �̿밳��</font> 
</form>
</body>
</html>