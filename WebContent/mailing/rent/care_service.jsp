<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*,  acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	
	String e_mail 	= request.getParameter("e_mail")==null?"":request.getParameter("e_mail");
	
	Vector  base = ad_db.getContCareEmail(e_mail);	
	int base_size = base.size();
		
%>	
	
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존케어 서비스</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #334ec5;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
    	<td height=4 bgcolor=#ea4f06></td>
    </tr>
    <tr>
        <td>
        	<table width=700 border=0 cellspacing=1 cellpadding=0 align=center bgcolor=#e2e2e2>
        		<tr>
        			<td bgcolor=#FFFFFF>
        				<table width=698 border=0 cellspacing=0 cellpadding=0>
			        		<tr>
			        			<td height=24 background=https://fms5.amazoncar.co.kr/mailing/images/mail_bg.gif>&nbsp;</td>
			        		</tr>
			        		<tr>
			        			<td height=20></td>
			        		</tr>
			        		<tr>
			        			<td  align=center>
						            <table width=677 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/care_bg.gif>
						                <tr>
						                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/care_1.jpg border=0></td>
						                </tr>
						                <tr>
						                	<td align=center>
						                		<table width=677 border=0 cellspacing=0 cellpadding=0>
						                			<tr>
						                				<td height=25></td>
						                			</tr>
						                			<tr>
						                				<td width=150 align=right><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/care_img.jpg></td>
						                				<td width=30>&nbsp;</td>
						                				<td>
						                					<table width=100% border=0>
						                					       <%	for(int i = 0 ; i < base_size ; i++){
									Hashtable ht = (Hashtable)base.elementAt(i);%>     
						                						<tr>
						                							<td width=180  height=18>
						                					<b>·</b> <%=ht.get("CAR_NM")%> (<font color=ba4c70><%=ht.get("CAR_NO")%></font>) </td>
						                					<td><%=ht.get("USER_NM")%>&nbsp;&nbsp;<%=ht.get("USER_M_TEL")%></td>
						                						</tr>
						                						 <%	}%> 
						                					</table>
						                				</td>
						                			</tr>
						                			
						                 			
						                			<tr>
						                				<td height=45></td>
						                			</tr>
						                		</table>
						                	</td>
						                </tr>
						                <tr>
						                	<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/care_2.jpg border=0></td>
						                </tr>
						            </table>
						        </td>
						    </tr>             
						    <tr>
						        <td height=35></td>
						    </tr>
						    <tr>
						        <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
						    </tr>
						    <tr>
						        <td height=35></td>
						    </tr>
						    <tr>
						        <td align=center valign=bottom>
						            <img src=https://fms5.amazoncar.co.kr/mailing/images/mail_bottom.gif width=622 height=100 border=0>
						        </td>
						    </tr>
						    <tr>
			        			<td height=24 background=https://fms5.amazoncar.co.kr/mailing/images/mail_bg_1.gif>&nbsp;</td>
			        		</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height=4 bgcolor=#ea4f06></td>
    </tr>
</table>
</body>
</html>