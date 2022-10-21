<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�����Ȳ
	
	//������ ��Ȳ - �ܱ���
	Vector vt1 = ic_db.gylist_yeardate("1");
	int vt1_size = vt1.size();
	
	//������ ��Ȳ - ������
	Vector vt2 = ic_db.gylist_yeardate("2");
	int vt2_size = vt2.size();
	
	//�μ��� ��Ȳ - ����
	Vector vt3 = ic_db.gylist_yeardate("3");
	int vt3_size = vt3.size();
	
	//�μ��� ��Ȳ - ����
	Vector vt4 = ic_db.gylist_yeardate("4");
	int vt4_size = vt4.size();
	
	int f_year 	= AddUtil.getDate2(1);	
	int l_year = AddUtil.getDate2(1)-3;
	int year_cnt = 4; //4��ġ
	
	int cnt1[] = new int[6];
	int cnt2[] = new int[6];
	int cnt3[] = new int[6];
	int cnt4[] = new int[6];
	
	int td_width = 180;		
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
<table border="0" cellspacing="0" cellpadding="0" width="<%=td_width*6%>">
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������Ȳ </span></td>
      <td align="right">�� ���ش� ���� ����, ���� ������ �ų� 12��31�� ������������ ��ȸ �Ǿ����ϴ�.</td>
    </tr>
    <tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 ></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD colspan="2" class='title'>����</TD>					          
					          <%for (int j = f_year ; j >= l_year ; j--){%>
                              <td width="<%=td_width%>" class=title><%=j%>��</td>
					          <%}%>
		        			</TR>
		        			<!-- ��������Ȳ - �ܱ��� -->
		        			<%	for(int i = 0 ; i < vt1_size ; i++){
									Hashtable ht = (Hashtable)vt1.elementAt(i);
									
									for (int j = 1 ; j <= year_cnt ; j++){
										cnt1[j] = cnt1[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
									}
							%>
					        <TR>
					          <%if(i==0){%><TD rowspan="<%=vt1_size+1%>" width="<%=td_width%>" class='title'>�ܱ���</TD><%}%>
					          <TD width="<%=td_width%>" class='title'><%=ht.get("NM")%></TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>
				            </TR>							
							<%	} %>
							<TR>					          
					          <TD class='title'>�Ұ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt1[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>	
				            <!-- ��������Ȳ - ������ -->
		        			<%	for(int i = 0 ; i < vt2_size ; i++){
									Hashtable ht = (Hashtable)vt2.elementAt(i);
									
									for (int j = 1 ; j <= year_cnt ; j++){
										cnt2[j] = cnt2[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
									}
							%>
					        <TR>
					          <%if(i==0){%><TD rowspan="<%=vt2_size+1%>" width="<%=td_width%>" class='title'>������</TD><%}%>
					          <TD width="<%=td_width%>"  class='title'><%=ht.get("NM")%></TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>
				            </TR>							
							<%	} %>
							<TR>					          
					          <TD class='title'>�Ұ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt2[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>	
				            <TR>					          
					          <TD colspan='2' class='title'>�հ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt1[j]+cnt2[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>				            	
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td colspan='2'>&nbsp;</td>
    </tr>
    <tr>
      <td colspan='2'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�μ�����Ȳ</span></td>
    </tr>
    <tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 ></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD colspan="2" class='title'>����</TD>					          
					          <%for (int j = f_year ; j >= l_year ; j--){%>
                              <td width="<%=td_width%>" class=title><%=j%>��</td>
					          <%}%>
		        			</TR>
		        			<!-- �μ�����Ȳ - ���� -->
		        			<%	for(int i = 0 ; i < vt3_size ; i++){
									Hashtable ht = (Hashtable)vt3.elementAt(i);
									
									for (int j = 1 ; j <= year_cnt ; j++){
										cnt3[j] = cnt3[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
									}
							%>
					        <TR>
					          <%if(i==0){%><TD rowspan="<%=vt3_size+1%>" width="<%=td_width%>" class='title'>����</TD><%}%>
					          <TD width="<%=td_width%>"  class='title'><%=ht.get("NM")%></TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>					          
				            </TR>							
							<%	} %>
							<TR>					          
					          <TD class='title'>�Ұ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt3[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>	
				            <!-- �μ�����Ȳ - ���� -->
		        			<%	for(int i = 0 ; i < vt4_size ; i++){
									Hashtable ht = (Hashtable)vt4.elementAt(i);
									
									for (int j = 1 ; j <= year_cnt ; j++){
										cnt4[j] = cnt4[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
									}
							%>
					        <TR>
					          <%if(i==0){%><TD rowspan="<%=vt4_size+1%>" width="<%=td_width%>" class='title'>����</TD><%}%>
					          <TD width="<%=td_width%>"  class='title'><%=ht.get("NM")%></TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center"><%=ht.get("CNT"+(j))%>&nbsp;��</TD>
					          <%}%>
				            </TR>							
							<%	} %>
							<TR>					          
					          <TD class='title'>�Ұ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt4[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>	
				            <TR>					          
					          <TD colspan='2' class='title'>�հ�</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD class='title'><%=cnt3[j]+cnt4[j]%>&nbsp;��</TD>
					          <%} %>
				            </TR>				            	
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr> 
</table>
</body>
</html>