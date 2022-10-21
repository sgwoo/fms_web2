<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String ib_dt = request.getParameter("ib_dt")==null?"":request.getParameter("ib_dt");
	String ib_gubun = request.getParameter("ib_gubun")==null?"":request.getParameter("ib_gubun");
	String ib_content = request.getParameter("ib_content")==null?"":request.getParameter("ib_content");
	String ib_job = request.getParameter("ib_job")==null?"":request.getParameter("ib_job");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//�μ�����Ʈ ��ȸ
	DeptBean dept_r [] = umd.getDeptAll();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>�λ�߷ɻ��� �Է�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	if(fm.ib_dt.value == "")	{ 	alert("��¥�� �Է��ϼ���."); 	return;	}
	if(fm.ib_type.value == "")	{ 	alert("�׸��� �����ϼ���."); 	return;	}
	 
	if (fm.ib_type.value == "1" ) {
		if(fm.ib_job.value == "")	{ 	alert("������ �����ϼ���."); 	return;	}
	} else {
		if(fm.ib_dept.value == "")	{ 	alert("�μ��� �����ϼ���."); 	return;	}
	}
			
	if(confirm('����Ͻðڽ��ϱ�?')){	
		fm.cmd.value = "ib";	
		fm.target="i_no";
		fm.action="./insa_card_null.jsp";		
		fm.submit();
	}
}


function cng_input(val){
	
	var fm = document.form1;
		
	if(val == '1'){ 		//���� 		
			tr_1.style.display 	= '';	
			tr_2.style.display 	= 'none';
	} else {	
			tr_1.style.display 	= 'none';	
			tr_2.style.display 	= '';
	}		
}	

//-->
</script>
</head>

<body>
<form name='form1'  method='post'>
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="cmd" value="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > �������� > �λ���ī�� > <span class=style5> �λ�߷ɻ��� �Է�</span></span></td>
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
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100% >
				<tr>
					<td class=title width="10%">��¥</td>
					<td width="15%">&nbsp;<input type='text' name="ib_dt" value='' size='15' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
					<td class=title width="10%">����</td>
					<td width="15%" ALIGN="CENTER">
						<SELECT NAME="ib_gubun">
							<OPTION VALUE="1">�����λ�</OPTION>
							<OPTION VALUE="2">�����λ�</OPTION>
						</SELECT>
					</td>
				</tr>
				<tr>
					<td class=title width="10%">�׸�</td>
					<td width="15%">&nbsp;
						<SELECT NAME="ib_type" onchange="javascript:cng_input(this.options[this.selectedIndex].value); ">
							<OPTION VALUE="1">����</OPTION>
							<OPTION VALUE="2">�μ�</OPTION>
						</SELECT>
					</td>
					
					<td colspan=2  id=tr_1 width="15%" ALIGN="CENTER"  style="display:''">
						<SELECT NAME="ib_job">
							<option value="">����</option>
							<OPTION VALUE="1">�ܱ���-1��</OPTION>
							<OPTION VALUE="2">�ܱ���-2��</OPTION>
							<OPTION VALUE="3">������</OPTION>
						</SELECT>
					</td>
					
					<td colspan=2 id=tr_2 width="15%" ALIGN="CENTER" style='display:none'>
						<SELECT NAME="ib_dept">
						 <option value="">����</option>
        <%    				for(int i=0; i<dept_r.length; i++){
                				dept_bean = dept_r[i];%>
           				  <option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
        <%					}%>								
        				</select>
					</td>
					
				</tr>
				<tr>
					<td class=title width="10%">����</td>
					<td colspan="3" >&nbsp;<input type='text' name="ib_content" value='' size='100' class='text'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h align="right">  </td>
	<tr> 
        <td class=h align="right">
        	<a href="javascript:reg()"><img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle"></a>
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" border="0" align="absmiddle"></a>        	
        	</td>
    </tr>
</table>

</body>
</html>
