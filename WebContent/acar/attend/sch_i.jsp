<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*,acar.common.*" %>
<%@ page import="acar.schedule.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	
	//�ش�μ� �������Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();
	if(auth_rw.equals("6")){
		users = c_db.getUserList("", "", "EMP");
	}else{
		users = c_db.getUserList_dept(user_id); 
	}
	int user_size = users.size();
	
	String dept_id = c_db.getUserDept(user_id);
	
	int year =AddUtil.getDate2(1);
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function ScheReg()
{
	var theForm = document.ScheRegForm;
	if(theForm.user_id.value == ''){	alert("����� �����Ͻʽÿ�.");	return;	}
	if(get_length(theForm.content.value) > 4000){alert("4000�� ������ �Է��� �� �ֽ��ϴ�."); return; }

	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.target = "i_no";
	theForm.submit();
}

function LoadSche()
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

<table border="0" cellspacing="0" cellpadding="0" width=580 >
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > ��ٰ��� > <span class=style5>�������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./sch_null_ui.jsp" name='ScheRegForm' method='post'>
	<tr>
		<td align='right'>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	 		<a href="javascript:ScheReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
		<%}%>
			<a href="javascript:LoadSche()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=580>
                <tr> 
                    <td width=100 class='title'>���</td>
                    <td align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">����</option>
                        <!--default������ login �� ����ڰ� ���õǾ��ֵ���-->
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td width=100 class='title'>����</td>
                    <td align='left' >&nbsp; 
                      <select name="sch_chk">
                        <option value="2">�������</option>
                        <option value="3">����</option>
                        <option value="4">����ް�</option>
                        <option value="5">����</option>
                        <option value="6">������</option>
        				<option value="7">����</option>
        				<option value="8">���</option>
        				<option value='9'>�����ް�</option>
                      </select>
                       &nbsp;
                        <select name="count">
                        <option value="">����</option>
                        <option value="F">����</option>
                        <option value="B1">��������</option>
                        <option value="B2">���Ĺ���</option>                       
                      </select>
                      
                      <input type='text' name='title' size='58' MAXLENGTH='55' class=text>
                    </td>
                </tr>
                <tr> 
                    <td width=100 class='title'>��ü������</td>
                    <td align='left' >&nbsp; 
                      <select name="work_id">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			  &nbsp;(����,�ް�,����,������,����ް��϶� - ���ڹ��� ���� ��ü��)
                    </td>
                </tr>		  		  
                <tr> 
                    <td class='title' width="100">����</td>
                    <td>&nbsp; 
                      <select name="start_year">
        			  <%for(int i=2020; i<=year; i++){%>
                        <option value="<%=i%>" <%if(AddUtil.getDate2(1) == i)%>selected<%%>><%=i%></option>
        			  <%}%>
                      </select>��			
                      <select name="start_mon">
        			  <%for(int i=1; i<13; i++){%>
                        <option value="<%=i%>" <%if(AddUtil.getDate2(2) == i)%>selected<%%>><%=i%></option>
        			  <%}%>
                      </select>��			
                      <select name="start_day">
        			  <%for(int i=1; i<32; i++){%>
                        <option value="<%=i%>" <%if(AddUtil.getDate2(3) == i)%>selected<%%>><%=i%></option>
        			  <%}%>
                      </select>��						  			  
        <!--              <script language="javascript">init2(5,<%=AddUtil.getDate(1)%>,<%=AddUtil.getDate(2)%>,<%=AddUtil.getDate(3)%>); init_display("start");</script>-->
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="100">����</td>
                    <td >&nbsp; 
                      <textarea name='content' rows='17' cols='70'></textarea>
                    </td>
                </tr>
            </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="acar_id" value="<%=user_id%>">
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="s_kd" value="<%=s_kd%>">
			<input type="hidden" name="t_wd" value="<%=t_wd%>">
			<input type="hidden" name="s_year" value="<%=s_year%>">
			<input type="hidden" name="s_month" value="<%=s_month%>">
			<input type="hidden" name="s_day" value="<%=s_day%>">
			<!--
			<input type="hidden" name="start_year" value="<%=AddUtil.getDate(1)%>">
			<input type="hidden" name="start_mon" value="<%=AddUtil.getDate(2)%>">
			<input type="hidden" name="start_day" value="<%=AddUtil.getDate(3)%>">-->
		</td>
	</tr>
	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
