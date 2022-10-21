<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	Hashtable ht = v_db.getVacation(user_id);
	
	Vector vt = v_db.getVacationList(user_id, (String)ht.get("YEAR"));
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 미사용 연차의 사용계획서</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
.style2 {color: #747474}
-->
</style>

<style type="text/css">
<!--
.style15 {
	font-size: x-large;
	font-weight: bold;
	font-family: "바탕", "궁서", AppleMyungjo;
}
-->
</style>
<style type="text/css">
<!--
.style23 {font-size: 12px}
.style24 {font-size: 14px}
.style26 {font-size: 14pt}
-->
</style>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/logo.gif width=332 height=52 border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td ><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
		<td align="center" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
			<table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_bg.gif>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_up.gif width=677 height=44></td>
                </tr>
                <tr>
                    <td height=25></td>
                </tr>
                <!--
                <tr>
            		<td align="center">
            			<table width=650 border=0 cellspacing=0 cellpadding=0>
            				<tr>
            				    <td height="30" align=left><span class="style24">문서번호 : 인사09-02-01 </span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">시행일자 : 2009년 02월 24일 </span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">수 &nbsp;&nbsp;&nbsp;&nbsp; 신 : <%if(ht.get("DEPT_ID").equals("0001")){%>영업팀<%}else if(ht.get("DEPT_ID").equals("0002")){%>고객지원팀<%}else if(ht.get("DEPT_ID").equals("0003")){%>총무팀<%}else if(ht.get("DEPT_ID").equals("0007")){%>부산지점<%}else if(ht.get("DEPT_ID").equals("0008")){%>대전지점<%}%> - <%=ht.get("USER_NM")%></span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">참 &nbsp;&nbsp;&nbsp;&nbsp; 조 : <%if(ht.get("DEPT_ID").equals("0001")){%>정채달 팀장님<%}else if(ht.get("DEPT_ID").equals("0002")){%>허승범 팀장님<%}else if(ht.get("DEPT_ID").equals("0003")){%>안보국 팀장님<%}else if(ht.get("DEPT_ID").equals("0007")){%>제인학 지점장님<%}else if(ht.get("DEPT_ID").equals("0008")){%>박영규 지점장님<%}%></span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">제 &nbsp;&nbsp;&nbsp;&nbsp; 목 : 미사용 연차의 사용계획서 제출(요청) </span></td>
            				</tr>
            			</table>
            		</td>
                </tr>-->
                <tr>
            		<td align="center">
            			<table width=608 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/free_time/images/img_bg.gif>
            				<tr>
            				    <td height=90></td>
            				</tr>
            				<tr>
            				    <td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font color=979797><%=ht.get("USER_NM")%> 님</font></b></td>
            				</tr>
            				<tr>
            					<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;귀하의 노고에 감사의 말씀을 드립니다.</td>
            		        </tr>
            		        <tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;아래와 같이 귀하의 미사용 연차현황을 통보하오니</td>
            		        </tr>
            		        <tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=a80331><b>기한(<%= AddUtil.getDate3((String)ht.get("END_DT"))%>)</b></font>내 사용계획서를 작성하고 부서장을</td>
            		    	</tr>
            		    	<tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;경유하여 총무팀 인사담당자에게 제출해 주시길 바랍니다.</td>
            				</tr>
            		        <tr>
                                <td height=30></td>
                            </tr>
            			</table>
            		</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/bar.gif></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
            		<td align="center">
            			<table width=520 border=0 cellspacing=1 cellpadding=0 bgcolor=cacaca>
            		        <tr>
            			        <td colspan="3" bgcolor=f2f2f2 height=27 align=center>연차현황 </td>
            			        <td colspan="3" bgcolor=f2f2f2 align=center>미사용연차소멸일 </td>
            			        <td rowspan="3" width="108" bgcolor=ecf9fb align=center>유효기한을<br>경과한 미사용<br>연차의 처리 </td>
            		        </tr>
            		        <tr>
            			        <td width=14% rowspan="2" bgcolor=f9f9f9 height=27 align=center>연차일수 </td>
            				    <td width=13% rowspan="2" bgcolor=f9f9f9 align=center>사용 </td>
            			        <td width=13% rowspan="2" bgcolor=f9f9f9 align=center>미사용 </td>
            				    <td width=14% rowspan="2" bgcolor=f9f9f9 align=center>년월일 </td>
            				    <td colspan="2" bgcolor=f9f9f9 align=center height=27>남은기간 </td>
            			    </tr>
            			    <tr>
            			        <td width=13% bgcolor=f9f9f9 height=27 align=center>개월</td>
            				    <td width=13% bgcolor=f9f9f9 align=center> 일 </td>
            			    </tr>
            			    <tr>
            				    <td align="center" bgcolor=FFFFFF height=100><%= ht.get("VACATION") %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("SU") %></td>
            				    <td align="center" bgcolor=FFFFFF><font color=a80331><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %></b></font></td>
            				    <td align="center" bgcolor=FFFFFF><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("RE_MONTH") %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("RE_DAY") %></td>
            				    <td align="center" bgcolor=FFFFFF>현금으로<br>보상하지<br>아니하고<br>소멸함</td>
            		        </tr>
            		    </table>
            	    </td>
                </tr>
                <tr>
                    <td height=30 align=center></td>
                </tr>
                <tr>
                    <td  align=center><a href=#><img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/button_down.gif border=0></a></td>
                </tr>
                <tr>
                    <td height=40></td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=20 colspan="3" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td height=20 colspan="3" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td colspan="3" align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td ><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>