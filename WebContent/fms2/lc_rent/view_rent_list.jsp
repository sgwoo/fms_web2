<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//������� ����
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
	//�ڵ���������� ����
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=800, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd)
	{		
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");				
	}	
//-->
</script>
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	Vector conts = l_db.getContList(client_id);
	int cont_size = conts.size();
	int valid_cont_cnt = 0;
%>
<form name='form2' method='post'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='c_st' value=''>  
 </form> 
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>���� �ŷ�ó ��ฮ��Ʈ</span></span> : ���� �ŷ�ó ��ฮ��Ʈ</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
            				<tr>
            				    <td width='3%' class=title>����</td>
            				    <td width='10%' class=title>����ȣ</td>
            				    <td width='7%' class=title>�����</td>
            				    <td width='8%' class=title>������ȣ</td>
            				    <td width='10%' class=title>����</td>
            				    <td width='10%' class=title>���Ⱓ</td>
            				    <td width='6%' class=title>�뿩���</td>
            				    <td width='6%' class=title>���ʿ���</td>
            				    <td width='6%' class=title>�������</td>
            				    <td width='6%' class=title>�������</td>
            				    <td width='6%' class=title>�뿩����</td>
            				    <td width='9%' class=title>��ȣ/����</td>
            				    <td width='8%' class=title>����/����</td>
            				    <td width='5%' class=title>��ĵ</td>
            				</tr>
			
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);
%>
				<tr>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='10%'><%=cont.get("RENT_L_CD")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='7%'><a href="javascript:view_client('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title='����ĳ���'><%=cont.get("RENT_DT")%></a></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='8%'><a href="javascript:view_car('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'><%=cont.get("CAR_NO")%></a></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='10%'><%=cont.get("CAR_NM")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='10%'><%=cont.get("RENT_START_DT")%>~<%=cont.get("RENT_END_DT")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='6%'><%=cont.get("RENT_WAY")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM2")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM3")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='6%'><%=cont.get("IS_RUN")%></td>		
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='9%'><%=cont.get("FIRM_NM")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='8%'><%=cont.get("R_SITE")%>&nbsp;<%=cont.get("R_SITE_SEQ")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("�ؾ�")){%>class=is<%}%> align='center' width='5%'><a href="javascript:view_scan('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ĵ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>									
				</tr>
<%
			if((String.valueOf(cont.get("IS_RUN_NUM")).equals("0"))||(String.valueOf(cont.get("IS_RUN_NUM")).equals("1")))
				valid_cont_cnt += 1;
		}
%>
<%
	}else{
%>				<tr>
					<td>&nbsp;��ϵ� ����� �����ϴ�</td>
				</tr>
<%	}
%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
