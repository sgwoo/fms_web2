<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	

	
	String title = "";	
	String title1 = "";	
	String sch_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function actn_scan_reg(){
		fm = document.form1;		
		if(!confirm("������ ����Ͻðڽ��ϱ�?"))	return;
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/actn_scan_all_a.jsp";
		
		//fm.target = "_blank";
		fm.submit();
	}

function actn_scan_close()
{
	self.close();
	window.close();
}


//-->
</script>


</HEAD>
<BODY>
<form action="" name='form1' method='post' enctype="multipart/form-data">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ��Ű��� > <span class=style5>������ĵ���� ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=600>
                <tr> 
                    <td width='20%' class='title'>�����</td>
                    <td width="" align='left' >&nbsp; 
						<select name='actn_nm'>
                        	<option value='�д�-����۷κ�(��)'>�д�-����۷κ�(��)</option>
							<option value='��ȭ-����۷κ�(��)'>��ȭ-����۷κ�(��)</option>
							<option value='(��)�����ڵ������'>(��)�����ڵ������</option>
							<option value='��ȭ����ũ �ֽ�ȸ��'>��ȭ����ũ �ֽ�ȸ��</option>
						</select>
					</td>
                </tr>
				<tr> 
                    <td class='title' width="20%">���Ƚ��</td>
                    <td colspan="">&nbsp; 
        			  <input type="text" name="actn_su" value='' size="15" class=text>&nbsp;ȸ
                    </td>
                </tr>
				<tr> 
                    <td class='title' width="20%">�������</td>
                    <td colspan="">&nbsp; 
        			  <input type="text" name="actn_dt" value='' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>

            </table>
			
			
		</td>
	</tr>
	<tr>
		<td align='right'>
			 
	 		<a href="javascript:actn_scan_reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<a href="javascript:actn_scan_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
		<td align='left'>
		 <font color="#999999">�� (��)�����ڵ���������� ���Ƚ���� �����Ƿ� 0���� �Է��Ѵ�.<br>
		 �� ������ ����ϰ� ��ĵ������ ������ ����մϴ�.
		 </font>
		 
		</td>
	</tr>
</table>
</form>
</BODY>
</HTML>
