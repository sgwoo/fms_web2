<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_ins.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//����� ���γ��� ����
	function view_ins(m_id, l_cd, c_id, ins_st)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value=ins_st;
		fm.target='d_content';
//		fm.action='/acar/con_ins/ins_u.jsp';
		fm.action='/acar/ins_mng/ins_u_frame.jsp';
		fm.submit();
	}
	
	//���ó��
	function pay_ins(c_id, ins_st, ins_tm)
	{
		window.open('/acar/con_ins/ins_pay_p.jsp?gubun=<%=gubun%>&c_id='+c_id+'&ins_st='+ins_st+'&ins_tm='+ins_tm, "PAY_INS", "left=100, top=100, width=500, height=250");
	}
	
	//����ó��
	function remake_ins(m_id, l_cd, c_id, ins_st)
	{
		if(confirm('����� �ش� �������� �����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			var auth_rw = fm.auth_rw.value;
			var br_id 	= fm.br_id.value;
			var user_id	= fm.user_id.value;
			var gubun1 	= fm.gubun1.value;
			var gubun2 	= fm.gubun2.value;
			var gubun3 	= fm.gubun3.value;
			var gubun4 	= fm.gubun4.value;		
			var st_dt 	= fm.st_dt.value;
			var end_dt 	= fm.end_dt.value;
			var s_kd 	= fm.s_kd.value;
			var t_wd 	= fm.t_wd.value;
			var sort_gubun = fm.sort_gubun.value;
			var asc 	= fm.asc.value;
			var f_list 	= fm.f_list.value;				

			parent.location="/acar/con_ins/ins_renew_i.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&f_list="+f_list+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&ins_st="+ins_st+"&ins_sts=1";
		}
	}	
	
	//����ó��
	function disable_renew(c_id, ins_st)
	{
		if(confirm('����� �ش� �����࿡ ���� �ٽ� �����Ҽ� ������ ���� ����ó�� �Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			fm.c_id.value=c_id;
			fm.ins_st.value=ins_st;
			fm.target='i_no';
			fm.action='/acar/con_ins/disable_renew_u_a.jsp';
			fm.submit();			
		}
	}

	//����ó��
	function remake_ins_offls(m_id, l_cd, c_id, ins_st)
	{
		if(confirm('�������� ������ ������ ����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			var auth_rw = fm.auth_rw.value;
			var br_id 	= fm.br_id.value;
			var user_id	= fm.user_id.value;
			var gubun1 	= fm.gubun1.value;
			var gubun2 	= fm.gubun2.value;
			var gubun3 	= fm.gubun3.value;
			var gubun4 	= fm.gubun4.value;		
			var st_dt 	= fm.st_dt.value;
			var end_dt 	= fm.end_dt.value;
			var s_kd 	= fm.s_kd.value;
			var t_wd 	= fm.t_wd.value;
			var sort_gubun = fm.sort_gubun.value;
			var asc 	= fm.asc.value;
			var f_list 	= fm.f_list.value;				

			parent.location="/acar/con_ins/ins_renew_i.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&f_list="+f_list+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&ins_st="+ins_st+"&ins_sts=4";
		}
	}
		
	//����:���� ����Ʈ �̵�
	function ins_move(f_list){
		var fm = document.form1;
		fm.f_list.value = f_list;
		if(f_list != 'now') fm.gubun2.value = '5';
		fm.target = "d_content";
		fm.action = "/acar/con_ins/ins_frame_s.jsp";
		fm.submit();
	}		
	
	//����Ʈ ���� ��ȯ
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}		
	//����Ʈ ���� ��ȯ
	function pop_auto(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_auto.jsp";
		fm.submit();
	}	
	
	//��Ȳ
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=275px");
		document.form1.action="ins_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='go_url' value='/acar/con_ins/ins_frame_s.jsp'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align='right' width='100%'>
			&nbsp;<a href="javascript:pop_auto();"><img src=../images/center/button_igcr.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="/acar/con_ins/ins_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&f_list=<%=f_list%>&gubun=<%=gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
