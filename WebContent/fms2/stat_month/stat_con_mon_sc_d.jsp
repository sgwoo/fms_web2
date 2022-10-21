<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	int f_year 	= 2001;	
	int days 	= AddUtil.getMonthDate(AddUtil.parseInt(s_yy), AddUtil.parseInt(s_mm));
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	
	int cnt1[]	 		= new int[days+1];
	int cnt2[]	 		= new int[days+1];
	int cnt3[]	 		= new int[days+1];
	int cnt4[]	 		= new int[days+1];
	int cnt5[]	 		= new int[days+1];
	int cnt6[]	 		= new int[days+1];
	int cnt7[]	 		= new int[days+1];	
	int cnt8[]	 		= new int[days+1];	
	
	int h_cnt[]	 		= new int[days+1];
	
	int t_cnt1[]	 		= new int[days+1];
	int t_cnt2[]	 		= new int[days+1];
	int t_cnt3[]	 		= new int[days+1];
	int t_cnt4[]	 		= new int[days+1];
	int t_cnt5[]	 		= new int[days+1];
	int t_cnt6[]	 		= new int[days+1];
	int t_cnt7[]	 		= new int[days+1];	
	int t_cnt8[]	 		= new int[days+1];	
	
	int th_cnt[]	 		= new int[days+1];

	String con_mon_nm[]	 	= new String[7];
	con_mon_nm[0] = "12개월";
	con_mon_nm[1] = "13개월";
	con_mon_nm[2] = "24개월";
	con_mon_nm[3] = "30개월";	
	con_mon_nm[4] = "36개월";	
	con_mon_nm[5] = "48개월";	
	con_mon_nm[6] = "60개월";		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
//-->
</script>
</head>
<body style="margin-left: 0;">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 			value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 			value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+80+40+(40*days)%> style="padding-right: 30px;">
    <tr>
      <td>1. 일별 계약현황</td>
    </tr>					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" class=title>구분</td>
                    <td width=40 class=title>합계</td>
					<%for (int j = 0 ; j < days ; j++){%>
                    <td width=40 class=title><%=j+1%>일</td>
					<%}%>
                </tr>
                
                
				<!--신차-->
				<%	Vector vt = sb_db.getStatConMonList("1", s_yy, s_mm, days, f_year, gubun1, gubun2);
					int vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];																
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];								
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];								
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt7[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt7[j];
								t_cnt7[j] 	= t_cnt7[j] + cnt7[j];
								th_cnt[j] 	= th_cnt[j]  + cnt7[j];
							}
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;
						%>				
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="6" align="center">신차</td><%}%>
                    <td width="80" align="center"><%=con_mon_nm[i]%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>						
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<%	}%>		

				<tr>
					<td class=title>소계</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>					
				
				<%	for (int j = 0 ; j < days+1 ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;						
						h_cnt[j] = 0;
					}%>
					              
				<!--재리스-->
				<%	vt = sb_db.getStatConMonList("2", s_yy, s_mm, days, f_year, gubun1, gubun2);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];							
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];							
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt7[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt7[j];
								t_cnt7[j] 	= t_cnt7[j] + cnt7[j];
								th_cnt[j] 	= th_cnt[j]  + cnt7[j];
							}
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;
						%>				
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="6" align="center">재리스</td><%}%>
                    <td width="80" align="center"><%=con_mon_nm[i]%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<%	}%>		

				<tr>
					<td class=title>소계</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>					
				
				<%	for (int j = 0 ; j < days+1 ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						h_cnt[j] = 0;
					}%>
					
				<!--연장-->
				<%	vt = sb_db.getStatConMonList("3", s_yy, s_mm, days, f_year, gubun1, gubun2);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];									
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];									
							}
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];		
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = 0 ; j < days+1 ; j++){
								cnt7[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt7[j];
								t_cnt7[j] 	= t_cnt7[j] + cnt7[j];
								th_cnt[j] 	= th_cnt[j]  + cnt7[j];		
							}
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;
						%>				
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="6" align="center">연장</td><%}%>
                    <td width="80" align="center"><%=con_mon_nm[i]%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<%	}%>		

				<tr>
					<td class=title>소계</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>					
				
				<%	for (int j = 0 ; j < days+1 ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						h_cnt[j] = 0;
					}%>					
					            
					  
				<!--합계-->					
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;
						%>				
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="6" align="center">합계</td><%}%>
                    <td width="80" align="center"><%=con_mon_nm[i]%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							%>	
                    <td align="right">
						<%if(i==0){%>		<%=t_cnt1[j]%>
						<%}else if(i==1){%>	<%=t_cnt2[j]%>
						<%}else if(i==2){%>	<%=t_cnt3[j]%>
						<%}else if(i==3){%>	<%=t_cnt4[j]%>
						<%}else if(i==4){%>	<%=t_cnt5[j]%>
						<%}else if(i==5){%>	<%=t_cnt6[j]%>
						<%}else if(i==6){%>	<%=t_cnt7[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<%	}%>	
				

				<tr>
					<td class=title>소계</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td class=title style='text-align:right'><%=th_cnt[j]%></td>
					<%	}%>					
				</tr>					
				
									            					                	
            </table>
        </td>
    </tr>
    <tr>
      <td>※ LPG차량 = 소형승용LPG+중형승용LPG+대형승용LPG, 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</td>
    </tr>						
</table>
</form>
</body>
</html>