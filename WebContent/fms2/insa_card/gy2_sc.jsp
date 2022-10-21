<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�����Ȳ2
	
	Vector vt1 = ic_db.gy2list_yeardate();
	int vt1_size = vt1.size();
	
	int cnt1[] = new int[10];
	int cnt2[] = new int[10];
	
	int year_cnt = 8; 
	
	int td_width = 120;		
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">

<!--

//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width="<%=td_width*10%>">
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������Ȳ </span></td>
      <td align="right"></td>
    </tr>
    <tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 ></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD rowspan='2' colspan="2" class='title'>����</TD>					          
					          <TD colspan="4" class='title'>ä����Ȳ</TD>
					          <TD colspan="4" class='title'>������Ȳ</TD>
		        			</TR>
		        			<tr>
                              <td width="<%=td_width%>" class=title>�ܱ���</td>
                              <td width="<%=td_width%>" class=title>����/�繫��</td>
                              <td width="<%=td_width%>" class=title>�����</td>
                              <td width="<%=td_width%>" class=title>�հ�</td>
                              <td width="<%=td_width%>" class=title>�ܱ���</td>
                              <td width="<%=td_width%>" class=title>����/�繫��</td>
                              <td width="<%=td_width%>" class=title>�����</td>
                              <td width="<%=td_width%>" class=title>�հ�</td>
		        			</TR>
		        			<%	for(int i = 0 ; i < vt1_size ; i++){
									Hashtable ht = (Hashtable)vt1.elementAt(i);
									
									if(!String.valueOf(ht.get("SAVE_DT")).equals("�հ�")){
										
										if(String.valueOf(ht.get("USER_FM")).equals("��")){
											for (int j = 1 ; j <= year_cnt ; j++){
												cnt1[j] = cnt1[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
											}
										}
										if(String.valueOf(ht.get("USER_FM")).equals("��")){
											for (int j = 1 ; j <= year_cnt ; j++){
												cnt2[j] = cnt2[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
											}
										}
							%>
					        <TR>
					          <%if(String.valueOf(ht.get("USER_FM")).equals("��")){%><TD rowspan="3" width="<%=td_width%>" class='title'><%=ht.get("SAVE_DT")%>��</TD><%}%>
					          <TD width="<%=td_width%>" class='title'><%=ht.get("USER_FM")%></TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center" <%if(String.valueOf(ht.get("USER_FM")).equals("�Ұ�")){%>class='title'<%}%>><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>
				            </TR>							
							<%		}else{%>
					        <TR>
					          <TD rowspan="3" width="<%=td_width%>" class='title'>�հ�</TD>
					          <TD width="<%=td_width%>" class='title'>��</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=cnt1[j]%>&nbsp;��</TD>
					          <%}%>
				            </TR>	
				            <TR>
					          <TD width="<%=td_width%>" class='title'>��</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=cnt2[j]%>&nbsp;��</TD>
					          <%}%>
				            </TR>	
				            <TR>
					          <TD width="<%=td_width%>" class='title'>��</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center" <%if(String.valueOf(ht.get("USER_FM")).equals("�Ұ�")){%>class='title'<%}%>><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>
				            </TR>												            								
							<%		}%>		
							<%	}%>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td colspan='2'>&nbsp;</td>
    </tr>
</table> 
<table border="0" cellspacing="0" cellpadding="0" width="<%=(td_width*10)+20%>">  
			<tr>
				<td colspan="2">
					<table border="0" cellspacing="0" cellpadding="0" width=100%>
						<tr>
							<td>
								<iframe src="gy2_sc_in.jsp?basic_dt=<%=AddUtil.getDate2(1)%>" width="100%" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 > </iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>    
</table>
</body>
</html>