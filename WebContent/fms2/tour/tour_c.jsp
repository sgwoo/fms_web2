<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*,  acar.tour.*" %>
<jsp:useBean id="t_db" scope="page" class="acar.tour.TourDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));

	String acar_id = login.getCookieValue(request, "acar_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");

	int count = 0;
	
	//����� ���� ��ȸ
	Vector vt = t_db.InsaCardUserList(user_id);
	int vt_size = vt.size();
	
	//�ټӳ�� ��ȸ
	Vector vt1 = t_db.getVacationAll2(user_id);
	int vt1_size = vt1.size();
	
	// ���󳻿�
	Vector vt_p = t_db.tour_view(user_id);
	int vt_p_size = vt_p.size();


%>
<HTML>
<HEAD>
<META NAME="Generator" CONTENT="Haansoft HWP 7.0.4.325">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<TITLE>���ī��</TITLE>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function input_ps(user_id,auth_rw)
{
	
	var SUBWIN="tour_i.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "input_ps", "left=100, top=100, width=800, height=200, scrollbars=yes");
}

function del(id, num)
{
	var fm = document.form1;
	fm.cmd.value = "d";
	
	fm.user_id.value = id;
	fm.seq.value = num;
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
		fm.action='tour_a.jsp';
		fm.target='i_no';
		fm.submit();
		}
}


//-->
</script>
</HEAD>

<BODY>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="seq" value="">
<input type="hidden" name="cmd" value="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ��԰��� > <span class=style5> ���ټ����� �󼼺���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
        <td class=h align="right">     
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" border="0" align="absmiddle"></a>        	
        	</td>
    </tr>

<%// if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "USERS";
	String content_seq  = (String)ht.get("USER_ID");

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
%> 
    
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr>		
					<TD rowspan="3" colspan="4" width="16%" height="300" align="center">
						<%if(attach_vt_size > 0){%>
							<%	for (int j = 0 ; j < attach_vt_size ; j++){
									Hashtable ht2 = (Hashtable)attach_vt.elementAt(j);
									if(String.valueOf(ht2.get("CONTENT_SEQ")).equals(content_seq+"2")){
							%>
									<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht2.get("SAVE_FOLDER")%><%=ht2.get("SAVE_FILE")%>" border="0" width="85" height="105">    														
								<%	}%>		
							<%	}%>		
						<%}%>
						<p><b><%=ht.get("USER_NM")%></b>
					</TD>		
					<TD width="14%" height="100" class=title>�����ȣ</TD>		
					<TD width="14%" height="100" align="center"><%=ht.get("ID")%></TD>		
					<TD width="14%" height="100" class=title>�Ի�����</TD>		
					<TD width="14%" height="100" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></TD>		
					<TD width="14%" height="100" class=title>�������</TD>		
					<TD width="14%" height="100" align="center"><%=ht.get("OUT_DT")%></TD>	
				</TR>	
				<TR>		
					<TD width="14%" height="100" class=title>�ٹ��μ�</TD>		
					<TD width="14%" height="100" align="center"><%=ht.get("DEPT_NM")%></TD>		
					<TD width="14%" height="100" class=title>��å</TD>		
					<TD width="14%" height="100" align="center"></TD>		
					<TD width="14%" height="100" class=title>����</TD>		
					<TD width="14%" height="100"  align="center"><%=ht.get("USER_POS")%></TD>	
				</TR>	
				<TR>		
					<TD width="14%" height="100" class=title>�ټӳ��<br>(��������)</TD>		
					<TD width="14%" height="100" align="center">
						<% for(int j = 0 ; j < vt1_size ; j++){
							Hashtable ht1 = (Hashtable)vt1.elementAt(j);
						%><%=ht1.get("YEAR")%>��&nbsp; <%=ht1.get("MONTH")%>����&nbsp;<%=ht1.get("DAY")%>��<br>
						<%}%>&nbsp;&nbsp;&nbsp;&nbsp;<b>  �� <%=ht.get("W_DAY")%>��</b>	</TD>		
					<TD width="14%" height="100" class=title>��ǥ��ȭ<br>(����)</TD>		
					<TD width="14%" height="100" align="center">			<% if(ht.get("DEPT_ID").equals("0001")){%>			02)757-0802			<%}else if (ht.get("DEPT_ID").equals("0002")){%>			02) 392-4242			<%}else if (ht.get("DEPT_ID").equals("0003")){%>			02) 392-4243			<%}else if (ht.get("DEPT_ID").equals("0004")){%>						<%}else if (ht.get("DEPT_ID").equals("0007")){%>			051) 851-0808			<%}else if (ht.get("DEPT_ID").equals("0008")){%>			042) 824-1770			<%}%>			<br>( <%=ht.get("IN_TEL")%> )</TD>		
					<TD width="14%" height="100" class=title>������ȭ</TD>		
					<TD width="14%" height="100" align="center"><%=ht.get("HOT_TEL")%></TD>	
				</TR>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>
<% if ( ck_acar_id.equals("000063") ) {%>
        <a href="javascript:input_ps('<%=ht.get("USER_ID")%>',<%=auth_rw%>)"><img src=/acar/images/center/button_reg_jg.gif border=0 align=absmiddle></a>
     
 <% } %>       
        </td>
    </tr>
  
<%}%>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width="100%">
				<TR>
					<TD class=title rowSpan="2" colSpan="2" width="12%">����</TD>
					<TD class=title rowSpan="2" width="20%">��������</TD>
					<TD class=title colSpan="2" width="20%">���󳻿�</TD>
					<TD class=title colSpan="3" width="68%">�ް�����</TD>
				</TR>
				<TR>
					<TD class=title width="10%">�ް��Ⱓ</TD>
					<TD class=title width="10%">����ݾ�</TD>
					<TD class=title width="20%">������</TD>
					<TD class=title width="20%">������</TD>
					<TD class=title width="20%">�����հ�</TD>
				</TR>
<% if(vt_p_size > 0)	{
				for(int g = 0 ; g < vt_p_size ; g++){
					Hashtable ht2 = (Hashtable)vt_p.elementAt(g);
			%>
				<TR>
					<TD class=title rowSpan="2" width="7%">�Ի�<br><%=String.valueOf(ht2.get("PS_COUNT"))%>����</TD>
					<TD class=title width="5%">���� <% if  (  nm_db.getWorkAuthUser("������",acar_id) ) {%><a href="javascript:del('<%=user_id%>', '<%=String.valueOf(ht2.get("SEQ"))%>' )">[����]</a>
				
					<%}%> </TD>
					<TD align="center" rowSpan="2"><%=String.valueOf(ht2.get("PS_DT"))%></TD>
					<TD align="center">5��</TD>
					<TD align="right"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("PS_AMT")))%></TD>
					<TD align="center"></TD>
					<TD align="center"></TD>
					<TD align="center"></TD>
				</TR>
				<TR>
					<TD class=title width="5%">�ǽ�</TD>
					<TD align="center">5��</TD>
					<TD align="right"><%=AddUtil.parseDecimal(String.valueOf(ht2.get("PS_AMT")))%></TD>	
					<TD align="center"><%=String.valueOf(ht2.get("PS_STR_DT"))%></TD>
					<TD align="center"><%=String.valueOf(ht2.get("PS_END_DT"))%></TD>
					<TD align="center"></TD>
					
				</TR>
				<%}
				}%>

			</TABLE>
		</td>
	</tr>
</table>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>

</HTML>

