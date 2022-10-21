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
	
	int cnt0[]	 			= new int[days+1];
	int cnt1[]	 			= new int[days+1];
	int cnt2[]	 			= new int[days+1];
	
	int t_cnt0[]	 		= new int[days+1];
	int t_cnt1[]	 		= new int[days+1];
	int t_cnt2[]	 		= new int[days+1];
	
	String lpg_yn[]	 		= new String[2];
	lpg_yn[0] = "Y";
	lpg_yn[1] = "N";
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
  <input type='hidden' name='s_yy' 			value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 			value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+80+40+(40*days)%>>
    <tr>
      <td>1. �Ϻ� �����Ȳ</td>
    </tr>	
	<%	Vector vt = new Vector();
		int vt_size = 0;
	%>
	
	<%	for (int k = 0 ; k < 2 ; k++){		%>	
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
      <td>&nbsp;&nbsp;&nbsp;
	  		<font color='red'><b>
	  		<%if(lpg_yn[k].equals("Y")){%>
				[ LPG���� ]
			<%}else{%>
				[ ��LPG���� ]
			<%}%>
			</b></font>
	  </td>
    </tr>	
	
	
		<%
			for (int j = 0 ; j < days+1 ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
				t_cnt0[j] = 0;
				t_cnt1[j] = 0;
				t_cnt2[j] = 0;
			}
			%>				
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" class=title>����</td>
                    <td width=40 class=title>�հ�</td>
					<%for (int j = 0 ; j < days ; j++){%>
                    <td width=40 class=title><%=j+1%>��</td>
					<%}%>
                </tr>
				<!--����-->
				<%	vt = sb_db.getStatLpgRentwayList(lpg_yn[k], "1", s_yy, s_mm, days, f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="4" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							if(String.valueOf(ht.get("RENT_WAY")).equals("�Ϲݽ�")){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt1[j] = t_cnt1[j]+ cnt1[j];
							}else if(String.valueOf(ht.get("RENT_WAY")).equals("�⺻��")){
								cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt2[j] = t_cnt2[j]+ cnt2[j];
							}
					%>	
                    <td align="right"><%=ht.get("CNT"+(j))%></td>
					<%	}%>
                </tr>		
				<%	}%>		
				
				<!--���� ����� 2�� �ƴҶ�-->
				<%	if(vt_size<2){
						for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="50" rowspan="4" align="center">����</td><%}%>
                    <td width="80" align="center"><%if(cnt1[0]==0 && i==0){%>�Ϲݽ�<%}else{%>�⺻��<%}%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							t_cnt1[j] = t_cnt1[j]+ 0;
							t_cnt2[j] = t_cnt2[j]+ 0;
					%>	
                    <td align="right"><%=0%></td>
					<%	}%>
                </tr>						
				<%		}
					}%>
					
                <tr> 
                    <td width="80" class=title>�Ұ�</td>
					<%for (int j = 0 ; j < days+1 ; j++){
							cnt0[j] = cnt1[j]+cnt2[j];
							t_cnt0[j] = t_cnt0[j]+cnt0[j];%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
					<%}%>
                </tr>
				
                <tr> 
                    <td width="80" class=is align="center">����</td>
					<%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=is align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(cnt0[j]))*100,1)%></td>
					<%}%>
                </tr>		
				
				
				<%	for (int j = 0 ; j < days+1 ; j++){
						cnt0[j] = 0;
						cnt1[j] = 0;
						cnt2[j] = 0;
					}%>		
						
				<!--�縮��-->
				<%	vt = sb_db.getStatLpgRentwayList(lpg_yn[k], "2", s_yy, s_mm, days, f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="4" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							if(String.valueOf(ht.get("RENT_WAY")).equals("�Ϲݽ�")){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt1[j] = t_cnt1[j]+ cnt1[j];
							}else if(String.valueOf(ht.get("RENT_WAY")).equals("�⺻��")){
								cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt2[j] = t_cnt2[j]+ cnt2[j];
							}
					%>	
                    <td align="right"><%=ht.get("CNT"+(j))%></td>
					<%	}%>
                </tr>		
				<%	}%>		
				
				<!--�縮�� ����� 2�� �ƴҶ�-->
				<%	if(vt_size<2){
						for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="50" rowspan="4" align="center">�縮��</td><%}%>
                    <td width="80" align="center"><%if(cnt1[0]==0 && i==0){%>�Ϲݽ�<%}else{%>�⺻��<%}%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							t_cnt1[j] = t_cnt1[j]+ 0;
							t_cnt2[j] = t_cnt2[j]+ 0;
					%>	
                    <td align="right"><%=0%></td>
					<%	}%>
                </tr>						
				<%		}
					}%>		
											
                <tr> 
                    <td width="80" class=title>�Ұ�</td>
					<%for (int j = 0 ; j < days+1 ; j++){
							cnt0[j] = cnt1[j]+cnt2[j];
							t_cnt0[j] = t_cnt0[j]+cnt0[j];%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
					<%}%>
                </tr>
				
                <tr> 
                    <td width="80" class=is align="center">����</td>
					<%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=is align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(cnt0[j]))*100,1)%></td>
					<%}%>
                </tr>		
				
				
				<%	for (int j = 0 ; j < days+1 ; j++){
						cnt0[j] = 0;
						cnt1[j] = 0;
						cnt2[j] = 0;
					}%>	
																								
				<!--����-->
				<%	vt = sb_db.getStatLpgRentwayList(lpg_yn[k], "3", s_yy, s_mm, days, f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <%if(i==0){%><td width="50" rowspan="4" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							if(String.valueOf(ht.get("RENT_WAY")).equals("�Ϲݽ�")){
								cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt1[j] = t_cnt1[j]+ cnt1[j];
							}else if(String.valueOf(ht.get("RENT_WAY")).equals("�⺻��")){
								cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
								t_cnt2[j] = t_cnt2[j]+ cnt2[j];
							}
					%>	
                    <td align="right"><%=ht.get("CNT"+(j))%></td>
					<%	}%>
                </tr>		
				<%	}%>		
					
				<!--���� ����� 2�� �ƴҶ�-->
				<%	if(vt_size<2){
						for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="50" rowspan="4" align="center">����</td><%}%>
                    <td width="80" align="center"><%if(cnt1[0]==0 && i==0){%>�Ϲݽ�<%}else{%>�⺻��<%}%></td>
					<%	for (int j = 0 ; j < days+1 ; j++){
							t_cnt1[j] = t_cnt1[j]+ 0;
							t_cnt2[j] = t_cnt2[j]+ 0;
					%>	
                    <td align="right"><%=0%></td>
					<%	}%>
                </tr>						
				<%		}
					}%>	
											
                <tr> 
                    <td width="80" class=title>�Ұ�</td>
					<%for (int j = 0 ; j < days+1 ; j++){
							cnt0[j] = cnt1[j]+cnt2[j];
							t_cnt0[j] = t_cnt0[j]+cnt0[j];%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
					<%}%>
                </tr>
				
                <tr> 
                    <td width="80" class=is align="center">����</td>
					<%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=is align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[j]))/AddUtil.parseFloat(String.valueOf(cnt0[j]))*100,1)%></td>
					<%}%>
                </tr>		
		
				<!--�հ�-->							
                <tr> 
                    <td width="50" rowspan="4" align="center">�հ�</td>
                    <td width="80" align="center">�Ϲݽ�</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right"><%=t_cnt1[j]%></td>
					<%	}%>
                </tr>										
                <tr> 
                    <td width="80" align="center">�⺻��</td>
					<%	for (int j = 0 ; j < days+1 ; j++){%>	
                    <td align="right"><%=t_cnt2[j]%></td>
					<%	}%>
                </tr>										
                <tr> 
                    <td width="80" class=title>�Ұ�</td>
					<%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=title style='text-align:right'><%=t_cnt0[j]%></td>
					<%}%>
                </tr>
				
                <tr> 
                    <td width="80" class=is align="center">����</td>
					<%for (int j = 0 ; j < days+1 ; j++){%>
                    <td class=is align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[j]))/AddUtil.parseFloat(String.valueOf(t_cnt0[j]))*100,1)%></td>
					<%}%>
                </tr>																		
            </table>
        </td>
    </tr>
	<%}%>	
    <tr>
      <td>�� �����¿�LPG+�����¿�LPG+�����¿�LPG, ���������/����������/���°�/���������� ����, �߰����� �縮���� ����, ������� �⺻�Ŀ� ����</td>
    </tr>						
</table>
</form>
</body>
</html>