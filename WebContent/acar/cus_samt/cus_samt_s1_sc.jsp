<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0401.*, acar.cus_samt.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "04", "04");	
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	String first = request.getParameter("first")==null?"":request.getParameter("first");
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	String ven_code = "";	
	ven_code = cs_db.getServOffVenCode(acct);

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">

<script language="JavaScript">
<!--
function view_detail(car_mng_id,rent_mng_id,rent_l_cd)
{
	var fm = document.form1;
	var url = "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "cus0401_d_sc_carinfo.jsp"+url+url2;
}

function view_client(client_id,cmd)
{
	var fm = document.form1;
	var url = "?client_id="+client_id+"&cmd="+cmd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "/acar/cus0402/cus0402_d_sc_clientinfo.jsp"+url+url2;
}

	
function list_move(gubun1, gubun2, gubun3)
{
		var fm = document.form1;
		var url = "/acar/cus0401/cus0401_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3;
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
}

//����Ʈ ���� ��ȯ
function pop_excel(s_year, s_mon, s_kd, t_wd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_excel_service.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_kd=" + s_kd+ "&t_wd=" + t_wd;
	fm.submit();
}	


function make_magam(s_yy, s_mm, s_seq){
		var fm = document.form1;
		
		if(!confirm('�ش�� ����ȸ���� �����Ͻðڽ��ϱ�?')){	return;	}
			
		fm.target = "i_no";
		fm.action = "cus_samt_magam_a.jsp?s_yy="+ s_yy + "&s_mm="+ s_mm + "&s_seq=" + s_seq;
		fm.submit();
}	


//��ǥ����
function make_autodocu(s_year, s_mon, s_kd, t_wd){
		
	var fm = document.form1;
	
	if ( fm.ven_code.value == 'XX' ) {
	  	alert("��ǥ�� ������ �� �����ϴ�. !!!, �����ü�׿����ڵ带 Ȯ���ϼ���!!!");
		return;
	}else {
	
		if ( s_kd== '3' && t_wd != ""  ) {
		}
		else {
		    alert("��ǥ�� ������ �� �����ϴ�. !!!");
		    return;
		}  
	}
	
	var SUBWIN="cus_samt_reg_autodoc_popup.jsp?acct="+fm.acct.value+"&s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_kd=" + s_kd+ "&t_wd=" + t_wd;	
 	window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");	 	
}


//������� - ȸ�� �� ������ - ����Ϸ��� ��������
function view_jungsan(car_mng_id, serv_id)
{
		window.open("/acar/cus_samt/cus_jungsan_popup.jsp?auth_rw=<%=auth_rw%>&car_mng_id="+car_mng_id+"&serv_id="+serv_id, "jungsan", "left=150, top=150, width=400, height=300");
}
	

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='s_year' value='<%=s_year%>'>
  <input type='hidden' name='s_mon' value='<%=s_mon%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='j_g_amt' value=>
  <input type='hidden' name='j_b_amt' value=>
  <input type='hidden' name='j_g_dc_amt' value=>
   <input type='hidden' name='j_ext_amt' value=>
   <input type='hidden' name='j_dc_amt' value=>
  <input type='hidden' name='acct' value='<%=acct%>'>
   <input type='hidden' name='ven_code' value='<%=ven_code%>'>
 <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td align='right' width=100%'>&nbsp;&nbsp;* excel ��½� �μ�̸����� ���� 75%,  �������������� ����,������ ���� 0.4 &nbsp;
	&nbsp;<a href="javascript:pop_excel('<%=s_year%>', '<%=s_mon%>', '<%=s_kd%>', '<%=t_wd%>');"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>
	 <%if (ck_acar_id.equals("000063")) {%>	<!-- ������Ȳ II ���� ������ �� ����   mj_jungsan �ݿ��� Ȯ���ؼ� ����ó���� �� - 20220721-->
 	 &nbsp;<a href="javascript:make_magam('<%=s_year%>', '<%=s_mon%>', '<%=t_wd%>');"><img src=../images/center/button_mg.gif align=absmiddle border=0></a>	
<!-- 	&nbsp;<a href="javascript:make_autodocu('<%=s_year%>', '<%=s_mon%>', '<%=s_kd%>', '<%=t_wd%>');"><img src=../images/center/button_jpss.gif align=absmiddle border=0></a> -->
     <% } %>
	</td>
  </tr>	
  <tr> 
    <td align='center'>
    <iframe src="./cus_samt_s1_sc_in.jsp?first=<%=first%>&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&height=<%=height%>" name="inner" width="100%" height="<%=height +10 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe></td>
  </tr>

</table>
</form>
</body>
</html>
