<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	

	String acar_id = login.getCookieValue(request, "acar_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String user_aut2 = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String out_dt = "";
	String taste = "";
	String special ="";
	String gundea = "";
	String bank_nm = "";
	String bank_no = "";
	
	String zip = "";
	String addr="";
	int count = 0;
		

	//����� ���� ��ȸ
	Vector vt = ic_db.InsaCardUserList(user_id);
	int vt_size = vt.size();
	
	//�ټӳ�� ��ȸ
	Vector vt1 = ic_db.getVacationAll2(user_id);
	int vt1_size = vt1.size();
	
	//�з���ȸ
	Vector vt2 = ic_db.Insa_sc(user_id);
	int vt2_size = vt2.size();
	
	//�λ�߷���ȸ
	Vector vt3 = ic_db.Insa_ib(user_id);
	int vt3_size = vt3.size();
	
	//�����ȸ
	Vector vt4 = ic_db.Insa_sb(user_id);
	int vt4_size = vt4.size();

	//������ȸ
	Vector vt5 = ic_db.Insa_fy(user_id);
	int vt5_size = vt5.size();
	
	//�ſ�������ȸ
	Vector vt6 = ic_db.Insa_sw(user_id);
	int vt6_size = vt6.size();
	
	//���������ȸ
	Vector vt7 = ic_db.Insa_wk(user_id);
	int vt7_size = vt7.size();
	
	//�ڰ�/������ȸ
	Vector vt8 = ic_db.Insa_ls(user_id);
	int vt8_size = vt8.size();
	
	//����
	Vector vt9 = ic_db.Insa_Jg(user_id);
	int vt9_size = vt9.size();
%>
<HTML>
<HEAD>
<META NAME="Generator" CONTENT="Haansoft HWP 7.0.4.325">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<TITLE>���ī��</TITLE>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function school(user_id,auth_rw)
{
	
	var SUBWIN="school.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "school", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_ib(user_id,auth_rw)
{
	
	var SUBWIN="insa_ib.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_ib", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_jg(user_id,auth_rw)
{
	
	var SUBWIN="insa_jg.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_jg", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_sb(user_id,auth_rw)
{
	
	var SUBWIN="insa_sb.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_sb", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_fy(user_id,auth_rw)
{
	
	var SUBWIN="insa_fy.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_fy", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_sw(user_id,auth_rw)
{
	
	var SUBWIN="insa_sw.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_sw", "left=100, top=100, width=800, height=350, scrollbars=yes");
}
function insa_wk(user_id,auth_rw)
{
	
	var SUBWIN="insa_wk.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_wk", "left=100, top=100, width=800, height=200, scrollbars=yes");
}
function insa_ls(user_id,auth_rw)
{
	
	var SUBWIN="insa_ls.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "insa_ls", "left=100, top=100, width=800, height=200, scrollbars=yes");
}

	
//����Ʈ ����	
function go_to_list()
{
	var fm = document.form1;
	
	fm.target = 'd_content';
	fm.action ="insa_card_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
	fm.submit();    
			
}

function del_data(user_id, seq, st){
	var fm = document.form1;

	if(!confirm('�����Ͻðڽ��ϱ�?'))
		return;		
	fm.cmd.value='del';
	fm.action = "insa_card_null.jsp?user_id="+user_id+"&seq="+seq+"&st="+st;	
	fm.target='i_no';
	fm.submit();		
}
	
//��ĵ���
function scan_reg(content_code, content_seq, file_st_nm){
	window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&content_code="+content_code+"&content_seq="+content_seq+"&file_st_nm="+file_st_nm, "SCAN", "left=10, top=10, width=720, height=200, scrollbars=yes, status=yes, resizable=yes");
}

//��ĵ����
function scan_del(seq){
	window.open("https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq, "SCAN", "left=10, top=10, width=570, height=280, scrollbars=yes, status=yes, resizable=yes");
}
	
//-->
</script>
</HEAD>

<BODY>
<form action="./insa_card_null.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">  
<input type="hidden" name="cmd" value="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > �������� > <span class=style5> �λ���ī��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>            
    </tr>
    
       <tr> 
      <td align="right"> 
      <a href="javascript:go_to_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
      </tr>
      
<%// if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%> 
    
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
		       	<tr>
					<TD rowspan="3" colspan="4" width="16%" height="300" align="center"><img src="https://fms3.amazoncar.co.kr/images/charge/<%=ht.get("FILENAME")%>.gif" width="85" height="105"></TD>
					<TD width="14%" height="100" class=title>�����ȣ</TD>
					<TD width="14%" height="100" align="center"><%=ht.get("SA_CODE")%></TD>
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
%>
						<%=ht1.get("YEAR")%>��&nbsp; <%=ht1.get("MONTH")%>����&nbsp;<%=ht1.get("DAY")%>��<br>
						<%}%>&nbsp;&nbsp;&nbsp;&nbsp;<b>  �� <%=ht.get("W_DAY")%>��</b>
					</TD>
					<TD width="14%" height="100" class=title>��ǥ��ȭ<br>(����)</TD>
					<TD width="14%" height="100" align="center">
						<% if(ht.get("DEPT_ID").equals("0001")){%>
						02)757-0802
						<%}else if (ht.get("DEPT_ID").equals("0002")){%>
						02)392-4242
						<%}else if (ht.get("DEPT_ID").equals("0003")){%>
						02)392-4243
						<%}else if (ht.get("DEPT_ID").equals("0004")){%>
						
						<%}else if (ht.get("DEPT_ID").equals("0007")){%>
						051)851-0606
						<%}else if (ht.get("DEPT_ID").equals("0008")){%>
						042)824-1770
						<%}else if (ht.get("DEPT_ID").equals("0009")){%>
						02)537-5877
						<%}else if (ht.get("DEPT_ID").equals("0010")){%>
						062)385-0133
						<%}else if (ht.get("DEPT_ID").equals("0011")){%>
						053)582-2998
						<%}%>
						<br>( <%=ht.get("IN_TEL")%> )</TD>
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
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="15%" height="25" class=title>����</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("USER_NM")%></TD>
					<TD width="15%" height="25" class=title>����</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("JUMIN")%></TD>
					<TD width="15%" height="25" class=title>�ֹε�Ϲ�ȣ</TD>
					<TD width="25%" height="25" align="center"><%=ht.get("SSN1")%>-******</TD>
				</TR>
				<TR>
					<TD width="15%" height="25" class=title>�ֹε���ּ�</TD>
					<TD colspan="5" width="85%" height="25"  >&nbsp;&nbsp;��:<%=ht.get("HOME_ZIP")%>&nbsp;&nbsp;<%=ht.get("HOME_ADDR")%></TD>
				</TR>
				<TR>
					<TD width="15%" height="25" class=title>�ǰ������ּ�</TD>
					<TD colspan="5" width="85%" height="25"  >&nbsp;&nbsp;��:<%=ht.get("ZIP")%>&nbsp;&nbsp;<%=ht.get("ADDR")%></TD>
				</TR>
				<TR>
					<TD width="15%" height="25" class=title>������ȭ</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("USER_H_TEL")%></TD>
					<TD width="15%" height="25" class=title>�ڵ���</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("USER_M_TEL")%></TD>
					<TD width="15%" height="25" class=title>E_MAIL</TD>
					<TD width="25%" height="25" align="center"><%=ht.get("USER_EMAIL")%></TD>
				</TR>
				<TR>
					<TD width="15%" height="25" class=title>���ʿ���</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("GUNDEA")%></TD>
					<TD width="15%" height="25" class=title>���</TD>
					<TD width="15%" height="25" align="center"><%=ht.get("TASTE")%></TD>
					<TD width="15%" height="25" class=title>Ư��</TD>
					<TD width="25%" height="25" align="center"><%=ht.get("SPECIAL")%></TD>
				</TR>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><b><<a href="javascript:school('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">�з�</a>></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="15%" height="74" class=title>����</TD>
					<TD width="15%" height="74" class=title>�����</TD>
					<TD width="30%" height="74" class=title>�б���</TD>
					<TD width="20%" height="74" class=title>����</TD>
					<TD width="10%" height="74" class=title>����</TD>
					<TD width="10%" height="74" class=title>����</TD>
				</TR>
<% if(vt2_size > 0)	{
	for(int g = 0 ; g < vt2_size ; g++){
			Hashtable ht2 = (Hashtable)vt2.elementAt(g);
%>									
				<TR>
					<TD width="15%" height="25" align='center'><%=ht2.get("SC_GUBUN")%></TD>
					<TD width="15%" height="25" align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("SC_ED_DT")))%></TD>
					<TD width="30%" height="25" align='center'><%=ht2.get("SC_NAME")%></TD>
					<TD width="20%" height="25" align='center'><%=ht2.get("SC_STUDY")%></TD>
					<TD width="10%" height="25" align='center'><%=ht2.get("SC_ST")%></TD>
					<TD width="10%" height="25" align='center'><a href="javascript:del_data('<%=ht2.get("USER_ID")%>','<%=ht2.get("SEQ")%>','school')"><img src="http://fms1.amazoncar.co.kr/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></TD>
				</TR>
<%}}%>				
				
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
		<td colspan="3">
	<%	if(nm_db.getWorkAuthUser("������",acar_id) || nm_db.getWorkAuthUser("�λ���",acar_id) ){%>			
			<b><<a href="javascript:insa_ib('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">�λ�߷�</a>></b>
	<%}else{%>
			<b><�λ�߷�></b>
	<%}%>
		</td>
	</tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="5%" height="25" class=title>����</TD>
					<TD width="15%" height="25" class=title>�����</TD>
					<TD width="25%" height="25" class=title>����</TD>
					<TD width="20%" height="25" class=title>����</TD>
					<TD width="35%" height="25" class=title>����</TD>
				</TR>
<% if(vt3_size > 0)	{
	for(int a = 0 ; a < vt3_size ; a++){
			Hashtable ht3 = (Hashtable)vt3.elementAt(a);
%>							
				<TR>
					<TD width="5%" height="25" align="center"><%=a+1%></TD>
					<TD width="15%" height="25" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht3.get("IB_DT")))%></TD>
					<TD width="25%" height="25" align="center"><%=ht3.get("IB_GUBUN")%></TD>
					<TD width="20%" height="25" align="center"><%=ht3.get("IB_TYPE")%> - <% if (String.valueOf(ht3.get("IB_TYPE")).equals("2") ) {%><%=c_db.getNameById(String.valueOf(ht3.get("IB_DEPT")), "DEPT")%><% } else { %><%=ht3.get("IB_JOB")%><% } %></TD>
					<TD width="35%" height="25" align="center"><%=ht3.get("IB_CONTENT")%></TD>
				</TR>
<%}}%>
			</table>
		</td>
	</TR>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="3">
	<%	if(nm_db.getWorkAuthUser("������",acar_id) || nm_db.getWorkAuthUser("�λ���",acar_id) ){%>			
			<b><<a href="javascript:insa_jg('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">����</a>></b>
	<%}else{%>
			<b><����></b>
	<%}%>
		</td>
	</tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="10%" height="25" class=title>����</TD>
					<TD width="10%" height="25" class=title>����</TD>
					<TD width="15%" height="25" class=title>��������</TD>
					<TD width="15%" height="25" class=title>�߷�����</TD>
					<TD width="50%" height="25" class=title>����</TD>
				</TR>
<% if(vt9_size > 0)	{
	for(int z = 0 ; z < vt9_size ; z++){
			Hashtable ht9 = (Hashtable)vt9.elementAt(z);
%>							
				<TR>
					<TD width="10%" height="25" align="center"><%=z+1%></TD>
					<TD width="10%" height="25" align="center"><%=ht9.get("POS")%></TD>					
					<TD width="15%" height="25" align="center"><%=ht9.get("JG_DT")%></TD>
					<TD width="15%" height="25" align="center"><%=ht9.get("BR_DT")%></TD>
					<TD width="50%" height="25" align="center"><%=ht9.get("NOTE")%></TD>
				</TR>
<%}}%>
			</table>
		</td>
	</TR>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="3">
<%if(nm_db.getWorkAuthUser("������",acar_id) || nm_db.getWorkAuthUser("�λ���",acar_id) ){%>
			<b><<a href="javascript:insa_sb('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">���</a>></b>
<%}else{%>
			<b><���></b>
<%}%>
			</td>
	</tr>
    <TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="5%" height="25" rowspan="2" class=title>����</TD>
					<TD width="15%" height="25" rowspan="2"   class=title>�����</TD>
					<TD width="20%" height="25" rowspan="2"   class=title>����</TD>
					<TD width="30%" height="25" rowspan="2"   class=title>����</TD>
					<TD height="12" colspan="2"   class=title>����Ⱓ</td>
				</TR>
				<TR>
				  <TD width="15%" height="12"   class=title>������</TD>
			      <TD width="15%" height="12"   class=title>������</TD>
			  </TR>
<% if(vt4_size > 0)	{
	for(int b = 0 ; b < vt4_size ; b++){
			Hashtable ht4 = (Hashtable)vt4.elementAt(b);
%>							
				<TR>
					<TD width="5%" height="25" align="center"><%=b+1%></TD>
					<TD width="15%" height="25" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht4.get("SB_DT")))%></TD>
					<TD width="20%" height="25" align="center"><%=ht4.get("SB_GUBUN")%></TD>
					<TD width="30%" height="25" align="center"><%=ht4.get("SB_CONTENT")%></TD>
					<TD width="15%" height="25" align="center"><%=ht4.get("SB_JS_DT")%></TD>
					<TD width="15%" height="25" align="center"><%=ht4.get("SB_JE_DT")%></TD>
				</TR>
<%}}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
     <tr> 
        <td><b><<a href="javascript:insa_fy('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">��������</a>></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>					
				<TR>
					<TD width="70" height="28" class=title>����</TD>
					<TD colspan="9" width="135" height="28" class=title>����	</TD>
					<TD colspan="13" width="218" height="28" class=title>�������</TD>
					<TD colspan="10" width="250" height="28" class=title>����(��)</TD>
					<TD colspan="2" width="50" height="28" class=title>����</TD>
				</TR>
<% if(vt5_size > 0)	{
	for(int c = 0 ; c < vt5_size ; c++){
			Hashtable ht5 = (Hashtable)vt5.elementAt(c);
%>					
				<TR>
					<TD width="70" height="28" align="center"><%=ht5.get("FY_GUBUN")%></TD>
					<TD colspan="9" width="135" height="28" align="center"><%=ht5.get("FY_NAME")%></TD>
					<TD colspan="13" width="218" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht5.get("FY_BIRTH")))%></TD>
					<TD colspan="10" width="250" height="28" align="center"><%=ht5.get("FY_AGE")%>&nbsp;��</TD>
					<TD colspan="2" width="50" height="28" align="center"><a href="javascript:del_data('<%=ht5.get("USER_ID")%>','<%=ht5.get("SEQ")%>','fy')"><img src="http://fms1.amazoncar.co.kr/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></TD>
				</TR>
<%}}%>				
			</table>
		</td>
	</tr>
	    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>
<%if(nm_db.getWorkAuthUser("������",acar_id) || nm_db.getWorkAuthUser("�λ���",acar_id) ){%>
        	<b><<a href="javascript:insa_sw('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">�ſ�����</a>></b>
<%}else{%>
			<b><�ſ�����></b>
<%}%>
        	</td>
    </tr>
    <tr> 
        <td><b>&nbsp;&nbsp;&nbsp;1) �κ���</b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="10%" height="28" class=title>����</TD>
					<TD width="13%" height="28" class=title>�ֹι�ȣ</TD>
					<TD width="20%" height="28" class=title>�ּ�</TD>
					<TD width="12%" height="28" class=title>����ó</TD>
					<TD width="5%" height="28" class=title>����</TD>
					<TD width="10%" height="28" class=title>������</TD>
					<TD width="10%" height="28" class=title>������</TD>
					<TD width="10%" height="28" class=title>���ſ�����</TD>
					<TD width="5%" height="28" class=title>�ڻ�</TD>
					<TD width="5%" height="28" class=title>��ĵ</TD>
				</TR>
<% if(vt6_size > 0)	{
	for(int d = 0 ; d < vt6_size ; d++){
			Hashtable ht6 = (Hashtable)vt6.elementAt(d);
			if(ht6.get("SW_GUBUN").equals("1")){
%>					
				<TR>
					<TD width="10%" height="28" align="center"><%=ht6.get("SW_NAME")%></TD>
					<TD width="13%" height="28" align="center"><%=ht6.get("SW_SSN")%></TD>
					<TD width="20%" height="28" align="center"><%=ht6.get("SW_ADDR")%></TD>
					<TD width="12%" height="28" align="center"><%=ht6.get("SW_TEL")%></TD>
					<TD width="5%" height="28" align="center"><%=ht6.get("SW_MY_GUBUN")%></TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht6.get("SW_ED_DT")))%></TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht6.get("SW_ED_DT")))%></TD>
					<TD width="5%" height="28" align="center"><%=ht6.get("SW_JESAN")%></TD>
					<TD width="5%" height="28" align="center"><a href="http://211.52.73.84/data/insa_card/<%=ht6.get("SW_FILE")%>" target="_blank"><img src="/acar/images/center/button_in_see.gif" border="0" align="absmiddle"></a></TD>
					
				</TR>
<%}}}%>
			</table>
		</td>
	</tr>
	<TR>
		<td class=h></td>
	</TR>
	<TR>
		<td><b>&nbsp;&nbsp;&nbsp;2) ��������</b></td>
	</TR>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD colspan="4" width="20%" height="28" class=title>������</TD>
					<TD colspan="4" width="20%" height="28" class=title>���ǹ�ȣ</TD>
					<TD colspan="4" width="20%" height="28" class=title>����ݾ�</TD>
					<TD width="10%" height="28" class=title>������</TD>
					<TD width="10%" height="28" class=title>������</TD>
					<TD width="10%" height="28" class=title>���ſ�����</TD>
				</TR>
<%	if(vt6_size > 0)	{
		for(int d = 0 ; d < vt6_size ; d++){
			Hashtable ht6 = (Hashtable)vt6.elementAt(d);
			if(ht6.get("SW_GUBUN").equals("2")){
%>									
				<TR>
					<TD colspan="4" width="336" height="28" align="center"><%=ht6.get("SW_INSU_NM")%></TD>
					<TD colspan="4" width="336" height="28" align="center"><%=ht6.get("SW_INSU_NO")%></TD>
					<TD colspan="4" width="337" height="28" align="center"><%=AddUtil.parseDecimal(String.valueOf(ht6.get("SW_INSU_MONEY")))%>&nbsp;����</TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht6.get("SW_ED_DT")))%></TD>
					<TD width="10%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht6.get("SW_ED_DT")))%></TD>
				</TR>
<%}}}%>
			</table>
		</td>
	</tr>
	    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><b><<a href="javascript:insa_wk('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">�������</a>></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>				
				<TR>
					<TD width="5%" height="28" class=title>����</TD>
					<TD width="15%" height="28" class=title>��ȣ/��ü��</TD>
					<TD width="7%" height="28" class=title>����</TD>
					<TD width="10%" height="28" class=title>�ٹ��μ�</TD>
					<TD width="35%" height="28" class=title>�ٹ��Ⱓ</TD>
					<TD width="20%" height="28" class=title>������</TD>
					<TD width="10%" height="28" class=title>�������</TD>
				</TR>
<% if(vt7_size > 0)	{
	for(int e = 0 ; e < vt7_size ; e++){
			Hashtable ht7 = (Hashtable)vt7.elementAt(e);
%>													
				<TR>
					<TD width="5%" height="28" align="center"><%=e+1%></TD>
					<TD width="15%" height="28" align="center"><%=ht7.get("WK_TITLE")%></TD>
					<TD width="7%" height="28" align="center"><%=ht7.get("WK_POS")%></TD>
					<TD width="10%" height="28" align="center"><%=ht7.get("WK_NAME")%></TD>
					<TD width="35%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht7.get("WK_ST_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht7.get("WK_ED_DT")))%> - (<%=ht7.get("YEAR")%>�� <%=ht7.get("MONTH")%>���� �ٹ�)</TD>
					<TD width="20%" height="28" align="center"><%=Util.subData(String.valueOf(ht7.get("WK_WORK")),12)%></TD>
					<TD width="10%" height="28" align="center"><%=ht7.get("WK_EMP")%></TD>
				</TR>
<%}}%>				
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><b><<a href="javascript:insa_ls('<%=ht.get("USER_ID")%>','<%=auth_rw%>')">�ڰ�/����</a>></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="5%" height="28"   class=title>����</TD>
					<TD width="25%" height="28"   class=title>�����</TD>
					<TD width="25%" height="28"   class=title>�����ȣ</TD>
					<TD width="25%" height="28"   class=title>�����</TD>
					<TD width="20%" height="28"   class=title>������	</TD>
				</TR>
<% if(vt8_size > 0)	{
	for(int f = 0 ; f < vt8_size ; f++){
			Hashtable ht8 = (Hashtable)vt8.elementAt(f);
%>									
				<TR>
					<TD width="5%" height="28" align="center"><%=f+1%></TD>
					<TD width="25%" height="28" align="center"><%=ht8.get("LS_NAME")%></TD>
					<TD width="25%" height="28" align="center"><%=ht8.get("LS_NUM")%></TD>
					<TD width="25%" height="28" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht8.get("LS_DT")))%></TD>
					<TD width="20%" height="28" align="center"><%=ht8.get("LS_BMNG")%></TD>
				</TR>
<%}}%>				
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><b><�޿�����></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<TR>
					<TD width="20%" height="28"   class=title>�����</TD>
					<TD width="40%" height="28"   class=title>���¹�ȣ</TD>
					<TD width="40%" height="28"   class=title>������</TD>
				</TR>
				<TR>
					<TD width="20%" height="28" align="center"><%=ht.get("BANK_NM")%></TD>
					<TD width="40%" height="28" align="center"><%=ht.get("BANK_NO")%></TD>
					<TD width="40%" height="28" align="center"><%=ht.get("BANK_USER")%></TD>
				
				</TR>
			</table>
		</td>
	</tr>
	 <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><b><���ü���></b></td>
    </tr>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<!-- �λ�ī����� ��ĵ(20180611) -->
				<tr>
				<%	String file_nm[] = new String[6];
					file_nm[0] = "�ٷΰ�༭";
					file_nm[1] = "�̷¼�";
					file_nm[2] = "����/��������";
					file_nm[3] = "�ſ�������";
					file_nm[4] = "�ֹε�ϵ";
					file_nm[5] = "����纻";
					
					for(int l=1; l<7; l++){
				%>
					<td width="16%" height="28" class=title colspan="2"><%=file_nm[l-1]%></td>
				<%	} %>	
				</tr>
				<tr>
				<%for(int m=1; m<7; m++){ 
					Vector scanList = c_db.getAcarAttachFileList("INSA_SCAN","user_id"+ht.get("USER_ID")+"-00"+m,-1);
					int scanListSize = scanList.size();%>
				<%	if(scanListSize > 0){ 
					Hashtable ht10 = (Hashtable)scanList.elementAt(i);	%>
					<td align="center" width="13%">
						<a href="javascript:openPopP('<%=ht10.get("FILE_TYPE")%>','<%=ht10.get("SEQ")%>');" title='����' ><%=ht10.get("FILE_NAME")%></a>
					</td>	
					<td align="center" width="3%">
						<a href="javascript:scan_del('<%=ht10.get("SEQ")%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					</td>
				<%	}else{%>
					<td align="center" colspan="2">
						<a href="javascript:scan_reg('INSA_SCAN','user_id<%=ht.get("USER_ID")%>-00<%=m%>','<%=file_nm[m-1]%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					</td>	
				<%	}%>	
				<%}%>
				</tr>
			</table>
		</td>
	</tr>
<%}//}%>
	

</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>

</HTML>

