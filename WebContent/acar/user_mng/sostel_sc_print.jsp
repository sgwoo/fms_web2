	<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.partner.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_nm = request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String user_h_tel = request.getParameter("user_h_tel")==null?"":request.getParameter("user_h_tel");	
	String in_tel = request.getParameter("in_tel")==null?"":request.getParameter("in_tel");
	String i_fax = request.getParameter("i_fax")==null?"":request.getParameter("i_fax");
	String hot_tel = request.getParameter("hot_tel")==null?"":request.getParameter("hot_tel");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	UsersBean user_r [] = umd.getUserAllSostel(s_br_id, dept_id, user_nm);
	
	Vector vt = po_db.PartnerAll(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
	
	int a = 0;
	int su = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>(��)�Ƹ���ī ������</title>
<link rel="stylesheet" type="text/css" href="../../include/table_sos.css">
<script language="JavaScript">
<!--

//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 7px;}
.style4 {color: #737373; font-size: 7px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 7px;}

body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->

</style>

</head>
<!-- MeadCo ScriptX -->
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>

<body>

<table border=0 cellspacing=0 cellpadding=0 width=750>
    <tr>
        <td align=center colspan=3 style='font-size:11pt'><span class=style5 >< (��)�Ƹ���ī ������ ></span></td>
    </tr>
    <tr>
        <td width=49% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <!-- �ӿ� ���� -->
				<tr>
                    <td style="font-size:7pt"><b>�� �ӿ� ��</b></td>
                </tr>
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>
                        	<tr>
                        		<td width=12% class=title>����</td>
                        		<td width=12% class=title>����</td>
                        		<td width=22% class=title>H.P</td>
                        		<td width=10% class=title>����</td>
                        		<td width=22% class=title>���ѽ�</td>
                        		<td width=22% class=title>����</td>
                        	</tr>
<%
	for(int i=0; i<user_r.length; i++){
		user_bean = user_r[i];
%>
	<%if(user_bean.getUser_id().equals("000003")){%>  
                            <tr>
            					<td align=center><%=user_bean.getUser_pos()  %></td>
                        		<td align=center><%= user_bean.getUser_nm() %></td>
                        		<td align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td align=center><%= user_bean.getIn_tel()%></td>
                        		<td align=center>&nbsp;</td>
                        		<td align=center>&nbsp;</td>
                        	</tr>
				<% } %>
	<%if(user_bean.getUser_id().equals("000004")){%>
                        	<tr>
            					<td align=center><%=user_bean.getUser_pos()  %></td>
                        		<td align=center><%= user_bean.getUser_nm() %></td>
                        		<td align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td align=center><%= user_bean.getIn_tel()%></td>
                        		<td align=center><%= user_bean.getI_fax()%></td>
                        		<td align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
				<% } %> 
	<%if(user_bean.getUser_id().equals("000005")){%>       
                        	<tr>
            					<td align=center><%=user_bean.getUser_pos()  %></td>
                        		<td align=center><%= user_bean.getUser_nm() %></td>
                        		<td align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td align=center><%= user_bean.getIn_tel()%></td>
                        		<td align=center><%= user_bean.getI_fax()%></td>
                        		<td align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
    			<% } %> 
<% } %> 
                        </table>
                    </td>
                </tr>
                <!--  �ӿ� �� -->
								  <!--  ������ȹ�� ���� -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0020")&&!user_bean.getUser_id().equals("000005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� ������ȹ��(<%=su%>��) ��</b> ��ǥ : 02)757-0802 FAX : 02)757-0803</td>
                </tr>
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>     
							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0020")&&!user_bean.getUser_id().equals("000005")){%>
							<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
						<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  ������ȹ�� �� -->
                <!--  ������ ���� -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0001")&&!user_bean.getUser_id().equals("000005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� ������(<%=su%>��) ��</b> ��ǥ : 02)757-0802 FAX : 02)757-0803</td>
                </tr>
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>            			
                        	
							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0001")&&!user_bean.getUser_id().equals("000005")){%>
							<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
						<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  ������ �� -->

                 <!--  ��������  ���� -->
				 <%
				 su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0002")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� ���� (<%=su%>��) ��</b> ��ǥ : 02)392-4242 FAX : 02)3775-4243</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>            				

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0002")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%> 
                        </table>
                    </td>
                </tr>

 			<!--  �ѹ��� ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0003")&&!user_bean.getUser_id().equals("000004")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �ѹ��� (<%=su%>��)��</b> ��ǥ : 02)392-4243 FAX : 02)757-0803</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>
 
							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0003")&&!user_bean.getUser_id().equals("000004")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  �ѹ��� �� -->
				 <!--  IT�� ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� IT�� (<%=su%>��)��</b> FAX : 02)757-0803 ���ѽ� : 0506-200-1864</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>            				
 
							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0005")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  IT�� �� -->
				
				
				<%
				 su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0014")){
					su += 1;
					}
					}
				%>
				<tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��) ��</b> ��ǥ : 02)2636-9920 FAX : 02)2636-9928</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%> 

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0014")){%>
                        	<tr>
                        		<%-- <td align="12%"><% if ( user_bean.getLoan_st().equals("1")) {%>������
			             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>����
			             		<% } %></td> --%>
             		
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%> 
                        </table>
                    </td>
                </tr>

				<%
				 su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0015")){
					su += 1;
					}
					}
				%>
				<tr>
                    <td style="font-size:7pt"><b>�� ��õ���� (<%=su%>��) ��</b> ��ǥ : 02)2038-7575 FAX : 02)2038-7577</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0015")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
							<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  �������� �� -->

        
            </table>
        </td>
        <td width=2%>&nbsp;</td>
        <td width=49% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            
            
                     <!--  ��õ ���� -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0012")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� ��õ���� (<%=su%>��)��</b> ��ǥ : 032)554-8820 FAX : 032)719-8765</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%> 
                        	<tr>
                        		<td width=12% class=title>����</td>
                        		<td width=12% class=title>����</td>
                        		<td width=22% class=title>H.P</td>
                        		<td width=10% class=title>����</td>
                        		<td width=22% class=title>���ѽ�</td>
                        		<td width=22% class=title>����</td>
                        	</tr>
							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0012")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  ��õ �� -->
                
                 <!--  ���� ���� -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0013")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��)��</b> ��ǥ : 031)546-8858 FAX : 031)546-8838</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%> 

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0013")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  ���� �� -->
                                

                 <!--  �������� ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0009")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��)��</b> ��ǥ : 02)537-5877 FAX : 02)537-5977</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0009")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  �������� �� -->
				<!--  ���� ���� -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0017")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� ��ȭ������ (<%=su%>��)��</b> ��ǥ : 02)2038-8661 FAX : 02)2038-8540</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0017")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  ���� �� -->
				
            
			<!--  ���� ���� -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0018")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��)��</b> ��ǥ : 02)2038-2492 FAX : 02)2038-6786</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0018")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  ���� �� -->
			

                 <!--  ���� ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0010")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��)��</b> ��ǥ : 062)385-0133 FAX : 062)385-0775</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0010")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  ���� �� -->

                 <!--  �뱸 ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0011")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �뱸���� (<%=su%>��)��</b> ��ǥ : 053)582-2998 FAX : 053)582-2999</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0011")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  �뱸 �� -->

                 <!--  �������� ���� -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0008")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �������� (<%=su%>��)��</b> ��ǥ : 042)824-1770 FAX : 042)824-1870</td>
                </tr>
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0008")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  �������� �� -->

                <!--  �λ����� ���� -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0007")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>�� �λ����� (<%=su%>��)��</b> ��ǥ : 051)851-0606 FAX : 051)851-1036</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>

							<%
								for(int i=0; i<user_r.length; i++){
									user_bean = user_r[i];
							%>
							<%if(user_bean.getDept_id().equals("0007")){%>
                        	<tr>
            					<td width=12% align=center><%=user_bean.getUser_pos()  %></td>
                        		<td width=12% align=center><%= user_bean.getUser_nm() %></td>
                        		<td width=22% align=center><%= user_bean.getUser_m_tel()%></td>
                        		<td width=10% align=center><%= user_bean.getIn_tel()%></td>
                        		<td width=22% align=center><%= user_bean.getI_fax()%></td>
                        		<td width=22% align=center><%= user_bean.getHot_tel() %></td>
                        	</tr>
            				<%}%>
							<%}%>
							
							<% if(user_r.length == 0) { %>
							<tr>
								<td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  �λ����� �� -->
                <!--  ��õ ���� -->
<!--  ���/����  -->
				<tr>
                    <td style="font-size:7pt"><b>�� ����⵿/����� ��</b></td>
                </tr>
				<tr>
					<td class=line>
						<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=30% class=title>����Ÿ�ڵ���<br>����⵿</td>
								<td width=20% align=center>1588-6688</td>
								<td width=30% class=title>��Ʈī��������</td>
								<td width=20% align=center>1661-7977</td>
							</tr> 
							<tr>
								<td class=title>SK��Ʈ����<br>(����⵿)</td>
								<td align=center>1670-5494</td>
								<td class=title>��������⵿<br>(�Ƹ���ī������ȣ)</td>
								<td align=center>1661-7977</td>
							</tr> 
							<tr>
								<td class=title>����ȭ��</td>
								<td align=center>1588-0100</td>
								<td class=title>�Ｚȭ��</td>
								<td align=center>1588-5114</td>
							</tr> 										
						</table>
					</td>
				</tr>
				
            </table>     
        </td>
    </tr>
</table>


<!--  ���¾�ü ���� -->
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table border=0 cellspacing=0 cellpadding=0 width=750>
    <tr>
        <td align=center colspan=3 style='font-size:11pt'><span class=style5 >< (��)�Ƹ���ī ���¾�ü ������ ></span></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width=100% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            <!--  ����  -->
				<tr>
                    <td style="font-size:7pt"><b>�� ��Ÿ���� ��</b></td>
                </tr>
				<tr>
					<td class=line>
						<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=15% class=title>��������</td>
								<td width=40% align=center>031)959-7626</td>
								<td width=15% class=title>��õ����</td>
								<td width=30%  align=center>031)532-3379</td>
							</tr> 				
						</table>
					</td>
				</tr>
            	<tr>
                    <td style="font-size:7pt"><b>�� ���¾�ü ��</b></td>
                </tr>
            	<tr>
                    <td class=line>
                    	<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=15% class=title align="center">����</td>
								<td width=25% class=title align="center">��ü</td>
								<td width=15% class=title align="center">����</td>
								<td width=15% class=title align="center">H.P</td>
								<td width=15% class=title align="center">����</td>
								<td width=15% class=title align="center">�ѽ�</td>
							</tr>
							<% if(vt_size > 0)	{
								for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);

							%>
							<tr>
								<td align="center"><%=ht.get("PO_GUBUN2")%></td>
								<td align="center"><%=ht.get("PO_NM")%></td>
								<td align="center"><%=ht.get("PO_OWN")%></td>
								<td align="center"><%=ht.get("PO_M_TEL")%></td>
								<td align="center"><%=ht.get("PO_O_TEL")%></td>
								<td align="center"><%=ht.get("PO_FAX")%></td>
							</tr>
							<%}
							}else{%>            	
						    <tr>
						        <td colspan=6 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
						    </tr>
							<%}%> 
						</table>
					</td>
				</tr>
			</table>
        </td>
	</tr>
</table>
   
    <!--  ���¾�ü �� -->
</body>
</html>
<script>
onprint();

function onprint(){
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 5.0; //��������   
factory.printing.topMargin = 5.0; //��ܿ���    
factory.printing.rightMargin = 5.0; //��������
factory.printing.bottomMargin = 5.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>

