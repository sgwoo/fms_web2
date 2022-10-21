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
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	int cnt1[]	 		= new int[years+1];
	int cnt2[]	 		= new int[years+1];
	int cnt3[]	 		= new int[years+1];
	int cnt4[]	 		= new int[years+1];
	int cnt5[]	 		= new int[years+1];
	int cnt6[]	 		= new int[years+1];
	int cnt7[]	 		= new int[years+1];	
	int cnt8[]	 		= new int[years+1];	
	
	int h_cnt[]	 		= new int[years+1];
	
	int t_cnt1[]	 		= new int[years+1];
	int t_cnt2[]	 		= new int[years+1];
	int t_cnt3[]	 		= new int[years+1];
	int t_cnt4[]	 		= new int[years+1];
	int t_cnt5[]	 		= new int[years+1];
	int t_cnt6[]	 		= new int[years+1];
	int t_cnt7[]	 		= new int[years+1];	
	int t_cnt8[]	 		= new int[years+1];	
	
	int th_cnt[]	 		= new int[years+1];

	int tot_cnt1 = 0;
	int tot_cnt2 = 0;
	int tot_cnt3 = 0;
	int tot_cnt4 = 0;
	int tot_cnt5 = 0;
	int tot_cnt6 = 0;
	int tot_cnt7 = 0;
	int tot_cnt8 = 0;
	
	int tot_h_cnt = 0;
	
	int tot_t_cnt1 = 0;
	int tot_t_cnt2 = 0;
	int tot_t_cnt3 = 0;
	int tot_t_cnt4 = 0;
	int tot_t_cnt5 = 0;
	int tot_t_cnt6 = 0;
	int tot_t_cnt7 = 0;
	int tot_t_cnt8 = 0;
	
	int tot_th_cnt = 0;
	
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
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents() {
		window.onscroll = moveTitle;
		window.onresize = moveTitle; 
	}
	
	function moveTitle() {
	    var X ;
	    
	    document.all.tr_title.style.top = document.body.scrollTop;
	    document.all.td_title.style.left = document.body.scrollLeft; 
	    document.all.td_con.style.left	= document.body.scrollLeft;   	    	    
	}
	
	function init() {
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="JavaScript:init()" style="margin-left: 0;">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 			value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 			value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=120+80+100+(100*years)%> style="padding-right: 30px;">
    <tr>
      <td>3. 년도별 계약현황</td>
    </tr>
    <tr id='tr_title' style='position:relative; z-index:1;'> 
        <td width='300' class='line' id='td_title' style='position:relative;'> 
            <table width='100%' border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width='200' colspan="2" rowspan='2'  class=title>구분</td>
                    <td width='100' colspan='2' class=title>합계</td>
                </tr>
                <tr align="center"> 
                	<td class='title' width='60'>건수</td>
                    <td class='title' width='40'>비율</td>
                </tr> 
              </table>
          </td>
        <td class='line' >
          	<table border="0" cellspacing="1" cellpadding="0" width=100%>
          		<tr align="center">
          			<%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    	<td width=100 colspan='2' class='title'><%=j%>년</td>
					<%}%>
          		</tr>
          		<tr align="center">
          			<%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
	                    <td class='title' width='60'>건수</td>
	                    <td class='title' width='40'>비율</td>
					<%}%>
          		</tr>
          	</table>
          </td>
     </tr>
      <tr>
        	<td width='300' class='line' id='td_con' style='position:relative; z-index:1;'>
        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<!--신차-->
				<%	Vector vt = sb_db.getStatConMonList("1", s_yy, s_mm, days, f_year, gubun1, gubun2);
					int vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							tot_cnt1 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt1;
							tot_t_cnt1 	= tot_t_cnt1 + tot_cnt1;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt1;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							tot_cnt2 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt2;
							tot_t_cnt2 	= tot_t_cnt2 + tot_cnt2;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt2;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							tot_cnt3 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt3;
							tot_t_cnt3 	= tot_t_cnt3 + tot_cnt3;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt3;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							tot_cnt4 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt4;
							tot_t_cnt4 	= tot_t_cnt4 + tot_cnt4;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt4;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							tot_cnt5 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt5;
							tot_t_cnt5 	= tot_t_cnt5 + tot_cnt5;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt5;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							tot_cnt6 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt6;
							tot_t_cnt6 	= tot_t_cnt6 + tot_cnt6;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt6;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							tot_cnt7 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt7;
							tot_t_cnt7 	= tot_t_cnt7 + tot_cnt7;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt7;
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;%>
				<tr>
					<%if(i==0){%><td width="80" rowspan="6" align="center">신차</td><%}%>
					<td width="120" align="center"><%=con_mon_nm[i]%></td>
					<td width="60" align="right">
						<%if(i==0){%>		<%=tot_cnt1%>
						<%}else if(i==1){%>	<%=tot_cnt2%>
						<%}else if(i==2){%>	<%=tot_cnt3%>
						<%}else if(i==3){%>	<%=tot_cnt4%>
						<%}else if(i==4){%>	<%=tot_cnt5%>
						<%}else if(i==5){%>	<%=tot_cnt6%>
						<%}else if(i==6){%>	<%=tot_cnt7%>
						<%}%>
					</td>
					<td width="40" align="right">
						<%if(i==0){%>		<%if(tot_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt1))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(tot_cnt2>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt2))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(tot_cnt3>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt3))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(tot_cnt4>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt4))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(tot_cnt5>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt5))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(tot_cnt6>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt6))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(tot_cnt7>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt7))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>
				</tr>
				<%	}%>	
				<tr>
					<td class=title>소계</td>
                    <td class=title width='60' style='text-align:right'><%=tot_h_cnt%></td>
                    <td class=title width='40' style='text-align:right'><%if(tot_h_cnt>0){%>100<%}else{%>0<%}%></td>
				</tr>					
				<%
					tot_cnt1 = 0;
					tot_cnt2 = 0;
					tot_cnt3 = 0;
					tot_cnt4 = 0;
					tot_cnt5 = 0;
					tot_cnt6 = 0;
					tot_cnt7 = 0;
					tot_h_cnt = 0;
				%>
					
				<!--재리스-->
				<%	vt = sb_db.getStatConMonList("2", s_yy, s_mm, days, f_year, gubun1, gubun2);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							tot_cnt1 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt1;
							tot_t_cnt1 	= tot_t_cnt1 + tot_cnt1;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt1;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							tot_cnt2 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt2;
							tot_t_cnt2 	= tot_t_cnt2 + tot_cnt2;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt2;
						}
						
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							tot_cnt3 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt3;
							tot_t_cnt3 	= tot_t_cnt3 + tot_cnt3;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt3;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							tot_cnt4 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt4;
							tot_t_cnt4 	= tot_t_cnt4 + tot_cnt4;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt4;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							tot_cnt5 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt5;
							tot_t_cnt5 	= tot_t_cnt5 + tot_cnt5;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt5;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							tot_cnt6 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt6;
							tot_t_cnt6 	= tot_t_cnt6 + tot_cnt6;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt6;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							tot_cnt7 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt7;
							tot_t_cnt7 	= tot_t_cnt7 + tot_cnt7;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt7;
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;%>				
                <tr> 
                	<%if(i==0){%><td width="50" rowspan="6" align="center">재리스</td><%}%>
                	<td width="80" align="center"><%=con_mon_nm[i]%></td>
					<td width="60" align="right">
						<%if(i==0){%>		<%=tot_cnt1%>
						<%}else if(i==1){%>	<%=tot_cnt2%>
						<%}else if(i==2){%>	<%=tot_cnt3%>
						<%}else if(i==3){%>	<%=tot_cnt4%>
						<%}else if(i==4){%>	<%=tot_cnt5%>
						<%}else if(i==5){%>	<%=tot_cnt6%>
						<%}else if(i==6){%>	<%=tot_cnt7%>
						<%}%>
					</td>
					<td width="40" align="right">
						<%if(i==0){%>		<%if(tot_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt1))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(tot_cnt2>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt2))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(tot_cnt3>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt3))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(tot_cnt4>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt4))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(tot_cnt5>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt5))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(tot_cnt6>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt6))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(tot_cnt7>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt7))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>
				</tr>
				<%	}%>	
				<tr>
					<td class=title>소계</td>
                    <td class=title width='60' style='text-align:right'><%=tot_h_cnt%></td>
                    <td class=title width='40' style='text-align:right'><%if(tot_h_cnt>0){%>100<%}else{%>0<%}%></td>
				</tr>					
				<%
					tot_cnt1 = 0;
					tot_cnt2 = 0;
					tot_cnt3 = 0;
					tot_cnt4 = 0;
					tot_cnt5 = 0;
					tot_cnt6 = 0;
					tot_cnt7 = 0;
					tot_h_cnt = 0;
				%>
					
				<!--연장-->
				<%	vt = sb_db.getStatConMonList("3", s_yy, s_mm, days, f_year, gubun1, gubun2);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							tot_cnt1 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt1;
							tot_t_cnt1 	= tot_t_cnt1 + tot_cnt1;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt1;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							tot_cnt2 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt2;
							tot_t_cnt2 	= tot_t_cnt2 + tot_cnt2;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt2;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							tot_cnt3 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt3;
							tot_t_cnt3 	= tot_t_cnt3 + tot_cnt3;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt3;
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							tot_cnt4 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt4;
							tot_t_cnt4 	= tot_t_cnt4 + tot_cnt4;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt4;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							tot_cnt5 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt5;
							tot_t_cnt5 	= tot_t_cnt5 + tot_cnt5;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt5;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							tot_cnt6 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt6;
							tot_t_cnt6 	= tot_t_cnt6 + tot_cnt6;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt6;
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							tot_cnt7 = AddUtil.parseInt((String)ht.get("CNT0"));
							tot_h_cnt = tot_h_cnt + tot_cnt7;
							tot_t_cnt7 	= tot_t_cnt6 + tot_cnt7;								
							tot_th_cnt 	= tot_th_cnt  + tot_cnt7;
						}	
					}					
				%>
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;%>			
				<tr> 
                	<%if(i==0){%><td width="50" rowspan="6" align="center">연장</td><%}%>
                	<td width="80" align="center"><%=con_mon_nm[i]%></td>
					<td width="60" align="right">
						<%if(i==0){%>		<%=tot_cnt1%>
						<%}else if(i==1){%>	<%=tot_cnt2%>
						<%}else if(i==2){%>	<%=tot_cnt3%>
						<%}else if(i==3){%>	<%=tot_cnt4%>
						<%}else if(i==4){%>	<%=tot_cnt5%>
						<%}else if(i==5){%>	<%=tot_cnt6%>
						<%}else if(i==6){%>	<%=tot_cnt7%>
						<%}%>
					</td>
					<td width="40" align="right">
						<%if(i==0){%>		<%if(tot_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt1))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(tot_cnt2>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt2))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(tot_cnt3>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt3))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(tot_cnt4>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt4))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(tot_cnt5>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt5))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(tot_cnt6>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt6))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(tot_cnt7>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_cnt7))/AddUtil.parseFloat(String.valueOf(tot_h_cnt))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>
				</tr>	
				<%	}%>
				<tr>
					<td class=title>소계</td>
                    <td class=title width='60' style='text-align:right'><%=tot_h_cnt%></td>
                    <td class=title width='40' style='text-align:right'><%if(tot_h_cnt>0){%>100<%}else{%>0<%}%></td>
				</tr>					
					  
				<!--합계-->					
				<%	for(int i = 0 ; i < 7 ; i++){
						if(i==1) continue;
						if(i==3) continue;%>				
                <tr> 
                	<%if(i==0){%><td width="50" rowspan="6" align="center">합계</td><%}%>
                	<td width="80" align="center"><%=con_mon_nm[i]%></td>
                	<td align="right">
						<%if(i==0){%>		<%=tot_t_cnt1%>
						<%}else if(i==1){%>	<%=tot_t_cnt2%>
						<%}else if(i==2){%>	<%=tot_t_cnt3%>
						<%}else if(i==3){%>	<%=tot_t_cnt4%>
						<%}else if(i==4){%>	<%=tot_t_cnt5%>
						<%}else if(i==5){%>	<%=tot_t_cnt6%>
						<%}else if(i==6){%>	<%=tot_t_cnt7%>
						<%}%>
					</td>
					<td width="40" align="right">
						<%if(i==0){%>		<%if(tot_t_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt1))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(tot_t_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt2))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(tot_t_cnt1>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt3))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(tot_t_cnt4>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt4))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(tot_t_cnt5>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt5))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(tot_t_cnt6>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt6))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(tot_t_cnt7>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(tot_t_cnt7))/AddUtil.parseFloat(String.valueOf(tot_th_cnt))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>
				</tr>	
				<%	}%>	
				<tr>
					<td class=title>소계</td>
                    <td class=title width='60' style='text-align:right'><%=tot_th_cnt%></td>
                    <td class=title width='40' style='text-align:right'><%if(tot_th_cnt>0){%>100<%}else{%>0<%}%></td>
				</tr>
            </table>
        	</td>
        	<td class='line' style='z-index:-1;'>
        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
        			<!-- 신차 -->
        			<%	vt = sb_db.getStatConMonList("1", s_yy, s_mm, days, f_year, gubun1, gubun2);
						vt_size = vt.size();%>
					<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("CON_MON")).equals("12개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];																
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];								
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];								
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
						if(i==3) continue;%>
                <tr> 
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td width="60" align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}else if(i==6){%>	<%=cnt7[j]%>
						<%}%>
					</td>
					<td width="40" align="right">
						<%if(i==0){%>		<%if(cnt1[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(cnt2[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(cnt3[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(cnt4[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(cnt5[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt5[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(cnt6[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(cnt7[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt7[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>					
					<%	}%>
                </tr>	
				<%	}%>		

				<tr>
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
                    <td class=title width='60' style='text-align:right'><%=h_cnt[j]%></td>
                    <td class=title width='40' style='text-align:right'><%if(h_cnt[j]>0){%>100<%}else{%>0<%}%></td>
					<%	}%>
				</tr>					
				
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];							
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];							
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
						if(i==3) continue;%>				
                <tr> 
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
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
					<td width="40" align="right">
						<%if(i==0){%>		<%if(cnt1[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(cnt2[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(cnt3[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(cnt4[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(cnt5[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt5[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(cnt6[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(cnt7[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt7[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>	
					<%	}%>
                </tr>	
				<%	}%>

				<tr>
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
                    <td class=title style='text-align:right'><%if(h_cnt[j]>0){%>100<%}else{%>0<%}%></td>
					<%	}%>			
				</tr>					
				
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								t_cnt1[j] 	= t_cnt1[j] + cnt1[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt1[j];									
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("13개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt2[j] 	= t_cnt2[j] + cnt2[j];	
								th_cnt[j] 	= th_cnt[j]  + cnt2[j];									
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("24개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt3[j] 	= t_cnt3[j] + cnt3[j];
								th_cnt[j] 	= th_cnt[j]  + cnt3[j];		
							}
						}
						if(String.valueOf(ht.get("CON_MON")).equals("30개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								t_cnt4[j] 	= t_cnt4[j] + cnt4[j];
								th_cnt[j] 	= th_cnt[j]  + cnt4[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("36개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt5[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt5[j];
								t_cnt5[j] 	= t_cnt5[j] + cnt5[j];
								th_cnt[j] 	= th_cnt[j]  + cnt5[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("48개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt6[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt6[j];
								t_cnt6[j] 	= t_cnt6[j] + cnt6[j];
								th_cnt[j] 	= th_cnt[j]  + cnt6[j];		
							}
						}	
						if(String.valueOf(ht.get("CON_MON")).equals("60개월")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
						if(i==3) continue;%>			
				
                <tr> 
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
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
					<td align="right">
						<%if(i==0){%>		<%if(cnt1[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(cnt2[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(cnt3[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(cnt4[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(cnt5[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt5[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(cnt6[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(cnt7[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(cnt7[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>		
					<%	}%>
                </tr>	
				<%	}%>
				<tr>
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
                    <td class=title style='text-align:right'><%if(h_cnt[j]>0){%>100<%}else{%>0<%}%></td>
					<%	}%>		
				</tr>					
				
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
						if(i==3) continue;%>				
                <tr> 
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
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
					<td align="right">
						<%if(i==0){%>		<%if(t_cnt1[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt1[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==1){%>	<%if(t_cnt2[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt2[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==2){%>	<%if(t_cnt3[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt3[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==3){%>	<%if(t_cnt4[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt4[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==4){%>	<%if(t_cnt5[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt5[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==5){%>	<%if(t_cnt6[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt6[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}else if(i==6){%>	<%if(t_cnt7[j]>0){%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(t_cnt7[j]))/AddUtil.parseFloat(String.valueOf(th_cnt[j]))*100,1)%><%}else{%>0<%}%>
						<%}%>
					</td>					
					<%	}%>
                </tr>	
				<%	}%>

				<tr>
					<%	for (int j = (f_year-2000) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
                    <td class=title style='text-align:right'><%=th_cnt[j]%></td>
                    <td class=title style='text-align:right'><%if(th_cnt[j]>0){%>100<%}else{%>0<%}%></td>
					 <%	}%>					
				</tr>
        		</table>
        	</td>
    	</tr>
    <tr>
      <td colspan="2">※ LPG차량 = 소형승용LPG+중형승용LPG+대형승용LPG, 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</td>
    </tr>						
</table>
</form>
</body>
</html>