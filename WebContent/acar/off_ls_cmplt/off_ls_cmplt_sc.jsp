<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_cmplt.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	//int tg[][]  = olcD.getTg(brch_id);
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
		
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">
function view_detail(auth_rw,car_mng_id, seq)
{
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&seq="+seq;
	parent.parent.d_content.location.href ="/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp"+url;
}

function view_detail_s(auth_rw,car_mng_id, seq)
{
	var SUBWIN= "/acar/off_ls_jh/off_ls_info.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq;
	window.open(SUBWIN, "View_OFFLS", "left=50, top=50, width=400, height=730, resizable=yes, scrollbars=yes");
}

	//���� �ٿ� �߰�  
	function excel_list(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "off_ls_cmplt_excel_list.jsp?ck_acar_id=<%=ck_acar_id%>";
		fm.submit();
	}
	
	//���� �ٿ� �߰�  
	function excel_reg(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "in_excel.jsp";
		fm.submit();
	}
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align=''><a href="javascript:excel_list();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:excel_reg();"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
    <tr> 
        <td align="right">
            * ��� �������������:
              [����۷κ�-��ȭ]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
              [����۷κ�-�д�]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
	      [�������̼�ī �ֽ�ȸ��]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
              [�Ե���Ż]		<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;            
        </td>        
    </tr>
	<tr>
		<td>
			
        <table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
            <td> <iframe src="./off_ls_cmplt_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun1=<%=gubun1%>&gubun_nm=<%=gubun_nm%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&s_au=<%=s_au%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
          </tr>
        </table>
		</td>
	</tr>
    <tr> 
        <td align="right">
            * �������� : 20150512 �������� �縮��������, 20150512 ���ʹ� �������� ��갪
        </td>        
    </tr>    
	<tr>

</table>
</form>
</body>
</html>