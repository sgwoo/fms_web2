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
<title>(주)아마존카 연락망</title>
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
        <td align=center colspan=3 style='font-size:11pt'><span class=style5 >< (주)아마존카 연락망 ></span></td>
    </tr>
    <tr>
        <td width=49% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <!-- 임원 시작 -->
				<tr>
                    <td style="font-size:7pt"><b>★ 임원 ★</b></td>
                </tr>
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>
                        	<tr>
                        		<td width=12% class=title>직급</td>
                        		<td width=12% class=title>성명</td>
                        		<td width=22% class=title>H.P</td>
                        		<td width=10% class=title>내선</td>
                        		<td width=22% class=title>웹팩스</td>
                        		<td width=22% class=title>직통</td>
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
                <!--  임원 끝 -->
								  <!--  영업기획팀 시작 -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0020")&&!user_bean.getUser_id().equals("000005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 영업기획팀(<%=su%>명) ★</b> 대표 : 02)757-0802 FAX : 02)757-0803</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
						<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  영업기획팀 끝 -->
                <!--  영업팀 시작 -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0001")&&!user_bean.getUser_id().equals("000005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 영업팀(<%=su%>명) ★</b> 대표 : 02)757-0802 FAX : 02)757-0803</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
						<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  영업팀 끝 -->

                 <!--  고객지원팀  시작 -->
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
                    <td style="font-size:7pt"><b>★ 고객지원팀 본사 (<%=su%>명) ★</b> 대표 : 02)392-4242 FAX : 02)3775-4243</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%> 
                        </table>
                    </td>
                </tr>

 			<!--  총무팀 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0003")&&!user_bean.getUser_id().equals("000004")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 총무팀 (<%=su%>명)★</b> 대표 : 02)392-4243 FAX : 02)757-0803</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  총무팀 끝 -->
				 <!--  IT팀 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0005")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ IT팀 (<%=su%>명)★</b> FAX : 02)757-0803 웹팩스 : 0506-200-1864</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  IT팀 끝 -->
				
				
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
                    <td style="font-size:7pt"><b>★ 강서지점 (<%=su%>명) ★</b> 대표 : 02)2636-9920 FAX : 02)2636-9928</td>
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
                        		<%-- <td align="12%"><% if ( user_bean.getLoan_st().equals("1")) {%>고객지원
			             		<% } else if ( user_bean.getLoan_st().equals("2")) {%>영업
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
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
                    <td style="font-size:7pt"><b>★ 부천지점 (<%=su%>명) ★</b> 대표 : 02)2038-7575 FAX : 02)2038-7577</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%> 
                        </table>
                    </td>
                </tr>
                <!--  고객지원팀 끝 -->

        
            </table>
        </td>
        <td width=2%>&nbsp;</td>
        <td width=49% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            
            
                     <!--  인천 시작 -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0012")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 인천지점 (<%=su%>명)★</b> 대표 : 032)554-8820 FAX : 032)719-8765</td>
                </tr>
                
                <tr>
                    <td class=line>
                        <table border=0 cellspacing=1 cellpadding=0 width=100%> 
                        	<tr>
                        		<td width=12% class=title>직급</td>
                        		<td width=12% class=title>성명</td>
                        		<td width=22% class=title>H.P</td>
                        		<td width=10% class=title>내선</td>
                        		<td width=22% class=title>웹팩스</td>
                        		<td width=22% class=title>직통</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  인천 끝 -->
                
                 <!--  수원 시작 -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0013")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 수원지점 (<%=su%>명)★</b> 대표 : 031)546-8858 FAX : 031)546-8838</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  수원 끝 -->
                                

                 <!--  강남지점 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0009")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 강남지점 (<%=su%>명)★</b> 대표 : 02)537-5877 FAX : 02)537-5977</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  강남지점 끝 -->
				<!--  종로 시작 -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0017")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 광화문지점 (<%=su%>명)★</b> 대표 : 02)2038-8661 FAX : 02)2038-8540</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  종로 끝 -->
				
            
			<!--  송파 시작 -->
				 
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0018")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 송파지점 (<%=su%>명)★</b> 대표 : 02)2038-2492 FAX : 02)2038-6786</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>

                <!--  송파 끝 -->
			

                 <!--  광주 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0010")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 광주지점 (<%=su%>명)★</b> 대표 : 062)385-0133 FAX : 062)385-0775</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  광주 끝 -->

                 <!--  대구 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0011")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 대구지점 (<%=su%>명)★</b> 대표 : 053)582-2998 FAX : 053)582-2999</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  대구 끝 -->

                 <!--  대전지점 시작 -->
				 <% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0008")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 대전지점 (<%=su%>명)★</b> 대표 : 042)824-1770 FAX : 042)824-1870</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  대전지점 끝 -->

                <!--  부산지점 시작 -->
				<% su = 0;
                for(int i=0; i<user_r.length; i++){
                    user_bean = user_r[i];
					if(user_bean.getDept_id().equals("0007")){
					su += 1;
					}
					}
				%>
                <tr>
                    <td style="font-size:7pt"><b>★ 부산지점 (<%=su%>명)★</b> 대표 : 051)851-0606 FAX : 051)851-1036</td>
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
								<td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
							</tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!--  부산지점 끝 -->
                <!--  인천 시작 -->
<!--  긴급/보험  -->
				<tr>
                    <td style="font-size:7pt"><b>★ 긴급출동/보험사 ★</b></td>
                </tr>
				<tr>
					<td class=line>
						<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=30% class=title>마스타자동차<br>긴급출동</td>
								<td width=20% align=center>1588-6688</td>
								<td width=30% class=title>렌트카공제조합</td>
								<td width=20% align=center>1661-7977</td>
							</tr> 
							<tr>
								<td class=title>SK네트웍스<br>(긴급출동)</td>
								<td align=center>1670-5494</td>
								<td class=title>공제긴급출동<br>(아마존카차량번호)</td>
								<td align=center>1661-7977</td>
							</tr> 
							<tr>
								<td class=title>동부화재</td>
								<td align=center>1588-0100</td>
								<td class=title>삼성화재</td>
								<td align=center>1588-5114</td>
							</tr> 										
						</table>
					</td>
				</tr>
				
            </table>     
        </td>
    </tr>
</table>


<!--  협력업체 시작 -->
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table border=0 cellspacing=0 cellpadding=0 width=750>
    <tr>
        <td align=center colspan=3 style='font-size:11pt'><span class=style5 >< (주)아마존카 협력업체 연락망 ></span></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width=100% valign=top>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            <!--  지점  -->
				<tr>
                    <td style="font-size:7pt"><b>★ 기타지역 ★</b></td>
                </tr>
				<tr>
					<td class=line>
						<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=15% class=title>파주지점</td>
								<td width=40% align=center>031)959-7626</td>
								<td width=15% class=title>포천지점</td>
								<td width=30%  align=center>031)532-3379</td>
							</tr> 				
						</table>
					</td>
				</tr>
            	<tr>
                    <td style="font-size:7pt"><b>★ 협력업체 ★</b></td>
                </tr>
            	<tr>
                    <td class=line>
                    	<table border=0 cellspacing=1 width=100%>
							<tr>
								<td width=15% class=title align="center">구분</td>
								<td width=25% class=title align="center">업체</td>
								<td width=15% class=title align="center">성명</td>
								<td width=15% class=title align="center">H.P</td>
								<td width=15% class=title align="center">내선</td>
								<td width=15% class=title align="center">팩스</td>
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
						        <td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
						    </tr>
							<%}%> 
						</table>
					</td>
				</tr>
			</table>
        </td>
	</tr>
</table>
   
    <!--  협력업체 끝 -->
</body>
</html>
<script>
onprint();

function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.topMargin = 5.0; //상단여백    
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.bottomMargin = 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>

