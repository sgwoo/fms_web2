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
	
	
	
	
	int cnt[]	 		= new int[days+1];
	int s_cnt[]	 		= new int[days+1];
	int h_cnt1[]	 		= new int[days+1];
	int h_cnt2[]	 		= new int[days+1];
	int h_cnt3[]	 		= new int[days+1];
	int h_cnt4[]	 		= new int[days+1];
	int t_cnt[]	 		= new int[days+1];
		
	
	int s_st1_row[]	 		= new int[10];
	for(int j = 0 ; j < 10 ; j++){		
		s_st1_row[j]	 	= 0;
	}
	
	String s_st1_nm[]	 	= new String[10];
	s_st1_nm[0] = "?????¿?LPG";
	s_st1_nm[1] = "?????¿?LPG";
	s_st1_nm[2] = "?????¿?LPG";
	s_st1_nm[3] = "???¿?";
	s_st1_nm[4] = "?????¿?";
	s_st1_nm[5] = "?????¿?";
	s_st1_nm[6] = "?????¿?";
	s_st1_nm[7] = "RV";
	s_st1_nm[8] = "????";
	s_st1_nm[9] = "ȭ??";
	
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
	
	int s_st2_row[]	 		= new int[7];
	for(int j = 0 ; j < 7 ; j++){		
		s_st2_row[j]	 	= 0;
	}
	
	String s_st2_nm[]	 	= new String[7];
	s_st2_nm[0] = "???¿?";
	s_st2_nm[1] = "?????¿?";
	s_st2_nm[2] = "?????¿?";
	s_st2_nm[3] = "?????¿?";
	s_st2_nm[4] = "RV";
	s_st2_nm[5] = "????";
	s_st2_nm[6] = "ȭ??";
	
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
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+40+110+(40*days)%>>
    <tr>
      <td>1. ?Ϻ? ??????Ȳ</td>
    </tr>					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
            
                <tr align="center"> 
                    <td colspan="3" class=title>????</td>
                    <td width=110 class=title>????</td>
                    <td width=40 class=title>?հ?</td>
		    <%for (int j = 0 ; j < days ; j++){%>
                    <td width=40 class=title><%=j+1%>??</td>
		    <%}%>
                </tr>
                
                <%	//????/??Ʈ
                	Vector vt1 	= sb_db.getStatRentCarNmEList("1", s_yy, s_mm, days, f_year);
			int vt_size1 	= vt1.size();
			//????/????
                	Vector vt2 	= sb_db.getStatRentCarNmEList("2", s_yy, s_mm, days, f_year);
			int vt_size2 	= vt2.size();
			//?縮??/??Ʈ
                	Vector vt3 	= sb_db.getStatRentCarNmEList("3", s_yy, s_mm, days, f_year);
			int vt_size3 	= vt3.size();
			//?縮??/????
                	Vector vt4 	= sb_db.getStatRentCarNmEList("4", s_yy, s_mm, days, f_year);
			int vt_size4 	= vt4.size();
			
			int td_rowspan1 = 10+1;
			int td_rowspan2 = 7+2;
			int td_rowspan3 = 10+1;
			int td_rowspan4 = 7+2;
			
			//???հ?, rowspan ????
			for(int i = 0 ; i < vt_size1 ; i++){
				Hashtable ht = (Hashtable)vt1.elementAt(i);											
				for (int k = 0 ; k < days+1 ; k++){
					int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));							
					t_cnt[k] 	= t_cnt[k] + i_cnt;
				}
				for(int j = 0 ; j < 10 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
						s_st1_row[j]++;
					}
				}
			}			
			for(int j = 0 ; j < 10 ; j++){	
				td_rowspan1 = td_rowspan1 + s_st1_row[j];								
			}
			
			for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);											
				for (int k = 0 ; k < days+1 ; k++){
					int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));							
					t_cnt[k] 	= t_cnt[k] + i_cnt;
				}
				for(int j = 0 ; j < 7 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						s_st2_row[j]++;
					}
				}
			}
			for(int j = 0 ; j < 7 ; j++){	
				td_rowspan2 = td_rowspan2 + s_st2_row[j];
			}
			for(int j = 0 ; j < 10 ; j++){	
				s_st1_row[j] = 0;
			}
			for(int j = 0 ; j < 7 ; j++){	
				s_st2_row[j] = 0;
			}
			for(int i = 0 ; i < vt_size3 ; i++){
				Hashtable ht = (Hashtable)vt3.elementAt(i);											
				for (int k = 0 ; k < days+1 ; k++){
					int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));							
					t_cnt[k] 	= t_cnt[k] + i_cnt;
				}
				for(int j = 0 ; j < 10 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
						s_st1_row[j]++;
					}
				}
			}
			for(int j = 0 ; j < 10 ; j++){	
				td_rowspan3 = td_rowspan3 + s_st1_row[j];
			}
			for(int i = 0 ; i < vt_size4 ; i++){
				Hashtable ht = (Hashtable)vt4.elementAt(i);											
				for (int k = 0 ; k < days+1 ; k++){
					int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));							
					t_cnt[k] 	= t_cnt[k] + i_cnt;
				}
				for(int j = 0 ; j < 7 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						s_st2_row[j]++;
					}
				}
			}
			for(int j = 0 ; j < 7 ; j++){	
				td_rowspan4 = td_rowspan4 + s_st2_row[j];
			}
			
			for(int j = 0 ; j < 10 ; j++){	
				s_st1_row[j] = 0;
			}
			for(int j = 0 ; j < 7 ; j++){	
				s_st2_row[j] = 0;
			}
								
			Vector vt 	= new Vector();
			int vt_size 	= 0;
                %>
                
                <tr align="center"> 
                    <td colspan="4" class=title>???հ?</td>                                       
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=t_cnt[k]%></td>
		    <%	}%>
                </tr>                
                
                <%	//?ʱ?ȭ
                	for (int j = 0 ; j < days+1 ; j++){
				cnt[j] = 0;
				s_cnt[j] = 0;				
			}
			for(int j = 0 ; j < 10 ; j++){	
				s_st1_row[j] = 0;
			}
                %>		
                
				
		<!--????/??Ʈ------------------------------------------------------------------------------------->
				
		<%	vt 	= vt1;
			vt_size = vt_size1;%>
			
		<%	//?????? ????
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
				for(int j = 0 ; j < 10 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
						s_st1_row[j]++;
					}
				}				
			}								
		%>
			
			
					
		<%	for(int j = 0 ; j < 10 ; j++){	%>
		<%		if(j==0){ //ù??%>
		<%			if(s_st1_row[j]==0){//????Ÿ ????%>
		
                <tr>                     
                    <td width="50" rowspan="<%=td_rowspan1+td_rowspan2+1%>" align="center">????</td>
                    <td width="40" rowspan="<%=td_rowspan1%>" align="center">??Ʈ</td>                                    
                    <td width="110" align="center"><%=s_st1_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt1[k] 	= h_cnt1[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;
								}
		%>
		
                <tr>                
                    <%if(car_nm_cnt==0){%>     
                    <td width="50" rowspan="<%=td_rowspan1+td_rowspan2+1%>" align="center">????</td>
                    <td width="40" rowspan="<%=td_rowspan1%>" align="center">??Ʈ</td>                                    
                    <td width="110" rowspan="<%=s_st1_row[j]+1%>" align="center"><%=s_st1_nm[j]%></td>                    
                    <%}%>                    
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>
                <%		}else{//2??°??????%>
		<%			if(s_st1_row[j]==0){//????Ÿ ????%>
		
                <tr>                                                                 
                    <td width="110" align="center"><%=s_st1_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt1[k] 	= h_cnt1[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;									
								}
		%>
		
                <tr>                                    
                    <%if(car_nm_cnt==0){%>    
                    <td width="110" rowspan="<%=s_st1_row[j]+1%>" align="center"><%=s_st1_nm[j]%></td>                    
                    <%}%>
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>               
                <%		}%>
                
                <%		if(s_st1_row[j]>0){//????Ÿ ????->?Ұ?????.%>
                <tr>                    
                    <td width="110" class=title>?Ұ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=s_cnt[k]%></td>
		    <%	}%>	
                </tr>
                <%		}%>	                		
                
		<%		//?Ұ? ?ʱ?ȭ
				for (int k = 0 ; k < days+1 ; k++){
					s_cnt[k] = 0;
				}						
			}
		%>
		<tr>                    
                    <td class=title colspan='2'>??Ʈ ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt1[k]%></td>
		    <%	}%>	
                </tr>
		
                <%	//?ʱ?ȭ
                	for (int j = 0 ; j < days+1 ; j++){
				cnt[j] = 0;
				s_cnt[j] = 0;				
			}
			for(int j = 0 ; j < 7 ; j++){	
				s_st2_row[j] = 0;
			}
                %>			

		<!--????/????------------------------------------------------------------------------------------->
				
		<%	vt 	= vt2;
			vt_size = vt_size2;%>
			
		<%	//?????? ????
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
				for(int j = 0 ; j < 7 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						s_st2_row[j]++;
					}
				}				
			}								
		%>
			
			
					
		<%	for(int j = 0 ; j < 7 ; j++){	%>
		<%		if(j==0){ //ù??%>
		<%			if(s_st2_row[j]==0){//????Ÿ ????%>
		
                <tr>                                         
                    <td width="40" rowspan="<%=td_rowspan2%>" align="center">????</td>                                    
                    <td width="110" align="center"><%=s_st2_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt2[k] 	= h_cnt2[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;
								}
		%>
		
                <tr>                
                    <%if(car_nm_cnt==0){%>                         
                    <td width="40" rowspan="<%=td_rowspan2%>" align="center">????</td>                                    
                    <td width="110" rowspan="<%=s_st2_row[j]+1%>" align="center"><%=s_st2_nm[j]%></td>                    
                    <%}%>                    
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>
                <%		}else{//2??°??????%>
		<%			if(s_st2_row[j]==0){//????Ÿ ????%>
		
                <tr>                                                                 
                    <td width="110" align="center"><%=s_st2_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt2[k] 	= h_cnt2[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;									
								}
		%>
		
                <tr>                                    
                    <%if(car_nm_cnt==0){%>    
                    <td width="110" rowspan="<%=s_st2_row[j]+1%>" align="center"><%=s_st2_nm[j]%></td>                    
                    <%}%>
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>               
                <%		}%>
                
                <%		if(s_st2_row[j]>0){//????Ÿ ????->?Ұ?????.%>
                <tr>                    
                    <td width="110" class=title>?Ұ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=s_cnt[k]%></td>
		    <%	}%>	
                </tr>
                <%		}%>	                		
                
		<%		//?Ұ? ?ʱ?ȭ
				for (int k = 0 ; k < days+1 ; k++){
					s_cnt[k] = 0;
				}						
			}
		%>
		<tr>                    
                    <td class=title colspan='2'>???? ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt2[k]%></td>
		    <%	}%>	
                </tr>
                <tr>                    
                    <td class=title colspan='2'>???? ????</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt2[k]))/AddUtil.parseFloat(String.valueOf(h_cnt1[k]+h_cnt2[k]))*100,1)%></td>
		    <%	}%>	
                </tr>
                <tr>                    
                    <td class=title colspan='3'>???? ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt1[k]+h_cnt2[k]%></td>
		    <%	}%>	
                </tr>
                
                
                <%	//?ʱ?ȭ
                	for (int j = 0 ; j < days+1 ; j++){
				cnt[j] = 0;
				s_cnt[j] = 0;				
			}
			for(int j = 0 ; j < 10 ; j++){	
				s_st1_row[j] = 0;
			}
                %>	
                                
				
		<!--?縮??/??Ʈ------------------------------------------------------------------------------------->
				
		<%	vt 	= vt3;
			vt_size = vt_size3;%>
			
		<%	//?????? ????
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
				for(int j = 0 ; j < 10 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){
						s_st1_row[j]++;
					}
				}				
			}								
		%>
			
			
					
		<%	for(int j = 0 ; j < 10 ; j++){	%>
		<%		if(j==0){ //ù??%>
		<%			if(s_st1_row[j]==0){//????Ÿ ????%>
		
                <tr>                     
                    <td width="50" rowspan="<%=td_rowspan3+td_rowspan4+1%>" align="center">?縮??</td>
                    <td width="40" rowspan="<%=td_rowspan3%>" align="center">??Ʈ</td>                                    
                    <td width="110" align="center"><%=s_st1_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt3[k] 	= h_cnt3[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;
								}
		%>
		
                <tr>                
                    <%if(car_nm_cnt==0){%>     
                    <td width="50" rowspan="<%=td_rowspan3+td_rowspan4+1%>" align="center">?縮??</td>
                    <td width="40" rowspan="<%=td_rowspan3%>" align="center">??Ʈ</td>                                    
                    <td width="110" rowspan="<%=s_st1_row[j]+1%>" align="center"><%=s_st1_nm[j]%></td>                    
                    <%}%>                    
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>
                <%		}else{//2??°??????%>
		<%			if(s_st1_row[j]==0){//????Ÿ ????%>
		
                <tr>                                                                 
                    <td width="110" align="center"><%=s_st1_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st1[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt3[k] 	= h_cnt3[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;									
								}
		%>
		
                <tr>                                    
                    <%if(car_nm_cnt==0){%>    
                    <td width="110" rowspan="<%=s_st1_row[j]+1%>" align="center"><%=s_st1_nm[j]%></td>                    
                    <%}%>
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>               
                <%		}%>
                
                <%		if(s_st1_row[j]>0){//????Ÿ ????->?Ұ?????.%>
                <tr>                    
                    <td width="110" class=title>?Ұ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=s_cnt[k]%></td>
		    <%	}%>	
                </tr>
                <%		}%>	                		
                
		<%		//?Ұ? ?ʱ?ȭ
				for (int k = 0 ; k < days+1 ; k++){
					s_cnt[k] = 0;
				}						
			}
		%>
		<tr>                    
                    <td class=title colspan='2'>??Ʈ ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt3[k]%></td>
		    <%	}%>	
                </tr>
		
                <%	//?ʱ?ȭ
                	for (int j = 0 ; j < days+1 ; j++){
				cnt[j] = 0;
				s_cnt[j] = 0;				
			}
			for(int j = 0 ; j < 7 ; j++){	
				s_st2_row[j] = 0;
			}
                %>	
                
		<!--?縮??/????------------------------------------------------------------------------------------->
				
		<%	vt 	= vt4;
			vt_size = vt_size4;%>
			
		<%	//?????? ????
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
				for(int j = 0 ; j < 7 ; j++){										
					if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){
						s_st2_row[j]++;
					}
				}				
			}								
		%>
			
			
					
		<%	for(int j = 0 ; j < 7 ; j++){	%>
		<%		if(j==0){ //ù??%>
		<%			if(s_st2_row[j]==0){//????Ÿ ????%>
		
                <tr>                                         
                    <td width="40" rowspan="<%=td_rowspan4%>" align="center">????</td>                                    
                    <td width="110" align="center"><%=s_st2_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt4[k] 	= h_cnt4[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;
								}
		%>
		
                <tr>                
                    <%if(car_nm_cnt==0){%>                         
                    <td width="40" rowspan="<%=td_rowspan4%>" align="center">????</td>                                    
                    <td width="110" rowspan="<%=s_st2_row[j]+1%>" align="center"><%=s_st2_nm[j]%></td>                    
                    <%}%>                    
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>
                <%		}else{//2??°??????%>
		<%			if(s_st2_row[j]==0){//????Ÿ ????%>
		
                <tr>                                                                 
                    <td width="110" align="center"><%=s_st2_nm[j]%></td>
                    <td width="110" class=title>?Ұ?</td>
		    <%					for (int k = 0 ; k < days+1 ; k++){%>	
                    <td class=title style='text-align:right'>
							0
		    </td>
		    <%					}%>
                </tr>	
                
                <%			}else{//????Ÿ ????
                				int car_nm_cnt = 0;
                				for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("S_ST")).equals(s_st2[j])){	
							
								for (int k = 0 ; k < days+1 ; k++){
									int i_cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(k)));
							
									cnt[k]  	= i_cnt;												
									s_cnt[k]   	= s_cnt[k] + i_cnt;
									h_cnt4[k] 	= h_cnt4[k] + i_cnt;																					
									t_cnt[k] 	= t_cnt[k] + i_cnt;									
								}
		%>
		
                <tr>                                    
                    <%if(car_nm_cnt==0){%>    
                    <td width="110" rowspan="<%=s_st2_row[j]+1%>" align="center"><%=s_st2_nm[j]%></td>                    
                    <%}%>
                    <td width="110" align="center"><%=ht.get("CAR_NM")%></td>
		    <%for (int k = 0 ; k < days+1 ; k++){%>	
                    <td align="right"><%=cnt[k]%></td>		    
		    <%}%>		    
                </tr>
                
                <%						car_nm_cnt++;
                					}
                				}%>	                
                <%			}%>               
                <%		}%>
                
                <%		if(s_st2_row[j]>0){//????Ÿ ????->?Ұ?????.%>
                <tr>                    
                    <td width="110" class=title>?Ұ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=s_cnt[k]%></td>
		    <%	}%>	
                </tr>
                <%		}%>	                		
                
		<%		//?Ұ? ?ʱ?ȭ
				for (int k = 0 ; k < days+1 ; k++){
					s_cnt[k] = 0;
				}						
			}
		%>
		<tr>                    
                    <td class=title colspan='2'>???? ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt4[k]%></td>
		    <%	}%>	
                </tr>
                <tr>                    
                    <td class=title colspan='2'>???? ????</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt4[k]))/AddUtil.parseFloat(String.valueOf(h_cnt3[k]+h_cnt4[k]))*100,1)%></td>
		    <%	}%>	
                </tr>
                <tr>                    
                    <td class=title colspan='3'>?縮?? ?հ?</td>
		    <%	for (int k = 0 ; k < days+1 ; k++){%>	
		    <td class=title style='text-align:right'><%=h_cnt3[k]+h_cnt4[k]%></td>
		    <%	}%>	
                </tr>
																																					
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>