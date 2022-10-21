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
	
	int f_year 	= 2001;	
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	days	= years;
	
	int cnt1[]	 		= new int[days+1];
	int cnt2[]	 		= new int[days+1];
	int cnt3[]	 		= new int[days+1];
	int cnt4[]	 		= new int[days+1];
	int cnt5[]	 		= new int[days+1];
	int cnt6[]	 		= new int[days+1];
	int cnt7[]	 		= new int[days+1];
	int cnt8[]	 		= new int[days+1];
	
	//소계
	int h_cnt1[]	 		= new int[days+1];
	int h_cnt2[]	 		= new int[days+1];
	int h_cnt3[]	 		= new int[days+1];
	int h_cnt4[]	 		= new int[days+1];
	int h_cnt5[]	 		= new int[days+1];
	int h_cnt6[]	 		= new int[days+1];
	int h_cnt7[]	 		= new int[days+1];
	
	//합계
	int t_cnt1[]	 		= new int[days+1];
	int t_cnt2[]	 		= new int[days+1];
	int t_cnt3[]	 		= new int[days+1];
	int t_cnt4[]	 		= new int[days+1];
	int t_cnt5[]	 		= new int[days+1];
	int t_cnt6[]	 		= new int[days+1];
	int t_cnt7[]	 		= new int[days+1];
	int t_cnt8[]	 		= new int[days+1];
	
	//연료구분
	String s_st1_nm[]	 	= new String[9];
	s_st1_nm[0] = "가솔린";
	s_st1_nm[1] = "디젤";
	s_st1_nm[2] = "일반승용LPG";
	s_st1_nm[3] = "기타차종LPG";
	s_st1_nm[4] = "하이브리드";
	s_st1_nm[5] = "플러그인HEV";
	s_st1_nm[6] = "전기";
	s_st1_nm[7] = "수소";
	s_st1_nm[8] = "소계";
	
	String s_st1[]	 		= new String[9];
	s_st1[0] = "1";
	s_st1[1] = "2";
	s_st1[2] = "3";
	s_st1[3] = "4";
	s_st1[4] = "5";
	s_st1[5] = "6";
	s_st1[6] = "7";
	s_st1[7] = "8";
	s_st1[8] = "9";
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
table tr{		height: 25px;	}
.doub_height{	height: 50px;	}
.doub_width{	width : 120px !important;	}
.basic_td{		width : 60px !important;	}
</style>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
<%-- <table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+60+60+(60*years*2)%>> --%>
<table border=0 cellspacing=0 cellpadding=0 style="table-layout: fixed !important;">
    <tr>
      <td>3. 년도별 계약현황</td>
    </tr>					
    <tr> 
        <td class=line>
        	<div style="width:1400px;">
	        	<div style="float: left; width: 160px; overflow-x:hidden; overflow-y:hidden;">
	        		<table border="0" cellspacing="1" cellpadding="0" style="table-layout: fixed !important;">
	        			<tr align="center" class="doub_height"> 
	                    	<td colspan="3" class=title>구분</td>
	                    </tr>
			<%	for(int i = 0 ; i < 36; i++){%>
		                <tr height="25px;"> 
	       					<%if(i==0){%><td width="50" rowspan="9" align="center">신차</td><%}%>
		                    <%if(i==9){%><td width="50" rowspan="9" align="center">재리스</td><%}%>
		                    <%if(i==18){%><td width="50" rowspan="9" align="center">연장</td><%}%>
		                    <%if(i==27){%><td width="50" rowspan="9" align="center">합계</td><%}%>
		                    <%if(i==36){%>
		                    	<td width="110" align="center" colspan="2" <%if(s_st1_nm[i%9].equals("소계")){%>class="title"<%}%>>총계</td>
		                    <%}else{%>
		                    	<td width="110" align="center" colspan="2" <%if(s_st1_nm[i%9].equals("소계")){%>class="title"<%}%>><%=s_st1_nm[i%9]%></td>
		                    <%} %>
		                </tr>
		    <%} %>
			    		<tr height="20px">
			    			<td colspan="3"></td>
			    		</tr>
	        		</table>
	        	</div>
	        	<!-- sdfsdf -->
	        	<div style="position: relative; width:1240px; overflow-x:auto;">
	        		<table border="0" cellspacing="1" cellpadding="0" style="table-layout: fixed !important;">
		                <tr align="center">
		                    <td colspan="2" class="title doub_width" >합계</td>
				    <%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
		                    <td colspan="2" class="title doub_width"><%=j%>년</td>
				    <%}%>
		                </tr>
		                <tr align="center"> 
				    <%for (int j = f_year ; j <= AddUtil.getDate2(1)+1 ; j++){%>
		                    <td class=title class="basic_td">대수</td>
		                    <td class=title class="basic_td">비율</td>
				    <%}%>
		                </tr>       
		                <%	//초기화
		                	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){ 
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						cnt8[j] = 0;
					}
		                %>		
		                
				<!--신차------------------------------------------------------------------------------------->
						
				<%	Vector vt = sb_db.getStatFuelList("1", s_yy, s_mm, days, f_year);
					int vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);				
						for(int j = 0 ; j < 8 ; j++){										
							if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
								for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
									int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
									
									if(j==0) cnt1[k]  = cnt;
									if(j==1) cnt2[k]  = cnt;
									if(j==2) cnt3[k]  = cnt;
									if(j==3) cnt4[k]  = cnt;
									if(j==4) cnt5[k]  = cnt;
									if(j==5) cnt6[k]  = cnt;
									if(j==6) cnt7[k]  = cnt;
									if(j==7) cnt8[k]  = cnt;	
					
									if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
									if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
									if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
									if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
									if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
									if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
									if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
									if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
		
									h_cnt1[k] 	= h_cnt1[k] + cnt;									
								}
							}
						}
					}%>             
						
				<%	for(int i = 0 ; i < 8 ; i++){%>
		                <tr>		
				    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>		
		                    <td align="right" class="basic_td">
		                    	<div style="width: 60px;">
								<%if(i==0){%>		<%=cnt1[j]%>
								<%}else if(i==1){%>	<%=cnt2[j]%>
								<%}else if(i==2){%>	<%=cnt3[j]%>
								<%}else if(i==3){%>	<%=cnt4[j]%>
								<%}else if(i==4){%>	<%=cnt5[j]%>
								<%}else if(i==5){%>	<%=cnt6[j]%>
								<%}else if(i==6){%>	<%=cnt7[j]%>
								<%}else if(i==7){%>	<%=cnt8[j]%>											
								<%}%>
								</div>
				    		</td>
							<td align="right" class="basic_td">
								<div style="width: 60px;">
								<%if(i==0){%>		    <%=AddUtil.parseFloatCipher2((float)cnt1[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2((float)cnt2[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher2((float)cnt3[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher2((float)cnt4[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher2((float)cnt5[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher2((float)cnt6[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==6){%>	<%=AddUtil.parseFloatCipher2((float)cnt7[j]/h_cnt1[j]*100,2)%>%
								<%}else if(i==7){%>	<%=AddUtil.parseFloatCipher2((float)cnt8[j]/h_cnt1[j]*100,2)%>%
								<%}%>
								</div>				
				    		</td>		    
				    <%		}%>
		                </tr>	
				<%	}%>
		                <tr>
				    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
				    		<td class="title basic_td" style='text-align:right'><%=h_cnt1[j]%></td>
				    		<td class="title basic_td" style='text-align:right'>-</td>
				    <%	}%>					
		                </tr>
						
		                <%	//초기화
		                	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){ 
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						cnt8[j] = 0;
						
					}						
		                %>
		                
				<!--재리스------------------------------------------------------------------------------------->
						
				<%	vt = sb_db.getStatFuelList("3", s_yy, s_mm, days, f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						for(int j = 0 ; j < 8 ; j++){
							if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
								for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
									int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
									
									if(j==0) cnt1[k]  = cnt;
									if(j==1) cnt2[k]  = cnt;
									if(j==2) cnt3[k]  = cnt;
									if(j==3) cnt4[k]  = cnt;
									if(j==4) cnt5[k]  = cnt;
									if(j==5) cnt6[k]  = cnt;
									if(j==6) cnt7[k]  = cnt;
									if(j==7) cnt8[k]  = cnt;	
					
									if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
									if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
									if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
									if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
									if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
									if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
									if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
									if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
												
									h_cnt3[k] 	= h_cnt3[k] + cnt;									
								}
							}
						}
					}%>
							
				<%	for(int i = 0 ; i < 8 ; i++){%>
		                <tr> 				
				    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		                    <td align="right" class="basic_td">
								<%if(i==0){%>		<%=cnt1[j]%>
								<%}else if(i==1){%>	<%=cnt2[j]%>
								<%}else if(i==2){%>	<%=cnt3[j]%>
								<%}else if(i==3){%>	<%=cnt4[j]%>
								<%}else if(i==4){%>	<%=cnt5[j]%>
								<%}else if(i==5){%>	<%=cnt6[j]%>
								<%}else if(i==6){%>	<%=cnt7[j]%>
								<%}else if(i==7){%>	<%=cnt8[j]%>											
								<%}%>
				    		</td>
				    		<!-- <td align="right" class="basic_td">-</td> -->
				    		<td align="right" class="basic_td">
				    			<div style="width: 60px;">
									<%if(i==0){%>		    <%=AddUtil.parseFloatCipher2((float)cnt1[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2((float)cnt2[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher2((float)cnt3[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher2((float)cnt4[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher2((float)cnt5[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher2((float)cnt6[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==6){%>	<%=AddUtil.parseFloatCipher2((float)cnt7[j]/h_cnt3[j]*100,2)%>%
									<%}else if(i==7){%>	<%=AddUtil.parseFloatCipher2((float)cnt8[j]/h_cnt3[j]*100,2)%>%
									<%}%>
								</div>
							</td>
				    <%		}%>
		                </tr>	
				<%	}%>
		                <tr>
				    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
						    <td class="title basic_td" style='text-align:right'><%=h_cnt3[j]%></td>
						    <td class="title basic_td" style='text-align:right'>-</td>
				    <%	}%>					
		                </tr>
		                <%	//초기화
		                	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){ 
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						cnt8[j] = 0;
					}
		                %>
		                
				<!--연장------------------------------------------------------------------------------------->
						
				<%	vt = sb_db.getStatFuelList("5", s_yy, s_mm, days, f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						for(int j = 0 ; j < 8 ; j++){
							if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
								for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
									int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
									
									if(j==0) cnt1[k]  = cnt;
									if(j==1) cnt2[k]  = cnt;
									if(j==2) cnt3[k]  = cnt;
									if(j==3) cnt4[k]  = cnt;
									if(j==4) cnt5[k]  = cnt;
									if(j==5) cnt6[k]  = cnt;
									if(j==6) cnt7[k]  = cnt;
									if(j==7) cnt8[k]  = cnt;
					
									if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
									if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
									if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
									if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
									if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
									if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
									if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
									if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
					
									h_cnt5[k] 	= h_cnt5[k] + cnt;									
								}
							}
						}
					}%>
							
				<%	for(int i = 0 ; i < 8 ; i++){%>
		                <tr>				
				    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		                    <td align="right" class="basic_td">
								<%if(i==0){%>		<%=cnt1[j]%>
								<%}else if(i==1){%>	<%=cnt2[j]%>
								<%}else if(i==2){%>	<%=cnt3[j]%>
								<%}else if(i==3){%>	<%=cnt4[j]%>
								<%}else if(i==4){%>	<%=cnt5[j]%>
								<%}else if(i==5){%>	<%=cnt6[j]%>
								<%}else if(i==6){%>	<%=cnt7[j]%>
								<%}else if(i==7){%>	<%=cnt8[j]%>											
								<%}%>
						    </td>
						    <!-- <td align="right" class="basic_td">-</td> -->
						    <td align="right" class="basic_td">
				    			<div style="width: 60px;">
									<%if(i==0){%>		    <%=AddUtil.parseFloatCipher2((float)cnt1[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2((float)cnt2[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher2((float)cnt3[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher2((float)cnt4[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher2((float)cnt5[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher2((float)cnt6[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==6){%>	<%=AddUtil.parseFloatCipher2((float)cnt7[j]/h_cnt5[j]*100,2)%>%
									<%}else if(i==7){%>	<%=AddUtil.parseFloatCipher2((float)cnt8[j]/h_cnt5[j]*100,2)%>%
									<%}%>
								</div>
							</td>
				    <%		}%>
		                </tr>	
				<%	}%>
		                <tr>
				    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
						    <td class="title basic_td" style='text-align:right'><%=h_cnt5[j]%></td>
						    <td class="title basic_td" style='text-align:right'>-</td>
				    <%	}%>					
		                </tr>
		                <%	//초기화
		                	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){ 
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						cnt7[j] = 0;
						cnt8[j] = 0;
					}
		                %>
									
				<!--합계------------------------------------------------------------------------------------->	
				
				<%	for(int i = 0 ; i < 8 ; i++){%>
		                <tr>	
				    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		                    <td align="right" class="basic_td">
								<%if(i==0){%>		<%=t_cnt1[j]%>
								<%}else if(i==1){%>	<%=t_cnt2[j]%>
								<%}else if(i==2){%>	<%=t_cnt3[j]%>
								<%}else if(i==3){%>	<%=t_cnt4[j]%>
								<%}else if(i==4){%>	<%=t_cnt5[j]%>
								<%}else if(i==5){%>	<%=t_cnt6[j]%>
								<%}else if(i==6){%>	<%=t_cnt7[j]%>
								<%}else if(i==7){%>	<%=t_cnt8[j]%>					
								<%}%>
				   			 </td>
				    		<!-- <td align="right" class="basic_td">-</td> -->
				    		<td align="right" class="basic_td">
				    			<div style="width: 60px;">
									<%if(i==0){%>		    <%=AddUtil.parseFloatCipher2((float)t_cnt1[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt2[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt3[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt4[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt5[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt6[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==6){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt7[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}else if(i==7){%>	<%=AddUtil.parseFloatCipher2((float)t_cnt8[j]/(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j])*100,2)%>%
									<%}%>
								</div>
							</td>
				    <%		}%>
		                </tr>	
				<%	}%>
		                <tr>
				    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
						    <td class="title basic_td" style='text-align:right'><%=h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]+h_cnt7[j]%></td>
						    <td class="title basic_td" style='text-align:right'>-</td>
				    <%	}%>					
		                </tr>																																		
		            </table>
	        	</div> 
            </div>
        </td>
    </tr>
</table>
</form>
</body>
</html>