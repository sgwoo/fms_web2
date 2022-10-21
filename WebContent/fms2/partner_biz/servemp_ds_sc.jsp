<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.partner.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	String s_mon = s_sys.substring(5,7);
	String s_day = s_sys.substring(8,10);
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String year = request.getParameter("year")==null?s_year:request.getParameter("year");
	String month = request.getParameter("month")==null?"":request.getParameter("month");
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String use_yn = request.getParameter("use_yn")==null?"1":request.getParameter("use_yn");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt  = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//��Ȳ ���μ���ŭ ���� ���������� ������
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Vector vt = se_dt.Count_serv_bc_item(off_id);
	int vt_size = vt.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
//����� ���
function serv_emp_reg(){
	var SUBWIN="serv_emp_i.jsp?auth_rw=<%= auth_rw %>&off_id=<%=off_id%>";
	window.open(SUBWIN, "ServEmpReg", "left=100, top=120, width=1000, height=300, scrollbars=no");
}
//�����Ȳ
function serv_sd_view(){
	var SUBWIN="serv_sd_view.jsp?auth_rw=<%= auth_rw %>&off_id=<%=off_id%>";
	window.open(SUBWIN, "ServEmpReg", "left=100, top=120, width=1000, height=600, scrollbars=no");
}
//�ŷ���Ȳ
function serv_gr_view(){
	var SUBWIN="serv_gr_view.jsp?auth_rw=<%= auth_rw %>&off_id=<%=off_id%>&cpt_cd=<%=cpt_cd%>";
	window.open(SUBWIN, "ServEmpReg", "left=20, top=50, width=1200, height=600, scrollbars=auto");
}

function search(st){
	var fm = document.form1;
	fm.use_yn.value = st;
	fm.submit();
}

//-->
</script>

</head>
<body>
<form name='form1' method='post' action='servemp_ds_sc.jsp' target='dsc_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>
<input type='hidden' name='use_yn' value='<%=use_yn%>'> 	
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td>
			<input type="button" class="button" value="���" onclick="serv_emp_reg()"/>
			<%if( auth_rw.equals("6")) {%>	
			<button type="button" class="button" onclick="serv_sd_view()">�����Ȳ<span style="color:red"><%if(vt_size > 0){%>(<%=vt_size%>)<%}%></span></button>
			<input type="button" class="button" value="�ŷ���Ȳ" onclick="serv_gr_view()"/>
			<%}%>
			<input type="button" class="button" value="��ü����" onclick="search('all')" style="float:right"/>
			<input type="button" class="button" value="��ȿ����" onclick="search('1')" style="float:right"/>
		</td>
	</tr>
    <tr>        
    <td><iframe src="servemp_ds_sc_in.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&off_id=<%=off_id%>&year=<%= year %>&month=<%= month %>&use_yn=<%= use_yn %>&mon_amt=<%=mon_amt%>&save_dt=<%=save_dt%>&gubun1=<%=gubun1%>" name="ServList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>

</table>
</form>
</body>
</html>
