<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	
	
	//장기계약에 등록된 관계자 리스트
	Vector vt = a_db.getSearchCmsList(client_id);
	int size = vt.size();
	
	
	//단기계약에 등록된 관계자 리스트
	Vector vt2 = rs_db.getSearchRentFeeCmsList(client_id);
	int size2 = vt2.size();
		
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(cms_acc_no, cms_bank, cms_dep_nm){		
	
		var ofm = opener.document.form1;
		
		ofm.cms_bank.value 	= cms_bank;
		ofm.cms_acc_no.value 	= cms_acc_no;
		ofm.cms_dep_nm.value 	= cms_dep_nm;
		
		self.close();			
	}
	
	function set_cms(cms_acc_no, cms_bank, cms_dep_nm, cms_day, cms_dep_ssn, cms_dep_post, cms_dep_addr, cms_tel, cms_m_tel, cms_email)	
	{
		var ofm = opener.document.form1;
		
		ofm.cms_bank.value 	= cms_bank;
		ofm.cms_acc_no.value 	= cms_acc_no;
		ofm.cms_dep_nm.value 	= cms_dep_nm;
				
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5>자동이체 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(size > 0){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기계약 자동이체</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='5%' class='title'>연번</td>
                    <td width="15%" class='title'>계약번호</td>
                    <td width="10%" class='title'>계약일자</td>
                    <td width="10%" class='title'>은행명</td>
                    <td width="15%" class='title'>계좌번호</td>
                    <td width="15%" class='title'>예금주</td>
                    <td width="10%" class='title'>결제일자</td>
                    <td width="10%" class='title'>시작일</td>
                    <td width="10%" class='title'>종료일</td>          
                  </tr>
		  <%	for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
		  <tr>
		    <td align='center'><%=i+1%></td>
		    <td align="center"><%=ht.get("RENT_L_CD")%></td>
		    <td align="center"><%=ht.get("RENT_DT")%></td>					
		    <td align="center"><%=ht.get("CMS_BANK")%></td>
		    <td align="center"><a href="javascript:set_cms('<%=ht.get("CMS_ACC_NO")%>', '<%=ht.get("CMS_BANK")%>', '<%=ht.get("CMS_DEP_NM")%>', '<%=ht.get("CMS_DAY")%>', '<%=ht.get("CMS_DEP_SSN")%>', '<%=ht.get("CMS_DEP_POST")%>', '<%=ht.get("CMS_DEP_ADDR")%>', '<%=ht.get("CMS_TEL")%>', '<%=ht.get("CMS_M_TEL")%>', '<%=ht.get("CMS_EMAIL")%>')"><%=ht.get("CMS_ACC_NO")%></a></td>
		    <td align="center"><%=ht.get("CMS_DEP_NM")%></a></td>
		    <td align="center"><%=ht.get("CMS_DAY")%></td>
		    <td align="center"><%=ht.get("CMS_START_DT")%></td>
		    <td align="center"><%=ht.get("CMS_END_DT")%></td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>단기계약 자동이체</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='5%' class='title'> 연번 </td>
                    <td width="10%" class='title'>계약일자</td>
		    <td width="10%" class='title'>차량번호</td>
		    <td width="20%" class='title'>은행명</td>
                    <td width="25%" class='title'>계좌번호</td>
                    <td width="30%" class='title'>예금주</td>

                  </tr>
		  <%	for(int i = 0 ; i < size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);	%>
		  <tr>
		    <td align='center'><%=i+1%></td>
		    <td align="center"><%=ht.get("RENT_DT")%></td>
		    <td align="center"><%=ht.get("CAR_NO")%></td>					
		    <td align="center"><a href="javascript:select('<%=ht.get("CMS_ACC_NO")%>', '<%=ht.get("CMS_BANK")%>', '<%=ht.get("CMS_DEP_NM")%>')"><%=ht.get("CMS_BANK")%></a></td>
		    <td align="center"><a href="javascript:select('<%=ht.get("CMS_ACC_NO")%>', '<%=ht.get("CMS_BANK")%>', '<%=ht.get("CMS_DEP_NM")%>')"><%=ht.get("CMS_ACC_NO")%></a></td>
		    <td align="center"><%=ht.get("CMS_DEP_NM")%></td>
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
