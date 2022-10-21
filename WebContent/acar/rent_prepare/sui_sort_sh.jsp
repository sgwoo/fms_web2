<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 	= request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc 	= request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year 		= request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt1 = rs_db.getSuiSortRegDtList();
	int vt1_size = vt1.size();
	
	Vector vt2 = rs_db.getSuiSortVarList();
	int vt2_size = vt2.size();
%>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;		
		if(fm.s_kd.value == '2'){
			fm.t_wd.value = ChangeDate3(fm.t_wd.value);
		}
		fm.action = 'sui_sort_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	
	//��������		
	function OpenVar(){
		var fm = document.form1;		
		var SUBWIN = "sui_sort_var.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value;
		window.open(SUBWIN, "VAR", "left=10, top=10, width=1100, height=800, scrollbars=yes");
	}	
	
	//���ϸ���
	function Magam(){
		var fm = document.form1;	
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		fm.target = 'i_no';
		fm.action = 'sui_sort_magam.jsp';
		fm.submit();		
	}	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='sui_sort_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �ڵ������� > <span class=style5>�Ű���󼱺�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	
    <tr> 
        <td width='40%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��������<!--<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>-->&nbsp;
            <select name='gubun1'>
              <option value='' <%if(gubun1.equals("")){%>selected<%}%>>=====��  ��=====&nbsp;&nbsp;&nbsp;</option>			  
			  <%for(int i = 0 ; i < vt1_size ; i++){
					Hashtable ht = (Hashtable)vt1.elementAt(i);%>
              <option value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>' <%if(gubun1.equals(AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT"))))){%>selected<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
              <%}%>	  
            </select>
        </td>
        <td colspan='2'>��������&nbsp;
		  <select name='gubun2'>
		  	  <option value='' <%if(gubun2.equals("")){%>selected<%}%>>��ü</option>			  
              <%for(int i = 0 ; i < vt2_size ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);%>
              <option value='<%=ht.get("SORT_CODE")%>' <%if(gubun2.equals(String.valueOf(ht.get("SORT_CODE")))){%>selected<%}%>><%=ht.get("SORT_GUBUN")%></option>
              <%}%>	  
            </select>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
            <select name='s_kd'>
              <option value='' <%if(s_kd.equals("")){%>selected<%}%>>��ü </option>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>������ȣ</option>
              <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>���ʵ����</option>		  
            </select>
            <input type='text' name='t_wd' size='36' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        </td>
        <td width=33%><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> &nbsp; 
            <select name='sort_gubun' onChange='javascript:search()'>
              <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>��������</option>
              <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>������ȣ</option>
              <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>����</option>
              <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>���ʵ����</option>
              <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>��ⷮ</option>
            </select>
            <select name='asc' onChange='javascript:search()'>
              <option value="asc" <%if(asc.equals("asc")){%> selected <%}%>>��������</option>
              <option value="desc" <%if(asc.equals("desc")){%> selected <%}%>>��������</option>
            </select>
        </td>
        <td>&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
			<%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����������",user_id)|| nm_db.getWorkAuthUser("�����������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:OpenVar()" title='��������'><img src=/acar/images/center/button_modify_bs.gif align=absmiddle border=0></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:Magam()" title='���ϸ���'><img src=/acar/images/center/button_dimg.gif align=absmiddle border=0></a> 
			<%	}%>  			
		</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
