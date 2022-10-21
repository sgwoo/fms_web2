<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
	//영업소 리스트 이동
	function goCarOffList(gubun1, gubun2, gubun3, gubun4){
		var fm = document.form1;
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;		
		fm.gubun3.value = gubun3;
		fm.gubun4.value = gubun4;		
		fm.action = "car_office_frame.jsp";	
		fm.target = "d_content";
		fm.submit();
	}
	//영업사원 리스트 이동
	function goCarOffEmpList(gubun1, gubun2, gubun3, gubun4){
		var fm = document.form1;
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;		
		fm.gubun3.value = gubun3;
		fm.gubun4.value = gubun4;		
		fm.action = "car_office_p_frame.jsp";	
		fm.target = "d_content";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<%if(!gubun1.equals("")){
		Vector stats = cod.getCarOffStatLoc(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd);
		int stat_size = stats.size();
		int h_cnt[] = new int[4];%>
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=gubun1%></span></td>
	</tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
				<tr>
				    <td class='line'>
					    <table  border=0 cellspacing=1 width="100%">
                            <tr>
                                <td width="6%" rowspan="2" class=title>연번</td>
                                <td width="22%" rowspan="2" class=title>시/구/군</td>
                                <td colspan="3" class=title>영업소</td>
                                <td colspan="3" class=title>영업사원</td>
                            </tr>
                            <tr>
                                <td width="12%" class=title>지점</td>
                                <td width="12%" class=title>대리점</td>
                                <td width="12%" class=title>소계</td>
                                <td width="12%" class=title>지점</td>
                                <td width="12%" class=title>대리점</td>
                                <td width="12%" class=title>소계</td>
                            </tr>
                           <%for(int i=0; i<stat_size ; i++){
								Hashtable stat = (Hashtable)stats.elementAt(i);
							%>						   
                            <tr align="center">
                                <td><%=i+1%></td>
                                <td><%if(gubun1.equals("기타")){%><%=stat.get("SIDO")+" "%><%}%><%=stat.get("GUGUN")%></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("O_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("O_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")))%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("E_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("E_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")))%></a></td>
                            </tr>
                           <%	h_cnt[0] = h_cnt[0] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")));
							   	h_cnt[1] = h_cnt[1] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")));
							   	h_cnt[2] = h_cnt[2] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")));
							   	h_cnt[3] = h_cnt[3] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")));
						   }%>
                            <tr align="center">
                                <td colspan="2" class=title>합계</td>
                                <td class=title><%=h_cnt[0]%></td>
                                <td class=title><%=h_cnt[1]%></td>
                                <td class=title><%=h_cnt[0]+h_cnt[1]%></td>
                                <td class=title><%=h_cnt[2]%></td>
                                <td class=title><%=h_cnt[3]%></td>
                                <td class=title><%=h_cnt[2]+h_cnt[3]%></td>
                            </tr>						   
                        </table>
                    </td>
				</tr>
			</table>
		</td>
	</tr>	
	<%}%>	
	<%if(gubun1.equals("")){
		Vector stats1 = cod.getCarOffStatLoc("서울", gubun2, gubun3, gubun4, s_kd, t_wd);
		int stat_size1 = stats1.size();
		Vector stats2 = cod.getCarOffStatLoc("경기", gubun2, gubun3, gubun4, s_kd, t_wd);
		int stat_size2 = stats2.size();
		Vector stats3 = cod.getCarOffStatLoc("인천", gubun2, gubun3, gubun4, s_kd, t_wd);
		int stat_size3 = stats3.size();
		Vector stats4 = cod.getCarOffStatLoc("기타", gubun2, gubun3, gubun4, s_kd, t_wd);
		int stat_size4 = stats4.size();
		int h_cnt[] = new int[20];%>

    <tr>
		<td>&nbsp;</td>
	</tr>	
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
				<tr>
					<td class='line'>
						 <table  border=0 cellspacing=1 width="100%">
                            <tr>
                                <td width="6%" rowspan="2" class=title>지역</td>
                                <td width="6%" rowspan="2" class=title>연번</td>
                                <td width="16%" rowspan="2" class=title>시/구/군</td>
                                <td colspan="3" class=title>영업소</td>
                                <td colspan="3" class=title>영업사원</td>
                            </tr>
                            <tr>
                                <td width="12%" class=title>지점</td>
                                <td width="12%" class=title>대리점</td>
                                <td width="12%" class=title>소계</td>
                                <td width="12%" class=title>지점</td>
                                <td width="12%" class=title>대리점</td>
                                <td width="12%" class=title>소계</td>
                            </tr>
                           <%for(int i=0; i<stat_size1 ; i++){
								Hashtable stat = (Hashtable)stats1.elementAt(i);
							%>
                            <tr align="center">						   
						   <%if(i==0){%>
                                <td rowspan="<%=stat_size1+1%>">서울</td>
						   <%}%>							
                                <td><%=i+1%></td>
                                <td><%=stat.get("GUGUN")%></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("O_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("O_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")))%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("E_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("E_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")))%></a></td>
                            </tr>
                           <%	h_cnt[0] = h_cnt[0] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")));
							   	h_cnt[1] = h_cnt[1] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")));
							   	h_cnt[2] = h_cnt[2] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")));
							   	h_cnt[3] = h_cnt[3] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")));
						   }%>
						   <%if(stat_size1>0){%>
                            <tr align="center">
                                <td colspan="2" class=title>소계</td>
                                <td class=title><%=h_cnt[0]%></td>
                                <td class=title><%=h_cnt[1]%></td>
                                <td class=title><%=h_cnt[0]+h_cnt[1]%></td>
                                <td class=title><%=h_cnt[2]%></td>
                                <td class=title><%=h_cnt[3]%></td>
                                <td class=title><%=h_cnt[2]+h_cnt[3]%></td>							 
                            </tr>
						   <%}%>
                           <%for(int i=0; i<stat_size2 ; i++){
								Hashtable stat = (Hashtable)stats2.elementAt(i);
							%>
                            <tr align="center">
						   <%if(i==0){%>
                                <td rowspan="<%=stat_size2+1%>">경기</td>
						   <%}%>							 
                                <td><%=i+1%></td>
                                <td><%=stat.get("GUGUN")%></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("O_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("O_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")))%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("E_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("E_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")))%></a></td>
                            </tr>
                           <%	h_cnt[4] = h_cnt[4] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")));
							   	h_cnt[5] = h_cnt[5] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")));
							   	h_cnt[6] = h_cnt[6] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")));
							   	h_cnt[7] = h_cnt[7] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")));
						   }%>
						   <%if(stat_size2>0){%>
                            <tr align="center">
                                <td colspan="2" class=title>소계</td>
                                <td class=title><%=h_cnt[4]%></td>
                                <td class=title><%=h_cnt[5]%></td>
                                <td class=title><%=h_cnt[4]+h_cnt[5]%></td>
                                <td class=title><%=h_cnt[6]%></td>
                                <td class=title><%=h_cnt[7]%></td>
                                <td class=title><%=h_cnt[6]+h_cnt[7]%></td>
                            </tr>
						   <%}%>
                           <%for(int i=0; i<stat_size3 ; i++){
								Hashtable stat = (Hashtable)stats3.elementAt(i);
							%>
                            <tr align="center">
						   <%if(i==0){%>
                                <td rowspan="<%=stat_size3+1%>">인천</td>
						   <%}%>							 
                                <td><%=i+1%></td>
                                <td><%=stat.get("GUGUN")%></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("O_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("O_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")))%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("E_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("E_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")))%></a></td>
                            </tr>
                           <%	h_cnt[8] = h_cnt[8] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")));
							   	h_cnt[9] = h_cnt[9] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")));
							   	h_cnt[10] = h_cnt[10] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")));
							   	h_cnt[11] = h_cnt[11] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")));
						   }%>
						   <%if(stat_size3>0){%>
                            <tr align="center">
                                <td colspan="2" class=title>소계</td>
                                <td class=title><%=h_cnt[8]%></td>
                                <td class=title><%=h_cnt[9]%></td>
                                <td class=title><%=h_cnt[8]+h_cnt[9]%></td>
                                <td class=title><%=h_cnt[10]%></td>
                                <td class=title><%=h_cnt[11]%></td>
                                <td class=title><%=h_cnt[10]+h_cnt[11]%></td>
                            </tr>
						   <%}%>
                           <%for(int i=0; i<stat_size4 ; i++){
								Hashtable stat = (Hashtable)stats4.elementAt(i);
							%>
                            <tr align="center">
						   <%if(i==0){%>
                                <td rowspan="<%=stat_size4+1%>">기타</td>
						   <%}%>							 
                                <td><%=i+1%></td>
                                <td><%=stat.get("SIDO")+" "%><%=stat.get("GUGUN")%></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("O_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("O_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")))%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','1')"><%=stat.get("E_CNT1")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','2')"><%=stat.get("E_CNT2")%></a></td>
                                <td><a href="javascript:goCarOffEmpList('<%=stat.get("SIDO")%>','<%=stat.get("GUGUN")%>','<%=gubun3%>','0')"><%=AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")))+AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")))%></a></td>
                            </tr>
                           <%	h_cnt[12] = h_cnt[12] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT1")));
							   	h_cnt[13] = h_cnt[13] + AddUtil.parseInt(String.valueOf(stat.get("O_CNT2")));
							   	h_cnt[14] = h_cnt[14] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT1")));
							   	h_cnt[15] = h_cnt[15] + AddUtil.parseInt(String.valueOf(stat.get("E_CNT2")));
						   }%>
						   <%if(stat_size4>0){%>
                            <tr align="center">
                                <td colspan="2" class=title>소계</td>
                                <td class=title><%=h_cnt[12]%></td>
                                <td class=title><%=h_cnt[13]%></td>
                                <td class=title><%=h_cnt[12]+h_cnt[13]%></td>
                                <td class=title><%=h_cnt[14]%></td>
                                <td class=title><%=h_cnt[15]%></td>
                                <td class=title><%=h_cnt[14]+h_cnt[15]%></td>
                            </tr>						
						   <%}%>   						   						   
                            <tr align="center">
                                <td colspan="3" class=title>합계</td>
                                <td class=title><%=h_cnt[0]+h_cnt[4]+h_cnt[8]+h_cnt[12]%></td>
                                <td class=title><%=h_cnt[1]+h_cnt[5]+h_cnt[9]+h_cnt[13]%></td>
                                <td class=title><%=h_cnt[0]+h_cnt[4]+h_cnt[8]+h_cnt[12]+h_cnt[1]+h_cnt[5]+h_cnt[9]+h_cnt[13]%></td>
                                <td class=title><%=h_cnt[2]+h_cnt[6]+h_cnt[10]+h_cnt[14]%></td>
                                <td class=title><%=h_cnt[3]+h_cnt[7]+h_cnt[11]+h_cnt[15]%></td>
                                <td class=title><%=h_cnt[2]+h_cnt[6]+h_cnt[10]+h_cnt[14]+h_cnt[3]+h_cnt[7]+h_cnt[11]+h_cnt[15]%></td>
                            </tr>
                         </table>
                     </td>
                </tr>
			</table>
		</td>
	</tr>
	<%}%>	
    <tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>