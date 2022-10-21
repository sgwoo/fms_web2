<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	
	String ch_cd 	= request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	
    out.println(ch_cd);
    
	ch_cd=AddUtil.substring(ch_cd, ch_cd.length() -1);
	
//	out.println(ch_cd);
	
	Vector vt = new Vector();
	
	Hashtable h_bean = new Hashtable(); 
	
	String car_no="";
	if (!ch_cd.equals("") ) {
                 
		 car_no =mc_db.getMasterCarNo(ch_cd);		 
		 //주소
		   h_bean = mc_db.getMasterCarAddr(ch_cd );			
	}	 
		 
		
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>사업용자동차차령조정신청서</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.5pt; font-family:돋움; font-weight:bold;}


.style3 {font-size:10.5pt; border-left:solid #000000 1px;border-bottom:solid #000000 1px; border-right:0px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {font-size:10.5pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {font-size:10pt; border-left:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {font-size:10pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}

.style1 {font-size:10.5pt; border-left:solid #000000 1px; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {font-size:10.5pt; border-right:solid #000000 0px;padding:1.4pt 1.4pt 1.4pt 1.4pt}


.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:15pt; line-height:150%;}
-->
</STYLE>	

</head>

<body>
<div id="Layer1" style="position:absolute; left:568px; top:540px; width:54px; height:41px; z-index:1"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" >
	<tr>
		<td>	
			<table width="700" border="0" cellspacing="1" cellpadding="0" bgcolor="#000000">
				<tr>
			        <td  bgcolor="#FFFFFF">
			        	<table width="700" border="0" cellspacing="1" cellpadding="0" bgcolor="#000000">
				            <tr bgcolor="#FFFFFF">
				                <td colspan=5>
				                	<table width=700 border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none;'>
				                		<tr>
				                			<td rowspan=2 width=600 align=center><span class=f1>사업용자동차차령조정신청서</span></td>
				                			<td width=100 height="55" align=center class=style3>처리기간</td>
										</tr>
										<tr>
					           				<td height="55" align=center class=style1>즉 시</td>
					           			</tr>
					           		</table>
					           	</td>
					     	</tr>			            
				            <tr bgcolor="#FFFFFF">
								<td width="50" align=center rowspan=2>신청인</td>
								<td width="170" align=center height=70>① 성 명 ( 법인의 경우 <br>명칭 및 대표자 성명)</td>
								<td width="160" align=left>&nbsp;&nbsp;(주) 아마존카</td>
								<td width="160" align=center >② 주민등록번호</td>
								<td width="160" align=left>&nbsp;&nbsp;115611-0019610</td>
				            </tr>
							<tr bgcolor="#FFFFFF">
								<td width="168" align=center height=65>③주 소</td>
								<td colspan=3 align=left>&nbsp;&nbsp;<%=h_bean.get("BR_ADDR")%></td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td align=center colspan=2 height=65>④사 업 의 종 류</td>
							    <td colspan=3 align=left>&nbsp;&nbsp;자동차 대여업</td>
						    </tr>
							<tr bgcolor="#FFFFFF">
								<td align=center colspan=2 height=100>⑤차령조정신청대상<br>자동차의등록번호</td>
							    <td colspan="3" colspan=3 align=left>&nbsp;&nbsp;<%=car_no%>&nbsp;&nbsp;</td>
						    </tr>
			            	<tr bgcolor="#FFFFFF"  valign=top>
								<td align="center" colspan="5">
									<table width=650 border=0 cellspacing=0 cellpadding=15>
										<tr>
											<td><br>여객자동차운수사업법시행규칙 제 103조제1항의 규정에 의하여 사업용자동차의 차령조정을 신청합니다.</td>
										</tr>
										<tr>
											<td align=center><%=AddUtil.getDate(1)%>년 <%=AddUtil.getDate(2)%>월 <%=AddUtil.getDate(3)%>일</td>
										</tr>
										<tr>
											<td align=right>신청인(주) 아 마 존 카 (서명 또는 인)</td>
										</tr>
										<tr>
											<td height=300 align=center><span class=f2><%=h_bean.get("BR_NM")%>시장 귀하</span></td>
										</tr>
									</table>
								</td>
				    		</tr>
							<tr bgcolor="#FFFFFF">
								<td height="70" align="left" colspan="5">&nbsp;&nbsp;구비서류 : 자동차관리법 제 44조의 규정에 의한 자동차검사대행자가 발행한 자동차임시검사<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;합격통지서 1부</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>

</html>

