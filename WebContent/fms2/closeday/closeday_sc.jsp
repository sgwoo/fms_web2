<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*, acar.free_time.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String jj_gub = request.getParameter("jj_gub")==null?"":request.getParameter("jj_gub");
	String bs_gub = request.getParameter("bs_gub")==null?"":request.getParameter("bs_gub");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun="+gubun+"&gubun2="+gubun2+
					"&gubun3="+gubun3+"&gubun1="+gubun1+"&st_year="+st_year+"&st_mon="+st_mon+"&s_day="+s_day+
				   	"&sh_height="+height+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&jj_gub="+jj_gub+"&bs_gub="+bs_gub+"&asc="+asc+"";
					
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//�ϰ�����ϱ�
function reg()	{
		var SUBWIN="./closeday_i.jsp";	
		window.open(SUBWIN, "reg", "left=100, top=50, width=650, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
//������û ���� ����
	function view_cont(user_id, doc_no){
		var fm = document.form1;
		fm.user_id.value = user_id;
		fm.doc_no.value = doc_no;
		fm.target ='d_content';
		fm.action = 'closeday_c.jsp';
		fm.submit();
	}
	
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
	<input type="hidden" name="user_id" value="">
<input type="hidden" name="doc_no" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr> 
		<td align='right'> <!--<a href='javascript:reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> --></td>
	</tr>
	<tr>
	    <td colspan=2>
	        <table width=100% border=0 cellspacing=0 cellpadding=0>
	            <tr>
                    <td class=line2></td>
                </tr>
	            <tR>	                
                    <td class=line>
            	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
								<td class="title" width=10%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td class="title" width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td class="title" width=20%>��û��</td>
								<td class="title" width=25%>��û����</td>
								<td class="title" width=30%>����</td>
							</tr>
            			</table>
            			<td width="16">&nbsp;</td>
            		</td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td colspan=2>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="closeday_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 >
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