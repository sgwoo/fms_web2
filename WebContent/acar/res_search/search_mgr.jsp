<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	
	//����࿡ ��ϵ� ������ ����Ʈ
	Vector vt = a_db.getSearchMgrList(client_id, "");
	int size = vt.size();
	
	
	//�ܱ��࿡ ��ϵ� ������ ����Ʈ
	Vector vt2 = rs_db.getSearchRentMgrList(client_id);
	int size2 = vt2.size();
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--	
	//�ܱ���
	function select(mgr_st, mgr_nm, lic_no, lic_st, tel, etc, ssn, zip, addr, mgr_st_nm){		
		var ofm = opener.document.form1;
		
		//�����
		<%if(idx.equals("4")){%>
		ofm.c_lic_no.value 	= lic_no;
		ofm.c_lic_st.value 	= lic_st;
		ofm.c_tel.value 	= tel;
		ofm.c_m_tel.value 	= etc;		
		<%}%>
		
		//��󿬶�ó
		<%if(idx.equals("2")){%>
		ofm.mgr_nm2.value 	= mgr_nm;
		ofm.m_tel2.value 	= etc;	
		ofm.m_etc2.value 	= mgr_st_nm;	
		<%}%>
		
		//�߰�������
		<%if(idx.equals("1")){%>
		ofm.m_lic_no1.value 	= lic_no;
		ofm.m_lic_st1.value 	= lic_st;
		ofm.mgr_nm1.value 	= mgr_nm;
		ofm.m_ssn1.value 	= ssn.substring(0,6);
		ofm.m_tel1.value 	= tel;			
		ofm.m_zip1.value 	= zip;	
		ofm.m_addr1.value 	= addr;	
		ofm.m_etc1.value 	= etc;	
		<%}%>
		
		self.close();			
	}
	
	//�����
	function set_mgr(mgr_st, com_nm, mgr_dept, mgr_nm, mgr_title, mgr_tel, mgr_m_tel, mgr_email, mgr_zip, mgr_addr)	
	{
		var ofm = opener.document.form1;
		
		//�����
		<%if(idx.equals("4")){%>
		ofm.c_tel.value 	= mgr_tel;
		ofm.c_m_tel.value 	= mgr_m_tel;		
		<%}%>
		
		//��󿬶�ó
		<%if(idx.equals("2")){%>
		ofm.mgr_nm2.value 	= mgr_nm;
		ofm.m_tel2.value 	= mgr_m_tel;	
		if(mgr_m_tel==''){
			ofm.m_tel2.value = mgr_tel;	
		}
		ofm.m_etc2.value 	= '[�����]'+mgr_st;	
		<%}%>
		
		//�߰�������
		<%if(idx.equals("1")){%>
		ofm.mgr_nm1.value 	= mgr_nm;
		ofm.m_tel1.value 	= mgr_m_tel;	
		if(mgr_m_tel==''){
			ofm.m_tel1.value = mgr_tel;	
		}
		ofm.m_zip1.value 	= mgr_zip;	
		ofm.m_addr1.value 	= mgr_addr;	
		<%}%>
		
		self.close();	
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > <span class=style5>�������� �˻�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <%if(size > 0){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ��������</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class='title' width='5%'> ���� </td>
		    <td width="13%" class='title'>������ȣ</td>
		    <td width="21%" class='title'>����</td>
		    <td width="14%" class='title'>�ٹ�ó</td>
		    <td width="12%" class='title'>�μ�</td>
		    <td width="10%" class='title'>����</td>
		    <td width="10%" class='title'>����</td>
		    <td width="15%" class='title'>�޴���</td>                
                  </tr>
		  <%	for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
		  <tr>
		    <td align='center'><%=i+1%></td>
		    <td align="center"><%=ht.get("CAR_NO")%></td>
		    <td align="center"><a href="javascript:set_mgr('<%=ht.get("MGR_ST")%>', '<%=ht.get("COM_NM")%>', '<%=ht.get("MGR_DEPT")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("MGR_TITLE")%>', '<%=ht.get("MGR_TEL")%>', '<%=ht.get("MGR_M_TEL")%>', '<%=ht.get("MGR_EMAIL")%>', '<%=ht.get("MGR_ZIP")%>', '<%=ht.get("MGR_ADDR")%>')"><%=ht.get("MGR_ST")%></a></td>					
		    <td align="center"><%=ht.get("COM_NM")%></td>
		    <td align="center"><%=ht.get("MGR_DEPT")%></td>
		    <td align="center"><a href="javascript:set_mgr('<%=ht.get("MGR_ST")%>', '<%=ht.get("COM_NM")%>', '<%=ht.get("MGR_DEPT")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("MGR_TITLE")%>', '<%=ht.get("MGR_TEL")%>', '<%=ht.get("MGR_M_TEL")%>', '<%=ht.get("MGR_EMAIL")%>', '<%=ht.get("MGR_ZIP")%>', '<%=ht.get("MGR_ADDR")%>')"><%=ht.get("MGR_NM")%></a></td>
		    <td align="center"><%=ht.get("MGR_TITLE")%></td>
		    <td align="center"><%=ht.get("MGR_M_TEL")%></td>
		  </tr>
                  <%	}%>
                </table>
	    </td>	    
	</tr>
    <%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>    
    <%if(size2 > 0){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ܱ��� ��������</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='5%' class='title'> ���� </td>
                    <td width="10%" class='title'>�������</td>
		    <td width="10%" class='title'>������ȣ</td>
		    <td width="10%" class='title'>����</td>
		    <td width="10%" class='title'>����</td>
		    <td width="15%" class='title'>���������ȣ</td>		    
		    <td width="10%" class='title'>��������</td>		    
		    <td width="15%" class='title'>��ȭ��ȣ</td>
		    <td width="15%" class='title'>�޴���</td>

                  </tr>
		  <%	for(int i = 0 ; i < size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);	%>
		  <tr>
		    <td align='center'><%=i+1%></td>
		    <td align="center"><%=ht.get("RENT_DT")%></td>
		    <td align="center"><%=ht.get("CAR_NO")%></td>					
		    <td align="center"><a href="javascript:select('<%=ht.get("MGR_ST")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("LIC_NO")%>', '<%=ht.get("LIC_ST")%>', '<%=ht.get("TEL")%>', '<%=ht.get("ETC")%>', '<%=ht.get("SSN")%>', '<%=ht.get("ZIP")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("MGR_ST_NM")%>')"><%=ht.get("MGR_ST_NM")%></a></td>
		    <td align="center"><a href="javascript:select('<%=ht.get("MGR_ST")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("LIC_NO")%>', '<%=ht.get("LIC_ST")%>', '<%=ht.get("TEL")%>', '<%=ht.get("ETC")%>', '<%=ht.get("SSN")%>', '<%=ht.get("ZIP")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("MGR_ST_NM")%>')"><%=ht.get("MGR_NM")%></a></td>
		    <td align="center"><%=ht.get("LIC_NO")%></td>
		    <td align="center"><%=ht.get("LIC_ST_NM")%></td>
		    <td align="center"><%=ht.get("TEL")%></td>
		    <td align="center"><%=ht.get("ETC")%></td>
		  </tr>
                  <%	}%>
                </table>
	    </td>	    
	</tr>
    <%}%>    	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
