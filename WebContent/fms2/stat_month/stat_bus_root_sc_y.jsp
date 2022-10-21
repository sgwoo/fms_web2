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
	String gubun1 	= request.getParameter("gubun1")==null?AddUtil.getDate(2):request.getParameter("gubun1");
	
	int f_year 	= 2001;	
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	int cnt1[]	 = new int[years+1];
	int cnt2[]	 = new int[years+1];
	int cnt3[]	 = new int[years+1];
	int cnt4[]	 = new int[years+1];
	int cnt5[]	 = new int[years+1];
	int cnt6[]	 = new int[years+1];	
	
	
	int h_cnt[]	= new int[years+1];
	int h_cnt1[] 	= new int[years+1];
	int h_cnt2[] 	= new int[years+1];
	int h_cnt3[]	= new int[years+1];
	int t_cnt[]	= new int[years+1];
	int tt_cnt[]	= new int[years+1];
	
	String bus_st1_nm[]	 	= new String[4];
	bus_st1_nm[0] = "에이젼트";
	bus_st1_nm[1] = "영업사원";
	bus_st1_nm[2] = "전화상담,인터넷";
	bus_st1_nm[3] = "업체소개,기존업체";
	
	String bus_st2_nm[]	 	= new String[3];
	bus_st2_nm[0] = "에이젼트";
	bus_st2_nm[1] = "영업사원";
	bus_st2_nm[2] = "자력영업";
	
	String rent_st_nm[]	 	= new String[2];
	rent_st_nm[0] = "증차";
	rent_st_nm[1] = "대차";
	
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
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
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
				
				<!--신차/신규-->
				<%	Vector vt = sb_db.getStatBusRootList("1", s_yy, s_mm, days, f_year, gubun1);
					int vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("에이젼트")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("영업사원")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("전화상담,인터넷")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								h_cnt3[j] 	= h_cnt3[j] + cnt3[j];
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("BUS_ST1")).equals("업체소개,기존업체")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];
								h_cnt3[j] 	= h_cnt3[j] + cnt4[j];
								t_cnt[j] 	= t_cnt[j]  + cnt4[j];
							}
						}
					}%>
					
				<%	for(int i = 0 ; i < 4 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="30" align="center">신차</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="9" align="center">신규</td><%}%>
                    <td width="110" align="center"><%=bus_st1_nm[i]%></td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<tr>
					<td class=is align="center">비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=is align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}%>
					</td>
					<%	}%>					
				</tr>	
				<%	}%>
				<tr>
					<td class=title>소계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>					
				
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						h_cnt[j] = 0;
					}%>		
									
				<!--신규/증차-->	
				<%	vt = sb_db.getStatBusRootList("2", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("에이젼트")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("영업사원")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("자력영업")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								h_cnt3[j] 	= h_cnt3[j] + cnt3[j];
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}						
					}%>
					
				<%	for(int i = 0 ; i < 3 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="40" rowspan="7" align="center">증차</td><%}%>
                    <td width="110" align="center"><%=bus_st2_nm[i]%></td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<tr>
					<td class=is align="center">비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=is align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}%>
					</td>
					<%	}%>					
				</tr>	
				<%	}%>
				<tr>
					<td class=title>소계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>				
							
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						h_cnt[j] = 0;
					}%>		
									
				<!--신규/대차-->	
				<%	vt = sb_db.getStatBusRootList("3", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("에이젼트")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("영업사원")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("자력영업")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								h_cnt3[j] 	= h_cnt3[j] + cnt3[j];
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}
						
					}%>
					
				<%	for(int i = 0 ; i < 3 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="40" rowspan="7" align="center">대차</td><%}%>
                    <td width="110" align="center"><%=bus_st2_nm[i]%></td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<tr>
					<td class=is align="center">비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=is align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}%>
					</td>
					<%	}%>					
				</tr>	
				<%	}%>
				<tr>
					<td class=title>소계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>		
				<tr>
					<td colspan='2' class=title>에이젼트 합계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt1[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt1[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>영업사원 합계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt2[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt2[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>	
				<tr>
					<td colspan='2' class=title>자력영업 합계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt3[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt3[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>													
				<tr>
					<td colspan='2' class=title>신차 합계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
							tt_cnt[j] = tt_cnt[j] + t_cnt[j];%>	
                    <td class=title style='text-align:right'><%=t_cnt[j]%></td>
					<%	}%>					
				</tr>		
						

				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						h_cnt[j] = 0;
						t_cnt[j] = 0;
					}%>		
															
				<!--재리스/신규-->
				<%	vt = sb_db.getStatBusRootList("4", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("에이젼트")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j] + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("영업사원")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j] + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("전화상담,인터넷")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];								
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("BUS_ST1")).equals("업체소개,기존업체")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];								
								t_cnt[j] 	= t_cnt[j]  + cnt4[j];
							}
						}
					}%>
					
				<%	for(int i = 0 ; i < 4 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="12" align="center">재리스</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="9" align="center">신규</td><%}%>
                    <td width="110" align="center"><%=bus_st1_nm[i]%></td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}else if(i==2){%>	<%=cnt3[j]%>
						<%}else if(i==3){%>	<%=cnt4[j]%>
						<%}else if(i==4){%>	<%=cnt5[j]%>
						<%}else if(i==5){%>	<%=cnt6[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<tr>
					<td class=is align="center">비율</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=is align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==3){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==4){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}else if(i==5){%>	<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[j]))/AddUtil.parseFloat(String.valueOf(h_cnt[j]))*100,1)%>
						<%}%>
					</td>
					<%	}%>					
				</tr>	
				<%	}%>
				<tr>
					<td class=title>소계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>	
						
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						h_cnt[j] = 0;
					}%>		
						
						
				<!--재리스/증차,대차-->	
				<%	vt = sb_db.getStatBusRootList("5", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("RENT_ST")).equals("증차")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] = h_cnt[j] + cnt1[j];
								t_cnt[j] = t_cnt[j] + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("RENT_ST")).equals("대차")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] = h_cnt[j] + cnt2[j];
								t_cnt[j] = t_cnt[j] + cnt2[j];
							}
						}
						
					}%>
					
				<%	for(int i = 0 ; i < 2 ; i++){%>
                <tr> 
                    <td colspan='2' align="center"><%=rent_st_nm[i]%></td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=cnt1[j]%>
						<%}else if(i==1){%>	<%=cnt2[j]%>
						<%}%>
					</td>
					<%	}%>
                </tr>	
				<%	}%>
				<tr>
					<td colspan='2' class=title>합계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
							tt_cnt[j] = tt_cnt[j] + t_cnt[j];%>	
                    <td class=title style='text-align:right'><%=t_cnt[j]%></td>
					<%	}%>					
				</tr>				
				
				<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;
						cnt4[j] = 0;
						cnt5[j] = 0;
						cnt6[j] = 0;
						h_cnt[j] = 0;
					}%>		
						
						
				<!--연장-->	
				<%	vt = sb_db.getStatBusRootList("6", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
							}
						
					}%>
					
                <tr> 
                    <td colspan='3' align="center">연장</td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
							tt_cnt[j] = tt_cnt[j] + cnt1[j];%>	
                    <td align="right"><%=cnt1[j]%></td>
					<%	}%>
                </tr>	

				<tr>
					<td colspan='3' class=title>총계</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=tt_cnt[j]%></td>
					<%	}%>					
				</tr>		
																																					
            </table>
        </td>
    </tr>
    <tr>
      <td>※ 인터넷, 모바일, 전화상담, Catalog는 전화상담/인터넷에 포함, 중고차는 재리스에 포함</td>
    </tr>						
</table>
</form>
</body>
</html>