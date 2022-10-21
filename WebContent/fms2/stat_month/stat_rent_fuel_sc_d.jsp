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
	int days 	= AddUtil.getMonthDate(AddUtil.parseInt(s_yy), AddUtil.parseInt(s_mm));
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	int item_size = 8;
	
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
	int h_cnt8[]	 		= new int[days+1];
	
	//합계
	int t_cnt1[]	 		= new int[days+1];
	int t_cnt2[]	 		= new int[days+1];
	int t_cnt3[]	 		= new int[days+1];
	int t_cnt4[]	 		= new int[days+1];
	int t_cnt5[]	 		= new int[days+1];
	int t_cnt6[]	 		= new int[days+1];
	int t_cnt7[]	 		= new int[days+1];	
	int t_cnt8[]	 		= new int[days+1];
	
	//연료 구분
	String s_st1_nm[]	 	= new String[item_size];
	s_st1_nm[0] = "가솔린";
	s_st1_nm[1] = "디젤";
	s_st1_nm[2] = "일반승용LPG";
	s_st1_nm[3] = "기타차종LPG";
	s_st1_nm[4] = "하이브리드";
	s_st1_nm[5] = "플러그인HEV";
	s_st1_nm[6] = "전기";
	s_st1_nm[7] = "수소";
	
	String s_st1[]	 		= new String[item_size];
	s_st1[0] = "1";
	s_st1[1] = "2";
	s_st1[2] = "3";
	s_st1[3] = "4";
	s_st1[4] = "5";
	s_st1[5] = "6";
	s_st1[6] = "7";	
	s_st1[7] = "8";
	
	
	
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
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+40+(40*days)%>>
    <tr>
      <td>1. 일별 계약현황</td>
    </tr>					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
            
                <tr align="center"> 
                    <td colspan="3" class=title>구분</td>
                    <td width=40 class=title>합계</td>
		    <%for (int j = 0 ; j < days ; j++){%>
                    <td width=40 class=title><%=j+1%>일</td>
		    <%}%>
                </tr>
                
                <%	//초기화
                	for (int j = 0 ; j < days+1 ; j++){
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
				for(int j = 0 ; j < item_size ; j++){										
					if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
						for (int k = 0 ; k < days+1 ; k++){
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
					
		<%	for(int i = 0 ; i < item_size ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="<%=item_size+1%>" align="center">신차</td><%}%>                    
                    <td width="110" align="center" colspan="2"><%=s_st1_nm[i]%></td>					
		    <%		for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title colspan="2">소계</td>
		    <%	for (int j = 0 ; j < days+1 ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt1[j]%></td>
		    <%	}%>					
                </tr>	
                				
				
                <%	//초기화
                	for (int j = 0 ; j < days+1 ; j++){
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
				
				for(int j = 0 ; j < item_size ; j++){
					if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
						for (int k = 0 ; k < days+1 ; k++){
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
					
		<%	for(int i = 0 ; i < item_size ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="<%=item_size+1%>" align="center">재리스</td><%}%>                    
                    <td width="110" align="center" colspan="2"><%=s_st1_nm[i]%></td>					
		    <%		for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title colspan="2">소계</td>
		    <%	for (int j = 0 ; j < days+1 ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt3[j]%></td>
		    <%	}%>					
                </tr>	
                				
				
                <%	//초기화
                	for (int j = 0 ; j < days+1 ; j++){
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
				
				for(int j = 0 ; j < item_size ; j++){
					if(String.valueOf(ht.get("DIESEL_YN")).equals(s_st1[j])){
						for (int k = 0 ; k < days+1 ; k++){
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
					
		<%	for(int i = 0 ; i < item_size ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="<%=item_size+1%>" align="center">연장</td><%}%>                    
                    <td width="110" align="center" colspan="2"><%=s_st1_nm[i]%></td>                    		
		    <%		for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
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
		    <%		}%>
                </tr>	
		<%	}%>
		
                <tr>
		    <td class=title colspan="2">소계</td>
		    <%	for (int j = 0 ; j < days+1 ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt5[j]%></td>
		    <%	}%>					
                </tr>	
                				
				
                <%	//초기화
                	for (int j = 0 ; j < days+1 ; j++){
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
		<%	for(int i = 0 ; i < item_size ; i++){%>
                <tr>                                      
                    <%if(i==0){%><td width="50" rowspan="<%=item_size+1%>" align="center">합계</td><%}%>
                    <td width="110" align="center" colspan='2'><%=s_st1_nm[i]%></td>					
		    <%		for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right">
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
		    <%		}%>
                </tr>	
		<%	}%>
                <tr>
		    <td class=title colspan='2'>총계</td>
		    <%	for (int j = 0 ; j < days+1 ; j++){%>	
		    <td class=title style='text-align:right'><%=h_cnt1[j]+h_cnt2[j]+h_cnt3[j]+h_cnt4[j]+h_cnt5[j]+h_cnt6[j]%></td>
		    <%	}%>					
                </tr>																																
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>