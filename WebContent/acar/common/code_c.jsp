<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 	= request.getParameter("c_st")==null?"":request.getParameter("c_st");
	String code 	= request.getParameter("code")==null?"":request.getParameter("code");
		
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	code_bean = c_db.getCodeBean(c_st, code, auth_rw);	
	ce_bean =  c_db.getCodeEtc(c_st, code);
		
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
function UpDisp()
{
	var theForm = document.CodeDispForm;
	theForm.submit();
}
function CodeClose()
{

	self.close();
	window.close();
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
</head>
<body onLoad="javascript:self.focus()">

<form action="./code_u.jsp" name="CodeDispForm" method="post">
  <input type="hidden" name="c_st" value="<%=c_st%>">
  <input type="hidden" name="code" value="<%=code%>">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">		
  <input type='hidden' name='from_page' value='<%=from_page%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100% style="margin: 0 auto;">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>�ڵ����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>			
			    <tr>
    				<td width=150 class="title">�ڵ屸��</td>
    				<td width=200>&nbsp;<%=code_bean.getC_st()%></td>
    				<td width=150 class="title">�ڵ�</td>
    				<td width=200>&nbsp;<%=code_bean.getCode()%></td>				
    			</tr>			
    			<tr>
    				<td class="title">����ڵ��</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getNm_cd()%></td>
    			</tr>				
    			<tr>
    				<td class="title">�ڵ��Ī</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getNm()%></td>
    			</tr>		
    			<tr>
    				<td class="title">
					<%if(c_st.equals("0001")){%>
					��ó
					<%}else if(c_st.equals("0013")){%>
					�������
					<%}else if(c_st.equals("0018")||c_st.equals("0019")||c_st.equals("0020")||c_st.equals("0021")){%>
					�ŷ�ó�ڵ�
					<%}else if(c_st.equals("0022")){%>
					Ź�۱ݾ�
					<%}else if(c_st.equals("0003")){%>
					���ι�ȣ
					<%}else{%>
					�ݿ�����
					<%}%>	
					</td>
    				<td colspan="3" align="left">&nbsp;
					<%if(c_st.equals("0001")){%>
						<%if(code_bean.getApp_st().equals("1")) {%>����
						<%}else if(code_bean.getApp_st().equals("2")) {%>������
						<%}else{%>�׿�
						<%}%>
					<%}else if(c_st.equals("0013")){%>
						<%if(code_bean.getApp_st().equals("1")) {%>KIS-����
						<%}else if(code_bean.getApp_st().equals("2")){%>ũ��Ž-����
						<%}else if(code_bean.getApp_st().equals("3")){%>ũ��ž-����
						<%}else{%>����
						<%}%>						
					<%}else{%>
					<%= code_bean.getApp_st() %>
					<%}%>	
					</td>
    			</tr>																	
    			<tr>
    				<td class="title">CMS����ڵ�</td>
    				<td colspan="3" align="left">&nbsp;<%=code_bean.getCms_bk()%></td>
    			</tr>	
    			
    			    <%if(c_st.equals("0003")){%> <!--  �����̸�, ���ĸ�Ī, �ּ� ����   -->
    			<tr>
				<td class="title">����</td>
				<td colspan="3" align="left">&nbsp;
				<%if(ce_bean.getGubun().equals("1")) {%>����
				<%}else if(ce_bean.getGubun().equals("2")){%>ĳ��Ż
				<%}else if(ce_bean.getGubun().equals("3")){%>�������� ��
				<%}else if(ce_bean.getGubun().equals("4")){%>��Ÿ �������
				<%} %>
				</td>
			</tr>					    
     			<tr>
				<td class="title">�����Ī</td>
				<td colspan="3" align="left">&nbsp;<%=ce_bean.getNm()%></td>				
			</tr>
			<tr>
			  <td class=title>�����ȣ</td>
			  <td colspan=3>&nbsp;<%=ce_bean.getZip()%></td>		
			</tr>
			<tr>
			  <td class=title>�ּ�</td>
			  <td colspan=3>&nbsp;<%=ce_bean.getAddr()%></td>			
			</tr>
    
    		<% } %>											
		    </table>		
	    </td>
	</tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һα�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
        <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>			
			    <tr>
    				<td width=150 class="title">����ȯ�� �ݾ�ó�� </td>
    				<td width=550>&nbsp;<%if(code_bean.getVar1().equals("1")){%>�Ҽ��� ����<%}%><%if(code_bean.getVar1().equals("7")){%>������ ����<%}%></td>
    			</tr>			
    			<tr>
    				<td class="title">���ڰ����</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar2().equals("1")){%>12����������<%}%>
		                <%if(code_bean.getVar2().equals("2")){%>���̿�������(365��)<%}%>
		                <%if(code_bean.getVar2().equals("4")){%>���̿�������(�����ϼ�)<%}%>
		                <%if(code_bean.getVar2().equals("3")){%>�����Է°�<%}%>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">���� �ݾ�ó��</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar3().equals("1")){%>�Ҽ��� ����<%}%>
		                <%if(code_bean.getVar3().equals("8")){%>�Ҽ��� ����<%}%>
		                <%if(code_bean.getVar3().equals("2")){%>�Ҽ��� �ݿø�<%}%>
		                <%if(code_bean.getVar3().equals("7")){%>������ ����<%}%>
		                <%if(code_bean.getVar3().equals("3")){%>������ ����<%}%>
		                <%if(code_bean.getVar3().equals("4")){%>�ʿ����� ����<%}%>
		                <%if(code_bean.getVar3().equals("5")){%>�ʿ����� ����<%}%>
		                <%if(code_bean.getVar3().equals("6")){%>�ʿ����� �ݿø�<%}%>
    				</td>
    			</tr>		
    			<tr>
    				<td class="title">1ȸ�� ���ڰ��</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar4().equals("Y")){%>1ȸ�� ���� ���ڰ�� �Ѵ�.<%}%>   
    				</td>
    			</tr>		 
    			<tr>
    				<td class="title">������ȸ�� ���ڰ��</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar5().equals("Y")){%>������ȸ�� ���� ���ڰ�� �Ѵ�. (������ȸ�� �������� ����� ����)<%}%>
    				</td>
    			</tr>	   	
    			<tr>
    				<td class="title">���ڰ�� ���� ���Կ���</td>
    				<td>&nbsp;
    				    <%if(code_bean.getVar6().equals("2")){%>���� �һ���<%}%>
		                <%if(code_bean.getVar6().equals("1")){%>���� ����<%}%>
    				</td>
    			</tr>	 		
		    </table>		
	    </td>
	</tr>    
	<tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
	<tr>
		<td colspan='4' align='right'>
		<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
		 <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify_s.gif border=0></a> 
		<%	}%>
		<a href="javascript:CodeClose()" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0></a></td>
	</tr>
	
</table>
</form>		

</body>
</html>