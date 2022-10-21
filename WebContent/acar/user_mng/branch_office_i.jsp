<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String br_id = "";						//����ID
    	String br_ent_no = "";					//����ڵ�Ϲ�ȣ
    	String br_nm = "";						//���θ�
    	String br_st_dt = "";					//���������
    	String br_post = "";						//�����ȣ
    	String br_addr = "";						//�ּ�
    	String br_item = "";						//����
    	String br_sta = "";						//����
    	String br_tax_o = "";					//���Ҽ�����
    	String br_own_nm = "";					//��ǥ��
    	String cmd = "";
    	int count = 0;
    
    
    	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert ����
	}
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		if(request.getParameter("br_id") !=null) br_id = request.getParameter("br_id");
		if(request.getParameter("br_ent_no") !=null) br_ent_no = request.getParameter("br_ent_no");
		if(request.getParameter("br_nm") !=null) br_nm = request.getParameter("br_nm");
		if(request.getParameter("br_st_dt") !=null) br_st_dt = request.getParameter("br_st_dt");
		if(request.getParameter("br_post") !=null) br_post = request.getParameter("br_post");
		if(request.getParameter("br_addr") !=null) br_addr = request.getParameter("br_addr");
		if(request.getParameter("br_item") !=null) br_item = request.getParameter("br_item");
		if(request.getParameter("br_sta") !=null) br_sta = request.getParameter("br_sta");
		if(request.getParameter("br_tax_o") !=null) br_tax_o = request.getParameter("br_tax_o");
		if(request.getParameter("br_own_nm") !=null) br_own_nm = request.getParameter("br_own_nm");
		
		br_bean.setBr_id(br_id.trim());
		br_bean.setBr_ent_no(br_ent_no.trim());
		br_bean.setBr_nm(br_nm.trim());
		br_bean.setBr_st_dt(br_st_dt.trim());
		br_bean.setBr_post(br_post.trim());
		br_bean.setBr_addr(br_addr.trim());
		br_bean.setBr_item(br_item.trim());
		br_bean.setBr_sta(br_sta.trim());
		br_bean.setBr_tax_o(br_tax_o.trim());
		br_bean.setBr_own_nm(br_own_nm.trim());
		
		if(cmd.equals("i")){
			count = umd.insertBranch(br_bean);
		}else if(cmd.equals("u")){
			br_id = umd.updateBranch(br_bean);
		}
	}
	BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function UpdateList(id,ent_no,nm,st_dt,post,addr,item,sta,tax_o,own_nm)
{
	var theForm = document.BranchForm;
	theForm.br_id.value = id;
	theForm.br_ent_no.value = ent_no;
	theForm.br_nm.value = nm;
	theForm.br_st_dt.value = st_dt;
	theForm.br_post.value = post;
	theForm.br_addr.value = addr;
	theForm.br_item.value = item;
	theForm.br_sta.value = sta;
	theForm.br_tax_o.value = tax_o;
	theForm.br_own_nm.value = own_nm;
}

function BranchReg()
{
	var theForm = document.BranchForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = 'i';
	theForm.submit();
}
function BranchUp()
{
	var theForm = document.BranchForm;
	if(!CheckField())
	{
		return;
	}
	var br_id = "";
	br_id = theForm.br_id.value;
	if(!confirm(br_id+'�� �����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = 'u';
	theForm.submit();
}
function search_zip()
{
		window.open("./branch_zip_s.jsp", "�����ȣ�˻�", "left=100, top=100, height=500, width=400, scrollbars=yes");
}
function CheckField()
{
	var theForm = document.BranchForm;
	
	if(theForm.br_ent_no.value=="")
	{
		alert("����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�.");
		theForm.br_end_no.focus();
		return false;
	}
	if(theForm.br_id.value=="")
	{
		alert("�����ڵ带 �Է��Ͻʽÿ�.");
		theForm.br_id.focus();
		return false;
	}
	if(theForm.br_nm.value=="")
	{
		alert("���θ� �Է��Ͻʽÿ�.");
		theForm.br_nm.focus();
		return false;
	}
	if(theForm.br_item.value=="")
	{
		alert("������ �Է��Ͻʽÿ�.");
		theForm.br_item.focus();
		return false;
	}
	if(theForm.br_sta.value=="")
	{
		alert("���¸� �Է��Ͻʽÿ�.");
		theForm.br_sta.focus();
		return false;
	}
	if(theForm.br_tax_o.value=="")
	{
		alert("���Ҽ������� �Է��Ͻʽÿ�.");
		theForm.br_tax_o.focus();
		return false;
	}
	if(theForm.br_own_nm.value=="")
	{
		alert("��ǥ�ڸ� �Է��Ͻʽÿ�.");
		theForm.br_own_nm.focus();
		return false;
	}
	return true;
}
	
//-->
</script>
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin="15" onLoad="self.focus()">

<form action="./branch_office_i.jsp" name="BranchForm" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > ����ڰ��� > <span class=style5>����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
                <tr>
                    
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
    	<td class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
	    		<tr>
			    	<td class=title>����ڵ�Ϲ�ȣ</td>
			    	<td>&nbsp;<input type="text" name="br_ent_no" value="" size="14" class=text maxlength=10></td>
			    	<td class=title>�����ڵ�</td>
			    	<td>&nbsp;<input type="text" name="br_id" value="" size="14" class=text maxlength=2></td>
			    	<td class=title>���θ�</td>
			    	<td>&nbsp;<input type="text" name="br_nm" value="" size="14" class=text  maxlength=30></td>
			    	<td class=title>���������</td>
			    	<td>&nbsp;<input type="text" name="br_st_dt" value="" size="13" class=text  maxlength=10></td>
			    </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('br_post').value = data.zonecode;
								document.getElementById('br_addr').value = data.address;
							}
						}).open();
					}
				</script>
			    <tr>
			    	<td class=title>����������</td>
			    	<td colspan=7>&nbsp;
					<input type="text" name='br_post' id="br_post" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='br_addr' id="br_addr" size="89">
					
					</td>
			    	
			    </tr>
			    <tr>
			    	<td width=12% class=title>����</td>
			    	<td width=14%>&nbsp;<input type="text" name="br_item" value="" size="14" class=text></td>
			    	<td width=10% class=title>����</td>
			    	<td width=14%>&nbsp;<input type="text" name="br_sta" value="" size="14" class=text></td>
			    	<td width=11% class=title>���Ҽ�����</td>
			    	<td width=14%>&nbsp;<input type="text" name="br_tax_o" value="" size="14" class=text></td>
			    	<td width=11% class=title>��ǥ��</td>
			    	<td width=14%>&nbsp;<input type="text" name="br_own_nm" value="" size="13" class=text></td>
			    	
			    </tr>
			</table>
    	</td>
    </tr>
	<tr>
    	<td align="right" height=25><a href="javascript:BranchReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;<a href="javascript:BranchUp()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td height=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=5% class=title>�ڵ�</td>
                    <td width=15% class=title>���θ�</td>
                    <td width=15% class=title>����ڵ�Ϲ�ȣ</td>
                    <td width=10% class=title>���������</td>
                    <td width=15% class=title>����</td>
                    <td width=10% class=title>����</td>
                    <td width=30% class=title>�ּ�</td>
                </tr>
<%
    for(int i=0; i<br_r.length; i++){
        br_bean = br_r[i];
%>
				<tr>
                    <td align=center><%= br_bean.getBr_id() %></td>
                    <td align=center><a href="javascript:UpdateList('<%= br_bean.getBr_id() %>','<%= br_bean.getBr_ent_no() %>','<%= br_bean.getBr_nm() %>','<%= br_bean.getBr_st_dt() %>','<%= br_bean.getBr_post() %>','<%= br_bean.getBr_addr() %>','<%= br_bean.getBr_item() %>','<%= br_bean.getBr_sta() %>','<%= br_bean.getBr_tax_o() %>','<%= br_bean.getBr_own_nm() %>')"><%= br_bean.getBr_nm() %></a></td>
                    <td align=center><%= br_bean.getBr_ent_no() %></td>
                    <td align=center><%= br_bean.getBr_st_dt() %></td>
                    <td align=center><%= br_bean.getBr_item() %></td>
                    <td align=center><%= br_bean.getBr_sta() %></td>
                    <td>&nbsp;(<%= br_bean.getBr_post() %>)<%= br_bean.getBr_addr() %></td>
                </tr>
<%}%>		

            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="cmd" vlaue="">
</form>
<script>
<%
	if(cmd.equals("u"))
	{
%>
alert("���������� �����Ǿ����ϴ�.");

<%
	}else{
		if(count==1)
		{
%>
alert("���������� ��ϵǾ����ϴ�.");
<%
		}
	}
%>
</script>
</body>
</html>