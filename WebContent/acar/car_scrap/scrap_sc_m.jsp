<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"����":request.getParameter("gubun");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "06", "05");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-200;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function regCar_scrap(cmd){
		fm = document.form1;
		if(fm.car_no.value==""){	alert("������ȣ�� �Է��Ͻʽÿ�");	fm.car_no.focus();			return;	}
		else if(fm.car_nm.value==""){	alert("�������� �Է��Ͻʽÿ�");	fm.car_nm.focus();			return;	}
		else if(fm.reg_dt.value==""){	alert("�����������ڸ� �Է��Ͻʽÿ�");	fm.reg_dt.focus();	return;	}

		var str = "";
		if(cmd=='i')				str = "���"; 
		else if(cmd=='u')		str = "����";
		else if(cmd=='d')		str = "����";
		fm.cmd.value = cmd;
		
		if(!confirm(str+'�Ͻðڽ��ϱ�?'))	return;

		fm.target = "i_no";
		fm.submit();
	}
	
	//��ü����
	function AllSelect(){
		var fm = i_in.document.form1;			
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}				
//-->

</script>
</head>
<body <% if(auth_rw.equals("6") && from_page.equals("")){ %>onLoad="document.form1.car_no.focus();"<% } %>>

<form action="car_scrap_iud.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="seq" value="">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line'> 
                        <table  border=0 cellspacing=1 cellpadding="0" width=100%>
			                <colgroup>
			            		<col width="3%;">
			            		<col width="3%;">
			            		<col width="6%;">
			            		<col width="6%;">
			            		<col width="7%;">            		
			            		<col width="7%;">
			            		<col width="7%;">
			            		<col width="5%;">
			            		<col width="7%;">
			            		<col width="5%;">
			            		<col width="10%;">            		
			            		<col width="6%;">
			            		<col width="12%;">
			            		<col width="9%;">
			            		<col width="7%;">
			            	</colgroup>
			                <tr> 
			                    <td class=title rowspan="2">����</td>
			                    <td class=title colspan="6">�����ȣ</td>				  
			                    <td class=title colspan="2">��������</td>
			                    <td class=title colspan="6">������Ȳ</td>
			                </tr>
			                <tr> 
			                    <td class=title>����
			                    	<input type="checkbox" onclick="javascraipt:AllSelect();">
			                    </td>
			                    <td class=title>�ڵ�����ȣ</td>
			                    <td class=title>��뺻����</td>
			                    <td class=title>���ʵ����</td>
			                    <td class=title>��������</td>
			                    <td class=title>��븸����</td>
			                    <td class=title>����</td>
			                    <td class=title>ó������</td>
			                    <td class=title>����</td>
			                    <td class=title>����ȣ</td>
			                    <td class=title>�����</td>
			                    <td class=title>����</td>
			                    <td class=title>�����ȣ</td>
			                    <td class=title>�������</td>
			                </tr>
		                </table>
	                </td>
                </tr>                       
            </table>
        </td>
        <td width='16'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="/acar/car_scrap/scrap_sc_in_m.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&gubun=<%=gubun%>&from_page=<%=from_page%>" name="i_in" width="99%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe> 
        </td>
    </tr>
	<% if(from_page.equals("")){%>
	<% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){ %>
    <tr> 
        <td>
            <table width=100% border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td>
                        <table width=100% border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table border=0 cellspacing=1 cellpadding="0" width=100%>
                                        <tr> 
                                            <td class="title">&nbsp;&nbsp;����&nbsp;&nbsp;</td>
                                            <td class="title">&nbsp;&nbsp;��������ȣ&nbsp;&nbsp;</td>
                                            <td class="title">&nbsp;&nbsp;����&nbsp;&nbsp;</td>
                                            <td class="title">&nbsp;&nbsp;������������&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td width="16%"><div align="center"><input  type="text" name="car_ext" size="10" class=text value=""></div></td>
                                            <td width='20%'> <div align="center"> 
                                                <input  type="text" name="car_no" size="20" class=text value="">
                                              </div></td>
                                            <td width=44%> <div align="center"> 
                                                <input  type="text" name="car_nm" size="50" class=text value="" >
                                              </div></td>
                                            <td width='20%'> <div align="center"> 
                                                <input  type="text" name="reg_dt" size="15" class=text value=""  onBlur='javascript:this.value=ChangeDate(this.value)'>
                                              </div></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align=right><a href="javascript:regCar_scrap('i');"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
                    <a href="javascript:regCar_scrap('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp; 
                    <a href="javascript:regCar_scrap('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a> 
                    </td>
                </tr>
            </table>
        </td>
        <td>&nbsp;</td>
    </tr>
<% } %>
<% } %>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
