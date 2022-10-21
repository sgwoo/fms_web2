<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.attend.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();	
	
	
	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-70;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
	
	
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') vacationSearch();
}

function vacationSearch(){
	fm = document.form1;
	var auth_rw = fm.auth_rw.value;
	var br_id = fm.br_id.value;
	var dept_id = fm.dept_id.value;
	var user_nm = fm.user_nm.value;
//alert("this");	
	this.inner.location.href = "./vacation_all_in_new.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&dept_id="+dept_id+"&user_nm="+user_nm;
	
}

	
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5>�������� </span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>                
                    <td width="45%" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gmg.gif align=absmiddle>
                        &nbsp;<select name='br_id'>
                          <option value=''>��ü</option>
                          <%	if(brch_size > 0){
                				for (int i = 0 ; i < brch_size ; i++){
                					Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%= branch.get("BR_ID") %>'><%= branch.get("BR_NM")%></option>
                          <%		}
                			}		%>
                        </select> &nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_bs.gif align=absmiddle>&nbsp;<select name="dept_id">
                          <option value="">��ü</option>
                          <option value="0001">������</option>
                          <option value="0020">������ȹ��</option>
                          <option value="0002">��������</option>
                          <option value="0003">�ѹ���</option>
						  <option value="0005">IT��</option>
                          <option value="0007">�λ�����</option>
                          <option value="0008">��������</option>
						  <option value="0009">��������</option>
						  <option value="0010">��������</option>
						  <option value="0011">�뱸����</option>
						  <option value="0014">��������</option>
						  <option value="0015">��������</option>
						  <option value="0016">�������</option>
						  <option value="0017">��ȭ������</option>
						  <option value="0018">��������</option>
                        </select> &nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_sm.gif align=absmiddle> 
                        &nbsp;<input type="text" name="user_nm" value="" class="text" size="15" style="IME-MODE:active;">
                    </td>
                    <td width=30% align="left"><a href="javascript:vacationSearch()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                    <td width=28% align="right"> 
                    	<%if( user_id.equals("000003") || user_id.equals("000203") ){%> &nbsp;
                    	<% } else {%>
					<a href="./vacation_sc_in_new.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= user_id %>"><img src=../images/center/button_see_s.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                             <% } %>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=3% rowspan="3" class="title">����</td>
                    <td width=8% rowspan="3" class="title">�ٹ���</td>
                    <td width=8% rowspan="3" class="title">�μ�</td>
                    <td width=5% rowspan="3" class="title">����</td>
                    <td width=7% rowspan="3" class="title">����</td>
                    <td width=7% rowspan="3" class="title">�Ի���</td>                 
                    <td colspan="3" class="title">��ӱٹ��Ⱓ</td>
                    <td colspan="4" class="title" width=21% >�ٷα��ع� ����</td>
                    <td colspan="4" class="title" width=19% >��Ա��� {�̿�(���� 30�� ����)}</td>	
                    <td width="6%" rowspan="3" class="title">���ް���Ȳ<br>����:����</td>
                    <td width=4% rowspan="3" class="title">����</td>         
                                    
                </tr>
                <tr> 
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=7% rowspan="2" class="title">������</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=7% rowspan="2" class="title">�̻�뿬��<br>�Ҹ꿹����</td>
                                  		               
                </tr>
                <tr> 
                    <td width=4% class="title">����</td>
                    <td width=5% class="title">���</td>
                    <td width=5% class="title">�̻��</td>
                    <td width=4% class="title">�̿�</td>
                    <td width=4% class="title">���</td>
                    <td width=4% class="title">�̻��</td>
                  
                </tr>
            </table>
        </td>
        <td width=16>&nbsp;</td>  
    </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><iframe src="vacation_all_in_new.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= user_id %>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
  </tr>
</table>
</form>
</body>
</html>
