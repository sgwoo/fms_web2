<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 		= request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt 		= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		var fm = document.form1;
		
		if(fm.dt[2].checked == true && (fm.t_st_dt.value == '' || fm.t_end_dt.value == '')){
			alert('��ȸ�Ⱓ�� �Է��Ͻʽÿ�.'); return;	
		}
		
		fm.action = 'dlv_condition_sc.jsp';
		fm.target='c_body';
		fm.submit();		
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='dlv_condition_sc.jsp' target='c_body'>
  <input type='hidden' name='auth_rw'  	value='<%=auth_rw%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> ������� > <span class=style5>�����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line>
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
    	        <%if(nm_db.getWorkAuthUser("�ܺ�_�ڵ�����",ck_acar_id)){%>
    	        <input type='hidden' name='car_off_id' value='<%=car_off_id%>'> 
    	        <%}else{%>
                <tr>
                    <td class=title width=10%>������</td>
                    <td colspan='5'>&nbsp;
            		<select name='car_off_id'>
                            <option value='' <%if(car_off_id.equals("")){%>selected<%}%>> ��ü </option>
                            <option value='03900' <%if(car_off_id.equals("03900")){%>selected<%}%>> ���� B2B������ </option>
                            <option value='00588' <%if(car_off_id.equals("00588")){%>selected<%}%>> ���� �ѽŴ뿪�븮�� </option>
                            <option value='00631' <%if(car_off_id.equals("00631")){%>selected<%}%>> ���� �����븮�� </option>
                            <option value='00623' <%if(car_off_id.equals("00623")){%>selected<%}%>> ���� �Ѱ��븮�� </option>                            
                            <!--<option value='03784' <%if(car_off_id.equals("03784")){%>selected<%}%>> ���� �̼��븮�� </option>-->
                            <option value='00998' <%if(car_off_id.equals("00998")){%>selected<%}%>> ��� ���Ǵ��Ǹ��� </option>
                            <option value='01129' <%if(car_off_id.equals("01129")){%>selected<%}%>> ��� �������Ǹ��� </option>
                            <option value='03579' <%if(car_off_id.equals("03579")){%>selected<%}%>> ��� ���ʹ븮�� </option>
                            <option value='03954' <%if(car_off_id.equals("03954")){%>selected<%}%>> ��� ���¿��븮�� </option>
                            <option value='04500' <%if(car_off_id.equals("04500")){%>selected<%}%>> ��� �����δ븮�� </option>
                            <option value='03548' <%if(car_off_id.equals("03548")){%>selected<%}%>> ��� ����븮�� </option>
                            <option value='02176' <%if(car_off_id.equals("02176")){%>selected<%}%>> ���� ������û�� </option>	<!-- ����������û�� �߰� (2018.03.22) -->
                        </select>
        	  </td>					
                </tr>    	        
    	        <%}%>            
            	<tr>
            		<td class=title width=10%>�˻�����</td>
            			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp; -->
            		<td width=40%>&nbsp;            			
            			<select name='s_kd'>
            				<option value='2'>����</option>            				
            			</select>
						<input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()'>
					</td>
					<td class=title width=10%>�Ⱓ</td>
					<td width=40%>&nbsp;
						<input type="radio" name="dt" value="1" > ����
            			                <input type="radio" name="dt" value="2" checked > ���
						<input type="radio" name="dt" value="3"> ��ȸ�Ⱓ
						<input type='text' name='t_st_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'> ~
						<input type='text' name='t_end_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'>
						&nbsp;
					</td>
				</tr>
            </table>
        </td>
    </tr>
	<tr align="right">
     			<td>	
			<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
		</td>						
	</tr>
</table>
</form>
</body>
</html>