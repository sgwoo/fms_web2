<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String	to_dt 	= AddUtil.getDate(1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);		
	String  st_dt = "";
	String  std_dt = "";
	String  end_dt = "";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('������ �۾��մϱ�? �� �� �����ϴ�.'); return;}
		
		if(work_st == 'search1'){
			fm.action = 'sk_speedmate_excel.jsp';
		}else if(work_st == 'search2'){
			fm.action = 'sk_speedmate_excel_re.jsp';
		}else{
			return;
		}
		
		fm.work_st.value = work_st;
		fm.target = '_blank';
		fm.submit();
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > <span class=style5>SpeedMate�����ڷ�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>

    <tr>
	    <td><table width=100% border=0 cellspacing=1 cellpadding=0>
          <tr>
            <td width="200" rowspan="3" align="center" valign="middle"><img src=/acar/images/logo_1.png align=absmiddle border=0></td>
            <td><!-- <b>��</b> ��ü���� : ����������  02-2000-0849  / 010-3825-3123  /  pdpost@sk.com  --></td>
          </tr>
          <tr>
            <!-- <td><b>��</b> �������� : ���ؿ�Ŵ��� 070-7800-0786 /  rosya37@sk.com</td> -->
            <td><b>��</b> �������� : �������Ŵ��� 070-7800-0908 /  h956899@sk.com</td>
          </tr>
          <tr>
            <td><b></b></td>
    	  	</tr>
          <tr>
            <td align="center" valign="middle"><b>���ǵ����Ʈ</b></td>
            <td>�� �ϳ����� ���� 10099774681437 (SK��Ʈ���� ���ǵ����Ʈ) &nbsp;&nbsp;&nbsp; - �Ŵ� ������ �� 5�ϳ� �Աݹٶ��ϴ�.</td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ���ø���Ʈ ��ȸ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>1</td> 
	                <td>&nbsp;
                	  <select name="s_kd">
						<option value="3" >����</option>
                	  	<option value="1" >���</option>
                		<option value="2" selected>�Ⱓ</option>
                	  </select>&nbsp;&nbsp;
					  <input type='text' size='11' name='st_dt' class='text' value='<%=AddUtil.getDate(1)+""+AddUtil.getDate(2)+"01"%>'>
                      ~ 
            		  <input type='text' size='11' name='end_dt' class='text' value='<%=Util.getDate()%>'>
					 &nbsp;&nbsp;&nbsp;����� ǥ�õ� �������� ���� &nbsp;<a href="javascript:save('search2')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> 
	                </td>
	            </tr>

	        </table>
	    </td>
    </tr>
	
    <tr>
	    <td>&nbsp;</td>
    </tr>

    <tr>
	    <td>�� ����� �����ϰ� [��ȸ]��ư Ŭ���ϸ� ���� ���� �ű� ��ϵ� ������ ��ȸ�� �ǰ�, <br>&nbsp;&nbsp;&nbsp;�Ⱓ�� �����ϰ� ��¥�� �Է��ϰ� [��ȸ]��ư Ŭ���ϸ� �Է��� �Ⱓ�� �ش��ϴ� ������ ��ȸ�� �ȴ�.</td>
    </tr>
	
    <tr>
	    <td>�� ����� ǥ�� ���������� ��������������� �̸��� ����ó�� ����Ʈ�� ���� ǥ�õǾ� �ִ� ���·� ������ �����ϴ� ����Ʈ �����Դϴ�. </td>
    </tr>

    <tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
	
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���񳻿� ���</span></td>
    </tr>
	<tr>
		
		<td colspan="2">&nbsp;&nbsp;&nbsp;���ǵ����Ʈ ���񳻿� ������ ��� :

            		<a href="javascript:var win=window.open('excel.jsp?user_id=<%=user_id%>','popup','left=10, top=10, width=800, height=600, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;

        </td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
		<tr>
	    <td>&nbsp;</td>
    </tr>
	
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ǰ����</span></td>
    </tr>
	<tr>
		
		<td colspan="2">&nbsp;&nbsp;&nbsp;���ǵ����Ʈ ����ǰ�� ������ ��� :

            		<a href="javascript:var win=window.open('jb_excel.jsp?user_id=<%=user_id%>','popup','left=10, top=10, width=800, height=600, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
