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
	bus_st1_nm[0] = "������Ʈ";
	bus_st1_nm[1] = "�������";
	bus_st1_nm[2] = "��ȭ���,���ͳ�";
	bus_st1_nm[3] = "��ü�Ұ�,������ü";
	
	String bus_st2_nm[]	 	= new String[3];
	bus_st2_nm[0] = "������Ʈ";
	bus_st2_nm[1] = "�������";
	bus_st2_nm[2] = "�ڷ¿���";
	
	String rent_st_nm[]	 	= new String[2];
	rent_st_nm[0] = "����";
	rent_st_nm[1] = "����";
	
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
      <td>3. �⵵�� �����Ȳ</td>
    </tr>					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="3" class=title>����</td>
                    <td width=60 class=title>�հ�</td>
					<%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    <td width=60 class=title><%=j%>��</td>
					<%}%>
                </tr>
				
				<!--����/�ű�-->
				<%	Vector vt = sb_db.getStatBusRootList("1", s_yy, s_mm, days, f_year, gubun1);
					int vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("������Ʈ")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("�������")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("��ȭ���,���ͳ�")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								h_cnt3[j] 	= h_cnt3[j] + cnt3[j];
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("BUS_ST1")).equals("��ü�Ұ�,������ü")){
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
                    <%if(i==0){%><td width="50" rowspan="30" align="center">����</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="9" align="center">�ű�</td><%}%>
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
					<td class=is align="center">����</td>
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
					<td class=title>�Ұ�</td>
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
									
				<!--�ű�/����-->	
				<%	vt = sb_db.getStatBusRootList("2", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("������Ʈ")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("�������")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("�ڷ¿���")){
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
                    <%if(i==0){%><td width="40" rowspan="7" align="center">����</td><%}%>
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
					<td class=is align="center">����</td>
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
					<td class=title>�Ұ�</td>
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
									
				<!--�ű�/����-->	
				<%	vt = sb_db.getStatBusRootList("3", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("������Ʈ")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];
								h_cnt1[j] 	= h_cnt1[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j]  + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("�������")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								h_cnt2[j] 	= h_cnt2[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j]  + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST2")).equals("�ڷ¿���")){
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
                    <%if(i==0){%><td width="40" rowspan="7" align="center">����</td><%}%>
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
					<td class=is align="center">����</td>
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
					<td class=title>�Ұ�</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt[j]%></td>
					<%	}%>					
				</tr>		
				<tr>
					<td colspan='2' class=title>������Ʈ �հ�</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt1[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>����</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt1[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>������� �հ�</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt2[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>����</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt2[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>	
				<tr>
					<td colspan='2' class=title>�ڷ¿��� �հ�</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=h_cnt3[j]%></td>
					<%	}%>					
				</tr>						
				<tr>
					<td colspan='2' class=title>����</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(h_cnt3[j]))/AddUtil.parseFloat(String.valueOf(t_cnt[j]))*100,1)%></td>
					<%	}%>					
				</tr>													
				<tr>
					<td colspan='2' class=title>���� �հ�</td>
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
															
				<!--�縮��/�ű�-->
				<%	vt = sb_db.getStatBusRootList("4", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("������Ʈ")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j] + cnt1[j];
								t_cnt[j] 	= t_cnt[j] + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("�������")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt2[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j] + cnt2[j];
								t_cnt[j] 	= t_cnt[j] + cnt2[j];
							}
						}
						
						if(String.valueOf(ht.get("BUS_ST1")).equals("��ȭ���,���ͳ�")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt3[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];								
								t_cnt[j] 	= t_cnt[j]  + cnt3[j];
							}
						}
						if(String.valueOf(ht.get("BUS_ST1")).equals("��ü�Ұ�,������ü")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt4[j] 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt4[j];								
								t_cnt[j] 	= t_cnt[j]  + cnt4[j];
							}
						}
					}%>
					
				<%	for(int i = 0 ; i < 4 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="12" align="center">�縮��</td><%}%>
                    <%if(i==0){%><td width="40" rowspan="9" align="center">�ű�</td><%}%>
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
					<td class=is align="center">����</td>
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
					<td class=title>�Ұ�</td>
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
						
						
				<!--�縮��/����,����-->	
				<%	vt = sb_db.getStatBusRootList("5", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("RENT_ST")).equals("����")){
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								h_cnt[j] = h_cnt[j] + cnt1[j];
								t_cnt[j] = t_cnt[j] + cnt1[j];
							}
						}
						
						if(String.valueOf(ht.get("RENT_ST")).equals("����")){
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
					<td colspan='2' class=title>�հ�</td>
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
						
						
				<!--����-->	
				<%	vt = sb_db.getStatBusRootList("6", s_yy, s_mm, days, f_year, gubun1);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
							for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
							}
						
					}%>
					
                <tr> 
                    <td colspan='3' align="center">����</td>					
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){
							tt_cnt[j] = tt_cnt[j] + cnt1[j];%>	
                    <td align="right"><%=cnt1[j]%></td>
					<%	}%>
                </tr>	

				<tr>
					<td colspan='3' class=title>�Ѱ�</td>
					<%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>	
                    <td class=title style='text-align:right'><%=tt_cnt[j]%></td>
					<%	}%>					
				</tr>		
																																					
            </table>
        </td>
    </tr>
    <tr>
      <td>�� ���ͳ�, �����, ��ȭ���, Catalog�� ��ȭ���/���ͳݿ� ����, �߰����� �縮���� ����</td>
    </tr>						
</table>
</form>
</body>
</html>