<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*,acar.common.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
	
	String mtel_scan_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	
	//�ش�μ� �������Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
%>

<HTML>
<HEAD>
<TITLE>�������</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function save()
{
	var fm = document.form1;
	
	if(fm.mtel_scan_file.value == ''){	alert('��ź� ��������  PDF ��ĵ�� �� ����Ͻʽÿ�.'); 	fm.mtel_scan_file.focus(); 	return; }
			
	//��ĵ���� Ȯ���ڰ� ".PDF" ��ġ üũ 
	
	var file = fm.mtel_scan_file.value;
	file = file.slice(file.indexOf("\\") +1 );
	ext = file.slice(file.indexOf(".")).toLowerCase();
	
	if(ext != '.pdf'){
		alert('PDF�� �ƴմϴ�. PDF�� ��ĵ�� ���ϸ� ����� �����մϴ�.'); 	
		fm.mtel_scan_file.focus(); 	
		return;
	}
	
	
	
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	
	
	fm.target = "i_no";
	fm.action = "mtel_scan_a.jsp";	
	fm.submit();
}
function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//-->
</script>

 

</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5>��ź񿵼������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post' enctype="multipart/form-data">
	<tr>
		<td align='right'>
			<a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=600>
                <tr> 
                    <td width=100 class='title'>���</td>
                    <td colspan="2" align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); 
								if(ck_acar_id.equals(user.get("USER_ID"))){

								}
								%>
								
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
						
                        <%	}
        				}		%>
                      </select>
                    </td>
				</tr>
				<tr> 
                    <td class='title' width="100">����</td>
                    <td colspan="2">&nbsp; 
					<select name="st_year">
				<option value="">��ü</option>
				<%for(int i=2009; i<=year; i++){%>
				<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>��</option>
				<%}%>
			</select> 
			<select name="st_mon">
				<option value="">��ü</option>
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>��</option>
				<%}%>
			</select>&nbsp;
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="100">����÷��</td>
                    <td colspan="2" >&nbsp; 
                      <input type="file" name="mtel_scan_file" size = "40">
                    </td>
                </tr>
            </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type='hidden' name="s_width" value="<%=s_width%>">   
			<input type='hidden' name="s_height" value="<%=s_height%>">  
			<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
			
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
