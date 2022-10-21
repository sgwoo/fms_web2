<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %> 


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="/include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script>
	function Search(){
		var fm = document.form1;
		fm.action="ins_calc_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	function gubun2Change(val){
		 if(val == '�Ϸ�'){
			var fm = document.form1;
			fm.gubun3.value = '�Ⱓ';
			skdChange(fm.gubun3.value);
		} 
	}
	
	function skdChange(val){
		 if(val == '�Ⱓ'){
			var date = new Date();
            date.setDate(1);
			var fm = document.form1;
			fm.st_dt.value = getFormatDate(date);
			fm.end_dt.value = getFormatDate(new Date());
		} 
	}
	
	function getFormatDate(date){
		var year = date.getFullYear();                 
		var month = (1 + date.getMonth());             
		month = month >= 10 ? month : '0' + month;     
		var day = date.getDate();                      
		day = day >= 10 ? day : '0' + day;             
		return  year + '' + month + '' + day;
	}
	
	
	
</script>
</head>

<body>
<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������� ><span class=style5>���Ǻ�������û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
</table>
<div class="search-area" >
	<label><i class="fa fa-check-circle"></i> ���� </label>
	<select id="gubun2" name="gubun2" class="select" style="width:70px;" onchange="gubun2Change(this.value)">
		<option value='��û' <%if(gubun2.equals("��û")){%>selected<%}%>>��û</option>
		<option value='�Ϸ�' <%if(gubun2.equals("�Ϸ�")){%>selected<%}%>>�Ϸ�</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> �Ⱓ </label>
	<select id="gubun3" name="gubun3" class="select" style="width:70px;" onchange="skdChange(this.value)">
		<option value=''>��ü</option>
		<option value='����' <%if(gubun3.equals("����")){%>selected<%}%>>����</option>
		<option value='����' <%if(gubun3.equals("����")){%>selected<%}%>>����</option>
		<option value='�Ⱓ' <%if(gubun3.equals("�Ⱓ")){%>selected<%}%>>�Ⱓ</option>		
	</select>	
	<input type="text" name="st_dt" size="10"  value="<%=st_dt%>" class="text" >
  ~ 
  <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> �˻����� </label>
	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��</option>
		<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ڹ�ȣ</option>
		<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>�����</option>
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="�˻�" onclick="Search()"/>
	</div>

</form>
</body>
</html>