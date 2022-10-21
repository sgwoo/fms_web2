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
	int cnt9[]	 		= new int[days+1];
	int cnt10[]	 		= new int[days+1];
	
	//소계
	int h_cnt1[]	 		= new int[days+1];
	int h_cnt2[]	 		= new int[days+1];
	int h_cnt3[]	 		= new int[days+1];
	int h_cnt4[]	 		= new int[days+1];
	int h_cnt5[]	 		= new int[days+1];
	int h_cnt6[]	 		= new int[days+1];
	
	//합계
	int t_cnt1[]	 		= new int[days+1];
	int t_cnt2[]	 		= new int[days+1];
	int t_cnt3[]	 		= new int[days+1];
	int t_cnt4[]	 		= new int[days+1];
	int t_cnt5[]	 		= new int[days+1];
	int t_cnt6[]	 		= new int[days+1];
	int t_cnt7[]	 		= new int[days+1];
	int t_cnt8[]	 		= new int[days+1];
	int t_cnt9[]	 		= new int[days+1];
	int t_cnt10[]	 		= new int[days+1];
	
	
	String s_st1_nm[]	 	= new String[10];
	s_st1_nm[0] = "소형승용LPG";
	s_st1_nm[1] = "중형승용LPG";
	s_st1_nm[2] = "대형승용LPG";
	s_st1_nm[3] = "경승용";
	s_st1_nm[4] = "소형승용";
	s_st1_nm[5] = "중형승용";
	s_st1_nm[6] = "대형승용";
	s_st1_nm[7] = "RV";
	s_st1_nm[8] = "승합";
	s_st1_nm[9] = "화물";
	
	String s_st1[]	 		= new String[10];
	s_st1[0] = "300";
	s_st1[1] = "301";
	s_st1[2] = "302";
	s_st1[3] = "100";
	s_st1[4] = "112";
	s_st1[5] = "103";
	s_st1[6] = "104";
	s_st1[7] = "401";
	s_st1[8] = "701";
	s_st1[9] = "801";
	
	String s_st2_nm[]	 	= new String[7];
	s_st2_nm[0] = "경승용";
	s_st2_nm[1] = "소형승용";
	s_st2_nm[2] = "중형승용";
	s_st2_nm[3] = "대형승용";
	s_st2_nm[4] = "RV";
	s_st2_nm[5] = "승합";
	s_st2_nm[6] = "화물";
	
	String s_st2[]	 		= new String[7];
	s_st2[0] = "100";
	s_st2[1] = "112";
	s_st2[2] = "103";
	s_st2[3] = "104";
	s_st2[4] = "401";
	s_st2[5] = "701";
	s_st2[6] = "801";	
	
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
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+60+(60*years)%>>
    <tr>
      <td>3. 년도별 계약현황</td>
    </tr>					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
            
                <tr align="center"> 
                    <td colspan="3" class=title>구분</td>
                    <td width=60 class=title>합계</td>
		    <%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    <td width=60 class=title><%=j%>년</td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}
                %>		
                
		<!--신차/렌트------------------------------------------------------------------------------------->
				
		<%	Vector vt = sb_db.getStatRentCarList("1", s_yy, s_mm, days, f_year);
			int vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
				for(int j = 0 ; j < 10 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
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
							if(j==8) cnt9[k]  = cnt;
							if(j==9) cnt10[k] = cnt;
			
							if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
							if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
							if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
							if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==8) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==9) t_cnt10[k]  = t_cnt10[k] + cnt;

							h_cnt1[k] 	= h_cnt1[k] + cnt;									
						}
					}
				}
			}%>
			                
				
		<%	for(int i = 0 ; i < 10 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="21" align="center">신차</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="11" align="center">렌트</td><%}%>
                    <td width="110" align="center"><%=s_st1_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}else if(i==7){%>	<%=cnt8[j]%>
						<%}else if(i==8){%>	<%=cnt9[j]%>
						<%}else if(i==9){%>	<%=cnt10[j]%>						
						<%}%>
		    </td>
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
		    <td class=title style='text-align:right'><%=h_cnt1[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}						
                %>		
									
			
		<!--신차/리스------------------------------------------------------------------------------------->
				
		<%	vt = sb_db.getStatRentCarList("2", s_yy, s_mm, days, f_year);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for(int j = 0 ; j < 7 ; j++){
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
							int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
							if(j==0) cnt1[k]  = cnt;
							if(j==1) cnt2[k]  = cnt;
							if(j==2) cnt3[k]  = cnt;
							if(j==3) cnt4[k]  = cnt;
							if(j==4) cnt5[k]  = cnt;
							if(j==5) cnt6[k]  = cnt;
							if(j==6) cnt7[k]  = cnt;
			
							if(j==0) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==1) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==2) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==3) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==4) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==5) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==6) t_cnt10[k]  = t_cnt10[k] + cnt;							
			
							h_cnt2[k] 	= h_cnt2[k] + cnt;									
						}
					}
				}
			}%>
					
		<%	for(int i = 0 ; i < 7 ; i++){%>
                <tr>                     
                    <%if(i==0){%><td width="40" rowspan="9" align="center">리스</td><%}%>
                    <td width="110" align="center"><%=s_st2_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt2[j]%></td>
		    <%	}%>					
                </tr>	
                <tr>
		    <td class=title>비율</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt1[j]+h_cnt2[j]))*100,1)%></td>
		    <%	}%>					
                </tr>
                
                <tr>
		    <td colspan='2' class=title>합계</td>
		    <%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt1[j]+h_cnt2[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}						
                %>	
                
		<!--재리스/렌트------------------------------------------------------------------------------------->
				
		<%	vt = sb_db.getStatRentCarList("3", s_yy, s_mm, days, f_year);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for(int j = 0 ; j < 10 ; j++){
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
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
							if(j==8) cnt9[k]  = cnt;
							if(j==9) cnt10[k] = cnt;
			
							if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
							if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
							if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
							if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==8) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==9) t_cnt10[k]  = t_cnt10[k] + cnt;
							
			
							h_cnt3[k] 	= h_cnt3[k] + cnt;									
						}
					}
				}
			}%>
					
		<%	for(int i = 0 ; i < 10 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="21" align="center">재리스</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="11" align="center">렌트</td><%}%>
                    <td width="110" align="center"><%=s_st1_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}else if(i==7){%>	<%=cnt8[j]%>
						<%}else if(i==8){%>	<%=cnt9[j]%>
						<%}else if(i==9){%>	<%=cnt10[j]%>						
						<%}%>
		    </td>
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt3[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}
                %>		
									
			
		<!--재리스/리스------------------------------------------------------------------------------------->
				
		<%	vt = sb_db.getStatRentCarList("4", s_yy, s_mm, days, f_year);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for(int j = 0 ; j < 7 ; j++){
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
							int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
							if(j==0) cnt1[k]  = cnt;
							if(j==1) cnt2[k]  = cnt;
							if(j==2) cnt3[k]  = cnt;
							if(j==3) cnt4[k]  = cnt;
							if(j==4) cnt5[k]  = cnt;
							if(j==5) cnt6[k]  = cnt;
							if(j==6) cnt7[k]  = cnt;
			
							if(j==0) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==1) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==2) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==3) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==4) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==5) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==6) t_cnt10[k]  = t_cnt10[k] + cnt;							
							
			
							h_cnt4[k] 	= h_cnt4[k] + cnt;									
						}
					}
				}
			}%>
					
		<%	for(int i = 0 ; i < 7 ; i++){%>
                <tr>                     
                    <%if(i==0){%><td width="40" rowspan="9" align="center">리스</td><%}%>
                    <td width="110" align="center"><%=s_st2_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt4[j]%></td>
		    <%	}%>					
                </tr>	
                <tr>
		    <td class=title>비율</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt3[j]+h_cnt4[j]))*100,1)%></td>
		    <%	}%>					
                </tr>
                
                <tr>
		    <td colspan='2' class=title>합계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt3[j]+h_cnt4[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}						
                %>
                
		<!--연장/렌트------------------------------------------------------------------------------------->
				
		<%	vt = sb_db.getStatRentCarList("5", s_yy, s_mm, days, f_year);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for(int j = 0 ; j < 10 ; j++){
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
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
							if(j==8) cnt9[k]  = cnt;
							if(j==9) cnt10[k] = cnt;
			
							if(j==0) t_cnt1[k]   = t_cnt1[k] + cnt;
							if(j==1) t_cnt2[k]   = t_cnt2[k] + cnt;
							if(j==2) t_cnt3[k]   = t_cnt3[k] + cnt;
							if(j==3) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==4) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==5) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==6) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==7) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==8) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==9) t_cnt10[k]  = t_cnt10[k] + cnt;
							
			
							h_cnt5[k] 	= h_cnt5[k] + cnt;									
						}
					}
				}
			}%>
					
		<%	for(int i = 0 ; i < 10 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="21" align="center">연장</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="11" align="center">렌트</td><%}%>
                    <td width="110" align="center"><%=s_st1_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}else if(i==7){%>	<%=cnt8[j]%>
						<%}else if(i==8){%>	<%=cnt9[j]%>
						<%}else if(i==9){%>	<%=cnt10[j]%>						
						<%}%>
		    </td>
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt5[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}
                %>		
									
			
		<!--연장/리스------------------------------------------------------------------------------------->
				
		<%	vt = sb_db.getStatRentCarList("6", s_yy, s_mm, days, f_year);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for(int j = 0 ; j < 7 ; j++){
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						for (int k = (f_year-2000-1) ; k <= (AddUtil.getDate2(1)-2000) ; k++){
							int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
							if(j==0) cnt1[k]  = cnt;
							if(j==1) cnt2[k]  = cnt;
							if(j==2) cnt3[k]  = cnt;
							if(j==3) cnt4[k]  = cnt;
							if(j==4) cnt5[k]  = cnt;
							if(j==5) cnt6[k]  = cnt;
							if(j==6) cnt7[k]  = cnt;
			
							if(j==0) t_cnt4[k]   = t_cnt4[k] + cnt;
							if(j==1) t_cnt5[k]   = t_cnt5[k] + cnt;
							if(j==2) t_cnt6[k]   = t_cnt6[k] + cnt;
							if(j==3) t_cnt7[k]   = t_cnt7[k] + cnt;
							if(j==4) t_cnt8[k]   = t_cnt8[k] + cnt;
							if(j==5) t_cnt9[k]   = t_cnt9[k] + cnt;
							if(j==6) t_cnt10[k]  = t_cnt10[k] + cnt;							
							
			
							h_cnt6[k] 	= h_cnt6[k] + cnt;									
						}
					}
				}
			}%>
					
		<%	for(int i = 0 ; i < 7 ; i++){%>
                <tr>                     
                    <%if(i==0){%><td width="40" rowspan="9" align="center">리스</td><%}%>
                    <td width="110" align="center"><%=s_st2_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title>소계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt6[j]%></td>
		    <%	}%>					
                </tr>	
                <tr>
		    <td class=title>비율</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt5[j]+h_cnt6[j]))*100,1)%></td>
		    <%	}%>					
                </tr>
                
                <tr>
		    <td colspan='2' class=title>합계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt5[j]+h_cnt6[j]%></td>
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
				cnt9[j] = 0;
				cnt10[j] = 0;
			}						
                %>                                                
                									
			
							
			
		<%	for(int i = 0 ; i < 10 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="11" align="center">합계</td><%}%>                    
                    <td align="center" colspan='2'><%=s_st1_nm[i]%></td>					
		    <%		for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=t_cnt1[j]%>
						<%}else if(i==1){%>	<%=t_cnt2[j]%>
						<%}else if(i==2){%>	<%=t_cnt3[j]%>
						<%}else if(i==3){%>	<%=t_cnt4[j]%>
						<%}else if(i==4){%>	<%=t_cnt5[j]%>
						<%}else if(i==5){%>	<%=t_cnt6[j]%>
						<%}else if(i==6){%>	<%=t_cnt7[j]%>
						<%}else if(i==7){%>	<%=t_cnt8[j]%>
						<%}else if(i==8){%>	<%=t_cnt9[j]%>
						<%}else if(i==9){%>	<%=t_cnt10[j]%>						
						<%}%>
		    </td>
		    <%		}%>
                </tr>	
		<%	}%>
                <tr>
		    <td class=title colspan='2'>총계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]%></td>
		    <%	}%>					
                </tr>		
			
											
                <tr>
		    <td colspan='3' class=title>렌트합계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt1[j]+h_cnt3[j]+h_cnt5[j]%></td>
		    <%	}%>					
                </tr>	
                <tr>
		    <td colspan='3' class=title>리스합계</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt2[j]+h_cnt4[j]+h_cnt6[j]%></td>
		    <%	}%>					
                </tr>	
                <tr>
		    <td colspan='3' class=title>리스비율</td>
		    <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt2[j]+h_cnt4[j]+h_cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]))*100,1)%></td>
		    <%	}%>					
                </tr>	
                	
																																					
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>