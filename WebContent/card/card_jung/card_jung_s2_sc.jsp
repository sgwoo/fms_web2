<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
    String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//����Ʈ ���� ��ȯ
function pop_excel(dt, ref_dt1, ref_dt2){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_card_excel.jsp?dt="+ dt + "&ref_dt1=" + ref_dt1+ "&ref_dt2=" + ref_dt2;
	fm.submit();
}	
//�߽Ĵ븸 ����
function pop_excel_js(dt, ref_dt1, ref_dt2){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_card_excel_js.jsp?dt="+ dt + "&ref_dt1=" + ref_dt1+ "&ref_dt2=" + ref_dt2;
	fm.submit();
}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	    <td align='right' width=100%'>&nbsp;&nbsp;
    <% if ( nm_db.getWorkAuthUser("�ӿ�",ck_acar_id) ||  nm_db.getWorkAuthUser("������",ck_acar_id)) {	%>	
	<a href="javascript:pop_excel_js('<%=dt%>','<%=ref_dt1%>', '<%=ref_dt2%>' );"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
	<% }	%>
	    </td>
    </tr>	
    <tr>
     <td><font color=red>***</font>&nbsp;���������� <font color=red>�߽Ĵ�����</font>�Ͽ� ������ ��밡���� �ѵ��� �ܾ��Դϴ�.  ��������ؾ��� ������������� �ݿ��� �ݾ��Դϴ�. �׻� ��������� ���Ѽ� ������� (-)�� ������ �ʵ��� �����ϼ���. </td>
	<tr>
	
	</tr>
    <tr>
        <td><iframe src="card_jung_s2_all_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&dept_id=<%=dept_id%>&br_id=<%=br_id%>&user_nm=<%=user_nm%>" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
<!--    	
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߽Ĵ� ����</span></td>
                    <td valign=top><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ����</span></td>
                </tr>
                <tr>
        
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;1. ���رݾ� ���� ���� : ������ �Ϳ� �޿��� �����Ͽ� ����<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;2. ���رݾ� �̻� ���� : ������ �Ϳ� �޿����� ����       
                    </td>
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;1. ���رݾ� ���� ���� : ������ ���̿��Ͽ� ���� <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;2. ���رݾ� �̻� ���� : ������ �Ϳ���(1����) �޿����� ����                   
                    </td>
                   
                </tr>
            </table>
        </td>
    </tr>
-->     
</table>
 
 
</form>
</body>
</html>
