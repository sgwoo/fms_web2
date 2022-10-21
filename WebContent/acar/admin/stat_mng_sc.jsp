<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*, acar.add_mark.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("�̹� ���� ��ϵ� ����� ������Ȳ�Դϴ�."); return; }		
		var i_fm = i_view.form1;
		i_view.save();		
/*		if(i_fm.save_dt.value != ''){ alert("�̹� ���� ��ϵ� �ڵ���������Ȳ�Դϴ�."); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		i_fm.target='i_no';
		i_fm.submit();		
*/		
	}	

	//������ȸ
	function TodaySearch(today){
		var fm = document.form1;	
		var i_fm = i_view.form1;
		fm.view_dt.value = today;
		fm.save_dt.value = '';		
		i_fm.brch_id.value = fm.brch_id.value;		
		i_fm.save_dt.value = '';
		i_fm.target='i_view';
		i_fm.action='stat_mng_sc_in_view.jsp';		
		i_fm.submit();				
	}
	//��ȸ
	function Search(){
		var fm = document.form1;	
		var i_fm = i_view.form1;
		i_fm.brch_id.value = fm.brch_id.value;
		i_fm.save_dt.value = fm.save_dt.value;
		i_fm.target='i_view';
		i_fm.action='stat_mng_sc_in_view.jsp';		
		i_fm.submit();				
	}		
	function OpenHelp(){
		var fm = document.form1;		
		var SUBWIN = "stat_mng_help.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&save_dt="+fm.save_dt.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=600, height=500, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	auth_rw = rs_db.getAuthRw(user_id, "09", "04", "05");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	if(user_id.equals("000003")) brch_id="";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_mng");
	
	//����ġ �ο�(�⺻)
	int c_o = 2;
	int c_t = 1;	
	int g_o = 4;
	int g_t1 = 1;
	int g_t2 = 3;	
	int b_o = 1;
	double b_t = 0.5;
	int p_o = 1;
	double p_t = 0.5;
	
	
	
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* �ڵ� ����:�뿩���-���������� */	
	int way_size = ways.length;
	
	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	//����ġ ��������
	

%>
<form action="stat_mng_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ������Ȳ > <span class=style5>�����������������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_yus.gif align=absmiddle>
              &nbsp;<select name='brch_id'>
                <option value='' <%if(brch_id.equals("")){%> selected <%}%>>��ü</option>
        <!--        <option value='S1' <%if(brch_id.equals("S1")){%> selected <%}%>>����</option> -->
                <!--<option value='S2' <%if(brch_id.equals("S2")){%> selected <%}%>>��������</option>-->
     <!--           <option value='B1' <%if(brch_id.equals("B1")){%> selected <%}%>>�λ�����</option> -->
                <!--<option value='G1' <%if(brch_id.equals("G1")){%> selected <%}%>>�뱸����</option>-->
         <!--       <option value='D1' <%if(brch_id.equals("D1")){%> selected <%}%>>��������</option> -->
                <!--<option value='J1' <%if(brch_id.equals("J1")){%> selected <%}%>>��������</option>-->
              </select>	 
			  &nbsp;		  
			  <a href="javascript:Search();"><img src=../images/center/button_search.gif border=0 align=absmiddle>  
        </td>
        <td align="right"> 
             
        </td>
        <td align="right"><img src=../images/center/arrow_gji.gif align=absmiddle> : 
        <input type='text' name='view_dt' size='11' value='<%if(save_dt.equals("")) {%><%=AddUtil.getDate()%><% } else {%> <%=AddUtil.ChangeDate2(save_dt)%><%}%>' class="white" readonly> &nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="3"><iframe src="./stat_mng_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_view" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="3"><font color="#FF00FF">�� ���� : </font> <a href="javascript:OpenHelp()">����ġ �ο����</a> <a href="javascript:OpenHelp()"><img src=../images/center/button_see.gif align=absmiddle border=0></a> (������ü : ����ϵ� ��ü ���� / �������� : ������ϵ� ��� ����)
        </td>
    </tr>
    <tR>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="3"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ȳ ����Ʈ</span></td>
    </tr>
    <tr> 
        <td colspan="3"><iframe src="./stat_mng_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>